import 'package:flutter/material.dart';

/// Application-wide constants and configuration values
/// Provides centralized access to design tokens, app metadata, and configuration
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Metadata
  static const String appName = 'ThemingMasterclass';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Flutter Theming Masterclass - Lesson 7';

  // Design System - Typography
  static const String primaryFontFamily = 'SF Pro Display';
  static const String secondaryFontFamily = 'SF Pro Text';
  static const String fallbackFontFamily = 'Roboto';

  // Design System - Spacing (8pt grid system)
  static const double space4xs = 2.0;
  static const double space3xs = 4.0;
  static const double space2xs = 6.0;
  static const double spaceXs = 8.0;
  static const double spaceSm = 12.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 20.0;
  static const double spaceXl = 24.0;
  static const double space2xl = 32.0;
  static const double space3xl = 40.0;
  static const double space4xl = 48.0;
  static const double space5xl = 64.0;
  static const double space6xl = 80.0;

  // Design System - Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radius4xl = 32.0;
  static const double radiusFull = 9999.0;

  // Design System - Elevation
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 6.0;
  static const double elevationXl = 8.0;
  static const double elevation2xl = 12.0;
  static const double elevation3xl = 16.0;
  static const double elevation4xl = 24.0;

  // Design System - Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 700);

  // Design System - Breakpoints
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointLarge = 1440.0;
  static const double breakpointXLarge = 1920.0;

  // Theme Configuration
  static const Color defaultSeedColor = Color(0xFF6750A4); // Material Purple
  static const double minTextScaleFactor = 0.5;
  static const double maxTextScaleFactor = 3.0;
  static const double defaultTextScaleFactor = 1.0;

  // Storage Keys
  static const String themeSettingsKey = 'theme_settings';
  static const String firstLaunchKey = 'first_launch';
  static const String analyticsEnabledKey = 'analytics_enabled';

  // App Configuration
  static const bool enableAnalytics = false; // Disabled for lesson
  static const bool enableCrashReporting = false; // Disabled for lesson
  static const bool enablePerformanceMonitoring = false; // Disabled for lesson

  // Accessibility Configuration
  static const double minContrastRatio = 4.5; // WCAG AA standard
  static const double preferredContrastRatio = 7.0; // WCAG AAA standard
  
  // Platform-specific configurations
  static const bool enableHapticFeedback = true;
  static const bool enableSystemNavigationBarTheming = true;
  static const bool enableStatusBarTheming = true;

  // Development Configuration
  static const bool enableDebugTools = true; // Set to false for production
  static const bool enablePerformanceOverlay = false;
  static const bool enableSemanticDebugging = false;

  // Network Configuration (for future lessons)
  static const String apiBaseUrl = 'https://api.fluttermasterclass.dev';
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // Maximum number of cached items

  // Feature Flags
  static const bool enableMaterial3 = true;
  static const bool enableDynamicColors = true;
  static const bool enableCustomFonts = true;
  static const bool enableHighContrastMode = true;
  static const bool enableTextScaling = true;
  static const bool enableThemeExtensions = true;

  // Theme Presets
  static const List<ThemePreset> themePresets = [
    ThemePreset(
      name: 'Default',
      description: 'Material Purple',
      seedColor: Color(0xFF6750A4),
    ),
    ThemePreset(
      name: 'Ocean',
      description: 'Deep Blue',
      seedColor: Color(0xFF1976D2),
    ),
    ThemePreset(
      name: 'Forest',
      description: 'Natural Green',
      seedColor: Color(0xFF388E3C),
    ),
    ThemePreset(
      name: 'Sunset',
      description: 'Warm Orange',
      seedColor: Color(0xFFFF9800),
    ),
    ThemePreset(
      name: 'Cherry',
      description: 'Vibrant Red',
      seedColor: Color(0xFFD32F2F),
    ),
    ThemePreset(
      name: 'Lavender',
      description: 'Soft Purple',
      seedColor: Color(0xFF7B1FA2),
    ),
  ];

  // UI Constants
  static const double maxContentWidth = 1200.0;
  static const double sidebarWidth = 280.0;
  static const double navigationRailWidth = 72.0;
  static const double bottomNavigationBarHeight = 80.0;
  static const double appBarHeight = 56.0;
  static const double toolbarHeight = 56.0;

  // Image Configuration
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;

  // Grid Configuration
  static const int gridCrossAxisCountMobile = 2;
  static const int gridCrossAxisCountTablet = 3;
  static const int gridCrossAxisCountDesktop = 4;
  static const double gridChildAspectRatio = 0.7;
  static const double gridSpacing = 16.0;

  // List Configuration
  static const double listItemHeight = 72.0;
  static const double listItemHeightCompact = 56.0;
  static const double listItemHeightExpanded = 88.0;

  // Button Configuration
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  static const double iconButtonSize = 48.0;
  static const double fabSize = 56.0;
  static const double fabSizeSmall = 40.0;
  static const double fabSizeLarge = 96.0;

  // Input Configuration
  static const double inputHeight = 56.0;
  static const double inputHeightCompact = 48.0;
  static const int maxInputLength = 255;
  static const int maxTextAreaLength = 1000;

  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String urlPattern = r'^https?:\/\/[^\s/$.?#].[^\s]*$';

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String timeoutErrorMessage = 'Request timed out. Please try again.';
  static const String notFoundErrorMessage = 'The requested resource was not found.';
  static const String unauthorizedErrorMessage = 'You are not authorized to perform this action.';
  static const String validationErrorMessage = 'Please check your input and try again.';

  // Success Messages
  static const String saveSuccessMessage = 'Changes saved successfully.';
  static const String deleteSuccessMessage = 'Item deleted successfully.';
  static const String updateSuccessMessage = 'Updated successfully.';
  static const String createSuccessMessage = 'Created successfully.';

  // Loading Messages
  static const String loadingMessage = 'Loading...';
  static const String savingMessage = 'Saving...';
  static const String deletingMessage = 'Deleting...';
  static const String updatingMessage = 'Updating...';

  // Confirmation Messages
  static const String deleteConfirmationMessage = 'Are you sure you want to delete this item?';
  static const String resetConfirmationMessage = 'Are you sure you want to reset to default settings?';
  static const String logoutConfirmationMessage = 'Are you sure you want to log out?';

  // Helper methods
  
  /// Get responsive grid cross axis count based on screen width
  static int getGridCrossAxisCount(double screenWidth) {
    if (screenWidth >= breakpointDesktop) {
      return gridCrossAxisCountDesktop;
    } else if (screenWidth >= breakpointTablet) {
      return gridCrossAxisCountTablet;
    } else {
      return gridCrossAxisCountMobile;
    }
  }

  /// Get responsive content padding based on screen width
  static EdgeInsets getContentPadding(double screenWidth) {
    if (screenWidth >= breakpointDesktop) {
      return const EdgeInsets.symmetric(horizontal: space4xl);
    } else if (screenWidth >= breakpointTablet) {
      return const EdgeInsets.symmetric(horizontal: space2xl);
    } else {
      return const EdgeInsets.symmetric(horizontal: spaceMd);
    }
  }

  /// Check if screen is mobile size
  static bool isMobile(double screenWidth) {
    return screenWidth < breakpointTablet;
  }

  /// Check if screen is tablet size
  static bool isTablet(double screenWidth) {
    return screenWidth >= breakpointTablet && screenWidth < breakpointDesktop;
  }

  /// Check if screen is desktop size
  static bool isDesktop(double screenWidth) {
    return screenWidth >= breakpointDesktop;
  }
}

