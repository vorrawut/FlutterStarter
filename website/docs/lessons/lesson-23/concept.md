# 🔄 Lesson 23: Integration Testing + Mocking - Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **End-to-End Testing Excellence** - Complete user journey testing with realistic scenarios and edge cases
- **Advanced Mocking Strategies** - Sophisticated mocking techniques for complex dependencies and external services
- **Integration Testing Patterns** - Professional integration testing for Firebase services, APIs, and third-party dependencies
- **Test Automation Mastery** - Automated testing pipelines with continuous integration and quality gates
- **Performance Integration Testing** - Load testing, stress testing, and performance validation under realistic conditions
- **Cross-Platform Testing** - Testing strategies for iOS, Android, and web with platform-specific considerations
- **Production Testing Strategies** - Testing practices for enterprise applications with millions of users
- **Test Maintenance Excellence** - Maintaining test suites, handling test debt, and evolving testing strategies

## 🚀 **Integration Testing Philosophy and Strategy**

### **The Complete Testing Ecosystem**

Integration testing sits at the crucial intersection between unit testing and full end-to-end testing, validating that components work together correctly:

```dart
// Integration Testing Framework for ConnectPro Ultimate
class IntegrationTestingStrategy {
  static const testingLevels = {
    'Component Integration': {
      'Purpose': 'Test interaction between related components',
      'Scope': 'Widget-to-widget communication and state sharing',
      'Examples': [
        'Chat message list with input field integration',
        'Social feed with infinite scroll and refresh',
        'Authentication flow with navigation transitions',
        'Real-time updates with UI synchronization',
      ],
      'Tools': ['flutter_test', 'integration_test', 'patrol'],
    },
    
    'Service Integration': {
      'Purpose': 'Test service layer interactions and data flow',
      'Scope': 'Repository-service-provider integration',
      'Examples': [
        'Firebase Auth with Firestore security rules',
        'Real-time chat with push notifications',
        'Social feed with caching and offline support',
        'File upload with progress tracking',
      ],
      'Tools': ['firebase_emulator', 'http_mock_adapter', 'dio_test'],
    },
    
    'Platform Integration': {
      'Purpose': 'Test platform-specific features and capabilities',
      'Scope': 'Native platform integration and device features',
      'Examples': [
        'Push notification delivery and handling',
        'Camera and gallery integration',
        'Background task execution',
        'Deep linking and app state restoration',
      ],
      'Tools': ['integration_test', 'flutter_driver', 'native_testing'],
    },
    
    'End-to-End Integration': {
      'Purpose': 'Test complete user journeys and business workflows',
      'Scope': 'Full application flows from start to finish',
      'Examples': [
        'User registration to first message sent',
        'Post creation to social engagement',
        'Offline usage to online synchronization',
        'App launch to feature discovery',
      ],
      'Tools': ['patrol', 'integration_test', 'golden_toolkit'],
    },
  };

  // Integration Testing Best Practices
  static const bestPractices = [
    'Test Real User Scenarios - Focus on actual user journeys and behaviors',
    'Use Production-Like Data - Test with realistic data sizes and complexity',
    'Validate Error Scenarios - Test failure modes and recovery mechanisms',
    'Performance Under Load - Test with concurrent users and high data volumes',
    'Cross-Platform Consistency - Ensure behavior is consistent across platforms',
    'Accessibility Integration - Test screen reader and accessibility features',
    'Security Integration - Validate authentication and authorization flows',
    'Offline-Online Transitions - Test network connectivity changes',
  ];
}
```

### **Advanced Mocking Strategies for Complex Systems**

Professional integration testing requires sophisticated mocking approaches:

