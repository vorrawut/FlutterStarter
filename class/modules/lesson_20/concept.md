# ☁️ Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **Cloud Functions Excellence** - Serverless backend logic with Firebase Functions and Google Cloud
- **Push Notifications Mastery** - Firebase Cloud Messaging (FCM) for real-time user engagement
- **Event-Driven Architecture** - Trigger-based functions responding to Firebase events
- **Background Processing** - Automated tasks, data processing, and scheduled operations
- **Integration Patterns** - Seamless integration with Firebase Auth, Firestore, and Storage
- **Security & Scalability** - Production-ready serverless functions with proper authentication
- **Testing & Deployment** - Comprehensive testing strategies and automated deployment pipelines
- **Performance Optimization** - Efficient function design, cold start mitigation, and cost optimization

## 🚀 **Cloud Functions Overview**

### **What are Cloud Functions?**

Cloud Functions provide serverless backend capabilities that automatically scale based on demand:

```dart
// Cloud Functions Value Proposition
class CloudFunctionsAdvantages {
  static const benefits = [
    '⚡ Serverless Execution - No server management required',
    '🔄 Event-Driven - Respond to Firebase and HTTP triggers',
    '📈 Auto-Scaling - Scale from zero to millions of requests',
    '💰 Pay-per-Use - Only pay for actual execution time',
    '🔐 Secure by Default - Built-in authentication and authorization',
    '🌐 Global Distribution - Run on Google Cloud infrastructure',
    '🛠️ Rich Ecosystem - Integration with all Firebase services',
    '📊 Monitoring Built-in - Logging, metrics, and error tracking',
  ];

  // Function Types and Triggers
  static const functionTypes = {
    'HTTP Functions': 'REST API endpoints and webhooks',
    'Firestore Triggers': 'Respond to database changes',
    'Authentication Triggers': 'React to user lifecycle events',
    'Storage Triggers': 'Process file uploads and changes',
    'Pub/Sub Triggers': 'Handle message queue events',
    'Scheduled Functions': 'Cron-like scheduled execution',
    'Analytics Triggers': 'Respond to user behavior events',
    'Remote Config Triggers': 'Handle configuration changes',
  };
}
```

### **Cloud Functions Architecture Patterns**

```dart
// Complete Function Architecture
class CloudFunctionArchitecture {
  // Function Organization
  static const organizationPatterns = {
    'Microservices': 'Single responsibility functions',
    'Monolithic': 'Combined functionality in fewer functions',
    'Event-Driven': 'Reactive functions responding to events',
    'API Gateway': 'HTTP functions as API endpoints',
    'Background Tasks': 'Asynchronous processing functions',
    'Scheduled Jobs': 'Time-based automated functions',
  };

  // Integration Layers
  static const integrationLayers = [
    'Firebase Services Layer - Direct Firebase SDK integration',
    'External APIs Layer - Third-party service integration', 
    'Data Processing Layer - ETL and transformation operations',
    'Notification Layer - Push notifications and communications',
    'Analytics Layer - Data analysis and reporting',
    'Security Layer - Authentication and authorization',
  ];

  // Deployment Strategies
  static const deploymentStrategies = {
    'Development': 'Firebase emulator for local testing',
    'Staging': 'Isolated Firebase project for testing',
    'Production': 'Live Firebase project with monitoring',
    'CI/CD': 'Automated testing and deployment pipeline',
  };
}
```

## ☁️ **Cloud Functions Deep Dive**

### **Function Types and Triggers**

Cloud Functions support multiple trigger types for different use cases:

