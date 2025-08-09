# ☁️ Lesson 20: Cloud Functions + Push Notifications - Workshop

## 🎯 **What We're Building**

Enhance **SocialHub Pro** from Lesson 19 with advanced serverless backend capabilities, including:
- **☁️ Cloud Functions Backend** - Serverless functions for automated tasks and business logic
- **📱 Push Notifications System** - Firebase Cloud Messaging (FCM) for real-time user engagement
- **🔔 Smart Notification Engine** - Intelligent, personalized notifications with templates
- **⚡ Event-Driven Architecture** - Reactive functions responding to Firebase events
- **🤖 Background Processing** - Automated moderation, analytics, and maintenance tasks
- **🧪 Comprehensive Testing** - Cloud Functions testing with emulators and integration tests

## ✅ **Expected Outcome**

A production-ready social platform with serverless backend capabilities:
- ☁️ **Serverless Excellence** - Cloud Functions handling backend logic and automation
- 📱 **Push Notification Mastery** - Intelligent FCM integration with personalized messaging
- 🔔 **Real-Time Engagement** - Live notifications for social interactions and updates
- ⚡ **Performance Optimization** - Efficient serverless functions with minimal cold starts
- 🤖 **Automated Operations** - Background tasks for moderation, cleanup, and analytics
- 🧪 **Testing Excellence** - Comprehensive testing with Firebase emulators

## 🏗️ **Project Architecture Enhancement**

Building on SocialHub Pro from Lesson 19, we'll add serverless backend capabilities:

```
socialhub_pro/ (Enhanced with Cloud Functions)
├── functions/                         # ☁️ Cloud Functions backend
│   ├── src/
│   │   ├── index.ts                   # Main functions export
│   │   ├── notifications/             # Notification functions
│   │   │   ├── notification-service.ts # Notification management
│   │   │   ├── templates.ts           # Notification templates
│   │   │   └── triggers.ts            # Notification triggers
│   │   ├── social/                    # Social feature functions
│   │   │   ├── post-functions.ts      # Post-related functions
│   │   │   ├── user-functions.ts      # User management functions
│   │   │   └── analytics.ts           # Social analytics
│   │   ├── background/                # Background processing
│   │   │   ├── cleanup.ts             # Data cleanup tasks
│   │   │   ├── moderation.ts          # Content moderation
│   │   │   └── analytics.ts           # Background analytics
│   │   ├── utils/                     # Utility functions
│   │   │   ├── auth.ts                # Authentication helpers
│   │   │   ├── validation.ts          # Data validation
│   │   │   └── helpers.ts             # Common utilities
│   │   └── types/                     # TypeScript type definitions
│   ├── package.json                   # Function dependencies
│   ├── tsconfig.json                  # TypeScript configuration
│   └── .env.example                   # Environment variables template
├── lib/ (Enhanced Flutter App)
│   ├── services/
│   │   ├── fcm_service.dart           # FCM integration service
│   │   ├── cloud_functions_service.dart # Cloud Functions client
│   │   └── notification_service.dart  # Local notification handling
│   ├── models/
│   │   ├── notification_model.dart    # Notification data models
│   │   └── cloud_response_model.dart  # Cloud function response models
│   └── presentation/
│       ├── pages/
│       │   ├── notifications/         # Notification management screens
│       │   └── settings/             # Enhanced settings with notification preferences
│       └── widgets/
│           ├── notification_widgets.dart # Notification UI components
│           └── cloud_widgets.dart     # Cloud function status widgets
├── test/
│   ├── functions/                     # Cloud Functions tests
│   │   ├── unit/                     # Unit tests for functions
│   │   ├── integration/              # Integration tests
│   │   └── emulator/                 # Emulator-based tests
│   └── flutter/                      # Flutter app tests
└── firebase.json                     # Firebase configuration
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Cloud Functions Project Setup** ⏱️ *30 minutes*

Initialize Cloud Functions in the existing SocialHub Pro project:

```bash
# Navigate to your SocialHub Pro project from Lesson 19
cd socialhub_pro

