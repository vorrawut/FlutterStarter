import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/navigation_repository.dart';
import '../../core/constants/app_routes.dart';

/// Use case for user authentication operations
/// Handles login, logout, registration with navigation integration
class AuthenticateUserUseCase {
  final AuthRepository _authRepository;
  final NavigationRepository _navigationRepository;

  const AuthenticateUserUseCase(
    this._authRepository,
    this._navigationRepository,
  );

  /// Login user with email and password
  Future<AuthenticationResult> login(
    String email,
    String password, {
    String? redirectRoute,
    Map<String, dynamic>? redirectExtra,
  }) async {
    try {
      // Validate input
      final validationResult = _validateLoginInput(email, password);
      if (!validationResult.isValid) {
        return AuthenticationResult.validationError(
          validationResult.errorMessage,
        );
      }

      // Track login attempt
      await _trackAuthEvent('login_attempt', {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Attempt login
      final authResult = await _authRepository.login(email, password);
      
      if (authResult.isSuccess && authResult.user != null) {
        // Track successful login
        await _trackAuthEvent('login_success', {
          'userId': authResult.user!.id,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Navigate to intended route or home
        final navigationResult = await _handlePostLoginNavigation(
          redirectRoute,
          redirectExtra,
        );

        return AuthenticationResult.success(
          authResult.user!,
          message: 'Login successful',
          navigationResult: navigationResult,
        );
      } else {
        // Track failed login
        await _trackAuthEvent('login_failure', {
          'email': email,
          'error': authResult.errorMessage,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      await _trackAuthEvent('login_error', {
        'email': email,
        'exception': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      return AuthenticationResult.error('Login failed: $e');
    }
  }

  /// Register new user account
  Future<AuthenticationResult> register(
    String email,
    String password,
    String firstName,
    String lastName, {
    String? phoneNumber,
  }) async {
    try {
      // Validate input
      final validationResult = _validateRegistrationInput(
        email,
        password,
        firstName,
        lastName,
      );
      if (!validationResult.isValid) {
        return AuthenticationResult.validationError(
          validationResult.errorMessage,
        );
      }

      // Check if email is available
      final isEmailAvailable = await _authRepository.isEmailAvailable(email);
      if (!isEmailAvailable) {
        return AuthenticationResult.emailAlreadyExists();
      }

      // Track registration attempt
      await _trackAuthEvent('register_attempt', {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Attempt registration
      final authResult = await _authRepository.register(
        email,
        password,
        firstName,
        lastName,
        phoneNumber: phoneNumber,
      );

      if (authResult.isSuccess && authResult.user != null) {
        // Track successful registration
        await _trackAuthEvent('register_success', {
          'userId': authResult.user!.id,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Navigate to home after registration
        final navigationResult = await _navigationRepository.navigateAndClearStack(
          AppRoutes.home,
        );

        return AuthenticationResult.success(
          authResult.user!,
          message: 'Registration successful',
          navigationResult: navigationResult,
        );
      } else {
        // Track failed registration
        await _trackAuthEvent('register_failure', {
          'email': email,
          'error': authResult.errorMessage,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      await _trackAuthEvent('register_error', {
        'email': email,
        'exception': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      return AuthenticationResult.error('Registration failed: $e');
    }
  }

  /// Logout current user
  Future<AuthenticationResult> logout() async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      
      // Track logout attempt
      await _trackAuthEvent('logout_attempt', {
        'userId': currentUser?.id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Perform logout
      final authResult = await _authRepository.logout();

      if (authResult.isSuccess) {
        // Track successful logout
        await _trackAuthEvent('logout_success', {
          'userId': currentUser?.id,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Navigate to home and clear stack
        final navigationResult = await _navigationRepository.navigateAndClearStack(
          AppRoutes.home,
        );

        return AuthenticationResult.successWithoutUser(
          message: 'Logout successful',
          navigationResult: navigationResult,
        );
      } else {
        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      return AuthenticationResult.error('Logout failed: $e');
    }
  }

  /// Send password reset email
  Future<AuthenticationResult> sendPasswordResetEmail(String email) async {
    try {
      if (!_isValidEmail(email)) {
        return AuthenticationResult.validationError('Invalid email address');
      }

      final authResult = await _authRepository.sendPasswordResetEmail(email);
      
      if (authResult.isSuccess) {
        await _trackAuthEvent('password_reset_email_sent', {
          'email': email,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return AuthenticationResult.successWithoutUser(
          message: 'Password reset email sent',
        );
      } else {
        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      return AuthenticationResult.error('Failed to send password reset email: $e');
    }
  }

  /// Reset password with token
  Future<AuthenticationResult> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      if (!_isValidPassword(newPassword)) {
        return AuthenticationResult.validationError(
          'Password must be at least 8 characters long',
        );
      }

      final authResult = await _authRepository.resetPassword(token, newPassword);
      
      if (authResult.isSuccess) {
        await _trackAuthEvent('password_reset_success', {
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Navigate to login after password reset
        final navigationResult = await _navigationRepository.navigateAndReplace(
          AppRoutes.login,
        );

        return AuthenticationResult.successWithoutUser(
          message: 'Password reset successful',
          navigationResult: navigationResult,
        );
      } else {
        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      return AuthenticationResult.error('Password reset failed: $e');
    }
  }

  /// Verify email address
  Future<AuthenticationResult> verifyEmail(String token) async {
    try {
      final authResult = await _authRepository.verifyEmail(token);
      
      if (authResult.isSuccess) {
        await _trackAuthEvent('email_verified', {
          'timestamp': DateTime.now().toIso8601String(),
        });

        return AuthenticationResult.successWithoutUser(
          message: 'Email verified successfully',
        );
      } else {
        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      return AuthenticationResult.error('Email verification failed: $e');
    }
  }

  /// Check current authentication status
  Future<AuthenticationStatusResult> checkAuthStatus() async {
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      final currentUser = await _authRepository.getCurrentUser();

      return AuthenticationStatusResult(
        isAuthenticated: isAuthenticated,
        user: currentUser,
      );
    } catch (e) {
      return AuthenticationStatusResult(
        isAuthenticated: false,
        user: null,
        error: 'Failed to check auth status: $e',
      );
    }
  }

  /// Update user profile
  Future<AuthenticationResult> updateProfile(User updatedUser) async {
    try {
      final authResult = await _authRepository.updateProfile(updatedUser);
      
      if (authResult.isSuccess && authResult.user != null) {
        await _trackAuthEvent('profile_updated', {
          'userId': authResult.user!.id,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return AuthenticationResult.success(
          authResult.user!,
          message: 'Profile updated successfully',
        );
      } else {
        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      return AuthenticationResult.error('Profile update failed: $e');
    }
  }

  /// Change user password
  Future<AuthenticationResult> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (!_isValidPassword(newPassword)) {
        return AuthenticationResult.validationError(
          'New password must be at least 8 characters long',
        );
      }

      if (currentPassword == newPassword) {
        return AuthenticationResult.validationError(
          'New password must be different from current password',
        );
      }

      final authResult = await _authRepository.changePassword(
        currentPassword,
        newPassword,
      );
      
      if (authResult.isSuccess) {
        await _trackAuthEvent('password_changed', {
          'timestamp': DateTime.now().toIso8601String(),
        });

        return AuthenticationResult.successWithoutUser(
          message: 'Password changed successfully',
        );
      } else {
        return AuthenticationResult.fromAuthResult(authResult);
      }
    } catch (e) {
      return AuthenticationResult.error('Password change failed: $e');
    }
  }

  // Private helper methods

  /// Handle navigation after successful login
  Future<NavigationResult> _handlePostLoginNavigation(
    String? redirectRoute,
    Map<String, dynamic>? redirectExtra,
  ) async {
    if (redirectRoute != null && redirectRoute.isNotEmpty) {
      return _navigationRepository.navigateAndReplace(
        redirectRoute,
        extra: redirectExtra,
      );
    }

    return _navigationRepository.navigateAndReplace(AppRoutes.home);
  }

  /// Validate login input
  InputValidationResult _validateLoginInput(String email, String password) {
    final errors = <String>[];

    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(email)) {
      errors.add('Invalid email format');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    }

    return InputValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate registration input
  InputValidationResult _validateRegistrationInput(
    String email,
    String password,
    String firstName,
    String lastName,
  ) {
    final errors = <String>[];

    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(email)) {
      errors.add('Invalid email format');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    } else if (!_isValidPassword(password)) {
      errors.add('Password must be at least 8 characters long');
    }

    if (firstName.isEmpty) {
      errors.add('First name is required');
    }

    if (lastName.isEmpty) {
      errors.add('Last name is required');
    }

    return InputValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  /// Track authentication events for analytics
  Future<void> _trackAuthEvent(
    String eventName,
    Map<String, dynamic> metadata,
  ) async {
    try {
      await _navigationRepository.trackNavigation(
        'auth_event',
        eventName,
        metadata: metadata,
      );
    } catch (e) {
      // Silently fail - don't break auth flow for analytics
    }
  }
}

/// Authentication result with navigation integration
class AuthenticationResult {
  final bool isSuccess;
  final User? user;
  final String? message;
  final String? errorMessage;
  final AuthResultType type;
  final NavigationResult? navigationResult;
  final Map<String, dynamic>? metadata;

  const AuthenticationResult._({
    required this.isSuccess,
    this.user,
    this.message,
    this.errorMessage,
    required this.type,
    this.navigationResult,
    this.metadata,
  });

  /// Success result with user
  factory AuthenticationResult.success(
    User user, {
    String? message,
    NavigationResult? navigationResult,
    Map<String, dynamic>? metadata,
  }) {
    return AuthenticationResult._(
      isSuccess: true,
      user: user,
      message: message,
      type: AuthResultType.success,
      navigationResult: navigationResult,
      metadata: metadata,
    );
  }

  /// Success result without user
  factory AuthenticationResult.successWithoutUser({
    String? message,
    NavigationResult? navigationResult,
    Map<String, dynamic>? metadata,
  }) {
    return AuthenticationResult._(
      isSuccess: true,
      message: message,
      type: AuthResultType.success,
      navigationResult: navigationResult,
      metadata: metadata,
    );
  }

  /// Error result
  factory AuthenticationResult.error(
    String errorMessage, {
    Map<String, dynamic>? metadata,
  }) {
    return AuthenticationResult._(
      isSuccess: false,
      errorMessage: errorMessage,
      type: AuthResultType.error,
      metadata: metadata,
    );
  }

  /// Validation error result
  factory AuthenticationResult.validationError(
    String errorMessage, {
    Map<String, dynamic>? metadata,
  }) {
    return AuthenticationResult._(
      isSuccess: false,
      errorMessage: errorMessage,
      type: AuthResultType.validationError,
      metadata: metadata,
    );
  }

  /// Invalid credentials result
  factory AuthenticationResult.invalidCredentials({
    Map<String, dynamic>? metadata,
  }) {
    return AuthenticationResult._(
      isSuccess: false,
      errorMessage: 'Invalid email or password',
      type: AuthResultType.invalidCredentials,
      metadata: metadata,
    );
  }

  /// Email already exists result
  factory AuthenticationResult.emailAlreadyExists({
    Map<String, dynamic>? metadata,
  }) {
    return AuthenticationResult._(
      isSuccess: false,
      errorMessage: 'An account with this email already exists',
      type: AuthResultType.emailAlreadyExists,
      metadata: metadata,
    );
  }

  /// Create from AuthResult
  factory AuthenticationResult.fromAuthResult(AuthResult authResult) {
    return AuthenticationResult._(
      isSuccess: authResult.isSuccess,
      user: authResult.user,
      errorMessage: authResult.errorMessage,
      type: _mapAuthResultType(authResult.type),
    );
  }

  bool get isError => !isSuccess;
  bool get hasUser => user != null;
  bool get hasNavigationResult => navigationResult != null;
  bool get isValidationError => type == AuthResultType.validationError;
  bool get isInvalidCredentials => type == AuthResultType.invalidCredentials;
  bool get isEmailAlreadyExists => type == AuthResultType.emailAlreadyExists;

  @override
  String toString() {
    return 'AuthenticationResult(isSuccess: $isSuccess, type: $type, message: $message, error: $errorMessage)';
  }

  static AuthResultType _mapAuthResultType(AuthResultType type) {
    switch (type) {
      case AuthResultType.success:
        return AuthResultType.success;
      case AuthResultType.invalidCredentials:
        return AuthResultType.invalidCredentials;
      case AuthResultType.emailAlreadyExists:
        return AuthResultType.emailAlreadyExists;
      case AuthResultType.emailNotVerified:
        return AuthResultType.emailNotVerified;
      case AuthResultType.accountDisabled:
        return AuthResultType.accountDisabled;
      case AuthResultType.networkError:
        return AuthResultType.networkError;
      case AuthResultType.timeout:
        return AuthResultType.timeout;
      case AuthResultType.tooManyAttempts:
        return AuthResultType.tooManyAttempts;
      default:
        return AuthResultType.error;
    }
  }
}

/// Authentication result type for use case operations
enum AuthResultType {
  success,
  error,
  validationError,
  invalidCredentials,
  emailAlreadyExists,
  emailNotVerified,
  accountDisabled,
  networkError,
  timeout,
  tooManyAttempts,
}

/// Authentication status result
class AuthenticationStatusResult {
  final bool isAuthenticated;
  final User? user;
  final String? error;

  const AuthenticationStatusResult({
    required this.isAuthenticated,
    this.user,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasUser => user != null;

  @override
  String toString() {
    return 'AuthenticationStatusResult(isAuthenticated: $isAuthenticated, hasUser: $hasUser, error: $error)';
  }
}

/// Input validation result
class InputValidationResult {
  final bool isValid;
  final List<String> errors;

  const InputValidationResult({
    required this.isValid,
    required this.errors,
  });

  String get errorMessage => errors.join(', ');

  @override
  String toString() {
    return 'InputValidationResult(isValid: $isValid, errors: $errors)';
  }
}