```typescript
// functions/src/index.ts - Complete Function Examples

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// 1. HTTP Triggered Functions (REST API)
export const api = functions.https.onRequest(async (req, res) => {
  // Set CORS headers
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  try {
    // Route handling
    const { path, method } = req;
    
    switch (method) {
      case 'GET':
        await handleGetRequest(req, res);
        break;
      case 'POST':
        await handlePostRequest(req, res);
        break;
      default:
        res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('API Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// 2. Firestore Triggered Functions
export const onUserCreate = functions.firestore
  .document('users/{userId}')
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const userData = snapshot.data();
    
    try {
      // Initialize user data
      await initializeNewUser(userId, userData);
      
      // Send welcome notification
      await sendWelcomeNotification(userId, userData);
      
      // Update analytics
      await updateUserAnalytics('user_created', userData);
      
      console.log(`User ${userId} successfully initialized`);
    } catch (error) {
      console.error(`Failed to initialize user ${userId}:`, error);
      throw error;
    }
  });

export const onPostCreate = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const postData = snapshot.data();
    
    try {
      // Process post content
      await processPostContent(postId, postData);
      
      // Notify followers
      await notifyFollowers(postData.authorId, postId, postData);
      
      // Update user post count
      await updateUserPostCount(postData.authorId, 1);
      
      // Extract and save hashtags
      await processHashtags(postId, postData.hashtags);
      
    } catch (error) {
      console.error(`Failed to process post ${postId}:`, error);
    }
  });

export const onPostUpdate = functions.firestore
  .document('posts/{postId}')
  .onUpdate(async (change, context) => {
    const postId = context.params.postId;
    const beforeData = change.before.data();
    const afterData = change.after.data();
    
    // Check what changed
    const likesChanged = beforeData.likesCount !== afterData.likesCount;
    const contentChanged = beforeData.content !== afterData.content;
    
    if (contentChanged) {
      // Reprocess content for moderation
      await moderatePostContent(postId, afterData);
    }
    
    if (likesChanged && afterData.likesCount > beforeData.likesCount) {
      // Notify post author of new like
      await notifyPostLike(afterData.authorId, postId);
    }
  });

// 3. Authentication Triggered Functions
export const onUserSignUp = functions.auth.user().onCreate(async (user) => {
  try {
    // Create user profile in Firestore
    await admin.firestore().collection('users').doc(user.uid).set({
      email: user.email,
      displayName: user.displayName || '',
      photoURL: user.photoURL || '',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      isActive: true,
      settings: {
        notifications: true,
        privacy: 'public',
        theme: 'system',
      },
    });
    
    // Send welcome email
    await sendWelcomeEmail(user);
    
    // Initialize user preferences
    await initializeUserPreferences(user.uid);
    
    console.log(`User profile created for ${user.uid}`);
  } catch (error) {
    console.error(`Failed to process user signup for ${user.uid}:`, error);
  }
});

export const onUserDelete = functions.auth.user().onDelete(async (user) => {
  try {
    // Delete user data (GDPR compliance)
    await deleteUserData(user.uid);
    
    // Update related content
    await anonymizeUserContent(user.uid);
    
    // Log deletion for audit
    await logUserDeletion(user.uid);
    
    console.log(`User ${user.uid} successfully deleted`);
  } catch (error) {
    console.error(`Failed to process user deletion for ${user.uid}:`, error);
  }
});

// 4. Storage Triggered Functions
export const onFileUpload = functions.storage.object().onFinalize(async (object) => {
  const fileBucket = object.bucket;
  const filePath = object.name!;
  const contentType = object.contentType;
  
  // Only process images
  if (!contentType?.startsWith('image/')) {
    console.log('File is not an image');
    return;
  }
  
  try {
    // Generate thumbnails
    await generateImageThumbnails(fileBucket, filePath);
    
    // Extract metadata
    await extractImageMetadata(fileBucket, filePath);
    
    // Update file record in Firestore
    await updateFileRecord(filePath, object);
    
    console.log(`Image processed: ${filePath}`);
  } catch (error) {
    console.error(`Failed to process image ${filePath}:`, error);
  }
});

// 5. Scheduled Functions (Cron Jobs)
export const dailyCleanup = functions.pubsub
  .schedule('0 2 * * *') // Daily at 2 AM
  .timeZone('UTC')
  .onRun(async (context) => {
    try {
      // Clean up expired sessions
      await cleanupExpiredSessions();
      
      // Archive old notifications
      await archiveOldNotifications();
      
      // Update user statistics
      await updateDailyStatistics();
      
      // Generate daily reports
      await generateDailyReports();
      
      console.log('Daily cleanup completed successfully');
    } catch (error) {
      console.error('Daily cleanup failed:', error);
    }
  });

export const weeklyAnalytics = functions.pubsub
  .schedule('0 0 * * 0') // Weekly on Sunday at midnight
  .timeZone('UTC')
  .onRun(async (context) => {
    try {
      // Generate weekly user analytics
      await generateWeeklyAnalytics();
      
      // Send admin reports
      await sendWeeklyReports();
      
      // Update trending content
      await updateTrendingContent();
      
      console.log('Weekly analytics completed');
    } catch (error) {
      console.error('Weekly analytics failed:', error);
    }
  });

// Helper Functions
async function initializeNewUser(userId: string, userData: any) {
  // Create user preferences
  await admin.firestore().collection('users').doc(userId).collection('preferences').doc('default').set({
    notifications: {
      email: true,
      push: true,
      inApp: true,
    },
    privacy: {
      profileVisibility: 'public',
      showEmail: false,
      showPhone: false,
    },
    theme: 'system',
    language: 'en',
  });
  
  // Initialize user counters
  await admin.firestore().collection('users').doc(userId).update({
    followersCount: 0,
    followingCount: 0,
    postsCount: 0,
  });
}

async function sendWelcomeNotification(userId: string, userData: any) {
  // Send push notification
  const message = {
    notification: {
      title: 'Welcome to SocialHub Pro!',
      body: `Hi ${userData.displayName || 'there'}! Start connecting with friends.`,
    },
    data: {
      type: 'welcome',
      userId: userId,
    },
    topic: `user_${userId}`,
  };
  
  await admin.messaging().send(message);
}

async function processPostContent(postId: string, postData: any) {
  // Content moderation
  const moderationResult = await moderateContent(postData.content);
  
  if (moderationResult.inappropriate) {
    // Flag post for review
    await admin.firestore().collection('posts').doc(postId).update({
      status: 'under_review',
      moderationFlags: moderationResult.flags,
    });
    
    // Notify moderators
    await notifyModerators(postId, moderationResult);
  }
  
  // Extract mentions and hashtags
  const mentions = extractMentions(postData.content);
  const hashtags = extractHashtags(postData.content);
  
  // Update post with extracted data
  await admin.firestore().collection('posts').doc(postId).update({
    mentions: mentions,
    hashtags: hashtags,
    processed: true,
  });
}

async function notifyFollowers(authorId: string, postId: string, postData: any) {
  // Get followers
  const followersSnapshot = await admin.firestore()
    .collection('follows')
    .where('followingId', '==', authorId)
    .where('isActive', '==', true)
    .get();
  
  const followerIds = followersSnapshot.docs.map(doc => doc.data().followerId);
  
  if (followerIds.length === 0) return;
  
  // Create notification for each follower
  const batch = admin.firestore().batch();
  
  followerIds.forEach(followerId => {
    const notificationRef = admin.firestore().collection('notifications').doc();
    batch.set(notificationRef, {
      userId: followerId,
      type: 'new_post',
      title: 'New Post',
      body: `${postData.authorName} shared a new post`,
      data: {
        postId: postId,
        authorId: authorId,
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isRead: false,
    });
  });
  
  await batch.commit();
  
  // Send push notifications
  await sendBulkPushNotifications(followerIds, {
    title: 'New Post',
    body: `${postData.authorName} shared a new post`,
    data: {
      type: 'new_post',
      postId: postId,
    },
  });
}
```

