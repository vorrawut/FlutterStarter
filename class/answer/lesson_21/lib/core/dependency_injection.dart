import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

import '../data/datasources/remote/firebase_auth_source.dart';
import '../data/datasources/remote/firestore_user_source.dart';
import '../data/datasources/remote/firestore_post_source.dart';
import '../data/datasources/remote/firestore_chat_source.dart';
import '../data/datasources/remote/cloud_functions_source.dart';
import '../data/datasources/local/hive_user_cache.dart';
import '../data/datasources/local/secure_storage.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/post_repository_impl.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/usecases/auth/sign_in_with_email.dart';
import '../domain/usecases/auth/sign_in_with_google.dart';
import '../domain/usecases/auth/sign_in_with_apple.dart';
import '../domain/usecases/auth/sign_up_with_email.dart';
import '../domain/usecases/auth/sign_out.dart';
import '../domain/usecases/auth/get_current_user.dart';
import '../domain/usecases/social/get_social_feed.dart';
import '../domain/usecases/social/create_post.dart';
import '../domain/usecases/social/like_post.dart';
import '../domain/usecases/social/comment_on_post.dart';
import '../domain/usecases/chat/get_chat_list.dart';
import '../domain/usecases/chat/get_chat_messages.dart';
import '../domain/usecases/chat/send_message.dart';
import '../domain/usecases/chat/create_chat.dart';
import '../domain/usecases/notifications/initialize_notifications.dart';
import '../domain/usecases/notifications/send_notification.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/user_provider.dart';
import '../presentation/providers/feed_provider.dart';
import '../presentation/providers/chat_provider.dart';
import '../presentation/providers/notification_provider.dart';
import 'network/dio_client.dart';
import 'network/network_info.dart';
import 'utils/encryption_service.dart';
import 'utils/image_service.dart';
import 'utils/analytics_service.dart';

/// Service locator instance
final GetIt getIt = GetIt.instance;

/// Configure all dependencies for the application
/// 
/// This function sets up the dependency injection container with all
/// necessary services, repositories, use cases, and providers using
/// the GetIt service locator pattern with clean architecture principles.
@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize logger
  getIt.registerSingleton<Logger>(
    Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    ),
  );

  // Register Firebase services
  await _registerFirebaseServices();

  // Register external services
  await _registerExternalServices();

  // Register core services
  await _registerCoreServices();

  // Register data sources
  await _registerDataSources();

  // Register repositories
  await _registerRepositories();

  // Register use cases
  await _registerUseCases();

  // Register providers
  await _registerProviders();

  getIt<Logger>().i('Dependency injection configuration completed');
}

/// Register Firebase services
Future<void> _registerFirebaseServices() async {
  // Firebase core services
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  getIt.registerSingleton<FirebaseFunctions>(FirebaseFunctions.instance);
  getIt.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  getIt.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);
  getIt.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);
}

/// Register external services
Future<void> _registerExternalServices() async {
  // Google Sign-In
  getIt.registerSingleton<GoogleSignIn>(
    GoogleSignIn(
      scopes: ['email', 'profile'],
    ),
  );

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Secure Storage
  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );

  // Connectivity
  getIt.registerSingleton<Connectivity>(Connectivity());
}

/// Register core services
Future<void> _registerCoreServices() async {
  // Network info
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // Dio client for HTTP requests
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      logger: getIt<Logger>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Encryption service
  getIt.registerLazySingleton<EncryptionService>(
    () => EncryptionServiceImpl(),
  );

  // Image service
  getIt.registerLazySingleton<ImageService>(
    () => ImageServiceImpl(
      firebaseStorage: getIt<FirebaseStorage>(),
      logger: getIt<Logger>(),
    ),
  );

  // Analytics service
  getIt.registerLazySingleton<AnalyticsService>(
    () => AnalyticsServiceImpl(
      firebaseAnalytics: getIt<FirebaseAnalytics>(),
      crashlytics: getIt<FirebaseCrashlytics>(),
      logger: getIt<Logger>(),
    ),
  );
}

