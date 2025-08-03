import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user in the application
class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final UserRole role;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserPreferences preferences;
  final UserAddress? defaultAddress;
  final List<UserAddress> addresses;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatarUrl,
    this.dateOfBirth,
    this.role = UserRole.customer,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    this.lastLoginAt,
    this.preferences = const UserPreferences(),
    this.defaultAddress,
    this.addresses = const [],
  });

  /// Create a copy with updated properties
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
    DateTime? dateOfBirth,
    UserRole? role,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
    UserAddress? defaultAddress,
    List<UserAddress>? addresses,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      addresses: addresses ?? this.addresses,
    );
  }

  /// Get user's full name
  String get fullName => '$firstName $lastName';

  /// Get user's display name (full name or email if name not available)
  String get displayName {
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return fullName.trim();
    }
    return email;
  }

  /// Get user's initials for avatar display
  String get initials {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    } else if (firstName.isNotEmpty) {
      return firstName[0].toUpperCase();
    } else if (lastName.isNotEmpty) {
      return lastName[0].toUpperCase();
    } else {
      return email[0].toUpperCase();
    }
  }

  /// Check if user profile is complete
  bool get isProfileComplete {
    return firstName.isNotEmpty &&
           lastName.isNotEmpty &&
           isEmailVerified &&
           phoneNumber != null &&
           phoneNumber!.isNotEmpty;
  }

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is moderator
  bool get isModerator => role == UserRole.moderator;

  /// Check if user is customer
  bool get isCustomer => role == UserRole.customer;

  /// Check if user has elevated privileges
  bool get hasElevatedPrivileges => isAdmin || isModerator;

  /// Get age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Check if user is active (logged in recently)
  bool get isActive {
    if (lastLoginAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);
    return difference.inDays < 30; // Consider active if logged in within 30 days
  }

  /// Add address to user's address list
  User addAddress(UserAddress address) {
    final updatedAddresses = List<UserAddress>.from(addresses)..add(address);
    return copyWith(addresses: updatedAddresses);
  }

  /// Remove address from user's address list
  User removeAddress(String addressId) {
    final updatedAddresses = addresses.where((addr) => addr.id != addressId).toList();
    return copyWith(addresses: updatedAddresses);
  }

  /// Update address in user's address list
  User updateAddress(UserAddress updatedAddress) {
    final updatedAddresses = addresses.map((addr) {
      return addr.id == updatedAddress.id ? updatedAddress : addr;
    }).toList();
    return copyWith(addresses: updatedAddresses);
  }

  /// Set default address
  User setDefaultAddress(String addressId) {
    final address = addresses.firstWhere(
      (addr) => addr.id == addressId,
      orElse: () => throw ArgumentError('Address not found'),
    );
    return copyWith(defaultAddress: address);
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        avatarUrl,
        dateOfBirth,
        role,
        isEmailVerified,
        isPhoneVerified,
        createdAt,
        lastLoginAt,
        preferences,
        defaultAddress,
        addresses,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $fullName, role: $role)';
  }
}

/// User role enumeration
enum UserRole {
  customer('Customer'),
  moderator('Moderator'),
  admin('Administrator');

  const UserRole(this.displayName);
  final String displayName;
}

/// User preferences for app customization
class UserPreferences extends Equatable {
  final bool enableNotifications;
  final bool enableEmailMarketing;
  final bool enableSmsMarketing;
  final String preferredLanguage;
  final String preferredCurrency;
  final bool darkModeEnabled;
  final bool biometricsEnabled;
  final double fontSize;
  final bool highContrastMode;

  const UserPreferences({
    this.enableNotifications = true,
    this.enableEmailMarketing = false,
    this.enableSmsMarketing = false,
    this.preferredLanguage = 'en',
    this.preferredCurrency = 'USD',
    this.darkModeEnabled = false,
    this.biometricsEnabled = false,
    this.fontSize = 1.0,
    this.highContrastMode = false,
  });

  UserPreferences copyWith({
    bool? enableNotifications,
    bool? enableEmailMarketing,
    bool? enableSmsMarketing,
    String? preferredLanguage,
    String? preferredCurrency,
    bool? darkModeEnabled,
    bool? biometricsEnabled,
    double? fontSize,
    bool? highContrastMode,
  }) {
    return UserPreferences(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableEmailMarketing: enableEmailMarketing ?? this.enableEmailMarketing,
      enableSmsMarketing: enableSmsMarketing ?? this.enableSmsMarketing,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      fontSize: fontSize ?? this.fontSize,
      highContrastMode: highContrastMode ?? this.highContrastMode,
    );
  }

  @override
  List<Object?> get props => [
        enableNotifications,
        enableEmailMarketing,
        enableSmsMarketing,
        preferredLanguage,
        preferredCurrency,
        darkModeEnabled,
        biometricsEnabled,
        fontSize,
        highContrastMode,
      ];
}

/// User address entity
class UserAddress extends Equatable {
  final String id;
  final String label; // e.g., "Home", "Work", "Other"
  final String firstName;
  final String lastName;
  final String street1;
  final String? street2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phoneNumber;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserAddress({
    required this.id,
    required this.label,
    required this.firstName,
    required this.lastName,
    required this.street1,
    this.street2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phoneNumber,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  UserAddress copyWith({
    String? id,
    String? label,
    String? firstName,
    String? lastName,
    String? street1,
    String? street2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phoneNumber,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street1: street1 ?? this.street1,
      street2: street2 ?? this.street2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get full name for address
  String get fullName => '$firstName $lastName';

  /// Get formatted address string
  String get formattedAddress {
    final buffer = StringBuffer();
    buffer.write(street1);
    if (street2 != null && street2!.isNotEmpty) {
      buffer.write(', $street2');
    }
    buffer.write(', $city, $state $postalCode');
    buffer.write(', $country');
    return buffer.toString();
  }

  /// Get short formatted address (without country)
  String get shortFormattedAddress {
    final buffer = StringBuffer();
    buffer.write(street1);
    if (street2 != null && street2!.isNotEmpty) {
      buffer.write(', $street2');
    }
    buffer.write(', $city, $state $postalCode');
    return buffer.toString();
  }

  @override
  List<Object?> get props => [
        id,
        label,
        firstName,
        lastName,
        street1,
        street2,
        city,
        state,
        postalCode,
        country,
        phoneNumber,
        isDefault,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'UserAddress(id: $id, label: $label, address: $formattedAddress)';
  }
}

/// Factory class for creating user entities
class UserFactory {
  /// Create a new user
  static User create({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    UserRole role = UserRole.customer,
  }) {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      role: role,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Create a sample user for testing
  static User createSample({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole role = UserRole.customer,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return User(
      id: id ?? 'user_$timestamp',
      email: email ?? 'user$timestamp@example.com',
      firstName: firstName ?? 'John',
      lastName: lastName ?? 'Doe',
      role: role,
      isEmailVerified: true,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Create admin user
  static User createAdmin({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
  }) {
    return create(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: UserRole.admin,
    );
  }
}