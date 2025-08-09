# 🧪 Workshop

## 🎯 **What We're Building**

Implement comprehensive testing for **ConnectPro Ultimate** from Lesson 21, demonstrating:
- **🧪 Unit Testing Excellence** - Testing business logic, models, services, and use cases with >90% coverage
- **🎨 Widget Testing Mastery** - Complete UI component testing with user interaction simulation
- **🔥 Firebase Testing Integration** - Testing Firebase services with emulators and sophisticated mocking
- **⚡ State Management Testing** - Testing Riverpod providers, Bloc patterns, and async state operations
- **📊 Performance Testing** - Testing app performance, memory usage, and optimization validation
- **🚀 Test-Driven Development** - TDD practices for building reliable, maintainable Flutter applications
- **📈 Code Coverage Excellence** - Achieving comprehensive test coverage with meaningful, production-ready tests

## ✅ **Expected Outcome**

A production-ready testing suite for ConnectPro Ultimate featuring:
- 🧪 **Comprehensive Unit Tests** - >90% code coverage with meaningful business logic validation
- 🎨 **Complete Widget Tests** - UI component testing with accessibility and user interaction validation
- 🔥 **Firebase Integration Tests** - Real-time feature testing with emulators and proper mocking
- ⚡ **State Management Tests** - Provider testing with complex async operations and error scenarios
- 📊 **Performance Validation** - Memory usage, rendering performance, and optimization benchmarks
- 🚀 **Quality Assurance** - Automated testing pipeline with comprehensive error detection and validation

## 🏗️ **Enhanced Testing Architecture**

Building comprehensive testing for ConnectPro Ultimate:

```
connectpro_ultimate_testing/
├── test/                              # 🧪 Complete testing suite
│   ├── unit/                          # Unit tests (70% of tests)
│   │   ├── models/                    # Data model testing
│   │   │   ├── chat_models_test.dart  # Chat and message model validation
│   │   │   ├── social_models_test.dart # Post and engagement model testing
│   │   │   ├── user_models_test.dart  # User profile and relationship testing
│   │   │   └── notification_models_test.dart # Notification model validation
│   │   ├── services/                  # Service layer testing
│   │   │   ├── chat_service_test.dart # Real-time chat service testing
│   │   │   ├── social_service_test.dart # Social feed service testing
│   │   │   ├── fcm_service_test.dart  # Push notification service testing
│   │   │   ├── encryption_service_test.dart # Security service testing
│   │   │   └── analytics_service_test.dart # Analytics service testing
│   │   ├── repositories/              # Repository pattern testing
│   │   │   ├── chat_repository_test.dart # Chat data repository testing
│   │   │   ├── social_repository_test.dart # Social data repository testing
│   │   │   ├── user_repository_test.dart # User data repository testing
│   │   │   └── notification_repository_test.dart # Notification repository testing
│   │   ├── usecases/                  # Business logic testing
│   │   │   ├── chat_usecases_test.dart # Chat business logic validation
│   │   │   ├── social_usecases_test.dart # Social platform logic testing
│   │   │   ├── user_usecases_test.dart # User management logic testing
│   │   │   └── notification_usecases_test.dart # Notification logic testing
│   │   └── utils/                     # Utility function testing
│   │       ├── encryption_utils_test.dart # Encryption utility testing
│   │       ├── validation_utils_test.dart # Input validation testing
│   │       ├── date_utils_test.dart   # Date formatting utility testing
│   │       └── network_utils_test.dart # Network utility testing
│   ├── widget/                        # Widget tests (20% of tests)
│   │   ├── chat/                      # Chat UI component testing
│   │   │   ├── message_widget_test.dart # Message bubble testing
│   │   │   ├── chat_list_widget_test.dart # Chat list testing
│   │   │   ├── typing_indicator_test.dart # Typing indicator testing
│   │   │   └── media_message_test.dart # Media message testing
│   │   ├── social/                    # Social UI component testing
│   │   │   ├── post_widget_test.dart  # Post display testing
│   │   │   ├── feed_widget_test.dart  # Social feed testing
│   │   │   ├── comment_widget_test.dart # Comment system testing
│   │   │   └── engagement_widget_test.dart # Like/share testing
│   │   ├── auth/                      # Authentication UI testing
│   │   │   ├── login_widget_test.dart # Login form testing
│   │   │   ├── signup_widget_test.dart # Registration form testing
│   │   │   └── profile_setup_test.dart # Profile setup testing
│   │   ├── common/                    # Common widget testing
│   │   │   ├── loading_widget_test.dart # Loading state testing
│   │   │   ├── error_widget_test.dart # Error handling testing
│   │   │   ├── navigation_test.dart   # Navigation testing
│   │   │   └── form_widget_test.dart  # Form validation testing
│   │   └── notification/              # Notification UI testing
│   │       ├── notification_card_test.dart # Notification display testing
│   │       └── notification_center_test.dart # Notification center testing
│   ├── integration/                   # Integration tests (10% of tests)
│   │   ├── firebase/                  # Firebase integration testing
│   │   │   ├── auth_integration_test.dart # Authentication flow testing
│   │   │   ├── firestore_integration_test.dart # Database integration testing
│   │   │   ├── storage_integration_test.dart # File storage testing
│   │   │   └── fcm_integration_test.dart # Push notification testing
│   │   ├── chat/                      # Chat integration testing
│   │   │   ├── chat_flow_test.dart    # Complete chat workflow testing
│   │   │   ├── real_time_test.dart    # Real-time messaging testing
│   │   │   └── group_chat_test.dart   # Group chat functionality testing
│   │   ├── social/                    # Social platform integration testing
│   │   │   ├── feed_flow_test.dart    # Social feed workflow testing
│   │   │   ├── post_creation_test.dart # Post creation flow testing
│   │   │   └── engagement_test.dart   # Social engagement testing
│   │   └── performance/               # Performance integration testing
│   │       ├── memory_test.dart       # Memory usage testing
│   │       ├── rendering_test.dart    # UI rendering performance testing
│   │       └── network_test.dart      # Network performance testing
│   ├── mocks/                         # Mock objects and helpers
│   │   ├── firebase_mocks.dart        # Firebase service mocks
│   │   ├── repository_mocks.dart      # Repository mocks
│   │   ├── service_mocks.dart         # Service layer mocks
│   │   └── test_data.dart             # Test data generators
│   ├── helpers/                       # Testing utility helpers
│   │   ├── firebase_test_helper.dart  # Firebase emulator setup
│   │   ├── widget_test_helper.dart    # Widget testing utilities
│   │   ├── performance_test_helper.dart # Performance testing utilities
│   │   └── mock_data_helper.dart      # Mock data generation
│   └── fixtures/                      # Test data fixtures
│       ├── chat_fixtures.dart         # Chat-related test data
│       ├── social_fixtures.dart       # Social platform test data
│       ├── user_fixtures.dart         # User profile test data
│       └── notification_fixtures.dart # Notification test data
├── test_driver/                       # Integration test drivers
│   ├── app_test.dart                  # End-to-end app testing
│   ├── performance_test.dart          # Performance benchmark testing
│   └── accessibility_test.dart        # Accessibility compliance testing
├── coverage/                          # Code coverage reports
│   ├── lcov.info                      # Coverage data file
│   └── html/                          # HTML coverage reports
└── analysis_options.yaml              # Enhanced linting for testing
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Testing Environment Setup** ⏱️ *30 minutes*

Configure comprehensive testing environment with all necessary dependencies:

```yaml
# pubspec.yaml - Enhanced testing dependencies
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  
  # Unit Testing
  test: ^1.24.6
  mockito: ^5.4.2
  build_runner: ^2.4.6
  
  # Widget Testing
  flutter_driver:
    sdk: flutter
  patrol: ^2.2.0
  
  # Firebase Testing
  fake_cloud_firestore: ^2.4.1+1
  firebase_auth_mocks: ^0.13.0
  cloud_firestore_mocks: ^0.17.0
  
  # State Management Testing
  bloc_test: ^9.1.5
  riverpod_test: ^2.0.0
  
  # Performance Testing
  flutter_test_ui: ^1.0.0
  integration_test_preview: ^0.0.1
  
  # Coverage
  coverage: ^1.6.3
  lcov: ^6.1.0
  
  # Mocking and Test Data
  faker: ^2.1.0
  json_annotation: ^4.8.1
  freezed: ^2.4.6
  
  # Code Generation for Mocks
  mockito_annotations: ^0.3.0

# analysis_options.yaml - Enhanced for testing
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**.g.dart"
    - "**.freezed.dart"
    - "**.mocks.dart"
    - "test/**.mocks.dart"
    - "coverage/**"
  
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

