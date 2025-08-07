import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { NotificationService } from '../notifications/notification-service';
import { NotificationType, UserData, FollowData } from '../types';

/**
 * User creation trigger - initializes new user and sends welcome notification
 */
export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  try {
    console.log(`Processing new user creation: ${user.uid}`);
    
    // Create user profile in Firestore
    await admin.firestore().collection('users').doc(user.uid).set({
      email: user.email || '',
      displayName: user.displayName || '',
      photoURL: user.photoURL || '',
      bio: '',
      website: '',
      location: '',
      interests: [],
      followersCount: 0,
      followingCount: 0,
      postsCount: 0,
      isPublic: true,
      isActive: true,
      isVerified: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      lastSeenAt: admin.firestore.FieldValue.serverTimestamp(),
      fcmTokens: [],
      settings: {
        notifications: {
          pushNotifications: true,
          emailNotifications: true,
          inAppNotifications: true,
          likes: true,
          comments: true,
          follows: true,
          messages: true,
          posts: true,
          quietHours: {
            enabled: false,
            startTime: '22:00',
            endTime: '08:00',
          },
        },
        privacy: {
          profileVisibility: 'public',
          showEmail: false,
          showLastSeen: true,
        },
        theme: 'system',
        language: 'en',
      },
    });
    
    // Initialize user preferences
    await initializeUserPreferences(user.uid);
    
    // Send welcome notification (delayed to ensure FCM token is available)
    setTimeout(async () => {
      try {
        await NotificationService.sendNotificationToUser({
          targetUserId: user.uid,
          type: NotificationType.WELCOME,
          title: '🎉 Welcome to SocialHub Pro!',
          body: `Hi ${user.displayName || 'there'}! Start connecting with friends.`,
          data: {
            userId: user.uid,
            welcomeMessage: 'Welcome to our community!',
          },
          priority: 'normal',
        });
      } catch (error) {
        console.error(`Failed to send welcome notification to ${user.uid}:`, error);
      }
    }, 5000); // 5 second delay
    
    // Log user creation analytics
    await admin.firestore().collection('analytics').add({
      eventName: 'user_created',
      userId: user.uid,
      data: {
        provider: user.providerData[0]?.providerId || 'unknown',
        hasDisplayName: !!user.displayName,
        hasPhotoURL: !!user.photoURL,
        emailVerified: user.emailVerified,
      },
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      platform: 'server',
    });
    
    console.log(`User ${user.uid} successfully initialized`);
  } catch (error) {
    console.error(`Failed to process user creation for ${user.uid}:`, error);
  }
});

/**
 * User deletion trigger - cleanup user data
 */
export const onUserDelete = functions.auth.user().onDelete(async (user) => {
  try {
    console.log(`Processing user deletion: ${user.uid}`);
    
    // Delete user data (GDPR compliance)
    await deleteUserData(user.uid);
    
    // Anonymize user content
    await anonymizeUserContent(user.uid);
    
    // Log deletion for audit
    await admin.firestore().collection('auditLogs').add({
      action: 'user_deleted',
      userId: user.uid,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      reason: 'user_requested',
    });
    
    console.log(`User ${user.uid} successfully deleted`);
  } catch (error) {
    console.error(`Failed to process user deletion for ${user.uid}:`, error);
  }
});

/**
 * User follow trigger - updates counts and sends notification
 */
