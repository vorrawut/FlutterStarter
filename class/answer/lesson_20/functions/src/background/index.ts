import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { NotificationService } from '../notifications/notification-service';

/**
 * Daily cleanup tasks - runs every day at 2 AM UTC
 */
export const dailyCleanup = functions.pubsub
  .schedule('0 2 * * *')
  .timeZone('UTC')
  .onRun(async (context) => {
    try {
      console.log('Starting daily cleanup tasks');
      
      // Clean up expired notifications
      await cleanupExpiredNotifications();
      
      // Clean up orphaned data
      await cleanupOrphanedData();
      
      // Archive old logs
      await archiveOldLogs();
      
      // Update user statistics
      await updateDailyStatistics();
      
      // Clean up invalid FCM tokens
      await cleanupInvalidTokens();
      
      // Process scheduled notifications
      await NotificationService.processScheduledNotifications();
      
      console.log('Daily cleanup completed successfully');
    } catch (error) {
      console.error('Daily cleanup failed:', error);
      
      // Send alert to administrators
      await sendAdminAlert('Daily Cleanup Failed', error);
    }
  });

/**
 * Weekly analytics - runs every Sunday at midnight UTC
 */
export const weeklyAnalytics = functions.pubsub
  .schedule('0 0 * * 0')
  .timeZone('UTC')
  .onRun(async (context) => {
    try {
      console.log('Starting weekly analytics generation');
      
      // Generate weekly user analytics
      await generateWeeklyUserAnalytics();
      
      // Generate content analytics
      await generateWeeklyContentAnalytics();
      
      // Update trending hashtags
      await updateTrendingHashtags();
      
      // Send weekly reports to admins
      await sendWeeklyReportsToAdmins();
      
      console.log('Weekly analytics completed successfully');
    } catch (error) {
      console.error('Weekly analytics failed:', error);
      await sendAdminAlert('Weekly Analytics Failed', error);
    }
  });

/**
 * Hourly health check - runs every hour
 */
