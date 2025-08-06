import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/cache_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class DioConfig {
  static Dio createDio({String? baseUrl}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: ApiConstants.defaultHeaders,
      validateStatus: (status) {
        // Accept all status codes to handle them in interceptors
        return status != null && status < 500;
      },
    ));

    // Add interceptors in order of priority
    _addInterceptors(dio);

    return dio;
  }

  static void _addInterceptors(Dio dio) {
    // 1. Request ID interceptor (first to add ID to all requests)
    dio.interceptors.add(_RequestIdInterceptor());

    // 2. Auth interceptor (add auth headers before request)
    dio.interceptors.add(AuthInterceptor());

    // 3. Cache interceptor (check cache before request)
    dio.interceptors.add(CacheInterceptor());

    // 4. Retry interceptor (retry failed requests)
    dio.interceptors.add(RetryInterceptor());

    // 5. Error interceptor (transform errors)
    dio.interceptors.add(ErrorInterceptor());

    // 6. Logging interceptor (last to log everything)
    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }
  }

  static Dio createAuthDio() {
    return createDio(baseUrl: ApiConstants.authBaseUrl);
  }

  static Dio createNewsDio() {
    final dio = createDio(baseUrl: ApiConstants.baseUrl);
    
    // Add News API specific configuration
    dio.options.headers['X-API-Key'] = ApiConstants.newsApiKey;
    
    return dio;
  }

  static Dio createMockDio() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://mock.api.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));

    // Only add essential interceptors for testing
    dio.interceptors.add(_RequestIdInterceptor());
    if (kDebugMode) {
      dio.interceptors.add(LoggingInterceptor());
    }

    return dio;
  }
}

class _RequestIdInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add unique request ID for tracking
    options.headers[ApiConstants.requestIdHeader] = 
        '${DateTime.now().millisecondsSinceEpoch}-${options.hashCode}';
    
    super.onRequest(options, handler);
  }
}