# Initialize Cloud Functions
firebase init functions

# Select TypeScript for development
# Choose to install dependencies with npm

# Navigate to functions directory
cd functions

# Install additional dependencies
npm install --save @types/node
npm install --save firebase-admin firebase-functions
npm install --dev @types/jest jest ts-jest
npm install --dev firebase-functions-test
```

### **Step 2: Cloud Functions Infrastructure** ⏱️ *45 minutes*

Set up the basic Cloud Functions structure:

```typescript
// functions/src/index.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK
admin.initializeApp();

// Import function modules
import * as notificationFunctions from './notifications';
import * as socialFunctions from './social';
import * as backgroundFunctions from './background';
import * as apiFunctions from './api';

// Export all functions
export const notifications = notificationFunctions;
export const social = socialFunctions;
export const background = backgroundFunctions;
export const api = apiFunctions;

// Health check function
export const healthCheck = functions.https.onRequest((req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  });
});

// functions/src/types/index.ts
export interface NotificationData {
  title: string;
  body: string;
  type: NotificationType;
  targetUserId: string;
  data?: Record<string, any>;
  priority?: 'high' | 'normal';
}

export enum NotificationType {
  NEW_POST = 'new_post',
  NEW_LIKE = 'new_like',
  NEW_COMMENT = 'new_comment',
  FRIEND_REQUEST = 'friend_request',
  NEW_MESSAGE = 'new_message',
  SYSTEM_ALERT = 'system_alert',
}

export interface UserTokens {
  fcmTokens: string[];
  lastUpdated: FirebaseFirestore.Timestamp;
}

export interface CloudFunctionResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
}

// functions/src/utils/auth.ts
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export function requireAuth(context: functions.https.CallableContext): string {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated to access this function'
    );
  }
  return context.auth.uid;
}

export async function requireAuthAndRole(
  context: functions.https.CallableContext,
  requiredRole: string
): Promise<string> {
  const uid = requireAuth(context);
  
  const userDoc = await admin.firestore()
    .collection('users')
    .doc(uid)
    .get();
    
  if (!userDoc.exists) {
    throw new functions.https.HttpsError(
      'not-found',
      'User profile not found'
    );
  }
  
  const userData = userDoc.data();
  if (userData?.role !== requiredRole) {
    throw new functions.https.HttpsError(
      'permission-denied',
      `Required role: ${requiredRole}`
    );
  }
  
  return uid;
}

export async function isAdmin(uid: string): Promise<boolean> {
  try {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(uid)
      .get();
      
    return userDoc.data()?.role === 'admin';
  } catch {
    return false;
  }
}

// functions/src/utils/validation.ts
export function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

export function validatePostContent(content: string): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];
  
  if (!content || content.trim().length === 0) {
    errors.push('Content cannot be empty');
  }
  
  if (content.length > 10000) {
    errors.push('Content too long (max 10,000 characters)');
  }
  
  // Check for inappropriate content (basic example)
  const inappropriateWords = ['spam', 'hate', 'abuse'];
  const hasInappropriate = inappropriateWords.some(word => 
    content.toLowerCase().includes(word)
  );
  
  if (hasInappropriate) {
    errors.push('Content contains inappropriate language');
  }
  
  return {
    isValid: errors.length === 0,
    errors,
  };
}

