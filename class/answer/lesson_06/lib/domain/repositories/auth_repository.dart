import '../entities/user.dart';

/// Authentication repository interface defining auth operations
/// Following clean architecture principles - domain layer defines contracts
abstract class AuthRepository {
  /// Get current authenticated user
  Future<User?> getCurrentUser();

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated();

  /// Login with email and password
  Future<AuthResult> login(String email, String password);

  /// Register new user account
  Future<AuthResult> register(
    String email,
    String password,
    String firstName,
    String lastName, {
    String? phoneNumber,
  });

  /// Logout current user
  Future<AuthResult> logout();

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email);

  /// Reset password with token
  Future<AuthResult> resetPassword(
    String token,
    String newPassword,
  );

  /// Verify email address
  Future<AuthResult> verifyEmail(String token);

  /// Resend email verification
  Future<AuthResult> resendEmailVerification();

  /// Update user profile
  Future<AuthResult> updateProfile(User updatedUser);

  /// Change password
  Future<AuthResult> changePassword(
    String currentPassword,
    String newPassword,
  );

  /// Delete user account
  Future<AuthResult> deleteAccount(String password);

  /// Refresh authentication token
  Future<AuthResult> refreshToken();

  /// Get user session information
  Future<UserSession?> getUserSession();

  /// Check if email is available for registration
  Future<bool> isEmailAvailable(String email);

  /// Get user by ID (admin function)
  Future<User?> getUserById(String userId);

  /// Stream of authentication state changes
  Stream<AuthState> get authStateChanges;

  /// Stream of current user changes
  Stream<User?> get userChanges;
}

/// Authentication result class for operation outcomes
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;
  final AuthResultType type;
  final Map<String, dynamic>? metadata;

  const AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    required this.type,
    this.metadata,
  });

  /// Success result with user
  factory AuthResult.success(User user, {Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      type: AuthResultType.success,
      metadata: metadata,
    );
  }

  /// Success result without user (e.g., logout, password reset email sent)
  factory AuthResult.successWithoutUser({
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return AuthResult._(
      isSuccess: true,
      type: AuthResultType.success,
      metadata: metadata,
    );
  }

  /// Error result
  factory AuthResult.error(String message, {Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: message,
      type: AuthResultType.error,
      metadata: metadata,
    );
  }

  /// Invalid credentials result
  factory AuthResult.invalidCredentials({Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: 'Invalid email or password',
      type: AuthResultType.invalidCredentials,
      metadata: metadata,
    );
  }

  /// Email already exists result
  factory AuthResult.emailAlreadyExists({Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: 'An account with this email already exists',
      type: AuthResultType.emailAlreadyExists,
      metadata: metadata,
    );
  }

  /// Email not verified result
  factory AuthResult.emailNotVerified({Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: 'Please verify your email address before signing in',
      type: AuthResultType.emailNotVerified,
      metadata: metadata,
    );
  }

  /// Account disabled result
  factory AuthResult.accountDisabled({Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: 'This account has been disabled',
      type: AuthResultType.accountDisabled,
      metadata: metadata,
    );
  }

  /// Network error result
  factory AuthResult.networkError({Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: 'Network error. Please check your connection',
      type: AuthResultType.networkError,
      metadata: metadata,
    );
  }

  /// Timeout result
  factory AuthResult.timeout({Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: 'Request timed out. Please try again',
      type: AuthResultType.timeout,
      metadata: metadata,
    );
  }

  /// Too many attempts result
  factory AuthResult.tooManyAttempts({Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: 'Too many failed attempts. Please try again later',
      type: AuthResultType.tooManyAttempts,
      metadata: metadata,
    );
  }

  bool get isError => !isSuccess;
  bool get hasUser => user != null;
  bool get isInvalidCredentials => type == AuthResultType.invalidCredentials;
  bool get isEmailAlreadyExists => type == AuthResultType.emailAlreadyExists;
  bool get isEmailNotVerified => type == AuthResultType.emailNotVerified;
  bool get isAccountDisabled => type == AuthResultType.accountDisabled;
  bool get isNetworkError => type == AuthResultType.networkError;
  bool get isTimeout => type == AuthResultType.timeout;
  bool get isTooManyAttempts => type == AuthResultType.tooManyAttempts;

  @override
  String toString() {
    return 'AuthResult(isSuccess: $isSuccess, type: $type, error: $errorMessage)';
  }
}

