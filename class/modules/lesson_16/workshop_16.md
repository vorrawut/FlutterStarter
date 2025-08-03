# 🌐 Lesson 16: Networking with Dio & Retrofit - Workshop

## 🎯 **What We're Building**

Create **NewsFlow Pro** - a comprehensive news application that demonstrates professional networking patterns with Dio, including:
- **🔧 Advanced Dio Configuration** - Interceptors, retry logic, and caching
- **📰 News API Integration** - Real-world API consumption with error handling
- **🏗️ Retrofit Pattern** - Clean API service organization and maintainability
- **📱 Offline Support** - Intelligent caching and offline-first architecture
- **🔒 Authentication Integration** - Token management and automatic refresh
- **🧪 Comprehensive Testing** - Mock services and integration testing

## ✅ **Expected Outcome**

A production-ready news application demonstrating:
- 🌐 **Professional Networking** - Dio with interceptors, retry logic, and error handling
- 🏗️ **Clean Architecture** - Repository pattern with proper separation of concerns
- 📱 **Offline Excellence** - Intelligent caching with automatic sync
- 🔒 **Security Features** - Secure API communication and token management
- 🧪 **Testing Mastery** - Comprehensive test coverage for networking code
- ⚡ **Performance Optimization** - Efficient data loading and caching strategies

## 🏗️ **Project Architecture**

We'll build a news application with clean networking architecture:

```
newsflow_pro/
├── lib/
│   ├── core/                          # 🔧 Core networking infrastructure
│   │   ├── network/                   # Network configuration and services
│   │   │   ├── dio_config.dart        # Dio setup and configuration
│   │   │   ├── interceptors/          # Request/response interceptors
│   │   │   ├── api_service.dart       # Base API service
│   │   │   └── network_info.dart      # Network connectivity service
│   │   ├── cache/                     # Caching infrastructure
│   │   │   ├── cache_service.dart     # Cache management
│   │   │   └── cached_response.dart   # Cache models
│   │   ├── errors/                    # Error handling
│   │   │   ├── api_error.dart         # API error models
│   │   │   └── network_exceptions.dart # Network exception handling
│   │   └── utils/                     # Utilities and helpers
│   ├── data/                          # 💾 Data layer
│   │   ├── models/                    # API response models
│   │   │   ├── article.dart           # News article model
│   │   │   ├── source.dart            # News source model
│   │   │   └── api_response.dart      # Generic API response wrapper
│   │   ├── services/                  # API services (Retrofit pattern)
│   │   │   ├── news_api_service.dart  # News API endpoints
│   │   │   ├── auth_api_service.dart  # Authentication endpoints
│   │   │   └── user_api_service.dart  # User management endpoints
│   │   ├── repositories/              # Repository implementations
│   │   │   ├── news_repository_impl.dart # News data repository
│   │   │   └── auth_repository_impl.dart # Auth data repository
│   │   └── datasources/               # Data source abstractions
│   │       ├── news_remote_datasource.dart # Remote news data
│   │       └── news_local_datasource.dart  # Local cached news data
│   ├── domain/                        # 🎯 Business logic
│   │   ├── entities/                  # Domain entities
│   │   ├── repositories/              # Repository interfaces
│   │   └── usecases/                  # Business use cases
│   └── presentation/                  # 🎨 UI layer
│       ├── pages/                     # App screens
│       ├── widgets/                   # Reusable widgets
│       └── providers/                 # State management
├── test/                              # 🧪 Testing
│   ├── unit/                          # Unit tests
│   │   ├── services/                  # API service tests
│   │   ├── repositories/              # Repository tests
│   │   └── mocks/                     # Mock implementations
│   ├── widget/                        # Widget tests
│   └── integration/                   # Integration tests
└── assets/                            # 🎨 App assets
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Project Setup & Dependencies** ⏱️ *15 minutes*

Set up the project with networking dependencies:

```yaml
# pubspec.yaml
name: newsflow_pro
description: Professional news app with advanced networking

dependencies:
  flutter:
    sdk: flutter
  
  # Networking
  dio: ^5.3.2
  retrofit: ^4.0.3
  json_annotation: ^4.8.1
  
  # Caching & Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # Connectivity
  connectivity_plus: ^4.0.2
  internet_connection_checker: ^1.0.0+1
  
  # State Management
  flutter_riverpod: ^2.4.5
  
  # Utils
  freezed_annotation: ^2.4.1
  equatable: ^2.0.5
  uuid: ^4.1.0
  intl: ^0.18.1
  
  # UI
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.6
  retrofit_generator: ^8.0.4
  json_serializable: ^6.7.1
  freezed: ^2.4.6
  hive_generator: ^2.0.1
  
  # Testing
  mocktail: ^1.0.0
  http_mock_adapter: ^0.4.4
  
  # Linting
  flutter_lints: ^3.0.1
