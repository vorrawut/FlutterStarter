import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  final String? code;
  
  const AuthException(this.message, {this.code});
  
  @override
  String toString() => message;
}

class AuthExceptions {
  /// Handle Firebase Auth exceptions and convert to user-friendly messages
  static AuthException handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      // Email/Password Authentication Errors
      case 'user-not-found':
        return const AuthException(
          'No account found with this email address. Please check your email or create a new account.',
          code: 'user-not-found',
        );
      
      case 'wrong-password':
        return const AuthException(
          'Incorrect password. Please check your password and try again.',
          code: 'wrong-password',
        );
      
      case 'email-already-in-use':
        return const AuthException(
          'An account already exists with this email address. Please sign in instead.',
          code: 'email-already-in-use',
        );
      
      case 'weak-password':
        return const AuthException(
          'Password is too weak. Please choose a stronger password with at least 6 characters.',
          code: 'weak-password',
        );
      
      case 'invalid-email':
        return const AuthException(
          'Please enter a valid email address.',
          code: 'invalid-email',
        );
      
      case 'user-disabled':
        return const AuthException(
          'This account has been disabled. Please contact support for assistance.',
          code: 'user-disabled',
        );
      
      case 'too-many-requests':
        return const AuthException(
          'Too many unsuccessful attempts. Please try again later.',
          code: 'too-many-requests',
        );
      
      case 'operation-not-allowed':
        return const AuthException(
          'This sign-in method is not enabled. Please contact support.',
          code: 'operation-not-allowed',
        );
      
      // Re-authentication Errors
      case 'requires-recent-login':
        return const AuthException(
          'This action requires recent authentication. Please sign in again.',
          code: 'requires-recent-login',
        );
      
      // Email Verification Errors
      case 'invalid-action-code':
        return const AuthException(
          'The verification link is invalid or has expired. Please request a new one.',
          code: 'invalid-action-code',
        );
      
      case 'expired-action-code':
        return const AuthException(
          'The verification link has expired. Please request a new one.',
          code: 'expired-action-code',
        );
      
      // Phone Authentication Errors
      case 'invalid-phone-number':
        return const AuthException(
          'Please enter a valid phone number.',
          code: 'invalid-phone-number',
        );
      
      case 'quota-exceeded':
        return const AuthException(
          'SMS quota exceeded. Please try again later.',
          code: 'quota-exceeded',
        );
      
      case 'invalid-verification-code':
        return const AuthException(
          'Invalid verification code. Please check the code and try again.',
          code: 'invalid-verification-code',
        );
      
      case 'invalid-verification-id':
        return const AuthException(
          'Verification session expired. Please request a new code.',
          code: 'invalid-verification-id',
        );
      
      // Provider Linking Errors
      case 'provider-already-linked':
        return const AuthException(
          'This account is already linked to another provider.',
          code: 'provider-already-linked',
        );
      
      case 'no-such-provider':
        return const AuthException(
          'This provider is not linked to your account.',
          code: 'no-such-provider',
        );
      
      case 'invalid-credential':
        return const AuthException(
          'The provided credentials are invalid or have expired.',
          code: 'invalid-credential',
        );
      
      case 'credential-already-in-use':
        return const AuthException(
          'This credential is already associated with a different account.',
          code: 'credential-already-in-use',
        );
      
      case 'account-exists-with-different-credential':
        return const AuthException(
          'An account already exists with the same email but different sign-in credentials.',
          code: 'account-exists-with-different-credential',
        );
      
      // Network and Server Errors
      case 'network-request-failed':
        return const AuthException(
          'Network error. Please check your internet connection and try again.',
          code: 'network-request-failed',
        );
      
      case 'internal-error':
        return const AuthException(
          'An internal error occurred. Please try again later.',
          code: 'internal-error',
        );
      
      case 'app-not-authorized':
        return const AuthException(
          'App not authorized to use Firebase Authentication.',
          code: 'app-not-authorized',
        );
      
      case 'app-not-installed':
        return const AuthException(
          'Required app is not installed on this device.',
          code: 'app-not-installed',
        );
      
      // Multi-Factor Authentication Errors
      case 'multi-factor-auth-required':
        return const AuthException(
          'Multi-factor authentication is required to complete sign-in.',
          code: 'multi-factor-auth-required',
        );
      
