import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';
import '../../core/errors/auth_exceptions.dart';

// Auth state provider - watches Firebase Auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Authentication status provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

// Email verification status provider
final isEmailVerifiedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.emailVerified ?? false;
});

// Authentication actions provider
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref);
});

class AuthActions {
  final Ref _ref;
  
  AuthActions(this._ref);

  /// Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await AuthService.signInWithEmailPassword(email, password);
      return credential.user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  /// Create account with email and password
  Future<User?> createAccount(
    String email, 
    String password, {
    String? displayName,
  }) async {
    try {
      final credential = await AuthService.createUserWithEmailPassword(
        email, 
        password,
        displayName: displayName,
      );
      return credential.user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Account creation failed: ${e.toString()}');
    }
  }

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final credential = await AuthService.signInWithGoogle();
      return credential.user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }

  /// Sign in with Apple
  Future<User?> signInWithApple() async {
    try {
      final credential = await AuthService.signInWithApple();
      return credential.user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Apple sign-in failed: ${e.toString()}');
    }
  }

  /// Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      final credential = await AuthService.signInAnonymously();
      return credential.user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Anonymous sign-in failed: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await AuthService.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await AuthService.resetPassword(email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await AuthService.sendEmailVerification();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Email verification failed: ${e.toString()}');
    }
  }

  /// Reload user
  Future<void> reloadUser() async {
    try {
      await AuthService.reloadUser();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('User reload failed: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await AuthService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Profile update failed: ${e.toString()}');
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await AuthService.deleteAccount();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Account deletion failed: ${e.toString()}');
    }
  }

  /// Get authentication status details
  Map<String, dynamic> getAuthStatus() {
    return AuthService.getAuthStatus();
  }
}

/// Authentication state notifier for complex auth flows
class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthStateNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    AuthService.authStateChanges.listen(
      (user) {
        state = AsyncValue.data(user);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  /// Sign in with email and password
  Future<void> signInWithEmailPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final credential = await AuthService.signInWithEmailPassword(email, password);
      state = AsyncValue.data(credential.user);
    } on AuthException catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } catch (e, stack) {
      state = AsyncValue.error(
        AuthException('Sign in failed: ${e.toString()}'),
        stack,
      );
    }
  }

  /// Create account
  Future<void> createAccount(
    String email, 
    String password, {
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final credential = await AuthService.createUserWithEmailPassword(
        email, 
        password,
        displayName: displayName,
      );
      state = AsyncValue.data(credential.user);
    } on AuthException catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } catch (e, stack) {
      state = AsyncValue.error(
        AuthException('Account creation failed: ${e.toString()}'),
        stack,
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await AuthService.signOut();
      state = const AsyncValue.data(null);
    } on AuthException catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } catch (e, stack) {
      state = AsyncValue.error(
        AuthException('Sign out failed: ${e.toString()}'),
        stack,
      );
    }
  }
}

/// Provider for auth state notifier (for complex auth flows)
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  return AuthStateNotifier();
});

/// Convenience providers for auth-related UI states
final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.hasError ? authState.error.toString() : null;
});

/// Provider for checking if current user needs email verification
final needsEmailVerificationProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null && !user.emailVerified;
});

/// Provider for getting user display name
final userDisplayNameProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.displayName ?? user?.email?.split('@').first ?? 'User';
});

/// Provider for getting user photo URL
final userPhotoURLProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.photoURL;
});

/// Provider for checking if user is anonymous
final isAnonymousUserProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isAnonymous ?? false;
});
