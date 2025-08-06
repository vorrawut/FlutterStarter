import 'package:equatable/equatable.dart';

abstract class ApiError extends Equatable implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => message;
}

class NetworkError extends ApiError {
  const NetworkError({
    required super.message,
    super.code,
    super.details,
  });
}

class ServerError extends ApiError {
  final int? statusCode;

  const ServerError({
    required super.message,
    this.statusCode,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, statusCode, code, details];
}

class ClientError extends ApiError {
  final int statusCode;

  const ClientError({
    required super.message,
    required this.statusCode,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, statusCode, code, details];
}

class ValidationError extends ClientError {
  final Map<String, List<String>>? fieldErrors;

  const ValidationError({
    required super.message,
    super.statusCode = 422,
    super.code,
    super.details,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, statusCode, code, details, fieldErrors];
}

class AuthenticationError extends ClientError {
  const AuthenticationError({
    required super.message,
    super.statusCode = 401,
    super.code,
    super.details,
  });
}

class AuthorizationError extends ClientError {
  const AuthorizationError({
    required super.message,
    super.statusCode = 403,
    super.code,
    super.details,
  });
}

class NotFoundError extends ClientError {
  final String? resource;

  const NotFoundError({
    required super.message,
    super.statusCode = 404,
    super.code,
    super.details,
    this.resource,
  });

  @override
  List<Object?> get props => [message, statusCode, code, details, resource];
}

class ConflictError extends ClientError {
  const ConflictError({
    required super.message,
    super.statusCode = 409,
    super.code,
    super.details,
  });
}

class RateLimitError extends ClientError {
  final DateTime? retryAfter;

  const RateLimitError({
    required super.message,
    super.statusCode = 429,
    super.code,
    super.details,
    this.retryAfter,
  });

  @override
  List<Object?> get props => [message, statusCode, code, details, retryAfter];
}

class TimeoutError extends NetworkError {
  final Duration? timeout;

  const TimeoutError({
    required super.message,
    super.code,
    super.details,
    this.timeout,
  });

  @override
  List<Object?> get props => [message, code, details, timeout];
}

class ConnectionError extends NetworkError {
  const ConnectionError({
    required super.message,
    super.code,
    super.details,
  });
}

class CacheError extends ApiError {
  const CacheError({
    required super.message,
    super.code,
    super.details,
  });
}

class UnknownError extends ApiError {
  final dynamic originalError;

  const UnknownError({
    required super.message,
    super.code,
    super.details,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, details, originalError];
}