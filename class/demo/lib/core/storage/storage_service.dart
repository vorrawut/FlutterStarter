import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Storage Service for Local Data Persistence
/// 
/// Demonstrates:
/// - Local Storage patterns (Lesson 17: Local Storage)
/// - Multiple storage backends (SharedPreferences + Hive)
/// - Clean storage abstraction
/// - Type-safe storage operations
/// - Error handling for storage operations
class StorageService {
  StorageService._(); // Private constructor
  
  static late Box _hiveBox;
  static late SharedPreferences _prefs;
  static bool _initialized = false;
  
  /// Initialize storage services
  /// 
  /// Demonstrates:
  /// - Async initialization patterns
  /// - Error handling for storage setup
  /// - Service initialization order
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Initialize SharedPreferences for simple key-value storage
      _prefs = await SharedPreferences.getInstance();
      
      // Initialize Hive for complex object storage
      await Hive.initFlutter();
      _hiveBox = await Hive.openBox(AppConstants.hiveBoxName);
      
      _initialized = true;
    } catch (e) {
      throw const StorageException('Failed to initialize storage');
    }
  }
  
  /// Ensure storage is initialized
  static void _ensureInitialized() {
    if (!_initialized) {
      throw const StorageException('Storage not initialized. Call initialize() first.');
    }
  }
  
  // ========================================
  // Generic Storage Operations
  // ========================================
  
  /// Generic read method for simple key-value storage
  static Future<T?> read<T>(String key) async {
    _ensureInitialized();
    
    try {
      if (T == String) {
        return _prefs.getString(key) as T?;
      } else if (T == int) {
        return _prefs.getInt(key) as T?;
      } else if (T == bool) {
        return _prefs.getBool(key) as T?;
      } else if (T == double) {
        return _prefs.getDouble(key) as T?;
      } else {
        // For complex objects, use Hive
        return _hiveBox.get(key) as T?;
      }
    } catch (e) {
      return null;
    }
  }
  
  /// Generic write method for simple key-value storage
  static Future<void> write<T>(String key, T value) async {
    _ensureInitialized();
    
    try {
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else {
        // For complex objects, use Hive
        await _hiveBox.put(key, value);
      }
    } catch (e) {
      throw StorageException('Failed to write $key: $e');
    }
  }
  
  /// Generic delete method
  static Future<void> delete(String key) async {
    _ensureInitialized();
    
    try {
      // Try both storage systems
      await _prefs.remove(key);
      await _hiveBox.delete(key);
    } catch (e) {
      throw StorageException('Failed to delete $key: $e');
    }
  }
  
  /// Clear all storage
  static Future<void> clear() async {
    _ensureInitialized();
    
    try {
      await _prefs.clear();
      await _hiveBox.clear();
    } catch (e) {
      throw StorageException('Failed to clear storage: $e');
    }
  }

  // ========================================
  // Theme Management
  // ========================================
  
  /// Get saved theme mode
  /// 
  /// Demonstrates:
  /// - Enum storage and retrieval
  /// - Default value handling
  /// - Type conversion for storage
  static Future<ThemeMode> getThemeMode() async {
    _ensureInitialized();
    
    try {
      final themeIndex = _prefs.getInt(AppConstants.themeKey);
      if (themeIndex == null) return ThemeMode.system;
      
      return ThemeMode.values[themeIndex];
    } catch (e) {
      return ThemeMode.system;
    }
  }
  
  /// Save theme mode
  static Future<void> setThemeMode(ThemeMode mode) async {
    _ensureInitialized();
    
    try {
      await _prefs.setInt(AppConstants.themeKey, mode.index);
    } catch (e) {
      throw StorageException('Failed to save theme mode: $e');
    }
  }
  
  // ========================================
  // User Preferences
  // ========================================
  
  /// Get user preferences
  /// 
  /// Demonstrates:
  /// - Complex object storage with Hive
  /// - Null safety for optional data
  /// - Type-safe retrieval patterns
  static Map<String, dynamic>? getUserPreferences() {
    _ensureInitialized();
    
    try {
      return _hiveBox.get(AppConstants.userPreferencesKey);
    } catch (e) {
      return null;
    }
  }
  
  /// Save user preferences
  static Future<void> setUserPreferences(Map<String, dynamic> preferences) async {
    _ensureInitialized();
    
    try {
      await _hiveBox.put(AppConstants.userPreferencesKey, preferences);
    } catch (e) {
      throw StorageException('Failed to save user preferences: $e');
    }
  }
  
  // ========================================
  // Authentication Token Management
  // ========================================
  
  /// Get authentication token
  /// 
  /// Demonstrates:
  /// - Secure token storage patterns
  /// - String data retrieval
  /// - Null safety for optional tokens
  static String? getAuthToken() {
    _ensureInitialized();
    
    try {
      return _prefs.getString(AppConstants.authTokenKey);
    } catch (e) {
      return null;
    }
  }
  
  /// Save authentication token
  static Future<void> setAuthToken(String token) async {
    _ensureInitialized();
    
    try {
      await _prefs.setString(AppConstants.authTokenKey, token);
    } catch (e) {
      throw StorageException('Failed to save auth token: $e');
    }
  }
  
  /// Remove authentication token
  static Future<void> removeAuthToken() async {
    _ensureInitialized();
    
    try {
      await _prefs.remove(AppConstants.authTokenKey);
      await _prefs.remove(AppConstants.refreshTokenKey);
    } catch (e) {
      throw StorageException('Failed to remove auth token: $e');
    }
  }
  
  /// Get refresh token
  static String? getRefreshToken() {
    _ensureInitialized();
    
    try {
      return _prefs.getString(AppConstants.refreshTokenKey);
    } catch (e) {
      return null;
    }
  }
  
  /// Save refresh token
  static Future<void> setRefreshToken(String token) async {
    _ensureInitialized();
    
    try {
      await _prefs.setString(AppConstants.refreshTokenKey, token);
    } catch (e) {
      throw StorageException('Failed to save refresh token: $e');
    }
  }
  
  // ========================================
  // User Profile Data
  // ========================================
  
  /// Get cached user profile
  /// 
  /// Demonstrates:
  /// - JSON serialization storage
  /// - Complex object caching
  /// - Offline data access patterns
  static Map<String, dynamic>? getUserProfile() {
    _ensureInitialized();
    
    try {
      return _hiveBox.get(AppConstants.userProfileKey);
    } catch (e) {
      return null;
    }
  }
  
  /// Cache user profile
  static Future<void> setUserProfile(Map<String, dynamic> profile) async {
    _ensureInitialized();
    
    try {
      await _hiveBox.put(AppConstants.userProfileKey, profile);
    } catch (e) {
      throw StorageException('Failed to cache user profile: $e');
    }
  }
  
  /// Remove cached user profile
  static Future<void> removeUserProfile() async {
    _ensureInitialized();
    
    try {
      await _hiveBox.delete(AppConstants.userProfileKey);
    } catch (e) {
      throw StorageException('Failed to remove user profile: $e');
    }
  }
  
  // ========================================
  // Onboarding State
  // ========================================
  
  /// Check if onboarding is complete
  /// 
  /// Demonstrates:
  /// - Boolean flag storage
  /// - App state persistence
  /// - First-time user detection
  static bool isOnboardingComplete() {
    _ensureInitialized();
    
    try {
      return _prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Mark onboarding as complete
  static Future<void> setOnboardingComplete() async {
    _ensureInitialized();
    
    try {
      await _prefs.setBool(AppConstants.onboardingCompleteKey, true);
    } catch (e) {
      throw StorageException('Failed to save onboarding state: $e');
    }
  }
  
  // ========================================
  // Notification Settings
  // ========================================
  
  /// Get notification settings
  /// 
  /// Demonstrates:
  /// - Settings persistence
  /// - Complex configuration storage
  /// - Default settings handling
  static Map<String, dynamic> getNotificationSettings() {
    _ensureInitialized();
    
    try {
      return _hiveBox.get(AppConstants.notificationSettingsKey) ?? {
        'pushEnabled': true,
        'emailEnabled': true,
        'chatNotifications': true,
        'postNotifications': true,
        'quizReminders': true,
        'achievementNotifications': true,
        'quietHoursEnabled': false,
        'quietHoursStart': '22:00',
        'quietHoursEnd': '08:00',
      };
    } catch (e) {
      return {
        'pushEnabled': true,
        'emailEnabled': true,
        'chatNotifications': true,
        'postNotifications': true,
        'quizReminders': true,
        'achievementNotifications': true,
        'quietHoursEnabled': false,
        'quietHoursStart': '22:00',
        'quietHoursEnd': '08:00',
      };
    }
  }
  
  /// Save notification settings
  static Future<void> setNotificationSettings(Map<String, dynamic> settings) async {
    _ensureInitialized();
    
    try {
      await _hiveBox.put(AppConstants.notificationSettingsKey, settings);
    } catch (e) {
      throw StorageException('Failed to save notification settings: $e');
    }
  }
  
  // ========================================
  // Generic Storage Operations
  // ========================================
  
  /// Get value by key from Hive
  /// 
  /// Demonstrates:
  /// - Generic storage operations
  /// - Type-safe value retrieval
  /// - Error handling for missing keys
  static T? getValue<T>(String key) {
    _ensureInitialized();
    
    try {
      return _hiveBox.get(key) as T?;
    } catch (e) {
      return null;
    }
  }
  
  /// Set value by key in Hive
  static Future<void> setValue<T>(String key, T value) async {
    _ensureInitialized();
    
    try {
      await _hiveBox.put(key, value);
    } catch (e) {
      throw StorageException('Failed to save value for key $key: $e');
    }
  }
  
  /// Remove value by key
  static Future<void> removeValue(String key) async {
    _ensureInitialized();
    
    try {
      await _hiveBox.delete(key);
    } catch (e) {
      throw StorageException('Failed to remove value for key $key: $e');
    }
  }
  
  /// Check if key exists
  static bool containsKey(String key) {
    _ensureInitialized();
    
    try {
      return _hiveBox.containsKey(key);
    } catch (e) {
      return false;
    }
  }
  
  /// Get all keys
  static Iterable<dynamic> getAllKeys() {
    _ensureInitialized();
    
    try {
      return _hiveBox.keys;
    } catch (e) {
      return [];
    }
  }
  
  // ========================================
  // Cache Management
  // ========================================
  
  /// Clear all cached data
  /// 
  /// Demonstrates:
  /// - Data cleanup operations
  /// - Storage maintenance
  /// - User logout procedures
  static Future<void> clearCache() async {
    _ensureInitialized();
    
    try {
      await _hiveBox.clear();
    } catch (e) {
      throw StorageException('Failed to clear cache: $e');
    }
  }
  
  /// Clear user-specific data
  /// 
  /// Demonstrates:
  /// - Selective data cleanup
  /// - User session management
  /// - Privacy compliance
  static Future<void> clearUserData() async {
    _ensureInitialized();
    
    try {
      await Future.wait([
        removeAuthToken(),
        removeUserProfile(),
        _hiveBox.delete(AppConstants.userPreferencesKey),
        _hiveBox.delete(AppConstants.notificationSettingsKey),
      ]);
    } catch (e) {
      throw StorageException('Failed to clear user data: $e');
    }
  }
  
  /// Get storage size information
  /// 
  /// Demonstrates:
  /// - Storage monitoring
  /// - Performance optimization insights
  /// - Storage usage analytics
  static Future<StorageInfo> getStorageInfo() async {
    _ensureInitialized();
    
    try {
      final hiveSize = _hiveBox.length;
      final prefsKeys = _prefs.getKeys();
      
      return StorageInfo(
        hiveBoxSize: hiveSize,
        sharedPreferencesSize: prefsKeys.length,
        totalKeys: hiveSize + prefsKeys.length,
      );
    } catch (e) {
      throw StorageException('Failed to get storage info: $e');
    }
  }
}

/// Storage Information Model
/// 
/// Demonstrates:
/// - Data classes for storage metrics
/// - Storage monitoring capabilities
/// - Performance analysis data structures
@immutable
class StorageInfo {
  const StorageInfo({
    required this.hiveBoxSize,
    required this.sharedPreferencesSize,
    required this.totalKeys,
  });
  
  final int hiveBoxSize;
  final int sharedPreferencesSize;
  final int totalKeys;
  
  @override
  String toString() {
    return 'StorageInfo(hive: $hiveBoxSize, prefs: $sharedPreferencesSize, total: $totalKeys)';
  }
}

/// Storage Exception Class
/// 
/// Demonstrates:
/// - Custom exception types
/// - Error handling patterns
/// - Type-safe error management
class StorageException implements Exception {
  const StorageException(this.message);
  
  final String message;
  
  @override
  String toString() => 'StorageException: $message';
}
