# 🌐 Lesson 16: Networking with Dio & Retrofit - Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **HTTP Networking Fundamentals** - Understanding REST APIs, HTTP methods, status codes, and headers
- **Dio Library Mastery** - Leveraging Dio's powerful features for HTTP networking in Flutter
- **Retrofit Pattern Implementation** - Organizing API clients with clean, maintainable patterns
- **Error Handling Strategies** - Comprehensive error management for network operations
- **Interceptor Architecture** - Middleware for logging, authentication, and request transformation
- **Caching and Offline Support** - Implementing intelligent caching and offline-first strategies
- **Clean Architecture Integration** - Applying clean architecture principles to networking layers

## 📚 **HTTP Networking Fundamentals**

### **Understanding REST APIs**

RESTful APIs (Representational State Transfer) are the backbone of modern web communication:

```dart
// HTTP Methods and Their Purpose
GET     /api/users          // Retrieve a list of users
GET     /api/users/123      // Retrieve a specific user
POST    /api/users          // Create a new user
PUT     /api/users/123      // Update an entire user
PATCH   /api/users/123      // Partially update a user
DELETE  /api/users/123      // Delete a user

// HTTP Status Codes
200 OK                      // Request successful
201 Created                 // Resource created successfully
204 No Content              // Request successful, no content to return
400 Bad Request             // Invalid request syntax
401 Unauthorized            // Authentication required
403 Forbidden               // Access denied
404 Not Found               // Resource not found
429 Too Many Requests       // Rate limit exceeded
500 Internal Server Error   // Server error
502 Bad Gateway             // Invalid response from upstream server
503 Service Unavailable     // Server temporarily unavailable
```

### **HTTP Headers and Authentication**

Headers provide metadata about requests and responses:

```dart
// Common Request Headers
{
  'Content-Type': 'application/json',
  'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  'Accept': 'application/json',
  'User-Agent': 'MyFlutterApp/1.0.0',
  'Accept-Language': 'en-US,en;q=0.9',
  'Cache-Control': 'no-cache',
  'X-API-Key': 'your-api-key-here'
}

// Authentication Strategies
Bearer Token:     Authorization: Bearer <token>
API Key:          X-API-Key: <key> or api_key=<key>
Basic Auth:       Authorization: Basic <base64(username:password)>
Custom Header:    X-Auth-Token: <token>
```

## 🚀 **Dio Library Deep Dive**

### **Why Dio Over http Package?**

Dio provides significant advantages over Flutter's built-in http package:

```dart
// Dio Advantages
✅ Interceptors for request/response transformation
✅ Built-in error handling and retry mechanisms
✅ Request and response transformation
✅ Concurrent request management
✅ File upload/download with progress tracking
✅ Certificate pinning for security
✅ Comprehensive caching support
✅ FormData support for multipart requests
✅ Timeout configuration and cancellation
✅ Mock adapter for testing

// Basic Dio Setup
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  sendTimeout: const Duration(seconds: 10),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
));
```

### **Dio Configuration and Options**

Comprehensive Dio configuration for production applications:

```dart
class DioConfig {
  static Dio createDio({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? headers,
    bool enableLogging = false,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      sendTimeout: sendTimeout ?? const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      },
      validateStatus: (status) {
        // Accept all status codes for custom error handling
        return status != null && status < 500;
      },
    ));

    // Add interceptors
    if (enableLogging) {
      dio.interceptors.add(_createLoggingInterceptor());
    }
    
    dio.interceptors.add(_createAuthInterceptor());
    dio.interceptors.add(_createErrorInterceptor());
    dio.interceptors.add(_createRetryInterceptor());
    
    return dio;
  }

  static LogInterceptor _createLoggingInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
      logPrint: (object) {
        // Custom logging implementation
        log(object.toString(), name: 'DioLogger');
      },
    );
  }
}
```

### **Request Types and Methods**

Comprehensive request implementation with Dio:

```dart
class ApiService {
  final Dio _dio;
  
  ApiService(this._dio);

  // GET Request with Query Parameters
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

  // POST Request with Body
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

  // PUT Request for Full Updates
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

  // PATCH Request for Partial Updates
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
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

  // DELETE Request
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

  // File Upload with Progress
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // File Download with Progress
  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
```

## 🔧 **Interceptor Architecture**

### **Authentication Interceptor**

Automatically handle authentication for all requests:

```dart
class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;
  final Dio _dio;

  AuthInterceptor(this._authRepository, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add authentication token to requests
    final token = await _authRepository.getAccessToken();
    if (token != null && !_isPublicEndpoint(options.path)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Add API key if required
    if (_requiresApiKey(options.path)) {
      options.headers['X-API-Key'] = ApiConstants.apiKey;
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token expiration
    if (err.response?.statusCode == 401) {
      await _handleTokenExpiration(err, handler);
    } else {
      handler.next(err);
    }
  }

  Future<void> _handleTokenExpiration(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      // Attempt to refresh token
      final refreshed = await _authRepository.refreshToken();
      
      if (refreshed) {
        // Retry the original request with new token
        final token = await _authRepository.getAccessToken();
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $token';
        
        final response = await _dio.fetch(options);
        handler.resolve(response);
      } else {
        // Refresh failed, logout user
        await _authRepository.logout();
        handler.next(err);
      }
    } catch (e) {
      // Refresh failed, logout user
      await _authRepository.logout();
      handler.next(err);
    }
  }

  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/public/',
    ];
    return publicEndpoints.any((endpoint) => path.startsWith(endpoint));
  }

  bool _requiresApiKey(String path) {
    // Define which endpoints require API keys
    return !path.startsWith('/auth/');
  }
}
```

### **Retry Interceptor**

Implement intelligent retry logic for failed requests:

```dart
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryStatusCodes = const [502, 503, 504],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);
    
    if (shouldRetry) {
      final attempt = _getAttemptCount(err.requestOptions);
      
      if (attempt < maxRetries) {
        await _delay(attempt);
        
        try {
          // Increment attempt count
          err.requestOptions.extra['retryAttempt'] = attempt + 1;
          
          // Retry the request
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Retry failed, continue with original error
        }
      }
    }
    
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry on network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }
    
    // Retry on specific status codes
    if (err.response?.statusCode != null) {
      return retryStatusCodes.contains(err.response!.statusCode);
    }
    
    return false;
  }

  int _getAttemptCount(RequestOptions options) {
    return options.extra['retryAttempt'] ?? 0;
  }

  Future<void> _delay(int attempt) async {
    // Exponential backoff: 1s, 2s, 4s, etc.
    final delay = Duration(
      milliseconds: (retryDelay.inMilliseconds * math.pow(2, attempt)).round(),
    );
    await Future.delayed(delay);
  }
}
```

### **Caching Interceptor**

Implement intelligent response caching:

```dart
class CacheInterceptor extends Interceptor {
  final CacheService _cacheService;
  final Duration defaultCacheDuration;

  CacheInterceptor(
    this._cacheService, {
    this.defaultCacheDuration = const Duration(minutes: 5),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      handler.next(options);
      return;
    }

    final cacheKey = _generateCacheKey(options);
    final cachedResponse = await _cacheService.get(cacheKey);
    
    if (cachedResponse != null && !_isCacheExpired(cachedResponse)) {
      // Return cached response
      final response = Response<dynamic>(
        requestOptions: options,
        data: cachedResponse.data,
        statusCode: cachedResponse.statusCode,
        headers: Headers.fromMap(cachedResponse.headers),
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
        response.statusCode == 200) {
      
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
        ),
      );
    }
    
    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final headers = options.headers.toString();
    return '$uri#$headers'.hashCode.toString();
  }

  Duration _getCacheDuration(RequestOptions options) {
    // Check for custom cache duration in options
    final customDuration = options.extra['cacheDuration'] as Duration?;
    return customDuration ?? defaultCacheDuration;
  }

  bool _isCacheExpired(CachedResponse cachedResponse) {
    return DateTime.now().isAfter(cachedResponse.expiresAt);
  }
}
```

## 🏗️ **Retrofit Pattern Implementation**

### **Clean API Service Organization**

Organize API endpoints using the Retrofit pattern for maintainability:

