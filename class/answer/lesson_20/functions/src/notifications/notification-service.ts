import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { 
  NotificationData, 
  NotificationTemplate, 
  NotificationTarget, 
  NotificationType,
  UserData,
  NotificationPreferences
} from '../types';

export class NotificationService {
  
  /**
   * Send a notification to a specific user or group
   */
  static async sendNotification(
    target: NotificationTarget,
    template: NotificationTemplate,
    options: {
      priority?: 'high' | 'normal';
      timeToLive?: number;
      collapseKey?: string;
      restrictedPackageName?: string;
      dryRun?: boolean;
    } = {}
  ): Promise<string> {
    
    const message: admin.messaging.Message = {
      notification: {
        title: template.title,
        body: template.body,
        imageUrl: template.icon,
      },
      data: {
        ...template.data,
        type: template.data?.type || 'default',
        timestamp: Date.now().toString(),
      },
      android: {
        notification: {
          icon: template.icon || 'ic_notification',
          color: template.color || '#6C63FF',
          sound: template.sound || 'default',
          priority: options.priority === 'high' ? 'high' : 'normal',
          defaultSound: true,
          defaultVibrateTimings: true,
          channelId: this.getNotificationChannelId(template.data?.type),
        },
        ttl: options.timeToLive ? options.timeToLive * 1000 : undefined,
        collapseKey: options.collapseKey,
        restrictedPackageName: options.restrictedPackageName,
      },
      apns: {
        payload: {
          aps: {
            alert: {
              title: template.title,
              body: template.body,
            },
            badge: template.badge,
            sound: template.sound || 'default',
            category: template.data?.category,
            'content-available': 1,
          },
        },
        headers: {
          'apns-priority': options.priority === 'high' ? '10' : '5',
          'apns-expiration': options.timeToLive ? 
            String(Math.floor(Date.now() / 1000) + options.timeToLive) : '0',
        },
      },
      webpush: {
        notification: {
          title: template.title,
          body: template.body,
          icon: template.icon,
          badge: template.icon,
          requireInteraction: options.priority === 'high',
          tag: options.collapseKey,
        },
        fcmOptions: {
          link: template.data?.link,
        },
      },
    };

    // Set target based on type
    switch (target.type) {
      case 'user':
        const userTokens = await this.getUserTokens(target.value as string);
        if (userTokens.length > 0) {
          message.tokens = userTokens;
        } else {
          throw new Error('No FCM tokens found for user');
        }
        break;
      case 'topic':
        message.topic = target.value as string;
        break;
      case 'condition':
        message.condition = target.value as string;
        break;
      case 'tokens':
        message.tokens = target.value as string[];
        break;
    }

    try {
      let response: string;
      
      if (message.tokens) {
        // Send to multiple tokens
        const multicastMessage: admin.messaging.MulticastMessage = {
          ...message,
          tokens: message.tokens,
        };
        
        const batchResponse = await admin.messaging().sendMulticast(multicastMessage, options.dryRun);
        response = `Sent to ${batchResponse.successCount}/${batchResponse.responses.length} devices`;
        
        // Handle failed tokens
        if (batchResponse.failureCount > 0) {
          await this.handleFailedTokens(message.tokens, batchResponse.responses);
        }
        
      } else {
        // Send to topic or condition
        response = await admin.messaging().send(message, options.dryRun);
      }
      
      console.log('Notification sent successfully:', response);
      
      // Log notification
      await this.logNotification(target, template, response);
      
      return response;
    } catch (error) {
      console.error('Failed to send notification:', error);
      await this.logNotificationError(target, template, error);
      throw error;
    }
  }

  /**
   * Send notification with user preference checking
   */
  static async sendNotificationToUser(data: NotificationData): Promise<string> {
    try {
      // Check user preferences
      const canSendNotification = await this.checkUserNotificationPreferences(
        data.targetUserId,
        data.type
      );
      
      if (!canSendNotification) {
        console.log(`Notification blocked by user preferences: ${data.targetUserId}`);
        return 'blocked_by_preferences';
      }
      
      // Get notification template
      const template = this.getNotificationTemplate(data.type, data.data || {});
      template.title = data.title;
      template.body = data.body;
      
      if (data.icon) template.icon = data.icon;
      if (data.sound) template.sound = data.sound;
      if (data.badge) template.badge = data.badge;
      
      // Create target
      const target: NotificationTarget = {
        type: 'user',
        value: data.targetUserId,
      };
      
      // Send notification
      const response = await this.sendNotification(target, template, {
        priority: data.priority || 'normal',
      });
      
      // Store notification in database
      await this.storeNotificationRecord(data, response);
      
      return response;
    } catch (error) {
      console.error('Failed to send notification to user:', error);
      throw error;
    }
  }