```

### **Step 2: Core Network Infrastructure** ⏱️ *30 minutes*

Create the foundation networking infrastructure:

```dart
// lib/core/network/dio_config.dart
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/cache_interceptor.dart';

class DioConfig {
  static Dio createDio({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? headers,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      sendTimeout: sendTimeout ?? const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'NewsFlowPro/1.0.0',
        ...?headers,
      },
      validateStatus: (status) {
        // Accept all status codes for custom error handling
        return status != null && status < 500;
      },
    ));

    // Add interceptors in order
    dio.interceptors.addAll([
      if (kDebugMode) LoggingInterceptor(),
      AuthInterceptor(),
      CacheInterceptor(),
      RetryInterceptor(),
    ]);

    // Configure certificate pinning for production
    if (!kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
        client.badCertificateCallback = (cert, host, port) {
          // Implement certificate pinning validation
          return _validateCertificate(cert, host);
        };
        return client;
      };
    }

    return dio;
  }

  static bool _validateCertificate(cert, String host) {
    // Implement certificate pinning logic
    // This is a simplified example - implement proper certificate validation
    return true;
  }
}

// lib/core/network/api_service.dart
import 'package:dio/dio.dart';
import '../errors/api_exceptions.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Request timeout. Please check your connection and try again.',
          error: e,
        );
      
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Network connection failed. Please check your internet connection.',
          error: e,
        );
      
      case DioExceptionType.badResponse:
        return _handleResponseError(e);
      
      case DioExceptionType.cancel:
        return RequestCancelledException(
          message: 'Request was cancelled',
          error: e,
        );
      
      default:
        return UnknownException(
          message: 'An unexpected error occurred',
          error: e,
        );
    }
  }

  ApiException _handleResponseError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: _extractErrorMessage(data, 'Bad request'),
          statusCode: statusCode!,
          error: e,
        );
      
      case 401:
        return UnauthorizedException(
          message: _extractErrorMessage(data, 'Unauthorized access'),
          statusCode: statusCode!,
          error: e,
        );
      
      case 403:
        return ForbiddenException(
          message: _extractErrorMessage(data, 'Access forbidden'),
          statusCode: statusCode!,
          error: e,
        );
      
      case 404:
        return NotFoundException(
          message: _extractErrorMessage(data, 'Resource not found'),
          statusCode: statusCode!,
          error: e,
        );
      
      case 422:
        return ValidationException(
          message: _extractErrorMessage(data, 'Validation failed'),
          statusCode: statusCode!,
          validationErrors: _extractValidationErrors(data),
          error: e,
        );
      
      case 429:
        return RateLimitException(
          message: _extractErrorMessage(data, 'Too many requests'),
          statusCode: statusCode!,
          retryAfter: _extractRetryAfter(e.response?.headers),
          error: e,
        );
      
      default:
        return ServerException(
          message: _extractErrorMessage(data, 'Server error'),
          statusCode: statusCode ?? 500,
          error: e,
        );
    }
  }

  String _extractErrorMessage(dynamic data, String defaultMessage) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? defaultMessage;
    }
    return data?.toString() ?? defaultMessage;
  }

  List<ValidationError> _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.entries
            .map((e) => ValidationError(
                  field: e.key,
                  message: e.value.toString(),
                ))
            .toList();
      } else if (errors is List) {
        return errors
            .map((e) => ValidationError(
                  field: 'general',
                  message: e.toString(),
                ))
            .toList();
      }
    }
    return [];
  }

  Duration? _extractRetryAfter(Headers? headers) {
    final retryAfterHeader = headers?.value('retry-after');
    if (retryAfterHeader != null) {
      final seconds = int.tryParse(retryAfterHeader);
      if (seconds != null) {
        return Duration(seconds: seconds);
      }
    }
    return null;
  }
}

