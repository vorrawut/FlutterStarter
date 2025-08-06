import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../constants/api_constants.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryableStatusCodes;

  RetryInterceptor({
    this.maxRetries = ApiConstants.maxRetries,
    this.retryDelay = ApiConstants.retryDelay,
    this.retryableStatusCodes = const [408, 429, 500, 502, 503, 504],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (await _shouldRetry(err)) {
      final retryCount = _getRetryCount(err.requestOptions);
      
      if (retryCount < maxRetries) {
        await _incrementRetryCount(err.requestOptions);
        await _waitBeforeRetry(retryCount);
        
        try {
          // Check network connectivity before retry
          if (await _hasNetworkConnection()) {
            final response = await err.requestOptions.dio.fetch(err.requestOptions);
            return handler.resolve(response);
          } else {
            // No network, wait and try again
            await Future.delayed(const Duration(seconds: 2));
            if (await _hasNetworkConnection()) {
              final response = await err.requestOptions.dio.fetch(err.requestOptions);
              return handler.resolve(response);
            }
          }
        } catch (e) {
          // Retry failed, check if we should try again
          if (retryCount + 1 < maxRetries) {
            return onError(e is DioException ? e : DioException(
              requestOptions: err.requestOptions,
              error: e,
            ), handler);
          }
        }
      }
    }

    return handler.next(err);
  }

  Future<bool> _shouldRetry(DioException err) async {
    // Don't retry if it's a client error (4xx) except specific cases
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      
      // Don't retry client errors except rate limiting
      if (statusCode >= 400 && statusCode < 500 && statusCode != 408 && statusCode != 429) {
        return false;
      }
      
      return retryableStatusCodes.contains(statusCode);
    }

    // Retry on network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    return false;
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retry_count'] as int? ?? 0;
  }

  Future<void> _incrementRetryCount(RequestOptions options) async {
    final currentCount = _getRetryCount(options);
    options.extra['retry_count'] = currentCount + 1;
  }

  Future<void> _waitBeforeRetry(int retryCount) async {
    // Exponential backoff with jitter
    final baseDelay = retryDelay.inMilliseconds;
    final exponentialDelay = baseDelay * (1 << retryCount); // 2^retryCount
    final jitter = (exponentialDelay * 0.1).round(); // 10% jitter
    final finalDelay = exponentialDelay + (jitter * (0.5 - (retryCount % 2)));
    
    await Future.delayed(Duration(milliseconds: finalDelay.round()));
  }

  Future<bool> _hasNetworkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      // If we can't check connectivity, assume we have connection
      return true;
    }
  }
}