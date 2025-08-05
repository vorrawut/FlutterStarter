import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application-wide constants and configuration
/// 
/// This class contains all the constants used throughout the ConnectPro Ultimate
/// application, including API endpoints, Firebase configuration, UI constants,
/// feature flags, and environment-specific settings.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ============================================================================
  // APP INFORMATION
  // ============================================================================
  
  static const String appName = 'ConnectPro Ultimate';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription = 'Complete social platform with real-time features';
  
  // ============================================================================
  // ENVIRONMENT CONFIGURATION
  // ============================================================================
  
  /// Whether the app is running in debug mode
  static bool get isDebugMode => kDebugMode;
  
  /// Whether the app is running in release mode
  static bool get isReleaseMode => kReleaseMode;
  
  /// Whether the app is running in profile mode
  static bool get isProfileMode => kProfileMode;
  
  /// Current environment (development, staging, production)
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  
  /// Whether the app is running in development environment
  static bool get isDevelopment => environment == 'development';
  
  /// Whether the app is running in staging environment
  static bool get isStaging => environment == 'staging';
  
  /// Whether the app is running in production environment
  static bool get isProduction => environment == 'production';

  // ============================================================================
  // API CONFIGURATION
  // ============================================================================
  
  /// Base API URL based on environment
  static String get baseApiUrl {
    switch (environment) {
      case 'production':
        return dotenv.env['PROD_API_URL'] ?? 'https://api.connectpro.app';
      case 'staging':
        return dotenv.env['STAGING_API_URL'] ?? 'https://staging-api.connectpro.app';
      default:
        return dotenv.env['DEV_API_URL'] ?? 'https://dev-api.connectpro.app';
    }
  }
  
  /// API timeout duration
  static const Duration apiTimeoutDuration = Duration(seconds: 30);
  
  /// API retry attempts
  static const int apiRetryAttempts = 3;
  
  /// API rate limit
  static const int apiRateLimit = 100; // requests per minute

  // ============================================================================
  // FIREBASE CONFIGURATION
  // ============================================================================
  
  /// Firebase project ID based on environment
  static String get firebaseProjectId {
    switch (environment) {
      case 'production':
        return dotenv.env['FIREBASE_PROJECT_PROD'] ?? 'connectpro-ultimate-prod';
      case 'staging':
        return dotenv.env['FIREBASE_PROJECT_STAGING'] ?? 'connectpro-ultimate-staging';
      default:
        return dotenv.env['FIREBASE_PROJECT_DEV'] ?? 'connectpro-ultimate-dev';
    }
  }
  
  /// Firestore collection names
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String notificationsCollection = 'notifications';
  static const String commentsCollection = 'comments';
  static const String likesCollection = 'likes';
  static const String followersCollection = 'followers';
  static const String followingCollection = 'following';
  
  /// Firebase Storage paths
  static const String profileImagesPath = 'profile_images';
  static const String postImagesPath = 'post_images';
  static const String chatImagesPath = 'chat_images';
  static const String chatVideosPath = 'chat_videos';
  static const String chatDocumentsPath = 'chat_documents';

  // ============================================================================
  // AUTHENTICATION CONFIGURATION
  // ============================================================================
  
  /// Minimum password length
  static const int minPasswordLength = 8;
  
  /// Maximum password length
  static const int maxPasswordLength = 128;
  
  /// Session timeout duration
  static const Duration sessionTimeoutDuration = Duration(hours: 24);
  
  /// Biometric authentication timeout
  static const Duration biometricTimeoutDuration = Duration(seconds: 30);
  
  /// Maximum login attempts before lockout
  static const int maxLoginAttempts = 5;
  
  /// Account lockout duration
  static const Duration accountLockoutDuration = Duration(minutes: 15);

  // ============================================================================
  // SOCIAL FEATURES CONFIGURATION
  // ============================================================================
  
  /// Maximum post content length
  static const int maxPostContentLength = 2000;
  
  /// Maximum comment length
  static const int maxCommentLength = 500;
  
  /// Maximum bio length
  static const int maxBioLength = 150;
  
  /// Maximum display name length
  static const int maxDisplayNameLength = 50;
  
  /// Posts per page for pagination
  static const int postsPerPage = 20;
  
  /// Comments per page for pagination
  static const int commentsPerPage = 10;
  
  /// Maximum images per post
  static const int maxImagesPerPost = 10;
  
  /// Maximum video duration for posts (in seconds)
  static const int maxVideoDisplayDuration = 60;

  // ============================================================================
  // CHAT CONFIGURATION
  // ============================================================================
  
  /// Maximum message length
  static const int maxMessageLength = 1000;
  
  /// Messages per page for pagination
  static const int messagesPerPage = 50;
  
  /// Maximum file size for chat attachments (in bytes)
  static const int maxChatFileSize = 50 * 1024 * 1024; // 50 MB
  
  /// Supported chat file types
  static const List<String> supportedChatFileTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
    'mp4', 'mov', 'avi', 'mkv', // Videos
    'pdf', 'doc', 'docx', 'txt', // Documents
  ];
  
  /// Chat encryption key size
  static const int chatEncryptionKeySize = 256;
  
  /// Typing indicator timeout
  static const Duration typingIndicatorTimeout = Duration(seconds: 3);

  // ============================================================================
  // PUSH NOTIFICATIONS CONFIGURATION
  // ============================================================================
  
  /// FCM topic names
  static const String allUsersTopicName = 'all_users';
  static const String androidTopicName = 'android_users';
  static const String iosTopicName = 'ios_users';
  
  /// Notification channels (Android)
  static const String defaultNotificationChannelId = 'default_channel';
  static const String chatNotificationChannelId = 'chat_channel';
  static const String socialNotificationChannelId = 'social_channel';
  static const String systemNotificationChannelId = 'system_channel';
  
  /// Notification priorities
  static const int highPriorityNotification = 1;
  static const int defaultPriorityNotification = 0;
  static const int lowPriorityNotification = -1;

  // ============================================================================
  // UI/UX CONFIGURATION
  // ============================================================================
  
  /// Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  /// Border radius values
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;
  
  /// Padding and margin values
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  /// Icon sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;
  
  /// Avatar sizes
  static const double smallAvatarSize = 32.0;
  static const double mediumAvatarSize = 48.0;
  static const double largeAvatarSize = 64.0;
  static const double extraLargeAvatarSize = 96.0;
  
  /// Image aspect ratios
  static const double squareAspectRatio = 1.0;
  static const double landscapeAspectRatio = 16 / 9;
  static const double portraitAspectRatio = 3 / 4;

  // ============================================================================
  // PERFORMANCE CONFIGURATION
  // ============================================================================
  
  /// Image cache size (in MB)
  static const int imageCacheSize = 100;
  
  /// Maximum concurrent network requests
  static const int maxConcurrentRequests = 5;
  
  /// Image compression quality (0-100)
  static const int imageCompressionQuality = 85;
  
  /// Video compression bitrate
  static const int videoCompressionBitrate = 1000000; // 1 Mbps
  
  /// Lazy loading threshold (pixels)
  static const double lazyLoadingThreshold = 200.0;
  
  /// Debounce duration for search
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);

  // ============================================================================
  // STORAGE CONFIGURATION
  // ============================================================================
  
  /// Local storage keys
  static const String userPreferencesKey = 'user_preferences';
  static const String themePreferencesKey = 'theme_preferences';
  static const String notificationPreferencesKey = 'notification_preferences';
  static const String cachePreferencesKey = 'cache_preferences';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String biometricEnabledKey = 'biometric_enabled';
  
  /// Secure storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String encryptionKeyKey = 'encryption_key';
  static const String biometricKeyKey = 'biometric_key';
  
  /// Cache durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);
  static const Duration extraLongCacheDuration = Duration(days: 7);

  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================
  
  /// Whether dark mode is enabled by default
  static const bool isDarkModeEnabledByDefault = false;
  
  /// Whether analytics are enabled
  static bool get isAnalyticsEnabled => 
      dotenv.env['ANALYTICS_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// Whether crash reporting is enabled
  static bool get isCrashReportingEnabled => 
      dotenv.env['CRASH_REPORTING_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// Whether performance monitoring is enabled
  static bool get isPerformanceMonitoringEnabled => 
      dotenv.env['PERFORMANCE_MONITORING_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// Whether end-to-end encryption is enabled
  static bool get isEndToEndEncryptionEnabled => 
      dotenv.env['E2E_ENCRYPTION_ENABLED']?.toLowerCase() == 'true' || true;
  
  /// Whether biometric authentication is enabled
  static bool get isBiometricAuthEnabled => 
      dotenv.env['BIOMETRIC_AUTH_ENABLED']?.toLowerCase() == 'true' || true;
  
  /// Whether social features are enabled
  static bool get areSocialFeaturesEnabled => 
      dotenv.env['SOCIAL_FEATURES_ENABLED']?.toLowerCase() == 'true' || true;
  
  /// Whether chat features are enabled
  static bool get areChatFeaturesEnabled => 
      dotenv.env['CHAT_FEATURES_ENABLED']?.toLowerCase() == 'true' || true;
  
  /// Whether push notifications are enabled
  static bool get arePushNotificationsEnabled => 
      dotenv.env['PUSH_NOTIFICATIONS_ENABLED']?.toLowerCase() == 'true' || true;

  // ============================================================================
  // EXTERNAL SERVICES CONFIGURATION
  // ============================================================================
  
  /// Google Sign-In client ID
  static String get googleSignInClientId => 
      dotenv.env['GOOGLE_SIGN_IN_CLIENT_ID'] ?? '';
  
  /// Apple Sign-In service ID
  static String get appleSignInServiceId => 
      dotenv.env['APPLE_SIGN_IN_SERVICE_ID'] ?? '';
  
  /// Analytics service configuration
  static String get analyticsServiceUrl => 
      dotenv.env['ANALYTICS_SERVICE_URL'] ?? '';
  
  /// Error reporting service configuration
  static String get errorReportingServiceUrl => 
      dotenv.env['ERROR_REPORTING_SERVICE_URL'] ?? '';

  // ============================================================================
  // SECURITY CONFIGURATION
  // ============================================================================
  
  /// Certificate pinning enabled
  static bool get isCertificatePinningEnabled => 
      dotenv.env['CERTIFICATE_PINNING_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// API rate limiting enabled
  static bool get isApiRateLimitingEnabled => 
      dotenv.env['API_RATE_LIMITING_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// Request signing enabled
  static bool get isRequestSigningEnabled => 
      dotenv.env['REQUEST_SIGNING_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// Security headers required
  static bool get areSecurityHeadersRequired => 
      dotenv.env['SECURITY_HEADERS_REQUIRED']?.toLowerCase() == 'true' || isProduction;

  // ============================================================================
  // COMPLIANCE CONFIGURATION
  // ============================================================================
  
  /// GDPR compliance enabled
  static bool get isGdprComplianceEnabled => 
      dotenv.env['GDPR_COMPLIANCE_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// CCPA compliance enabled
  static bool get isCcpaComplianceEnabled => 
      dotenv.env['CCPA_COMPLIANCE_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// Data retention period (in days)
  static int get dataRetentionPeriodDays => 
      int.tryParse(dotenv.env['DATA_RETENTION_PERIOD_DAYS'] ?? '365') ?? 365;
  
  /// User data export enabled
  static bool get isUserDataExportEnabled => 
      dotenv.env['USER_DATA_EXPORT_ENABLED']?.toLowerCase() == 'true' || isProduction;
  
  /// User data deletion enabled
  static bool get isUserDataDeletionEnabled => 
      dotenv.env['USER_DATA_DELETION_ENABLED']?.toLowerCase() == 'true' || isProduction;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  /// Get environment-specific configuration value
  static String getEnvironmentConfig(String key, String defaultValue) {
    final envKey = '${environment.toUpperCase()}_$key';
    return dotenv.env[envKey] ?? dotenv.env[key] ?? defaultValue;
  }
  
  /// Check if feature is enabled
  static bool isFeatureEnabled(String featureName) {
    final key = '${featureName.toUpperCase()}_ENABLED';
    return dotenv.env[key]?.toLowerCase() == 'true' || false;
  }
  
  /// Get environment-specific URL
  static String getEnvironmentUrl(String baseKey) {
    final envKey = '${environment.toUpperCase()}_$baseKey';
    return dotenv.env[envKey] ?? dotenv.env[baseKey] ?? '';
  }
  
  /// Check if environment is development or staging
  static bool get isNonProduction => isDevelopment || isStaging;
  
  /// Get app display name with environment suffix
  static String get appDisplayName {
    if (isProduction) return appName;
    return '$appName (${environment.toUpperCase()})';
  }
}