export const onUserFollow = functions.firestore
  .document('follows/{followId}')
  .onCreate(async (snapshot, context) => {
    const followId = context.params.followId;
    const followData = snapshot.data() as FollowData;
    const followerId = followData.followerId;
    const followingId = followData.followingId;
    
    try {
      console.log(`Processing follow: ${followerId} -> ${followingId}`);
      
      // Update follower/following counts
      await updateFollowCounts(followerId, followingId, 1);
      
      // Get follower info for notification
      const followerData = await getUserData(followerId);
      if (!followerData) {
        console.error(`Follower data not found for user ${followerId}`);
        return;
      }
      
      // Send notification to followed user
      await NotificationService.sendNotificationToUser({
        targetUserId: followingId,
        type: NotificationType.FRIEND_REQUEST,
        title: 'New Follower 👋',
        body: `${followerData.displayName} started following you`,
        data: {
          followId: followId,
          followerId: followerId,
          followerName: followerData.displayName,
          followerAvatar: followerData.photoURL,
          action: 'new_follower',
        },
        priority: 'normal',
      });
      
      // Log follow analytics
      await admin.firestore().collection('analytics').add({
        eventName: 'user_followed',
        userId: followerId,
        data: {
          targetUserId: followingId,
          followId: followId,
        },
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        platform: 'server',
      });
      
      console.log(`Follow notification sent: ${followerId} -> ${followingId}`);
    } catch (error) {
      console.error(`Error processing follow ${followId}:`, error);
    }
  });

/**
 * User unfollow trigger - updates counts
 */
export const onUserUnfollow = functions.firestore
  .document('follows/{followId}')
  .onDelete(async (snapshot, context) => {
    const followId = context.params.followId;
    const followData = snapshot.data() as FollowData;
    const followerId = followData.followerId;
    const followingId = followData.followingId;
    
    try {
      console.log(`Processing unfollow: ${followerId} -> ${followingId}`);
      
      // Update follower/following counts
      await updateFollowCounts(followerId, followingId, -1);
      
      // Log unfollow analytics
      await admin.firestore().collection('analytics').add({
        eventName: 'user_unfollowed',
        userId: followerId,
        data: {
          targetUserId: followingId,
          followId: followId,
        },
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        platform: 'server',
      });
      
      console.log(`Unfollow processed: ${followerId} -> ${followingId}`);
    } catch (error) {
      console.error(`Error processing unfollow ${followId}:`, error);
    }
  });

/**
 * User profile update trigger - processes profile changes
 */
export const onUserProfileUpdate = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    const userId = context.params.userId;
    const beforeData = change.before.data() as UserData;
    const afterData = change.after.data() as UserData;
    
    try {
      console.log(`Processing profile update for user ${userId}`);
      
      // Check what changed
      const changes: Record<string, any> = {};
      
      if (beforeData.displayName !== afterData.displayName) {
        changes.displayName = {
          before: beforeData.displayName,
          after: afterData.displayName,
        };
      }
      
      if (beforeData.photoURL !== afterData.photoURL) {
        changes.photoURL = {
          before: beforeData.photoURL,
          after: afterData.photoURL,
        };
      }
      
      if (beforeData.bio !== afterData.bio) {
        changes.bio = {
          before: beforeData.bio,
          after: afterData.bio,
        };
      }
      
      // Log profile changes
      if (Object.keys(changes).length > 0) {
        await admin.firestore().collection('analytics').add({
          eventName: 'profile_updated',
          userId: userId,
          data: {
            changes: changes,
            fieldsChanged: Object.keys(changes),
          },
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          platform: 'server',
        });
      }
      
      // Update search index if display name changed
      if (changes.displayName) {
        await updateUserSearchIndex(userId, afterData);
      }
      
      console.log(`Profile update processed for user ${userId}`);
    } catch (error) {
      console.error(`Error processing profile update for ${userId}:`, error);
    }
  });

// Helper functions