/// Theme preset configuration
class ThemePreset {
  final String name;
  final String description;
  final Color seedColor;

  const ThemePreset({
    required this.name,
    required this.description,
    required this.seedColor,
  });

  @override
  String toString() => 'ThemePreset(name: $name, seedColor: $seedColor)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemePreset &&
        other.name == name &&
        other.description == description &&
        other.seedColor == seedColor;
  }

  @override
  int get hashCode => Object.hash(name, description, seedColor);
}

/// Platform-specific constants
class PlatformConstants {
  PlatformConstants._();

  // iOS specific
  static const double iosAppBarHeight = 44.0;
  static const double iosTabBarHeight = 83.0;
  static const double iosNavigationBarHeight = 44.0;

  // Android specific
  static const double androidAppBarHeight = 56.0;
  static const double androidBottomNavigationBarHeight = 56.0;
  static const double androidNavigationBarHeight = 56.0;

  // Web specific
  static const double webMaxContentWidth = 1200.0;
  static const double webSidebarWidth = 300.0;
  static const double webMinWindowWidth = 400.0;
  static const double webMinWindowHeight = 600.0;

  // Desktop specific
  static const double desktopWindowMinWidth = 800.0;
  static const double desktopWindowMinHeight = 600.0;
  static const double desktopTitleBarHeight = 32.0;
  static const double desktopMenuBarHeight = 28.0;
}

/// Asset paths
class AssetPaths {
  AssetPaths._();

  // Images
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String fontsPath = 'assets/fonts/';

  // Specific assets
  static const String appIcon = '${iconsPath}app_icon.png';
  static const String placeholderImage = '${imagesPath}placeholder.png';
  static const String errorImage = '${imagesPath}error.png';
  static const String loadingImage = '${imagesPath}loading.png';

  // Theme-related assets
  static const String lightModeIcon = '${iconsPath}light_mode.svg';
  static const String darkModeIcon = '${iconsPath}dark_mode.svg';
  static const String systemModeIcon = '${iconsPath}system_mode.svg';
}

/// Regular expressions for validation
class RegexPatterns {
  RegexPatterns._();

  static final RegExp email = RegExp(AppConstants.emailPattern);
  static final RegExp phone = RegExp(AppConstants.phonePattern);
  static final RegExp url = RegExp(AppConstants.urlPattern);
  static final RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp alphabetic = RegExp(r'^[a-zA-Z]+$');
  static final RegExp numeric = RegExp(r'^[0-9]+$');
  static final RegExp password = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$');
  static final RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
}

/// Environment configuration
enum Environment {
  development,
  staging,
  production,
}

/// Environment-specific configuration
class EnvironmentConfig {
  static const Environment current = Environment.development;

  static bool get isDevelopment => current == Environment.development;
  static bool get isStaging => current == Environment.staging;
  static bool get isProduction => current == Environment.production;

  static String get environmentName => current.name;

  static Map<String, dynamic> get config {
    switch (current) {
      case Environment.development:
        return {
          'apiBaseUrl': 'https://dev-api.fluttermasterclass.dev',
          'enableLogging': true,
          'enableDebugMode': true,
          'enableAnalytics': false,
        };
      case Environment.staging:
        return {
          'apiBaseUrl': 'https://staging-api.fluttermasterclass.dev',
          'enableLogging': true,
          'enableDebugMode': false,
          'enableAnalytics': true,
        };
      case Environment.production:
        return {
          'apiBaseUrl': 'https://api.fluttermasterclass.dev',
          'enableLogging': false,
          'enableDebugMode': false,
          'enableAnalytics': true,
        };
    }
  }
}