      case 'multi-factor-info-not-found':
        return const AuthException(
          'Multi-factor authentication information not found.',
          code: 'multi-factor-info-not-found',
        );
      
      case 'admin-restricted-operation':
        return const AuthException(
          'This operation is restricted by an administrator.',
          code: 'admin-restricted-operation',
        );
      
      // Custom Token Errors
      case 'invalid-custom-token':
        return const AuthException(
          'Invalid custom authentication token.',
          code: 'invalid-custom-token',
        );
      
      case 'custom-token-mismatch':
        return const AuthException(
          'Custom token corresponds to a different Firebase project.',
          code: 'custom-token-mismatch',
        );
      
      // Session Errors
      case 'invalid-user-token':
        return const AuthException(
          'Your session has expired. Please sign in again.',
          code: 'invalid-user-token',
        );
      
      case 'user-token-expired':
        return const AuthException(
          'Your session has expired. Please sign in again.',
          code: 'user-token-expired',
        );
      
      // Default case
      default:
        return AuthException(
          e.message ?? 'An authentication error occurred. Please try again.',
          code: e.code,
        );
    }
  }
  
  /// Check if error requires user to sign in again
  static bool requiresReauthentication(String? code) {
    const reauthCodes = [
      'requires-recent-login',
      'invalid-user-token',
      'user-token-expired',
    ];
    return code != null && reauthCodes.contains(code);
  }
  
  /// Check if error is due to network issues
  static bool isNetworkError(String? code) {
    const networkCodes = [
      'network-request-failed',
      'internal-error',
    ];
    return code != null && networkCodes.contains(code);
  }
  
  /// Check if error is due to invalid credentials
  static bool isCredentialError(String? code) {
    const credentialCodes = [
      'invalid-credential',
      'wrong-password',
      'user-not-found',
      'invalid-verification-code',
      'expired-action-code',
      'invalid-action-code',
    ];
    return code != null && credentialCodes.contains(code);
  }
  
  /// Check if error is due to account being disabled or restricted
  static bool isAccountRestricted(String? code) {
    const restrictedCodes = [
      'user-disabled',
      'admin-restricted-operation',
    ];
    return code != null && restrictedCodes.contains(code);
  }
  
  /// Check if error is temporary and user should retry
  static bool isTemporaryError(String? code) {
    const temporaryCodes = [
      'too-many-requests',
      'quota-exceeded',
      'network-request-failed',
      'internal-error',
    ];
    return code != null && temporaryCodes.contains(code);
  }
  
  /// Get user-friendly action suggestion based on error code
  static String getActionSuggestion(String? code) {
    switch (code) {
      case 'user-not-found':
        return 'Check your email address or create a new account.';
      case 'wrong-password':
        return 'Check your password or reset it if you forgot.';
      case 'weak-password':
        return 'Choose a password with at least 6 characters.';
      case 'email-already-in-use':
        return 'Try signing in instead of creating a new account.';
      case 'invalid-email':
        return 'Enter a valid email address format.';
      case 'requires-recent-login':
        return 'Sign out and sign in again to continue.';
      case 'too-many-requests':
        return 'Wait a few minutes before trying again.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'invalid-verification-code':
        return 'Check the verification code and enter it correctly.';
      case 'expired-action-code':
        return 'Request a new verification email.';
      default:
        return 'Please try again or contact support if the problem persists.';
    }
  }
  
  /// Create a detailed error report for logging
  static Map<String, dynamic> createErrorReport(
    FirebaseAuthException e, {
    String? userAction,
    Map<String, dynamic>? context,
  }) {
    return {
      'error_code': e.code,
      'error_message': e.message,
      'user_friendly_message': handleFirebaseAuthException(e).message,
      'user_action': userAction,
      'context': context,
      'timestamp': DateTime.now().toIso8601String(),
      'requires_reauthentication': requiresReauthentication(e.code),
      'is_network_error': isNetworkError(e.code),
      'is_credential_error': isCredentialError(e.code),
      'is_temporary_error': isTemporaryError(e.code),
      'action_suggestion': getActionSuggestion(e.code),
    };
  }
}