```dart
// Advanced Mocking Framework for Complex Dependencies
class AdvancedMockingStrategy {
  // Service Layer Mocking
  static const serviceMocking = {
    'Firebase Services': {
      'Approach': 'Emulator-first with selective mocking',
      'Benefits': 'Real behavior with controlled environment',
      'Use Cases': [
        'Firestore with complex queries and security rules',
        'Firebase Auth with multi-provider flows',
        'Cloud Functions with event triggers',
        'FCM with cross-platform delivery',
      ],
    },
    
    'HTTP Services': {
      'Approach': 'HTTP interceptors with realistic responses',
      'Benefits': 'Network behavior simulation with error scenarios',
      'Use Cases': [
        'API rate limiting and throttling',
        'Network timeouts and connectivity issues',
        'Server errors and recovery mechanisms',
        'Large response payloads and streaming',
      ],
    },
    
    'Platform Services': {
      'Approach': 'Platform channel mocking with native behavior',
      'Benefits': 'Device feature simulation without hardware',
      'Use Cases': [
        'Camera and gallery access',
        'Location services and permissions',
        'Background task execution',
        'Push notification delivery',
      ],
    },
    
    'Third-Party Services': {
      'Approach': 'Adapter pattern with configurable behavior',
      'Benefits': 'External dependency isolation with realistic responses',
      'Use Cases': [
        'Analytics and crash reporting',
        'Payment processing and validation',
        'Social media integration',
        'Content delivery networks',
      ],
    },
  };

  // Mock Data Generation Strategies
  static const mockDataStrategies = [
    'Realistic Volume - Generate data sets that match production scale',
    'Edge Case Coverage - Include boundary conditions and unusual data',
    'Temporal Consistency - Maintain realistic timestamps and sequences',
    'Relationship Integrity - Ensure foreign key relationships are valid',
    'Cultural Diversity - Include international users and content',
    'Performance Variety - Mix of fast and slow operations',
    'Error Simulation - Include various failure scenarios',
    'State Transitions - Test state changes and workflow progressions',
  ];
}
```

## 🔄 **End-to-End Testing Excellence**

### **Complete User Journey Testing**

```dart
// Comprehensive E2E Testing Framework
class EndToEndTestingFramework {
  // User Journey Categories
  static const userJourneys = {
    'New User Onboarding': {
      'Steps': [
        'App launch and splash screen',
        'Registration with email verification',
        'Profile setup and photo upload',
        'Tutorial and feature introduction',
        'First social interaction',
      ],
      'Validations': [
        'UI responsiveness and smooth transitions',
        'Data persistence across app restarts',
        'Error handling for network issues',
        'Accessibility compliance',
        'Performance under load',
      ],
    },
    
    'Social Engagement Workflow': {
      'Steps': [
        'Login and feed refresh',
        'Post creation with media',
        'Social interactions (like, comment, share)',
        'Real-time notifications',
        'Chat initiation and messaging',
      ],
      'Validations': [
        'Real-time synchronization accuracy',
        'Push notification delivery',
        'Cross-device consistency',
        'Offline functionality',
        'Content moderation enforcement',
      ],
    },
    
    'Chat Communication Flow': {
      'Steps': [
        'Chat list navigation',
        'Message composition and sending',
        'Real-time message delivery',
        'Media sharing and viewing',
        'Group chat management',
      ],
      'Validations': [
        'Message ordering and consistency',
        'Typing indicators and presence',
        'End-to-end encryption verification',
        'Message status accuracy',
        'Performance with large chat histories',
      ],
    },
    
    'Offline-Online Transition': {
      'Steps': [
        'App usage while offline',
        'Content creation and queuing',
        'Network reconnection',
        'Data synchronization',
        'Conflict resolution',
      ],
      'Validations': [
        'Data integrity during sync',
        'User feedback during transitions',
        'Conflict resolution accuracy',
        'Performance during large syncs',
        'Error recovery mechanisms',
      ],
    },
  };

  // Critical Path Testing
  static const criticalPaths = [
    'Authentication and security flows',
    'Real-time messaging and notifications',
    'Data synchronization and offline support',
    'Content creation and social interactions',
    'Performance under concurrent usage',
    'Error recovery and graceful degradation',
    'Cross-platform feature parity',
    'Accessibility and internationalization',
  ];
}
```