```dart
// Base API Service
abstract class BaseApiService {
  Future<ApiResponse<T>> handleRequest<T>(
    Future<Response> request,
    T Function(Map<String, dynamic>) fromJson,
  );
  
  Future<ApiResponse<List<T>>> handleListRequest<T>(
    Future<Response> request,
    T Function(Map<String, dynamic>) fromJson,
  );
}

class BaseApiServiceImpl implements BaseApiService {
  final ApiService _apiService;
  
  BaseApiServiceImpl(this._apiService);

  @override
  Future<ApiResponse<T>> handleRequest<T>(
    Future<Response> request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await request;
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = fromJson(response.data);
        return ApiResponse.success(data);
      } else {
        return ApiResponse.error(
          ApiError.fromResponse(response),
        );
      }
    } on ApiException catch (e) {
      return ApiResponse.error(e);
    } catch (e) {
      return ApiResponse.error(
        ApiError(
          message: 'Unexpected error occurred',
          code: 'UNKNOWN_ERROR',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<List<T>>> handleListRequest<T>(
    Future<Response> request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await request;
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'] ?? response.data;
        final data = jsonList
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList();
        
        return ApiResponse.success(data);
      } else {
        return ApiResponse.error(
          ApiError.fromResponse(response),
        );
      }
    } on ApiException catch (e) {
      return ApiResponse.error(e);
    } catch (e) {
      return ApiResponse.error(
        ApiError(
          message: 'Unexpected error occurred',
          code: 'UNKNOWN_ERROR',
          statusCode: 500,
        ),
      );
    }
  }
}

// User API Service
abstract class UserApiService extends BaseApiService {
  Future<ApiResponse<User>> getCurrentUser();
  Future<ApiResponse<User>> getUserById(String id);
  Future<ApiResponse<List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  });
  Future<ApiResponse<User>> updateUser(String id, UpdateUserRequest request);
  Future<ApiResponse<void>> deleteUser(String id);
}

class UserApiServiceImpl extends BaseApiServiceImpl implements UserApiService {
  UserApiServiceImpl(super.apiService);

  @override
  Future<ApiResponse<User>> getCurrentUser() {
    return handleRequest(
      _apiService.get('/users/me'),
      (json) => User.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<User>> getUserById(String id) {
    return handleRequest(
      _apiService.get('/users/$id'),
      (json) => User.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) {
    return handleListRequest(
      _apiService.get('/users', queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
      }),
      (json) => User.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<User>> updateUser(String id, UpdateUserRequest request) {
    return handleRequest(
      _apiService.put('/users/$id', data: request.toJson()),
      (json) => User.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> deleteUser(String id) async {
    try {
      final response = await _apiService.delete('/users/$id');
      
      if (response.statusCode == 204 || response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error(ApiError.fromResponse(response));
      }
    } on ApiException catch (e) {
      return ApiResponse.error(e);
    } catch (e) {
      return ApiResponse.error(
        ApiError(
          message: 'Failed to delete user',
          code: 'DELETE_FAILED',
          statusCode: 500,
        ),
      );
    }
  }
}
```

### **API Response Wrapper**

Standardize API responses for consistent error handling:

```dart
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success(T data) = ApiSuccess<T>;
  const factory ApiResponse.error(ApiError error) = ApiFailure<T>;
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) = _$ApiResponseFromJson<T>;
}

extension ApiResponseExtension<T> on ApiResponse<T> {
  bool get isSuccess => this is ApiSuccess<T>;
  bool get isError => this is ApiFailure<T>;
  
  T? get dataOrNull => when(
    success: (data) => data,
    error: (_) => null,
  );
  
  ApiError? get errorOrNull => when(
    success: (_) => null,
    error: (error) => error,
  );
  
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiError error) error,
  }) {
    if (this is ApiSuccess<T>) {
      return success((this as ApiSuccess<T>).data);
    } else {
      return error((this as ApiFailure<T>).error);
    }
  }
}

@freezed
class ApiError with _$ApiError implements Exception {
  const factory ApiError({
    required String message,
    required String code,
    required int statusCode,
    Map<String, dynamic>? details,
    @Default([]) List<ValidationError> validationErrors,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);
  
  factory ApiError.fromResponse(Response response) {
    final data = response.data;
    
    if (data is Map<String, dynamic>) {
      return ApiError(
        message: data['message'] ?? 'An error occurred',
        code: data['code'] ?? 'UNKNOWN_ERROR',
        statusCode: response.statusCode ?? 500,
        details: data['details'],
        validationErrors: (data['validation_errors'] as List?)
            ?.map((e) => ValidationError.fromJson(e))
            .toList() ?? [],
      );
    } else {
      return ApiError(
        message: data?.toString() ?? 'An error occurred',
        code: 'UNKNOWN_ERROR',
        statusCode: response.statusCode ?? 500,
      );
    }
  }
  
  factory ApiError.networkError() {
    return const ApiError(
      message: 'Network connection failed',
      code: 'NETWORK_ERROR',
      statusCode: 0,
    );
  }
  
  factory ApiError.timeout() {
    return const ApiError(
      message: 'Request timeout',
      code: 'TIMEOUT_ERROR',
      statusCode: 408,
    );
  }
}

@freezed
class ValidationError with _$ValidationError {
  const factory ValidationError({
    required String field,
    required String message,
    String? code,
  }) = _ValidationError;

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);
}
```

