# 💬 Lesson 21: Chat/Social Feed App - Capstone Workshop

## 🎯 **What We're Building**

Create **ConnectPro Ultimate** - the definitive capstone project for Phase 5 that integrates all Firebase & Cloud concepts into a production-ready social platform featuring:
- **💬 Real-Time Chat System** - Professional messaging with typing indicators, read receipts, and media sharing
- **📱 Intelligent Social Feed** - ML-powered feed algorithm with engagement tracking and content discovery
- **☁️ Advanced Cloud Integration** - Complete Firebase ecosystem with Cloud Functions automation
- **🔔 Smart Notifications** - Intelligent push notification system with personalization and targeting
- **🔒 Enterprise Security** - End-to-end encryption, comprehensive authentication, and data protection
- **⚡ Performance Excellence** - Optimized real-time operations capable of handling millions of users
- **🧪 Production Testing** - Comprehensive testing strategy covering all real-time features and interactions

## ✅ **Expected Outcome**

A complete, production-ready social platform demonstrating:
- 💬 **Real-Time Communication** - Professional chat system with advanced features and encryption
- 📱 **Social Platform Excellence** - Intelligent feed, engagement tracking, and content discovery
- ☁️ **Cloud Architecture Mastery** - Complete Firebase integration with serverless backend automation
- 🔔 **Notification Intelligence** - Smart push notification system with personalization and analytics
- 🔒 **Security Excellence** - Enterprise-grade security with end-to-end encryption and compliance
- ⚡ **Scalable Performance** - Optimized architecture handling millions of users with real-time features
- 🧪 **Quality Assurance** - Comprehensive testing covering complex real-time interactions and edge cases

## 🏗️ **ConnectPro Ultimate Architecture**

Building the ultimate social platform that integrates all Phase 5 concepts:

