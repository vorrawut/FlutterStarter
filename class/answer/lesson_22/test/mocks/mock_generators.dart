// Mock generation configuration file
// Run: dart run build_runner build to generate mocks

import 'package:mockito/annotations.dart';

// Firebase Services
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Domain Layer
import 'package:connectpro_ultimate_testing/domain/repositories/chat_repository.dart';
import 'package:connectpro_ultimate_testing/domain/repositories/social_repository.dart';
import 'package:connectpro_ultimate_testing/domain/repositories/user_repository.dart';
import 'package:connectpro_ultimate_testing/domain/repositories/notification_repository.dart';

// Use Cases
import 'package:connectpro_ultimate_testing/domain/usecases/chat_usecases.dart';
import 'package:connectpro_ultimate_testing/domain/usecases/social_usecases.dart';
import 'package:connectpro_ultimate_testing/domain/usecases/user_usecases.dart';
import 'package:connectpro_ultimate_testing/domain/usecases/notification_usecases.dart';

// Data Services
import 'package:connectpro_ultimate_testing/data/services/realtime_chat_service.dart';
import 'package:connectpro_ultimate_testing/data/services/social_feed_service.dart';
import 'package:connectpro_ultimate_testing/data/services/notification_service.dart';
import 'package:connectpro_ultimate_testing/data/services/encryption_service.dart';
import 'package:connectpro_ultimate_testing/data/services/analytics_service.dart';

// Core Services
import 'package:connectpro_ultimate_testing/core/network/network_info.dart';

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

// Generate mocks for domain repositories
@GenerateMocks([
  ChatRepository,
  SocialRepository,
  UserRepository,
  NotificationRepository,
])

// Generate mocks for use cases
@GenerateMocks([
  // Chat Use Cases
  SendMessageUseCase,
  GetMessagesUseCase,
  MarkMessagesAsReadUseCase,
  CreateChatUseCase,
  AddReactionUseCase,
  EditMessageUseCase,
  DeleteMessageUseCase,
  
  // Social Use Cases
  CreatePostUseCase,
  GetFeedUseCase,
  LikePostUseCase,
  CommentOnPostUseCase,
  SharePostUseCase,
  FollowUserUseCase,
  UnfollowUserUseCase,
  GetTrendingPostsUseCase,
  
  // User Use Cases
  GetUserProfileUseCase,
  UpdateUserProfileUseCase,
  SearchUsersUseCase,
  BlockUserUseCase,
  UnblockUserUseCase,
  
  // Notification Use Cases
  SendNotificationUseCase,
  GetNotificationsUseCase,
  MarkNotificationAsReadUseCase,
  UpdateNotificationSettingsUseCase,
])

// Generate mocks for data services
@GenerateMocks([
  RealtimeChatService,
  SocialFeedService,
  NotificationService,
  EncryptionService,
  AnalyticsService,
])

// Generate mocks for core services
@GenerateMocks([
  NetworkInfo,
])

void main() {
  // This file is used by build_runner to generate mocks
  // Run: dart run build_runner build
}
