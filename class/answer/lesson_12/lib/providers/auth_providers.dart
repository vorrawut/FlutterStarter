import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock user class for demonstration
class User {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });
}

// Mock authentication notifier
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      // Simulate checking for existing authentication
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, auto-login with a mock user
      final user = User(
        id: 'demo-user-123',
        name: 'Demo User',
        email: 'demo@todomaster.com',
      );
      
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      // Simulate login API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }
      
      final user = User(
        id: 'user-${email.hashCode}',
        name: email.split('@').first,
        email: email,
      );
      
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    
    try {
      // Simulate logout
      await Future.delayed(const Duration(milliseconds: 500));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('All fields are required');
      }
      
      final user = User(
        id: 'user-${email.hashCode}',
        name: name,
        email: email,
      );
      
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Auth providers
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});

// Computed providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull;
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.id;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});