```
connectpro_ultimate/
├── lib/
│   ├── core/                          # 🔧 Core infrastructure
│   │   ├── constants/                 # App constants and configuration
│   │   ├── errors/                    # Comprehensive error handling
│   │   ├── utils/                     # Utility functions and helpers
│   │   ├── security/                  # Encryption and security services
│   │   └── performance/               # Performance monitoring and optimization
│   ├── data/                          # 💾 Data layer (Clean Architecture)
│   │   ├── models/                    # Enhanced data models
│   │   │   ├── chat_models.dart       # Chat, message, and conversation models
│   │   │   ├── social_models.dart     # Post, comment, engagement models
│   │   │   ├── user_models.dart       # Enhanced user and profile models
│   │   │   └── notification_models.dart # Notification and alert models
│   │   ├── datasources/               # Data source implementations
│   │   │   ├── remote/                # Firebase remote data sources
│   │   │   │   ├── chat_remote_datasource.dart    # Real-time chat operations
│   │   │   │   ├── social_remote_datasource.dart  # Social feed and interactions
│   │   │   │   ├── user_remote_datasource.dart    # User management operations
│   │   │   │   └── notification_remote_datasource.dart # Notification operations
│   │   │   └── local/                 # Local caching and offline support
│   │   │       ├── chat_local_datasource.dart     # Chat message caching
│   │   │       ├── social_local_datasource.dart   # Feed caching and offline posts
│   │   │       └── user_local_datasource.dart     # User profile caching
│   │   ├── repositories/              # Repository implementations
│   │   │   ├── chat_repository_impl.dart          # Chat and messaging repository
│   │   │   ├── social_repository_impl.dart        # Social feed and engagement repository
│   │   │   ├── user_repository_impl.dart          # User management repository
│   │   │   └── notification_repository_impl.dart  # Notification management repository
│   │   └── services/                  # Enhanced Firebase services
│   │       ├── firebase_config.dart               # Firebase initialization and configuration
│   │       ├── realtime_chat_service.dart         # Real-time chat with advanced features
│   │       ├── social_feed_service.dart           # Intelligent feed algorithm
│   │       ├── notification_service.dart          # FCM with personalization
│   │       ├── encryption_service.dart            # End-to-end encryption
│   │       └── analytics_service.dart             # Advanced analytics and tracking
│   ├── domain/                        # 🎯 Business logic layer
│   │   ├── entities/                  # Domain entities
│   │   │   ├── chat_entities.dart     # Chat, message, conversation entities
│   │   │   ├── social_entities.dart   # Post, comment, engagement entities
│   │   │   ├── user_entities.dart     # User, profile, relationship entities
│   │   │   └── notification_entities.dart # Notification and alert entities
│   │   ├── repositories/              # Repository interfaces
│   │   │   ├── chat_repository.dart   # Chat operations interface
│   │   │   ├── social_repository.dart # Social platform interface
│   │   │   ├── user_repository.dart   # User management interface
│   │   │   └── notification_repository.dart # Notification interface
│   │   └── usecases/                  # Business use cases
│   │       ├── chat_usecases.dart     # Chat and messaging use cases
│   │       ├── social_usecases.dart   # Social feed and engagement use cases
│   │       ├── user_usecases.dart     # User management use cases
│   │       └── notification_usecases.dart # Notification management use cases
│   └── presentation/                  # 🎨 UI layer
│       ├── pages/                     # Application screens
│       │   ├── splash/                # App initialization and loading
│       │   │   └── splash_screen.dart # Enhanced splash with initialization
│       │   ├── auth/                  # Authentication screens (from Lesson 19)
│       │   │   ├── sign_in_screen.dart # Multi-provider authentication
│       │   │   ├── sign_up_screen.dart # Registration with verification
│       │   │   └── profile_setup_screen.dart # Initial profile configuration
│       │   ├── main/                  # Main application screens
│       │   │   ├── main_screen.dart   # Bottom navigation container
│       │   │   ├── home_screen.dart   # Social feed with intelligent algorithm
│       │   │   ├── chat_list_screen.dart # Chat conversations list
│       │   │   ├── profile_screen.dart # User profile with social stats
│       │   │   └── discover_screen.dart # Content and user discovery
│       │   ├── chat/                  # Real-time chat screens
│       │   │   ├── chat_screen.dart   # Individual chat interface
│       │   │   ├── group_chat_screen.dart # Group chat management
│       │   │   ├── chat_info_screen.dart # Chat details and settings
│       │   │   └── media_viewer_screen.dart # Media viewing and sharing
│       │   ├── social/                # Social interaction screens
│       │   │   ├── post_detail_screen.dart # Post details with comments
│       │   │   ├── create_post_screen.dart # Post creation with media
│       │   │   ├── user_profile_screen.dart # Other user profiles
│       │   │   └── trending_screen.dart # Trending content and hashtags
│       │   ├── notifications/         # Notification management
│       │   │   ├── notifications_screen.dart # Notification center
│       │   │   └── notification_settings_screen.dart # Notification preferences
│       │   └── settings/              # App settings and preferences
│       │       ├── settings_screen.dart # Main settings interface
│       │       ├── privacy_screen.dart # Privacy and security settings
│       │       └── about_screen.dart  # App information and credits
│       ├── widgets/                   # Reusable UI components
│       │   ├── chat/                  # Chat-specific widgets
│       │   │   ├── message_widgets.dart # Message bubbles and components
│       │   │   ├── typing_indicator.dart # Real-time typing indicators
│       │   │   ├── voice_message_widget.dart # Voice message player
│       │   │   └── media_message_widget.dart # Image/video message display
│       │   ├── social/                # Social platform widgets
│       │   │   ├── post_widgets.dart  # Post display and interaction
│       │   │   ├── comment_widgets.dart # Comment threads and replies
│       │   │   ├── engagement_widgets.dart # Like, share, save buttons
│       │   │   └── feed_widgets.dart  # Feed loading and refresh
│       │   ├── common/                # Common UI components
│       │   │   ├── loading_widgets.dart # Loading states and skeletons
│       │   │   ├── error_widgets.dart # Error handling and retry
│       │   │   ├── empty_widgets.dart # Empty state displays
│       │   │   └── animation_widgets.dart # Custom animations and transitions
│       │   └── notifications/         # Notification widgets
│       │       ├── notification_card.dart # Notification display card
│       │       └── notification_badge.dart # Unread count badge
│       └── providers/                 # State management (Riverpod)
│           ├── auth_provider.dart     # Authentication state management
│           ├── chat_providers.dart    # Chat and messaging state
│           ├── social_providers.dart  # Social feed and engagement state
│           ├── user_providers.dart    # User profile and relationship state
│           ├── notification_providers.dart # Notification state management
│           └── app_providers.dart     # Global app state and configuration
├── functions/                         # ☁️ Enhanced Cloud Functions (from Lesson 20)
│   ├── src/
│   │   ├── chat/                      # Chat-related functions
│   │   │   ├── message-functions.ts   # Message processing and routing
│   │   │   ├── chat-management.ts     # Chat creation and participant management
│   │   │   └── encryption-functions.ts # Server-side encryption support
│   │   ├── social/                    # Social platform functions
│   │   │   ├── feed-algorithm.ts      # Intelligent feed generation
│   │   │   ├── engagement-tracking.ts # User engagement analytics
│   │   │   ├── content-moderation.ts  # Advanced content filtering
│   │   │   └── recommendation-engine.ts # Content and user recommendations
│   │   ├── notifications/             # Advanced notification system
│   │   │   ├── intelligent-targeting.ts # Smart notification targeting
│   │   │   ├── personalization.ts     # Content personalization engine
│   │   │   └── delivery-optimization.ts # Send time and frequency optimization
│   │   ├── analytics/                 # Real-time analytics processing
│   │   │   ├── user-behavior.ts       # User behavior analysis
│   │   │   ├── engagement-metrics.ts  # Engagement tracking and analysis
│   │   │   └── trending-algorithm.ts  # Trending content detection
│   │   ├── security/                  # Security and validation functions
│   │   │   ├── content-validation.ts  # Advanced content validation
│   │   │   ├── user-verification.ts   # User verification and authentication
│   │   │   └── abuse-detection.ts     # Abuse and spam detection
│   │   └── maintenance/               # Background maintenance tasks
│   │       ├── data-cleanup.ts        # Automated data cleanup
│   │       ├── performance-monitoring.ts # Performance analysis
│   │       └── backup-operations.ts   # Data backup and recovery
├── test/                              # 🧪 Comprehensive testing
│   ├── unit/                          # Unit tests
│   │   ├── models/                    # Model testing
│   │   ├── repositories/              # Repository testing with mocks
│   │   ├── usecases/                  # Business logic testing
│   │   └── services/                  # Service testing with Firebase mocks
│   ├── integration/                   # Integration tests
│   │   ├── chat_integration_test.dart # Real-time chat testing
│   │   ├── social_integration_test.dart # Social platform testing
│   │   ├── notification_integration_test.dart # Notification system testing
│   │   └── security_integration_test.dart # Security and encryption testing
│   ├── widget/                        # Widget tests
│   │   ├── chat_widget_test.dart      # Chat UI component testing
│   │   ├── social_widget_test.dart    # Social platform UI testing
│   │   └── notification_widget_test.dart # Notification UI testing
│   └── e2e/                          # End-to-end tests
│       ├── chat_e2e_test.dart         # Complete chat workflow testing
│       ├── social_e2e_test.dart       # Social platform workflow testing
│       └── performance_e2e_test.dart  # Performance and load testing
├── firebase/                          # 🔥 Enhanced Firebase configuration
│   ├── firestore.rules                # Comprehensive security rules
│   ├── firestore.indexes.json         # Optimized database indexes
│   ├── storage.rules                  # File storage security rules
│   └── firebase.json                  # Complete Firebase project configuration
└── assets/                            # 🎨 Application assets
    ├── images/                        # App images and icons
    ├── animations/                    # Lottie animations and transitions
    └── sounds/                        # Notification and interaction sounds
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Project Foundation and Firebase Integration** ⏱️ *45 minutes*

Set up the complete ConnectPro Ultimate project with enhanced Firebase integration:

```yaml
# pubspec.yaml - Complete dependency configuration
name: connectpro_ultimate
description: Ultimate social platform with real-time chat and intelligent feed