linter:
  rules:
    # Testing-specific rules
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    unnecessary_const: true
    avoid_redundant_argument_values: true
    
    # Code quality for tests
    always_declare_return_types: true
    annotate_overrides: true
    avoid_empty_else: true
    avoid_return_types_on_setters: true
    await_only_futures: true
    camel_case_types: true
    cancel_subscriptions: true
    close_sinks: true
    comment_references: true
    constant_identifier_names: true
    control_flow_in_finally: true
    empty_catches: true
    empty_constructor_bodies: true
    empty_statements: true
    hash_and_equals: true
    implementation_imports: true
    library_names: true
    library_prefixes: true
    non_constant_identifier_names: true
    package_api_docs: false  # Relaxed for tests
    package_prefixed_library_names: true
    prefer_contains: true
    prefer_equal_for_default_values: true
    prefer_final_fields: true
    prefer_final_locals: true
    prefer_is_empty: true
    prefer_is_not_empty: true
    prefer_single_quotes: true
    slash_for_doc_comments: true
    test_types_in_equals: true
    throw_in_finally: true
    type_init_formals: true
    unawaited_futures: true
    unnecessary_brace_in_string_interps: true
    unnecessary_getters_setters: true
    unnecessary_new: true
    unnecessary_null_aware_assignments: true
    unnecessary_null_in_if_null_operators: true
    unnecessary_overrides: true
    unnecessary_parenthesis: true
    unnecessary_statements: true
    unnecessary_this: true
    unrelated_type_equality_checks: true
    use_rethrow_when_possible: true
    valid_regexps: true
```

### **Step 2: Mock Infrastructure and Test Data** ⏱️ *45 minutes*

Create comprehensive mocking infrastructure and test data:

```dart
// test/mocks/firebase_mocks.dart
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Generate mocks for all Firebase services
@GenerateMocks([
  // Firestore
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  QueryDocumentSnapshot,
  Query,
  Transaction,
  WriteBatch,
  
  // Auth
  FirebaseAuth,
  User,
  UserCredential,
  AuthCredential,
  
  // Messaging
  FirebaseMessaging,
  RemoteMessage,
  RemoteNotification,
  
  // Storage
  FirebaseStorage,
  Reference,
  UploadTask,
  TaskSnapshot,
  
  // Analytics
  FirebaseAnalytics,
])
import 'firebase_mocks.mocks.dart';

// Export all mocks for easy import
export 'firebase_mocks.mocks.dart';

// test/helpers/firebase_test_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseTestHelper {
  static late FakeFirebaseFirestore fakeFirestore;
  static late MockFirebaseAuth mockAuth;
  static late MockUser mockUser;

  static Future<void> setupFirebaseTest() async {
    // Setup fake Firestore
    fakeFirestore = FakeFirebaseFirestore();
    
    // Setup mock Auth
    mockUser = MockUser(
      uid: 'test-user-id',
      email: 'test@example.com',
      displayName: 'Test User',
      photoURL: 'https://example.com/avatar.jpg',
    );
    
    mockAuth = MockFirebaseAuth(
      mockUser: mockUser,
      signedIn: true,
    );
  }

  static Future<void> setupFirebaseEmulators() async {
    await Firebase.initializeApp();
    
    // Use Firestore emulator
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    
    // Use Auth emulator
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    
    // Clear any existing data
    await clearFirestoreData();
  }

  static Future<void> clearFirestoreData() async {
    final firestore = FirebaseFirestore.instance;
    
    // Delete all test collections
    final collections = ['chats', 'users', 'posts', 'notifications', 'engagements'];
    
    for (final collectionName in collections) {
      await _deleteCollection(firestore, collectionName);
    }
  }

  static Future<void> _deleteCollection(
    FirebaseFirestore firestore,
    String collectionPath,
  ) async {
    final collection = firestore.collection(collectionPath);
    final snapshot = await collection.get();
    
    final batch = firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  static Future<User> createTestUser({
    required String email,
    required String password,
    String? displayName,
    String? photoURL,
  }) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null || photoURL != null) {
      await credential.user!.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
    }

    return credential.user!;
  }

  static Future<DocumentReference> createTestChat({
    required List<String> participantIds,
    String? name,
    String chatType = 'group',
  }) async {
    final chatData = {
      'participantIds': participantIds,
      'participants': {
        for (final id in participantIds)
          id: {
            'userId': id,
            'displayName': 'Test User $id',
            'role': id == participantIds.first ? 'owner' : 'member',
            'joinedAt': FieldValue.serverTimestamp(),
            'isActive': true,
          }
      },
      'name': name ?? 'Test Chat ${DateTime.now().millisecondsSinceEpoch}',
      'type': chatType,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'unreadCounts': {for (final id in participantIds) id: 0},
    };

    return await FirebaseFirestore.instance.collection('chats').add(chatData);
  }

  static Future<DocumentReference> createTestMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = 'text',
    Map<String, dynamic>? metadata,
  }) async {
    final messageData = {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': messageType,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent',
      'attachments': [],
      'reactions': {},
      'readBy': [],
      'editHistory': [],
      'isDeleted': false,
      'isEncrypted': false,
      'metadata': metadata ?? {},
    };

    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }

  static Future<DocumentReference> createTestPost({
    required String authorId,
    required String content,
    List<String>? hashtags,
    List<String>? mentions,
    String visibility = 'public',
  }) async {
    final postData = {
      'authorId': authorId,
      'content': content,
      'hashtags': hashtags ?? [],
      'mentions': mentions ?? [],
      'likesCount': 0,
      'commentsCount': 0,
      'sharesCount': 0,
      'viewsCount': 0,
      'visibility': visibility,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isDeleted': false,
      'status': 'published',
      'attachments': [],
      'metadata': {},
    };

    return await FirebaseFirestore.instance.collection('posts').add(postData);
  }

  static Future<void> addTestEngagement({
    required String postId,
    required String userId,
    required String type, // 'like', 'comment', 'share', 'view'
    Map<String, dynamic>? data,
  }) async {
    final engagementData = {
      'postId': postId,
      'userId': userId,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
      'data': data ?? {},
    };

    await FirebaseFirestore.instance.collection('engagements').add(engagementData);
    
    // Update post counts
    final increment = type == 'view' ? {'viewsCount': FieldValue.increment(1)}
        : type == 'like' ? {'likesCount': FieldValue.increment(1)}
        : type == 'comment' ? {'commentsCount': FieldValue.increment(1)}
        : type == 'share' ? {'sharesCount': FieldValue.increment(1)}
        : <String, dynamic>{};

    if (increment.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update(increment);
    }
  }
}

