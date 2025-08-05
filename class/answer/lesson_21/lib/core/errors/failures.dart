import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

/// Base failure class for all application errors
/// 
/// This abstract class serves as the foundation for all error handling
/// in the ConnectPro Ultimate application, following clean architecture
/// principles and providing consistent error representation across layers.
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

// ============================================================================
// GENERAL FAILURES
// ============================================================================

/// Server failure for API-related errors
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory ServerFailure.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'CONNECTION_TIMEOUT',
        );
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          message: 'Server response timeout. Please try again.',
          code: 'RECEIVE_TIMEOUT',
        );
      case DioExceptionType.sendTimeout:
        return const ServerFailure(
          message: 'Request timeout. Please try again.',
          code: 'SEND_TIMEOUT',
        );
      case DioExceptionType.badResponse:
        return ServerFailure(
          message: _parseErrorMessage(exception.response?.data),
          code: exception.response?.statusCode.toString(),
          details: exception.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure(
          message: 'Request was cancelled.',
          code: 'REQUEST_CANCELLED',
        );
      case DioExceptionType.connectionError:
        return const ServerFailure(
          message: 'Connection error. Please check your internet connection.',
          code: 'CONNECTION_ERROR',
        );
      default:
        return const ServerFailure(
          message: 'An unexpected error occurred. Please try again.',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  static String _parseErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? 
             data['error'] ?? 
             data['detail'] ?? 
             'Server error occurred';
    }
    return 'Server error occurred';
  }
}

/// Network failure for connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'No internet connection. Please check your network settings.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkFailure.poor() {
    return const NetworkFailure(
      message: 'Poor internet connection. Please try again.',
      code: 'POOR_CONNECTION',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Network timeout. Please try again.',
      code: 'NETWORK_TIMEOUT',
    );
  }
}