dependencies:
  flutter:
    sdk: flutter
  
  # Firebase Core Services
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_functions: ^4.5.8
  firebase_messaging: ^14.7.9
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  firebase_storage: ^11.5.6
  firebase_performance: ^0.9.3+8
  
  # Authentication Providers
  google_sign_in: ^6.1.6
  sign_in_with_apple: ^5.0.0
  
  # State Management
  flutter_riverpod: ^2.4.5
  
  # Real-time Features
  stream_chat_flutter: ^7.2.0
  web_socket_channel: ^2.4.0
  
  # UI Components
  cached_network_image: ^3.3.0
  image_picker: ^1.0.4
  photo_view: ^0.14.0
  flutter_staggered_grid_view: ^0.7.0
  
  # Notifications
  flutter_local_notifications: ^16.1.0
  
  # Media and Files
  video_player: ^2.8.1
  audioplayers: ^5.2.1
  file_picker: ^6.1.1
  
  # Utilities
  uuid: ^4.1.0
  intl: ^0.18.1
  timeago: ^3.5.0
  connectivity_plus: ^5.0.1
  permission_handler: ^11.0.1
  
  # Security and Encryption
  crypto: ^3.0.3
  encrypt: ^5.0.1
  pointycastle: ^3.7.3
  
  # Performance
  flutter_cache_manager: ^3.3.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # Architecture
  get_it: ^7.6.4
  injectable: ^2.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.6
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  injectable_generator: ^2.4.1
  
  # Testing
  mocktail: ^1.0.0
  bloc_test: ^9.1.5
  fake_cloud_firestore: ^2.4.1+1
  firebase_auth_mocks: ^0.13.0
  
  # Performance Testing
  patrol: ^2.2.0
  
  # Linting
  flutter_lints: ^3.0.1