### **Advanced E2E Testing Implementation**

```dart
// test/integration/e2e/user_journey_test.dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/patrol.dart';
import 'package:connectpro_ultimate/main.dart' as app;
import '../helpers/integration_test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete User Journey Tests', () {
    late PatrolIntegrationTester $;

    setUp(() async {
      $ = PatrolIntegrationTester(binding);
      await IntegrationTestHelper.setupTestEnvironment();
    });

    tearDown(() async {
      await IntegrationTestHelper.cleanupTestEnvironment();
    });

    patrolTest('New user onboarding journey', ($) async {
      // Launch app and verify splash screen
      app.main();
      await $.pumpAndSettle();
      
      expect($.find.text('ConnectPro Ultimate'), findsOneWidget);
      
      // Navigate to registration
      await $.tap($.find.text('Get Started'));
      await $.pumpAndSettle();
      
      // Complete registration flow
      await _completeRegistration($);
      
      // Verify profile setup
      await _completeProfileSetup($);
      
      // Test tutorial flow
      await _completeTutorial($);
      
      // Verify first social interaction
      await _performFirstSocialInteraction($);
      
      // Validate onboarding completion
      expect($.find.text('Welcome to ConnectPro!'), findsOneWidget);
    });

    patrolTest('Real-time chat workflow', ($) async {
      // Setup: Login with test user
      app.main();
      await $.pumpAndSettle();
      await _loginTestUser($);
      
      // Navigate to chat
      await $.tap($.find.byIcon(Icons.chat));
      await $.pumpAndSettle();
      
      // Start new chat
      await $.tap($.find.byIcon(Icons.add));
      await $.enterText($.find.byType(TextField), 'test-recipient@example.com');
      await $.tap($.find.text('Start Chat'));
      await $.pumpAndSettle();
      
      // Send messages and verify real-time delivery
      const testMessage = 'Hello from integration test!';
      await $.enterText($.find.byType(TextField), testMessage);
      await $.tap($.find.byIcon(Icons.send));
      await $.pumpAndSettle();
      
      // Verify message appears in chat
      expect($.find.text(testMessage), findsOneWidget);
      
      // Test message reactions
      await $.longPress($.find.text(testMessage));
      await $.pumpAndSettle();
      await $.tap($.find.text('👍'));
      await $.pumpAndSettle();
      
      // Verify reaction appears
      expect($.find.text('👍'), findsOneWidget);
      
      // Test typing indicators
      await $.enterText($.find.byType(TextField), 'Typing test...');
      await $.pump(Duration(milliseconds: 500));
      
      // Verify typing indicator (would need test user simulation)
      // expect($.find.text('User is typing...'), findsOneWidget);
    });

    patrolTest('Social feed engagement workflow', ($) async {
      // Setup: Login and navigate to feed
      app.main();
      await $.pumpAndSettle();
      await _loginTestUser($);
      
      // Create a new post
      await $.tap($.find.byIcon(Icons.add));
      await $.pumpAndSettle();
      
      const postContent = 'Test post from integration test #testing';
      await $.enterText($.find.byType(TextField), postContent);
      await $.tap($.find.text('Post'));
      await $.pumpAndSettle();
      
      // Verify post appears in feed
      expect($.find.text(postContent), findsOneWidget);
      
      // Test post interactions
      await $.tap($.find.byIcon(Icons.favorite_border));
      await $.pumpAndSettle();
      
      // Verify like count increases
      expect($.find.text('1'), findsOneWidget);
      
      // Test comment creation
      await $.tap($.find.byIcon(Icons.comment));
      await $.pumpAndSettle();
      
      const commentContent = 'Great post!';
      await $.enterText($.find.byType(TextField), commentContent);
      await $.tap($.find.text('Comment'));
      await $.pumpAndSettle();
      
      // Verify comment appears
      expect($.find.text(commentContent), findsOneWidget);
    });

    patrolTest('Offline-online transition workflow', ($) async {
      // Setup: Login and create content while online
      app.main();
      await $.pumpAndSettle();
      await _loginTestUser($);
      
      // Create initial content
      await _createTestContent($);
      
      // Simulate network disconnection
      await IntegrationTestHelper.simulateNetworkDisconnection();
      
      // Attempt to create content while offline
      await $.tap($.find.byIcon(Icons.add));
      await $.enterText($.find.byType(TextField), 'Offline post');
      await $.tap($.find.text('Post'));
      await $.pumpAndSettle();
      
      // Verify offline indicator and queued content
      expect($.find.byIcon(Icons.offline_bolt), findsOneWidget);
      expect($.find.text('Queued for sync'), findsOneWidget);
      
      // Simulate network reconnection
      await IntegrationTestHelper.simulateNetworkReconnection();
      await $.pumpAndSettle(Duration(seconds: 5));
      
      // Verify content synchronization
      expect($.find.text('Offline post'), findsOneWidget);
      expect($.find.byIcon(Icons.offline_bolt), findsNothing);
    });

    patrolTest('Performance under load', ($) async {
      // Setup: Login with user that has large dataset
      app.main();
      await $.pumpAndSettle();
      await _loginTestUserWithLargeDataset($);
      
      // Measure feed loading performance
      final stopwatch = Stopwatch()..start();
      
      await $.tap($.find.byIcon(Icons.refresh));
      await $.pumpAndSettle();
      
      stopwatch.stop();
      
      // Verify performance meets requirements
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      
      // Test scrolling performance with large lists
      for (int i = 0; i < 10; i++) {
        await $.scroll(
          $.find.byType(ListView),
          Offset(0, -500),
          Duration(milliseconds: 100),
        );
        await $.pump();
      }
      
      // Verify smooth scrolling (no frame drops)
      // This would require performance monitoring integration
    });

    // Helper methods for common test operations
    Future<void> _completeRegistration(PatrolIntegrationTester $) async {
      await $.enterText($.find.byKey(Key('email_field')), 'test@example.com');
      await $.enterText($.find.byKey(Key('password_field')), 'TestPassword123!');
      await $.enterText($.find.byKey(Key('confirm_password_field')), 'TestPassword123!');
      await $.tap($.find.text('Create Account'));
      await $.pumpAndSettle();
      
      // Handle email verification (in test environment)
      await IntegrationTestHelper.simulateEmailVerification('test@example.com');
      await $.pumpAndSettle();
    }

    Future<void> _completeProfileSetup(PatrolIntegrationTester $) async {
      await $.enterText($.find.byKey(Key('display_name_field')), 'Test User');
      
      // Simulate photo upload
      await $.tap($.find.byIcon(Icons.camera_alt));
      await $.pumpAndSettle();
      await IntegrationTestHelper.simulatePhotoSelection();
      await $.pumpAndSettle();
      
      await $.tap($.find.text('Continue'));
      await $.pumpAndSettle();
    }

    Future<void> _completeTutorial(PatrolIntegrationTester $) async {
      // Navigate through tutorial screens
      for (int i = 0; i < 3; i++) {
        await $.tap($.find.text('Next'));
        await $.pumpAndSettle();
      }
      
      await $.tap($.find.text('Get Started'));
      await $.pumpAndSettle();
    }

    Future<void> _performFirstSocialInteraction(PatrolIntegrationTester $) async {
      // Like a sample post
      await $.tap($.find.byIcon(Icons.favorite_border).first);
      await $.pumpAndSettle();
      
      // Verify tutorial completion
      expect($.find.text('Great! You liked your first post'), findsOneWidget);
    }

    Future<void> _loginTestUser(PatrolIntegrationTester $) async {
      await $.enterText($.find.byKey(Key('email_field')), 'test@example.com');
      await $.enterText($.find.byKey(Key('password_field')), 'TestPassword123!');
      await $.tap($.find.text('Sign In'));
      await $.pumpAndSettle();
    }

    Future<void> _createTestContent(PatrolIntegrationTester $) async {
      await $.tap($.find.byIcon(Icons.add));
      await $.enterText($.find.byType(TextField), 'Test content');
      await $.tap($.find.text('Post'));
      await $.pumpAndSettle();
    }

    Future<void> _loginTestUserWithLargeDataset(PatrolIntegrationTester $) async {
      await $.enterText($.find.byKey(Key('email_field')), 'heavy-user@example.com');
      await $.enterText($.find.byKey(Key('password_field')), 'TestPassword123!');
      await $.tap($.find.text('Sign In'));
      await $.pumpAndSettle();
    }
  });
}
```