/// Cache failure for local storage issues
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory CacheFailure.notFound() {
    return const CacheFailure(
      message: 'Requested data not found in cache.',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheFailure.expired() {
    return const CacheFailure(
      message: 'Cached data has expired.',
      code: 'CACHE_EXPIRED',
    );
  }

  factory CacheFailure.storageError() {
    return const CacheFailure(
      message: 'Error accessing local storage.',
      code: 'CACHE_STORAGE_ERROR',
    );
  }

  factory CacheFailure.corruption() {
    return const CacheFailure(
      message: 'Cached data is corrupted.',
      code: 'CACHE_CORRUPTION',
    );
  }
}

/// Validation failure for input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory ValidationFailure.invalidEmail() {
    return const ValidationFailure(
      message: 'Please enter a valid email address.',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationFailure.weakPassword() {
    return const ValidationFailure(
      message: 'Password must be at least 8 characters long and contain letters, numbers, and symbols.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory ValidationFailure.passwordMismatch() {
    return const ValidationFailure(
      message: 'Passwords do not match.',
      code: 'PASSWORD_MISMATCH',
    );
  }

  factory ValidationFailure.emptyField(String fieldName) {
    return ValidationFailure(
      message: '$fieldName is required.',
      code: 'EMPTY_FIELD',
      details: {'field': fieldName},
    );
  }

  factory ValidationFailure.invalidLength(String fieldName, int min, int max) {
    return ValidationFailure(
      message: '$fieldName must be between $min and $max characters.',
      code: 'INVALID_LENGTH',
      details: {'field': fieldName, 'min': min, 'max': max},
    );
  }

  factory ValidationFailure.invalidFormat(String fieldName) {
    return ValidationFailure(
      message: '$fieldName format is invalid.',
      code: 'INVALID_FORMAT',
      details: {'field': fieldName},
    );
  }
}

// ============================================================================
// AUTHENTICATION FAILURES
// ============================================================================

/// Authentication failure for auth-related errors
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory AuthFailure.fromFirebaseException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return const AuthFailure(
          message: 'No account found with this email address.',
          code: 'USER_NOT_FOUND',
        );
      case 'wrong-password':
        return const AuthFailure(
          message: 'Incorrect password. Please try again.',
          code: 'WRONG_PASSWORD',
        );
      case 'invalid-email':
        return const AuthFailure(
          message: 'Please enter a valid email address.',
          code: 'INVALID_EMAIL',
        );
      case 'user-disabled':
        return const AuthFailure(
          message: 'This account has been disabled. Please contact support.',
          code: 'USER_DISABLED',
        );
      case 'email-already-in-use':
        return const AuthFailure(
          message: 'An account already exists with this email address.',
          code: 'EMAIL_ALREADY_IN_USE',
        );
      case 'weak-password':
        return const AuthFailure(
          message: 'Password is too weak. Please choose a stronger password.',
          code: 'WEAK_PASSWORD',
        );
      case 'operation-not-allowed':
        return const AuthFailure(
          message: 'This sign-in method is not enabled.',
          code: 'OPERATION_NOT_ALLOWED',
        );
      case 'invalid-verification-code':
        return const AuthFailure(
          message: 'Invalid verification code. Please try again.',
          code: 'INVALID_VERIFICATION_CODE',
        );
      case 'invalid-verification-id':
        return const AuthFailure(
          message: 'Invalid verification ID. Please try again.',
          code: 'INVALID_VERIFICATION_ID',
        );
      case 'too-many-requests':
        return const AuthFailure(
          message: 'Too many attempts. Please try again later.',
          code: 'TOO_MANY_REQUESTS',
        );
      case 'network-request-failed':
        return const AuthFailure(
          message: 'Network error. Please check your connection.',
          code: 'NETWORK_REQUEST_FAILED',
        );
      default:
        return AuthFailure(
          message: exception.message ?? 'An authentication error occurred.',
          code: exception.code,
        );
    }
  }

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Invalid email or password. Please try again.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthFailure.userNotLoggedIn() {
    return const AuthFailure(
      message: 'User is not logged in.',
      code: 'USER_NOT_LOGGED_IN',
    );
  }

  factory AuthFailure.sessionExpired() {
    return const AuthFailure(
      message: 'Your session has expired. Please log in again.',
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthFailure.googleSignInFailed() {
    return const AuthFailure(
      message: 'Google sign-in failed. Please try again.',
      code: 'GOOGLE_SIGN_IN_FAILED',
    );
  }

  factory AuthFailure.appleSignInFailed() {
    return const AuthFailure(
      message: 'Apple sign-in failed. Please try again.',
      code: 'APPLE_SIGN_IN_FAILED',
    );
  }

  factory AuthFailure.phoneAuthFailed() {
    return const AuthFailure(
      message: 'Phone authentication failed. Please try again.',
      code: 'PHONE_AUTH_FAILED',
    );
  }

  factory AuthFailure.biometricAuthFailed() {
    return const AuthFailure(
      message: 'Biometric authentication failed. Please try again.',
      code: 'BIOMETRIC_AUTH_FAILED',
    );
  }

  factory AuthFailure.accountLocked() {
    return const AuthFailure(
      message: 'Account temporarily locked due to multiple failed attempts.',
      code: 'ACCOUNT_LOCKED',
    );
  }
}

// ============================================================================
// FIRESTORE FAILURES
// ============================================================================

/// Firestore failure for database-related errors
class FirestoreFailure extends Failure {
  const FirestoreFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory FirestoreFailure.fromFirebaseException(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return const FirestoreFailure(
          message: 'Access denied. You don\'t have permission to perform this action.',
          code: 'PERMISSION_DENIED',
        );
      case 'not-found':
        return const FirestoreFailure(
          message: 'Requested document not found.',
          code: 'NOT_FOUND',
        );
      case 'already-exists':
        return const FirestoreFailure(
          message: 'Document already exists.',
          code: 'ALREADY_EXISTS',
        );
      case 'resource-exhausted':
        return const FirestoreFailure(
          message: 'Request quota exceeded. Please try again later.',
          code: 'RESOURCE_EXHAUSTED',
        );
      case 'failed-precondition':
        return const FirestoreFailure(
          message: 'Operation failed due to data conflicts.',
          code: 'FAILED_PRECONDITION',
        );
      case 'aborted':
        return const FirestoreFailure(
          message: 'Operation was aborted due to conflicts.',
          code: 'ABORTED',
        );
      case 'out-of-range':
        return const FirestoreFailure(
          message: 'Invalid data range provided.',
          code: 'OUT_OF_RANGE',
        );
      case 'unimplemented':
        return const FirestoreFailure(
          message: 'This operation is not implemented.',
          code: 'UNIMPLEMENTED',
        );
      case 'internal':
        return const FirestoreFailure(
          message: 'Internal server error. Please try again.',
          code: 'INTERNAL',
        );
      case 'unavailable':
        return const FirestoreFailure(
          message: 'Service temporarily unavailable. Please try again.',
          code: 'UNAVAILABLE',
        );
      case 'data-loss':
        return const FirestoreFailure(
          message: 'Data loss detected. Please contact support.',
          code: 'DATA_LOSS',
        );
      default:
        return FirestoreFailure(
          message: exception.message ?? 'Database error occurred.',
          code: exception.code,
        );
    }
  }

  factory FirestoreFailure.documentNotFound(String documentId) {
    return FirestoreFailure(
      message: 'Document not found.',
      code: 'DOCUMENT_NOT_FOUND',
      details: {'documentId': documentId},
    );
  }

  factory FirestoreFailure.collectionEmpty(String collection) {
    return FirestoreFailure(
      message: 'No documents found in collection.',
      code: 'COLLECTION_EMPTY',
      details: {'collection': collection},
    );
  }

  factory FirestoreFailure.queryError() {
    return const FirestoreFailure(
      message: 'Error executing query. Please try again.',
      code: 'QUERY_ERROR',
    );
  }

  factory FirestoreFailure.batchWriteError() {
    return const FirestoreFailure(
      message: 'Error executing batch write operation.',
      code: 'BATCH_WRITE_ERROR',
    );
  }
}

