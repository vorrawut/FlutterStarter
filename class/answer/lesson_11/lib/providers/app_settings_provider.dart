/// App settings state management with Provider pattern
/// 
/// This file demonstrates global application settings management
/// using Provider and ChangeNotifier for configuration state.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/models/app_settings.dart';

/// App settings state management using Provider and ChangeNotifier
/// 
/// Manages global application configuration including theme, preferences,
/// and feature flags with automatic dependency injection.
class AppSettingsProvider with ChangeNotifier {
  /// Creates an app settings provider
  AppSettingsProvider() {
    _currentSettings = AppSettings.defaultSettings();
    _loadSettings();
    if (kDebugMode) {
      debugPrint('⚙️ AppSettingsProvider initialized');
    }
  }

  /// Current app settings
  AppSettings _currentSettings = AppSettings.defaultSettings();

  /// Whether settings operations are in progress
  bool _isLoading = false;

  /// Error message if any operation failed
  String? _errorMessage;

  /// When the settings were last updated
  DateTime? _lastUpdated;

  /// Get current app settings (immutable)
  AppSettings get currentSettings => _currentSettings;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Get last updated time
  DateTime? get lastUpdated => _lastUpdated;

  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error message
  void _setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update settings and timestamp
  void _updateSettings(AppSettings newSettings) {
    _currentSettings = newSettings;
    _lastUpdated = DateTime.now();
    _errorMessage = null;
    notifyListeners();
    
    // Auto-save after updates
    _saveSettings();
  }

  /// Clear error state
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Load settings from storage
  Future<void> _loadSettings() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate loading from storage
      await Future.delayed(const Duration(milliseconds: 300));