## 🎭 **Advanced Mocking Techniques**

### **Service Layer Mocking with Realistic Behavior**

```dart
// test/integration/mocks/advanced_service_mocks.dart
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// Advanced HTTP Service Mock with Realistic Network Behavior
class RealisticHttpMock extends Mock implements http.Client {
  final Map<String, dynamic> _responses = {};
  final Map<String, int> _latencies = {};
  final Map<String, double> _failureRates = {};
  final Map<String, int> _requestCounts = {};

  // Configure realistic response patterns
  void configureEndpoint({
    required String url,
    required Map<String, dynamic> response,
    int latencyMs = 200,
    double failureRate = 0.0,
  }) {
    _responses[url] = response;
    _latencies[url] = latencyMs;
    _failureRates[url] = failureRate;
    _requestCounts[url] = 0;
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _simulateRequest(url.toString(), 'GET');
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return _simulateRequest(url.toString(), 'POST', body: body);
  }

  Future<http.Response> _simulateRequest(
    String url,
    String method, {
    Object? body,
  }) async {
    _requestCounts[url] = (_requestCounts[url] ?? 0) + 1;

    // Simulate network latency
    final latency = _latencies[url] ?? 200;
    await Future.delayed(Duration(milliseconds: latency));

    // Simulate failure rate
    final failureRate = _failureRates[url] ?? 0.0;
    if (Random().nextDouble() < failureRate) {
      throw http.ClientException('Network error simulated');
    }

    // Simulate rate limiting
    if (_requestCounts[url]! > 100) {
      return http.Response(
        jsonEncode({'error': 'Rate limit exceeded'}),
        429,
        headers: {'content-type': 'application/json'},
      );
    }

    // Return configured response
    final response = _responses[url];
    if (response != null) {
      return http.Response(
        jsonEncode(response),
        200,
        headers: {'content-type': 'application/json'},
      );
    }

    return http.Response('Not found', 404);
  }

  // Analytics for testing
  int getRequestCount(String url) => _requestCounts[url] ?? 0;
  
  void resetCounters() => _requestCounts.clear();
}

// Advanced Firebase Service Mock with Emulator Integration
class HybridFirebaseMock {
  static bool _useEmulators = true;
  static final Map<String, dynamic> _mockData = {};
  static final StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  static void enableEmulators() => _useEmulators = true;
  static void enableMocks() => _useEmulators = false;

  // Hybrid approach: use emulators when possible, mocks for edge cases
  static Future<DocumentSnapshot> getDocument(String path) async {
    if (_useEmulators) {
      // Use actual Firebase emulator
      return await FirebaseFirestore.instance.doc(path).get();
    } else {
      // Use mock data
      final data = _mockData[path];
      return MockDocumentSnapshot(path, data);
    }
  }

  static Stream<DocumentSnapshot> streamDocument(String path) {
    if (_useEmulators) {
      return FirebaseFirestore.instance.doc(path).snapshots();
    } else {
      return _streamController.stream
          .where((event) => event['path'] == path)
          .map((event) => MockDocumentSnapshot(path, event['data']));
    }
  }

  // Simulate complex Firebase scenarios
  static void simulateConnectionLoss() {
    _useEmulators = false;
    _mockData.clear();
  }

  static void simulateConnectionRestore() {
    _useEmulators = true;
  }

  static void injectMockData(String path, Map<String, dynamic> data) {
    _mockData[path] = data;
    _streamController.add({'path': path, 'data': data});
  }
}

// Platform Channel Mock for Native Features
class PlatformChannelMock {
  static const MethodChannel _channel = MethodChannel('test_platform_channel');
  static final Map<String, dynamic> _responses = {};
  static final List<MethodCall> _callHistory = [];

  static void setupMock() {
    _channel.setMockMethodCallHandler(_handleMethodCall);
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    _callHistory.add(call);

    switch (call.method) {
      case 'camera.takePicture':
        return _simulateCameraCapture();
      case 'location.getCurrentPosition':
        return _simulateLocationRequest();
      case 'notifications.requestPermission':
        return _simulatePermissionRequest();
      case 'background.scheduleTask':
        return _simulateBackgroundTask();
      default:
        return _responses[call.method];
    }
  }

  static Map<String, dynamic> _simulateCameraCapture() {
    // Simulate camera capture with realistic delay
    return {
      'path': '/mock/path/to/image.jpg',
      'width': 1920,
      'height': 1080,
      'size': 2048000,
    };
  }

  static Map<String, double> _simulateLocationRequest() {
    return {
      'latitude': 37.7749,
      'longitude': -122.4194,
      'accuracy': 5.0,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toDouble(),
    };
  }

  static bool _simulatePermissionRequest() {
    // Simulate user granting permission 80% of the time
    return Random().nextDouble() < 0.8;
  }

  static String _simulateBackgroundTask() {
    return 'task_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Test utilities
  static List<MethodCall> getCallHistory() => List.from(_callHistory);
  static void clearCallHistory() => _callHistory.clear();
  static void setResponse(String method, dynamic response) {
    _responses[method] = response;
  }
}
```

