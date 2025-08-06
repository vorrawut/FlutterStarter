/// User profile entity with role-based features and preferences
/// 
/// This file defines the UserProfile model for authentication,
/// user preferences, and role-based feature management.
library;

import 'package:flutter/foundation.dart';
import 'product.dart';

/// User role enumeration
enum UserRole {
  guest('Guest'),
  customer('Customer'),
  premium('Premium Customer'),
  admin('Administrator');

  const UserRole(this.displayName);

  /// Display name for the role
  final String displayName;

  /// Whether this role can access premium features
  bool get isPremium => this == UserRole.premium || this == UserRole.admin;

  /// Whether this role has admin privileges
  bool get isAdmin => this == UserRole.admin;

  /// Whether this role can make purchases
  bool get canPurchase => this != UserRole.guest;
}

/// User authentication status
enum AuthStatus {
  unauthenticated('Not Signed In'),
  authenticated('Signed In'),
  verifying('Verifying'),
  error('Authentication Error');

  const AuthStatus(this.label);

  /// Display label for the status
  final String label;
}

/// User preferences for shopping experience
@immutable
class UserPreferences {
  const UserPreferences({
    this.favoriteCategories = const [],
    this.currency = 'USD',
    this.language = 'en',
    this.receiveNotifications = true,
    this.receivePromotions = true,
    this.darkMode = false,
    this.compactView = false,
  });

  /// Favorite product categories
  final List<ProductCategory> favoriteCategories;

  /// Preferred currency
  final String currency;

  /// Preferred language
  final String language;

  /// Whether to receive notifications
  final bool receiveNotifications;

  /// Whether to receive promotional emails
  final bool receivePromotions;

  /// Whether to use dark mode
  final bool darkMode;

  /// Whether to use compact view
  final bool compactView;

  /// Create preferences from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteCategories: (json['favoriteCategories'] as List?)
          ?.map((categoryName) => ProductCategory.values.firstWhere(
                (cat) => cat.name == categoryName,
                orElse: () => ProductCategory.electronics,
              ))
          .toList() ?? [],
      currency: json['currency'] as String? ?? 'USD',
      language: json['language'] as String? ?? 'en',
      receiveNotifications: json['receiveNotifications'] as bool? ?? true,
      receivePromotions: json['receivePromotions'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? false,
      compactView: json['compactView'] as bool? ?? false,
    );
  }

  /// Convert preferences to JSON
  Map<String, dynamic> toJson() {
    return {
      'favoriteCategories': favoriteCategories.map((cat) => cat.name).toList(),
      'currency': currency,
      'language': language,
      'receiveNotifications': receiveNotifications,
      'receivePromotions': receivePromotions,
      'darkMode': darkMode,
      'compactView': compactView,
    };
  }

  /// Create a copy with modified fields
  UserPreferences copyWith({
    List<ProductCategory>? favoriteCategories,
    String? currency,
    String? language,
    bool? receiveNotifications,
    bool? receivePromotions,
    bool? darkMode,
    bool? compactView,
  }) {
    return UserPreferences(
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      receiveNotifications: receiveNotifications ?? this.receiveNotifications,
      receivePromotions: receivePromotions ?? this.receivePromotions,
      darkMode: darkMode ?? this.darkMode,
      compactView: compactView ?? this.compactView,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        listEquals(other.favoriteCategories, favoriteCategories) &&
        other.currency == currency &&
        other.language == language &&
        other.receiveNotifications == receiveNotifications &&
        other.receivePromotions == receivePromotions &&
        other.darkMode == darkMode &&
        other.compactView == compactView;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(favoriteCategories),
      currency,
      language,
      receiveNotifications,
      receivePromotions,
      darkMode,
      compactView,
    );
  }
}