// lib/core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl(this._connectivity, this._connectionChecker);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    
    // Check actual internet connectivity
    return await _connectionChecker.hasConnection;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((result) async {
      if (result == ConnectivityResult.none) {
        return false;
      }
      return await _connectionChecker.hasConnection;
    });
  }
}
```

### **Step 3: Interceptor Implementation** ⏱️ *35 minutes*

Create comprehensive interceptors for authentication, caching, and retry logic:

```dart
// lib/core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final AuthRepository _authRepository;

  AuthInterceptor(this._secureStorage, this._authRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip authentication for public endpoints
    if (_isPublicEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    // Add authentication token
    final token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add API key if required
    if (_requiresApiKey(options.path)) {
      options.headers['X-API-Key'] = await _secureStorage.getApiKey();
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token expiration
    if (err.response?.statusCode == 401 && !_isAuthEndpoint(err.requestOptions.path)) {
      final refreshed = await _refreshToken();
      
      if (refreshed) {
        // Retry the original request
        try {
          final token = await _secureStorage.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Retry failed, proceed with original error
        }
      }
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final result = await _authRepository.refreshToken(refreshToken);
      if (result.isSuccess) {
        await _secureStorage.saveTokens(
          accessToken: result.data!.accessToken,
          refreshToken: result.data!.refreshToken,
        );
        return true;
      }
    } catch (e) {
      // Refresh failed
    }
    
    // Clear invalid tokens and logout
    await _secureStorage.clearTokens();
    await _authRepository.logout();
    return false;
  }

  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/news/public',
      '/categories/public',
    ];
    return publicEndpoints.any((endpoint) => path.startsWith(endpoint));
  }

  bool _isAuthEndpoint(String path) {
    return path.startsWith('/auth/');
  }

  bool _requiresApiKey(String path) {
    return path.startsWith('/news/') || path.startsWith('/categories/');
  }
}

// lib/core/network/interceptors/cache_interceptor.dart
import 'package:dio/dio.dart';
import '../../cache/cache_service.dart';

class CacheInterceptor extends Interceptor {
  final CacheService _cacheService;

  CacheInterceptor(this._cacheService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET' || _shouldSkipCache(options)) {
      handler.next(options);
      return;
    }

    final cacheKey = _generateCacheKey(options);
    final cachedResponse = await _cacheService.get(cacheKey);

    if (cachedResponse != null) {
      // Check if we should serve stale content while revalidating
      if (_shouldRevalidate(cachedResponse, options)) {
        // Serve cached content and revalidate in background
        _revalidateInBackground(options, cacheKey);
      }

      final response = Response<dynamic>(
        requestOptions: options,
        data: cachedResponse.data,
        statusCode: cachedResponse.statusCode,
        headers: Headers.fromMap(cachedResponse.headers),
        extra: {'fromCache': true},
      );

      handler.resolve(response);
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Cache successful GET responses
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode == 200 &&
        !_shouldSkipCache(response.requestOptions)) {
      
      final cacheKey = _generateCacheKey(response.requestOptions);
      final cacheDuration = _getCacheDuration(response.requestOptions);
      
      await _cacheService.put(
        cacheKey,
        CachedResponse(
          data: response.data,
          statusCode: response.statusCode!,
          headers: response.headers.map,
          cachedAt: DateTime.now(),
          expiresAt: DateTime.now().add(cacheDuration),
          eTag: response.headers.value('etag'),
        ),
      );
    }

    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    // Include relevant headers in cache key
    final relevantHeaders = <String, dynamic>{};
    for (final header in ['authorization', 'accept-language']) {
      if (options.headers.containsKey(header)) {
        relevantHeaders[header] = options.headers[header];
      }
    }
    return '${uri}_${relevantHeaders.hashCode}';
  }

  Duration _getCacheDuration(RequestOptions options) {
    // Check for custom cache duration
    final customDuration = options.extra['cacheDuration'] as Duration?;
    if (customDuration != null) return customDuration;

    // Default cache durations based on endpoint
    if (options.path.contains('/news/')) {
      return const Duration(minutes: 5); // News updates frequently
    } else if (options.path.contains('/categories/')) {
      return const Duration(hours: 1); // Categories change rarely
    } else if (options.path.contains('/profile/')) {
      return const Duration(minutes: 1); // Profile data
    }

    return const Duration(minutes: 5); // Default
  }

  bool _shouldSkipCache(RequestOptions options) {
    // Skip cache for real-time endpoints
    final noCacheEndpoints = ['/auth/', '/live/', '/realtime/'];
    return noCacheEndpoints.any((endpoint) => options.path.startsWith(endpoint)) ||
           options.extra['skipCache'] == true;
  }

  bool _shouldRevalidate(CachedResponse cached, RequestOptions options) {
    // Revalidate if cache is older than half of its duration
    final age = DateTime.now().difference(cached.cachedAt);
    final maxAge = cached.expiresAt.difference(cached.cachedAt);
    return age > maxAge ~/ 2;
  }

  void _revalidateInBackground(RequestOptions options, String cacheKey) {
    // Perform background revalidation
    Future(() async {
      try {
        final response = await Dio().fetch(options);
        if (response.statusCode == 200) {
          final cacheDuration = _getCacheDuration(options);
          await _cacheService.put(
            cacheKey,
            CachedResponse(
              data: response.data,
              statusCode: response.statusCode!,
              headers: response.headers.map,
              cachedAt: DateTime.now(),
              expiresAt: DateTime.now().add(cacheDuration),
              eTag: response.headers.value('etag'),
            ),
          );
        }
      } catch (e) {
        // Background revalidation failed, keep existing cache
      }
    });
  }
}

