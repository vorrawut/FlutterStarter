// lib/core/maintenance/app_maintenance_manager.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:convert';

/// Comprehensive app maintenance and lifecycle management
/// Handles version updates, feature flags, maintenance modes, and user communication
class AppMaintenanceManager {
  static final AppMaintenanceManager _instance = AppMaintenanceManager._internal();
  factory AppMaintenanceManager() => _instance;
  AppMaintenanceManager._internal();

  static const String _maintenancePrefsKey = 'app_maintenance_config';
  static const String _updatePrefsKey = 'app_update_tracking';
  late SharedPreferences _prefs;
  late PackageInfo _packageInfo;
  late FirebaseRemoteConfig _remoteConfig;
  late FirebaseAnalytics _analytics;
  
  bool _isInitialized = false;
  MaintenanceConfig? _currentConfig;
  UpdateTrackingData? _updateData;

  /// Initialize the maintenance manager
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _packageInfo = await PackageInfo.fromPlatform();
      _remoteConfig = FirebaseRemoteConfig.instance;
      _analytics = FirebaseAnalytics.instance;
      
      await _initializeRemoteConfig();
      await _loadMaintenanceConfig();
      await _loadUpdateData();
      await _checkForUpdates();
      
      _isInitialized = true;
      debugPrint('✅ App Maintenance Manager initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Maintenance Manager: $e');
    }
  }

  /// Initialize Firebase Remote Config
  Future<void> _initializeRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(minutes: 1),
        minimumFetchInterval: Duration(hours: 1),
      ));

      // Set default values
      await _remoteConfig.setDefaults({
        'maintenance_mode': false,
        'maintenance_message': 'We\'re currently performing maintenance. Please try again later.',
        'minimum_version': '1.0.0',
        'latest_version': '1.0.0',
        'force_update': false,
        'update_message': 'A new version is available with improvements and bug fixes.',
        'feature_flags': '{}',
        'announcement_message': '',
        'announcement_active': false,
        'store_urls': '{"android": "", "ios": ""}',
      });

      await _remoteConfig.fetchAndActivate();
      debugPrint('Remote Config initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Remote Config: $e');
    }
  }

  /// Load maintenance configuration
  Future<void> _loadMaintenanceConfig() async {
    try {
      // Get configuration from Remote Config
      final maintenanceMode = _remoteConfig.getBool('maintenance_mode');
      final maintenanceMessage = _remoteConfig.getString('maintenance_message');
      final minimumVersion = _remoteConfig.getString('minimum_version');
      final latestVersion = _remoteConfig.getString('latest_version');
      final forceUpdate = _remoteConfig.getBool('force_update');
      final updateMessage = _remoteConfig.getString('update_message');
      final featureFlagsJson = _remoteConfig.getString('feature_flags');
      final announcementMessage = _remoteConfig.getString('announcement_message');
      final announcementActive = _remoteConfig.getBool('announcement_active');
      final storeUrlsJson = _remoteConfig.getString('store_urls');

      // Parse feature flags
      final featureFlags = <String, dynamic>{};
      if (featureFlagsJson.isNotEmpty) {
        try {
          featureFlags.addAll(jsonDecode(featureFlagsJson));
        } catch (e) {
          debugPrint('Error parsing feature flags: $e');
        }
      }

      // Parse store URLs
      final storeUrls = <String, String>{};
      if (storeUrlsJson.isNotEmpty) {
        try {
          final urls = jsonDecode(storeUrlsJson) as Map<String, dynamic>;
          storeUrls.addAll(urls.cast<String, String>());
        } catch (e) {
          debugPrint('Error parsing store URLs: $e');
        }
      }

      _currentConfig = MaintenanceConfig(
        maintenanceMode: maintenanceMode,
        maintenanceMessage: maintenanceMessage,
        minimumVersion: minimumVersion,
        latestVersion: latestVersion,
        forceUpdate: forceUpdate,
        updateMessage: updateMessage,
        featureFlags: featureFlags,
        announcementMessage: announcementMessage,
        announcementActive: announcementActive,
        storeUrls: storeUrls,
        lastUpdated: DateTime.now(),
      );

      // Save to local storage as backup
      await _saveMaintenanceConfig();
      
    } catch (e) {
      debugPrint('Error loading maintenance config: $e');
      await _loadLocalMaintenanceConfig();
    }
  }

  /// Load local maintenance configuration as fallback
  Future<void> _loadLocalMaintenanceConfig() async {
    try {
      final configJson = _prefs.getString(_maintenancePrefsKey);
      if (configJson != null) {
        final configMap = jsonDecode(configJson) as Map<String, dynamic>;
        _currentConfig = MaintenanceConfig.fromJson(configMap);
      } else {
        _currentConfig = MaintenanceConfig.default();
      }
    } catch (e) {
      debugPrint('Error loading local maintenance config: $e');
      _currentConfig = MaintenanceConfig.default();
    }
  }

  /// Save maintenance configuration to local storage
  Future<void> _saveMaintenanceConfig() async {
    if (_currentConfig != null) {
      final configJson = jsonEncode(_currentConfig!.toJson());
      await _prefs.setString(_maintenancePrefsKey, configJson);
    }
  }

  /// Load update tracking data
  Future<void> _loadUpdateData() async {
    try {
      final dataJson = _prefs.getString(_updatePrefsKey);
      if (dataJson != null) {
        final dataMap = jsonDecode(dataJson) as Map<String, dynamic>;
        _updateData = UpdateTrackingData.fromJson(dataMap);
      } else {
        _updateData = UpdateTrackingData.initial(_packageInfo.version);
        await _saveUpdateData();
      }
    } catch (e) {
      debugPrint('Error loading update data: $e');
      _updateData = UpdateTrackingData.initial(_packageInfo.version);
    }
  }

  /// Save update tracking data
  Future<void> _saveUpdateData() async {
    if (_updateData != null) {
      final dataJson = jsonEncode(_updateData!.toJson());
      await _prefs.setString(_updatePrefsKey, dataJson);
    }
  }

  /// Check for app updates
  Future<UpdateStatus> _checkForUpdates() async {
    if (_currentConfig == null || _updateData == null) {
      return UpdateStatus.unknown;
    }

    final currentVersion = _packageInfo.version;
    final minimumVersion = _currentConfig!.minimumVersion;
    final latestVersion = _currentConfig!.latestVersion;

    // Check if current version is below minimum required
    if (_isVersionLower(currentVersion, minimumVersion)) {
      await _analytics.logEvent(
        name: 'version_below_minimum',
        parameters: {
          'current_version': currentVersion,
          'minimum_version': minimumVersion,
        },
      );
      return UpdateStatus.required;
    }

    // Check if there's a newer version available
    if (_isVersionLower(currentVersion, latestVersion)) {
      await _analytics.logEvent(
        name: 'update_available',
        parameters: {
          'current_version': currentVersion,
          'latest_version': latestVersion,
        },
      );
      return _currentConfig!.forceUpdate ? UpdateStatus.required : UpdateStatus.available;
    }

    return UpdateStatus.upToDate;
  }

  /// Compare version strings
  bool _isVersionLower(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();

    // Ensure both versions have the same number of parts
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return true;
      if (v1Parts[i] > v2Parts[i]) return false;
    }

    return false; // Versions are equal
  }

  /// Check if app is in maintenance mode
  bool get isInMaintenanceMode {
    return _currentConfig?.maintenanceMode ?? false;
  }

  /// Get maintenance message
  String get maintenanceMessage {
    return _currentConfig?.maintenanceMessage ?? 'App is currently under maintenance.';
  }

  /// Check if feature is enabled
  bool isFeatureEnabled(String featureName) {
    if (_currentConfig?.featureFlags == null) return false;
    return _currentConfig!.featureFlags[featureName] as bool? ?? false;
  }

  /// Get feature flag value
  T? getFeatureFlag<T>(String featureName) {
    if (_currentConfig?.featureFlags == null) return null;
    return _currentConfig!.featureFlags[featureName] as T?;
  }

  /// Check if announcement is active
  bool get hasActiveAnnouncement {
    return _currentConfig?.announcementActive ?? false;
  }

  /// Get announcement message
  String get announcementMessage {
    return _currentConfig?.announcementMessage ?? '';
  }

  /// Get update status
  Future<UpdateStatus> getUpdateStatus() async {
    if (!_isInitialized) await initialize();
    return await _checkForUpdates();
  }

  /// Get update information
  Future<UpdateInfo?> getUpdateInfo() async {
    final status = await getUpdateStatus();
    
    if (status == UpdateStatus.upToDate || _currentConfig == null) {
      return null;
    }

    return UpdateInfo(
      status: status,
      currentVersion: _packageInfo.version,
      latestVersion: _currentConfig!.latestVersion,
      minimumVersion: _currentConfig!.minimumVersion,
      updateMessage: _currentConfig!.updateMessage,
      isForced: _currentConfig!.forceUpdate || status == UpdateStatus.required,
      storeUrls: _currentConfig!.storeUrls,
    );
  }

  /// Record update prompt shown
  Future<void> recordUpdatePromptShown() async {
    if (_updateData == null) return;

    _updateData = _updateData!.copyWith(
      updatePromptsShown: _updateData!.updatePromptsShown + 1,
      lastPromptDate: DateTime.now(),
    );

    await _saveUpdateData();
    
    await _analytics.logEvent(
      name: 'update_prompt_shown',
      parameters: {
        'current_version': _packageInfo.version,
        'latest_version': _currentConfig?.latestVersion ?? 'unknown',
        'prompts_shown': _updateData!.updatePromptsShown,
      },
    );
  }

  /// Record update dismissed
  Future<void> recordUpdateDismissed() async {
    if (_updateData == null) return;

    _updateData = _updateData!.copyWith(
      updatesDismissed: _updateData!.updatesDismissed + 1,
      lastDismissalDate: DateTime.now(),
    );

    await _saveUpdateData();
    
    await _analytics.logEvent(
      name: 'update_dismissed',
      parameters: {
        'current_version': _packageInfo.version,
        'latest_version': _currentConfig?.latestVersion ?? 'unknown',
        'dismissals_count': _updateData!.updatesDismissed,
      },
    );
  }

  /// Record store redirect
  Future<void> recordStoreRedirect(String platform) async {
    await _analytics.logEvent(
      name: 'store_redirect',
      parameters: {
        'platform': platform,
        'current_version': _packageInfo.version,
        'latest_version': _currentConfig?.latestVersion ?? 'unknown',
      },
    );
  }

  /// Refresh configuration from Remote Config
  Future<void> refreshConfiguration() async {
    try {
      await _remoteConfig.fetchAndActivate();
      await _loadMaintenanceConfig();
      debugPrint('Configuration refreshed from Remote Config');
      
      await _analytics.logEvent(name: 'config_refreshed');
    } catch (e) {
      debugPrint('Error refreshing configuration: $e');
    }
  }

  /// Should show update prompt
  bool shouldShowUpdatePrompt() {
    if (_updateData == null) return false;

    final now = DateTime.now();
    
    // Don't show if dismissed recently (within 24 hours)
    if (_updateData!.lastDismissalDate != null) {
      final hoursSinceDismissal = now.difference(_updateData!.lastDismissalDate!).inHours;
      if (hoursSinceDismissal < 24) {
        return false;
      }
    }

    // Don't show if shown recently (within 1 hour)
    if (_updateData!.lastPromptDate != null) {
      final hoursSincePrompt = now.difference(_updateData!.lastPromptDate!).inHours;
      if (hoursSincePrompt < 1) {
        return false;
      }
    }

    // Don't show too frequently
    if (_updateData!.updatePromptsShown >= 5) {
      return false;
    }

    return true;
  }

  /// Get app status summary
  AppStatus getAppStatus() {
    return AppStatus(
      isInMaintenance: isInMaintenanceMode,
      maintenanceMessage: maintenanceMessage,
      hasAnnouncement: hasActiveAnnouncement,
      announcementMessage: announcementMessage,
      updateStatus: UpdateStatus.unknown, // Will be updated by calling getUpdateStatus()
      featureFlags: _currentConfig?.featureFlags ?? {},
      lastConfigUpdate: _currentConfig?.lastUpdated,
    );
  }

  /// Get maintenance analytics
  MaintenanceAnalytics getAnalytics() {
    return MaintenanceAnalytics(
      currentVersion: _packageInfo.version,
      latestVersion: _currentConfig?.latestVersion ?? 'unknown',
      minimumVersion: _currentConfig?.minimumVersion ?? 'unknown',
      updatePromptsShown: _updateData?.updatePromptsShown ?? 0,
      updatesDismissed: _updateData?.updatesDismissed ?? 0,
      lastPromptDate: _updateData?.lastPromptDate,
      lastDismissalDate: _updateData?.lastDismissalDate,
      isInMaintenanceMode: isInMaintenanceMode,
      hasActiveAnnouncement: hasActiveAnnouncement,
      enabledFeatures: _currentConfig?.featureFlags.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList() ?? [],
    );
  }

  /// Current configuration
  MaintenanceConfig? get currentConfig => _currentConfig;

  /// Current update data
  UpdateTrackingData? get updateData => _updateData;
}

