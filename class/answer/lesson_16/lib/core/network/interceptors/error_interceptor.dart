import 'package:dio/dio.dart';
import '../../errors/api_error.dart';
import '../../errors/network_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiError = _transformError(err);
    
    // Create a new DioException with our custom error
    final transformedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiError,
      message: apiError.message,
    );

    handler.next(transformedError);
  }

  ApiError _transformError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkExceptions.connectionTimeout();
        
      case DioExceptionType.sendTimeout:
        return NetworkExceptions.sendTimeout();
        
      case DioExceptionType.receiveTimeout:
        return NetworkExceptions.receiveTimeout();
        
      case DioExceptionType.badCertificate:
        return NetworkExceptions.badCertificate();
        
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
        
      case DioExceptionType.cancel:
        return NetworkExceptions.requestCancelled();
        
      case DioExceptionType.connectionError:
        return NetworkExceptions.noInternetConnection();
        
      case DioExceptionType.unknown:
        return _handleUnknownError(error);
        
      default:
        return NetworkExceptions.unexpectedError();
    }
  }

  ApiError _handleBadResponse(DioException error) {
    final response = error.response;
    if (response == null) {
      return NetworkExceptions.noResponse();
    }

    final statusCode = response.statusCode ?? 0;
    
    // Try to extract error message from response
    String? errorMessage;
    Map<String, dynamic>? errorData;
    
    try {
      if (response.data is Map<String, dynamic>) {
        errorData = response.data as Map<String, dynamic>;
        errorMessage = _extractErrorMessage(errorData);
      } else if (response.data is String) {
        errorMessage = response.data as String;
      }
    } catch (e) {
      // Ignore parsing errors
    }

    switch (statusCode) {
      case 400:
        return NetworkExceptions.badRequest(
          message: errorMessage ?? 'Bad request',
          details: errorData,
        );
        
      case 401:
        return NetworkExceptions.unauthorizedRequest(
          message: errorMessage ?? 'Unauthorized access',
        );
        
      case 403:
        return NetworkExceptions.forbiddenRequest(
          message: errorMessage ?? 'Access forbidden',
        );
        
      case 404:
        return NetworkExceptions.notFound(
          message: errorMessage ?? 'Resource not found',
        );
        
      case 409:
        return NetworkExceptions.conflict(
          message: errorMessage ?? 'Resource conflict',
          details: errorData,
        );
        
      case 422:
        return NetworkExceptions.validationError(
          message: errorMessage ?? 'Validation failed',
          details: errorData,
        );
        
      case 429:
        return NetworkExceptions.tooManyRequests(
          message: errorMessage ?? 'Too many requests',
        );
        
      case 500:
        return NetworkExceptions.internalServerError(
          message: errorMessage ?? 'Internal server error',
        );
        
      case 502:
        return NetworkExceptions.badGateway(
          message: errorMessage ?? 'Bad gateway',
        );
        
      case 503:
        return NetworkExceptions.serviceUnavailable(
          message: errorMessage ?? 'Service unavailable',
        );
        
      case 504:
        return NetworkExceptions.gatewayTimeout(
          message: errorMessage ?? 'Gateway timeout',
        );
        
      default:
        if (statusCode >= 500) {
          return NetworkExceptions.internalServerError(
            message: errorMessage ?? 'Server error',
          );
        } else if (statusCode >= 400) {
          return NetworkExceptions.badRequest(
            message: errorMessage ?? 'Client error',
            details: errorData,
          );
        } else {
          return NetworkExceptions.unexpectedError(
            message: errorMessage ?? 'Unexpected response: $statusCode',
          );
        }
    }
  }

  ApiError _handleUnknownError(DioException error) {
    final errorMessage = error.message;
    
    if (errorMessage != null) {
      if (errorMessage.contains('SocketException') ||
          errorMessage.contains('Network is unreachable')) {
        return NetworkExceptions.noInternetConnection();
      }
      
      if (errorMessage.contains('Connection refused')) {
        return NetworkExceptions.serverUnreachable();
      }
      
      if (errorMessage.contains('timeout')) {
        return NetworkExceptions.connectionTimeout();
      }
    }

    return NetworkExceptions.unexpectedError(
      message: errorMessage ?? 'Unknown error occurred',
    );
  }

  String? _extractErrorMessage(Map<String, dynamic> errorData) {
    // Common error message field names
    const messageFields = [
      'message',
      'error',
      'detail',
      'description',
      'msg',
      'error_description',
    ];

    for (final field in messageFields) {
      if (errorData.containsKey(field)) {
        final value = errorData[field];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    // Try to extract from nested error object
    if (errorData.containsKey('error') && errorData['error'] is Map) {
      final nestedError = errorData['error'] as Map<String, dynamic>;
      return _extractErrorMessage(nestedError);
    }

    // Try to extract from errors array
    if (errorData.containsKey('errors') && errorData['errors'] is List) {
      final errors = errorData['errors'] as List;
      if (errors.isNotEmpty) {
        final firstError = errors.first;
        if (firstError is String) {
          return firstError;
        } else if (firstError is Map<String, dynamic>) {
          return _extractErrorMessage(firstError);
        }
      }
    }

    return null;
  }
}