### **Advanced Function Patterns**

```typescript
// Advanced Cloud Function Patterns

// 1. Callable Functions (Client SDK Integration)
export const sendFriendRequest = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated to send friend requests'
    );
  }
  
  const { targetUserId } = data;
  const requesterId = context.auth.uid;
  
  // Validate input
  if (!targetUserId || typeof targetUserId !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Target user ID is required and must be a string'
    );
  }
  
  if (requesterId === targetUserId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Cannot send friend request to yourself'
    );
  }
  
  try {
    // Check if request already exists
    const existingRequest = await admin.firestore()
      .collection('friendRequests')
      .where('requesterId', '==', requesterId)
      .where('targetUserId', '==', targetUserId)
      .get();
    
    if (!existingRequest.empty) {
      throw new functions.https.HttpsError(
        'already-exists',
        'Friend request already sent'
      );
    }
    
    // Create friend request
    const requestRef = await admin.firestore().collection('friendRequests').add({
      requesterId: requesterId,
      targetUserId: targetUserId,
      status: 'pending',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    // Send notification
    await sendFriendRequestNotification(requesterId, targetUserId);
    
    return { success: true, requestId: requestRef.id };
  } catch (error) {
    console.error('Friend request error:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to send friend request'
    );
  }
});

// 2. Batch Processing Functions
export const processBulkNotifications = functions.https.onCall(async (data, context) => {
  // Admin only function
  if (!context.auth || !await isAdmin(context.auth.uid)) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Admin access required'
    );
  }
  
  const { notifications } = data;
  
  try {
    // Process in batches to avoid timeouts
    const batchSize = 500;
    const batches = [];
    
    for (let i = 0; i < notifications.length; i += batchSize) {
      const batch = notifications.slice(i, i + batchSize);
      batches.push(processBatch(batch));
    }
    
    const results = await Promise.allSettled(batches);
    
    return {
      total: notifications.length,
      successful: results.filter(r => r.status === 'fulfilled').length,
      failed: results.filter(r => r.status === 'rejected').length,
    };
  } catch (error) {
    console.error('Bulk notification error:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to process bulk notifications'
    );
  }
});

// 3. Data Aggregation Functions
export const updateUserStatistics = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot, context) => {
    const postData = snapshot.data();
    const authorId = postData.authorId;
    
    // Use transaction for consistency
    await admin.firestore().runTransaction(async (transaction) => {
      const userRef = admin.firestore().collection('users').doc(authorId);
      const userDoc = await transaction.get(userRef);
      
      if (!userDoc.exists) {
        throw new Error('User not found');
      }
      
      const currentStats = userDoc.data();
      const updatedStats = {
        postsCount: (currentStats?.postsCount || 0) + 1,
        lastPostAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      
      transaction.update(userRef, updatedStats);
    });
  });

// 4. External API Integration
export const syncWithExternalService = functions.pubsub
  .schedule('*/30 * * * *') // Every 30 minutes
  .onRun(async (context) => {
    try {
      // Get users who need sync
      const usersToSync = await getUsersNeedingSync();
      
      for (const user of usersToSync) {
        await syncUserWithExternalAPI(user);
      }
      
      console.log(`Synced ${usersToSync.length} users`);
    } catch (error) {
      console.error('External sync error:', error);
    }
  });

async function syncUserWithExternalAPI(user: any) {
  try {
    // Make external API call
    const response = await fetch(`https://api.external.com/users/${user.externalId}`, {
      headers: {
        'Authorization': `Bearer ${process.env.EXTERNAL_API_KEY}`,
        'Content-Type': 'application/json',
      },
    });
    
    if (!response.ok) {
      throw new Error(`API call failed: ${response.status}`);
    }
    
    const externalData = await response.json();
    
    // Update user data
    await admin.firestore().collection('users').doc(user.id).update({
      externalData: externalData,
      lastSyncAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
  } catch (error) {
    console.error(`Failed to sync user ${user.id}:`, error);
    
    // Log failed sync
    await admin.firestore().collection('syncErrors').add({
      userId: user.id,
      error: error.message,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
}

// 5. Error Handling and Monitoring
export const handleGlobalErrors = functions.crashlytics.issue().onNew(async (issue) => {
  const { issueId, appId } = issue;
  
  // Send alert to developers
  await sendDeveloperAlert({
    title: 'New Crashlytics Issue',
    message: `Issue ${issueId} detected in app ${appId}`,
    severity: 'high',
  });
  
  // Log to monitoring system
  await logToMonitoringSystem('crash', {
    issueId,
    appId,
    timestamp: new Date().toISOString(),
  });
});
```

## 📱 **Firebase Cloud Messaging (FCM) Deep Dive**

### **Push Notification Architecture**

Firebase Cloud Messaging provides reliable, cross-platform messaging:

```dart
// FCM Integration Overview
class FCMArchitecture {
  static const features = [
    '📱 Cross-Platform - iOS, Android, Web support',
    '🎯 Targeted Messaging - Individual users, groups, topics',
    '⚡ Real-Time Delivery - Instant message delivery',
    '📊 Analytics Integration - Delivery and engagement metrics',
    '🔒 Secure Messaging - End-to-end encryption support',
    '💰 Free Service - No cost for unlimited messages',
    '🌐 Global Infrastructure - Google Cloud delivery network',
    '🛠️ Rich Features - Custom data, actions, scheduling',
  ];

  // Notification Types
  static const notificationTypes = {
    'Data Messages': 'Custom data-only messages handled by app',
    'Notification Messages': 'Display notifications with title and body',
    'Mixed Messages': 'Combination of notification and data payload',
    'Topic Messages': 'Broadcast to subscribed users',
    'Conditional Messages': 'Target based on multiple conditions',
    'Scheduled Messages': 'Delivery at specific times',
  };
}
```

### **Flutter FCM Implementation**

```dart
// lib/services/fcm_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  // Initialize FCM service
  static Future<void> initialize() async {
    // Request permissions
    await _requestPermissions();
    
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // Set up message handlers
    await _setupMessageHandlers();
    
    // Get and save FCM token
    await _setupToken();
  }
  
  // Request notification permissions
  static Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('FCM Permission Status: ${settings.authorizationStatus}');
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  
  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }
  
  // Setup message handlers
  static Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    
    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
    // Handle initial message (app opened from notification)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }
  
  // Setup FCM token
  static Future<void> _setupToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveTokenToDatabase(token);
      print('FCM Token: $token');
    }
    
    // Listen for token refresh
    _messaging.onTokenRefresh.listen(_saveTokenToDatabase);
  }
  
  // Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}');
    
    // Show local notification
    await _showLocalNotification(message);
    
    // Update app state
    await _updateAppState(message);
    
    // Track analytics
    await _trackNotificationReceived(message);
  }
  
  // Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Received background message: ${message.messageId}');
    
    // Process data
    await _processBackgroundData(message);
    
    // Update local storage
    await _updateLocalStorage(message);
    
    // Track analytics
    await _trackNotificationReceived(message);
  }
  
  // Handle notification tap
  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    print('Notification tapped: ${message.messageId}');
    
    // Navigate to appropriate screen
    await _handleNotificationNavigation(message);
    
    // Track analytics
    await _trackNotificationOpened(message);
  }
  
  // Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    
    if (notification == null) return;
    
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2196F3),
      playSound: true,
      enableVibration: true,
    );
    
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    
    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(data),
    );
  }
  
  // Topic subscription management
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
      
      // Save subscription to database
      await _saveTopicSubscription(topic, true);
    } catch (e) {
      print('Failed to subscribe to topic $topic: $e');
    }
  }
  
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
      
      // Update subscription in database
      await _saveTopicSubscription(topic, false);
    } catch (e) {
      print('Failed to unsubscribe from topic $topic: $e');
    }
  }
  
  // Send notification via Cloud Function
  static Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendNotification');
      
      final result = await callable.call({
        'targetUserId': userId,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data ?? {},
      });
      
      print('Notification sent: ${result.data}');
    } catch (e) {
      print('Failed to send notification: $e');
    }
  }
  
  // Helper methods
  static Future<void> _saveTokenToDatabase(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
    }
  }
  
  static Future<void> _saveTopicSubscription(String topic, bool isSubscribed) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('subscriptions')
          .doc(topic)
          .set({
        'isSubscribed': isSubscribed,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
  
  static Future<void> _onNotificationTapped(NotificationResponse response) async {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      await _handleNotificationNavigation(RemoteMessage(data: data));
    }
  }
  
  static Future<void> _handleNotificationNavigation(RemoteMessage message) async {
    final data = message.data;
    final type = data['type'];
    
    switch (type) {
      case 'new_post':
        NavigationService.navigateToPost(data['postId']);
        break;
      case 'friend_request':
        NavigationService.navigateToFriendRequests();
        break;
      case 'new_message':
        NavigationService.navigateToChat(data['chatId']);
        break;
      case 'like':
        NavigationService.navigateToPost(data['postId']);
        break;
      default:
        NavigationService.navigateToHome();
    }
  }
  
  static Future<void> _updateAppState(RemoteMessage message) async {
    // Update relevant providers based on notification type
    final type = message.data['type'];
    
    switch (type) {
      case 'new_message':
        // Refresh chat state
        ChatProvider.refreshMessages(message.data['chatId']);
        break;
      case 'new_post':
        // Refresh feed
        FeedProvider.refreshFeed();
        break;
      case 'friend_request':
        // Refresh friend requests
        SocialProvider.refreshFriendRequests();
        break;
    }
  }
  
  static Future<void> _trackNotificationReceived(RemoteMessage message) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'notification_received',
      parameters: {
        'message_id': message.messageId ?? '',
        'type': message.data['type'] ?? 'unknown',
        'from': message.from ?? '',
      },
    );
  }
  
  static Future<void> _trackNotificationOpened(RemoteMessage message) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'notification_opened',
      parameters: {
        'message_id': message.messageId ?? '',
        'type': message.data['type'] ?? 'unknown',
      },
    );
  }
}
```

### **Advanced Push Notification Patterns**

```typescript
// functions/src/notifications.ts - Advanced Notification System

