# 🛠 Lesson 7: Theming Your App - Workshop (Part 2)

## **Step 6: Theme Domain Layer** ⏱️ *15 minutes*

Create the business logic layer for theme management:

```dart
// lib/domain/entities/theme_settings.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme settings entity representing user theme preferences
class ThemeSettings extends Equatable {
  final ThemeMode themeMode;
  final Color? seedColor;
  final bool useSystemColors;
  final bool highContrastMode;
  final double textScaleFactor;
  final String fontFamily;
  final bool useCustomColors;
  final DateTime lastUpdated;

  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.seedColor,
    this.useSystemColors = true,
    this.highContrastMode = false,
    this.textScaleFactor = 1.0,
    this.fontFamily = 'SF Pro Display',
    this.useCustomColors = false,
    required this.lastUpdated,
  });

  /// Create default theme settings
  factory ThemeSettings.defaultSettings() {
    return ThemeSettings(
      lastUpdated: DateTime.now(),
    );
  }

  /// Copy with updated properties
  ThemeSettings copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    bool? useSystemColors,
    bool? highContrastMode,
    double? textScaleFactor,
    String? fontFamily,
    bool? useCustomColors,
    DateTime? lastUpdated,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      useSystemColors: useSystemColors ?? this.useSystemColors,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      fontFamily: fontFamily ?? this.fontFamily,
      useCustomColors: useCustomColors ?? this.useCustomColors,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  /// Check if using dark mode
  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// Check if using light mode
  bool get isLightMode => themeMode == ThemeMode.light;

  /// Check if using system mode
  bool get isSystemMode => themeMode == ThemeMode.system;

  /// Get effective seed color (null if using system colors)
  Color? get effectiveSeedColor {
    if (useSystemColors) return null;
    return seedColor ?? const Color(0xFF6750A4);
  }

  @override
  List<Object?> get props => [
        themeMode,
        seedColor,
        useSystemColors,
        highContrastMode,
        textScaleFactor,
        fontFamily,
        useCustomColors,
        lastUpdated,
      ];

  @override
  String toString() {
    return 'ThemeSettings(mode: $themeMode, seedColor: $seedColor, highContrast: $highContrastMode)';
  }
}

// lib/domain/repositories/theme_repository.dart
import '../entities/theme_settings.dart';

/// Theme repository interface for theme operations
abstract class ThemeRepository {
  /// Get current theme settings
  Future<ThemeSettings> getThemeSettings();

  /// Update theme settings
  Future<void> updateThemeSettings(ThemeSettings settings);

  /// Reset to default theme settings
  Future<void> resetThemeSettings();

  /// Get available seed colors
  List<Color> getAvailableSeedColors();

  /// Get available font families
  List<String> getAvailableFontFamilies();

  /// Stream of theme settings changes
  Stream<ThemeSettings> get themeSettingsStream;
}

// lib/domain/usecases/get_theme_settings_usecase.dart
import '../entities/theme_settings.dart';
import '../repositories/theme_repository.dart';

/// Use case for getting current theme settings
class GetThemeSettingsUseCase {
  final ThemeRepository _repository;

  const GetThemeSettingsUseCase(this._repository);

  /// Execute getting theme settings
  Future<ThemeSettings> execute() async {
    try {
      return await _repository.getThemeSettings();
    } catch (e) {
      // Return default settings on error
      return ThemeSettings.defaultSettings();
    }
  }

  /// Get theme settings stream
  Stream<ThemeSettings> executeStream() {
    return _repository.themeSettingsStream;
  }
}

// lib/domain/usecases/update_theme_settings_usecase.dart
import 'package:flutter/material.dart';
import '../entities/theme_settings.dart';
import '../repositories/theme_repository.dart';

/// Use case for updating theme settings
class UpdateThemeSettingsUseCase {
  final ThemeRepository _repository;

  const UpdateThemeSettingsUseCase(this._repository);

  /// Update theme mode
  Future<ThemeUpdateResult> updateThemeMode(ThemeMode mode) async {
    try {
      final currentSettings = await _repository.getThemeSettings();
      final updatedSettings = currentSettings.copyWith(themeMode: mode);
      await _repository.updateThemeSettings(updatedSettings);
      
      return ThemeUpdateResult.success(
        'Theme mode updated to ${mode.name}',
        updatedSettings,
      );
    } catch (e) {
      return ThemeUpdateResult.error('Failed to update theme mode: $e');
    }
  }

  /// Update seed color
  Future<ThemeUpdateResult> updateSeedColor(Color? color) async {
    try {
      final currentSettings = await _repository.getThemeSettings();
      final updatedSettings = currentSettings.copyWith(
        seedColor: color,
        useSystemColors: color == null,
        useCustomColors: color != null,
      );
      await _repository.updateThemeSettings(updatedSettings);
      
      return ThemeUpdateResult.success(
        'Theme color updated',
        updatedSettings,
      );
    } catch (e) {
      return ThemeUpdateResult.error('Failed to update theme color: $e');
    }
  }

  /// Toggle high contrast mode
  Future<ThemeUpdateResult> toggleHighContrastMode() async {
    try {
      final currentSettings = await _repository.getThemeSettings();
      final updatedSettings = currentSettings.copyWith(
        highContrastMode: !currentSettings.highContrastMode,
      );
      await _repository.updateThemeSettings(updatedSettings);
      
      return ThemeUpdateResult.success(
        'High contrast mode ${updatedSettings.highContrastMode ? 'enabled' : 'disabled'}',
        updatedSettings,
      );
    } catch (e) {
      return ThemeUpdateResult.error('Failed to toggle high contrast: $e');
    }
  }

  /// Update text scale factor
  Future<ThemeUpdateResult> updateTextScaleFactor(double scale) async {
    try {
      if (scale < 0.5 || scale > 2.0) {
        return ThemeUpdateResult.error('Text scale must be between 0.5 and 2.0');
      }

      final currentSettings = await _repository.getThemeSettings();
      final updatedSettings = currentSettings.copyWith(textScaleFactor: scale);
      await _repository.updateThemeSettings(updatedSettings);
      
      return ThemeUpdateResult.success(
        'Text scale updated to ${(scale * 100).toInt()}%',
        updatedSettings,
      );
    } catch (e) {
      return ThemeUpdateResult.error('Failed to update text scale: $e');
    }
  }

  /// Reset to default settings
  Future<ThemeUpdateResult> resetToDefaults() async {
    try {
      await _repository.resetThemeSettings();
      final defaultSettings = ThemeSettings.defaultSettings();
      
      return ThemeUpdateResult.success(
        'Theme settings reset to defaults',
        defaultSettings,
      );
    } catch (e) {
      return ThemeUpdateResult.error('Failed to reset theme settings: $e');
    }
  }
}

/// Result class for theme update operations
class ThemeUpdateResult {
  final bool isSuccess;
  final String message;
  final ThemeSettings? settings;

  const ThemeUpdateResult._({
    required this.isSuccess,
    required this.message,
    this.settings,
  });

  factory ThemeUpdateResult.success(String message, ThemeSettings settings) {
    return ThemeUpdateResult._(
      isSuccess: true,
      message: message,
      settings: settings,
    );
  }

  factory ThemeUpdateResult.error(String message) {
    return ThemeUpdateResult._(
      isSuccess: false,
      message: message,
    );
  }

  bool get isError => !isSuccess;

  @override
  String toString() {
    return 'ThemeUpdateResult(isSuccess: $isSuccess, message: $message)';
  }
}
```