### **State-Based Mocking for Complex Scenarios**

```dart
// Advanced state-based mocking for integration tests
class StatefulServiceMock {
  // Chat service mock with realistic state management
  static class ChatServiceMock {
    static final Map<String, List<Message>> _chatMessages = {};
    static final Map<String, Set<String>> _typingUsers = {};
    static final Map<String, UserPresence> _userPresence = {};
    static final StreamController<ChatEvent> _eventController =
        StreamController.broadcast();

    static Future<void> sendMessage(String chatId, String content, String userId) async {
      // Simulate message processing delay
      await Future.delayed(Duration(milliseconds: 200));

      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: userId,
        content: content,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      _chatMessages.putIfAbsent(chatId, () => []).add(message);
      
      // Simulate real-time delivery to other users
      _eventController.add(ChatEvent.messageReceived(message));

      // Simulate read receipts after delay
      Timer(Duration(seconds: 2), () {
        message.status = MessageStatus.read;
        _eventController.add(ChatEvent.messageStatusUpdated(message));
      });
    }

    static void setUserTyping(String chatId, String userId, bool isTyping) {
      final typingSet = _typingUsers.putIfAbsent(chatId, () => {});
      
      if (isTyping) {
        typingSet.add(userId);
      } else {
        typingSet.remove(userId);
      }

      _eventController.add(ChatEvent.typingStatusChanged(chatId, List.from(typingSet)));

      // Auto-clear typing after 3 seconds
      if (isTyping) {
        Timer(Duration(seconds: 3), () {
          setUserTyping(chatId, userId, false);
        });
      }
    }

    static void setUserPresence(String userId, UserPresence presence) {
      _userPresence[userId] = presence;
      _eventController.add(ChatEvent.presenceChanged(userId, presence));
    }

    static Stream<List<Message>> streamMessages(String chatId) {
      return _eventController.stream
          .where((event) => event.chatId == chatId && event.type == ChatEventType.messageReceived)
          .map((event) => _chatMessages[chatId] ?? []);
    }

    static Stream<List<String>> streamTypingUsers(String chatId) {
      return _eventController.stream
          .where((event) => event.chatId == chatId && event.type == ChatEventType.typingChanged)
          .map((event) => List<String>.from(_typingUsers[chatId] ?? {}));
    }

    // Simulate network issues
    static void simulateNetworkIssue() {
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (Random().nextDouble() < 0.1) { // 10% chance of network issue
          _eventController.add(ChatEvent.connectionLost());
          
          Timer(Duration(seconds: 3), () {
            _eventController.add(ChatEvent.connectionRestored());
            timer.cancel();
          });
        }
      });
    }

    // Test utilities
    static void reset() {
      _chatMessages.clear();
      _typingUsers.clear();
      _userPresence.clear();
    }

    static List<Message> getMessages(String chatId) {
      return List.from(_chatMessages[chatId] ?? []);
    }
  }

  // Social feed mock with algorithmic behavior
  static class SocialFeedMock {
    static final List<Post> _allPosts = [];
    static final Map<String, UserProfile> _userProfiles = {};
    static final Map<String, List<String>> _userFollowing = {};
    static final Map<String, EngagementHistory> _engagementHistory = {};

    static Future<List<Post>> generateFeed(String userId, int limit) async {
      // Simulate feed generation delay
      await Future.delayed(Duration(milliseconds: 500));

      final userProfile = _userProfiles[userId];
      final following = _userFollowing[userId] ?? [];
      final engagement = _engagementHistory[userId] ?? EngagementHistory();

      // Simulate feed algorithm
      final scoredPosts = _allPosts.map((post) {
        double score = 0.0;

        // Recency score
        final age = DateTime.now().difference(post.createdAt).inHours;
        score += math.exp(-age / 24.0) * 100;

        // Following score
        if (following.contains(post.authorId)) {
          score += 200;
        }

        // Engagement score
        score += post.likesCount * 2 + post.commentsCount * 5;

        // Interest matching
        for (final hashtag in post.hashtags) {
          if (userProfile?.interests.contains(hashtag) == true) {
            score += 50;
          }
        }

        return ScoredPost(post, score);
      }).toList();

      scoredPosts.sort((a, b) => b.score.compareTo(a.score));
      return scoredPosts.take(limit).map((sp) => sp.post).toList();
    }

    static void addPost(Post post) {
      _allPosts.add(post);
      
      // Simulate post processing
      Timer(Duration(seconds: 1), () {
        post.status = PostStatus.published;
      });
    }

    static void simulateEngagement(String postId, String userId, EngagementType type) {
      final post = _allPosts.firstWhere((p) => p.id == postId);
      
      switch (type) {
        case EngagementType.like:
          post.likesCount++;
          break;
        case EngagementType.comment:
          post.commentsCount++;
          break;
        case EngagementType.share:
          post.sharesCount++;
          break;
        case EngagementType.view:
          post.viewsCount++;
          break;
      }

      // Update user engagement history
      final history = _engagementHistory.putIfAbsent(userId, () => EngagementHistory());
      history.addEngagement(postId, type);
    }

    // Test utilities
    static void reset() {
      _allPosts.clear();
      _userProfiles.clear();
      _userFollowing.clear();
      _engagementHistory.clear();
    }

    static void addTestData() {
      // Add sample posts and users for testing
      for (int i = 0; i < 100; i++) {
        addPost(TestDataGenerator.createPost(i));
      }
      
      for (int i = 0; i < 20; i++) {
        final userId = 'user_$i';
        _userProfiles[userId] = TestDataGenerator.createUserProfile(i);
        _userFollowing[userId] = TestDataGenerator.createFollowingList(i);
      }
    }
  }
}
```