export function sanitizeUserInput(input: string): string {
  // Basic HTML sanitization
  return input
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .trim();
}
```

### **Step 3: Firebase Cloud Messaging (FCM) Service** ⏱️ *50 minutes*

Implement comprehensive FCM functionality:

```dart
// lib/services/fcm_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  static bool _isInitialized = false;
  static String? _currentToken;
  
  // Initialize FCM service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Request permissions
      await _requestPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Set up message handlers
      await _setupMessageHandlers();
      
      // Get and save FCM token
      await _setupToken();
      
      // Set up foreground notification options
      await _setupForegroundOptions();
      
      _isInitialized = true;
      print('✅ FCM Service initialized successfully');
    } catch (e) {
      print('❌ FCM Service initialization failed: $e');
    }
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
    
    // Track permission status
    await _analytics.logEvent(
      name: 'fcm_permission_requested',
      parameters: {
        'status': settings.authorizationStatus.toString(),
        'platform': Platform.isIOS ? 'ios' : 'android',
      },
    );
  }
  
  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: false, // Already requested above
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }
  
  // Create Android notification channels
  static Future<void> _createNotificationChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'social_interactions',
        'Social Interactions',
        description: 'Notifications for likes, comments, and follows',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
      AndroidNotificationChannel(
        'messages',
        'Messages',
        description: 'New message notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
      AndroidNotificationChannel(
        'system',
        'System Notifications',
        description: 'Important system notifications',
        importance: Importance.high,
        playSound: true,
      ),
    ];
    
    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
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
      await _handleNotificationTap(initialMessage);
    }
  }
  
  // Setup FCM token management
  static Future<void> _setupToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _currentToken = token;
        await _saveTokenToDatabase(token);
        print('FCM Token obtained: ${token.substring(0, 20)}...');
      }
      
      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) async {
        _currentToken = newToken;
        await _saveTokenToDatabase(newToken);
        print('FCM Token refreshed');
      });
      
    } catch (e) {
      print('Error setting up FCM token: $e');
    }
  }
  
  // Setup foreground notification options
  static Future<void> _setupForegroundOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
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
    
    // Update notification badge
    await _updateNotificationBadge();
  }
  
  // Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Received background message: ${message.messageId}');
    
    // Process data
    await _processBackgroundData(message);
    
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
    
    // Mark notification as read
    await _markNotificationAsRead(message);
  }
  
  // Show local notification with rich content
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    
    if (notification == null) return;
    
    final notificationType = data['type'] ?? 'system';
    final channelId = _getChannelId(notificationType);
    
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(notificationType),
      channelDescription: _getChannelDescription(notificationType),
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF2196F3),
      playSound: true,
      enableVibration: true,
      styleInformation: await _getNotificationStyle(message),
      actions: _getNotificationActions(notificationType),
    );
    
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'default',
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
  
  // Get notification style based on type
  static Future<AndroidNotificationDetails?> _getNotificationStyle(
    RemoteMessage message,
  ) async {
    final data = message.data;
    final type = data['type'] ?? 'system';
    
    switch (type) {
      case 'new_message':
        return const AndroidNotificationDetails(
          'messages',
          'Messages',
          styleInformation: MessagingStyleInformation(
            Person(name: 'You'),
            conversationTitle: 'New Message',
            groupConversation: false,
          ),
        );
      case 'new_post':
        return AndroidNotificationDetails(
          'social_interactions',
          'Social Interactions',
          styleInformation: BigTextStyleInformation(
            message.notification?.body ?? '',
            contentTitle: message.notification?.title,
          ),
        );
      default:
        return null;
    }
  }
  
  // Get notification actions based on type
  static List<AndroidNotificationAction>? _getNotificationActions(String type) {
    switch (type) {
      case 'new_message':
        return [
          const AndroidNotificationAction('reply', 'Reply'),
          const AndroidNotificationAction('mark_read', 'Mark as Read'),
        ];
      case 'new_like':
      case 'new_comment':
        return [
          const AndroidNotificationAction('view', 'View Post'),
          const AndroidNotificationAction('dismiss', 'Dismiss'),
        ];
      case 'friend_request':
        return [
          const AndroidNotificationAction('accept', 'Accept'),
          const AndroidNotificationAction('decline', 'Decline'),
        ];
      default:
        return null;
    }
  }
  
  // Topic subscription management
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
      
      // Save subscription to database
      await _saveTopicSubscription(topic, true);
      
      // Track analytics
      await _analytics.logEvent(
        name: 'topic_subscribed',
        parameters: {'topic': topic},
      );
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
      
      // Track analytics
      await _analytics.logEvent(
        name: 'topic_unsubscribed',
        parameters: {'topic': topic},
      );
    } catch (e) {
      print('Failed to unsubscribe from topic $topic: $e');
    }
  }
  
  // Helper methods
  static String _getChannelId(String type) {
    switch (type) {
      case 'new_message':
        return 'messages';
      case 'new_post':
      case 'new_like':
      case 'new_comment':
      case 'friend_request':
        return 'social_interactions';
      default:
        return 'system';
    }
  }
  
  static String _getChannelName(String type) {
    switch (type) {
      case 'new_message':
        return 'Messages';
      case 'new_post':
      case 'new_like':
      case 'new_comment':
      case 'friend_request':
        return 'Social Interactions';
      default:
        return 'System Notifications';
    }
  }
  
  static String _getChannelDescription(String type) {
    switch (type) {
      case 'new_message':
        return 'Notifications for new messages';
      case 'new_post':
      case 'new_like':
      case 'new_comment':
      case 'friend_request':
        return 'Notifications for social interactions';
      default:
        return 'Important system notifications';
    }
  }
  
  static Future<void> _saveTokenToDatabase(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'fcmTokens': FieldValue.arrayUnion([token]),
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        });
        print('FCM token saved to database');
      } catch (e) {
        print('Failed to save FCM token: $e');
      }
    }
  }
  
  static Future<void> _saveTopicSubscription(String topic, bool isSubscribed) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('subscriptions')
            .doc(topic)
            .set({
          'isSubscribed': isSubscribed,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Failed to save topic subscription: $e');
      }
    }
  }
  
  static Future<void> _onNotificationTapped(NotificationResponse response) async {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        await _handleNotificationNavigation(RemoteMessage(data: data));
      } catch (e) {
        print('Error handling notification tap: $e');
      }
    }
  }
  
  static Future<void> _handleNotificationNavigation(RemoteMessage message) async {
    final data = message.data;
    final type = data['type'];
    
    // Use a navigation service or app router
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
      case 'new_like':
      case 'new_comment':
        NavigationService.navigateToPost(data['postId']);
        break;
      default:
        NavigationService.navigateToHome();
    }
  }
  
  static Future<void> _updateAppState(RemoteMessage message) async {
    // Update relevant app state based on notification type
    final type = message.data['type'];
    
    // This would typically update your state management
    // Example with Riverpod:
    // ProviderContainer.read(notificationProvider.notifier).addNotification(message);
  }
  
  static Future<void> _trackNotificationReceived(RemoteMessage message) async {
    await _analytics.logEvent(
      name: 'notification_received',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'type': message.data['type'] ?? 'unknown',
        'from': message.from ?? 'unknown',
      },
    );
  }
  
  static Future<void> _trackNotificationOpened(RemoteMessage message) async {
    await _analytics.logEvent(
      name: 'notification_opened',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'type': message.data['type'] ?? 'unknown',
      },
    );
  }
  
  static Future<void> _processBackgroundData(RemoteMessage message) async {
    // Process notification data in background
    // Update local storage, sync data, etc.
  }
  
  static Future<void> _updateNotificationBadge() async {
    // Update app badge count
    // This would typically query unread notifications count
  }
  
  static Future<void> _markNotificationAsRead(RemoteMessage message) async {
    // Mark notification as read in database
    final notificationId = message.data['notificationId'];
    if (notificationId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(notificationId)
            .update({
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Failed to mark notification as read: $e');
      }
    }
  }
  
  // Public API methods
  static Future<String?> getToken() async {
    return _currentToken ?? await _messaging.getToken();
  }
  
  static Future<void> deleteToken() async {
    await _messaging.deleteToken();
    _currentToken = null;
  }
  
  static bool get isInitialized => _isInitialized;
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FCMService._handleBackgroundMessage(message);
}
```

### **Step 4: Cloud Functions for Social Features** ⏱️ *60 minutes*

Implement Cloud Functions for social interactions:

```typescript
// functions/src/social/post-functions.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sendNotification } from '../notifications/notification-service';
import { NotificationType } from '../types';