export const hourlyHealthCheck = functions.pubsub
  .schedule('0 * * * *')
  .timeZone('UTC')
  .onRun(async (context) => {
    try {
      console.log('Starting hourly health check');
      
      // Check system health
      const healthStatus = await checkSystemHealth();
      
      // Log health status
      await admin.firestore().collection('systemHealth').add({
        status: healthStatus,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      // Alert if there are issues
      if (!healthStatus.healthy) {
        await sendAdminAlert('System Health Alert', healthStatus.issues);
      }
      
      console.log('Hourly health check completed');
    } catch (error) {
      console.error('Hourly health check failed:', error);
    }
  });

/**
 * Process notification queue - runs every 5 minutes
 */
export const processNotificationQueue = functions.pubsub
  .schedule('*/5 * * * *')
  .timeZone('UTC')
  .onRun(async (context) => {
    try {
      console.log('Processing notification queue');
      
      // Process pending notifications
      await processPendingNotifications();
      
      // Process scheduled notifications
      await NotificationService.processScheduledNotifications();
      
      console.log('Notification queue processing completed');
    } catch (error) {
      console.error('Notification queue processing failed:', error);
    }
  });

// Helper functions

async function cleanupExpiredNotifications(): Promise<void> {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    // Delete old notifications
    const expiredNotificationsSnapshot = await admin.firestore()
      .collectionGroup('notifications')
      .where('createdAt', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
      .limit(500) // Process in batches
      .get();
    
    if (!expiredNotificationsSnapshot.empty) {
      const batch = admin.firestore().batch();
      
      expiredNotificationsSnapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      await batch.commit();
      console.log(`Deleted ${expiredNotificationsSnapshot.size} expired notifications`);
    }
    
    // Delete old notification logs
    const expiredLogsSnapshot = await admin.firestore()
      .collection('notificationLogs')
      .where('timestamp', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
      .limit(500)
      .get();
    
    if (!expiredLogsSnapshot.empty) {
      const batch = admin.firestore().batch();
      
      expiredLogsSnapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      await batch.commit();
      console.log(`Deleted ${expiredLogsSnapshot.size} expired notification logs`);
    }
  } catch (error) {
    console.error('Failed to cleanup expired notifications:', error);
  }
}

async function cleanupOrphanedData(): Promise<void> {
  try {
    // Clean up likes for deleted posts
    const orphanedLikesSnapshot = await admin.firestore()
      .collectionGroup('likes')
      .limit(100)
      .get();
    
    const batch = admin.firestore().batch();
    let deletedCount = 0;
    
    for (const likeDoc of orphanedLikesSnapshot.docs) {
      const postId = likeDoc.ref.parent.parent?.id;
      if (postId) {
        const postDoc = await admin.firestore()
          .collection('posts')
          .doc(postId)
          .get();
        
        if (!postDoc.exists) {
          batch.delete(likeDoc.ref);
          deletedCount++;
        }
      }
    }
    
    if (deletedCount > 0) {
      await batch.commit();
      console.log(`Deleted ${deletedCount} orphaned likes`);
    }
  } catch (error) {
    console.error('Failed to cleanup orphaned data:', error);
  }
}

async function archiveOldLogs(): Promise<void> {
  try {
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    // Archive old error logs
    const oldLogsSnapshot = await admin.firestore()
      .collection('errorLogs')
      .where('timestamp', '<', admin.firestore.Timestamp.fromDate(sevenDaysAgo))
      .where('resolved', '==', true)
      .limit(100)
      .get();
    
    if (!oldLogsSnapshot.empty) {
      const batch = admin.firestore().batch();
      
      oldLogsSnapshot.docs.forEach(doc => {
        // Move to archive collection
        batch.set(
          admin.firestore().collection('archivedLogs').doc(doc.id),
          doc.data()
        );
        
        // Delete from active logs
        batch.delete(doc.ref);
      });
      
      await batch.commit();
      console.log(`Archived ${oldLogsSnapshot.size} old logs`);
    }
  } catch (error) {
    console.error('Failed to archive old logs:', error);
  }
}

async function updateDailyStatistics(): Promise<void> {
  try {
    const today = new Date();
    const todayString = today.toISOString().split('T')[0];
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayTimestamp = admin.firestore.Timestamp.fromDate(yesterday);
    
    // Count new users
    const newUsersSnapshot = await admin.firestore()
      .collection('users')
      .where('createdAt', '>=', yesterdayTimestamp)
      .get();
    
    // Count new posts
    const newPostsSnapshot = await admin.firestore()
      .collection('posts')
      .where('createdAt', '>=', yesterdayTimestamp)
      .get();
    
    // Count total users
    const totalUsersSnapshot = await admin.firestore()
      .collection('users')
      .where('isActive', '==', true)
      .get();
    
    // Count total posts
    const totalPostsSnapshot = await admin.firestore()
      .collection('posts')
      .get();
    
    // Save daily statistics
    await admin.firestore()
      .collection('dailyStats')
      .doc(todayString)
      .set({
        date: todayString,
        newUsers: newUsersSnapshot.size,
        newPosts: newPostsSnapshot.size,
        totalUsers: totalUsersSnapshot.size,
        totalPosts: totalPostsSnapshot.size,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log(`Updated daily statistics for ${todayString}`);
  } catch (error) {
    console.error('Failed to update daily statistics:', error);
  }
}

async function cleanupInvalidTokens(): Promise<void> {
  try {
    // This would typically use FCM token validation
    // For now, we'll remove tokens that are too old
    const oneMonthAgo = new Date();
    oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
    
    const usersSnapshot = await admin.firestore()
      .collection('users')
      .where('lastTokenUpdate', '<', admin.firestore.Timestamp.fromDate(oneMonthAgo))
      .limit(100)
      .get();
    
    if (!usersSnapshot.empty) {
      const batch = admin.firestore().batch();
      
      usersSnapshot.docs.forEach(doc => {
        batch.update(doc.ref, {
          fcmTokens: [],
          lastTokenCleanup: admin.firestore.FieldValue.serverTimestamp(),
        });
      });
      
      await batch.commit();
      console.log(`Cleaned up tokens for ${usersSnapshot.size} users`);
    }
  } catch (error) {
    console.error('Failed to cleanup invalid tokens:', error);
  }
}

async function processPendingNotifications(): Promise<void> {
  try {
    // Process notifications that failed to send
    const pendingNotificationsSnapshot = await admin.firestore()
      .collection('pendingNotifications')
      .where('status', '==', 'pending')
      .limit(50)
      .get();
    
    for (const doc of pendingNotificationsSnapshot.docs) {
      const notificationData = doc.data();
      
      try {
        await NotificationService.sendNotificationToUser(notificationData);
        
        // Mark as completed
        await doc.ref.update({
          status: 'completed',
          completedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      } catch (error) {
        // Mark as failed
        await doc.ref.update({
          status: 'failed',
          failedAt: admin.firestore.FieldValue.serverTimestamp(),
          error: error instanceof Error ? error.message : String(error),
          retryCount: admin.firestore.FieldValue.increment(1),
        });
      }
    }
    
    console.log(`Processed ${pendingNotificationsSnapshot.size} pending notifications`);
  } catch (error) {
    console.error('Failed to process pending notifications:', error);
  }
}

async function generateWeeklyUserAnalytics(): Promise<void> {
  try {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
    const weekAgoTimestamp = admin.firestore.Timestamp.fromDate(oneWeekAgo);
    
    // Get weekly active users
    const activeUsersSnapshot = await admin.firestore()
      .collection('users')
      .where('lastSeenAt', '>=', weekAgoTimestamp)
      .get();
    
    // Calculate engagement metrics
    const engagementSnapshot = await admin.firestore()
      .collection('analytics')
      .where('timestamp', '>=', weekAgoTimestamp)
      .get();
    
    const eventCounts: Record<string, number> = {};
    engagementSnapshot.docs.forEach(doc => {
      const eventName = doc.data().eventName;
      eventCounts[eventName] = (eventCounts[eventName] || 0) + 1;
    });
    
    // Save weekly analytics
    const weekString = oneWeekAgo.toISOString().split('T')[0];
    await admin.firestore()
      .collection('weeklyAnalytics')
      .doc(weekString)
      .set({
        weekStarting: weekString,
        activeUsers: activeUsersSnapshot.size,
        eventCounts: eventCounts,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log(`Generated weekly user analytics for week of ${weekString}`);
  } catch (error) {
    console.error('Failed to generate weekly user analytics:', error);
  }
}

async function generateWeeklyContentAnalytics(): Promise<void> {
  try {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
    const weekAgoTimestamp = admin.firestore.Timestamp.fromDate(oneWeekAgo);
    
    // Count weekly posts
    const weeklyPostsSnapshot = await admin.firestore()
      .collection('posts')
      .where('createdAt', '>=', weekAgoTimestamp)
      .get();
    
    // Count weekly comments
    const weeklyCommentsSnapshot = await admin.firestore()
      .collectionGroup('comments')
      .where('createdAt', '>=', weekAgoTimestamp)
      .get();
    
    // Count weekly likes
    const weeklyLikesSnapshot = await admin.firestore()
      .collectionGroup('likes')
      .where('createdAt', '>=', weekAgoTimestamp)
      .get();
    
    const weekString = oneWeekAgo.toISOString().split('T')[0];
    await admin.firestore()
      .collection('weeklyContentAnalytics')
      .doc(weekString)
      .set({
        weekStarting: weekString,
        newPosts: weeklyPostsSnapshot.size,
        newComments: weeklyCommentsSnapshot.size,
        newLikes: weeklyLikesSnapshot.size,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log(`Generated weekly content analytics for week of ${weekString}`);
  } catch (error) {
    console.error('Failed to generate weekly content analytics:', error);
  }
}

async function updateTrendingHashtags(): Promise<void> {
  try {
    const oneDayAgo = new Date();
    oneDayAgo.setDate(oneDayAgo.getDate() - 1);
    
    // Get trending hashtags
    const trendsSnapshot = await admin.firestore()
      .collection('trends')
      .where('lastUsed', '>=', admin.firestore.Timestamp.fromDate(oneDayAgo))
      .orderBy('count', 'desc')
      .limit(50)
      .get();
    
    const trendingHashtags = trendsSnapshot.docs.map(doc => ({
      hashtag: doc.data().hashtag,
      count: doc.data().count,
      rank: 0, // Will be set below
    }));
    
    // Assign ranks
    trendingHashtags.forEach((tag, index) => {
      tag.rank = index + 1;
    });
    
    // Save trending hashtags
    await admin.firestore()
      .collection('trending')
      .doc('hashtags')
      .set({
        hashtags: trendingHashtags,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        period: '24h',
      });
    
    console.log(`Updated trending hashtags: ${trendingHashtags.length} tags`);
  } catch (error) {
    console.error('Failed to update trending hashtags:', error);
  }
}

async function sendWeeklyReportsToAdmins(): Promise<void> {
  try {
    // Get admins
    const adminsSnapshot = await admin.firestore()
      .collection('users')
      .where('role', '==', 'admin')
      .get();
    
    if (adminsSnapshot.empty) {
      console.log('No admins found to send weekly reports');
      return;
    }
    
    // Generate report summary
    const reportData = await generateWeeklyReportData();
    
    // Send notifications to admins
    const promises = adminsSnapshot.docs.map(doc =>
      NotificationService.sendNotificationToUser({
        targetUserId: doc.id,
        type: 'system_alert' as any,
        title: '📊 Weekly Report Available',
        body: `Weekly analytics report is ready for review`,
        data: {
          reportType: 'weekly_analytics',
          reportData: reportData,
        },
        priority: 'normal',
      }).catch(error => {
        console.error(`Failed to send weekly report to admin ${doc.id}:`, error);
      })
    );
    
    await Promise.allSettled(promises);
    console.log(`Sent weekly reports to ${adminsSnapshot.size} admins`);
  } catch (error) {
    console.error('Failed to send weekly reports to admins:', error);
  }
}

async function generateWeeklyReportData(): Promise<any> {
  try {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
    
    // Get basic stats
    const stats = await admin.firestore()
      .collection('weeklyAnalytics')
      .orderBy('timestamp', 'desc')
      .limit(1)
      .get();
    
    return stats.empty ? {} : stats.docs[0].data();
  } catch (error) {
    console.error('Failed to generate weekly report data:', error);
    return {};
  }
}

async function checkSystemHealth(): Promise<{
  healthy: boolean;
  issues: string[];
  timestamp: Date;
}> {
  const issues: string[] = [];
  const timestamp = new Date();
  
  try {
    // Check Firestore connectivity
    await admin.firestore().collection('health').doc('test').get();
  } catch (error) {
    issues.push('Firestore connectivity issue');
  }
  
  try {
    // Check error rates
    const recentErrorsSnapshot = await admin.firestore()
      .collection('errorLogs')
      .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(
        new Date(Date.now() - 60 * 60 * 1000) // Last hour
      ))
      .get();
    
    if (recentErrorsSnapshot.size > 100) {
      issues.push('High error rate detected');
    }
  } catch (error) {
    issues.push('Unable to check error rates');
  }
  
  return {
    healthy: issues.length === 0,
    issues,
    timestamp,
  };
}

async function sendAdminAlert(title: string, error: any): Promise<void> {
  try {
    const adminsSnapshot = await admin.firestore()
      .collection('users')
      .where('role', '==', 'admin')
      .get();
    
    const promises = adminsSnapshot.docs.map(doc =>
      NotificationService.sendNotificationToUser({
        targetUserId: doc.id,
        type: 'system_alert' as any,
        title: `🚨 ${title}`,
        body: `System alert: ${error instanceof Error ? error.message : String(error)}`,
        data: {
          alertType: 'system_error',
          error: error instanceof Error ? error.message : String(error),
        },
        priority: 'high',
      }).catch(err => {
        console.error(`Failed to send admin alert to ${doc.id}:`, err);
      })
    );
    
    await Promise.allSettled(promises);
  } catch (error) {
    console.error('Failed to send admin alert:', error);
  }
}