## 🔬 **Performance Integration Testing**

### **Load Testing and Stress Testing**

```dart
// Performance integration testing framework
class PerformanceIntegrationTests {
  // Load testing for real-time features
  static Future<void> testChatLoadPerformance() async {
    const int concurrentUsers = 100;
    const int messagesPerUser = 50;
    
    final List<Future> userTasks = [];
    final Map<String, List<Duration>> messageTimes = {};

    for (int i = 0; i < concurrentUsers; i++) {
      final userId = 'load_test_user_$i';
      final chatId = 'load_test_chat';
      
      userTasks.add(_simulateUserChatActivity(userId, chatId, messagesPerUser));
    }

    final stopwatch = Stopwatch()..start();
    await Future.wait(userTasks);
    stopwatch.stop();

    // Analyze performance results
    final totalMessages = concurrentUsers * messagesPerUser;
    final messagesPerSecond = totalMessages / (stopwatch.elapsedMilliseconds / 1000);
    
    print('Load Test Results:');
    print('Total messages: $totalMessages');
    print('Total time: ${stopwatch.elapsedMilliseconds}ms');
    print('Messages per second: ${messagesPerSecond.toStringAsFixed(2)}');
    
    // Performance assertions
    expect(messagesPerSecond, greaterThan(100)); // Must handle >100 msg/sec
    expect(stopwatch.elapsedMilliseconds, lessThan(60000)); // Complete within 1 minute
  }

  static Future<void> _simulateUserChatActivity(
    String userId,
    String chatId,
    int messageCount,
  ) async {
    for (int i = 0; i < messageCount; i++) {
      final messageContent = 'Load test message $i from $userId';
      
      final stopwatch = Stopwatch()..start();
      await ChatService.sendMessage(
        chatId: chatId,
        content: messageContent,
        type: MessageType.text,
      );
      stopwatch.stop();

      // Random delay between messages (0-2 seconds)
      await Future.delayed(Duration(milliseconds: Random().nextInt(2000)));
    }
  }

  // Memory leak testing
  static Future<void> testMemoryLeaks() async {
    final initialMemory = await _getCurrentMemoryUsage();
    
    // Simulate heavy usage for 5 minutes
    final endTime = DateTime.now().add(Duration(minutes: 5));
    
    while (DateTime.now().isBefore(endTime)) {
      // Create and destroy many objects
      await _simulateHeavyObjectCreation();
      
      // Force garbage collection
      await _forceGarbageCollection();
      
      // Check memory usage
      final currentMemory = await _getCurrentMemoryUsage();
      final memoryIncrease = currentMemory - initialMemory;
      
      // Memory should not increase by more than 50MB
      expect(memoryIncrease, lessThan(50 * 1024 * 1024));
      
      await Future.delayed(Duration(seconds: 10));
    }
  }

  static Future<int> _getCurrentMemoryUsage() async {
    // Platform-specific memory usage retrieval
    // This would use method channels to get actual memory usage
    return 0; // Placeholder
  }

  static Future<void> _simulateHeavyObjectCreation() async {
    // Create many temporary objects to test memory management
    final largeList = List.generate(10000, (index) => 
      MessageModel(
        id: 'temp_$index',
        chatId: 'temp_chat',
        senderId: 'temp_user',
        content: 'Temporary message $index with some content',
        type: MessageType.text,
        timestamp: DateTime.now(),
      ),
    );
    
    // Use the list briefly
    final totalLength = largeList.fold(0, (sum, msg) => sum + msg.content.length);
    print('Created ${largeList.length} objects with total content length: $totalLength');
  }

  static Future<void> _forceGarbageCollection() async {
    // Trigger garbage collection (platform-specific)
    await Future.delayed(Duration(milliseconds: 100));
  }
}
```

This is the first part of Lesson 23 focusing on integration testing concepts, advanced mocking strategies, and end-to-end testing frameworks. The lesson continues with practical implementation, cross-platform testing, and test automation. Would you like me to continue with the remaining parts of the workshop?

**Ready to master comprehensive integration testing and advanced mocking for production Flutter applications! 🔄✨**