/// Immutable UserProfile entity with authentication and preferences
/// 
/// Represents a user in the e-commerce system with authentication status,
/// profile information, preferences, and role-based features.
@immutable
class UserProfile {
  /// Creates a new UserProfile instance
  const UserProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.authStatus,
    required this.preferences,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.wishlistProductIds = const [],
    this.orderHistory = const [],
    this.memberSince,
    this.lastLoginAt,
    this.totalSpent = 0.0,
    this.loyaltyPoints = 0,
  });

  /// Unique user identifier
  final String id;

  /// User email address
  final String email;

  /// User role
  final UserRole role;

  /// Authentication status
  final AuthStatus authStatus;

  /// User preferences
  final UserPreferences preferences;

  /// First name (optional)
  final String? firstName;

  /// Last name (optional)
  final String? lastName;

  /// Avatar image URL (optional)
  final String? avatarUrl;

  /// Phone number (optional)
  final String? phoneNumber;

  /// Date of birth (optional)
  final DateTime? dateOfBirth;

  /// Street address (optional)
  final String? address;

  /// City (optional)
  final String? city;

  /// Country (optional)
  final String? country;

  /// Postal code (optional)
  final String? postalCode;

  /// List of wishlisted product IDs
  final List<String> wishlistProductIds;

  /// Order history IDs
  final List<String> orderHistory;

  /// When the user joined
  final DateTime? memberSince;

  /// Last login time
  final DateTime? lastLoginAt;

  /// Total amount spent
  final double totalSpent;

  /// Loyalty points earned
  final int loyaltyPoints;

  /// Create a user profile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.customer,
      ),
      authStatus: AuthStatus.values.firstWhere(
        (status) => status.name == json['authStatus'],
        orElse: () => AuthStatus.unauthenticated,
      ),
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>? ?? {}),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      wishlistProductIds: List<String>.from(json['wishlistProductIds'] as List? ?? []),
      orderHistory: List<String>.from(json['orderHistory'] as List? ?? []),
      memberSince: json['memberSince'] != null ? DateTime.parse(json['memberSince'] as String) : null,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt'] as String) : null,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      loyaltyPoints: json['loyaltyPoints'] as int? ?? 0,
    );
  }

  /// Convert user profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.name,
      'authStatus': authStatus.name,
      'preferences': preferences.toJson(),
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'wishlistProductIds': wishlistProductIds,
      'orderHistory': orderHistory,
      'memberSince': memberSince?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'totalSpent': totalSpent,
      'loyaltyPoints': loyaltyPoints,
    };
  }

  /// Create a copy with modified fields (immutable update pattern)
  UserProfile copyWith({
    String? id,
    String? email,
    UserRole? role,
    AuthStatus? authStatus,
    UserPreferences? preferences,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    List<String>? wishlistProductIds,
    List<String>? orderHistory,
    DateTime? memberSince,
    DateTime? lastLoginAt,
    double? totalSpent,
    int? loyaltyPoints,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      authStatus: authStatus ?? this.authStatus,
      preferences: preferences ?? this.preferences,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      wishlistProductIds: wishlistProductIds ?? this.wishlistProductIds,
      orderHistory: orderHistory ?? this.orderHistory,
      memberSince: memberSince ?? this.memberSince,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      totalSpent: totalSpent ?? this.totalSpent,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    );
  }

  /// Create a guest user profile
  factory UserProfile.guest() {
    return const UserProfile(
      id: 'guest',
      email: '',
      role: UserRole.guest,
      authStatus: AuthStatus.unauthenticated,
      preferences: UserPreferences(),
    );
  }

  /// Create a new customer profile
  factory UserProfile.newCustomer({
    required String email,
    String? firstName,
    String? lastName,
  }) {
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      role: UserRole.customer,
      authStatus: AuthStatus.authenticated,
      preferences: const UserPreferences(),
      firstName: firstName,
      lastName: lastName,
      memberSince: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Sign in the user
  UserProfile signIn() {
    return copyWith(
      authStatus: AuthStatus.authenticated,
      lastLoginAt: DateTime.now(),
    );
  }

  /// Sign out the user
  UserProfile signOut() {
    return copyWith(authStatus: AuthStatus.unauthenticated);
  }

  /// Update user preferences
  UserProfile updatePreferences(UserPreferences newPreferences) {
    return copyWith(preferences: newPreferences);
  }

  /// Update profile information
  UserProfile updateProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? country,
    String? postalCode,
  }) {
    return copyWith(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  /// Add product to wishlist
  UserProfile addToWishlist(String productId) {
    if (wishlistProductIds.contains(productId)) return this;
    
    return copyWith(
      wishlistProductIds: [...wishlistProductIds, productId],
    );
  }

  /// Remove product from wishlist
  UserProfile removeFromWishlist(String productId) {
    return copyWith(
      wishlistProductIds: wishlistProductIds.where((id) => id != productId).toList(),
    );
  }

  /// Toggle product in wishlist
  UserProfile toggleWishlist(String productId) {
    if (wishlistProductIds.contains(productId)) {
      return removeFromWishlist(productId);
    } else {
      return addToWishlist(productId);
    }
  }

  /// Add order to history
  UserProfile addOrder(String orderId, double orderTotal) {
    return copyWith(
      orderHistory: [...orderHistory, orderId],
      totalSpent: totalSpent + orderTotal,
      loyaltyPoints: loyaltyPoints + (orderTotal * 0.01).round(), // 1 point per dollar
    );
  }

  /// Award loyalty points
  UserProfile awardLoyaltyPoints(int points) {
    return copyWith(loyaltyPoints: loyaltyPoints + points);
  }

  /// Redeem loyalty points
  UserProfile redeemLoyaltyPoints(int points) {
    final newPoints = loyaltyPoints - points;
    return copyWith(loyaltyPoints: newPoints > 0 ? newPoints : 0);
  }

  /// Add favorite category
  UserProfile addFavoriteCategory(ProductCategory category) {
    final currentCategories = preferences.favoriteCategories;
    if (currentCategories.contains(category)) return this;

    final updatedCategories = [...currentCategories, category];
    return copyWith(
      preferences: preferences.copyWith(favoriteCategories: updatedCategories),
    );
  }

  /// Remove favorite category
  UserProfile removeFavoriteCategory(ProductCategory category) {
    final updatedCategories = preferences.favoriteCategories
        .where((cat) => cat != category)
        .toList();
    
    return copyWith(
      preferences: preferences.copyWith(favoriteCategories: updatedCategories),
    );
  }

  /// Business logic: Get display name
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return email.isNotEmpty ? email.split('@').first : 'User';
    }
  }

  /// Business logic: Get initials for avatar
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName!.isNotEmpty ? firstName![0] : ''}${lastName!.isNotEmpty ? lastName![0] : ''}'.toUpperCase();
    } else if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    } else if (email.isNotEmpty) {
      return email[0].toUpperCase();
    } else {
      return 'U';
    }
  }

  /// Business logic: Check if user is authenticated
  bool get isAuthenticated => authStatus == AuthStatus.authenticated;

  /// Business logic: Check if user is guest
  bool get isGuest => role == UserRole.guest;

  /// Business logic: Check if user has premium access
  bool get hasPremiumAccess => role.isPremium;

  /// Business logic: Check if user is admin
  bool get isAdmin => role.isAdmin;

  /// Business logic: Check if user can make purchases
  bool get canPurchase => role.canPurchase && isAuthenticated;

  /// Business logic: Get membership duration
  Duration? get membershipDuration {
    if (memberSince == null) return null;
    return DateTime.now().difference(memberSince!);
  }

  /// Business logic: Check if user is new member (joined within 30 days)
  bool get isNewMember {
    final duration = membershipDuration;
    return duration != null && duration.inDays <= 30;
  }

  /// Business logic: Get loyalty tier based on points
  String get loyaltyTier {
    if (loyaltyPoints >= 10000) return 'Diamond';
    if (loyaltyPoints >= 5000) return 'Platinum';
    if (loyaltyPoints >= 2000) return 'Gold';
    if (loyaltyPoints >= 500) return 'Silver';
    return 'Bronze';
  }

  /// Business logic: Check if product is in wishlist
  bool isInWishlist(String productId) => wishlistProductIds.contains(productId);

  /// Business logic: Get formatted total spent
  String get formattedTotalSpent => '\$${totalSpent.toStringAsFixed(2)}';

  /// Business logic: Get full address
  String? get fullAddress {
    final parts = [address, city, country, postalCode]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    
    return parts.isNotEmpty ? parts.join(', ') : null;
  }

  /// Validation: Check if user profile data is valid
  UserProfileValidationResult validate() {
    final errors = <String>[];

    // Email validation
    if (email.isEmpty && role != UserRole.guest) {
      errors.add('Email is required for non-guest users');
    } else if (email.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors.add('Please enter a valid email address');
    }

    // Name validation
    if (firstName != null && firstName!.length > 50) {
      errors.add('First name must be less than 50 characters');
    }

    if (lastName != null && lastName!.length > 50) {
      errors.add('Last name must be less than 50 characters');
    }

    // Phone validation
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      final cleanPhone = phoneNumber!.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
      if (cleanPhone.length < 10 || !RegExp(r'^\d+$').hasMatch(cleanPhone)) {
        errors.add('Please enter a valid phone number');
      }
    }

    // Date of birth validation
    if (dateOfBirth != null && dateOfBirth!.isAfter(DateTime.now())) {
      errors.add('Date of birth cannot be in the future');
    }

    // Loyalty points validation
    if (loyaltyPoints < 0) {
      errors.add('Loyalty points cannot be negative');
    }

    // Total spent validation
    if (totalSpent < 0) {
      errors.add('Total spent cannot be negative');
    }

    return UserProfileValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.authStatus == authStatus &&
        other.preferences == preferences &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.avatarUrl == avatarUrl &&
        other.phoneNumber == phoneNumber &&
        other.dateOfBirth == dateOfBirth &&
        other.address == address &&
        other.city == city &&
        other.country == country &&
        other.postalCode == postalCode &&
        listEquals(other.wishlistProductIds, wishlistProductIds) &&
        listEquals(other.orderHistory, orderHistory) &&
        other.memberSince == memberSince &&
        other.lastLoginAt == lastLoginAt &&
        other.totalSpent == totalSpent &&
        other.loyaltyPoints == loyaltyPoints;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      role,
      authStatus,
      preferences,
      firstName,
      lastName,
      avatarUrl,
      phoneNumber,
      dateOfBirth,
      address,
      city,
      country,
      postalCode,
      Object.hashAll(wishlistProductIds),
      Object.hashAll(orderHistory),
      memberSince,
      lastLoginAt,
      totalSpent,
      loyaltyPoints,
    );
  }

  @override
  String toString() {
    return 'UserProfile('
        'id: $id, '
        'email: $email, '
        'displayName: $displayName, '
        'role: ${role.displayName}, '
        'authStatus: ${authStatus.label}, '
        'loyaltyTier: $loyaltyTier'
        ')';
  }
}

/// User profile validation result
class UserProfileValidationResult {
  const UserProfileValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Whether the user profile data is valid
  final bool isValid;

  /// List of validation errors
  final List<String> errors;

  /// Get formatted error message
  String get errorMessage => errors.join('\n');

  @override
  String toString() {
    return 'UserProfileValidationResult(isValid: $isValid, errors: ${errors.length})';
  }
}