interface NotificationTemplate {
  title: string;
  body: string;
  icon?: string;
  color?: string;
  sound?: string;
  badge?: number;
  data?: Record<string, any>;
}

interface NotificationTarget {
  type: 'user' | 'topic' | 'condition' | 'tokens';
  value: string | string[];
}

class NotificationService {
  
  // Send targeted notifications
  static async sendNotification(
    target: NotificationTarget,
    template: NotificationTemplate,
    options: {
      priority?: 'high' | 'normal';
      timeToLive?: number;
      collapseKey?: string;
      restrictedPackageName?: string;
    } = {}
  ): Promise<string> {
    
    const message: admin.messaging.Message = {
      notification: {
        title: template.title,
        body: template.body,
        imageUrl: template.icon,
      },
      data: template.data || {},
      android: {
        notification: {
          icon: template.icon || 'ic_notification',
          color: template.color || '#2196F3',
          sound: template.sound || 'default',
          priority: options.priority || 'high',
          defaultSound: true,
          defaultVibrateTimings: true,
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
        },
        fcmOptions: {
          link: template.data?.link,
        },
      },
    };

    // Set target
    switch (target.type) {
      case 'user':
        const userTokens = await this.getUserTokens(target.value as string);
        if (userTokens.length > 0) {
          message.tokens = userTokens;
        } else {
          throw new Error('No tokens found for user');
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
      const response = await admin.messaging().send(message);
      console.log('Notification sent successfully:', response);
      
      // Log notification
      await this.logNotification(target, template, response);
      
      return response;
    } catch (error) {
      console.error('Failed to send notification:', error);
      throw error;
    }
  }

  // Bulk notification sending
  static async sendBulkNotifications(
    notifications: Array<{
      target: NotificationTarget;
      template: NotificationTemplate;
    }>,
    batchSize: number = 500
  ): Promise<void> {
    
    const batches = [];
    for (let i = 0; i < notifications.length; i += batchSize) {
      batches.push(notifications.slice(i, i + batchSize));
    }

    for (const batch of batches) {
      const promises = batch.map(({ target, template }) =>
        this.sendNotification(target, template).catch(error => {
          console.error('Batch notification failed:', error);
          return null;
        })
      );

      await Promise.allSettled(promises);
    }
  }

  // Scheduled notifications
  static async scheduleNotification(
    target: NotificationTarget,
    template: NotificationTemplate,
    scheduleTime: Date
  ): Promise<string> {
    
    // Store scheduled notification
    const scheduledNotification = {
      target,
      template,
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

  // Process scheduled notifications (called by cron job)
  static async processScheduledNotifications(): Promise<void> {
    const now = admin.firestore.Timestamp.now();
    
    const scheduledSnapshot = await admin.firestore()
      .collection('scheduledNotifications')
      .where('scheduleTime', '<=', now)
      .where('status', '==', 'scheduled')
      .get();

    for (const doc of scheduledSnapshot.docs) {
      const data = doc.data();
      
      try {
        await this.sendNotification(data.target, data.template);
        
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
          error: error.message,
          failedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // Notification templates
  static getTemplate(type: string, data: Record<string, any>): NotificationTemplate {
    const templates: Record<string, (data: any) => NotificationTemplate> = {
      
      new_post: (data) => ({
        title: 'New Post',
        body: `${data.authorName} shared a new post`,
        icon: data.authorAvatar,
        data: {
          type: 'new_post',
          postId: data.postId,
          authorId: data.authorId,
        },
      }),

      new_like: (data) => ({
        title: 'New Like',
        body: `${data.likerName} liked your post`,
        icon: data.likerAvatar,
        data: {
          type: 'new_like',
          postId: data.postId,
          likerId: data.likerId,
        },
      }),

      new_comment: (data) => ({
        title: 'New Comment',
        body: `${data.commenterName} commented on your post`,
        icon: data.commenterAvatar,
        data: {
          type: 'new_comment',
          postId: data.postId,
          commentId: data.commentId,
          commenterId: data.commenterId,
        },
      }),

      friend_request: (data) => ({
        title: 'Friend Request',
        body: `${data.requesterName} sent you a friend request`,
        icon: data.requesterAvatar,
        data: {
          type: 'friend_request',
          requestId: data.requestId,
          requesterId: data.requesterId,
        },
      }),

      new_message: (data) => ({
        title: data.senderName,
        body: data.messagePreview,
        icon: data.senderAvatar,
        data: {
          type: 'new_message',
          chatId: data.chatId,
          messageId: data.messageId,
          senderId: data.senderId,
        },
      }),

    };

    const template = templates[type];
    if (!template) {
      throw new Error(`Unknown notification template: ${type}`);
    }

    return template(data);
  }

  // Helper methods
  private static async getUserTokens(userId: string): Promise<string[]> {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(userId)
      .get();

    if (!userDoc.exists) {
      return [];
    }

    const userData = userDoc.data();
    return userData?.fcmTokens || [];
  }

  private static async logNotification(
    target: NotificationTarget,
    template: NotificationTemplate,
    messageId: string
  ): Promise<void> {
    await admin.firestore().collection('notificationLogs').add({
      target,
      template,
      messageId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
}

// Export callable function
export const sendNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { targetUserId, type, notificationData } = data;
  
  try {
    const template = NotificationService.getTemplate(type, notificationData);
    const target: NotificationTarget = { type: 'user', value: targetUserId };
    
    const messageId = await NotificationService.sendNotification(target, template);
    
    return { success: true, messageId };
  } catch (error) {
    console.error('Send notification error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
});
```

## 🏗️ **Integration with Existing Firebase Architecture**

### **Clean Architecture with Cloud Functions**

```dart
// lib/data/repositories/cloud_repository_impl.dart
abstract class CloudRepository {
  Future<Result<void>> sendNotification({
    required String userId,
    required String type,
    required Map<String, dynamic> data,
  });
  
  Future<Result<List<Notification>>> getUserNotifications(String userId);
  Future<Result<void>> markNotificationAsRead(String notificationId);
  Future<Result<void>> subscribeToTopic(String topic);
  Future<Result<void>> unsubscribeFromTopic(String topic);
}

class CloudRepositoryImpl implements CloudRepository {
  final CloudRemoteDataSource _remoteDataSource;
  final CloudLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  CloudRepositoryImpl({
    required CloudRemoteDataSource remoteDataSource,
    required CloudLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<void>> sendNotification({
    required String userId,
    required String type,
    required Map<String, dynamic> data,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        // Queue notification for later
        await _localDataSource.queueNotification(userId, type, data);
        return Result.success(null);
      }

      await _remoteDataSource.sendNotification(
        userId: userId,
        type: type,
        data: data,
      );

      return Result.success(null);
    } catch (e) {
      return Result.failure(CloudException(e.toString()));
    }
  }

  @override
  Future<Result<List<Notification>>> getUserNotifications(String userId) async {
    try {
      // Get cached notifications
      final cachedNotifications = await _localDataSource.getNotifications(userId);
      
      if (await _networkInfo.isConnected) {
        // Fetch latest from server
        final serverNotifications = await _remoteDataSource.getUserNotifications(userId);
        
        // Update cache
        await _localDataSource.cacheNotifications(userId, serverNotifications);
        
        return Result.success(serverNotifications);
      }
      
      return Result.success(cachedNotifications);
    } catch (e) {
      return Result.failure(CloudException(e.toString()));
    }
  }
}

// Use Cases
class SendNotificationUseCase {
  final CloudRepository _repository;

  SendNotificationUseCase(this._repository);

  Future<Result<void>> execute({
    required String userId,
    required NotificationType type,
    required Map<String, dynamic> data,
  }) async {
    return await _repository.sendNotification(
      userId: userId,
      type: type.toString(),
      data: data,
    );
  }
}

enum NotificationType {
  newPost,
  newLike,
  newComment,
  friendRequest,
  newMessage,
}
```

## 🧪 **Testing Cloud Functions and FCM**

### **Testing Strategies**

```typescript
// functions/src/__tests__/notifications.test.ts
import * as admin from 'firebase-admin';
import * as test from 'firebase-functions-test';

const testEnv = test();

describe('Notification Functions', () => {
  beforeAll(() => {
    // Initialize admin SDK
    admin.initializeApp();
  });

  afterAll(() => {
    testEnv.cleanup();
  });

  describe('sendNotification', () => {
    it('should send notification to valid user', async () => {
      const data = {
        targetUserId: 'test-user-id',
        type: 'new_post',
        notificationData: {
          authorName: 'Test User',
          postId: 'test-post-id',
        },
      };

      const context = {
        auth: { uid: 'sender-user-id' },
      };

      const result = await sendNotification(data, context);

      expect(result.success).toBe(true);
      expect(result.messageId).toBeDefined();
    });

    it('should reject unauthenticated requests', async () => {
      const data = {
        targetUserId: 'test-user-id',
        type: 'new_post',
        notificationData: {},
      };

      await expect(sendNotification(data, {})).rejects.toThrow();
    });
  });

  describe('onUserCreate', () => {
    it('should initialize new user on creation', async () => {
      const userData = {
        email: 'test@example.com',
        displayName: 'Test User',
      };

      const snap = testEnv.firestore.makeDocumentSnapshot(userData, 'users/test-user-id');
      const context = { params: { userId: 'test-user-id' } };

      await onUserCreate(snap, context);

      // Verify user initialization
      // Add assertions here
    });
  });
});

// Flutter Integration Tests
// test/integration/fcm_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FCM Integration Tests', () {
    testWidgets('should receive and handle notifications', (tester) async {
      // Setup notification handler
      bool notificationReceived = false;
      
      FirebaseMessaging.onMessage.listen((message) {
        notificationReceived = true;
      });

      // Trigger notification from test backend
      await triggerTestNotification();

      // Wait for notification
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(notificationReceived, isTrue);
    });

    testWidgets('should navigate correctly on notification tap', (tester) async {
      // Setup navigation spy
      String? navigatedRoute;
      
      NavigationService.setTestNavigationCallback((route) {
        navigatedRoute = route;
      });

      // Simulate notification tap
      await simulateNotificationTap({
        'type': 'new_post',
        'postId': 'test-post-id',
      });

      await tester.pumpAndSettle();

      expect(navigatedRoute, equals('/post/test-post-id'));
    });
  });
}
```

## 🚀 **Best Practices Summary**

### **1. Cloud Functions Development**
- **Single Responsibility** - Each function should have one clear purpose
- **Error Handling** - Comprehensive error handling with proper logging
- **Performance Optimization** - Minimize cold starts and execution time
- **Security First** - Validate all inputs and implement proper authentication

### **2. Push Notification Strategy**
- **User Consent** - Always request permission appropriately
- **Personalization** - Tailor notifications based on user preferences
- **Timing Optimization** - Send notifications at optimal times for engagement
- **Analytics Integration** - Track delivery, open rates, and user engagement

### **3. Integration Patterns**
- **Event-Driven Design** - Use Firebase triggers for reactive functions
- **Batch Processing** - Handle bulk operations efficiently
- **Retry Logic** - Implement robust retry mechanisms for failed operations
- **Monitoring** - Comprehensive logging and monitoring for production

### **4. Testing Excellence**
- **Unit Testing** - Test individual functions in isolation
- **Integration Testing** - Test end-to-end functionality with Firebase services
- **Load Testing** - Verify performance under high traffic
- **Security Testing** - Validate authentication and authorization

### **5. Production Considerations**
- **Cost Optimization** - Monitor and optimize function execution costs
- **Scalability Planning** - Design functions to handle traffic spikes
- **Deployment Strategy** - Use staged deployments with proper testing
- **Monitoring & Alerting** - Set up comprehensive monitoring and alerting

Cloud Functions and Firebase Cloud Messaging provide powerful serverless backend capabilities that enable building scalable, real-time applications with professional notification systems, automated background processing, and seamless integration with the broader Firebase ecosystem.

**Ready to build serverless backends with intelligent push notifications and event-driven architecture! ☁️📱✨**