import 'package:equatable/equatable.dart';

class UserPreferences extends Equatable {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool locationServices;
  final bool analytics;
  final String language;
  final String currency;
  final int autoLockTimer; // seconds
  final bool biometricEnabled;
  final List<String> interests;
  final Map<String, dynamic> customSettings;
  final DateTime? lastSyncAt;

  const UserPreferences({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.locationServices = false,
    this.analytics = true,
    this.language = 'en',
    this.currency = 'USD',
    this.autoLockTimer = 300, // 5 minutes
    this.biometricEnabled = false,
    this.interests = const [],
    this.customSettings = const {},
    this.lastSyncAt,
  });

  UserPreferences copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? locationServices,
    bool? analytics,
    String? language,
    String? currency,
    int? autoLockTimer,
    bool? biometricEnabled,
    List<String>? interests,
    Map<String, dynamic>? customSettings,
    DateTime? lastSyncAt,
  }) {
    return UserPreferences(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      locationServices: locationServices ?? this.locationServices,
      analytics: analytics ?? this.analytics,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      autoLockTimer: autoLockTimer ?? this.autoLockTimer,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      interests: interests ?? this.interests,
      customSettings: customSettings ?? this.customSettings,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'locationServices': locationServices,
      'analytics': analytics,
      'language': language,
      'currency': currency,
      'autoLockTimer': autoLockTimer,
      'biometricEnabled': biometricEnabled,
      'interests': interests,
      'customSettings': customSettings,
      'lastSyncAt': lastSyncAt?.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      locationServices: json['locationServices'] as bool? ?? false,
      analytics: json['analytics'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'USD',
      autoLockTimer: json['autoLockTimer'] as int? ?? 300,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      interests: List<String>.from(json['interests'] as List? ?? []),
      customSettings: Map<String, dynamic>.from(json['customSettings'] as Map? ?? {}),
      lastSyncAt: json['lastSyncAt'] != null 
          ? DateTime.parse(json['lastSyncAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        emailNotifications,
        pushNotifications,
        locationServices,
        analytics,
        language,
        currency,
        autoLockTimer,
        biometricEnabled,
        interests,
        customSettings,
        lastSyncAt,
      ];

  @override
  String toString() {
    return 'UserPreferences(emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, language: $language, analytics: $analytics)';
  }
}
