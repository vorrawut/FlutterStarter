import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../../constants/api_constants.dart';

class CacheInterceptor extends Interceptor {
  final Duration maxAge;
  final Duration staleTime;
  final int maxCacheSize;

  CacheInterceptor({
    this.maxAge = ApiConstants.cacheMaxAge,
    this.staleTime = ApiConstants.cacheStaleTime,
    this.maxCacheSize = ApiConstants.maxCacheSize,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    // Check if request explicitly disables cache
    if (options.headers['Cache-Control'] == 'no-cache') {
      return handler.next(options);
    }

    final cacheKey = _generateCacheKey(options);
    final cachedResponse = await _getCachedResponse(cacheKey);

    if (cachedResponse != null) {
      final age = DateTime.now().difference(cachedResponse.timestamp);
      
      if (age <= maxAge) {
        // Cache is fresh, return cached response
        final response = Response<dynamic>(
          data: cachedResponse.data,
          statusCode: cachedResponse.statusCode,
          statusMessage: cachedResponse.statusMessage,
          headers: Headers.fromMap(cachedResponse.headers),
          requestOptions: options,
          extra: {'from_cache': true, 'cache_age': age.inSeconds},
        );
        
        return handler.resolve(response);
      } else if (age <= staleTime) {
        // Cache is stale but within stale time, return stale data and update in background
        final response = Response<dynamic>(
          data: cachedResponse.data,
          statusCode: cachedResponse.statusCode,
          statusMessage: cachedResponse.statusMessage,
          headers: Headers.fromMap(cachedResponse.headers),
          requestOptions: options,
          extra: {'from_cache': true, 'cache_age': age.inSeconds, 'stale': true},
        );
        
        // Continue with request to update cache in background
        _updateCacheInBackground(options, cacheKey);
        
        return handler.resolve(response);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Only cache successful GET responses
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      
      final cacheKey = _generateCacheKey(response.requestOptions);
      await _storeCachedResponse(cacheKey, response);
    }

    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final headers = Map<String, dynamic>.from(options.headers);
    
    // Remove auth headers from cache key to allow sharing between users
    headers.remove('Authorization');
    headers.remove('X-API-Key');
    
    final keyData = {
      'uri': uri,
      'headers': headers,
      'queryParameters': options.queryParameters,
    };
    
    return _hashString(json.encode(keyData));
  }

  String _hashString(String input) {
    // Simple hash function for cache keys
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash + input.codeUnitAt(i)) & 0xffffffff;
    }
    return hash.abs().toString();
  }

  Future<CachedResponse?> _getCachedResponse(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cache_$key');
      
      if (cachedData != null) {
        final data = json.decode(cachedData);
        return CachedResponse.fromJson(data);
      }
    } catch (e) {
      // Cache read error, ignore
    }
    
    return null;
  }

  Future<void> _storeCachedResponse(String key, Response response) async {
    try {
      final cachedResponse = CachedResponse(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        statusMessage: response.statusMessage ?? 'OK',
        headers: response.headers.map,
        timestamp: DateTime.now(),
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cache_$key', json.encode(cachedResponse.toJson()));
      
      // Clean up old cache entries if needed
      await _cleanupCache();
    } catch (e) {
      // Cache write error, ignore
    }
  }

  Future<void> _updateCacheInBackground(RequestOptions options, String cacheKey) async {
    try {
      // Create a new dio instance to avoid interceptor loops
      final dio = Dio(BaseOptions(
        baseUrl: options.baseUrl,
        headers: options.headers,
      ));
      
      final response = await dio.fetch(options);
      await _storeCachedResponse(cacheKey, response);
    } catch (e) {
      // Background update failed, ignore
    }
  }

  Future<void> _cleanupCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_'));
      
      // Calculate total cache size (approximate)
      int totalSize = 0;
      final cacheEntries = <String, CachedResponse>{};
      
      for (final key in keys) {
        final cachedData = prefs.getString(key);
        if (cachedData != null) {
          totalSize += cachedData.length;
          try {
            final data = json.decode(cachedData);
            cacheEntries[key] = CachedResponse.fromJson(data);
          } catch (e) {
            // Invalid cache entry, mark for deletion
            await prefs.remove(key);
          }
        }
      }
      
      // If cache is too large, remove oldest entries
      if (totalSize > maxCacheSize) {
        final sortedEntries = cacheEntries.entries.toList()
          ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
        
        // Remove oldest entries until under limit
        for (final entry in sortedEntries) {
          await prefs.remove(entry.key);
          totalSize -= (prefs.getString(entry.key)?.length ?? 0);
          
          if (totalSize <= maxCacheSize * 0.8) break; // Leave some headroom
        }
      }
      
      // Remove expired entries
      final now = DateTime.now();
      for (final entry in cacheEntries.entries) {
        if (now.difference(entry.value.timestamp) > staleTime) {
          await prefs.remove(entry.key);
        }
      }
    } catch (e) {
      // Cleanup error, ignore
    }
  }

  // Public methods for cache management
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_'));
      
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Clear cache error, ignore
    }
  }

  static Future<int> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_'));
      
      int totalSize = 0;
      for (final key in keys) {
        final cachedData = prefs.getString(key);
        if (cachedData != null) {
          totalSize += cachedData.length;
        }
      }
      
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}

class CachedResponse {
  final dynamic data;
  final int statusCode;
  final String statusMessage;
  final Map<String, List<String>> headers;
  final DateTime timestamp;

  CachedResponse({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.headers,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'headers': headers,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CachedResponse.fromJson(Map<String, dynamic> json) {
    return CachedResponse(
      data: json['data'],
      statusCode: json['statusCode'] as int,
      statusMessage: json['statusMessage'] as String,
      headers: Map<String, List<String>>.from(
        (json['headers'] as Map).map(
          (key, value) => MapEntry(
            key.toString(),
            List<String>.from(value as List),
          ),
        ),
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}