## **Step 7: Data Layer Implementation** ⏱️ *15 minutes*

Implement data persistence for theme settings:

```dart
// lib/data/models/theme_settings_model.dart
import 'package:flutter/material.dart';
import '../../domain/entities/theme_settings.dart';

/// Data model for theme settings with JSON serialization
class ThemeSettingsModel extends ThemeSettings {
  const ThemeSettingsModel({
    required super.themeMode,
    super.seedColor,
    required super.useSystemColors,
    required super.highContrastMode,
    required super.textScaleFactor,
    required super.fontFamily,
    required super.useCustomColors,
    required super.lastUpdated,
  });

  /// Create from domain entity
  factory ThemeSettingsModel.fromEntity(ThemeSettings entity) {
    return ThemeSettingsModel(
      themeMode: entity.themeMode,
      seedColor: entity.seedColor,
      useSystemColors: entity.useSystemColors,
      highContrastMode: entity.highContrastMode,
      textScaleFactor: entity.textScaleFactor,
      fontFamily: entity.fontFamily,
      useCustomColors: entity.useCustomColors,
      lastUpdated: entity.lastUpdated,
    );
  }

  /// Create from JSON
  factory ThemeSettingsModel.fromJson(Map<String, dynamic> json) {
    return ThemeSettingsModel(
      themeMode: _parseThemeMode(json['themeMode'] as String?),
      seedColor: _parseColor(json['seedColor'] as String?),
      useSystemColors: json['useSystemColors'] as bool? ?? true,
      highContrastMode: json['highContrastMode'] as bool? ?? false,
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
      fontFamily: json['fontFamily'] as String? ?? 'SF Pro Display',
      useCustomColors: json['useCustomColors'] as bool? ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'seedColor': seedColor?.value.toRadixString(16),
      'useSystemColors': useSystemColors,
      'highContrastMode': highContrastMode,
      'textScaleFactor': textScaleFactor,
      'fontFamily': fontFamily,
      'useCustomColors': useCustomColors,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Create default model
  factory ThemeSettingsModel.defaultSettings() {
    return ThemeSettingsModel.fromEntity(ThemeSettings.defaultSettings());
  }

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static Color? _parseColor(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return Color(int.parse(value, radix: 16));
    } catch (e) {
      return null;
    }
  }
}

// lib/data/datasources/theme_datasource.dart
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/theme_settings_model.dart';

/// Local data source for theme settings using SharedPreferences
class LocalThemeDataSource {
  static const String _themeSettingsKey = 'theme_settings';
  
  final StreamController<ThemeSettingsModel> _themeController = 
      StreamController<ThemeSettingsModel>.broadcast();

  /// Get theme settings from local storage
  Future<ThemeSettingsModel> getThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_themeSettingsKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return ThemeSettingsModel.fromJson(json);
      }
      
      return ThemeSettingsModel.defaultSettings();
    } catch (e) {
      return ThemeSettingsModel.defaultSettings();
    }
  }

  /// Save theme settings to local storage
  Future<void> saveThemeSettings(ThemeSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      await prefs.setString(_themeSettingsKey, jsonString);
      
      // Notify listeners
      _themeController.add(settings);
    } catch (e) {
      throw Exception('Failed to save theme settings: $e');
    }
  }

  /// Clear theme settings (reset to defaults)
  Future<void> clearThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeSettingsKey);
      
      // Notify with default settings
      _themeController.add(ThemeSettingsModel.defaultSettings());
    } catch (e) {
      throw Exception('Failed to clear theme settings: $e');
    }
  }

  /// Get predefined seed colors
  List<Color> getAvailableSeedColors() {
    return [
      const Color(0xFF6750A4), // Purple (default)
      const Color(0xFF1976D2), // Blue
      const Color(0xFF388E3C), // Green
      const Color(0xFFD32F2F), // Red
      const Color(0xFFFF9800), // Orange
      const Color(0xFF7B1FA2), // Deep Purple
      const Color(0xFF303F9F), // Indigo
      const Color(0xFF455A64), // Blue Grey
      const Color(0xFF5D4037), // Brown
      const Color(0xFF00695C), // Teal
      const Color(0xFFAD1457), // Pink
      const Color(0xFF00838F), // Cyan
    ];
  }

  /// Get available font families
  List<String> getAvailableFontFamilies() {
    return [
      'SF Pro Display',
      'Roboto',
      'Arial',
      'Helvetica',
      'Open Sans',
      'Lato',
      'Montserrat',
      'Source Sans Pro',
    ];
  }

  /// Stream of theme settings changes
  Stream<ThemeSettingsModel> get themeSettingsStream => _themeController.stream;

  /// Dispose resources
  void dispose() {
    _themeController.close();
  }
}

// lib/data/repositories/theme_repository_impl.dart
import 'package:flutter/material.dart';
import '../../domain/entities/theme_settings.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_datasource.dart';
import '../models/theme_settings_model.dart';

/// Implementation of theme repository using local data source
class ThemeRepositoryImpl implements ThemeRepository {
  final LocalThemeDataSource _dataSource;

  const ThemeRepositoryImpl(this._dataSource);

  @override
  Future<ThemeSettings> getThemeSettings() async {
    try {
      final model = await _dataSource.getThemeSettings();
      return model;
    } catch (e) {
      return ThemeSettings.defaultSettings();
    }
  }

  @override
  Future<void> updateThemeSettings(ThemeSettings settings) async {
    try {
      final model = ThemeSettingsModel.fromEntity(settings);
      await _dataSource.saveThemeSettings(model);
    } catch (e) {
      throw Exception('Failed to update theme settings: $e');
    }
  }

  @override
  Future<void> resetThemeSettings() async {
    try {
      await _dataSource.clearThemeSettings();
    } catch (e) {
      throw Exception('Failed to reset theme settings: $e');
    }
  }

  @override
  List<Color> getAvailableSeedColors() {
    return _dataSource.getAvailableSeedColors();
  }

  @override
  List<String> getAvailableFontFamilies() {
    return _dataSource.getAvailableFontFamilies();
  }

  @override
  Stream<ThemeSettings> get themeSettingsStream {
    return _dataSource.themeSettingsStream.map((model) => model as ThemeSettings);
  }
}
```

