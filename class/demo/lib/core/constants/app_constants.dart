import 'dart:ui';

/// Application-wide constants
/// 
/// Demonstrates:
/// - Proper constant organization (Lesson 3: Dart Fundamentals)
/// - Type safety and null safety (Lesson 3: Dart Fundamentals)
/// - Configuration management best practices
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation
  
  // App Identity
  static const String appName = 'FlutterSocial Pro';
  static const String appVersion = '1.0.0';
  static const String appDescription = 
      'Complete social learning platform showcasing Flutter curriculum concepts';
  
  // Supported Locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('ja', 'JP'),
    Locale('ko', 'KR'),
    Locale('zh', 'CN'),
  ];
  
  // API Configuration
  static const String baseApiUrl = 'https://api.fluttersocial.pro';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String themeKey = 'app_theme_mode';
  static const String userPreferencesKey = 'user_preferences';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userProfileKey = 'user_profile';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String notificationSettingsKey = 'notification_settings';
  
  // Database Names
  static const String hiveBoxName = 'flutter_social_box';
  static const String sqliteDbName = 'flutter_social.db';
  static const int dbVersion = 1;
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String groupsCollection = 'groups';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String quizzesCollection = 'quizzes';
  static const String achievementsCollection = 'achievements';
  
  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 40.0;
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 250);
  
  // Breakpoints for Responsive Design (Lesson 8)
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double wideScreenBreakpoint = 1600;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload Limits
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 100;
  static const int maxDocumentSizeMB = 50;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi', 'mkv'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];
  
  // Feature Flags
  static const bool enableDebugMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableOfflineMode = true;
  
  // Social Features
  static const int maxPostLength = 5000;
  static const int maxCommentLength = 1000;
  static const int maxGroupNameLength = 100;
  static const int maxBioLength = 500;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;
  
  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration imageCacheExpiration = Duration(days: 7);
  static const int maxCacheSize = 100; // MB
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String authErrorMessage = 'Authentication failed. Please sign in again.';
  static const String permissionErrorMessage = 'Permission denied. Please grant required permissions.';
  
  // Success Messages
  static const String signInSuccessMessage = 'Welcome back!';
  static const String signUpSuccessMessage = 'Account created successfully!';
  static const String postCreatedMessage = 'Post shared successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';
}

/// Screen Size Helper
/// 
/// Demonstrates:
/// - Extension methods (Lesson 3: Dart Fundamentals)
/// - Responsive design utilities (Lesson 8: Responsive UI)
extension ScreenSize on Size {
  bool get isMobile => width < AppConstants.mobileBreakpoint;
  bool get isTablet => width >= AppConstants.mobileBreakpoint && 
                      width < AppConstants.desktopBreakpoint;
  bool get isDesktop => width >= AppConstants.desktopBreakpoint;
  bool get isWideScreen => width >= AppConstants.wideScreenBreakpoint;
}

/// Device Type Enum
/// 
/// Demonstrates:
/// - Enum usage (Lesson 3: Dart Fundamentals)
/// - Type safety for different screen categories
enum DeviceType {
  mobile,
  tablet,
  desktop,
  wideScreen;
  
  static DeviceType fromWidth(double width) {
    if (width < AppConstants.mobileBreakpoint) return DeviceType.mobile;
    if (width < AppConstants.desktopBreakpoint) return DeviceType.tablet;
    if (width < AppConstants.wideScreenBreakpoint) return DeviceType.desktop;
    return DeviceType.wideScreen;
  }
}