/// Maintenance configuration model
class MaintenanceConfig {
  final bool maintenanceMode;
  final String maintenanceMessage;
  final String minimumVersion;
  final String latestVersion;
  final bool forceUpdate;
  final String updateMessage;
  final Map<String, dynamic> featureFlags;
  final String announcementMessage;
  final bool announcementActive;
  final Map<String, String> storeUrls;
  final DateTime lastUpdated;

  const MaintenanceConfig({
    required this.maintenanceMode,
    required this.maintenanceMessage,
    required this.minimumVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.updateMessage,
    required this.featureFlags,
    required this.announcementMessage,
    required this.announcementActive,
    required this.storeUrls,
    required this.lastUpdated,
  });

  factory MaintenanceConfig.default() {
    return MaintenanceConfig(
      maintenanceMode: false,
      maintenanceMessage: 'We\'re currently performing maintenance. Please try again later.',
      minimumVersion: '1.0.0',
      latestVersion: '1.0.0',
      forceUpdate: false,
      updateMessage: 'A new version is available with improvements and bug fixes.',
      featureFlags: {},
      announcementMessage: '',
      announcementActive: false,
      storeUrls: {},
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maintenanceMode': maintenanceMode,
      'maintenanceMessage': maintenanceMessage,
      'minimumVersion': minimumVersion,
      'latestVersion': latestVersion,
      'forceUpdate': forceUpdate,
      'updateMessage': updateMessage,
      'featureFlags': featureFlags,
      'announcementMessage': announcementMessage,
      'announcementActive': announcementActive,
      'storeUrls': storeUrls,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory MaintenanceConfig.fromJson(Map<String, dynamic> json) {
    return MaintenanceConfig(
      maintenanceMode: json['maintenanceMode'] as bool,
      maintenanceMessage: json['maintenanceMessage'] as String,
      minimumVersion: json['minimumVersion'] as String,
      latestVersion: json['latestVersion'] as String,
      forceUpdate: json['forceUpdate'] as bool,
      updateMessage: json['updateMessage'] as String,
      featureFlags: json['featureFlags'] as Map<String, dynamic>,
      announcementMessage: json['announcementMessage'] as String,
      announcementActive: json['announcementActive'] as bool,
      storeUrls: (json['storeUrls'] as Map<String, dynamic>).cast<String, String>(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

/// Update tracking data model
class UpdateTrackingData {
  final String currentVersion;
  final int updatePromptsShown;
  final int updatesDismissed;
  final DateTime? lastPromptDate;
  final DateTime? lastDismissalDate;
  final DateTime? lastUpdateCheckDate;

  const UpdateTrackingData({
    required this.currentVersion,
    required this.updatePromptsShown,
    required this.updatesDismissed,
    this.lastPromptDate,
    this.lastDismissalDate,
    this.lastUpdateCheckDate,
  });

  factory UpdateTrackingData.initial(String version) {
    return UpdateTrackingData(
      currentVersion: version,
      updatePromptsShown: 0,
      updatesDismissed: 0,
      lastUpdateCheckDate: DateTime.now(),
    );
  }

  UpdateTrackingData copyWith({
    String? currentVersion,
    int? updatePromptsShown,
    int? updatesDismissed,
    DateTime? lastPromptDate,
    DateTime? lastDismissalDate,
    DateTime? lastUpdateCheckDate,
  }) {
    return UpdateTrackingData(
      currentVersion: currentVersion ?? this.currentVersion,
      updatePromptsShown: updatePromptsShown ?? this.updatePromptsShown,
      updatesDismissed: updatesDismissed ?? this.updatesDismissed,
      lastPromptDate: lastPromptDate ?? this.lastPromptDate,
      lastDismissalDate: lastDismissalDate ?? this.lastDismissalDate,
      lastUpdateCheckDate: lastUpdateCheckDate ?? this.lastUpdateCheckDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentVersion': currentVersion,
      'updatePromptsShown': updatePromptsShown,
      'updatesDismissed': updatesDismissed,
      'lastPromptDate': lastPromptDate?.toIso8601String(),
      'lastDismissalDate': lastDismissalDate?.toIso8601String(),
      'lastUpdateCheckDate': lastUpdateCheckDate?.toIso8601String(),
    };
  }

  factory UpdateTrackingData.fromJson(Map<String, dynamic> json) {
    return UpdateTrackingData(
      currentVersion: json['currentVersion'] as String,
      updatePromptsShown: json['updatePromptsShown'] as int,
      updatesDismissed: json['updatesDismissed'] as int,
      lastPromptDate: json['lastPromptDate'] != null 
          ? DateTime.parse(json['lastPromptDate'] as String) 
          : null,
      lastDismissalDate: json['lastDismissalDate'] != null 
          ? DateTime.parse(json['lastDismissalDate'] as String) 
          : null,
      lastUpdateCheckDate: json['lastUpdateCheckDate'] != null 
          ? DateTime.parse(json['lastUpdateCheckDate'] as String) 
          : null,
    );
  }
}

/// Update info model
class UpdateInfo {
  final UpdateStatus status;
  final String currentVersion;
  final String latestVersion;
  final String minimumVersion;
  final String updateMessage;
  final bool isForced;
  final Map<String, String> storeUrls;

  const UpdateInfo({
    required this.status,
    required this.currentVersion,
    required this.latestVersion,
    required this.minimumVersion,
    required this.updateMessage,
    required this.isForced,
    required this.storeUrls,
  });
}

/// App status model
class AppStatus {
  final bool isInMaintenance;
  final String maintenanceMessage;
  final bool hasAnnouncement;
  final String announcementMessage;
  final UpdateStatus updateStatus;
  final Map<String, dynamic> featureFlags;
  final DateTime? lastConfigUpdate;

  const AppStatus({
    required this.isInMaintenance,
    required this.maintenanceMessage,
    required this.hasAnnouncement,
    required this.announcementMessage,
    required this.updateStatus,
    required this.featureFlags,
    this.lastConfigUpdate,
  });
}

/// Maintenance analytics model
class MaintenanceAnalytics {
  final String currentVersion;
  final String latestVersion;
  final String minimumVersion;
  final int updatePromptsShown;
  final int updatesDismissed;
  final DateTime? lastPromptDate;
  final DateTime? lastDismissalDate;
  final bool isInMaintenanceMode;
  final bool hasActiveAnnouncement;
  final List<String> enabledFeatures;

  const MaintenanceAnalytics({
    required this.currentVersion,
    required this.latestVersion,
    required this.minimumVersion,
    required this.updatePromptsShown,
    required this.updatesDismissed,
    this.lastPromptDate,
    this.lastDismissalDate,
    required this.isInMaintenanceMode,
    required this.hasActiveAnnouncement,
    required this.enabledFeatures,
  });
}

/// Update status enumeration
enum UpdateStatus {
  unknown,
  upToDate,
  available,
  required,
}