## 🔄 **Clean Architecture Integration**

### **Repository Pattern for Networking**

Implement the repository pattern to abstract API details:

```dart
// Domain Repository Interface
abstract class UserRepository {
  Future<Result<User>> getCurrentUser();
  Future<Result<User>> getUserById(String id);
  Future<Result<List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  });
  Future<Result<User>> updateUser(String id, UpdateUserRequest request);
  Future<Result<void>> deleteUser(String id);
}

// Data Repository Implementation
class UserRepositoryImpl implements UserRepository {
  final UserApiService _apiService;
  final UserLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl(
    this._apiService,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _apiService.getCurrentUser();
        
        return response.when(
          success: (user) async {
            // Cache user data locally
            await _localDataSource.cacheUser(user);
            return Result.success(user);
          },
          error: (error) => Result.failure(error),
        );
      } else {
        // Return cached data when offline
        final cachedUser = await _localDataSource.getCachedCurrentUser();
        if (cachedUser != null) {
          return Result.success(cachedUser);
        } else {
          return Result.failure(
            ApiError.networkError(),
          );
        }
      }
    } catch (e) {
      return Result.failure(
        ApiError(
          message: e.toString(),
          code: 'REPOSITORY_ERROR',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Result<List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _apiService.getUsers(
          page: page,
          limit: limit,
          search: search,
        );
        
        return response.when(
          success: (users) async {
            // Cache users data locally
            await _localDataSource.cacheUsers(users, page);
            return Result.success(users);
          },
          error: (error) => Result.failure(error),
        );
      } else {
        // Return cached data when offline
        final cachedUsers = await _localDataSource.getCachedUsers(page);
        if (cachedUsers.isNotEmpty) {
          return Result.success(cachedUsers);
        } else {
          return Result.failure(ApiError.networkError());
        }
      }
    } catch (e) {
      return Result.failure(
        ApiError(
          message: e.toString(),
          code: 'REPOSITORY_ERROR',
          statusCode: 500,
        ),
      );
    }
  }
}

// Use Case Implementation
class GetCurrentUserUseCase {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Result<User>> execute() async {
    return await _repository.getCurrentUser();
  }
}

class GetUsersUseCase {
  final UserRepository _repository;

  GetUsersUseCase(this._repository);

  Future<Result<List<User>>> execute({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    // Add business logic here if needed
    if (limit <= 0 || limit > 100) {
      return Result.failure(
        ApiError(
          message: 'Limit must be between 1 and 100',
          code: 'INVALID_LIMIT',
          statusCode: 400,
        ),
      );
    }
    
    return await _repository.getUsers(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
```

## 📱 **Offline Support and Caching**

### **Cache Strategy Implementation**

Implement intelligent caching for offline support:

```dart
class CacheService {
  final HiveInterface _hive;
  late Box<CachedResponse> _cacheBox;
  
  CacheService(this._hive);

  Future<void> init() async {
    _cacheBox = await _hive.openBox<CachedResponse>('api_cache');
  }

  Future<CachedResponse?> get(String key) async {
    final cached = _cacheBox.get(key);
    
    if (cached != null && !_isExpired(cached)) {
      return cached;
    } else {
      // Remove expired cache
      await _cacheBox.delete(key);
      return null;
    }
  }

  Future<void> put(String key, CachedResponse response) async {
    await _cacheBox.put(key, response);
  }

  Future<void> clear() async {
    await _cacheBox.clear();
  }

  Future<void> clearExpired() async {
    final expiredKeys = <String>[];
    
    for (final entry in _cacheBox.toMap().entries) {
      if (_isExpired(entry.value)) {
        expiredKeys.add(entry.key);
      }
    }
    
    await _cacheBox.deleteAll(expiredKeys);
  }

  bool _isExpired(CachedResponse cached) {
    return DateTime.now().isAfter(cached.expiresAt);
  }
}

@HiveType(typeId: 0)
class CachedResponse {
  @HiveField(0)
  final dynamic data;
  
  @HiveField(1)
  final int statusCode;
  
  @HiveField(2)
  final Map<String, List<String>> headers;
  
  @HiveField(3)
  final DateTime cachedAt;
  
  @HiveField(4)
  final DateTime expiresAt;

  CachedResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
    required this.cachedAt,
    required this.expiresAt,
  });
}
```

