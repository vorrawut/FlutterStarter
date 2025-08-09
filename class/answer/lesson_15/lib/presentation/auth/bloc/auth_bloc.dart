import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/services/security_service.dart';
import '../../../core/services/analytics_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthInitializationRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;
  
  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  
  @override
  List<Object> get props => [email, password, rememberMe];
}

class AuthRegistrationRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  
  const AuthRegistrationRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
  
  @override
  List<Object> get props => [email, password, firstName, lastName];
}

class AuthBiometricRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthTokenRefreshRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  
  const AuthPasswordResetRequested(this.email);
  
  @override
  List<Object> get props => [email];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final String? message;
  
  const AuthLoading({this.message});
  
  @override
  List<Object?> get props => [message];
}

class AuthAuthenticated extends AuthState {
  final User user;
  final DateTime authenticatedAt;
  final String method;
  
  const AuthAuthenticated({
    required this.user,
    required this.authenticatedAt,
    required this.method,
  });
  
  @override
  List<Object> get props => [user, authenticatedAt, method];
}

class AuthUnauthenticated extends AuthState {
  final String? reason;
  
  const AuthUnauthenticated({this.reason});
  
  @override
  List<Object?> get props => [reason];
}

class AuthError extends AuthState {
  final String message;
  final String type;
  final DateTime timestamp;
  
  const AuthError({
    required this.message,
    required this.type,
    required this.timestamp,
  });
  
  @override
  List<Object> get props => [message, type, timestamp];
}

class AuthPasswordResetEmailSent extends AuthState {
  final String email;
  
  const AuthPasswordResetEmailSent(this.email);
  
  @override
  List<Object> get props => [email];
}

