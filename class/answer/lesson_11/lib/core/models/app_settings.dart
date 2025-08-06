/// Application settings and configuration management
/// 
/// This file defines the AppSettings model for global application
/// configuration, theme preferences, and feature flags.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Theme mode preferences
enum AppThemeMode {
  light('Light'),
  dark('Dark'),
  system('System');

  const AppThemeMode(this.label);

  /// Display label for the theme mode
  final String label;

  /// Convert to Flutter ThemeMode
  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

/// Layout density preferences
enum LayoutDensity {
  compact('Compact'),
  standard('Standard'),
  comfortable('Comfortable');

  const LayoutDensity(this.label);

  /// Display label for the layout density
  final String label;

  /// Get visual density value
  VisualDensity get visualDensity {
    switch (this) {
      case LayoutDensity.compact:
        return VisualDensity.compact;
      case LayoutDensity.standard:
        return VisualDensity.standard;
      case LayoutDensity.comfortable:
        return VisualDensity.comfortable;
    }
  }
}

/// Immutable AppSettings entity for global configuration
/// 
/// Manages application-wide settings including theme preferences,
/// layout configuration, feature flags, and user experience options.
@immutable
class AppSettings {
  /// Creates a new AppSettings instance
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.primaryColor = Colors.blue,
    this.layoutDensity = LayoutDensity.standard,
    this.fontSize = 14.0,
    this.enableAnimations = true,
    this.enableHapticFeedback = true,
    this.enableSounds = true,
    this.debugMode = false,
    this.showPerformanceOverlay = false,
    this.enableAnalytics = true,
    this.enableCrashReporting = true,
    this.cacheSize = 100,
    this.offlineMode = false,
    this.autoSaveInterval = 30,
    this.maxImageQuality = 0.8,
    this.enableDataSaver = false,
    this.showOnboarding = true,
    this.language = 'en',
    this.currency = 'USD',
    this.timeZone = 'UTC',
    this.dateFormat = 'MM/dd/yyyy',
    this.timeFormat = '12h',
    this.firstRun = true,
    this.lastUpdateCheck,
    this.version = '1.0.0',
  });

  /// Theme mode preference
  final AppThemeMode themeMode;

  /// Primary app color
  final Color primaryColor;

  /// Layout density preference
  final LayoutDensity layoutDensity;

  /// Base font size
  final double fontSize;

  /// Whether animations are enabled
  final bool enableAnimations;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Whether sounds are enabled
  final bool enableSounds;

  /// Whether debug mode is enabled
  final bool debugMode;

  /// Whether to show performance overlay
  final bool showPerformanceOverlay;

  /// Whether analytics are enabled
  final bool enableAnalytics;

  /// Whether crash reporting is enabled
  final bool enableCrashReporting;

  /// Cache size in MB
  final int cacheSize;

  /// Whether app is in offline mode
  final bool offlineMode;

  /// Auto-save interval in seconds
  final int autoSaveInterval;

  /// Maximum image quality (0.0 to 1.0)
  final double maxImageQuality;

  /// Whether data saver mode is enabled
  final bool enableDataSaver;

  /// Whether to show onboarding
  final bool showOnboarding;

  /// App language
  final String language;

  /// App currency
  final String currency;

  /// Time zone
  final String timeZone;

  /// Date format
  final String dateFormat;

  /// Time format (12h or 24h)
  final String timeFormat;

  /// Whether this is the first run
  final bool firstRun;

  /// Last update check time
  final DateTime? lastUpdateCheck;

  /// App version
  final String version;

  /// Create app settings from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (mode) => mode.name == json['themeMode'],
        orElse: () => AppThemeMode.system,
      ),
      primaryColor: Color(json['primaryColor'] as int? ?? Colors.blue.value),
      layoutDensity: LayoutDensity.values.firstWhere(
        (density) => density.name == json['layoutDensity'],
        orElse: () => LayoutDensity.standard,
      ),
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      enableAnimations: json['enableAnimations'] as bool? ?? true,
      enableHapticFeedback: json['enableHapticFeedback'] as bool? ?? true,
      enableSounds: json['enableSounds'] as bool? ?? true,
      debugMode: json['debugMode'] as bool? ?? false,
      showPerformanceOverlay: json['showPerformanceOverlay'] as bool? ?? false,
      enableAnalytics: json['enableAnalytics'] as bool? ?? true,
      enableCrashReporting: json['enableCrashReporting'] as bool? ?? true,
      cacheSize: json['cacheSize'] as int? ?? 100,
      offlineMode: json['offlineMode'] as bool? ?? false,
      autoSaveInterval: json['autoSaveInterval'] as int? ?? 30,
      maxImageQuality: (json['maxImageQuality'] as num?)?.toDouble() ?? 0.8,
      enableDataSaver: json['enableDataSaver'] as bool? ?? false,
      showOnboarding: json['showOnboarding'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'USD',
      timeZone: json['timeZone'] as String? ?? 'UTC',
      dateFormat: json['dateFormat'] as String? ?? 'MM/dd/yyyy',
      timeFormat: json['timeFormat'] as String? ?? '12h',
      firstRun: json['firstRun'] as bool? ?? true,
      lastUpdateCheck: json['lastUpdateCheck'] != null 
          ? DateTime.parse(json['lastUpdateCheck'] as String) 
          : null,
      version: json['version'] as String? ?? '1.0.0',
    );
  }

  /// Convert app settings to JSON
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'primaryColor': primaryColor.value,
      'layoutDensity': layoutDensity.name,
      'fontSize': fontSize,
      'enableAnimations': enableAnimations,
      'enableHapticFeedback': enableHapticFeedback,
      'enableSounds': enableSounds,
      'debugMode': debugMode,
      'showPerformanceOverlay': showPerformanceOverlay,
      'enableAnalytics': enableAnalytics,
      'enableCrashReporting': enableCrashReporting,
      'cacheSize': cacheSize,
      'offlineMode': offlineMode,
      'autoSaveInterval': autoSaveInterval,
      'maxImageQuality': maxImageQuality,
      'enableDataSaver': enableDataSaver,
      'showOnboarding': showOnboarding,
      'language': language,
      'currency': currency,
      'timeZone': timeZone,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'firstRun': firstRun,
      'lastUpdateCheck': lastUpdateCheck?.toIso8601String(),
      'version': version,
    };
  }

  /// Create a copy with modified fields (immutable update pattern)
  AppSettings copyWith({
    AppThemeMode? themeMode,
    Color? primaryColor,
    LayoutDensity? layoutDensity,
    double? fontSize,
    bool? enableAnimations,
    bool? enableHapticFeedback,
    bool? enableSounds,
    bool? debugMode,
    bool? showPerformanceOverlay,
    bool? enableAnalytics,
    bool? enableCrashReporting,
    int? cacheSize,
    bool? offlineMode,
    int? autoSaveInterval,
    double? maxImageQuality,
    bool? enableDataSaver,
    bool? showOnboarding,
    String? language,
    String? currency,
    String? timeZone,
    String? dateFormat,
    String? timeFormat,
    bool? firstRun,
    DateTime? lastUpdateCheck,
    String? version,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      layoutDensity: layoutDensity ?? this.layoutDensity,
      fontSize: fontSize ?? this.fontSize,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableSounds: enableSounds ?? this.enableSounds,
      debugMode: debugMode ?? this.debugMode,
      showPerformanceOverlay: showPerformanceOverlay ?? this.showPerformanceOverlay,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
      cacheSize: cacheSize ?? this.cacheSize,
      offlineMode: offlineMode ?? this.offlineMode,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
      maxImageQuality: maxImageQuality ?? this.maxImageQuality,
      enableDataSaver: enableDataSaver ?? this.enableDataSaver,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      firstRun: firstRun ?? this.firstRun,
      lastUpdateCheck: lastUpdateCheck ?? this.lastUpdateCheck,
      version: version ?? this.version,
    );
  }

  /// Create default app settings
  factory AppSettings.defaultSettings() {
    return const AppSettings();
  }

  /// Create development settings
  factory AppSettings.development() {
    return const AppSettings(
      debugMode: true,
      showPerformanceOverlay: true,
      enableAnalytics: false,
      enableCrashReporting: false,
      showOnboarding: false,
      firstRun: false,
    );
  }

  /// Create production settings
  factory AppSettings.production() {
    return const AppSettings(
      debugMode: false,
      showPerformanceOverlay: false,
      enableAnalytics: true,
      enableCrashReporting: true,
    );
  }

  /// Update theme settings
  AppSettings updateTheme({
    AppThemeMode? themeMode,
    Color? primaryColor,
  }) {
    return copyWith(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }

  /// Update accessibility settings
  AppSettings updateAccessibility({
    LayoutDensity? layoutDensity,
    double? fontSize,
    bool? enableAnimations,
    bool? enableHapticFeedback,
    bool? enableSounds,
  }) {
    return copyWith(
      layoutDensity: layoutDensity ?? this.layoutDensity,
      fontSize: fontSize ?? this.fontSize,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableSounds: enableSounds ?? this.enableSounds,
    );
  }

  /// Update performance settings
  AppSettings updatePerformance({
    int? cacheSize,
    double? maxImageQuality,
    bool? enableDataSaver,
    int? autoSaveInterval,
  }) {
    return copyWith(
      cacheSize: cacheSize ?? this.cacheSize,
      maxImageQuality: maxImageQuality ?? this.maxImageQuality,
      enableDataSaver: enableDataSaver ?? this.enableDataSaver,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
    );
  }

  /// Update privacy settings
  AppSettings updatePrivacy({
    bool? enableAnalytics,
    bool? enableCrashReporting,
  }) {
    return copyWith(
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
    );
  }

  /// Update localization settings
  AppSettings updateLocalization({
    String? language,
    String? currency,
    String? timeZone,
    String? dateFormat,
    String? timeFormat,
  }) {
    return copyWith(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
    );
  }

  /// Mark onboarding as completed
  AppSettings completeOnboarding() {
    return copyWith(
      showOnboarding: false,
      firstRun: false,
    );
  }

  /// Update last check time
  AppSettings updateLastCheck() {
    return copyWith(lastUpdateCheck: DateTime.now());
  }

  /// Toggle offline mode
  AppSettings toggleOfflineMode() {
    return copyWith(offlineMode: !offlineMode);
  }

  /// Reset to default settings
  AppSettings resetToDefaults() {
    return AppSettings.defaultSettings().copyWith(
      firstRun: false,
      version: version,
    );
  }

  /// Business logic: Get scaled font size
  double getScaledFontSize(double baseFontSize) {
    final scaleFactor = fontSize / 14.0; // 14.0 is the default base size
    return baseFontSize * scaleFactor;
  }

  /// Business logic: Check if accessibility features are enabled
  bool get hasAccessibilityFeatures {
    return layoutDensity != LayoutDensity.standard ||
           fontSize != 14.0 ||
           !enableAnimations ||
           !enableSounds;
  }

  /// Business logic: Check if performance mode is enabled
  bool get isPerformanceMode {
    return enableDataSaver ||
           maxImageQuality < 0.8 ||
           cacheSize < 100 ||
           !enableAnimations;
  }

  /// Business logic: Check if privacy mode is enabled
  bool get isPrivacyMode {
    return !enableAnalytics || !enableCrashReporting;
  }

  /// Business logic: Get memory usage estimation in MB
  int get estimatedMemoryUsage {
    int baseUsage = 50; // Base app memory usage
    
    // Cache contributes to memory usage
    baseUsage += cacheSize;
    
    // High quality images use more memory
    if (maxImageQuality > 0.8) baseUsage += 20;
    
    // Animations use additional memory
    if (enableAnimations) baseUsage += 10;
    
    // Performance overlay uses memory
    if (showPerformanceOverlay) baseUsage += 5;
    
    return baseUsage;
  }

  /// Business logic: Get battery usage estimation (0.0 to 1.0)
  double get estimatedBatteryUsage {
    double usage = 0.3; // Base usage
    
    // High quality images drain battery
    usage += maxImageQuality * 0.2;
    
    // Animations drain battery
    if (enableAnimations) usage += 0.1;
    
    // Haptic feedback drains battery
    if (enableHapticFeedback) usage += 0.05;
    
    // Sounds drain battery
    if (enableSounds) usage += 0.05;
    
    // Analytics drain battery
    if (enableAnalytics) usage += 0.1;
    
    return usage.clamp(0.0, 1.0);
  }

  /// Business logic: Check if settings need migration
  bool needsMigration(String currentVersion) {
    return version != currentVersion;
  }

  /// Validation: Check if app settings data is valid
  AppSettingsValidationResult validate() {
    final errors = <String>[];

    // Font size validation
    if (fontSize < 8.0 || fontSize > 32.0) {
      errors.add('Font size must be between 8 and 32');
    }

    // Cache size validation
    if (cacheSize < 10 || cacheSize > 1000) {
      errors.add('Cache size must be between 10 and 1000 MB');
    }

    // Auto save interval validation
    if (autoSaveInterval < 5 || autoSaveInterval > 300) {
      errors.add('Auto-save interval must be between 5 and 300 seconds');
    }

    // Image quality validation
    if (maxImageQuality < 0.1 || maxImageQuality > 1.0) {
      errors.add('Image quality must be between 0.1 and 1.0');
    }

    // Language validation
    if (language.isEmpty || language.length != 2) {
      errors.add('Language must be a valid 2-character code');
    }

    // Currency validation
    if (currency.isEmpty || currency.length != 3) {
      errors.add('Currency must be a valid 3-character code');
    }

    // Version validation
    if (version.isEmpty) {
      errors.add('Version cannot be empty');
    }

    return AppSettingsValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.themeMode == themeMode &&
        other.primaryColor == primaryColor &&
        other.layoutDensity == layoutDensity &&
        other.fontSize == fontSize &&
        other.enableAnimations == enableAnimations &&
        other.enableHapticFeedback == enableHapticFeedback &&
        other.enableSounds == enableSounds &&
        other.debugMode == debugMode &&
        other.showPerformanceOverlay == showPerformanceOverlay &&
        other.enableAnalytics == enableAnalytics &&
        other.enableCrashReporting == enableCrashReporting &&
        other.cacheSize == cacheSize &&
        other.offlineMode == offlineMode &&
        other.autoSaveInterval == autoSaveInterval &&
        other.maxImageQuality == maxImageQuality &&
        other.enableDataSaver == enableDataSaver &&
        other.showOnboarding == showOnboarding &&
        other.language == language &&
        other.currency == currency &&
        other.timeZone == timeZone &&
        other.dateFormat == dateFormat &&
        other.timeFormat == timeFormat &&
        other.firstRun == firstRun &&
        other.lastUpdateCheck == lastUpdateCheck &&
        other.version == version;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      primaryColor,
      layoutDensity,
      fontSize,
      enableAnimations,
      enableHapticFeedback,
      enableSounds,
      debugMode,
      showPerformanceOverlay,
      enableAnalytics,
      enableCrashReporting,
      cacheSize,
      offlineMode,
      autoSaveInterval,
      maxImageQuality,
      enableDataSaver,
      showOnboarding,
      language,
      currency,
      timeZone,
      dateFormat,
      timeFormat,
      firstRun,
      lastUpdateCheck,
      version,
    );
  }

  @override
  String toString() {
    return 'AppSettings('
        'theme: ${themeMode.label}, '
        'density: ${layoutDensity.label}, '
        'fontSize: $fontSize, '
        'animations: $enableAnimations, '
        'language: $language, '
        'version: $version'
        ')';
  }
}

/// App settings validation result
class AppSettingsValidationResult {
  const AppSettingsValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Whether the app settings data is valid
  final bool isValid;

  /// List of validation errors
  final List<String> errors;

  /// Get formatted error message
  String get errorMessage => errors.join('\n');

  @override
  String toString() {
    return 'AppSettingsValidationResult(isValid: $isValid, errors: ${errors.length})';
  }
}