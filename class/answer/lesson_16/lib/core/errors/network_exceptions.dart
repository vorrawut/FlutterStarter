import 'api_error.dart';

class NetworkExceptions {
  // Connection Errors
  static ConnectionError noInternetConnection() {
    return const ConnectionError(
      message: 'No internet connection available',
      code: 'NO_INTERNET',
    );
  }

  static ConnectionError serverUnreachable() {
    return const ConnectionError(
      message: 'Unable to reach the server',
      code: 'SERVER_UNREACHABLE',
    );
  }

  static ConnectionError connectionFailed() {
    return const ConnectionError(
      message: 'Connection failed',
      code: 'CONNECTION_FAILED',
    );
  }

  // Timeout Errors
  static TimeoutError connectionTimeout() {
    return const TimeoutError(
      message: 'Connection timeout',
      code: 'CONNECTION_TIMEOUT',
      timeout: Duration(seconds: 30),
    );
  }

  static TimeoutError sendTimeout() {
    return const TimeoutError(
      message: 'Request send timeout',
      code: 'SEND_TIMEOUT',
    );
  }

  static TimeoutError receiveTimeout() {
    return const TimeoutError(
      message: 'Response receive timeout',
      code: 'RECEIVE_TIMEOUT',
    );
  }

  // Certificate Errors
  static NetworkError badCertificate() {
    return const NetworkError(
      message: 'Invalid SSL certificate',
      code: 'BAD_CERTIFICATE',
    );
  }

  // Request Cancellation
  static NetworkError requestCancelled() {
    return const NetworkError(
      message: 'Request was cancelled',
      code: 'REQUEST_CANCELLED',
    );
  }

  // Response Errors
  static NetworkError noResponse() {
    return const NetworkError(
      message: 'No response received from server',
      code: 'NO_RESPONSE',
    );
  }

  // Client Errors (4xx)
  static ClientError badRequest({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return ClientError(
      message: message ?? 'Invalid request',
      statusCode: 400,
      code: 'BAD_REQUEST',
      details: details,
    );
  }

  static AuthenticationError unauthorizedRequest({
    String? message,
  }) {
    return AuthenticationError(
      message: message ?? 'Authentication required',
      code: 'UNAUTHORIZED',
    );
  }

  static AuthorizationError forbiddenRequest({
    String? message,
  }) {
    return AuthorizationError(
      message: message ?? 'Access forbidden',
      code: 'FORBIDDEN',
    );
  }

  static NotFoundError notFound({
    String? message,
    String? resource,
  }) {
    return NotFoundError(
      message: message ?? 'Resource not found',
      code: 'NOT_FOUND',
      resource: resource,
    );
  }

  static ConflictError conflict({
    String? message,
    Map<String, dynamic>? details,
  }) {
    return ConflictError(
      message: message ?? 'Resource conflict',
      code: 'CONFLICT',
      details: details,
    );
  }

  static ValidationError validationError({
    String? message,
    Map<String, dynamic>? details,
    Map<String, List<String>>? fieldErrors,
  }) {
    return ValidationError(
      message: message ?? 'Validation failed',
      code: 'VALIDATION_ERROR',
      details: details,
      fieldErrors: fieldErrors,
    );
  }

  static RateLimitError tooManyRequests({
    String? message,
    DateTime? retryAfter,
  }) {
    return RateLimitError(
      message: message ?? 'Too many requests',
      code: 'RATE_LIMIT',
      retryAfter: retryAfter,
    );
  }

  // Server Errors (5xx)
  static ServerError internalServerError({
    String? message,
  }) {
    return ServerError(
      message: message ?? 'Internal server error',
      statusCode: 500,
      code: 'INTERNAL_SERVER_ERROR',
    );
  }

  static ServerError badGateway({
    String? message,
  }) {
    return ServerError(
      message: message ?? 'Bad gateway',
      statusCode: 502,
      code: 'BAD_GATEWAY',
    );
  }

  static ServerError serviceUnavailable({
    String? message,
  }) {
    return ServerError(
      message: message ?? 'Service temporarily unavailable',
      statusCode: 503,
      code: 'SERVICE_UNAVAILABLE',
    );
  }

  static ServerError gatewayTimeout({
    String? message,
  }) {
    return ServerError(
      message: message ?? 'Gateway timeout',
      statusCode: 504,
      code: 'GATEWAY_TIMEOUT',
    );
  }

  // Generic Errors
  static UnknownError unexpectedError({
    String? message,
    dynamic originalError,
  }) {
    return UnknownError(
      message: message ?? 'An unexpected error occurred',
      code: 'UNEXPECTED_ERROR',
      originalError: originalError,
    );
  }

  static CacheError cacheError({
    String? message,
  }) {
    return CacheError(
      message: message ?? 'Cache operation failed',
      code: 'CACHE_ERROR',
    );
  }

  // Helper method to check error types
  static bool isNetworkError(ApiError error) {
    return error is NetworkError || error is ConnectionError || error is TimeoutError;
  }

  static bool isServerError(ApiError error) {
    return error is ServerError;
  }

  static bool isClientError(ApiError error) {
    return error is ClientError;
  }

  static bool isAuthError(ApiError error) {
    return error is AuthenticationError || error is AuthorizationError;
  }

  static bool isRetryableError(ApiError error) {
    if (error is TimeoutError || error is ConnectionError) {
      return true;
    }
    
    if (error is ServerError) {
      return error.statusCode == 502 || 
             error.statusCode == 503 || 
             error.statusCode == 504;
    }
    
    if (error is RateLimitError) {
      return true;
    }
    
    return false;
  }
}