async function initializeUserPreferences(userId: string): Promise<void> {
  try {
    // Create default notification preferences
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .collection('preferences')
      .doc('notifications')
      .set({
        pushNotifications: true,
        emailNotifications: true,
        inAppNotifications: true,
        likes: true,
        comments: true,
        follows: true,
        messages: true,
        posts: true,
        quietHours: {
          enabled: false,
          startTime: '22:00',
          endTime: '08:00',
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    // Create default privacy preferences
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .collection('preferences')
      .doc('privacy')
      .set({
        profileVisibility: 'public',
        showEmail: false,
        showLastSeen: true,
        allowMessageRequests: true,
        showOnlineStatus: true,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log(`Initialized preferences for user ${userId}`);
  } catch (error) {
    console.error(`Failed to initialize preferences for user ${userId}:`, error);
  }
}

async function deleteUserData(userId: string): Promise<void> {
  try {
    const batch = admin.firestore().batch();
    
    // Delete user profile
    batch.delete(admin.firestore().collection('users').doc(userId));
    
    // Delete user preferences
    const preferencesSnapshot = await admin.firestore()
      .collection('users')
      .doc(userId)
      .collection('preferences')
      .get();
    
    preferencesSnapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    // Delete user notifications
    const notificationsSnapshot = await admin.firestore()
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .get();
    
    notificationsSnapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    // Delete follow relationships
    const followsSnapshot = await admin.firestore()
      .collection('follows')
      .where('followerId', '==', userId)
      .get();
    
    followsSnapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    const followingSnapshot = await admin.firestore()
      .collection('follows')
      .where('followingId', '==', userId)
      .get();
    
    followingSnapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    await batch.commit();
    console.log(`Deleted user data for ${userId}`);
  } catch (error) {
    console.error(`Failed to delete user data for ${userId}:`, error);
  }
}

async function anonymizeUserContent(userId: string): Promise<void> {
  try {
    const batch = admin.firestore().batch();
    
    // Anonymize posts
    const postsSnapshot = await admin.firestore()
      .collection('posts')
      .where('authorId', '==', userId)
      .get();
    
    postsSnapshot.docs.forEach(doc => {
      batch.update(doc.ref, {
        authorId: 'deleted_user',
        authorName: 'Deleted User',
        authorAvatar: null,
        anonymized: true,
        anonymizedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });
    
    // Anonymize comments
    const commentsSnapshot = await admin.firestore()
      .collectionGroup('comments')
      .where('authorId', '==', userId)
      .get();
    
    commentsSnapshot.docs.forEach(doc => {
      batch.update(doc.ref, {
        authorId: 'deleted_user',
        authorName: 'Deleted User',
        authorAvatar: null,
        anonymized: true,
        anonymizedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });
    
    await batch.commit();
    console.log(`Anonymized content for user ${userId}`);
  } catch (error) {
    console.error(`Failed to anonymize content for user ${userId}:`, error);
  }
}

async function updateFollowCounts(
  followerId: string,
  followingId: string,
  increment: number
): Promise<void> {
  try {
    const batch = admin.firestore().batch();
    
    // Update follower's following count
    const followerRef = admin.firestore()
      .collection('users')
      .doc(followerId);
    batch.update(followerRef, {
      followingCount: admin.firestore.FieldValue.increment(increment),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // Update following user's follower count
    const followingRef = admin.firestore()
      .collection('users')
      .doc(followingId);
    batch.update(followingRef, {
      followersCount: admin.firestore.FieldValue.increment(increment),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    await batch.commit();
    console.log(`Updated follow counts: ${followerId} -> ${followingId} (${increment})`);
  } catch (error) {
    console.error(`Failed to update follow counts: ${followerId} -> ${followingId}:`, error);
  }
}

async function updateUserSearchIndex(userId: string, userData: UserData): Promise<void> {
  try {
    // Update search index document
    await admin.firestore()
      .collection('searchIndex')
      .doc(`user_${userId}`)
      .set({
        type: 'user',
        userId: userId,
        displayName: userData.displayName,
        displayNameLower: userData.displayName.toLowerCase(),
        searchTerms: generateSearchTerms(userData.displayName),
        photoURL: userData.photoURL,
        isVerified: userData.isVerified,
        isPublic: userData.isPublic,
        followersCount: userData.followersCount,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log(`Updated search index for user ${userId}`);
  } catch (error) {
    console.error(`Failed to update search index for user ${userId}:`, error);
  }
}

function generateSearchTerms(displayName: string): string[] {
  const terms: string[] = [];
  const words = displayName.toLowerCase().split(/\s+/);
  
  // Add individual words
  terms.push(...words);
  
  // Add partial matches (prefixes)
  words.forEach(word => {
    for (let i = 1; i <= word.length; i++) {
      terms.push(word.substring(0, i));
    }
  });
  
  // Remove duplicates and empty strings
  return [...new Set(terms)].filter(term => term.length > 0);
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