  /**
   * Send bulk notifications efficiently
   */
  static async sendBulkNotifications(
    notifications: Array<{
      target: NotificationTarget;
      template: NotificationTemplate;
      options?: any;
    }>,
    batchSize: number = 500
  ): Promise<{
    totalSent: number;
    totalFailed: number;
    errors: string[];
  }> {
    
    let totalSent = 0;
    let totalFailed = 0;
    const errors: string[] = [];
    
    // Process in batches
    for (let i = 0; i < notifications.length; i += batchSize) {
      const batch = notifications.slice(i, i + batchSize);
      
      const promises = batch.map(async ({ target, template, options }) => {
        try {
          await this.sendNotification(target, template, options);
          return { success: true };
        } catch (error) {
          const errorMessage = error instanceof Error ? error.message : String(error);
          errors.push(errorMessage);
          return { success: false, error: errorMessage };
        }
      });

      const results = await Promise.allSettled(promises);
      
      results.forEach((result) => {
        if (result.status === 'fulfilled' && result.value.success) {
          totalSent++;
        } else {
          totalFailed++;
        }
      });
    }
    
    return { totalSent, totalFailed, errors };
  }

  /**
   * Schedule a notification for future delivery
   */
  static async scheduleNotification(
    target: NotificationTarget,
    template: NotificationTemplate,
    scheduleTime: Date,
    options?: any
  ): Promise<string> {
    
    const scheduledNotification = {
      target,
      template,
      options,
      scheduleTime: admin.firestore.Timestamp.fromDate(scheduleTime),
      status: 'scheduled',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const docRef = await admin.firestore()
      .collection('scheduledNotifications')
      .add(scheduledNotification);

    console.log(`Notification scheduled: ${docRef.id}`);
    return docRef.id;
  }

  /**
   * Process scheduled notifications (called by cron job)
   */
  static async processScheduledNotifications(): Promise<void> {
    const now = admin.firestore.Timestamp.now();
    
    const scheduledSnapshot = await admin.firestore()
      .collection('scheduledNotifications')
      .where('scheduleTime', '<=', now)
      .where('status', '==', 'scheduled')
      .limit(100) // Process in batches
      .get();

    for (const doc of scheduledSnapshot.docs) {
      const data = doc.data();
      
      try {
        await this.sendNotification(data.target, data.template, data.options);
        
        // Mark as sent
        await doc.ref.update({
          status: 'sent',
          sentAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        
      } catch (error) {
        console.error(`Failed to send scheduled notification ${doc.id}:`, error);
        
        // Mark as failed
        await doc.ref.update({
          status: 'failed',
          error: error instanceof Error ? error.message : String(error),
          failedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    }
  }

  /**
   * Get notification template based on type
   */
  static getNotificationTemplate(
    type: NotificationType, 
    data: Record<string, any>
  ): NotificationTemplate {
    
    const templates: Record<NotificationType, (data: any) => NotificationTemplate> = {
      
      [NotificationType.NEW_POST]: (data) => ({
        title: 'New Post',
        body: `${data.authorName || 'Someone'} shared a new post`,
        icon: data.authorAvatar || '/icons/post.png',
        color: '#6C63FF',
        data: {
          type: 'new_post',
          postId: data.postId,
          authorId: data.authorId,
          action: 'view_post',
        },
      }),

      [NotificationType.NEW_LIKE]: (data) => ({
        title: 'New Like ❤️',
        body: `${data.likerName || 'Someone'} liked your post`,
        icon: data.likerAvatar || '/icons/like.png',
        color: '#FF6B6B',
        data: {
          type: 'new_like',
          postId: data.postId,
          likerId: data.likerId,
          action: 'view_post',
        },
      }),

      [NotificationType.NEW_COMMENT]: (data) => ({
        title: 'New Comment 💬',
        body: `${data.commenterName || 'Someone'} commented on your post`,
        icon: data.commenterAvatar || '/icons/comment.png',
        color: '#4ECDC4',
        data: {
          type: 'new_comment',
          postId: data.postId,
          commentId: data.commentId,
          commenterId: data.commenterId,
          action: 'view_post',
        },
      }),

      [NotificationType.FRIEND_REQUEST]: (data) => ({
        title: 'Friend Request 👋',
        body: `${data.requesterName || 'Someone'} sent you a friend request`,
        icon: data.requesterAvatar || '/icons/friend.png',
        color: '#45B7D1',
        data: {
          type: 'friend_request',
          requestId: data.requestId,
          requesterId: data.requesterId,
          action: 'view_friend_requests',
        },
      }),

      [NotificationType.NEW_MESSAGE]: (data) => ({
        title: data.senderName || 'New Message',
        body: data.messagePreview || 'You have a new message',
        icon: data.senderAvatar || '/icons/message.png',
        color: '#7B68EE',
        data: {
          type: 'new_message',
          chatId: data.chatId,
          messageId: data.messageId,
          senderId: data.senderId,
          action: 'view_chat',
        },
      }),

      [NotificationType.SYSTEM_ALERT]: (data) => ({
        title: data.title || 'System Alert',
        body: data.message || 'You have a system notification',
        icon: '/icons/system.png',
        color: '#FFA726',
        data: {
          type: 'system_alert',
          alertId: data.alertId,
          severity: data.severity || 'info',
          action: data.action || 'view_notifications',
        },
      }),

      [NotificationType.WELCOME]: (data) => ({
        title: '🎉 Welcome to SocialHub Pro!',
        body: `Hi ${data.displayName || 'there'}! Start connecting with friends.`,
        icon: '/icons/welcome.png',
        color: '#6C63FF',
        data: {
          type: 'welcome',
          userId: data.userId,
          action: 'explore_app',
        },
      }),

      [NotificationType.REMINDER]: (data) => ({
        title: data.title || '🔔 Reminder',
        body: data.message || 'You have a reminder',
        icon: '/icons/reminder.png',
        color: '#FF9800',
        data: {
          type: 'reminder',
          reminderId: data.reminderId,
          action: data.action || 'view_reminders',
        },
      }),
    };

    const templateFunction = templates[type];
    if (!templateFunction) {
      throw new Error(`Unknown notification template: ${type}`);
    }

    return templateFunction(data);
  }

  /**
   * Get user's FCM tokens
   */
  private static async getUserTokens(userId: string): Promise<string[]> {
    try {
      const userDoc = await admin.firestore()
        .collection('users')
        .doc(userId)
        .get();

      if (!userDoc.exists) {
        return [];
      }

      const userData = userDoc.data() as UserData;
      return userData.fcmTokens || [];
    } catch (error) {
      console.error(`Failed to get tokens for user ${userId}:`, error);
      return [];
    }
  }

  /**
   * Check user notification preferences
   */
  private static async checkUserNotificationPreferences(
    userId: string,
    notificationType: NotificationType
  ): Promise<boolean> {
    try {
      const prefsDoc = await admin.firestore()
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('notifications')
        .get();

      if (!prefsDoc.exists) {
        // Default to allow all notifications
        return true;
      }

      const prefs = prefsDoc.data() as NotificationPreferences;
      
      // Check global push notification setting
      if (!prefs.pushNotifications) {
        return false;
      }
      
      // Check specific notification type
      switch (notificationType) {
        case NotificationType.NEW_LIKE:
          return prefs.likes;
        case NotificationType.NEW_COMMENT:
          return prefs.comments;
        case NotificationType.FRIEND_REQUEST:
          return prefs.follows;
        case NotificationType.NEW_MESSAGE:
          return prefs.messages;
        case NotificationType.NEW_POST:
          return prefs.posts;
        default:
          return true; // Allow system alerts and other types by default
      }
    } catch (error) {
      console.error(`Failed to check preferences for user ${userId}:`, error);
      return true; // Default to allow on error
    }
  }

  /**
   * Handle failed FCM tokens by removing them from user records
   */
  private static async handleFailedTokens(
    tokens: string[],
    responses: admin.messaging.SendResponse[]
  ): Promise<void> {
    const failedTokens: string[] = [];
    
    responses.forEach((response, index) => {
      if (!response.success) {
        const error = response.error;
        if (error?.code === 'messaging/registration-token-not-registered' ||
            error?.code === 'messaging/invalid-registration-token') {
          failedTokens.push(tokens[index]);
        }
      }
    });
    
    if (failedTokens.length > 0) {
      console.log(`Removing ${failedTokens.length} invalid FCM tokens`);
      await this.removeInvalidTokens(failedTokens);
    }
  }

  /**
   * Remove invalid FCM tokens from user records
   */
  private static async removeInvalidTokens(tokens: string[]): Promise<void> {
    try {
      // Find users with these tokens and remove them
      const usersSnapshot = await admin.firestore()
        .collection('users')
        .where('fcmTokens', 'array-contains-any', tokens)
        .get();

      const batch = admin.firestore().batch();
      
      usersSnapshot.docs.forEach((doc) => {
        const userData = doc.data() as UserData;
        const updatedTokens = userData.fcmTokens?.filter(token => !tokens.includes(token)) || [];
        
        batch.update(doc.ref, {
          fcmTokens: updatedTokens,
          lastTokenCleanup: admin.firestore.FieldValue.serverTimestamp(),
        });
      });
      
      await batch.commit();
      console.log(`Cleaned up tokens from ${usersSnapshot.size} users`);
    } catch (error) {
      console.error('Failed to remove invalid tokens:', error);
    }
  }

  /**
   * Get notification channel ID based on type
   */
  private static getNotificationChannelId(type: string): string {
    switch (type) {
      case 'new_message':
        return 'messages';
      case 'new_post':
      case 'new_like':
      case 'new_comment':
      case 'friend_request':
        return 'social_interactions';
      case 'system_alert':
      case 'welcome':
      case 'reminder':
        return 'system';
      default:
        return 'default';
    }
  }

  /**
   * Log successful notification
   */
  private static async logNotification(
    target: NotificationTarget,
    template: NotificationTemplate,
    response: string
  ): Promise<void> {
    try {
      await admin.firestore().collection('notificationLogs').add({
        target,
        template: {
          title: template.title,
          body: template.body,
          type: template.data?.type,
        },
        response,
        status: 'sent',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (error) {
      console.error('Failed to log notification:', error);
    }
  }

  /**
   * Log notification error
   */
  private static async logNotificationError(
    target: NotificationTarget,
    template: NotificationTemplate,
    error: any
  ): Promise<void> {
    try {
      await admin.firestore().collection('notificationLogs').add({
        target,
        template: {
          title: template.title,
          body: template.body,
          type: template.data?.type,
        },
        error: error instanceof Error ? error.message : String(error),
        status: 'failed',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (logError) {
      console.error('Failed to log notification error:', logError);
    }
  }

  /**
   * Store notification record in user's notifications collection
   */
  private static async storeNotificationRecord(
    data: NotificationData,
    response: string
  ): Promise<void> {
    try {
      await admin.firestore()
        .collection('users')
        .doc(data.targetUserId)
        .collection('notifications')
        .add({
          title: data.title,
          body: data.body,
          type: data.type,
          data: data.data || {},
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          messageId: response,
        });
    } catch (error) {
      console.error('Failed to store notification record:', error);
    }
  }
}

/**
 * Callable Cloud Function for sending notifications
 */
export const sendNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { targetUserId, type, title, body, notificationData } = data;
  
  // Validate input
  if (!targetUserId || !type || !title || !body) {
    throw new functions.https.HttpsError(
      'invalid-argument', 
      'Missing required fields: targetUserId, type, title, body'
    );
  }
  
  try {
    const response = await NotificationService.sendNotificationToUser({
      targetUserId,
      type,
      title,
      body,
      data: notificationData || {},
      priority: data.priority || 'normal',
    });
    
    return { success: true, response };
  } catch (error) {
    console.error('Send notification error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
});
