import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../logger.dart';

/// Console log output for development and debugging
/// Provides colored output with structured formatting
class ConsoleLogOutput implements LogOutput {
  static const int _maxDataLength = 500;
  static const int _maxMessageLength = 200;

  @override
  Future<void> initialize() async {
    // No initialization needed for console output
    if (kDebugMode) {
      print('📝 Console logging initialized');
    }
  }

  @override
  void write(LogEntry entry) {
    if (kDebugMode) {
      final colorCode = _getColorCode(entry.level);
      final resetCode = '\x1B[0m';
      final timestamp = _formatTimestamp(entry.timestamp);
      final levelStr = entry.level.name.padRight(5);
      final tag = entry.tag != null ? '[${entry.tag}] ' : '';
      final message = _truncateMessage(entry.message);
      
      // Main log line
      print('$colorCode$timestamp $levelStr $tag$message$resetCode');
      
      // Error details if present
      if (entry.error != null) {
        print('$colorCode  ❌ Error: ${entry.error}$resetCode');
        
        if (entry.stackTrace != null) {
          final stackLines = entry.stackTrace.toString().split('\n');
          final relevantLines = stackLines.take(5).join('\n  ');
          print('$colorCode  📚 Stack: $relevantLines$resetCode');
        }
      }
      
      // Additional data if present
      if (entry.data != null && entry.data!.isNotEmpty) {
        final dataStr = _formatData(entry.data!);
        if (dataStr.isNotEmpty) {
          print('$colorCode  📊 Data: $dataStr$resetCode');
        }
      }

      // Context information for errors and warnings
      if (entry.level.level >= LogLevel.WARN.level && entry.context.isNotEmpty) {
        final contextStr = _formatContext(entry.context);
        if (contextStr.isNotEmpty) {
          print('$colorCode  🔍 Context: $contextStr$resetCode');
        }
      }

      // Performance information
      if (entry.tag == 'PERFORMANCE') {
        _printPerformanceInfo(entry, colorCode, resetCode);
      }

      // User action details
      if (entry.tag == 'USER_ACTION') {
        _printUserActionInfo(entry, colorCode, resetCode);
      }

      // Security event details
      if (entry.tag == 'SECURITY') {
        _printSecurityInfo(entry, colorCode, resetCode);
      }
    }
  }

  /// Get ANSI color code for log level
  String _getColorCode(LogLevel level) {
    switch (level) {
      case LogLevel.TRACE:
        return '\x1B[90m'; // Bright Black (Gray)
      case LogLevel.DEBUG:
        return '\x1B[36m'; // Cyan
      case LogLevel.INFO:
        return '\x1B[32m'; // Green
      case LogLevel.WARN:
        return '\x1B[33m'; // Yellow
      case LogLevel.ERROR:
        return '\x1B[31m'; // Red
      case LogLevel.FATAL:
        return '\x1B[35m\x1B[1m'; // Bright Magenta + Bold
    }
  }

  /// Format timestamp for console display
  String _formatTimestamp(DateTime timestamp) {
    final time = timestamp.toString().substring(11, 23); // HH:mm:ss.SSS
    return time;
  }

  /// Truncate message if too long
  String _truncateMessage(String message) {
    if (message.length <= _maxMessageLength) {
      return message;
    }
    return '${message.substring(0, _maxMessageLength)}...';
  }

  /// Format data for console display
  String _formatData(Map<String, dynamic> data) {
    try {
      final filteredData = _filterSensitiveData(data);
      final jsonStr = jsonEncode(filteredData);
      
      if (jsonStr.length <= _maxDataLength) {
        return jsonStr;
      }
      
      // For long data, show just the keys and value types
      final summary = filteredData.entries.map((e) {
        final valueType = e.value.runtimeType.toString();
        return '${e.key}: $valueType';
      }).join(', ');
      
      return '{$summary}';
    } catch (e) {
      return data.toString();
    }
  }

  /// Format context information
  String _formatContext(Map<String, dynamic> context) {
    try {
      final importantKeys = [
        'current_screen',
        'memory_usage',
        'network_status',
        'auth_status',
        'app_version'
      ];
      
      final filteredContext = <String, dynamic>{};
      for (final key in importantKeys) {
        if (context.containsKey(key)) {
          filteredContext[key] = context[key];
        }
      }
      
      if (filteredContext.isEmpty) return '';
      
      return jsonEncode(filteredContext);
    } catch (e) {
      return 'Context formatting error';
    }
  }

  /// Print performance-specific information
  void _printPerformanceInfo(LogEntry entry, String colorCode, String resetCode) {
    final data = entry.data ?? {};
    final operation = data['operation'] ?? 'unknown';
    final durationMs = data['duration_ms'] ?? 0;
    final grade = data['performance_grade'] ?? 'N/A';
    
    print('$colorCode  ⚡ Performance: $operation took ${durationMs}ms (Grade: $grade)$resetCode');
    
    if (data['is_slow'] == true) {
      print('$colorCode  ⚠️  SLOW OPERATION WARNING$resetCode');
    }
  }

  /// Print user action information
  void _printUserActionInfo(LogEntry entry, String colorCode, String resetCode) {
    final data = entry.data ?? {};
    final action = data['action'] ?? 'unknown';
    final screen = data['screen'] ?? 'unknown';
    
    print('$colorCode  👤 User: $action on $screen$resetCode');
  }

  /// Print security event information
  void _printSecurityInfo(LogEntry entry, String colorCode, String resetCode) {
    final data = entry.data ?? {};
    final event = data['security_event'] ?? 'unknown';
    final severity = data['severity'] ?? 'unknown';
    
    final icon = severity == 'critical' ? '🚨' : '🔒';
    print('$colorCode  $icon Security: $event (Severity: $severity)$resetCode');
  }

  /// Filter out sensitive data from logs
  Map<String, dynamic> _filterSensitiveData(Map<String, dynamic> data) {
    final filtered = <String, dynamic>{};
    final sensitiveKeys = {
      'password',
      'token',
      'auth_token',
      'access_token',
      'refresh_token',
      'api_key',
      'secret',
      'private_key',
      'credit_card',
      'ssn',
      'social_security',
    };

    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;

      if (sensitiveKeys.any((sensitive) => key.contains(sensitive))) {
        filtered[entry.key] = '[REDACTED]';
      } else if (value is Map<String, dynamic>) {
        filtered[entry.key] = _filterSensitiveData(value);
      } else if (value is List) {
        filtered[entry.key] = value.map((item) {
          return item is Map<String, dynamic> ? _filterSensitiveData(item) : item;
        }).toList();
      } else {
        filtered[entry.key] = value;
      }
    }

    return filtered;
  }

  @override
  Future<void> flush() async {
    // Console output is immediate, no buffering
  }

  @override
  void dispose() {
    // No cleanup needed for console output
    if (kDebugMode) {
      print('📝 Console logging disposed');
    }
  }
}