// Bloc Implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final BiometricService _biometricService;
  final SecurityService _securityService;
  final AnalyticsService _analyticsService;
  
  Timer? _tokenRefreshTimer;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required BiometricService biometricService,
    required SecurityService securityService,
    required AnalyticsService analyticsService,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _registerUseCase = registerUseCase,
        _biometricService = biometricService,
        _securityService = securityService,
        _analyticsService = analyticsService,
        super(AuthInitial()) {
    
    // Register event handlers
    on<AuthInitializationRequested>(_onInitializationRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegistrationRequested>(_onRegistrationRequested);
    on<AuthBiometricRequested>(_onBiometricRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    
    // Initialize authentication state
    add(AuthInitializationRequested());
  }

  Future<void> _onInitializationRequested(
    AuthInitializationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Initializing...'));
    
    try {
      // Check if user is already authenticated
      final storedUser = await _securityService.getStoredUser();
      final isTokenValid = await _securityService.isTokenValid();
      
      if (storedUser != null && isTokenValid) {
        emit(AuthAuthenticated(
          user: storedUser,
          authenticatedAt: DateTime.now(),
          method: 'stored_credentials',
        ));
        
        await _analyticsService.trackEvent('auth_restored', {
          'user_id': storedUser.id,
          'method': 'stored_credentials',
        });
        
        _scheduleTokenRefresh();
        return;
      }
      
      emit(const AuthUnauthenticated());
    } catch (error) {
      log('Auth initialization error: $error');
      emit(AuthError(
        message: 'Failed to initialize authentication',
        type: 'initialization_error',
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Signing in...'));
    
    try {
      final result = await _loginUseCase.execute(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      );
      
      emit(AuthAuthenticated(
        user: result.user,
        authenticatedAt: DateTime.now(),
        method: 'email_password',
      ));
      
      await _analyticsService.trackEvent('login_success', {
        'user_id': result.user.id,
        'method': 'email_password',
        'remember_me': event.rememberMe,
      });
      
      _scheduleTokenRefresh();
      
    } catch (error) {
      log('Login error: $error');
      
      await _analyticsService.trackEvent('login_failure', {
        'email': event.email,
        'error': error.toString(),
        'method': 'email_password',
      });
      
      emit(AuthError(
        message: _getErrorMessage(error),
        type: 'login_error',
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onRegistrationRequested(
    AuthRegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Creating account...'));
    
    try {
      final result = await _registerUseCase.execute(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      );
      
      emit(AuthAuthenticated(
        user: result.user,
        authenticatedAt: DateTime.now(),
        method: 'registration',
      ));
      
      await _analyticsService.trackEvent('registration_success', {
        'user_id': result.user.id,
        'method': 'email_password',
      });
      
      _scheduleTokenRefresh();
      
    } catch (error) {
      log('Registration error: $error');
      
      await _analyticsService.trackEvent('registration_failure', {
        'email': event.email,
        'error': error.toString(),
      });
      
      emit(AuthError(
        message: _getErrorMessage(error),
        type: 'registration_error',
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onBiometricRequested(
    AuthBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Verifying biometric...'));
    
    try {
      final isAvailable = await _biometricService.isAvailable();
      if (!isAvailable) {
        emit(const AuthError(
          message: 'Biometric authentication is not available on this device',
          type: 'biometric_not_available',
          timestamp: DateTime.now(),
        ));
        return;
      }
      
      final isAuthenticated = await _biometricService.authenticate(
        localizedFallbackTitle: 'Use PIN',
        reason: 'Authenticate to access your account',
      );
      
      if (isAuthenticated) {
        final storedUser = await _securityService.getStoredUser();
        
        if (storedUser != null) {
          emit(AuthAuthenticated(
            user: storedUser,
            authenticatedAt: DateTime.now(),
            method: 'biometric',
          ));
          
          await _analyticsService.trackEvent('login_success', {
            'user_id': storedUser.id,
            'method': 'biometric',
          });
          
          _scheduleTokenRefresh();
        } else {
          emit(const AuthError(
            message: 'No stored credentials found',
            type: 'no_stored_credentials',
            timestamp: DateTime.now(),
          ));
        }
      } else {
        emit(const AuthError(
          message: 'Biometric authentication failed',
          type: 'biometric_failed',
          timestamp: DateTime.now(),
        ));
      }
    } catch (error) {
      log('Biometric auth error: $error');
      emit(AuthError(
        message: 'Biometric authentication error',
        type: 'biometric_error',
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Signing out...'));
    
    try {
      String? userId;
      if (state is AuthAuthenticated) {
        userId = (state as AuthAuthenticated).user.id;
      }
      
      await _logoutUseCase.execute();
      _cancelTokenRefresh();
      
      emit(const AuthUnauthenticated(reason: 'User logged out'));
      
      if (userId != null) {
        await _analyticsService.trackEvent('logout_success', {
          'user_id': userId,
        });
      }
    } catch (error) {
      log('Logout error: $error');
      emit(AuthError(
        message: 'Failed to logout properly',
        type: 'logout_error',
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;
    
    try {
      final refreshed = await _securityService.refreshToken();
      
      if (refreshed) {
        _scheduleTokenRefresh();
      } else {
        // Token refresh failed, force logout
        add(AuthLogoutRequested());
      }
    } catch (error) {
      log('Token refresh error: $error');
      // Force logout on token refresh failure
      add(AuthLogoutRequested());
    }
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Sending reset email...'));
    
    try {
      // Simulate password reset request
      await Future.delayed(const Duration(seconds: 2));
      
      emit(AuthPasswordResetEmailSent(event.email));
      
      await _analyticsService.trackEvent('password_reset_requested', {
        'email': event.email,
      });
    } catch (error) {
      log('Password reset error: $error');
      emit(AuthError(
        message: 'Failed to send password reset email',
        type: 'password_reset_error',
        timestamp: DateTime.now(),
      ));
    }
  }

  void _scheduleTokenRefresh() {
    _cancelTokenRefresh();
    
    // Schedule token refresh for 50 minutes (assuming 1-hour tokens)
    _tokenRefreshTimer = Timer(const Duration(minutes: 50), () {
      add(AuthTokenRefreshRequested());
    });
  }

  void _cancelTokenRefresh() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = null;
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('invalid_credentials')) {
      return 'Invalid email or password';
    } else if (error.toString().contains('network')) {
      return 'Network error. Please check your connection';
    } else if (error.toString().contains('user_exists')) {
      return 'An account with this email already exists';
    }
    return 'An unexpected error occurred';
  }

  @override
  Future<void> close() {
    _cancelTokenRefresh();
    return super.close();
  }
}
