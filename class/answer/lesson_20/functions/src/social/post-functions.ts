import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { NotificationService } from '../notifications/notification-service';
import { NotificationType, PostData, UserData, ModerationResult } from '../types';
import { validatePostContent, moderateContent, extractHashtags, extractMentions } from '../utils/validation';

/**
 * Post creation trigger - processes new posts and sends notifications
 */
export const onPostCreate = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const postData = snapshot.data() as PostData;
    const authorId = postData.authorId;
    
    try {
      console.log(`Processing new post ${postId} by user ${authorId}`);
      
      // Process post content
      await processPostContent(postId, postData);
      
      // Update user post count
      await updateUserPostCount(authorId, 1);
      
      // Get author information for notifications
      const authorData = await getUserData(authorId);
      if (!authorData) {
        console.error(`Author data not found for user ${authorId}`);
        return;
      }
      
      // Notify followers of new post
      await notifyFollowersOfNewPost(authorId, postId, postData, authorData);
      
      // Process hashtags and mentions
      await processHashtagsAndMentions(postId, postData);
      
      console.log(`Post ${postId} processed successfully`);
    } catch (error) {
      console.error(`Error processing post ${postId}:`, error);
      
      // Log error for monitoring
      await logError('onPostCreate', error, { postId, authorId });
    }
  });

/**
 * Post like trigger - processes likes and sends notifications
 */
