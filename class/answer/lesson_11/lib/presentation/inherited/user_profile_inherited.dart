/// User profile state management with InheritedWidget
/// 
/// This file demonstrates user authentication and profile management
/// using pure InheritedWidget patterns before Provider simplification.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/models/user_profile.dart';
import '../../core/models/product.dart';

/// User profile state management using pure InheritedWidget
/// 
/// Demonstrates traditional approach to managing user authentication
/// and profile state across the widget tree.
class UserProfileInheritedWidget extends InheritedWidget {
  /// Creates a user profile inherited widget
  const UserProfileInheritedWidget({
    super.key,
    required this.userData,
    required super.child,
  });

  /// User state data
  final UserProfileData userData;

  /// Access the user profile from context
  static UserProfileData? of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<UserProfileInheritedWidget>();
    return widget?.userData;
  }

  /// Access the user profile from context (throws if not found)
  static UserProfileData ofRequired(BuildContext context) {
    final userData = of(context);
    if (userData == null) {
      throw FlutterError(
        'UserProfileInheritedWidget.ofRequired() called with a context that does not '
        'contain a UserProfileInheritedWidget.\n'
        'No UserProfileInheritedWidget ancestor could be found starting from the context '
        'that was passed to UserProfileInheritedWidget.ofRequired().',
      );
    }
    return userData;
  }

  @override
  bool updateShouldNotify(UserProfileInheritedWidget oldWidget) {
    // Only notify dependents if the user data has actually changed
    return userData != oldWidget.userData;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<UserProfileData>('userData', userData));
  }
}

/// Immutable user profile data for InheritedWidget
/// 
/// Contains the current user state with immutable update patterns
/// for predictable authentication and profile management.
@immutable
class UserProfileData {
  /// Creates user profile data
  const UserProfileData({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdated,
  });

  /// Current user profile (null if not authenticated)
  final UserProfile? currentUser;

  /// Whether user operations are in progress
  final bool isLoading;

  /// Error message if any operation failed
  final String? errorMessage;

  /// When the user data was last updated
  final DateTime? lastUpdated;