```

### **Step 2: Enhanced Data Models with Real-Time Features** ⏱️ *60 minutes*

Create comprehensive data models for the complete social platform:

```dart
// lib/data/models/chat_models.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    required List<String> participantIds,
    required Map<String, ChatParticipant> participants,
    required ChatType type,
    LastMessage? lastMessage,
    @Default({}) Map<String, int> unreadCounts,
    @Default({}) Map<String, DateTime> lastSeenTimestamps,
    @Default(true) bool isActive,
    @Default({}) Map<String, dynamic> settings,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    @Default({}) Map<String, List<String>> deletedMessagesFor,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) => 
      _$ChatModelFromJson(json);

  factory ChatModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      participantIds: List<String>.from(data['participantIds'] ?? []),
      participants: (data['participants'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                key,
                ChatParticipant.fromJson(Map<String, dynamic>.from(value)),
              )),
      type: ChatType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => ChatType.direct,
      ),
      lastMessage: data['lastMessage'] != null
          ? LastMessage.fromJson(Map<String, dynamic>.from(data['lastMessage']))
          : null,
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
      lastSeenTimestamps: (data['lastSeenTimestamps'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, (value as Timestamp).toDate())),
      isActive: data['isActive'] ?? true,
      settings: Map<String, dynamic>.from(data['settings'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
      deletedMessagesFor: (data['deletedMessagesFor'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, List<String>.from(value))),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'participantIds': participantIds,
      'participants': participants.map((key, value) => MapEntry(key, value.toJson())),
      'type': type.toString(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCounts': unreadCounts,
      'lastSeenTimestamps': lastSeenTimestamps
          .map((key, value) => MapEntry(key, Timestamp.fromDate(value))),
      'isActive': isActive,
      'settings': settings,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'deletedMessagesFor': deletedMessagesFor,
    };
  }

  // Helper methods
  bool get isGroup => type == ChatType.group;
  bool get isDirect => type == ChatType.direct;
  
  int getUnreadCount(String userId) => unreadCounts[userId] ?? 0;
  
  DateTime? getLastSeen(String userId) => lastSeenTimestamps[userId];
  
  bool isUserOnline(String userId) {
    final lastSeen = getLastSeen(userId);
    if (lastSeen == null) return false;
    return DateTime.now().difference(lastSeen).inMinutes < 5;
  }
  
  List<String> getOtherParticipants(String currentUserId) {
    return participantIds.where((id) => id != currentUserId).toList();
  }
}

enum ChatType {
  direct,
  group,
  broadcast,
  channel,
}

@freezed
class ChatParticipant with _$ChatParticipant {
  const factory ChatParticipant({
    required String userId,
    required String displayName,
    String? photoURL,
    required ChatRole role,
    required DateTime joinedAt,
    DateTime? leftAt,
    @Default(true) bool isActive,
    @Default({}) Map<String, dynamic> permissions,
  }) = _ChatParticipant;

  factory ChatParticipant.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantFromJson(json);
}