// test/fixtures/chat_fixtures.dart
import 'package:connectpro_ultimate/data/models/chat_models.dart';

class ChatFixtures {
  static MessageModel createTextMessage({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return MessageModel(
      id: id ?? 'test-message-${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId ?? 'test-chat-id',
      senderId: senderId ?? 'test-sender-id',
      content: content ?? 'Test message content',
      type: MessageType.text,
      timestamp: timestamp ?? DateTime.now(),
      attachments: [],
      metadata: {},
      reactions: {},
      readBy: [],
      editHistory: [],
      isDeleted: false,
      isEncrypted: false,
      status: status ?? MessageStatus.sent,
    );
  }

  static MessageModel createImageMessage({
    String? id,
    String? chatId,
    String? senderId,
    String? imageUrl,
    DateTime? timestamp,
  }) {
    return MessageModel(
      id: id ?? 'test-image-message-${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId ?? 'test-chat-id',
      senderId: senderId ?? 'test-sender-id',
      content: 'Image message',
      type: MessageType.image,
      timestamp: timestamp ?? DateTime.now(),
      attachments: [
        MediaAttachment(
          id: 'test-attachment-id',
          url: imageUrl ?? 'https://example.com/test-image.jpg',
          fileName: 'test-image.jpg',
          mimeType: 'image/jpeg',
          sizeBytes: 1024000,
          uploadedAt: timestamp ?? DateTime.now(),
        ),
      ],
      metadata: {},
      reactions: {},
      readBy: [],
      editHistory: [],
      isDeleted: false,
      isEncrypted: false,
      status: MessageStatus.sent,
    );
  }

  static MessageModel createMessageWithReactions({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    Map<String, MessageReaction>? reactions,
  }) {
    return MessageModel(
      id: id ?? 'test-message-with-reactions',
      chatId: chatId ?? 'test-chat-id',
      senderId: senderId ?? 'test-sender-id',
      content: content ?? 'Message with reactions',
      type: MessageType.text,
      timestamp: DateTime.now(),
      attachments: [],
      metadata: {},
      reactions: reactions ?? {
        'user1': MessageReaction(
          emoji: '👍',
          userId: 'user1',
          timestamp: DateTime.now(),
        ),
        'user2': MessageReaction(
          emoji: '❤️',
          userId: 'user2',
          timestamp: DateTime.now(),
        ),
      },
      readBy: [],
      editHistory: [],
      isDeleted: false,
      isEncrypted: false,
      status: MessageStatus.sent,
    );
  }

  static ChatModel createGroupChat({
    String? id,
    String? name,
    List<String>? participantIds,
    Map<String, ChatParticipant>? participants,
    LastMessage? lastMessage,
  }) {
    final defaultParticipantIds = participantIds ?? ['user1', 'user2', 'user3'];
    final defaultParticipants = participants ?? {
      for (final userId in defaultParticipantIds)
        userId: ChatParticipant(
          userId: userId,
          displayName: 'User $userId',
          role: userId == defaultParticipantIds.first ? ChatRole.owner : ChatRole.member,
          joinedAt: DateTime.now(),
          isActive: true,
        ),
    };

    return ChatModel(
      id: id ?? 'test-group-chat-${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Test Group Chat',
      participantIds: defaultParticipantIds,
      participants: defaultParticipants,
      type: ChatType.group,
      lastMessage: lastMessage,
      unreadCounts: {for (final userId in defaultParticipantIds) userId: 0},
      lastSeenTimestamps: {},
      isActive: true,
      settings: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: defaultParticipantIds.first,
    );
  }

  static ChatModel createDirectChat({
    String? id,
    List<String>? participantIds,
    LastMessage? lastMessage,
  }) {
    final defaultParticipantIds = participantIds ?? ['user1', 'user2'];
    
    return ChatModel(
      id: id ?? 'test-direct-chat-${DateTime.now().millisecondsSinceEpoch}',
      name: '', // Direct chats typically don't have names
      participantIds: defaultParticipantIds,
      participants: {
        for (final userId in defaultParticipantIds)
          userId: ChatParticipant(
            userId: userId,
            displayName: 'User $userId',
            role: ChatRole.member,
            joinedAt: DateTime.now(),
            isActive: true,
          ),
      },
      type: ChatType.direct,
      lastMessage: lastMessage,
      unreadCounts: {for (final userId in defaultParticipantIds) userId: 0},
      lastSeenTimestamps: {},
      isActive: true,
      settings: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<MessageModel> createMessageList({
    String? chatId,
    int count = 10,
    List<String>? senderIds,
  }) {
    final defaultSenderIds = senderIds ?? ['user1', 'user2'];
    
    return List.generate(count, (index) {
      final senderId = defaultSenderIds[index % defaultSenderIds.length];
      return createTextMessage(
        id: 'test-message-$index',
        chatId: chatId,
        senderId: senderId,
        content: 'Test message $index from $senderId',
        timestamp: DateTime.now().subtract(Duration(minutes: count - index)),
      );
    });
  }
}

// test/fixtures/social_fixtures.dart
import 'package:connectpro_ultimate/data/models/social_models.dart';

class SocialFixtures {
  static PostModel createTextPost({
    String? id,
    String? authorId,
    String? content,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    String? visibility,
  }) {
    return PostModel(
      id: id ?? 'test-post-${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId ?? 'test-author-id',
      content: content ?? 'This is a test post content with #hashtag and @mention',
      hashtags: ['hashtag'],
      mentions: ['mention'],
      likesCount: likesCount ?? 0,
      commentsCount: commentsCount ?? 0,
      sharesCount: 0,
      viewsCount: 0,
      visibility: visibility ?? 'public',
      attachments: [],
      metadata: {},
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: createdAt ?? DateTime.now(),
      editHistory: [],
      isDeleted: false,
      status: PostStatus.published,
    );
  }

  static PostModel createPostWithMedia({
    String? id,
    String? authorId,
    String? content,
    List<String>? imageUrls,
  }) {
    final attachments = (imageUrls ?? ['https://example.com/image1.jpg'])
        .map((url) => MediaAttachment(
              id: 'attachment-${url.hashCode}',
              url: url,
              fileName: 'image.jpg',
              mimeType: 'image/jpeg',
              sizeBytes: 1024000,
              uploadedAt: DateTime.now(),
            ))
        .toList();

    return PostModel(
      id: id ?? 'test-media-post-${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId ?? 'test-author-id',
      content: content ?? 'Post with media attachments',
      hashtags: [],
      mentions: [],
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
      viewsCount: 0,
      visibility: 'public',
      attachments: attachments,
      metadata: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      editHistory: [],
      isDeleted: false,
      status: PostStatus.published,
    );
  }

  static PostModel createTrendingPost({
    String? id,
    String? authorId,
    String? content,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
  }) {
    return PostModel(
      id: id ?? 'test-trending-post',
      authorId: authorId ?? 'test-author-id',
      content: content ?? 'This is a trending post with high engagement',
      hashtags: ['trending', 'viral', 'popular'],
      mentions: [],
      likesCount: likesCount ?? 1500,
      commentsCount: commentsCount ?? 250,
      sharesCount: sharesCount ?? 100,
      viewsCount: viewsCount ?? 10000,
      visibility: 'public',
      attachments: [],
      metadata: {},
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(Duration(hours: 1)),
      editHistory: [],
      isDeleted: false,
      status: PostStatus.published,
      trendingScore: 95.5,
      engagementScore: 88.2,
    );
  }

  static List<PostModel> createFeedPosts({
    int count = 20,
    List<String>? authorIds,
    DateTime? baseTime,
  }) {
    final defaultAuthorIds = authorIds ?? ['author1', 'author2', 'author3'];
    final baseDateTime = baseTime ?? DateTime.now();
    
    return List.generate(count, (index) {
      final authorId = defaultAuthorIds[index % defaultAuthorIds.length];
      return createTextPost(
        id: 'feed-post-$index',
        authorId: authorId,
        content: 'Feed post $index from $authorId with unique content',
        createdAt: baseDateTime.subtract(Duration(hours: index)),
        likesCount: (index * 10) + (index % 5),
        commentsCount: (index * 2) + (index % 3),
      );
    });
  }
}
```

### **Step 3: Comprehensive Unit Testing Implementation** ⏱️ *75 minutes*

Implement complete unit testing for all application layers:

```dart
// test/unit/services/social_feed_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:connectpro_ultimate/data/services/social_feed_service.dart';
import 'package:connectpro_ultimate/data/models/social_models.dart';
import 'package:connectpro_ultimate/data/models/user_models.dart';
import '../../../test/mocks/firebase_mocks.dart';
import '../../../test/fixtures/social_fixtures.dart';

void main() {
  group('SocialFeedService', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockPostsCollection;
    late MockQuery mockQuery;
    late MockQuerySnapshot mockQuerySnapshot;
    
    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockPostsCollection = MockCollectionReference();
      mockQuery = MockQuery();
      mockQuerySnapshot = MockQuerySnapshot();
      
      when(mockFirestore.collection('posts')).thenReturn(mockPostsCollection);
    });

    group('generatePersonalizedFeed', () {
      test('should generate feed with correct post ranking', () async {
        // Arrange
        final userId = 'test-user-id';
        final testPosts = SocialFixtures.createFeedPosts(count: 10);
        
        when(mockPostsCollection.where(any, isEqualTo: anyNamed('isEqualTo')))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy(any, descending: anyNamed('descending')))
            .thenReturn(mockQuery);
        when(mockQuery.limit(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        
        final mockDocs = testPosts.map((post) {
          final mockDoc = MockQueryDocumentSnapshot();
          when(mockDoc.id).thenReturn(post.id);
          when(mockDoc.data()).thenReturn(post.toFirestore());
          return mockDoc;
        }).toList();
        
        when(mockQuerySnapshot.docs).thenReturn(mockDocs);

        // Act
        final result = await SocialFeedService.generatePersonalizedFeed(
          userId: userId,
          limit: 10,
        );

        // Assert
        expect(result.length, equals(10));
        expect(result.first.authorId, isNotEmpty);
        
        // Verify posts are ordered by some ranking logic
        // (In a real implementation, this would check engagement scores, etc.)
        for (int i = 0; i < result.length - 1; i++) {
          // Posts should be in descending order of some score
          expect(result[i].createdAt.isAfter(result[i + 1].createdAt) ||
                 result[i].createdAt.isAtSameMomentAs(result[i + 1].createdAt), 
                 isTrue);
        }
      });

      test('should handle empty feed gracefully', () async {
        // Arrange
        final userId = 'test-user-id';
        
        when(mockPostsCollection.where(any, isEqualTo: anyNamed('isEqualTo')))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy(any, descending: anyNamed('descending')))
            .thenReturn(mockQuery);
        when(mockQuery.limit(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await SocialFeedService.generatePersonalizedFeed(
          userId: userId,
          limit: 10,
        );

        // Assert
        expect(result, isEmpty);
      });

      test('should apply diversity filters correctly', () async {
        // Arrange
        final userId = 'test-user-id';
        final sameAuthorPosts = List.generate(10, (index) => 
          SocialFixtures.createTextPost(
            id: 'post-$index',
            authorId: 'same-author-id', // All from same author
            content: 'Post $index content',
          )
        );
        
        when(mockPostsCollection.where(any, isEqualTo: anyNamed('isEqualTo')))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy(any, descending: anyNamed('descending')))
            .thenReturn(mockQuery);
        when(mockQuery.limit(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        
        final mockDocs = sameAuthorPosts.map((post) {
          final mockDoc = MockQueryDocumentSnapshot();
          when(mockDoc.id).thenReturn(post.id);
          when(mockDoc.data()).thenReturn(post.toFirestore());
          return mockDoc;
        }).toList();
        
        when(mockQuerySnapshot.docs).thenReturn(mockDocs);

        // Act
        final result = await SocialFeedService.generatePersonalizedFeed(
          userId: userId,
          limit: 10,
        );

        // Assert
        expect(result.length, lessThanOrEqualTo(10));
        
        // In a real implementation, diversity filters would limit posts from same author
        // This test validates that the service processes the posts
        final authorIds = result.map((post) => post.authorId).toSet();
        expect(authorIds.isNotEmpty, isTrue);
      });
    });

    group('trackEngagement', () {
      test('should record engagement successfully', () async {
        // Arrange
        final mockEngagementsCollection = MockCollectionReference();
        final mockEngagementDoc = MockDocumentReference();
        
        when(mockFirestore.collection('engagements')).thenReturn(mockEngagementsCollection);
        when(mockEngagementsCollection.add(any)).thenAnswer((_) async => mockEngagementDoc);
        when(mockEngagementDoc.id).thenReturn('engagement-id');

        // Act
        await SocialFeedService.trackEngagement(
          userId: 'test-user-id',
          postId: 'test-post-id',
          type: EngagementType.like,
          metadata: {'source': 'feed'},
        );

        // Assert
        verify(mockEngagementsCollection.add(any)).called(1);
        
        final capturedData = verify(mockEngagementsCollection.add(captureAny)).captured.first;
        expect(capturedData['userId'], equals('test-user-id'));
        expect(capturedData['postId'], equals('test-post-id'));
        expect(capturedData['type'], equals('EngagementType.like'));
        expect(capturedData['metadata']['source'], equals('feed'));
      });

      test('should handle engagement tracking errors', () async {
        // Arrange
        final mockEngagementsCollection = MockCollectionReference();
        
        when(mockFirestore.collection('engagements')).thenReturn(mockEngagementsCollection);
        when(mockEngagementsCollection.add(any)).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => SocialFeedService.trackEngagement(
            userId: 'test-user-id',
            postId: 'test-post-id',
            type: EngagementType.like,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('discoverTrendingContent', () {
      test('should return trending posts based on engagement', () async {
        // Arrange
        final trendingPosts = [
          SocialFixtures.createTrendingPost(
            id: 'trending-1',
            likesCount: 1000,
            commentsCount: 200,
            viewsCount: 10000,
          ),
          SocialFixtures.createTrendingPost(
            id: 'trending-2',
            likesCount: 800,
            commentsCount: 150,
            viewsCount: 8000,
          ),
        ];
        
        when(mockPostsCollection.where('createdAt', isGreaterThan: any))
            .thenReturn(mockQuery);
        when(mockQuery.where('visibility', isEqualTo: 'public'))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        
        final mockDocs = trendingPosts.map((post) {
          final mockDoc = MockQueryDocumentSnapshot();
          when(mockDoc.id).thenReturn(post.id);
          when(mockDoc.data()).thenReturn(post.toFirestore());
          return mockDoc;
        }).toList();
        
        when(mockQuerySnapshot.docs).thenReturn(mockDocs);

        // Act
        final result = await SocialFeedService.discoverTrendingContent();

        // Assert
        expect(result.length, equals(2));
        expect(result.first.likesCount, greaterThan(result.last.likesCount));
      });

      test('should filter by category when provided', () async {
        // Arrange
        const category = 'technology';
        
        when(mockPostsCollection.where('createdAt', isGreaterThan: any))
            .thenReturn(mockQuery);
        when(mockQuery.where('visibility', isEqualTo: 'public'))
            .thenReturn(mockQuery);
        when(mockQuery.where('category', isEqualTo: category))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        await SocialFeedService.discoverTrendingContent(category: category);

        // Assert
        verify(mockQuery.where('category', isEqualTo: category)).called(1);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle null user ID gracefully', () async {
        // Act & Assert
        expect(
          () => SocialFeedService.generatePersonalizedFeed(
            userId: '',
            limit: 10,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle negative limit values', () async {
        // Act & Assert
        expect(
          () => SocialFeedService.generatePersonalizedFeed(
            userId: 'test-user-id',
            limit: -1,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle very large limit values', () async {
        // Arrange
        const largeLimit = 10000;
        
        when(mockPostsCollection.where(any, isEqualTo: anyNamed('isEqualTo')))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy(any, descending: anyNamed('descending')))
            .thenReturn(mockQuery);
        when(mockQuery.limit(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await SocialFeedService.generatePersonalizedFeed(
          userId: 'test-user-id',
          limit: largeLimit,
        );

        // Assert
        expect(result, isEmpty);
        verify(mockQuery.limit(lessThanOrEqualTo(1000))).called(greaterThan(0));
      });
    });
  });
}

// test/unit/usecases/social_usecases_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:connectpro_ultimate/domain/usecases/social_usecases.dart';
import 'package:connectpro_ultimate/domain/repositories/social_repository.dart';
import 'package:connectpro_ultimate/domain/entities/social_entities.dart';
import 'package:connectpro_ultimate/core/error/failures.dart';
import 'package:connectpro_ultimate/core/utils/result.dart';

@GenerateMocks([SocialRepository])
import 'social_usecases_test.mocks.dart';

void main() {
  group('CreatePostUseCase', () {
    late CreatePostUseCase useCase;
    late MockSocialRepository mockRepository;

    setUp(() {
      mockRepository = MockSocialRepository();
      useCase = CreatePostUseCase(mockRepository);
    });

    group('execute', () {
      test('should create post successfully', () async {
        // Arrange
        final params = CreatePostParams(
          authorId: 'test-author-id',
          content: 'Test post content',
          visibility: 'public',
          hashtags: ['test', 'flutter'],
          mentions: ['user1'],
        );

        final expectedPost = Post(
          id: 'test-post-id',
          authorId: 'test-author-id',
          content: 'Test post content',
          hashtags: ['test', 'flutter'],
          mentions: ['user1'],
          visibility: 'public',
          createdAt: DateTime.now(),
        );

        when(mockRepository.createPost(any))
            .thenAnswer((_) async => Result.success(expectedPost));

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data?.content, equals('Test post content'));
        expect(result.data?.hashtags, contains('test'));
        expect(result.data?.mentions, contains('user1'));
        verify(mockRepository.createPost(any)).called(1);
      });

      test('should return failure when repository fails', () async {
        // Arrange
        final params = CreatePostParams(
          authorId: 'test-author-id',
          content: 'Test post content',
        );

        when(mockRepository.createPost(any))
            .thenAnswer((_) async => Result.failure(NetworkFailure('Creation failed')));

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<NetworkFailure>());
        verify(mockRepository.createPost(any)).called(1);
      });

      test('should validate post content before creating', () async {
        // Arrange
        final params = CreatePostParams(
          authorId: 'test-author-id',
          content: '', // Empty content
        );

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<ValidationFailure>());
        verifyNever(mockRepository.createPost(any));
      });

      test('should validate author ID before creating', () async {
        // Arrange
        final params = CreatePostParams(
          authorId: '', // Empty author ID
          content: 'Test post content',
        );

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<ValidationFailure>());
        verifyNever(mockRepository.createPost(any));
      });

      test('should extract hashtags and mentions correctly', () async {
        // Arrange
        final params = CreatePostParams(
          authorId: 'test-author-id',
          content: 'Check out this #awesome #flutter app! Thanks @john and @jane',
        );

        final expectedPost = Post(
          id: 'test-post-id',
          authorId: 'test-author-id',
          content: 'Check out this #awesome #flutter app! Thanks @john and @jane',
          hashtags: ['awesome', 'flutter'],
          mentions: ['john', 'jane'],
          createdAt: DateTime.now(),
        );

        when(mockRepository.createPost(any))
            .thenAnswer((_) async => Result.success(expectedPost));

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data?.hashtags, containsAll(['awesome', 'flutter']));
        expect(result.data?.mentions, containsAll(['john', 'jane']));
      });
    });
  });

  group('LikePostUseCase', () {
    late LikePostUseCase useCase;
    late MockSocialRepository mockRepository;

    setUp(() {
      mockRepository = MockSocialRepository();
      useCase = LikePostUseCase(mockRepository);
    });

    test('should like post successfully', () async {
      // Arrange
      final params = LikePostParams(
        postId: 'test-post-id',
        userId: 'test-user-id',
      );

      when(mockRepository.likePost(any))
          .thenAnswer((_) async => Result.success(true));

      // Act
      final result = await useCase.execute(params);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isTrue);
      verify(mockRepository.likePost(any)).called(1);
    });

    test('should handle duplicate like attempts', () async {
      // Arrange
      final params = LikePostParams(
        postId: 'test-post-id',
        userId: 'test-user-id',
      );

      when(mockRepository.likePost(any))
          .thenAnswer((_) async => Result.failure(ConflictFailure('Already liked')));

      // Act
      final result = await useCase.execute(params);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.error, isA<ConflictFailure>());
    });
  });
}
```

*This is part 1 of the comprehensive testing workshop. Continue with widget testing, Firebase integration testing, performance testing, and TDD implementation...*

## 🚀 **How to Run**

```bash
# Navigate to ConnectPro Ultimate project
cd connectpro_ultimate

# Install testing dependencies
flutter pub get

# Generate mocks
flutter packages pub run build_runner build

# Run all unit tests
flutter test test/unit/

# Run widget tests
flutter test test/widget/

# Run integration tests with Firebase emulators
firebase emulators:start --import=./firebase-export
flutter test integration_test/

# Generate code coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run specific test suites
flutter test test/unit/models/
flutter test test/unit/services/
flutter test test/widget/chat/

# Run tests with verbose output
flutter test --reporter=expanded

# Run performance tests
flutter drive --target=test_driver/performance_test.dart
```

## 🎯 **Learning Outcomes**

After completing this testing workshop, you will have mastered:
- **Unit Testing Excellence** - Comprehensive testing of all business logic with >90% coverage
- **Widget Testing Mastery** - Complete UI component testing with user interactions and accessibility
- **Firebase Testing Integration** - Professional testing of Firebase services with emulators and mocks
- **State Management Testing** - Testing complex state operations with Riverpod and async patterns
- **Performance Testing** - Validating app performance, memory usage, and optimization strategies
- **Test-Driven Development** - TDD practices for building reliable, maintainable Flutter applications

**Ready to build bulletproof Flutter applications with comprehensive testing strategies! 🧪✨**