  /// Create a copy with modified fields
  UserProfileData copyWith({
    UserProfile? currentUser,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return UserProfileData(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Sign in user
  UserProfileData signInUser(UserProfile user) {
    return copyWith(
      currentUser: user.signIn(),
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Sign out user
  UserProfileData signOutUser() {
    return copyWith(
      currentUser: currentUser?.signOut(),
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Update user profile
  UserProfileData updateUser(UserProfile updatedUser) {
    return copyWith(
      currentUser: updatedUser,
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Update user preferences
  UserProfileData updatePreferences(UserPreferences preferences) {
    if (currentUser == null) return this;
    
    return copyWith(
      currentUser: currentUser!.updatePreferences(preferences),
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Add product to wishlist
  UserProfileData addToWishlist(String productId) {
    if (currentUser == null) return this;
    
    return copyWith(
      currentUser: currentUser!.addToWishlist(productId),
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Remove product from wishlist
  UserProfileData removeFromWishlist(String productId) {
    if (currentUser == null) return this;
    
    return copyWith(
      currentUser: currentUser!.removeFromWishlist(productId),
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Toggle product in wishlist
  UserProfileData toggleWishlist(String productId) {
    if (currentUser == null) return this;
    
    return copyWith(
      currentUser: currentUser!.toggleWishlist(productId),
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Set loading state
  UserProfileData setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  /// Set error message
  UserProfileData setError(String? error) {
    return copyWith(
      errorMessage: error,
      isLoading: false,
    );
  }

  /// Business logic: Check if user is authenticated
  bool get isAuthenticated => currentUser != null && currentUser!.isAuthenticated;

  /// Business logic: Check if user is guest
  bool get isGuest => currentUser == null || currentUser!.isGuest;

  /// Business logic: Check if user has premium access
  bool get hasPremiumAccess => currentUser?.hasPremiumAccess ?? false;

  /// Business logic: Check if user is admin
  bool get isAdmin => currentUser?.isAdmin ?? false;

  /// Business logic: Check if user can make purchases
  bool get canPurchase => currentUser?.canPurchase ?? false;

  /// Business logic: Get user display name
  String get displayName => currentUser?.displayName ?? 'Guest';

  /// Business logic: Get user initials
  String get initials => currentUser?.initials ?? 'G';

  /// Business logic: Get user avatar URL
  String? get avatarUrl => currentUser?.avatarUrl;

  /// Business logic: Get user email
  String get email => currentUser?.email ?? '';

  /// Business logic: Get user role
  UserRole get role => currentUser?.role ?? UserRole.guest;

  /// Business logic: Get loyalty tier
  String get loyaltyTier => currentUser?.loyaltyTier ?? 'Bronze';

  /// Business logic: Get loyalty points
  int get loyaltyPoints => currentUser?.loyaltyPoints ?? 0;

  /// Business logic: Get favorite categories
  List<ProductCategory> get favoriteCategories => currentUser?.preferences.favoriteCategories ?? [];

  /// Business logic: Get user preferences
  UserPreferences get preferences => currentUser?.preferences ?? const UserPreferences();

  /// Business logic: Check if product is in wishlist
  bool isInWishlist(String productId) => currentUser?.isInWishlist(productId) ?? false;

  /// Business logic: Get wishlist count
  int get wishlistCount => currentUser?.wishlistProductIds.length ?? 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileData &&
        other.currentUser == currentUser &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentUser,
      isLoading,
      errorMessage,
      lastUpdated,
    );
  }

  @override
  String toString() {
    return 'UserProfileData('
        'user: $displayName, '
        'authenticated: $isAuthenticated, '
        'role: ${role.displayName}, '
        'isLoading: $isLoading'
        ')';
  }
}

/// StatefulWidget wrapper for managing user profile state with InheritedWidget
/// 
/// Demonstrates how to manage user authentication and profile state
/// using traditional Flutter patterns before Provider.
class UserProfileManager extends StatefulWidget {
  /// Creates a user profile manager
  const UserProfileManager({
    super.key,
    required this.child,
    this.onUserChanged,
  });

  /// Child widget that will have access to user state
  final Widget child;

  /// Callback when user changes
  final void Function(UserProfileData userData)? onUserChanged;

  @override
  State<UserProfileManager> createState() => UserProfileManagerState();
}

/// State class for user profile manager
/// 
/// Manages the actual user state and provides methods for user operations.
class UserProfileManagerState extends State<UserProfileManager> {
  /// Current user data
  UserProfileData _userData = const UserProfileData();

  /// Get current user data
  UserProfileData get userData => _userData;

  @override
  void initState() {
    super.initState();
    // Initialize with guest user
    _userData = UserProfileData(currentUser: UserProfile.guest());
  }

  /// Update user data and notify listeners
  void _updateUserData(UserProfileData newUserData) {
    if (_userData != newUserData) {
      setState(() {
        _userData = newUserData;
      });
      widget.onUserChanged?.call(_userData);
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    // Set loading state
    _updateUserData(_userData.setLoading(true));

    try {
      // Simulate authentication API call
      await Future.delayed(const Duration(milliseconds: 1000));

      // Validate credentials (mock validation)
      if (email.isEmpty || password.isEmpty) {
        _updateUserData(_userData.setError('Email and password are required'));
        return;
      }

      if (!email.contains('@')) {
        _updateUserData(_userData.setError('Please enter a valid email address'));
        return;
      }

      if (password.length < 6) {
        _updateUserData(_userData.setError('Password must be at least 6 characters'));
        return;
      }

      // Create user profile (mock user data)
      final user = UserProfile.newCustomer(
        email: email,
        firstName: email.split('@').first.split('.').first,
        lastName: email.split('@').first.split('.').length > 1 ? email.split('@').first.split('.').last : null,
      );

      // Sign in user
      _updateUserData(_userData.signInUser(user).setLoading(false));

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${user.displayName}!'),
            duration: const Duration(seconds: 3),
          ),
        );
      }

    } catch (error) {
      _updateUserData(_userData.setError('Failed to sign in: $error'));
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(String email, String password, String? firstName, String? lastName) async {
    // Set loading state
    _updateUserData(_userData.setLoading(true));

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(milliseconds: 1200));

      // Validate input
      if (email.isEmpty || password.isEmpty) {
        _updateUserData(_userData.setError('Email and password are required'));
        return;
      }

      if (!email.contains('@')) {
        _updateUserData(_userData.setError('Please enter a valid email address'));
        return;
      }

      if (password.length < 6) {
        _updateUserData(_userData.setError('Password must be at least 6 characters'));
        return;
      }

      // Create new user profile
      final user = UserProfile.newCustomer(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      // Sign in user
      _updateUserData(_userData.signInUser(user).setLoading(false));

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to the app, ${user.displayName}!'),
            duration: const Duration(seconds: 3),
          ),
        );
      }

    } catch (error) {
      _updateUserData(_userData.setError('Failed to create account: $error'));
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    // Set loading state
    _updateUserData(_userData.setLoading(true));

    try {
      // Simulate sign out API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Sign out and switch to guest
      _updateUserData(
        UserProfileData(currentUser: UserProfile.guest())
            .setLoading(false),
      );

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have been signed out'),
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (error) {
      _updateUserData(_userData.setError('Failed to sign out: $error'));
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
    if (_userData.currentUser == null) return;

    // Set loading state
    _updateUserData(_userData.setLoading(true));

    try {
      // Simulate profile update API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Update profile
      final updatedUser = _userData.currentUser!.updateProfile(
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

      _updateUserData(_userData.updateUser(updatedUser).setLoading(false));

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (error) {
      _updateUserData(_userData.setError('Failed to update profile: $error'));
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    if (_userData.currentUser == null) return;

    // Set loading state
    _updateUserData(_userData.setLoading(true));

    try {
      // Simulate preferences update API call
      await Future.delayed(const Duration(milliseconds: 400));

      // Update preferences
      _updateUserData(_userData.updatePreferences(preferences).setLoading(false));

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences updated'),
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (error) {
      _updateUserData(_userData.setError('Failed to update preferences: $error'));
    }
  }

  /// Toggle product in wishlist
  Future<void> toggleWishlist(String productId) async {
    if (_userData.currentUser == null) {
      _updateUserData(_userData.setError('Please sign in to manage your wishlist'));
      return;
    }

    try {
      // Simulate wishlist API call
      await Future.delayed(const Duration(milliseconds: 300));

      // Toggle wishlist
      final wasInWishlist = _userData.isInWishlist(productId);
      _updateUserData(_userData.toggleWishlist(productId));

      // Show feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(wasInWishlist ? 'Removed from wishlist' : 'Added to wishlist'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

    } catch (error) {
      _updateUserData(_userData.setError('Failed to update wishlist: $error'));
    }
  }

  /// Add favorite category
  Future<void> addFavoriteCategory(ProductCategory category) async {
    if (_userData.currentUser == null) return;

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 200));

      // Add favorite category
      final updatedUser = _userData.currentUser!.addFavoriteCategory(category);
      _updateUserData(_userData.updateUser(updatedUser));

    } catch (error) {
      _updateUserData(_userData.setError('Failed to add favorite category: $error'));
    }
  }

  /// Remove favorite category
  Future<void> removeFavoriteCategory(ProductCategory category) async {
    if (_userData.currentUser == null) return;

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 200));

      // Remove favorite category
      final updatedUser = _userData.currentUser!.removeFavoriteCategory(category);
      _updateUserData(_userData.updateUser(updatedUser));

    } catch (error) {
      _updateUserData(_userData.setError('Failed to remove favorite category: $error'));
    }
  }

  /// Clear error state
  void clearError() {
    _updateUserData(_userData.setError(null));
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileInheritedWidget(
      userData: _userData,
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<UserProfileData>('userData', _userData));
  }
}

/// Static helper methods for accessing user operations
/// 
/// Provides convenient static methods for accessing user operations
/// from anywhere in the widget tree.
class UserProfileInheritedHelper {
  /// Private constructor
  UserProfileInheritedHelper._();

  /// Get user data from context
  static UserProfileData? getUserData(BuildContext context) {
    return UserProfileInheritedWidget.of(context);
  }

  /// Get user manager state from context
  static UserProfileManagerState? getUserManager(BuildContext context) {
    return context.findAncestorStateOfType<UserProfileManagerState>();
  }

  /// Sign in with email and password
  static Future<void> signInWithEmail(BuildContext context, String email, String password) async {
    final manager = getUserManager(context);
    if (manager != null) {
      await manager.signInWithEmail(email, password);
    }
  }

  /// Sign up with email and password
  static Future<void> signUpWithEmail(
    BuildContext context,
    String email,
    String password, [
    String? firstName,
    String? lastName,
  ]) async {
    final manager = getUserManager(context);
    if (manager != null) {
      await manager.signUpWithEmail(email, password, firstName, lastName);
    }
  }

  /// Sign out current user
  static Future<void> signOut(BuildContext context) async {
    final manager = getUserManager(context);
    if (manager != null) {
      await manager.signOut();
    }
  }

  /// Toggle product in wishlist
  static Future<void> toggleWishlist(BuildContext context, String productId) async {
    final manager = getUserManager(context);
    if (manager != null) {
      await manager.toggleWishlist(productId);
    }
  }

  /// Update user preferences
  static Future<void> updatePreferences(BuildContext context, UserPreferences preferences) async {
    final manager = getUserManager(context);
    if (manager != null) {
      await manager.updatePreferences(preferences);
    }
  }

  /// Clear error state
  static void clearError(BuildContext context) {
    final manager = getUserManager(context);
    manager?.clearError();
  }
}

/// Widget that rebuilds when user data changes
/// 
/// Provides a convenient way to rebuild widgets when user state changes,
/// similar to Consumer in Provider but for InheritedWidget.
class UserProfileBuilder extends StatelessWidget {
  /// Creates a user profile builder
  const UserProfileBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  /// Builder function that receives user data
  final Widget Function(BuildContext context, UserProfileData? userData, Widget? child) builder;

  /// Optional child widget that doesn't need to rebuild
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final userData = UserProfileInheritedWidget.of(context);
    return builder(context, userData, child);
  }
}