enum ChatRole {
  member,
  admin,
  owner,
  moderator,
}

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    required MessageType type,
    required DateTime timestamp,
    @Default([]) List<MediaAttachment> attachments,
    @Default({}) Map<String, dynamic> metadata,
    String? replyToMessageId,
    String? threadId,
    @Default({}) Map<String, MessageReaction> reactions,
    @Default([]) List<String> readBy,
    @Default([]) List<MessageEdit> editHistory,
    @Default(false) bool isDeleted,
    @Default(false) bool isEncrypted,
    String? encryptionKeyId,
    @Default(MessageStatus.sent) MessageStatus status,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => 
      _$MessageModelFromJson(json);

  factory MessageModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MessageModel(
      id: snapshot.id,
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] ?? '',
      content: data['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      attachments: (data['attachments'] as List<dynamic>? ?? [])
          .map((e) => MediaAttachment.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      replyToMessageId: data['replyToMessageId'],
      threadId: data['threadId'],
      reactions: (data['reactions'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                key,
                MessageReaction.fromJson(Map<String, dynamic>.from(value)),
              )),
      readBy: List<String>.from(data['readBy'] ?? []),
      editHistory: (data['editHistory'] as List<dynamic>? ?? [])
          .map((e) => MessageEdit.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      isDeleted: data['isDeleted'] ?? false,
      isEncrypted: data['isEncrypted'] ?? false,
      encryptionKeyId: data['encryptionKeyId'],
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => MessageStatus.sent,
      ),
      deliveredAt: data['deliveredAt'] != null
          ? (data['deliveredAt'] as Timestamp).toDate()
          : null,
      readAt: data['readAt'] != null
          ? (data['readAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': type.toString(),
      'timestamp': Timestamp.fromDate(timestamp),
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'metadata': metadata,
      'replyToMessageId': replyToMessageId,
      'threadId': threadId,
      'reactions': reactions.map((key, value) => MapEntry(key, value.toJson())),
      'readBy': readBy,
      'editHistory': editHistory.map((e) => e.toJson()).toList(),
      'isDeleted': isDeleted,
      'isEncrypted': isEncrypted,
      'encryptionKeyId': encryptionKeyId,
      'status': status.toString(),
      'deliveredAt': deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
    };
  }

  // Helper methods
  bool get hasAttachments => attachments.isNotEmpty;
  bool get isEdited => editHistory.isNotEmpty;
  bool get hasReactions => reactions.isNotEmpty;
  bool get isThread => threadId != null;
  bool get isReply => replyToMessageId != null;
  bool get isRead => readBy.isNotEmpty;
  bool get isDelivered => status == MessageStatus.delivered || status == MessageStatus.read;
  
  Duration get messageAge => DateTime.now().difference(timestamp);
  
  List<String> getUsersWhoReacted(String emoji) {
    return reactions.entries
        .where((entry) => entry.value.emoji == emoji)
        .map((entry) => entry.key)
        .toList();
  }
  
  Map<String, int> get reactionCounts {
    final counts = <String, int>{};
    for (final reaction in reactions.values) {
      counts[reaction.emoji] = (counts[reaction.emoji] ?? 0) + 1;
    }
    return counts;
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  location,
  contact,
  system,
  poll,
  event,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

@freezed
class MediaAttachment with _$MediaAttachment {
  const factory MediaAttachment({
    required String id,
    required String url,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? thumbnailUrl,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime uploadedAt,
  }) = _MediaAttachment;

  factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentFromJson(json);
}

@freezed
class MessageReaction with _$MessageReaction {
  const factory MessageReaction({
    required String emoji,
    required String userId,
    required DateTime timestamp,
  }) = _MessageReaction;

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionFromJson(json);
}

@freezed
class MessageEdit with _$MessageEdit {
  const factory MessageEdit({
    required String previousContent,
    required DateTime editedAt,
    required String editedBy,
  }) = _MessageEdit;

  factory MessageEdit.fromJson(Map<String, dynamic> json) =>
      _$MessageEditFromJson(json);
}

@freezed
class LastMessage with _$LastMessage {
  const factory LastMessage({
    required String content,
    required DateTime timestamp,
    required String senderId,
    required MessageType type,
    @Default(false) bool isDeleted,
  }) = _LastMessage;

  factory LastMessage.fromJson(Map<String, dynamic> json) =>
      _$LastMessageFromJson(json);
}

// lib/data/models/social_models.dart
@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String authorId,
    required String content,
    @Default([]) List<MediaAttachment> attachments,
    @Default([]) List<String> hashtags,
    @Default([]) List<String> mentions,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int sharesCount,
    @Default(0) int viewsCount,
    @Default('public') String visibility,
    String? location,
    @Default(false) bool isPinned,
    @Default(true) bool allowComments,
    @Default(true) bool allowShares,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<PostEdit> editHistory,
    @Default(false) bool isDeleted,
    @Default(PostStatus.published) PostStatus status,
    double? engagementScore,
    double? trendingScore,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => 
      _$PostModelFromJson(json);

  factory PostModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PostModel(
      id: snapshot.id,
      authorId: data['authorId'] ?? '',
      content: data['content'] ?? '',
      attachments: (data['attachments'] as List<dynamic>? ?? [])
          .map((e) => MediaAttachment.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      hashtags: List<String>.from(data['hashtags'] ?? []),
      mentions: List<String>.from(data['mentions'] ?? []),
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      sharesCount: data['sharesCount'] ?? 0,
      viewsCount: data['viewsCount'] ?? 0,
      visibility: data['visibility'] ?? 'public',
      location: data['location'],
      isPinned: data['isPinned'] ?? false,
      allowComments: data['allowComments'] ?? true,
      allowShares: data['allowShares'] ?? true,
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      editHistory: (data['editHistory'] as List<dynamic>? ?? [])
          .map((e) => PostEdit.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      isDeleted: data['isDeleted'] ?? false,
      status: PostStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => PostStatus.published,
      ),
      engagementScore: data['engagementScore']?.toDouble(),
      trendingScore: data['trendingScore']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'content': content,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'hashtags': hashtags,
      'mentions': mentions,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'visibility': visibility,
      'location': location,
      'isPinned': isPinned,
      'allowComments': allowComments,
      'allowShares': allowShares,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'editHistory': editHistory.map((e) => e.toJson()).toList(),
      'isDeleted': isDeleted,
      'status': status.toString(),
      'engagementScore': engagementScore,
      'trendingScore': trendingScore,
    };
  }

  // Helper methods
  bool get hasMedia => attachments.isNotEmpty;
  bool get isEdited => editHistory.isNotEmpty;
  bool get hasLocation => location != null && location!.isNotEmpty;
  
  double get engagementRate {
    if (viewsCount == 0) return 0.0;
    return (likesCount + commentsCount + sharesCount) / viewsCount;
  }
  
  Duration get postAge => DateTime.now().difference(createdAt);
  
  bool get isRecent => postAge.inHours < 24;
  bool get isTrending => trendingScore != null && trendingScore! > 50;
  bool get isPopular => engagementScore != null && engagementScore! > 75;
}

enum PostStatus {
  draft,
  published,
  archived,
  hidden,
  flagged,
}

@freezed
class PostEdit with _$PostEdit {
  const factory PostEdit({
    required String previousContent,
    required DateTime editedAt,
    required String editedBy,
  }) = _PostEdit;

  factory PostEdit.fromJson(Map<String, dynamic> json) =>
      _$PostEditFromJson(json);
}
```

### **Step 3: Real-Time Chat Service Implementation** ⏱️ *90 minutes*

Implement comprehensive real-time chat functionality:

```dart
// lib/data/services/realtime_chat_service.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RealtimeChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Map<String, StreamSubscription> _activeSubscriptions = {};
  static final Map<String, Timer> _typingTimers = {};
  
  // Create or get direct chat
  static Future<ChatModel> createOrGetDirectChat(String otherUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    // Check if chat already exists
    final existingChatQuery = await _firestore
        .collection('chats')
        .where('type', isEqualTo: ChatType.direct.toString())
        .where('participantIds', arrayContains: currentUserId)
        .get();
    
    for (final doc in existingChatQuery.docs) {
      final chat = ChatModel.fromFirestore(doc);
      if (chat.participantIds.contains(otherUserId)) {
        return chat;
      }
    }
    
    // Create new chat
    return await _createNewChat(
      participantIds: [currentUserId, otherUserId],
      type: ChatType.direct,
      name: '', // Will be set based on participant names
    );
  }
  
  // Create group chat
  static Future<ChatModel> createGroupChat({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  }) async {
    final currentUserId = _auth.currentUser!.uid;
    
    if (!participantIds.contains(currentUserId)) {
      participantIds.add(currentUserId);
    }
    
    return await _createNewChat(
      participantIds: participantIds,
      type: ChatType.group,
      name: name,
      description: description,
      imageUrl: imageUrl,
      createdBy: currentUserId,
    );
  }
  
  // Send message with comprehensive features
  static Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required MessageType type,
    List<MediaAttachment>? attachments,
    String? replyToMessageId,
    String? threadId,
    Map<String, dynamic>? metadata,
  }) async {
    final user = _auth.currentUser!;
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();
    
    final message = MessageModel(
      id: messageRef.id,
      chatId: chatId,
      senderId: user.uid,
      content: content,
      type: type,
      timestamp: DateTime.now(),
      attachments: attachments ?? [],
      metadata: metadata ?? {},
      replyToMessageId: replyToMessageId,
      threadId: threadId,
      status: MessageStatus.sending,
    );
    
    try {
      // Use transaction for consistency
      await _firestore.runTransaction((transaction) async {
        // Add message
        transaction.set(messageRef, message.toFirestore());
        
        // Update chat metadata
        final chatRef = _firestore.collection('chats').doc(chatId);
        transaction.update(chatRef, {
          'lastMessage': LastMessage(
            content: _getDisplayContent(message),
            timestamp: message.timestamp,
            senderId: user.uid,
            type: type,
          ).toJson(),
          'updatedAt': Timestamp.fromDate(message.timestamp),
        });
        
        // Update unread counts
        await _updateUnreadCounts(transaction, chatId, user.uid);
      });
      
      // Update message status to sent
      await messageRef.update({
        'status': MessageStatus.sent.toString(),
      });
      
      // Clear typing indicator
      await setTypingStatus(chatId: chatId, isTyping: false);
      
      // Trigger push notifications
      await _triggerMessageNotifications(chatId, message);
      
      return message.copyWith(status: MessageStatus.sent);
    } catch (e) {
      // Update message status to failed
      await messageRef.update({
        'status': MessageStatus.failed.toString(),
      });
      
      throw Exception('Failed to send message: $e');
    }
  }
  
  // Stream messages with real-time updates
  static Stream<List<MessageModel>> streamMessages({
    required String chatId,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      return Stream.empty();
    }
    
    Query query = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit);
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .where((message) => !_isMessageDeletedForUser(message, currentUserId))
          .toList();
    });
  }
  
  // Typing indicators with automatic cleanup
  static Future<void> setTypingStatus({
    required String chatId,
    required bool isTyping,
  }) async {
    final user = _auth.currentUser!;
    final typingRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('typing')
        .doc(user.uid);
    
    if (isTyping) {
      await typingRef.set({
        'isTyping': true,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });
      
      // Cancel existing timer
      _typingTimers['${chatId}_${user.uid}']?.cancel();
      
      // Auto-clear typing status after 3 seconds
      _typingTimers['${chatId}_${user.uid}'] = Timer(
        const Duration(seconds: 3),
        () => setTypingStatus(chatId: chatId, isTyping: false),
      );
    } else {
      await typingRef.delete();
      _typingTimers['${chatId}_${user.uid}']?.cancel();
    }
  }
  
  // Stream typing indicators
  static Stream<List<String>> streamTypingUsers(String chatId) {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return Stream.empty();
    
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('typing')
        .where('isTyping', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['userId'] as String)
          .where((userId) => userId != currentUserId)
          .toList();
    });
  }
  
  // Message reactions
  static Future<void> addReaction({
    required String chatId,
    required String messageId,
    required String emoji,
  }) async {
    final user = _auth.currentUser!;
    
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'reactions.${user.uid}': MessageReaction(
        emoji: emoji,
        userId: user.uid,
        timestamp: DateTime.now(),
      ).toJson(),
    });
  }
  
  static Future<void> removeReaction({
    required String chatId,
    required String messageId,
  }) async {
    final user = _auth.currentUser!;
    
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'reactions.${user.uid}': FieldValue.delete(),
    });
  }
  
  // Mark messages as read
  static Future<void> markMessagesAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    final user = _auth.currentUser!;
    final batch = _firestore.batch();
    
    for (final messageId in messageIds) {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);
      
      batch.update(messageRef, {
        'readBy': FieldValue.arrayUnion([user.uid]),
        'status': MessageStatus.read.toString(),
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    
    await batch.commit();
    
    // Update chat unread count
    await _firestore.collection('chats').doc(chatId).update({
      'unreadCounts.${user.uid}': 0,
      'lastSeenTimestamps.${user.uid}': FieldValue.serverTimestamp(),
    });
  }
  
  // Edit message
  static Future<void> editMessage({
    required String chatId,
    required String messageId,
    required String newContent,
  }) async {
    final user = _auth.currentUser!;
    
    // Get current message
    final messageDoc = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .get();
    
    if (!messageDoc.exists) {
      throw Exception('Message not found');
    }
    
    final currentMessage = MessageModel.fromFirestore(messageDoc);
    
    // Verify user can edit
    if (currentMessage.senderId != user.uid) {
      throw Exception('Cannot edit message from another user');
    }
    
    // Check if message is too old to edit (24 hours)
    if (DateTime.now().difference(currentMessage.timestamp).inHours > 24) {
      throw Exception('Message is too old to edit');
    }
    
    // Create edit history entry
    final editEntry = MessageEdit(
      previousContent: currentMessage.content,
      editedAt: DateTime.now(),
      editedBy: user.uid,
    );
    
    // Update message
    await messageDoc.reference.update({
      'content': newContent,
      'editHistory': FieldValue.arrayUnion([editEntry.toJson()]),
    });
  }
  
  // Delete message
  static Future<void> deleteMessage({
    required String chatId,
    required String messageId,
    bool deleteForEveryone = false,
  }) async {
    final user = _auth.currentUser!;
    
    if (deleteForEveryone) {
      // Get message to verify permissions
      final messageDoc = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .get();
      
      if (!messageDoc.exists) {
        throw Exception('Message not found');
      }
      
      final message = MessageModel.fromFirestore(messageDoc);
      
      // Only sender or chat admin can delete for everyone
      if (message.senderId != user.uid) {
        final chat = await getChat(chatId);
        final userRole = chat.participants[user.uid]?.role;
        
        if (userRole != ChatRole.admin && userRole != ChatRole.owner) {
          throw Exception('Insufficient permissions to delete for everyone');
        }
      }
      
      // Mark as deleted for everyone
      await messageDoc.reference.update({
        'isDeleted': true,
        'content': 'This message was deleted',
        'attachments': [],
        'metadata': {
          'deletedBy': user.uid,
          'deletedAt': FieldValue.serverTimestamp(),
        },
      });
    } else {
      // Delete only for current user
      await _firestore.collection('chats').doc(chatId).update({
        'deletedMessagesFor.${user.uid}': FieldValue.arrayUnion([messageId]),
      });
    }
  }
  
  // Stream user chats
  static Stream<List<ChatModel>> streamUserChats() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return Stream.empty();
    
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatModel.fromFirestore(doc))
          .where((chat) => chat.lastMessage != null)
          .toList();
    });
  }
  
  // Get chat details
  static Future<ChatModel> getChat(String chatId) async {
    final doc = await _firestore.collection('chats').doc(chatId).get();
    
    if (!doc.exists) {
      throw Exception('Chat not found');
    }
    
    return ChatModel.fromFirestore(doc);
  }
  
  // Helper methods
  static Future<ChatModel> _createNewChat({
    required List<String> participantIds,
    required ChatType type,
    required String name,
    String? description,
    String? imageUrl,
    String? createdBy,
  }) async {
    final chatRef = _firestore.collection('chats').doc();
    final now = DateTime.now();
    
    // Get participant details
    final participants = <String, ChatParticipant>{};
    for (final participantId in participantIds) {
      final userDoc = await _firestore.collection('users').doc(participantId).get();
      final userData = userDoc.data()!;
      
      participants[participantId] = ChatParticipant(
        userId: participantId,
        displayName: userData['displayName'] ?? '',
        photoURL: userData['photoURL'],
        role: participantId == createdBy ? ChatRole.owner : ChatRole.member,
        joinedAt: now,
      );
    }
    
    final chat = ChatModel(
      id: chatRef.id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      participantIds: participantIds,
      participants: participants,
      type: type,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
    );
    
    await chatRef.set(chat.toFirestore());
    return chat;
  }
  
  static Future<void> _updateUnreadCounts(
    Transaction transaction,
    String chatId,
    String senderId,
  ) async {
    final chatDoc = await transaction.get(
      _firestore.collection('chats').doc(chatId),
    );
    
    final participants = List<String>.from(
      chatDoc.data()?['participantIds'] ?? [],
    );
    
    for (final participantId in participants) {
      if (participantId != senderId) {
        transaction.update(
          _firestore.collection('chats').doc(chatId),
          {
            'unreadCounts.$participantId': FieldValue.increment(1),
          },
        );
      }
    }
  }
  
  static String _getDisplayContent(MessageModel message) {
    switch (message.type) {
      case MessageType.text:
        return message.content;
      case MessageType.image:
        return '📷 Photo';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.audio:
        return '🎵 Voice message';
      case MessageType.file:
        return '📎 File';
      case MessageType.location:
        return '📍 Location';
      case MessageType.contact:
        return '👤 Contact';
      default:
        return 'Message';
    }
  }
  
  static bool _isMessageDeletedForUser(MessageModel message, String userId) {
    // Implementation for checking if message is deleted for specific user
    return false; // Simplified for workshop
  }
  
  static Future<void> _triggerMessageNotifications(
    String chatId,
    MessageModel message,
  ) async {
    // Get chat details
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data()!;
    
    // Get sender info
    final senderDoc = await _firestore
        .collection('users')
        .doc(message.senderId)
        .get();
    final senderData = senderDoc.data()!;
    
    // Send notifications to other participants
    final participants = List<String>.from(chatData['participantIds']);
    participants.remove(message.senderId);
    
    for (final participantId in participants) {
      // Call Cloud Function to send notification
      // This would be implemented in the Cloud Functions
    }
  }
  
  // Cleanup subscriptions
  static void dispose() {
    for (final subscription in _activeSubscriptions.values) {
      subscription.cancel();
    }
    _activeSubscriptions.clear();
    
    for (final timer in _typingTimers.values) {
      timer.cancel();
    }
    _typingTimers.clear();
  }
}
```

*This is part 1 of the workshop. Continue with social feed implementation, UI components, testing, and deployment...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_21

# Install dependencies
flutter pub get

# Generate code for models
flutter packages pub run build_runner build

# Set up Firebase project (enhanced from previous lessons)
# 1. Use existing Firebase project from Lessons 19-20
# 2. Enable additional services: Performance Monitoring
# 3. Configure enhanced security rules for chat and social features
# 4. Set up Cloud Functions for real-time processing

# Start Firebase emulators with all services
firebase emulators:start --import=./firebase-export

# Run the complete application
flutter run

# Test the comprehensive social platform
# 1. Test real-time chat with all advanced features
# 2. Test intelligent social feed with engagement tracking
# 3. Test push notifications with personalization
# 4. Test social interactions and user discovery
# 5. Test offline functionality and synchronization
```

## 🎯 **Learning Outcomes**

After completing this capstone workshop, you will have mastered:
- **Complete Firebase Integration** - Seamless use of all Firebase services in a production application
- **Real-Time Systems Mastery** - Professional implementation of live chat and social features
- **Advanced Social Platform** - Intelligent feed algorithms, engagement tracking, and content discovery
- **Production Architecture** - Scalable, secure, and maintainable application design for millions of users
- **Security Excellence** - End-to-end encryption, comprehensive authentication, and data protection
- **Performance Optimization** - Efficient real-time operations and resource management
- **Testing Excellence** - Comprehensive testing strategies for complex real-time applications

**Ready to build the ultimate social platform with real-time chat, intelligent features, and production-grade architecture! 💬📱✨**