/// Authentication result type enumeration
enum AuthResultType {
  success,
  error,
  invalidCredentials,
  emailAlreadyExists,
  emailNotVerified,
  accountDisabled,
  networkError,
  timeout,
  tooManyAttempts,
}

/// Authentication state enumeration
enum AuthState {
  unknown,
  authenticated,
  unauthenticated,
  loading,
}

/// User session information
class UserSession {
  final String sessionId;
  final String userId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? deviceId;
  final String? deviceName;
  final String? ipAddress;
  final String? userAgent;
  final bool isActive;
  final DateTime? lastActivityAt;

  const UserSession({
    required this.sessionId,
    required this.userId,
    required this.createdAt,
    this.expiresAt,
    this.deviceId,
    this.deviceName,
    this.ipAddress,
    this.userAgent,
    this.isActive = true,
    this.lastActivityAt,
  });

  /// Check if session is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if session is valid
  bool get isValid => isActive && !isExpired;

  /// Get session duration
  Duration get sessionDuration {
    final endTime = lastActivityAt ?? DateTime.now();
    return endTime.difference(createdAt);
  }

  /// Get time until expiration
  Duration? get timeUntilExpiration {
    if (expiresAt == null) return null;
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return Duration.zero;
    return expiresAt!.difference(now);
  }

  @override
  String toString() {
    return 'UserSession(sessionId: $sessionId, userId: $userId, isActive: $isActive)';
  }
}

/// Authentication configuration interface
abstract class AuthConfiguration {
  /// Get minimum password length
  int getMinPasswordLength();

  /// Get password requirements
  PasswordRequirements getPasswordRequirements();

  /// Get session timeout duration
  Duration getSessionTimeout();

  /// Get maximum login attempts
  int getMaxLoginAttempts();

  /// Get lockout duration after max attempts
  Duration getLockoutDuration();

  /// Check if email verification is required
  bool isEmailVerificationRequired();

  /// Check if phone verification is required
  bool isPhoneVerificationRequired();

  /// Get supported authentication providers
  List<AuthProvider> getSupportedProviders();
}

/// Password requirements
class PasswordRequirements {
  final int minLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumbers;
  final bool requireSpecialCharacters;
  final List<String> disallowedPasswords;

  const PasswordRequirements({
    this.minLength = 8,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireNumbers = true,
    this.requireSpecialCharacters = true,
    this.disallowedPasswords = const [],
  });

  /// Validate password against requirements
  PasswordValidationResult validatePassword(String password) {
    final errors = <String>[];

    if (password.length < minLength) {
      errors.add('Password must be at least $minLength characters long');
    }

    if (requireUppercase && !password.contains(RegExp(r'[A-Z]'))) {
      errors.add('Password must contain at least one uppercase letter');
    }

    if (requireLowercase && !password.contains(RegExp(r'[a-z]'))) {
      errors.add('Password must contain at least one lowercase letter');
    }

    if (requireNumbers && !password.contains(RegExp(r'[0-9]'))) {
      errors.add('Password must contain at least one number');
    }

    if (requireSpecialCharacters && !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add('Password must contain at least one special character');
    }

    if (disallowedPasswords.contains(password.toLowerCase())) {
      errors.add('This password is not allowed');
    }

    return PasswordValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// Password validation result
class PasswordValidationResult {
  final bool isValid;
  final List<String> errors;

  const PasswordValidationResult({
    required this.isValid,
    required this.errors,
  });

  String get errorMessage => errors.join(', ');

  @override
  String toString() {
    return 'PasswordValidationResult(isValid: $isValid, errors: $errors)';
  }
}

/// Authentication provider enumeration
enum AuthProvider {
  email('Email'),
  google('Google'),
  facebook('Facebook'),
  apple('Apple'),
  twitter('Twitter'),
  github('GitHub');

  const AuthProvider(this.displayName);
  final String displayName;
}