import 'dart:developer';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/user_preferences.dart';
import '../../../domain/repositories/user_preferences_repository.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/security_service.dart';

class UserSettingsProvider extends ChangeNotifier {
  final UserPreferencesRepository _repository;
  final NotificationService _notificationService;
  final AnalyticsService _analyticsService;
  final SecurityService _securityService;
  
  UserPreferences _preferences = const UserPreferences();
  bool _isLoading = false;
  String? _error;
  DateTime? _lastSyncAt;

  UserSettingsProvider({
    required UserPreferencesRepository repository,
    required NotificationService notificationService,
    required AnalyticsService analyticsService,
    required SecurityService securityService,
  })  : _repository = repository,
        _notificationService = notificationService,
        _analyticsService = analyticsService,
        _securityService = securityService {
    _initialize();
  }

  // Getters
  UserPreferences get preferences => _preferences;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastSyncAt => _lastSyncAt;

  bool get emailNotifications => _preferences.emailNotifications;
  bool get pushNotifications => _preferences.pushNotifications;
  bool get locationServices => _preferences.locationServices;
  bool get analytics => _preferences.analytics;
  String get language => _preferences.language;
  String get currency => _preferences.currency;
  int get autoLockTimer => _preferences.autoLockTimer;
  bool get biometricEnabled => _preferences.biometricEnabled;
  List<String> get interests => _preferences.interests;
  Map<String, dynamic> get customSettings => _preferences.customSettings;

  Future<void> _initialize() async {
    _setLoading(true);
    
    try {
      _preferences = await _repository.getUserPreferences();
      _error = null;
      _lastSyncAt = _preferences.lastSyncAt;
      
      log('User settings initialized: ${_preferences.toString()}');
    } catch (e) {
      _error = e.toString();
      log('Failed to initialize user settings: $e');
    }
    
    _setLoading(false);
  }

  Future<void> toggleEmailNotifications() async {
    await _updatePreferences(
      _preferences.copyWith(emailNotifications: !_preferences.emailNotifications),
    );
    
    await _analyticsService.trackEvent('setting_changed', {
      'setting': 'email_notifications',
      'value': _preferences.emailNotifications,
    });
  }

  Future<void> togglePushNotifications() async {
    final newValue = !_preferences.pushNotifications;
    
    await _updatePreferences(
      _preferences.copyWith(pushNotifications: newValue),
    );
    
    // Update notification service
    try {
      if (newValue) {
        await _notificationService.requestPermission();
        await _notificationService.subscribeToTopics(_preferences.interests);
      } else {
        await _notificationService.unsubscribeFromAllTopics();
      }
    } catch (e) {
      log('Failed to update notification service: $e');
    }
    
    await _analyticsService.trackEvent('setting_changed', {
      'setting': 'push_notifications',
      'value': newValue,
    });
  }

  Future<void> toggleLocationServices() async {
    final newValue = !_preferences.locationServices;
    
    if (newValue) {
      final hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        _error = 'Location permission denied';
        notifyListeners();
        return;
      }
    }
    
    await _updatePreferences(
      _preferences.copyWith(locationServices: newValue),
    );
    