// ============================================================================
// SOCIAL FEATURES FAILURES
// ============================================================================

/// Social failure for social features errors
class SocialFailure extends Failure {
  const SocialFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory SocialFailure.postNotFound() {
    return const SocialFailure(
      message: 'Post not found or has been deleted.',
      code: 'POST_NOT_FOUND',
    );
  }

  factory SocialFailure.alreadyLiked() {
    return const SocialFailure(
      message: 'You have already liked this post.',
      code: 'ALREADY_LIKED',
    );
  }

  factory SocialFailure.alreadyFollowing() {
    return const SocialFailure(
      message: 'You are already following this user.',
      code: 'ALREADY_FOLLOWING',
    );
  }

  factory SocialFailure.cannotFollowSelf() {
    return const SocialFailure(
      message: 'You cannot follow yourself.',
      code: 'CANNOT_FOLLOW_SELF',
    );
  }

  factory SocialFailure.feedEmpty() {
    return const SocialFailure(
      message: 'No posts available in your feed.',
      code: 'FEED_EMPTY',
    );
  }

  factory SocialFailure.contentModerated() {
    return const SocialFailure(
      message: 'Content has been moderated and cannot be displayed.',
      code: 'CONTENT_MODERATED',
    );
  }

  factory SocialFailure.userBlocked() {
    return const SocialFailure(
      message: 'This user has been blocked.',
      code: 'USER_BLOCKED',
    );
  }

  factory SocialFailure.privacyRestriction() {
    return const SocialFailure(
      message: 'You don\'t have permission to view this content.',
      code: 'PRIVACY_RESTRICTION',
    );
  }
}

// ============================================================================
// CHAT FAILURES
// ============================================================================

/// Chat failure for messaging-related errors
class ChatFailure extends Failure {
  const ChatFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory ChatFailure.chatNotFound() {
    return const ChatFailure(
      message: 'Chat conversation not found.',
      code: 'CHAT_NOT_FOUND',
    );
  }

  factory ChatFailure.messageNotFound() {
    return const ChatFailure(
      message: 'Message not found or has been deleted.',
      code: 'MESSAGE_NOT_FOUND',
    );
  }

