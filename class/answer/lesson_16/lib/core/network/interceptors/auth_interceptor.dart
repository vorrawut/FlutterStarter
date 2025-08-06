import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for login/register endpoints
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }

    final token = await _getStoredToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      final refreshed = await _attemptTokenRefresh();
      
      if (refreshed) {
        // Retry the original request with new token
        final cloneReq = await _cloneRequest(err.requestOptions);
        try {
          final response = await err.requestOptions.dio.fetch(cloneReq);
          return handler.resolve(response);
        } catch (e) {
          // If retry also fails, continue with original error
        }
      } else {
        // Refresh failed, clear tokens and redirect to login
        await _clearTokens();
        // Note: In a real app, you'd trigger a navigation to login here
      }
    }

    return handler.next(err);
  }

  bool _shouldSkipAuth(String path) {
    final authSkipPaths = [
      ApiConstants.login,
      ApiConstants.register,
      ApiConstants.refreshToken,
      '/public',
    ];
    
    return authSkipPaths.any((skipPath) => path.contains(skipPath));
  }

  Future<String?> _getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<bool> _attemptTokenRefresh() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;

      // Create a new Dio instance to avoid interceptor loops
      final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.authBaseUrl,
        headers: {'Content-Type': 'application/json'},
      ));

      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access_token'] as String?;
        final newRefreshToken = response.data['refresh_token'] as String?;

        if (newToken != null) {
          await _storeTokens(newToken, newRefreshToken);
          return true;
        }
      }
    } catch (e) {
      // Refresh failed
    }

    return false;
  }

  Future<void> _storeTokens(String token, String? refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      
      if (refreshToken != null) {
        await prefs.setString(_refreshTokenKey, refreshToken);
      }
    } catch (e) {
      // Handle storage error
    }
  }

  Future<void> _clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
    } catch (e) {
      // Handle storage error
    }
  }

  Future<RequestOptions> _cloneRequest(RequestOptions options) async {
    final token = await _getStoredToken();
    
    return options.copyWith(
      headers: {
        ...options.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // Public methods for token management
  static Future<void> storeAuthTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, accessToken);
      
      if (refreshToken != null) {
        await prefs.setString(_refreshTokenKey, refreshToken);
      }
    } catch (e) {
      // Handle storage error
    }
  }

  static Future<void> clearAuthTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
    } catch (e) {
      // Handle storage error
    }
  }

  static Future<bool> hasValidToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}