// Post creation trigger
export const onPostCreate = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const postData = snapshot.data();
    const authorId = postData.authorId;
    
    try {
      // Process post content
      await processPostContent(postId, postData);
      
      // Update user post count
      await updateUserPostCount(authorId, 1);
      
      // Notify followers
      await notifyFollowersOfNewPost(authorId, postId, postData);
      
      // Process hashtags and mentions
      await processHashtagsAndMentions(postId, postData);
      
      console.log(`Post ${postId} processed successfully`);
    } catch (error) {
      console.error(`Error processing post ${postId}:`, error);
    }
  });

// Post like trigger
export const onPostLike = functions.firestore
  .document('posts/{postId}/likes/{likeId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const likeData = snapshot.data();
    const likerId = likeData.userId;
    
    try {
      // Get post data
      const postDoc = await admin.firestore()
        .collection('posts')
        .doc(postId)
        .get();
        
      if (!postDoc.exists) return;
      
      const postData = postDoc.data()!;
      const authorId = postData.authorId;
      
      // Don't notify if user likes their own post
      if (likerId === authorId) return;
      
      // Update like count
      await admin.firestore()
        .collection('posts')
        .doc(postId)
        .update({
          likesCount: admin.firestore.FieldValue.increment(1),
        });
      
      // Get liker info
      const likerDoc = await admin.firestore()
        .collection('users')
        .doc(likerId)
        .get();
        
      const likerData = likerDoc.data();
      
      // Send notification to post author
      await sendNotification({
        targetUserId: authorId,
        type: NotificationType.NEW_LIKE,
        title: 'New Like',
        body: `${likerData?.displayName || 'Someone'} liked your post`,
        data: {
          postId: postId,
          likerId: likerId,
          likerName: likerData?.displayName,
          likerAvatar: likerData?.photoURL,
        },
      });
      
      console.log(`Like notification sent for post ${postId}`);
    } catch (error) {
      console.error(`Error processing like for post ${postId}:`, error);
    }
  });