// lib/core/network/interceptors/retry_interceptor.dart
import 'dart:math' as math;
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.retryStatusCodes = const [502, 503, 504],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final attempt = _getAttemptCount(err.requestOptions);
    
    if (attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    // Calculate delay with exponential backoff and jitter
    final delay = _calculateDelay(attempt);
    await Future.delayed(delay);

    try {
      // Increment attempt count
      err.requestOptions.extra['retryAttempt'] = attempt + 1;
      
      // Log retry attempt
      print('Retrying request (attempt ${attempt + 1}/$maxRetries): ${err.requestOptions.uri}');
      
      // Retry the request
      final response = await Dio().fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      // If it's still a DioException, let it bubble up for potential further retries
      if (e is DioException) {
        onError(e, handler);
      } else {
        handler.next(err);
      }
    }
  }

  bool _shouldRetry(DioException err) {
    // Don't retry client errors (4xx) except for specific cases
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      
      // Retry specific server errors
      if (retryStatusCodes.contains(statusCode)) return true;
      
      // Don't retry client errors
      if (statusCode >= 400 && statusCode < 500) return false;
      
      // Retry server errors
      if (statusCode >= 500) return true;
    }

    // Retry network errors
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      default:
        return false;
    }
  }

  int _getAttemptCount(RequestOptions options) {
    return options.extra['retryAttempt'] ?? 0;
  }

  Duration _calculateDelay(int attempt) {
    // Exponential backoff with jitter
    final exponentialDelay = initialDelay.inMilliseconds * 
                           math.pow(backoffMultiplier, attempt);
    
    // Add jitter (±25% of the delay)
    final jitter = (exponentialDelay * 0.25 * (math.Random().nextDouble() * 2 - 1));
    
    return Duration(milliseconds: (exponentialDelay + jitter).round());
  }
}

// lib/core/network/interceptors/logging_interceptor.dart
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  final bool logHeaders;
  final bool logBody;
  final bool logResponseData;

  LoggingInterceptor({
    this.logHeaders = true,
    this.logBody = true,
    this.logResponseData = false, // Set to false in production for large responses
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logRequest(options);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    developer.log(
      '➡️ ${options.method} ${options.uri}',
      name: 'HTTP Request',
    );

    if (logHeaders && options.headers.isNotEmpty) {
      developer.log(
        'Headers: ${_formatHeaders(options.headers)}',
        name: 'HTTP Request',
      );
    }

    if (logBody && options.data != null) {
      developer.log(
        'Body: ${_formatData(options.data)}',
        name: 'HTTP Request',
      );
    }
  }

  void _logResponse(Response response) {
    final statusCode = response.statusCode;
    final method = response.requestOptions.method;
    final uri = response.requestOptions.uri;

    developer.log(
      '⬅️ $statusCode $method $uri',
      name: 'HTTP Response',
    );

    if (logHeaders && response.headers.map.isNotEmpty) {
      developer.log(
        'Headers: ${_formatHeaders(response.headers.map)}',
        name: 'HTTP Response',
      );
    }

    if (logResponseData && response.data != null) {
      developer.log(
        'Data: ${_formatData(response.data)}',
        name: 'HTTP Response',
      );
    }
  }

  void _logError(DioException err) {
    developer.log(
      '❌ ${err.type} ${err.requestOptions.method} ${err.requestOptions.uri}',
      name: 'HTTP Error',
      error: err,
    );

    if (err.response != null) {
      developer.log(
        'Status: ${err.response?.statusCode}',
        name: 'HTTP Error',
      );
      
      if (err.response?.data != null) {
        developer.log(
          'Error Data: ${_formatData(err.response?.data)}',
          name: 'HTTP Error',
        );
      }
    }
  }

  String _formatHeaders(Map<String, dynamic> headers) {
    final sanitizedHeaders = Map<String, dynamic>.from(headers);
    
    // Remove sensitive headers
    sanitizedHeaders.remove('authorization');
    sanitizedHeaders.remove('cookie');
    sanitizedHeaders.remove('x-api-key');
    
    return sanitizedHeaders.toString();
  }

  String _formatData(dynamic data) {
    if (data is String) {
      return data.length > 1000 ? '${data.substring(0, 1000)}...' : data;
    }
    
    final dataString = data.toString();
    return dataString.length > 1000 ? '${dataString.substring(0, 1000)}...' : dataString;
  }
}
```

### **Step 4: News API Service with Retrofit Pattern** ⏱️ *40 minutes*

Implement the news API service using clean Retrofit patterns:

```dart
// lib/data/models/article.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'source.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    String? id,
    required String title,
    String? description,
    String? content,
    required String url,
    String? urlToImage,
    required DateTime publishedAt,
    required Source source,
    String? author,
    @Default([]) List<String> categories,
    @Default(0) int readTime,
    @Default(false) bool isBookmarked,
    @Default(false) bool isRead,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}