export const onPostLike = functions.firestore
  .document('posts/{postId}/likes/{likeId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const likeId = context.params.likeId;
    const likeData = snapshot.data();
    const likerId = likeData.userId;
    
    try {
      console.log(`Processing like ${likeId} on post ${postId} by user ${likerId}`);
      
      // Get post data
      const postDoc = await admin.firestore()
        .collection('posts')
        .doc(postId)
        .get();
        
      if (!postDoc.exists) {
        console.log(`Post ${postId} not found`);
        return;
      }
      
      const postData = postDoc.data() as PostData;
      const authorId = postData.authorId;
      
      // Don't notify if user likes their own post
      if (likerId === authorId) {
        console.log('User liked their own post, skipping notification');
        return;
      }
      
      // Update like count atomically
      await admin.firestore()
        .collection('posts')
        .doc(postId)
        .update({
          likesCount: admin.firestore.FieldValue.increment(1),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      
      // Get liker and author info
      const [likerData, authorData] = await Promise.all([
        getUserData(likerId),
        getUserData(authorId),
      ]);
      
      if (!likerData) {
        console.error(`Liker data not found for user ${likerId}`);
        return;
      }
      
      // Send notification to post author
      await NotificationService.sendNotificationToUser({
        targetUserId: authorId,
        type: NotificationType.NEW_LIKE,
        title: 'New Like ❤️',
        body: `${likerData.displayName} liked your post`,
        data: {
          postId: postId,
          likerId: likerId,
          likerName: likerData.displayName,
          likerAvatar: likerData.photoURL,
          postContent: postData.content.substring(0, 100),
        },
        priority: 'normal',
      });
      
      console.log(`Like notification sent for post ${postId}`);
    } catch (error) {
      console.error(`Error processing like for post ${postId}:`, error);
      await logError('onPostLike', error, { postId, likeId, likerId });
    }
  });

/**
 * Post unlike trigger - decrements like count
 */
export const onPostUnlike = functions.firestore
  .document('posts/{postId}/likes/{likeId}')
  .onDelete(async (snapshot, context) => {
    const postId = context.params.postId;
    const likeId = context.params.likeId;
    
    try {
      console.log(`Processing unlike ${likeId} on post ${postId}`);
      
      // Update like count atomically
      await admin.firestore()
        .collection('posts')
        .doc(postId)
        .update({
          likesCount: admin.firestore.FieldValue.increment(-1),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      
      console.log(`Unlike processed for post ${postId}`);
    } catch (error) {
      console.error(`Error processing unlike for post ${postId}:`, error);
      await logError('onPostUnlike', error, { postId, likeId });
    }
  });

/**
 * Comment creation trigger - processes comments and sends notifications
 */
export const onCommentCreate = functions.firestore
  .document('posts/{postId}/comments/{commentId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const commentId = context.params.commentId;
    const commentData = snapshot.data();
    const commenterId = commentData.authorId;
    
    try {
      console.log(`Processing comment ${commentId} on post ${postId} by user ${commenterId}`);
      
      // Get post data
      const postDoc = await admin.firestore()
        .collection('posts')
        .doc(postId)
        .get();
        
      if (!postDoc.exists) {
        console.log(`Post ${postId} not found`);
        return;
      }
      
      const postData = postDoc.data() as PostData;
      const postAuthorId = postData.authorId;
      
      // Update comment count atomically
      await admin.firestore()
        .collection('posts')
        .doc(postId)
        .update({
          commentsCount: admin.firestore.FieldValue.increment(1),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      
      // Get commenter info
      const commenterData = await getUserData(commenterId);
      if (!commenterData) {
        console.error(`Commenter data not found for user ${commenterId}`);
        return;
      }
      
      // Send notification to post author (if not commenting on own post)
      if (commenterId !== postAuthorId) {
        await NotificationService.sendNotificationToUser({
          targetUserId: postAuthorId,
          type: NotificationType.NEW_COMMENT,
          title: 'New Comment 💬',
          body: `${commenterData.displayName} commented on your post`,
          data: {
            postId: postId,
            commentId: commentId,
            commenterId: commenterId,
            commenterName: commenterData.displayName,
            commenterAvatar: commenterData.photoURL,
            commentPreview: commentData.content.substring(0, 100),
            postContent: postData.content.substring(0, 100),
          },
          priority: 'normal',
        });
      }
      
      // Process comment for moderation
      await processCommentContent(commentId, commentData);
      
      console.log(`Comment notification sent for post ${postId}`);
    } catch (error) {
      console.error(`Error processing comment for post ${postId}:`, error);
      await logError('onCommentCreate', error, { postId, commentId, commenterId });
    }
  });

/**
 * Comment deletion trigger - decrements comment count
 */
export const onCommentDelete = functions.firestore
  .document('posts/{postId}/comments/{commentId}')
  .onDelete(async (snapshot, context) => {
    const postId = context.params.postId;
    const commentId = context.params.commentId;
    
    try {
      console.log(`Processing comment deletion ${commentId} on post ${postId}`);
      
      // Update comment count atomically
      await admin.firestore()
        .collection('posts')
        .doc(postId)
        .update({
          commentsCount: admin.firestore.FieldValue.increment(-1),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      
      console.log(`Comment deletion processed for post ${postId}`);
    } catch (error) {
      console.error(`Error processing comment deletion for post ${postId}:`, error);
      await logError('onCommentDelete', error, { postId, commentId });
    }
  });

/**
 * Post deletion trigger - cleanup and update counts
 */
export const onPostDelete = functions.firestore
  .document('posts/{postId}')
  .onDelete(async (snapshot, context) => {
    const postId = context.params.postId;
    const postData = snapshot.data() as PostData;
    const authorId = postData.authorId;
    
    try {
      console.log(`Processing post deletion ${postId} by user ${authorId}`);
      
      // Update user post count
      await updateUserPostCount(authorId, -1);
      
      // Clean up related data (likes, comments, etc.)
      await cleanupPostData(postId);
      
      console.log(`Post deletion processed for ${postId}`);
    } catch (error) {
      console.error(`Error processing post deletion ${postId}:`, error);
      await logError('onPostDelete', error, { postId, authorId });
    }
  });

// Helper functions

async function processPostContent(postId: string, postData: PostData): Promise<void> {
  try {
    // Validate post content
    const validation = validatePostContent(postData.content);
    if (!validation.isValid) {
      console.warn(`Post ${postId} has validation issues:`, validation.errors);
    }
    
    // Content moderation
    const moderationResult = await moderateContent(postData.content);
    
    if (moderationResult.flagged) {
      await admin.firestore()
        .collection('posts')
        .doc(postId)
        .update({
          moderationStatus: moderationResult.action,
          moderationFlags: moderationResult.flags,
          moderationConfidence: moderationResult.confidence,
          moderatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      
      // Notify moderators if content needs review or blocking
      if (moderationResult.action !== 'allow') {
        await notifyModerators(postId, moderationResult);
      }
    }
  } catch (error) {
    console.error(`Failed to process post content for ${postId}:`, error);
  }
}

async function processCommentContent(commentId: string, commentData: any): Promise<void> {
  try {
    // Content moderation for comments
    const moderationResult = await moderateContent(commentData.content);
    
    if (moderationResult.flagged) {
      await admin.firestore()
        .collection('posts')
        .doc(commentData.postId)
        .collection('comments')
        .doc(commentId)
        .update({
          moderationStatus: moderationResult.action,
          moderationFlags: moderationResult.flags,
          moderationConfidence: moderationResult.confidence,
          moderatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      
      if (moderationResult.action !== 'allow') {
        await notifyModerators(commentId, moderationResult, 'comment');
      }
    }
  } catch (error) {
    console.error(`Failed to process comment content for ${commentId}:`, error);
  }
}

async function updateUserPostCount(userId: string, increment: number): Promise<void> {
  try {
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .update({
        postsCount: admin.firestore.FieldValue.increment(increment),
        lastPostAt: increment > 0 ? admin.firestore.FieldValue.serverTimestamp() : null,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
  } catch (error) {
    console.error(`Failed to update post count for user ${userId}:`, error);
  }
}

async function notifyFollowersOfNewPost(
  authorId: string,
  postId: string,
  postData: PostData,
  authorData: UserData
): Promise<void> {
  try {
    // Get followers
    const followersSnapshot = await admin.firestore()
      .collection('follows')
      .where('followingId', '==', authorId)
      .where('isActive', '==', true)
      .get();
    
    if (followersSnapshot.empty) {
      console.log(`No followers found for user ${authorId}`);
      return;
    }
    
    console.log(`Notifying ${followersSnapshot.size} followers of new post ${postId}`);
    
    // Send notifications to followers in batches
    const followerIds = followersSnapshot.docs.map(doc => doc.data().followerId);
    const batchSize = 100;
    
    for (let i = 0; i < followerIds.length; i += batchSize) {
      const batch = followerIds.slice(i, i + batchSize);
      
      const promises = batch.map(followerId =>
        NotificationService.sendNotificationToUser({
          targetUserId: followerId,
          type: NotificationType.NEW_POST,
          title: 'New Post',
          body: `${authorData.displayName} shared a new post`,
          data: {
            postId: postId,
            authorId: authorId,
            authorName: authorData.displayName,
            authorAvatar: authorData.photoURL,
            postPreview: postData.content.substring(0, 100),
          },
          priority: 'normal',
        }).catch(error => {
          console.error(`Failed to notify follower ${followerId}:`, error);
        })
      );
      
      await Promise.allSettled(promises);
    }
    
    console.log(`Finished notifying followers of post ${postId}`);
  } catch (error) {
    console.error(`Failed to notify followers of post ${postId}:`, error);
  }
}

async function processHashtagsAndMentions(postId: string, postData: PostData): Promise<void> {
  try {
    const content = postData.content;
    
    // Extract hashtags and mentions
    const hashtags = extractHashtags(content);
    const mentions = extractMentions(content);
    
    // Update post with extracted data
    await admin.firestore()
      .collection('posts')
      .doc(postId)
      .update({
        hashtags: hashtags,
        mentions: mentions,
        extractedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    // Process hashtag trends
    if (hashtags.length > 0) {
      await updateHashtagTrends(hashtags);
    }
    
    // Notify mentioned users
    if (mentions.length > 0) {
      await notifyMentionedUsers(postId, mentions, postData);
    }
  } catch (error) {
    console.error(`Failed to process hashtags and mentions for post ${postId}:`, error);
  }
}

async function updateHashtagTrends(hashtags: string[]): Promise<void> {
  try {
    const batch = admin.firestore().batch();
    
    hashtags.forEach(hashtag => {
      const trendRef = admin.firestore()
        .collection('trends')
        .doc(hashtag);
        
      batch.set(trendRef, {
        hashtag: hashtag,
        count: admin.firestore.FieldValue.increment(1),
        lastUsed: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
    });
    
    await batch.commit();
    console.log(`Updated trends for ${hashtags.length} hashtags`);
  } catch (error) {
    console.error('Failed to update hashtag trends:', error);
  }
}

async function notifyMentionedUsers(
  postId: string,
  mentions: string[],
  postData: PostData
): Promise<void> {
  try {
    // Get mentioned users by username
    const userPromises = mentions.map(async username => {
      const userSnapshot = await admin.firestore()
        .collection('users')
        .where('username', '==', username)
        .limit(1)
        .get();
        
      return userSnapshot.empty ? null : userSnapshot.docs[0];
    });
    
    const userDocs = await Promise.all(userPromises);
    const validUsers = userDocs.filter(doc => doc !== null);
    
    if (validUsers.length === 0) {
      console.log('No valid mentioned users found');
      return;
    }
    
    // Get author data for notifications
    const authorData = await getUserData(postData.authorId);
    if (!authorData) {
      console.error('Author data not found for mentions notification');
      return;
    }
    
    // Send notifications
    const notificationPromises = validUsers.map(doc =>
      NotificationService.sendNotificationToUser({
        targetUserId: doc!.id,
        type: NotificationType.NEW_POST,
        title: 'You were mentioned',
        body: `${authorData.displayName} mentioned you in a post`,
        data: {
          postId: postId,
          authorId: postData.authorId,
          authorName: authorData.displayName,
          authorAvatar: authorData.photoURL,
          type: 'mention',
          postPreview: postData.content.substring(0, 100),
        },
        priority: 'normal',
      }).catch(error => {
        console.error(`Failed to notify mentioned user ${doc!.id}:`, error);
      })
    );
    
    await Promise.allSettled(notificationPromises);
    console.log(`Notified ${validUsers.length} mentioned users`);
  } catch (error) {
    console.error('Failed to notify mentioned users:', error);
  }
}

async function notifyModerators(
  contentId: string, 
  moderationResult: ModerationResult,
  contentType: 'post' | 'comment' = 'post'
): Promise<void> {
  try {
    // Get list of moderators
    const moderatorsSnapshot = await admin.firestore()
      .collection('users')
      .where('role', 'in', ['admin', 'moderator'])
      .get();
    
    if (moderatorsSnapshot.empty) {
      console.log('No moderators found to notify');
      return;
    }
    
    const moderatorPromises = moderatorsSnapshot.docs.map(doc =>
      NotificationService.sendNotificationToUser({
        targetUserId: doc.id,
        type: NotificationType.SYSTEM_ALERT,
        title: 'Content Flagged for Review',
        body: `${contentType} ${contentId} needs moderation review`,
        data: {
          contentId: contentId,
          contentType: contentType,
          flags: moderationResult.flags,
          severity: moderationResult.severity,
          action: moderationResult.action,
          confidence: moderationResult.confidence,
        },
        priority: moderationResult.severity === 'high' ? 'high' : 'normal',
      }).catch(error => {
        console.error(`Failed to notify moderator ${doc.id}:`, error);
      })
    );
    
    await Promise.allSettled(moderatorPromises);
    console.log(`Notified ${moderatorsSnapshot.size} moderators`);
  } catch (error) {
    console.error('Failed to notify moderators:', error);
  }
}

async function cleanupPostData(postId: string): Promise<void> {
  try {
    const batch = admin.firestore().batch();
    
    // Delete likes
    const likesSnapshot = await admin.firestore()
      .collection('posts')
      .doc(postId)
      .collection('likes')
      .get();
    
    likesSnapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    // Delete comments
    const commentsSnapshot = await admin.firestore()
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .get();
    
    commentsSnapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    await batch.commit();
    console.log(`Cleaned up data for post ${postId}`);
  } catch (error) {
    console.error(`Failed to cleanup post data for ${postId}:`, error);
  }
}

async function getUserData(userId: string): Promise<UserData | null> {
  try {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(userId)
      .get();
      
    if (!userDoc.exists) {
      return null;
    }
    
    return { id: userId, ...userDoc.data() } as UserData;
  } catch (error) {
    console.error(`Failed to get user data for ${userId}:`, error);
    return null;
  }
}

async function logError(
  functionName: string, 
  error: any, 
  context: Record<string, any>
): Promise<void> {
  try {
    await admin.firestore().collection('errorLogs').add({
      functionName,
      error: error instanceof Error ? error.message : String(error),
      context,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      severity: 'medium',
      resolved: false,
    });
  } catch (logError) {
    console.error('Failed to log error:', logError);
  }
}
