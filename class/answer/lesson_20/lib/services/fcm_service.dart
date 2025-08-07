import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  static bool _isInitialized = false;
  static String? _currentToken;
  
  // Navigation callback
  static Function(String route, Map<String, dynamic>? arguments)? _navigationCallback;
  
  /// Initialize FCM service
  static Future<void> initialize({
    Function(String route, Map<String, dynamic>? arguments)? onNavigate,
  }) async {
    if (_isInitialized) return;
    
    _navigationCallback = onNavigate;
    
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
      debugPrint('✅ FCM Service initialized successfully');
    } catch (e) {
      debugPrint('❌ FCM Service initialization failed: $e');
      rethrow;
    }
  }
  
  /// Request notification permissions
  static Future<NotificationSettings> _requestPermissions() async {
    // Request basic notification permission
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    // Request additional permissions on Android
    if (Platform.isAndroid) {
      await Permission.notification.request();
      
      // Request exact alarm permission for scheduled notifications (Android 12+)
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }
    
    debugPrint('FCM Permission Status: ${settings.authorizationStatus}');
    
    // Track permission status
    await _analytics.logEvent(
      name: 'fcm_permission_requested',
      parameters: {
        'status': settings.authorizationStatus.toString(),
        'platform': Platform.isIOS ? 'ios' : 'android',
        'alert': settings.alert.toString(),
        'badge': settings.badge.toString(),
        'sound': settings.sound.toString(),
      },
    );
    
    return settings;
  }
  
  /// Initialize local notifications
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
  
  /// Create Android notification channels
  static Future<void> _createNotificationChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'social_interactions',
        'Social Interactions',
        description: 'Notifications for likes, comments, and follows',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
      AndroidNotificationChannel(
        'messages',
        'Messages',
        description: 'New message notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
      AndroidNotificationChannel(
        'system',
        'System Notifications',
        description: 'Important system notifications',
        importance: Importance.high,
        playSound: true,
        showBadge: true,
      ),
      AndroidNotificationChannel(
        'default',
        'Default',
        description: 'Default notification channel',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
    ];
    
    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    
    debugPrint('Created ${channels.length} notification channels');
  }
  
  /// Setup message handlers
  static Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
    // Handle initial message (app opened from notification when terminated)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleNotificationTap(initialMessage);
    }
  }
  
  /// Setup FCM token management
  static Future<void> _setupToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _currentToken = token;
        await _saveTokenToDatabase(token);
        debugPrint('FCM Token obtained: ${token.substring(0, 20)}...');
      }
      
      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) async {
        _currentToken = newToken;
        await _saveTokenToDatabase(newToken);
        debugPrint('FCM Token refreshed');
      });
      
    } catch (e) {
      debugPrint('Error setting up FCM token: $e');
    }
  }
  
  /// Setup foreground notification options
  static Future<void> _setupForegroundOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  
  /// Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Received foreground message: ${message.messageId}');
    
    // Show local notification
    await _showLocalNotification(message);
    
    // Update app state
    await _updateAppState(message);
    
    // Track analytics
    await _trackNotificationReceived(message);
    
    // Update notification badge
    await _updateNotificationBadge();
  }
  
  /// Handle notification tap
  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    debugPrint('Notification tapped: ${message.messageId}');
    
    // Navigate to appropriate screen
    await _handleNotificationNavigation(message);
    
    // Track analytics
    await _trackNotificationOpened(message);
    
    // Mark notification as read
    await _markNotificationAsRead(message);
  }
  
  /// Show local notification with rich content
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    
    if (notification == null) return;
    
    final notificationType = data['type'] ?? 'default';
    final channelId = _getChannelId(notificationType);
    
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(notificationType),
      channelDescription: _getChannelDescription(notificationType),
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF6C63FF),
      playSound: true,
      enableVibration: true,
      styleInformation: _getNotificationStyle(message),
      actions: _getNotificationActions(notificationType),
      when: DateTime.now().millisecondsSinceEpoch,
      showWhen: true,
      groupKey: _getGroupKey(notificationType),
      setAsGroupSummary: false,
    );
    
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'default',
      interruptionLevel: InterruptionLevel.active,
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
  
  /// Get notification style based on type
  static StyleInformation? _getNotificationStyle(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] ?? 'default';
    
    switch (type) {
      case 'new_message':
        return MessagingStyleInformation(
          Person(
            name: data['senderName'] ?? 'Unknown',
            icon: data['senderAvatar'] != null 
                ? BitmapFilePathAndroidIcon(data['senderAvatar'])
                : null,
          ),
          conversationTitle: 'New Message',
          groupConversation: false,
          messages: [
            Message(
              data['messagePreview'] ?? message.notification?.body ?? '',
              DateTime.now(),
              Person(name: data['senderName'] ?? 'Unknown'),
            ),
          ],
        );
      
      case 'new_post':
      case 'new_comment':
        return BigTextStyleInformation(
          message.notification?.body ?? '',
          contentTitle: message.notification?.title,
          summaryText: data['authorName'] != null 
              ? 'from ${data['authorName']}'
              : null,
        );
      
      default:
        return null;
    }
  }
  
  /// Get notification actions based on type
  static List<AndroidNotificationAction>? _getNotificationActions(String type) {
    switch (type) {
      case 'new_message':
        return [
          const AndroidNotificationAction(
            'reply',
            'Reply',
            icon: DrawableResourceAndroidBitmap('ic_reply'),
            inputs: [
              AndroidNotificationActionInput(
                label: 'Type a reply...',
              ),
            ],
          ),
          const AndroidNotificationAction(
            'mark_read',
            'Mark as Read',
            icon: DrawableResourceAndroidBitmap('ic_check'),
          ),
        ];
      
      case 'new_like':
      case 'new_comment':
        return [
          const AndroidNotificationAction(
            'view',
            'View Post',
            icon: DrawableResourceAndroidBitmap('ic_view'),
          ),
          const AndroidNotificationAction(
            'like',
            'Like',
            icon: DrawableResourceAndroidBitmap('ic_favorite'),
          ),
        ];
      
      case 'friend_request':
        return [
          const AndroidNotificationAction(
            'accept',
            'Accept',
            icon: DrawableResourceAndroidBitmap('ic_check'),
          ),
          const AndroidNotificationAction(
            'decline',
            'Decline',
            icon: DrawableResourceAndroidBitmap('ic_close'),
          ),
        ];
      
      default:
        return null;
    }
  }
  
  /// Topic subscription management
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
      
      // Save subscription to database
      await _saveTopicSubscription(topic, true);
      
      // Track analytics
      await _analytics.logEvent(
        name: 'topic_subscribed',
        parameters: {'topic': topic},
      );
    } catch (e) {
      debugPrint('Failed to subscribe to topic $topic: $e');
      rethrow;
    }
  }
  
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
      
      // Update subscription in database
      await _saveTopicSubscription(topic, false);
      
      // Track analytics
      await _analytics.logEvent(
        name: 'topic_unsubscribed',
        parameters: {'topic': topic},
      );
    } catch (e) {
      debugPrint('Failed to unsubscribe from topic $topic: $e');
      rethrow;
    }
  }
  
  /// Send notification via Cloud Function
  static Future<Map<String, dynamic>> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
    String priority = 'normal',
  }) async {
    try {
      // This would call a Cloud Function
      // For demo purposes, we'll simulate the response
      await Future.delayed(const Duration(milliseconds: 500));
      
      debugPrint('Notification sent to user $userId: $title');
      
      return {
        'success': true,
        'messageId': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      };
    } catch (e) {
      debugPrint('Failed to send notification: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
  
  /// Helper methods
  static String _getChannelId(String type) {
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
  
  static String _getChannelName(String type) {
    switch (type) {
      case 'new_message':
        return 'Messages';
      case 'new_post':
      case 'new_like':
      case 'new_comment':
      case 'friend_request':
        return 'Social Interactions';
      case 'system_alert':
      case 'welcome':
      case 'reminder':
        return 'System Notifications';
      default:
        return 'Default';
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
      case 'system_alert':
      case 'welcome':
      case 'reminder':
        return 'Important system notifications';
      default:
        return 'Default notification channel';
    }
  }
  
  static String _getGroupKey(String type) {
    switch (type) {
      case 'new_message':
        return 'messages_group';
      case 'new_post':
      case 'new_like':
      case 'new_comment':
        return 'social_group';
      default:
        return 'default_group';
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
        debugPrint('FCM token saved to database');
      } catch (e) {
        debugPrint('Failed to save FCM token: $e');
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
        debugPrint('Failed to save topic subscription: $e');
      }
    }
  }
  
  static Future<void> _onNotificationTapped(NotificationResponse response) async {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        await _handleNotificationNavigation(RemoteMessage(data: data));
      } catch (e) {
        debugPrint('Error handling notification tap: $e');
      }
    }
    
    // Handle notification actions
    if (response.actionId != null) {
      await _handleNotificationAction(response.actionId!, response.payload);
    }
  }
  
  static Future<void> _handleNotificationAction(String actionId, String? payload) async {
    debugPrint('Notification action: $actionId');
    
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        
        switch (actionId) {
          case 'reply':
            // Handle reply action
            debugPrint('Reply action triggered');
            break;
          case 'mark_read':
            // Handle mark as read action
            await _markNotificationAsRead(RemoteMessage(data: data));
            break;
          case 'like':
            // Handle like action
            debugPrint('Like action triggered');
            break;
          case 'accept':
            // Handle accept action
            debugPrint('Accept action triggered');
            break;
          case 'decline':
            // Handle decline action
            debugPrint('Decline action triggered');
            break;
        }
      } catch (e) {
        debugPrint('Error handling notification action: $e');
      }
    }
  }
  
  static Future<void> _handleNotificationNavigation(RemoteMessage message) async {
    final data = message.data;
    final type = data['type'];
    
    if (_navigationCallback == null) {
      debugPrint('Navigation callback not set');
      return;
    }
    
    switch (type) {
      case 'new_post':
        _navigationCallback!('/post', {'postId': data['postId']});
        break;
      case 'friend_request':
        _navigationCallback!('/friend-requests', null);
        break;
      case 'new_message':
        _navigationCallback!('/chat', {'chatId': data['chatId']});
        break;
      case 'new_like':
      case 'new_comment':
        _navigationCallback!('/post', {'postId': data['postId']});
        break;
      case 'system_alert':
        _navigationCallback!('/notifications', null);
        break;
      default:
        _navigationCallback!('/home', null);
    }
  }
  
  static Future<void> _updateAppState(RemoteMessage message) async {
    // This would update relevant app state based on notification type
    final type = message.data['type'];
    
    debugPrint('Updating app state for notification type: $type');
    
    // In a real app, you would update your state management here
    // For example, with Riverpod:
    // final container = ProviderContainer();
    // container.read(notificationProvider.notifier).addNotification(message);
  }
  
  static Future<void> _trackNotificationReceived(RemoteMessage message) async {
    await _analytics.logEvent(
      name: 'notification_received',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'type': message.data['type'] ?? 'unknown',
        'from': message.from ?? 'unknown',
        'has_notification': (message.notification != null).toString(),
        'data_keys': message.data.keys.join(','),
      },
    );
  }
  
  static Future<void> _trackNotificationOpened(RemoteMessage message) async {
    await _analytics.logEvent(
      name: 'notification_opened',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'type': message.data['type'] ?? 'unknown',
        'title': message.notification?.title ?? '',
      },
    );
  }
  
  static Future<void> _updateNotificationBadge() async {
    // Update app badge count
    // This would typically query unread notifications count
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final unreadCount = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .where('isRead', isEqualTo: false)
            .get()
            .then((snapshot) => snapshot.size);
        
        await _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getNotificationChannels();
        
        // Set badge (iOS handles this automatically, Android would need a plugin)
        debugPrint('Unread notifications: $unreadCount');
      }
    } catch (e) {
      debugPrint('Failed to update notification badge: $e');
    }
  }
  
  static Future<void> _markNotificationAsRead(RemoteMessage message) async {
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
        debugPrint('Marked notification as read: $notificationId');
      } catch (e) {
        debugPrint('Failed to mark notification as read: $e');
      }
    }
  }
  
  /// Public API methods
  static Future<String?> getToken() async {
    return _currentToken ?? await _messaging.getToken();
  }
  
  static Future<void> deleteToken() async {
    await _messaging.deleteToken();
    _currentToken = null;
    
    // Remove from database
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcmTokens': [],
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
    }
  }
  
  /// Check if FCM is supported on this platform
  static Future<bool> isSupported() async {
    return await _messaging.isSupported();
  }
  
  /// Get notification settings
  static Future<NotificationSettings> getNotificationSettings() async {
    return await _messaging.getNotificationSettings();
  }
  
  /// Set auto initialization
  static Future<void> setAutoInitEnabled(bool enabled) async {
    await _messaging.setAutoInitEnabled(enabled);
  }
  
  static bool get isInitialized => _isInitialized;
  
  static String? get currentToken => _currentToken;
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  
  // Process background data
  await _processBackgroundMessage(message);
  
  // Track analytics
  await FirebaseAnalytics.instance.logEvent(
    name: 'notification_received_background',
    parameters: {
      'message_id': message.messageId ?? 'unknown',
      'type': message.data['type'] ?? 'unknown',
    },
  );
}

Future<void> _processBackgroundMessage(RemoteMessage message) async {
  // Process notification data in background
  // Update local storage, sync data, etc.
  
  try {
    final type = message.data['type'];
    debugPrint('Processing background message of type: $type');
    
    switch (type) {
      case 'new_message':
        // Pre-load message data
        break;
      case 'new_post':
        // Update feed cache
        break;
      case 'system_alert':
        // Handle system notifications
        break;
    }
  } catch (e) {
    debugPrint('Error processing background message: $e');
  }
}
