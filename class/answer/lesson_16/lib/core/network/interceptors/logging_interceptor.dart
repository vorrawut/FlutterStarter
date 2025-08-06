import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class LoggingInterceptor extends Interceptor {
  final bool logRequestHeaders;
  final bool logRequestBody;
  final bool logResponseHeaders;
  final bool logResponseBody;
  final bool logOnlyErrors;

  LoggingInterceptor({
    this.logRequestHeaders = true,
    this.logRequestBody = true,
    this.logResponseHeaders = false,
    this.logResponseBody = true,
    this.logOnlyErrors = false,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!logOnlyErrors) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!logOnlyErrors) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    final requestId = options.headers['X-Request-ID'] ?? 'unknown';
    
    print('');
    print('🌐 ╭── HTTP REQUEST ──────────────────────────────────');
    print('🌐 │ ID: $requestId');
    print('🌐 │ ${options.method.toUpperCase()} ${options.uri}');
    
    if (logRequestHeaders && options.headers.isNotEmpty) {
      print('🌐 │');
      print('🌐 │ Headers:');
      options.headers.forEach((key, value) {
        // Mask sensitive headers
        final displayValue = _maskSensitiveValue(key, value);
        print('🌐 │   $key: $displayValue');
      });
    }

    if (logRequestBody && options.data != null) {
      print('🌐 │');
      print('🌐 │ Body:');
      _printRequestBody(options.data);
    }
    
    print('🌐 ╰──────────────────────────────────────────────────');
    print('');
  }

  void _logResponse(Response response) {
    if (!kDebugMode) return;

    final requestId = response.requestOptions.headers['X-Request-ID'] ?? 'unknown';
    final fromCache = response.extra['from_cache'] == true;
    final cacheAge = response.extra['cache_age'] as int?;
    final isStale = response.extra['stale'] == true;
    
    print('');
    print('🌐 ╭── HTTP RESPONSE ─────────────────────────────────');
    print('🌐 │ ID: $requestId');
    print('🌐 │ ${response.statusCode} ${response.statusMessage}');
    print('🌐 │ ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');
    
    if (fromCache) {
      final ageText = cacheAge != null ? ' (${cacheAge}s old)' : '';
      final staleText = isStale ? ' [STALE]' : '';
      print('🌐 │ 💾 FROM CACHE$ageText$staleText');
    }
    
    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      print('🌐 │');
      print('🌐 │ Headers:');
      response.headers.map.forEach((key, value) {
        print('🌐 │   $key: ${value.join(', ')}');
      });
    }

    if (logResponseBody && response.data != null) {
      print('🌐 │');
      print('🌐 │ Body:');
      _printResponseBody(response.data);
    }
    
    print('🌐 ╰──────────────────────────────────────────────────');
    print('');
  }

  void _logError(DioException err) {
    if (!kDebugMode) return;

    final requestId = err.requestOptions.headers['X-Request-ID'] ?? 'unknown';
    
    print('');
    print('🔥 ╭── HTTP ERROR ────────────────────────────────────');
    print('🔥 │ ID: $requestId');
    print('🔥 │ ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}');
    print('🔥 │ Type: ${err.type}');
    
    if (err.response != null) {
      print('🔥 │ Status: ${err.response!.statusCode} ${err.response!.statusMessage}');
      
      if (err.response!.data != null) {
        print('🔥 │');
        print('🔥 │ Error Body:');
        _printResponseBody(err.response!.data);
      }
    } else {
      print('🔥 │ Message: ${err.message}');
    }
    
    print('🔥 ╰──────────────────────────────────────────────────');
    print('');
  }

  void _printRequestBody(dynamic data) {
    try {
      if (data is FormData) {
        print('🌐 │   [FormData]');
        data.fields.forEach((field) {
          final value = _maskSensitiveValue(field.key, field.value);
          print('🌐 │     ${field.key}: $value');
        });
        if (data.files.isNotEmpty) {
          print('🌐 │   Files: ${data.files.length}');
          data.files.forEach((file) {
            print('🌐 │     ${file.key}: ${file.value.filename} (${file.value.length} bytes)');
          });
        }
      } else if (data is Map) {
        final maskedData = Map.from(data);
        _maskSensitiveFields(maskedData);
        final prettyJson = const JsonEncoder.withIndent('  ').convert(maskedData);
        _printJsonWithPrefix(prettyJson, '🌐 │   ');
      } else if (data is String) {
        print('🌐 │   $data');
      } else {
        print('🌐 │   ${data.toString()}');
      }
    } catch (e) {
      print('🌐 │   [Unable to parse body: $e]');
    }
  }

  void _printResponseBody(dynamic data) {
    try {
      if (data is Map || data is List) {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(data);
        _printJsonWithPrefix(prettyJson, '🌐 │   ');
      } else if (data is String) {
        if (data.length > 1000) {
          print('🌐 │   ${data.substring(0, 1000)}...');
          print('🌐 │   [Response truncated - ${data.length} total characters]');
        } else {
          print('🌐 │   $data');
        }
      } else {
        print('🌐 │   ${data.toString()}');
      }
    } catch (e) {
      print('🌐 │   [Unable to parse response: $e]');
    }
  }

  void _printJsonWithPrefix(String json, String prefix) {
    final lines = json.split('\n');
    for (final line in lines) {
      print('$prefix$line');
    }
  }

  String _maskSensitiveValue(String key, dynamic value) {
    final sensitiveKeys = [
      'authorization',
      'auth',
      'token',
      'password',
      'secret',
      'key',
      'api_key',
      'apikey',
      'x-api-key',
    ];

    if (sensitiveKeys.any((sensitive) => 
        key.toLowerCase().contains(sensitive.toLowerCase()))) {
      if (value is String && value.isNotEmpty) {
        if (value.length <= 8) {
          return '***';
        } else {
          return '${value.substring(0, 4)}...${value.substring(value.length - 4)}';
        }
      }
      return '***';
    }

    return value.toString();
  }

  void _maskSensitiveFields(Map<String, dynamic> data) {
    final sensitiveKeys = [
      'password',
      'token',
      'secret',
      'api_key',
      'apikey',
      'authorization',
      'auth',
    ];

    data.forEach((key, value) {
      if (sensitiveKeys.any((sensitive) => 
          key.toLowerCase().contains(sensitive.toLowerCase()))) {
        data[key] = '***';
      } else if (value is Map<String, dynamic>) {
        _maskSensitiveFields(value);
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            _maskSensitiveFields(item);
          }
        }
      }
    });
  }
}