    await _analyticsService.trackEvent('setting_changed', {
      'setting': 'location_services',
      'value': newValue,
    });
  }

  Future<void> toggleAnalytics() async {
    final newValue = !_preferences.analytics;
    
    await _updatePreferences(
      _preferences.copyWith(analytics: newValue),
    );
    
    // Update analytics service
    await _analyticsService.setAnalyticsEnabled(newValue);
    
    await _analyticsService.trackEvent('setting_changed', {
      'setting': 'analytics',
      'value': newValue,
    });
  }

  Future<void> updateLanguage(String language) async {
    if (_preferences.language != language) {
      await _updatePreferences(
        _preferences.copyWith(language: language),
      );
      
      await _analyticsService.trackEvent('setting_changed', {
        'setting': 'language',
        'value': language,
      });
    }
  }

  Future<void> updateCurrency(String currency) async {
    await _updatePreferences(
      _preferences.copyWith(currency: currency),
    );
    
    await _analyticsService.trackEvent('setting_changed', {
      'setting': 'currency',
      'value': currency,
    });
  }

  Future<void> updateAutoLockTimer(int seconds) async {
    await _updatePreferences(
      _preferences.copyWith(autoLockTimer: seconds),
    );
    
    // Update security service
    await _securityService.updateAutoLockTimer(seconds);
    
    await _analyticsService.trackEvent('setting_changed', {
      'setting': 'auto_lock_timer',
      'value': seconds,
    });
  }

  Future<void> toggleBiometric() async {
    final newValue = !_preferences.biometricEnabled;
    
    if (newValue) {
      final canUseBiometric = await _securityService.canUseBiometric();
      if (!canUseBiometric) {
        _error = 'Biometric authentication is not available';
        notifyListeners();
        return;
      }
      
      final isAuthenticated = await _securityService.authenticateWithBiometric();
      if (!isAuthenticated) {
        _error = 'Biometric authentication failed';
        notifyListeners();
        return;
      }
    }
    
    await _updatePreferences(
      _preferences.copyWith(biometricEnabled: newValue),
    );
    
    // Update security service
    await _securityService.setBiometricEnabled(newValue);
    
    await _analyticsService.trackEvent('setting_changed', {
      'setting': 'biometric_enabled',
      'value': newValue,
    });
  }

  Future<void> addInterest(String interest) async {
    if (!_preferences.interests.contains(interest)) {
      final updatedInterests = [..._preferences.interests, interest];
      await _updatePreferences(
        _preferences.copyWith(interests: updatedInterests),
      );
      
      // Update notification topics
      if (_preferences.pushNotifications) {
        try {
          await _notificationService.subscribeToTopic(interest);
        } catch (e) {
          log('Failed to subscribe to topic: $e');
        }
      }
      
      await _analyticsService.trackEvent('interest_added', {
        'interest': interest,
        'total_interests': updatedInterests.length,
      });
    }
  }

  Future<void> removeInterest(String interest) async {
    if (_preferences.interests.contains(interest)) {
      final updatedInterests = _preferences.interests
          .where((i) => i != interest)
          .toList();
      
      await _updatePreferences(
        _preferences.copyWith(interests: updatedInterests),
      );
      
      // Update notification topics
      try {
        await _notificationService.unsubscribeFromTopic(interest);
      } catch (e) {
        log('Failed to unsubscribe from topic: $e');
      }
      
      await _analyticsService.trackEvent('interest_removed', {
        'interest': interest,
        'total_interests': updatedInterests.length,
      });
    }
  }

  Future<void> updateCustomSetting(String key, dynamic value) async {
    final updatedSettings = Map<String, dynamic>.from(_preferences.customSettings);
    updatedSettings[key] = value;
    
    await _updatePreferences(
      _preferences.copyWith(customSettings: updatedSettings),
    );
    
    await _analyticsService.trackEvent('custom_setting_changed', {
      'key': key,
      'value': value.toString(),
    });
  }

  Future<void> resetToDefaults() async {
    const defaultPreferences = UserPreferences();
    
    await _updatePreferences(defaultPreferences);
    
    // Reset all related services
    try {
      await _notificationService.reset();
      await _securityService.resetToDefaults();
      await _analyticsService.reset();
    } catch (e) {
      log('Failed to reset services: $e');
    }
    
    await _analyticsService.trackEvent('settings_reset', {});
  }

  Future<void> syncWithServer() async {
    _setLoading(true);
    
    try {
      await _repository.syncWithServer();
      _preferences = await _repository.getUserPreferences();
      _lastSyncAt = _preferences.lastSyncAt;
      _error = null;
      
      await _analyticsService.trackEvent('settings_synced', {
        'sync_time': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _error = 'Failed to sync settings: $e';
      log('Settings sync failed: $e');
    }
    
    _setLoading(false);
  }

  Future<Map<String, dynamic>> exportSettings() async {
    final exported = await _repository.exportPreferences();
    
    await _analyticsService.trackEvent('settings_exported', {
      'export_time': DateTime.now().toIso8601String(),
    });
    
    return exported;
  }

  Future<void> importSettings(Map<String, dynamic> data) async {
    _setLoading(true);
    
    try {
      await _repository.importPreferences(data);
      _preferences = await _repository.getUserPreferences();
      _error = null;
      
      // Apply imported settings to services
      await _applyAllSettings();
      
      await _analyticsService.trackEvent('settings_imported', {
        'import_time': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _error = 'Failed to import settings: $e';
      log('Settings import failed: $e');
    }
    
    _setLoading(false);
  }

  Future<void> _updatePreferences(UserPreferences newPreferences) async {
    _preferences = newPreferences;
    notifyListeners();
    
    try {
      await _repository.updatePreferences(newPreferences);
      _error = null;
    } catch (e) {
      _error = e.toString();
      log('Failed to update preferences: $e');
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> _requestLocationPermission() async {
    // In a real app, this would request location permission
    // For this demo, we'll simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<void> _applyAllSettings() async {
    // Apply all settings to their respective services
    try {
      if (_preferences.pushNotifications) {
        await _notificationService.requestPermission();
        await _notificationService.subscribeToTopics(_preferences.interests);
      } else {
        await _notificationService.unsubscribeFromAllTopics();
      }
      
      await _securityService.setBiometricEnabled(_preferences.biometricEnabled);
      await _securityService.updateAutoLockTimer(_preferences.autoLockTimer);
      await _analyticsService.setAnalyticsEnabled(_preferences.analytics);
    } catch (e) {
      log('Failed to apply settings to services: $e');
    }
  }
}