## **Step 8: Theme Controller (State Management)** ⏱️ *15 minutes*

Create the presentation layer controller for theme state:

```dart
// lib/presentation/controllers/theme_controller.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/theme_settings.dart';
import '../../domain/usecases/get_theme_settings_usecase.dart';
import '../../domain/usecases/update_theme_settings_usecase.dart';

/// Controller for managing theme state and operations
class ThemeController extends ChangeNotifier {
  final GetThemeSettingsUseCase _getThemeSettingsUseCase;
  final UpdateThemeSettingsUseCase _updateThemeSettingsUseCase;

  ThemeSettings _themeSettings = ThemeSettings.defaultSettings();
  bool _isLoading = false;
  String? _errorMessage;

  ThemeController(
    this._getThemeSettingsUseCase,
    this._updateThemeSettingsUseCase,
  ) {
    _initializeTheme();
    _listenToThemeChanges();
  }

  // Getters
  ThemeSettings get themeSettings => _themeSettings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get current light theme
  ThemeData get lightTheme {
    if (_themeSettings.highContrastMode) {
      return AppTheme.highContrastLight(seedColor: _themeSettings.effectiveSeedColor);
    }
    return AppTheme.light(seedColor: _themeSettings.effectiveSeedColor);
  }

  /// Get current dark theme
  ThemeData get darkTheme {
    if (_themeSettings.highContrastMode) {
      return AppTheme.highContrastDark(seedColor: _themeSettings.effectiveSeedColor);
    }
    return AppTheme.dark(seedColor: _themeSettings.effectiveSeedColor);
  }

  /// Get current theme mode
  ThemeMode get themeMode => _themeSettings.themeMode;

  /// Get text scale factor
  double get textScaleFactor => _themeSettings.textScaleFactor;

  /// Check if currently using dark mode
  bool get isDarkMode => _themeSettings.isDarkMode;

  /// Check if currently using light mode
  bool get isLightMode => _themeSettings.isLightMode;

  /// Check if currently using system mode
  bool get isSystemMode => _themeSettings.isSystemMode;

  /// Check if high contrast mode is enabled
  bool get isHighContrastMode => _themeSettings.highContrastMode;

  /// Check if using system colors
  bool get useSystemColors => _themeSettings.useSystemColors;

  /// Get current seed color
  Color? get seedColor => _themeSettings.seedColor;

  /// Initialize theme settings
  Future<void> _initializeTheme() async {
    _setLoading(true);
    try {
      _themeSettings = await _getThemeSettingsUseCase.execute();
      _clearError();
    } catch (e) {
      _setError('Failed to load theme settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Listen to theme settings changes
  void _listenToThemeChanges() {
    _getThemeSettingsUseCase.executeStream().listen(
      (settings) {
        _themeSettings = settings;
        _clearError();
        notifyListeners();
      },
      onError: (error) {
        _setError('Theme settings stream error: $error');
      },
    );
  }

  /// Update theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _setLoading(true);
    try {
      final result = await _updateThemeSettingsUseCase.updateThemeMode(mode);
      
      if (result.isSuccess && result.settings != null) {
        _themeSettings = result.settings!;
        _clearError();
        _showSuccessMessage(result.message);
      } else {
        _setError(result.message);
      }
    } catch (e) {
      _setError('Failed to update theme mode: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update seed color
  Future<void> setSeedColor(Color? color) async {
    _setLoading(true);
    try {
      final result = await _updateThemeSettingsUseCase.updateSeedColor(color);
      
      if (result.isSuccess && result.settings != null) {
        _themeSettings = result.settings!;
        _clearError();
        _showSuccessMessage(result.message);
      } else {
        _setError(result.message);
      }
    } catch (e) {
      _setError('Failed to update theme color: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle high contrast mode
  Future<void> toggleHighContrastMode() async {
    _setLoading(true);
    try {
      final result = await _updateThemeSettingsUseCase.toggleHighContrastMode();
      
      if (result.isSuccess && result.settings != null) {
        _themeSettings = result.settings!;
        _clearError();
        _showSuccessMessage(result.message);
      } else {
        _setError(result.message);
      }
    } catch (e) {
      _setError('Failed to toggle high contrast mode: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update text scale factor
  Future<void> setTextScaleFactor(double scale) async {
    _setLoading(true);
    try {
      final result = await _updateThemeSettingsUseCase.updateTextScaleFactor(scale);
      
      if (result.isSuccess && result.settings != null) {
        _themeSettings = result.settings!;
        _clearError();
        _showSuccessMessage(result.message);
      } else {
        _setError(result.message);
      }
    } catch (e) {
      _setError('Failed to update text scale: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Reset theme to defaults
  Future<void> resetToDefaults() async {
    _setLoading(true);
    try {
      final result = await _updateThemeSettingsUseCase.resetToDefaults();
      
      if (result.isSuccess && result.settings != null) {
        _themeSettings = result.settings!;
        _clearError();
        _showSuccessMessage(result.message);
      } else {
        _setError(result.message);
      }
    } catch (e) {
      _setError('Failed to reset theme settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh theme settings
  Future<void> refresh() async {
    await _initializeTheme();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _showSuccessMessage(String message) {
    // In a real app, you might show a snackbar or toast
    debugPrint('Theme updated: $message');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
```

**Continue to Part 3 for UI Components and Integration...**