// Comment creation trigger
export const onCommentCreate = functions.firestore
  .document('posts/{postId}/comments/{commentId}')
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;
    const commentId = context.params.commentId;
    const commentData = snapshot.data();
    const commenterId = commentData.authorId;
    
    try {
      // Get post data
      const postDoc = await admin.firestore()
        .collection('posts')
        .doc(postId)
        .get();
        
      if (!postDoc.exists) return;
      
      const postData = postDoc.data()!;
      const postAuthorId = postData.authorId;
      
      // Update comment count
      await admin.firestore()
        .collection('posts')
        .doc(postId)
        .update({
          commentsCount: admin.firestore.FieldValue.increment(1),
        });
      
      // Don't notify if user comments on their own post
      if (commenterId === postAuthorId) return;
      
      // Get commenter info
      const commenterDoc = await admin.firestore()
        .collection('users')
        .doc(commenterId)
        .get();
        
      const commenterData = commenterDoc.data();
      
      // Send notification to post author
      await sendNotification({
        targetUserId: postAuthorId,
        type: NotificationType.NEW_COMMENT,
        title: 'New Comment',
        body: `${commenterData?.displayName || 'Someone'} commented on your post`,
        data: {
          postId: postId,
          commentId: commentId,
          commenterId: commenterId,
          commenterName: commenterData?.displayName,
          commenterAvatar: commenterData?.photoURL,
          commentPreview: commentData.content.substring(0, 100),
        },
      });
      
      console.log(`Comment notification sent for post ${postId}`);
    } catch (error) {
      console.error(`Error processing comment for post ${postId}:`, error);
    }
  });

