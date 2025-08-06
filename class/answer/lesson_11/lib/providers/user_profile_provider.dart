/// User profile state management with Provider pattern
/// 
/// This file demonstrates user authentication and profile management
/// using Provider and ChangeNotifier for simplified state management.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/models/user_profile.dart';
import '../core/models/product.dart';

/// User profile state management using Provider and ChangeNotifier
/// 
/// Demonstrates modern user authentication and profile state management
/// with automatic dependency injection and optimized rebuilds.
class UserProfileProvider with ChangeNotifier {
  /// Creates a user profile provider
  UserProfileProvider() {
    _currentUser = UserProfile.guest();
    if (kDebugMode) {
      debugPrint('👤 UserProfileProvider initialized with guest user');
    }
  }

  /// Current user profile
  UserProfile _currentUser = UserProfile.guest();

  /// Whether user operations are in progress
  bool _isLoading = false;

  /// Error message if any operation failed
  String? _errorMessage;

  /// When the user data was last updated
  DateTime? _lastUpdated;

  /// Get current user profile (immutable)
  UserProfile get currentUser => _currentUser;

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

  /// Update user and timestamp
  void _updateUser(UserProfile newUser) {
    _currentUser = newUser;
    _lastUpdated = DateTime.now();
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error state
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate authentication API call
      await Future.delayed(const Duration(milliseconds: 1000));

      // Validate credentials (mock validation)
      if (email.isEmpty || password.isEmpty) {
        _setError('Email and password are required');
        return;
      }

      if (!email.contains('@')) {
        _setError('Please enter a valid email address');
        return;
      }

      if (password.length < 6) {
        _setError('Password must be at least 6 characters');
        return;
      }

      // Create user profile (mock user data)
      final user = UserProfile.newCustomer(
        email: email,
        firstName: email.split('@').first.split('.').first,
        lastName: email.split('@').first.split('.').length > 1 
            ? email.split('@').first.split('.').last 
            : null,
      );

      _updateUser(user.signIn());
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 User signed in: ${user.displayName}');
      }

    } catch (error) {
      _setError('Failed to sign in: $error');
      if (kDebugMode) {
        debugPrint('❌ Sign in error: $error');
      }
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(String email, String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate registration API call
      await Future.delayed(const Duration(milliseconds: 1200));

      // Validate input
      if (email.isEmpty || password.isEmpty) {
        _setError('Email and password are required');
        return;
      }

      if (!email.contains('@')) {
        _setError('Please enter a valid email address');
        return;
      }

      if (password.length < 6) {
        _setError('Password must be at least 6 characters');
        return;
      }

      // Create new user profile
      final user = UserProfile.newCustomer(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      _updateUser(user.signIn());
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 New user registered: ${user.displayName}');
      }

    } catch (error) {
      _setError('Failed to create account: $error');
      if (kDebugMode) {
        debugPrint('❌ Sign up error: $error');
      }
    }
  }

  /// Sign in with social provider (mock implementation)
  Future<void> signInWithSocial(String provider) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate social authentication
      await Future.delayed(const Duration(milliseconds: 800));

      // Create mock user based on provider
      final user = UserProfile.newCustomer(
        email: 'user@${provider.toLowerCase()}.com',
        firstName: 'Social',
        lastName: 'User',
      );

      _updateUser(user.signIn());
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 User signed in with $provider: ${user.displayName}');
      }

    } catch (error) {
      _setError('Failed to sign in with $provider: $error');
      if (kDebugMode) {
        debugPrint('❌ Social sign in error: $error');
      }
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate sign out API call
      await Future.delayed(const Duration(milliseconds: 500));

      final guestUser = UserProfile.guest();
      _updateUser(guestUser);
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 User signed out, switched to guest');
      }

    } catch (error) {
      _setError('Failed to sign out: $error');
      if (kDebugMode) {
        debugPrint('❌ Sign out error: $error');
      }
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? country,
    String? postalCode,
  }) async {
    if (!isAuthenticated) {
      _setError('Please sign in to update your profile');
      return;
    }

    try {
      _setLoading(true);
      _setError(null);

      // Simulate profile update API call
      await Future.delayed(const Duration(milliseconds: 800));

      final updatedUser = _currentUser.updateProfile(
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        address: address,
        city: city,
        country: country,
        postalCode: postalCode,
      );

      _updateUser(updatedUser);
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 Profile updated for: ${updatedUser.displayName}');
      }

    } catch (error) {
      _setError('Failed to update profile: $error');
      if (kDebugMode) {
        debugPrint('❌ Profile update error: $error');
      }
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    if (!isAuthenticated) {
      _setError('Please sign in to update preferences');
      return;
    }

    try {
      _setLoading(true);
      _setError(null);

      // Simulate preferences update API call
      await Future.delayed(const Duration(milliseconds: 400));

      final updatedUser = _currentUser.updatePreferences(preferences);
      _updateUser(updatedUser);
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 Preferences updated for: ${updatedUser.displayName}');
      }

    } catch (error) {
      _setError('Failed to update preferences: $error');
      if (kDebugMode) {
        debugPrint('❌ Preferences update error: $error');
      }
    }
  }

  /// Toggle product in wishlist
  Future<void> toggleWishlist(String productId) async {
    if (!isAuthenticated) {
      _setError('Please sign in to manage your wishlist');
      return;
    }

    try {
      // Simulate wishlist API call
      await Future.delayed(const Duration(milliseconds: 300));

      final wasInWishlist = _currentUser.isInWishlist(productId);
      final updatedUser = _currentUser.toggleWishlist(productId);
      _updateUser(updatedUser);

      if (kDebugMode) {
        debugPrint('👤 Wishlist ${wasInWishlist ? 'removed' : 'added'}: $productId');
      }

    } catch (error) {
      _setError('Failed to update wishlist: $error');
      if (kDebugMode) {
        debugPrint('❌ Wishlist update error: $error');
      }
    }
  }

  /// Add product to wishlist
  Future<void> addToWishlist(String productId) async {
    if (!_currentUser.isInWishlist(productId)) {
      await toggleWishlist(productId);
    }
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    if (_currentUser.isInWishlist(productId)) {
      await toggleWishlist(productId);
    }
  }

  /// Add favorite category
  Future<void> addFavoriteCategory(ProductCategory category) async {
    if (!isAuthenticated) return;

    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final updatedUser = _currentUser.addFavoriteCategory(category);
      _updateUser(updatedUser);

      if (kDebugMode) {
        debugPrint('👤 Added favorite category: ${category.displayName}');
      }

    } catch (error) {
      _setError('Failed to add favorite category: $error');
    }
  }

  /// Remove favorite category
  Future<void> removeFavoriteCategory(ProductCategory category) async {
    if (!isAuthenticated) return;

    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final updatedUser = _currentUser.removeFavoriteCategory(category);
      _updateUser(updatedUser);

      if (kDebugMode) {
        debugPrint('👤 Removed favorite category: ${category.displayName}');
      }

    } catch (error) {
      _setError('Failed to remove favorite category: $error');
    }
  }

  /// Add order to history
  Future<void> addOrder(String orderId, double orderTotal) async {
    if (!isAuthenticated) return;

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedUser = _currentUser.addOrder(orderId, orderTotal);
      _updateUser(updatedUser);

      if (kDebugMode) {
        debugPrint('👤 Order added: $orderId (\$${orderTotal.toStringAsFixed(2)})');
      }

    } catch (error) {
      _setError('Failed to record order: $error');
    }
  }

  /// Award loyalty points
  Future<void> awardLoyaltyPoints(int points, {String? reason}) async {
    if (!isAuthenticated || points <= 0) return;

    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final updatedUser = _currentUser.awardLoyaltyPoints(points);
      _updateUser(updatedUser);

      if (kDebugMode) {
        debugPrint('👤 Awarded $points loyalty points${reason != null ? ' for $reason' : ''}');
      }

    } catch (error) {
      _setError('Failed to award loyalty points: $error');
    }
  }

  /// Redeem loyalty points
  Future<void> redeemLoyaltyPoints(int points, {String? purpose}) async {
    if (!isAuthenticated || points <= 0) return;

    if (points > _currentUser.loyaltyPoints) {
      _setError('Insufficient loyalty points');
      return;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final updatedUser = _currentUser.redeemLoyaltyPoints(points);
      _updateUser(updatedUser);

      if (kDebugMode) {
        debugPrint('👤 Redeemed $points loyalty points${purpose != null ? ' for $purpose' : ''}');
      }

    } catch (error) {
      _setError('Failed to redeem loyalty points: $error');
    }
  }

  /// Upgrade to premium
  Future<void> upgradeToPremium() async {
    if (!isAuthenticated) {
      _setError('Please sign in to upgrade to premium');
      return;
    }

    if (_currentUser.role == UserRole.premium) {
      _setError('You already have premium access');
      return;
    }

    try {
      _setLoading(true);
      _setError(null);

      // Simulate premium upgrade API call
      await Future.delayed(const Duration(milliseconds: 1000));

      final updatedUser = _currentUser.copyWith(role: UserRole.premium);
      _updateUser(updatedUser);
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 User upgraded to premium: ${updatedUser.displayName}');
      }

    } catch (error) {
      _setError('Failed to upgrade to premium: $error');
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    if (!isAuthenticated) return;

    try {
      _setLoading(true);
      _setError(null);

      // Simulate account deletion API call
      await Future.delayed(const Duration(milliseconds: 1500));

      final guestUser = UserProfile.guest();
      _updateUser(guestUser);
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('👤 Account deleted, switched to guest');
      }

    } catch (error) {
      _setError('Failed to delete account: $error');
    }
  }

  /// Business logic: Check if user is authenticated
  bool get isAuthenticated => _currentUser.isAuthenticated;

  /// Business logic: Check if user is guest
  bool get isGuest => _currentUser.isGuest;

  /// Business logic: Check if user has premium access
  bool get hasPremiumAccess => _currentUser.hasPremiumAccess;

  /// Business logic: Check if user is admin
  bool get isAdmin => _currentUser.isAdmin;

  /// Business logic: Check if user can make purchases
  bool get canPurchase => _currentUser.canPurchase;

  /// Business logic: Get user display name
  String get displayName => _currentUser.displayName;

  /// Business logic: Get user initials
  String get initials => _currentUser.initials;

  /// Business logic: Get user avatar URL
  String? get avatarUrl => _currentUser.avatarUrl;

  /// Business logic: Get user email
  String get email => _currentUser.email;

  /// Business logic: Get user role
  UserRole get role => _currentUser.role;

  /// Business logic: Get loyalty tier
  String get loyaltyTier => _currentUser.loyaltyTier;

  /// Business logic: Get loyalty points
  int get loyaltyPoints => _currentUser.loyaltyPoints;

  /// Business logic: Get favorite categories
  List<ProductCategory> get favoriteCategories => _currentUser.preferences.favoriteCategories;

  /// Business logic: Get user preferences
  UserPreferences get preferences => _currentUser.preferences;

  /// Business logic: Check if product is in wishlist
  bool isInWishlist(String productId) => _currentUser.isInWishlist(productId);

  /// Business logic: Get wishlist count
  int get wishlistCount => _currentUser.wishlistProductIds.length;

  /// Business logic: Get order count
  int get orderCount => _currentUser.orderHistory.length;

  /// Business logic: Get formatted total spent
  String get formattedTotalSpent => _currentUser.formattedTotalSpent;

  /// Business logic: Check if user is new member
  bool get isNewMember => _currentUser.isNewMember;

  /// Business logic: Get membership duration
  Duration? get membershipDuration => _currentUser.membershipDuration;

  /// Validate current user profile
  UserProfileValidationResult validateProfile() {
    return _currentUser.validate();
  }

  /// Save user data to local storage (placeholder)
  Future<void> saveToStorage() async {
    try {
      // In a real app, this would save to SharedPreferences, Hive, etc.
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (kDebugMode) {
        debugPrint('👤 User data saved to storage');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('❌ Failed to save user data: $error');
      }
    }
  }

  /// Load user data from local storage (placeholder)
  Future<void> loadFromStorage() async {
    try {
      // In a real app, this would load from SharedPreferences, Hive, etc.
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (kDebugMode) {
        debugPrint('👤 User data loaded from storage');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load user data: $error');
      }
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('👤 UserProfileProvider disposed');
    }
    super.dispose();
  }

  @override
  String toString() {
    return 'UserProfileProvider('
        'user: $displayName, '
        'authenticated: $isAuthenticated, '
        'role: ${role.displayName}, '
        'isLoading: $_isLoading'
        ')';
  }
}