/// Register data sources
Future<void> _registerDataSources() async {
  // Remote data sources
  getIt.registerLazySingleton<FirebaseAuthSource>(
    () => FirebaseAuthSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<FirestoreUserSource>(
    () => FirestoreUserSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<FirestorePostSource>(
    () => FirestorePostSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<FirestoreChatSource>(
    () => FirestoreChatSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<CloudFunctionsSource>(
    () => CloudFunctionsSourceImpl(
      functions: getIt<FirebaseFunctions>(),
      logger: getIt<Logger>(),
    ),
  );

  // Local data sources
  getIt.registerLazySingleton<HiveUserCache>(
    () => HiveUserCacheImpl(),
  );

  getIt.registerLazySingleton<SecureStorageSource>(
    () => SecureStorageSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
      logger: getIt<Logger>(),
    ),
  );
}

/// Register repositories
Future<void> _registerRepositories() async {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuthSource: getIt<FirebaseAuthSource>(),
      secureStorage: getIt<SecureStorageSource>(),
      userCache: getIt<HiveUserCache>(),
      networkInfo: getIt<NetworkInfo>(),
      analytics: getIt<AnalyticsService>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      firestoreUserSource: getIt<FirestoreUserSource>(),
      userCache: getIt<HiveUserCache>(),
      imageService: getIt<ImageService>(),
      networkInfo: getIt<NetworkInfo>(),
      analytics: getIt<AnalyticsService>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      firestorePostSource: getIt<FirestorePostSource>(),
      imageService: getIt<ImageService>(),
      networkInfo: getIt<NetworkInfo>(),
      analytics: getIt<AnalyticsService>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      firestoreChatSource: getIt<FirestoreChatSource>(),
      encryptionService: getIt<EncryptionService>(),
      networkInfo: getIt<NetworkInfo>(),
      analytics: getIt<AnalyticsService>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      firebaseMessaging: getIt<FirebaseMessaging>(),
      cloudFunctionsSource: getIt<CloudFunctionsSource>(),
      secureStorage: getIt<SecureStorageSource>(),
      analytics: getIt<AnalyticsService>(),
      logger: getIt<Logger>(),
    ),
  );
}

/// Register use cases
Future<void> _registerUseCases() async {
  // Authentication use cases
  getIt.registerLazySingleton<SignInWithEmail>(
    () => SignInWithEmail(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignInWithGoogle>(
    () => SignInWithGoogle(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignInWithApple>(
    () => SignInWithApple(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpWithEmail>(
    () => SignUpWithEmail(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignOut>(
    () => SignOut(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUser>(
    () => GetCurrentUser(getIt<AuthRepository>()),
  );

  // Social use cases
  getIt.registerLazySingleton<GetSocialFeed>(
    () => GetSocialFeed(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<CreatePost>(
    () => CreatePost(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<LikePost>(
    () => LikePost(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<CommentOnPost>(
    () => CommentOnPost(getIt<PostRepository>()),
  );

  // Chat use cases
  getIt.registerLazySingleton<GetChatList>(
    () => GetChatList(getIt<ChatRepository>()),
  );

  getIt.registerLazySingleton<GetChatMessages>(
    () => GetChatMessages(getIt<ChatRepository>()),
  );

  getIt.registerLazySingleton<SendMessage>(
    () => SendMessage(getIt<ChatRepository>()),
  );

  getIt.registerLazySingleton<CreateChat>(
    () => CreateChat(getIt<ChatRepository>()),
  );

  // Notification use cases
  getIt.registerLazySingleton<InitializeNotifications>(
    () => InitializeNotifications(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<SendNotification>(
    () => SendNotification(getIt<NotificationRepository>()),
  );
}

/// Register providers
Future<void> _registerProviders() async {
  // Note: Riverpod providers are typically registered in their respective files
  // This is just for reference - actual provider registration happens through
  // Riverpod's provider system
  
  getIt<Logger>().i('Provider registration completed via Riverpod system');
}

/// Clean up dependencies (call this when app is disposed)
Future<void> disposeDependencies() async {
  await getIt.reset();
  getIt<Logger>().i('Dependencies disposed');
}

/// Dependency injection extensions for easier access
extension DependencyInjectionExtensions on GetIt {
  /// Get authentication use cases
  AuthUseCases get authUseCases => AuthUseCases(
    signInWithEmail: get<SignInWithEmail>(),
    signInWithGoogle: get<SignInWithGoogle>(),
    signInWithApple: get<SignInWithApple>(),
    signUpWithEmail: get<SignUpWithEmail>(),
    signOut: get<SignOut>(),
    getCurrentUser: get<GetCurrentUser>(),
  );

  /// Get social use cases
  SocialUseCases get socialUseCases => SocialUseCases(
    getSocialFeed: get<GetSocialFeed>(),
    createPost: get<CreatePost>(),
    likePost: get<LikePost>(),
    commentOnPost: get<CommentOnPost>(),
  );

  /// Get chat use cases
  ChatUseCases get chatUseCases => ChatUseCases(
    getChatList: get<GetChatList>(),
    getChatMessages: get<GetChatMessages>(),
    sendMessage: get<SendMessage>(),
    createChat: get<CreateChat>(),
  );

  /// Get notification use cases
  NotificationUseCases get notificationUseCases => NotificationUseCases(
    initializeNotifications: get<InitializeNotifications>(),
    sendNotification: get<SendNotification>(),
  );
}

/// Authentication use cases bundle
class AuthUseCases {
  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;

  const AuthUseCases({
    required this.signInWithEmail,
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.signUpWithEmail,
    required this.signOut,
    required this.getCurrentUser,
  });
}

/// Social use cases bundle
class SocialUseCases {
  final GetSocialFeed getSocialFeed;
  final CreatePost createPost;
  final LikePost likePost;
  final CommentOnPost commentOnPost;

  const SocialUseCases({
    required this.getSocialFeed,
    required this.createPost,
    required this.likePost,
    required this.commentOnPost,
  });
}

/// Chat use cases bundle
class ChatUseCases {
  final GetChatList getChatList;
  final GetChatMessages getChatMessages;
  final SendMessage sendMessage;
  final CreateChat createChat;

  const ChatUseCases({
    required this.getChatList,
    required this.getChatMessages,
    required this.sendMessage,
    required this.createChat,
  });
}

/// Notification use cases bundle
class NotificationUseCases {
  final InitializeNotifications initializeNotifications;
  final SendNotification sendNotification;

  const NotificationUseCases({
    required this.initializeNotifications,
    required this.sendNotification,
  });
}