// Helper functions
async function processPostContent(postId: string, postData: any) {
  // Content moderation
  const moderationResult = await moderateContent(postData.content);
  
  if (moderationResult.flagged) {
    await admin.firestore()
      .collection('posts')
      .doc(postId)
      .update({
        moderationStatus: 'flagged',
        moderationFlags: moderationResult.flags,
        moderatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    // Notify moderators
    await notifyModerators(postId, moderationResult);
  }
}

async function updateUserPostCount(userId: string, increment: number) {
  await admin.firestore()
    .collection('users')
    .doc(userId)
    .update({
      postsCount: admin.firestore.FieldValue.increment(increment),
      lastPostAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}

async function notifyFollowersOfNewPost(
  authorId: string,
  postId: string,
  postData: any
) {
  // Get followers
  const followersSnapshot = await admin.firestore()
    .collection('follows')
    .where('followingId', '==', authorId)
    .where('isActive', '==', true)
    .get();
  
  if (followersSnapshot.empty) return;
  
  // Get author info
  const authorDoc = await admin.firestore()
    .collection('users')
    .doc(authorId)
    .get();
    
  const authorData = authorDoc.data();
  
  // Send notifications to followers in batches
  const followerIds = followersSnapshot.docs.map(doc => doc.data().followerId);
  const batchSize = 100;
  
  for (let i = 0; i < followerIds.length; i += batchSize) {
    const batch = followerIds.slice(i, i + batchSize);
    
    const promises = batch.map(followerId =>
      sendNotification({
        targetUserId: followerId,
        type: NotificationType.NEW_POST,
        title: 'New Post',
        body: `${authorData?.displayName || 'Someone'} shared a new post`,
        data: {
          postId: postId,
          authorId: authorId,
          authorName: authorData?.displayName,
          authorAvatar: authorData?.photoURL,
          postPreview: postData.content.substring(0, 100),
        },
      }).catch(error => {
        console.error(`Failed to notify follower ${followerId}:`, error);
      })
    );
    
    await Promise.allSettled(promises);
  }
}

async function processHashtagsAndMentions(postId: string, postData: any) {
  const content = postData.content;
  
  // Extract hashtags
  const hashtagRegex = /#(\w+)/g;
  const hashtags = [];
  let match;
  
  while ((match = hashtagRegex.exec(content)) !== null) {
    hashtags.push(match[1].toLowerCase());
  }
  
  // Extract mentions
  const mentionRegex = /@(\w+)/g;
  const mentions = [];
  
  while ((match = mentionRegex.exec(content)) !== null) {
    mentions.push(match[1].toLowerCase());
  }
  
  // Update post with extracted data
  await admin.firestore()
    .collection('posts')
    .doc(postId)
    .update({
      hashtags: hashtags,
      mentions: mentions,
    });
  
  // Process hashtag trends
  if (hashtags.length > 0) {
    await updateHashtagTrends(hashtags);
  }
  
  // Notify mentioned users
  if (mentions.length > 0) {
    await notifyMentionedUsers(postId, mentions, postData);
  }
}

async function moderateContent(content: string): Promise<{
  flagged: boolean;
  flags: string[];
}> {
  // Basic content moderation (in production, use ML services)
  const inappropriateWords = [
    'spam', 'hate', 'abuse', 'harassment',
    // Add more as needed
  ];
  
  const flags: string[] = [];
  const lowerContent = content.toLowerCase();
  
  inappropriateWords.forEach(word => {
    if (lowerContent.includes(word)) {
      flags.push(word);
    }
  });
  
  return {
    flagged: flags.length > 0,
    flags: flags,
  };
}

async function notifyModerators(postId: string, moderationResult: any) {
  // Get list of moderators
  const moderatorsSnapshot = await admin.firestore()
    .collection('users')
    .where('role', '==', 'moderator')
    .get();
  
  const moderatorPromises = moderatorsSnapshot.docs.map(doc =>
    sendNotification({
      targetUserId: doc.id,
      type: NotificationType.SYSTEM_ALERT,
      title: 'Content Flagged',
      body: `Post ${postId} has been flagged for review`,
      data: {
        postId: postId,
        flags: moderationResult.flags,
        action: 'moderate_content',
      },
    })
  );
  
  await Promise.allSettled(moderatorPromises);
}

async function updateHashtagTrends(hashtags: string[]) {
  const batch = admin.firestore().batch();
  
  hashtags.forEach(hashtag => {
    const trendRef = admin.firestore()
      .collection('trends')
      .doc(hashtag);
      
    batch.set(trendRef, {
      count: admin.firestore.FieldValue.increment(1),
      lastUsed: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
  });
  
  await batch.commit();
}

async function notifyMentionedUsers(
  postId: string,
  mentions: string[],
  postData: any
) {
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
  
  // Send notifications
  const notificationPromises = validUsers.map(doc =>
    sendNotification({
      targetUserId: doc!.id,
      type: NotificationType.NEW_POST,
      title: 'You were mentioned',
      body: `${postData.authorName} mentioned you in a post`,
      data: {
        postId: postId,
        authorId: postData.authorId,
        type: 'mention',
      },
    })
  );
  
  await Promise.allSettled(notificationPromises);
}

// functions/src/social/user-functions.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sendNotification } from '../notifications/notification-service';
import { NotificationType } from '../types';

// User follow trigger
export const onUserFollow = functions.firestore
  .document('follows/{followId}')
  .onCreate(async (snapshot, context) => {
    const followData = snapshot.data();
    const followerId = followData.followerId;
    const followingId = followData.followingId;
    
    try {
      // Update follower/following counts
      await updateFollowCounts(followerId, followingId, 1);
      
      // Get follower info
      const followerDoc = await admin.firestore()
        .collection('users')
        .doc(followerId)
        .get();
        
      const followerData = followerDoc.data();
      
      // Send notification to followed user
      await sendNotification({
        targetUserId: followingId,
        type: NotificationType.FRIEND_REQUEST,
        title: 'New Follower',
        body: `${followerData?.displayName || 'Someone'} started following you`,
        data: {
          followerId: followerId,
          followerName: followerData?.displayName,
          followerAvatar: followerData?.photoURL,
          action: 'new_follower',
        },
      });
      
      console.log(`Follow notification sent: ${followerId} -> ${followingId}`);
    } catch (error) {
      console.error(`Error processing follow:`, error);
    }
  });

// User unfollow trigger
export const onUserUnfollow = functions.firestore
  .document('follows/{followId}')
  .onDelete(async (snapshot, context) => {
    const followData = snapshot.data();
    const followerId = followData.followerId;
    const followingId = followData.followingId;
    
    try {
      // Update follower/following counts
      await updateFollowCounts(followerId, followingId, -1);
      
      console.log(`Unfollow processed: ${followerId} -> ${followingId}`);
    } catch (error) {
      console.error(`Error processing unfollow:`, error);
    }
  });

async function updateFollowCounts(
  followerId: string,
  followingId: string,
  increment: number
) {
  const batch = admin.firestore().batch();
  
  // Update follower's following count
  const followerRef = admin.firestore()
    .collection('users')
    .doc(followerId);
  batch.update(followerRef, {
    followingCount: admin.firestore.FieldValue.increment(increment),
  });
  
  // Update following user's follower count
  const followingRef = admin.firestore()
    .collection('users')
    .doc(followingId);
  batch.update(followingRef, {
    followersCount: admin.firestore.FieldValue.increment(increment),
  });
  
  await batch.commit();
}
```

*This is part 1 of the workshop. Continue with notification system implementation, background functions, Flutter integration, and testing...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_20

# Install dependencies
flutter pub get
cd functions
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Start Firebase emulators
firebase emulators:start

# Deploy functions (when ready for testing)
firebase deploy --only functions

# Run the Flutter app
flutter run

# Test the enhanced features
# 1. Test push notifications with various types
# 2. Test Cloud Functions with social interactions
# 3. Test background processing and automation
# 4. Test notification preferences and settings
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Cloud Functions Excellence** - Serverless backend logic with automated social features
- **Push Notification Mastery** - Comprehensive FCM integration with intelligent targeting
- **Event-Driven Architecture** - Reactive functions responding to Firebase database changes
- **Background Processing** - Automated tasks for moderation, analytics, and maintenance
- **Integration Excellence** - Seamless connection between Flutter app and Cloud Functions
- **Testing Excellence** - Comprehensive testing strategies for serverless applications

**Ready to build intelligent, cloud-powered social applications with automated backend logic and real-time notifications! ☁️📱✨**