// lib/data/models/source.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'source.freezed.dart';
part 'source.g.dart';

@freezed
class Source with _$Source {
  const factory Source({
    String? id,
    required String name,
    String? description,
    String? url,
    String? category,
    String? language,
    String? country,
  }) = _Source;

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}

// lib/data/models/news_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'article.dart';

part 'news_response.freezed.dart';
part 'news_response.g.dart';

@freezed
class NewsResponse with _$NewsResponse {
  const factory NewsResponse({
    required String status,
    required int totalResults,
    required List<Article> articles,
    String? nextPageToken,
    @Default(1) int currentPage,
    @Default(20) int pageSize,
  }) = _NewsResponse;

  factory NewsResponse.fromJson(Map<String, dynamic> json) => _$NewsResponseFromJson(json);
}

// lib/data/services/news_api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/news_response.dart';
import '../models/article.dart';
import '../models/source.dart';

part 'news_api_service.g.dart';

@RestApi()
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl}) = _NewsApiService;

  // Top Headlines
  @GET('/top-headlines')
  Future<NewsResponse> getTopHeadlines({
    @Query('country') String? country,
    @Query('category') String? category,
    @Query('sources') String? sources,
    @Query('q') String? query,
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  // Everything endpoint for search
  @GET('/everything')
  Future<NewsResponse> searchArticles({
    @Query('q') required String query,
    @Query('searchIn') String? searchIn,
    @Query('sources') String? sources,
    @Query('domains') String? domains,
    @Query('excludeDomains') String? excludeDomains,
    @Query('from') String? fromDate,
    @Query('to') String? toDate,
    @Query('language') String? language,
    @Query('sortBy') String? sortBy,
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  // Sources
  @GET('/sources')
  Future<SourcesResponse> getSources({
    @Query('category') String? category,
    @Query('language') String? language,
    @Query('country') String? country,
  });

  // Category-specific endpoints
  @GET('/top-headlines')
  Future<NewsResponse> getBusinessNews({
    @Query('country') String? country = 'us',
    @Query('category') String category = 'business',
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  @GET('/top-headlines')
  Future<NewsResponse> getTechnologyNews({
    @Query('country') String? country = 'us',
    @Query('category') String category = 'technology',
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  @GET('/top-headlines')
  Future<NewsResponse> getSportsNews({
    @Query('country') String? country = 'us',
    @Query('category') String category = 'sports',
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  @GET('/top-headlines')
  Future<NewsResponse> getHealthNews({
    @Query('country') String? country = 'us',
    @Query('category') String category = 'health',
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  // Trending topics
  @GET('/everything')
  Future<NewsResponse> getTrendingNews({
    @Query('q') String query = 'trending',
    @Query('sortBy') String sortBy = 'popularity',
    @Query('from') String? fromDate,
    @Query('language') String language = 'en',
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  // Personalized recommendations (if API supports it)
  @POST('/recommendations')
  Future<NewsResponse> getPersonalizedNews(
    @Body() Map<String, dynamic> preferences,
  );
}

@freezed
class SourcesResponse with _$SourcesResponse {
  const factory SourcesResponse({
    required String status,
    required List<Source> sources,
  }) = _SourcesResponse;

  factory SourcesResponse.fromJson(Map<String, dynamic> json) => _$SourcesResponseFromJson(json);
}

// lib/data/services/base_api_service.dart
import 'package:dio/dio.dart';
import '../../core/errors/api_exceptions.dart';
import '../../core/network/api_response.dart';

abstract class BaseApiService {
  Future<ApiResponse<T>> handleRequest<T>(
    Future<T> request,
  ) async {
    try {
      final result = await request;
      return ApiResponse.success(result);
    } on ApiException catch (e) {
      return ApiResponse.error(e);
    } catch (e) {
      return ApiResponse.error(
        UnknownException(
          message: 'Unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  Future<ApiResponse<List<T>>> handleListRequest<T>(
    Future<List<T>> request,
  ) async {
    try {
      final result = await request;
      return ApiResponse.success(result);
    } on ApiException catch (e) {
      return ApiResponse.error(e);
    } catch (e) {
      return ApiResponse.error(
        UnknownException(
          message: 'Unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }
}

// lib/data/services/news_service.dart - High-level service wrapper
class NewsService extends BaseApiService {
  final NewsApiService _apiService;

  NewsService(this._apiService);

  Future<ApiResponse<NewsResponse>> getTopHeadlines({
    String? country,
    String? category,
    String? sources,
    String? query,
    int page = 1,
    int pageSize = 20,
  }) {
    return handleRequest(
      _apiService.getTopHeadlines(
        country: country,
        category: category,
        sources: sources,
        query: query,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  Future<ApiResponse<NewsResponse>> searchArticles({
    required String query,
    String? searchIn,
    String? sources,
    String? domains,
    String? excludeDomains,
    DateTime? fromDate,
    DateTime? toDate,
    String? language,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) {
    return handleRequest(
      _apiService.searchArticles(
        query: query,
        searchIn: searchIn,
        sources: sources,
        domains: domains,
        excludeDomains: excludeDomains,
        fromDate: fromDate?.toIso8601String().split('T')[0],
        toDate: toDate?.toIso8601String().split('T')[0],
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  Future<ApiResponse<SourcesResponse>> getSources({
    String? category,
    String? language,
    String? country,
  }) {
    return handleRequest(
      _apiService.getSources(
        category: category,
        language: language,
        country: country,
      ),
    );
  }

  Future<ApiResponse<NewsResponse>> getNewsByCategory(
    NewsCategory category, {
    String? country,
    int page = 1,
    int pageSize = 20,
  }) {
    switch (category) {
      case NewsCategory.business:
        return handleRequest(_apiService.getBusinessNews(
          country: country,
          page: page,
          pageSize: pageSize,
        ));
      case NewsCategory.technology:
        return handleRequest(_apiService.getTechnologyNews(
          country: country,
          page: page,
          pageSize: pageSize,
        ));
      case NewsCategory.sports:
        return handleRequest(_apiService.getSportsNews(
          country: country,
          page: page,
          pageSize: pageSize,
        ));
      case NewsCategory.health:
        return handleRequest(_apiService.getHealthNews(
          country: country,
          page: page,
          pageSize: pageSize,
        ));
      default:
        return getTopHeadlines(
          country: country,
          category: category.name,
          page: page,
          pageSize: pageSize,
        );
    }
  }

  Future<ApiResponse<NewsResponse>> getTrendingNews({
    DateTime? fromDate,
    String language = 'en',
    int page = 1,
    int pageSize = 20,
  }) {
    return handleRequest(
      _apiService.getTrendingNews(
        fromDate: fromDate?.toIso8601String().split('T')[0],
        language: language,
        page: page,
        pageSize: pageSize,
      ),
    );
  }
}

enum NewsCategory {
  general,
  business,
  entertainment,
  health,
  science,
  sports,
  technology,
}
```

*This is part 1 of the workshop. Continue with repository implementation, caching, UI components, and testing...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_16

# Install dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build

# Set up API key (create .env file)
echo "NEWS_API_KEY=your_api_key_here" > .env

# Run the app
flutter run

# Test networking functionality
# 1. Browse news articles with caching
# 2. Test offline functionality
# 3. Search and filter articles
# 4. Experience retry logic with poor connection
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Advanced Dio Configuration** - Interceptors, timeouts, and error handling
- **Retrofit Pattern Implementation** - Clean API service organization
- **Error Handling Excellence** - Comprehensive error management strategies
- **Caching and Offline Support** - Intelligent caching with background sync
- **Authentication Integration** - Token management with automatic refresh
- **Testing Strategies** - Mock services and comprehensive test coverage

**Ready to build robust networking layers that handle real-world API challenges with professional patterns! 🌐✨**