      // In a real app, this would load from SharedPreferences, Hive, etc.
      // For now, we'll use default settings
      _updateSettings(AppSettings.defaultSettings());
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('⚙️ Settings loaded from storage');
      }

    } catch (error) {
      _setError('Failed to load settings: $error');
      if (kDebugMode) {
        debugPrint('❌ Error loading settings: $error');
      }
    }
  }

  /// Save settings to storage
  Future<void> _saveSettings() async {
    try {
      // Simulate saving to storage
      await Future.delayed(const Duration(milliseconds: 100));

      // In a real app, this would save to SharedPreferences, Hive, etc.
      
      if (kDebugMode) {
        debugPrint('⚙️ Settings saved to storage');
      }

    } catch (error) {
      if (kDebugMode) {
        debugPrint('❌ Failed to save settings: $error');
      }
    }
  }

  /// Update theme settings
  Future<void> updateTheme({
    AppThemeMode? themeMode,
    Color? primaryColor,
  }) async {
    try {
      final updatedSettings = _currentSettings.updateTheme(
        themeMode: themeMode,
        primaryColor: primaryColor,
      );

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Theme updated: ${themeMode?.label}, color: ${primaryColor?.value}');
      }

    } catch (error) {
      _setError('Failed to update theme: $error');
    }
  }

  /// Update accessibility settings
  Future<void> updateAccessibility({
    LayoutDensity? layoutDensity,
    double? fontSize,
    bool? enableAnimations,
    bool? enableHapticFeedback,
    bool? enableSounds,
  }) async {
    try {
      final updatedSettings = _currentSettings.updateAccessibility(
        layoutDensity: layoutDensity,
        fontSize: fontSize,
        enableAnimations: enableAnimations,
        enableHapticFeedback: enableHapticFeedback,
        enableSounds: enableSounds,
      );

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Accessibility settings updated');
      }

    } catch (error) {
      _setError('Failed to update accessibility settings: $error');
    }
  }

  /// Update performance settings
  Future<void> updatePerformance({
    int? cacheSize,
    double? maxImageQuality,
    bool? enableDataSaver,
    int? autoSaveInterval,
  }) async {
    try {
      final updatedSettings = _currentSettings.updatePerformance(
        cacheSize: cacheSize,
        maxImageQuality: maxImageQuality,
        enableDataSaver: enableDataSaver,
        autoSaveInterval: autoSaveInterval,
      );

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Performance settings updated');
      }

    } catch (error) {
      _setError('Failed to update performance settings: $error');
    }
  }

  /// Update privacy settings
  Future<void> updatePrivacy({
    bool? enableAnalytics,
    bool? enableCrashReporting,
  }) async {
    try {
      final updatedSettings = _currentSettings.updatePrivacy(
        enableAnalytics: enableAnalytics,
        enableCrashReporting: enableCrashReporting,
      );

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Privacy settings updated: analytics=$enableAnalytics, crashReporting=$enableCrashReporting');
      }

    } catch (error) {
      _setError('Failed to update privacy settings: $error');
    }
  }

  /// Update localization settings
  Future<void> updateLocalization({
    String? language,
    String? currency,
    String? timeZone,
    String? dateFormat,
    String? timeFormat,
  }) async {
    try {
      final updatedSettings = _currentSettings.updateLocalization(
        language: language,
        currency: currency,
        timeZone: timeZone,
        dateFormat: dateFormat,
        timeFormat: timeFormat,
      );

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Localization settings updated: language=$language, currency=$currency');
      }

    } catch (error) {
      _setError('Failed to update localization settings: $error');
    }
  }

  /// Toggle theme mode
  Future<void> toggleThemeMode() async {
    AppThemeMode newMode;
    switch (_currentSettings.themeMode) {
      case AppThemeMode.light:
        newMode = AppThemeMode.dark;
        break;
      case AppThemeMode.dark:
        newMode = AppThemeMode.system;
        break;
      case AppThemeMode.system:
        newMode = AppThemeMode.light;
        break;
    }

    await updateTheme(themeMode: newMode);
  }

  /// Toggle debug mode
  Future<void> toggleDebugMode() async {
    try {
      final updatedSettings = _currentSettings.copyWith(
        debugMode: !_currentSettings.debugMode,
      );

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Debug mode toggled: ${updatedSettings.debugMode}');
      }

    } catch (error) {
      _setError('Failed to toggle debug mode: $error');
    }
  }

  /// Toggle performance overlay
  Future<void> togglePerformanceOverlay() async {
    try {
      final updatedSettings = _currentSettings.copyWith(
        showPerformanceOverlay: !_currentSettings.showPerformanceOverlay,
      );

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Performance overlay toggled: ${updatedSettings.showPerformanceOverlay}');
      }

    } catch (error) {
      _setError('Failed to toggle performance overlay: $error');
    }
  }

  /// Toggle offline mode
  Future<void> toggleOfflineMode() async {
    try {
      final updatedSettings = _currentSettings.toggleOfflineMode();
      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Offline mode toggled: ${updatedSettings.offlineMode}');
      }

    } catch (error) {
      _setError('Failed to toggle offline mode: $error');
    }
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    try {
      final updatedSettings = _currentSettings.completeOnboarding();
      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Onboarding completed');
      }

    } catch (error) {
      _setError('Failed to complete onboarding: $error');
    }
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate reset operation
      await Future.delayed(const Duration(milliseconds: 500));

      final defaultSettings = _currentSettings.resetToDefaults();
      _updateSettings(defaultSettings);
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('⚙️ Settings reset to defaults');
      }

    } catch (error) {
      _setError('Failed to reset settings: $error');
    }
  }

  /// Update last check time
  Future<void> updateLastCheck() async {
    try {
      final updatedSettings = _currentSettings.updateLastCheck();
      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Last check time updated');
      }

    } catch (error) {
      _setError('Failed to update last check: $error');
    }
  }

  /// Set development mode
  Future<void> setDevelopmentMode(bool enabled) async {
    try {
      AppSettings updatedSettings;
      
      if (enabled) {
        updatedSettings = AppSettings.development().copyWith(
          version: _currentSettings.version,
          firstRun: _currentSettings.firstRun,
          language: _currentSettings.language,
          currency: _currentSettings.currency,
        );
      } else {
        updatedSettings = AppSettings.production().copyWith(
          version: _currentSettings.version,
          firstRun: _currentSettings.firstRun,
          language: _currentSettings.language,
          currency: _currentSettings.currency,
          themeMode: _currentSettings.themeMode,
          primaryColor: _currentSettings.primaryColor,
        );
      }

      _updateSettings(updatedSettings);

      if (kDebugMode) {
        debugPrint('⚙️ Development mode ${enabled ? 'enabled' : 'disabled'}');
      }

    } catch (error) {
      _setError('Failed to set development mode: $error');
    }
  }

  /// Business logic: Get current theme mode
  ThemeMode get themeMode => _currentSettings.themeMode.themeMode;

  /// Business logic: Get primary color
  Color get primaryColor => _currentSettings.primaryColor;

  /// Business logic: Get visual density
  VisualDensity get visualDensity => _currentSettings.layoutDensity.visualDensity;

  /// Business logic: Get scaled font size
  double getScaledFontSize(double baseFontSize) => _currentSettings.getScaledFontSize(baseFontSize);

  /// Business logic: Check if animations are enabled
  bool get enableAnimations => _currentSettings.enableAnimations;

  /// Business logic: Check if haptic feedback is enabled
  bool get enableHapticFeedback => _currentSettings.enableHapticFeedback;

  /// Business logic: Check if sounds are enabled
  bool get enableSounds => _currentSettings.enableSounds;

  /// Business logic: Check if debug mode is enabled
  bool get debugMode => _currentSettings.debugMode;

  /// Business logic: Check if performance overlay is enabled
  bool get showPerformanceOverlay => _currentSettings.showPerformanceOverlay;

  /// Business logic: Check if analytics are enabled
  bool get enableAnalytics => _currentSettings.enableAnalytics;

  /// Business logic: Check if crash reporting is enabled
  bool get enableCrashReporting => _currentSettings.enableCrashReporting;

  /// Business logic: Check if offline mode is enabled
  bool get offlineMode => _currentSettings.offlineMode;

  /// Business logic: Check if should show onboarding
  bool get showOnboarding => _currentSettings.showOnboarding;

  /// Business logic: Check if this is first run
  bool get firstRun => _currentSettings.firstRun;

  /// Business logic: Get app language
  String get language => _currentSettings.language;

  /// Business logic: Get app currency
  String get currency => _currentSettings.currency;

  /// Business logic: Get app version
  String get version => _currentSettings.version;

  /// Business logic: Check if accessibility features are enabled
  bool get hasAccessibilityFeatures => _currentSettings.hasAccessibilityFeatures;

  /// Business logic: Check if performance mode is enabled
  bool get isPerformanceMode => _currentSettings.isPerformanceMode;

  /// Business logic: Check if privacy mode is enabled
  bool get isPrivacyMode => _currentSettings.isPrivacyMode;

  /// Business logic: Get estimated memory usage
  int get estimatedMemoryUsage => _currentSettings.estimatedMemoryUsage;

  /// Business logic: Get estimated battery usage
  double get estimatedBatteryUsage => _currentSettings.estimatedBatteryUsage;

  /// Validate current settings
  AppSettingsValidationResult validateSettings() {
    return _currentSettings.validate();
  }

  /// Export settings (placeholder for real implementation)
  Future<Map<String, dynamic>> exportSettings() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (kDebugMode) {
        debugPrint('⚙️ Settings exported');
      }
      
      return _currentSettings.toJson();
    } catch (error) {
      _setError('Failed to export settings: $error');
      return {};
    }
  }

  /// Import settings (placeholder for real implementation)
  Future<void> importSettings(Map<String, dynamic> settingsData) async {
    try {
      _setLoading(true);
      _setError(null);

      await Future.delayed(const Duration(milliseconds: 500));
      
      final importedSettings = AppSettings.fromJson(settingsData);
      final validation = importedSettings.validate();
      
      if (!validation.isValid) {
        _setError('Invalid settings data: ${validation.errorMessage}');
        return;
      }

      _updateSettings(importedSettings);
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('⚙️ Settings imported successfully');
      }

    } catch (error) {
      _setError('Failed to import settings: $error');
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('⚙️ AppSettingsProvider disposed');
    }
    super.dispose();
  }

  @override
  String toString() {
    return 'AppSettingsProvider('
        'theme: ${_currentSettings.themeMode.label}, '
        'language: ${_currentSettings.language}, '
        'debugMode: ${_currentSettings.debugMode}, '
        'isLoading: $_isLoading'
        ')';
  }
}