  factory ChatFailure.sendMessageFailed() {
    return const ChatFailure(
      message: 'Failed to send message. Please try again.',
      code: 'SEND_MESSAGE_FAILED',
    );
  }

  factory ChatFailure.encryptionFailed() {
    return const ChatFailure(
      message: 'Failed to encrypt message.',
      code: 'ENCRYPTION_FAILED',
    );
  }

  factory ChatFailure.decryptionFailed() {
    return const ChatFailure(
      message: 'Failed to decrypt message.',
      code: 'DECRYPTION_FAILED',
    );
  }

  factory ChatFailure.fileUploadFailed() {
    return const ChatFailure(
      message: 'Failed to upload file. Please try again.',
      code: 'FILE_UPLOAD_FAILED',
    );
  }

  factory ChatFailure.fileTooLarge() {
    return const ChatFailure(
      message: 'File is too large. Maximum size is 50MB.',
      code: 'FILE_TOO_LARGE',
    );
  }

  factory ChatFailure.unsupportedFileType() {
    return const ChatFailure(
      message: 'File type is not supported.',
      code: 'UNSUPPORTED_FILE_TYPE',
    );
  }

  factory ChatFailure.participantNotFound() {
    return const ChatFailure(
      message: 'Chat participant not found.',
      code: 'PARTICIPANT_NOT_FOUND',
    );
  }

  factory ChatFailure.groupChatLimitExceeded() {
    return const ChatFailure(
      message: 'Group chat member limit exceeded.',
      code: 'GROUP_CHAT_LIMIT_EXCEEDED',
    );
  }
}

// ============================================================================
// NOTIFICATION FAILURES
// ============================================================================

/// Notification failure for push notification errors
class NotificationFailure extends Failure {
  const NotificationFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory NotificationFailure.permissionDenied() {
    return const NotificationFailure(
      message: 'Notification permission denied. Please enable in settings.',
      code: 'PERMISSION_DENIED',
    );
  }

  factory NotificationFailure.initializationFailed() {
    return const NotificationFailure(
      message: 'Failed to initialize notifications.',
      code: 'INITIALIZATION_FAILED',
    );
  }

  factory NotificationFailure.sendFailed() {
    return const NotificationFailure(
      message: 'Failed to send notification.',
      code: 'SEND_FAILED',
    );
  }

  factory NotificationFailure.tokenUpdateFailed() {
    return const NotificationFailure(
      message: 'Failed to update notification token.',
      code: 'TOKEN_UPDATE_FAILED',
    );
  }

  factory NotificationFailure.subscriptionFailed() {
    return const NotificationFailure(
      message: 'Failed to subscribe to topic.',
      code: 'SUBSCRIPTION_FAILED',
    );
  }

  factory NotificationFailure.unsubscriptionFailed() {
    return const NotificationFailure(
      message: 'Failed to unsubscribe from topic.',
      code: 'UNSUBSCRIPTION_FAILED',
    );
  }
}

// ============================================================================
// STORAGE FAILURES
// ============================================================================

/// Storage failure for file storage errors
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.details,
  });

  factory StorageFailure.uploadFailed() {
    return const StorageFailure(
      message: 'File upload failed. Please try again.',
      code: 'UPLOAD_FAILED',
    );
  }

  factory StorageFailure.downloadFailed() {
    return const StorageFailure(
      message: 'File download failed. Please try again.',
      code: 'DOWNLOAD_FAILED',
    );
  }

  factory StorageFailure.fileNotFound() {
    return const StorageFailure(
      message: 'File not found.',
      code: 'FILE_NOT_FOUND',
    );
  }

  factory StorageFailure.insufficientStorage() {
    return const StorageFailure(
      message: 'Insufficient storage space.',
      code: 'INSUFFICIENT_STORAGE',
    );
  }

  factory StorageFailure.quotaExceeded() {
    return const StorageFailure(
      message: 'Storage quota exceeded.',
      code: 'QUOTA_EXCEEDED',
    );
  }

  factory StorageFailure.invalidFileName() {
    return const StorageFailure(
      message: 'Invalid file name.',
      code: 'INVALID_FILE_NAME',
    );
  }
}