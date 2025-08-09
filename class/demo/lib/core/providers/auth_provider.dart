import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/demo_user.dart';
import '../storage/storage_service.dart';

/// Authentication State
/// 
/// Demonstrates:
/// - State modeling with sealed classes/unions (modern Dart patterns)
/// - Authentication flow management
/// - Error handling patterns

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  
  final DemoUser user;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthAuthenticated && other.user == user;
  }
  
  @override
  int get hashCode => user.hashCode;
}

class AuthError extends AuthState {
  const AuthError(this.message);
  
  final String message;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthError && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Authentication Notifier
/// 
/// Demonstrates:
/// - Complex state management (Lesson 13: Riverpod)
/// - Async operations with proper error handling
/// - Persistent authentication state
/// - Demo/bypass functionality for development

const String _kAuthUserKey = 'auth_user';
const String _kIsAuthenticatedKey = 'is_authenticated';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthInitial()) {
    _loadAuthState();
  }

  /// Load authentication state from storage
  Future<void> _loadAuthState() async {
    try {
      state = const AuthLoading();
      
      final isAuthenticated = await StorageService.read(_kIsAuthenticatedKey);
      if (isAuthenticated == 'true') {
        final userJson = await StorageService.read(_kAuthUserKey);
        if (userJson != null) {
          // For demo purposes, we'll recreate user from stored role
          final userData = Map<String, dynamic>.from(
            await StorageService.read(_kAuthUserKey) ?? {},
          );
          
          if (userData.isNotEmpty) {
            final user = DemoUser.fromJson(userData);
            state = AuthAuthenticated(user);
            return;
          }
        }
      }
      
      state = const AuthUnauthenticated();
    } catch (e) {
      state = AuthError('Failed to load authentication state: $e');
    }
  }

  /// Demo login - bypass with predefined users
  Future<void> loginDemo(UserRole role) async {
    try {
      state = const AuthLoading();
      
      // Simulate network delay for realistic UX
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final user = DemoUsers.getUserByRole(role);
      if (user != null) {
        await _saveAuthState(user);
        state = AuthAuthenticated(user);
        debugPrint('Demo login successful for ${user.fullName} (${user.role.displayName})');
      } else {
        state = const AuthError('Demo user not found');
      }
    } catch (e) {
      state = AuthError('Demo login failed: $e');
    }
  }

  /// Traditional email/password login (for demo purposes)
  Future<void> login(String email, String password) async {
    try {
      state = const AuthLoading();
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // For demo, accept any email/password and default to student
      final user = DemoUsers.student.copyWith(
        email: email,
        firstName: email.split('@').first.split('.').first,
        lastName: email.split('@').first.split('.').length > 1 
            ? email.split('@').first.split('.').last 
            : 'User',
      );
      
      await _saveAuthState(user);
      state = AuthAuthenticated(user);
      debugPrint('Login successful for $email');
    } catch (e) {
      state = AuthError('Login failed: $e');
    }
  }

  /// User registration (for demo purposes)
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    UserRole role = UserRole.student,
  }) async {
    try {
      state = const AuthLoading();
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 2500));
      
      // Create new demo user
      final user = DemoUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        avatar: _getRandomAvatar(role),
        joinDate: DateTime.now(),
        bio: 'New Flutter learner!',
      );
      
      await _saveAuthState(user);
      state = AuthAuthenticated(user);
      debugPrint('Registration successful for $email');
    } catch (e) {
      state = AuthError('Registration failed: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await StorageService.delete(_kAuthUserKey);
      await StorageService.delete(_kIsAuthenticatedKey);
      state = const AuthUnauthenticated();
      debugPrint('Logout successful');
    } catch (e) {
      state = AuthError('Logout failed: $e');
    }
  }

  /// Update user profile
  Future<void> updateProfile(DemoUser updatedUser) async {
    try {
      if (state is AuthAuthenticated) {
        await _saveAuthState(updatedUser);
        state = AuthAuthenticated(updatedUser);
        debugPrint('Profile updated for ${updatedUser.fullName}');
      }
    } catch (e) {
      state = AuthError('Profile update failed: $e');
    }
  }

  /// Save authentication state to storage
  Future<void> _saveAuthState(DemoUser user) async {
    await StorageService.write(_kAuthUserKey, user.toJson());
    await StorageService.write(_kIsAuthenticatedKey, 'true');
  }

  /// Get random avatar for role
  String _getRandomAvatar(UserRole role) {
    switch (role) {
      case UserRole.student:
        return ['👨‍🎓', '👩‍🎓', '🧑‍🎓'][DateTime.now().second % 3];
      case UserRole.developer:
        return ['👨‍💻', '👩‍💻', '🧑‍💻'][DateTime.now().second % 3];
      case UserRole.instructor:
        return ['👨‍🏫', '👩‍🏫', '🧑‍🏫'][DateTime.now().second % 3];
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state is AuthAuthenticated;

  /// Get current user (null if not authenticated)
  DemoUser? get currentUser {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user;
    }
    return null;
  }
}

/// Main auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

/// Convenience providers for common auth checks
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState is AuthAuthenticated;
});

final currentUserProvider = Provider<DemoUser?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) {
    return authState.user;
  }
  return null;
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState is AuthLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthError) {
    return authState.message;
  }
  return null;
});