## 🧪 **Testing Network Code**

### **Mock Implementation and Testing**

Comprehensive testing strategies for network code:

```dart
// Mock API Service for Testing
class MockUserApiService implements UserApiService {
  final List<User> _users = [];
  bool _shouldFail = false;
  
  void setShouldFail(bool shouldFail) {
    _shouldFail = shouldFail;
  }

  @override
  Future<ApiResponse<User>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_shouldFail) {
      return ApiResponse.error(
        ApiError.networkError(),
      );
    }
    
    return ApiResponse.success(
      User(id: '1', name: 'Test User', email: 'test@example.com'),
    );
  }

  @override
  Future<ApiResponse<List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_shouldFail) {
      return ApiResponse.error(
        ApiError.networkError(),
      );
    }
    
    var filteredUsers = _users;
    
    if (search != null && search.isNotEmpty) {
      filteredUsers = _users
          .where((user) =>
              user.name.toLowerCase().contains(search.toLowerCase()) ||
              user.email.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    
    final startIndex = (page - 1) * limit;
    final endIndex = math.min(startIndex + limit, filteredUsers.length);
    
    if (startIndex >= filteredUsers.length) {
      return ApiResponse.success([]);
    }
    
    return ApiResponse.success(
      filteredUsers.sublist(startIndex, endIndex),
    );
  }
}

// Repository Testing
void main() {
  group('UserRepository', () {
    late UserRepository repository;
    late MockUserApiService mockApiService;
    late MockUserLocalDataSource mockLocalDataSource;
    late MockNetworkInfo mockNetworkInfo;

    setUp(() {
      mockApiService = MockUserApiService();
      mockLocalDataSource = MockUserLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      
      repository = UserRepositoryImpl(
        mockApiService,
        mockLocalDataSource,
        mockNetworkInfo,
      );
    });

    test('should return user when network is available', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      
      // Act
      final result = await repository.getCurrentUser();
      
      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data?.id, equals('1'));
    });

    test('should return cached user when network is unavailable', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);
      mockLocalDataSource.setCachedUser(
        User(id: '1', name: 'Cached User', email: 'cached@example.com'),
      );
      
      // Act
      final result = await repository.getCurrentUser();
      
      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data?.name, equals('Cached User'));
    });

    test('should return error when network fails and no cache', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);
      mockLocalDataSource.setCachedUser(null);
      
      // Act
      final result = await repository.getCurrentUser();
      
      // Assert
      expect(result.isFailure, isTrue);
      expect(result.error?.code, equals('NETWORK_ERROR'));
    });
  });
}
```

## 🌟 **Best Practices Summary**

### **1. Configuration Management**
- Use environment-specific configurations
- Centralize timeout and retry settings
- Implement proper SSL certificate pinning
- Use API versioning strategies

### **2. Error Handling**
- Implement comprehensive error mapping
- Use retry strategies for transient failures
- Provide meaningful error messages to users
- Log errors appropriately for debugging

### **3. Performance Optimization**
- Implement intelligent caching strategies
- Use connection pooling and keep-alive
- Minimize request payload size
- Implement pagination for large datasets

### **4. Security Considerations**
- Never log sensitive information
- Implement proper authentication handling
- Use HTTPS for all communications
- Validate all input data

### **5. Testing Strategy**
- Mock external dependencies for unit tests
- Test both success and failure scenarios
- Use integration tests for critical flows
- Implement contract testing for API changes

### **6. Monitoring and Analytics**
- Track API response times
- Monitor error rates and types
- Implement user experience analytics
- Use crash reporting for debugging

The comprehensive networking foundation provided by Dio, combined with clean architecture principles and robust error handling, creates a solid foundation for building reliable, scalable Flutter applications that gracefully handle the complexities of modern API integration.

**Ready to build bulletproof networking layers that handle real-world challenges with elegance and reliability! 🌐✨**