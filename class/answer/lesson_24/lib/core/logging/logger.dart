import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'log_outputs/console_output.dart';
import 'log_outputs/file_output.dart';
import 'log_outputs/firebase_output.dart';
import 'log_outputs/crash_output.dart';

/// Log levels with priority ordering
enum LogLevel {
  TRACE(0, 'TRACE'),
  DEBUG(1, 'DEBUG'),
  INFO(2, 'INFO'),
  WARN(3, 'WARN'),
  ERROR(4, 'ERROR'),
  FATAL(5, 'FATAL');

  const LogLevel(this.level, this.name);
  final int level;
  final String name;
}

/// Comprehensive log entry with structured data
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? tag;
  final Map<String, dynamic>? data;
  final Exception? error;
  final StackTrace? stackTrace;
  final String? userId;
  final String? sessionId;
  final Map<String, dynamic> context;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.data,
    this.error,
    this.stackTrace,
    this.userId,
    this.sessionId,
    required this.context,
  });

  /// Convert log entry to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'level_value': level.level,
      'message': message,
      'tag': tag,
      'data': data,
      'error': error?.toString(),
      'error_type': error?.runtimeType.toString(),
      'stack_trace': stackTrace?.toString(),
      'user_id': userId,
      'session_id': sessionId,
      'context': context,
      'message_hash': message.hashCode,
      'log_size': _calculateLogSize(),
    };
  }

  /// Calculate approximate log entry size
  int _calculateLogSize() {
    final jsonString = jsonEncode(toJson());
    return jsonString.length;
  }

  @override
  String toString() {
    return 'LogEntry(${level.name}) $message';
  }
}

/// Advanced logging system with multiple outputs and intelligent filtering
class AdvancedLogger {
  static final List<LogOutput> _outputs = [];
  static LogLevel _minLevel = kDebugMode ? LogLevel.TRACE : LogLevel.INFO;
  static bool _isInitialized = false;
  static String? _currentUserId;
  static String? _currentSessionId;
  static final Map<String, int> _logCounts = {};
  static Timer? _statsTimer;

  /// Initialize the advanced logging system
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize log outputs
      _outputs.addAll([
        ConsoleLogOutput(),
        FileLogOutput(),
        FirebaseLogOutput(),
        CrashReportingOutput(),
      ]);

      // Configure each output
      for (final output in _outputs) {
        await output.initialize();
      }

      // Start periodic statistics collection
      _startStatsCollection();

      _isInitialized = true;
      info('Advanced logging system initialized successfully');
    } catch (e) {
      print('Failed to initialize logging system: $e');
      // Fallback to console-only logging
      _outputs.clear();
      _outputs.add(ConsoleLogOutput());
      await _outputs.first.initialize();
      _isInitialized = true;
    }
  }

  /// Main logging method with comprehensive features
  static void log({
    required LogLevel level,
    required String message,
    String? tag,
    Map<String, dynamic>? data,
    Exception? error,
    StackTrace? stackTrace,
    String? userId,
    String? sessionId,
  }) {
    if (!_shouldLog(level)) return;

    try {
      final logEntry = LogEntry(
        timestamp: DateTime.now(),
        level: level,
        message: message,
        tag: tag ?? _getCallerTag(),
        data: data,
        error: error,
        stackTrace: stackTrace,
        userId: userId ?? _currentUserId,
        sessionId: sessionId ?? _currentSessionId,
        context: _buildContext(),
      );

      // Update statistics
      _updateLogStats(level);

      // Write to all outputs
      for (final output in _outputs) {
        try {
          output.write(logEntry);
        } catch (e) {
          // Fallback to console if output fails
          print('Log output failed: $e');
        }
      }

      // Handle critical logs immediately
      if (level == LogLevel.ERROR || level == LogLevel.FATAL) {
        _handleCriticalLog(logEntry);
      }

      // Rate limiting check
      _checkRateLimit(level);

    } catch (e) {
      // Ultimate fallback - print to console
      print('Logging failed: $e - Original message: $message');
    }
  }

  /// Convenience methods for different log levels
  static void trace(String message, {String? tag, Map<String, dynamic>? data}) {
    log(level: LogLevel.TRACE, message: message, tag: tag, data: data);
  }

  static void debug(String message, {String? tag, Map<String, dynamic>? data}) {
    log(level: LogLevel.DEBUG, message: message, tag: tag, data: data);
  }

  static void info(String message, {String? tag, Map<String, dynamic>? data}) {
    log(level: LogLevel.INFO, message: message, tag: tag, data: data);
  }

  static void warn(String message, {String? tag, Exception? error, Map<String, dynamic>? data}) {
    log(level: LogLevel.WARN, message: message, tag: tag, error: error, data: data);
  }

  static void error(String message, {String? tag, Exception? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    log(
      level: LogLevel.ERROR,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  static void fatal(String message, {String? tag, Exception? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    log(
      level: LogLevel.FATAL,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Specialized logging methods for different contexts

  /// Log user actions and interactions
  static void logUserAction({
    required String action,
    String? screen,
    Map<String, dynamic>? details,
  }) {
    log(
      level: LogLevel.INFO,
      message: 'User Action: $action',
      tag: 'USER_ACTION',
      data: {
        'action': action,
        'screen': screen ?? _getCurrentScreen(),
        'timestamp': DateTime.now().toIso8601String(),
        'user_id': _currentUserId,
        'session_duration': _getSessionDuration(),
        ...?details,
      },
    );
  }

  /// Log performance metrics and timing
  static void logPerformance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metrics,
  }) {
    final durationMs = duration.inMilliseconds;
    
    log(
      level: LogLevel.INFO,
      message: 'Performance: $operation (${durationMs}ms)',
      tag: 'PERFORMANCE',
      data: {
        'operation': operation,
        'duration_ms': durationMs,
        'duration_readable': _formatDuration(duration),
        'is_slow': durationMs > 1000,
        'performance_grade': _getPerformanceGrade(durationMs),
        'memory_usage': _getCurrentMemoryUsage(),
        'cpu_usage': _getCurrentCpuUsage(),
        ...?metrics,
      },
    );

    // Log warning for slow operations
    if (durationMs > 5000) {
      warn(
        'Slow operation detected: $operation took ${durationMs}ms',
        tag: 'PERFORMANCE_WARNING',
        data: {'operation': operation, 'duration_ms': durationMs},
      );
    }
  }

  /// Log business events and analytics
  static void logBusinessEvent({
    required String event,
    required String category,
    Map<String, dynamic>? properties,
  }) {
    log(
      level: LogLevel.INFO,
      message: 'Business Event: $event',
      tag: 'BUSINESS',
      data: {
        'event': event,
        'category': category,
        'properties': properties,
        'user_id': _currentUserId,
        'session_id': _currentSessionId,
        'app_version': _getAppVersion(),
        'platform': Platform.operatingSystem,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Log security events with enhanced context
  static void logSecurityEvent({
    required String event,
    required String severity,
    Map<String, dynamic>? details,
  }) {
    final logLevel = severity == 'critical' ? LogLevel.ERROR : LogLevel.WARN;
    
    log(
      level: logLevel,
      message: 'Security Event: $event',
      tag: 'SECURITY',
      data: {
        'security_event': event,
        'severity': severity,
        'ip_address': _getCurrentIP(),
        'user_agent': _getUserAgent(),
        'device_id': _getDeviceId(),
        'session_id': _currentSessionId,
        'auth_status': _getAuthStatus(),
        'location': _getApproximateLocation(),
        'timestamp': DateTime.now().toIso8601String(),
        ...?details,
      },
    );

    // Immediate alert for critical security events
    if (severity == 'critical') {
      _sendSecurityAlert(event, details);
    }
  }

  /// Log network requests and responses
  static void logNetworkEvent({
    required String method,
    required String url,
    required int statusCode,
    required Duration duration,
    Map<String, dynamic>? details,
  }) {
    final level = statusCode >= 400 ? LogLevel.WARN : LogLevel.DEBUG;
    
    log(
      level: level,
      message: 'Network: $method $url ($statusCode)',
      tag: 'NETWORK',
      data: {
        'method': method,
        'url': url,
        'status_code': statusCode,
        'duration_ms': duration.inMilliseconds,
        'is_success': statusCode < 400,
        'is_client_error': statusCode >= 400 && statusCode < 500,
        'is_server_error': statusCode >= 500,
        'network_type': _getNetworkType(),
        'connection_quality': _getConnectionQuality(),
        ...?details,
      },
    );
  }

  /// Log application lifecycle events
  static void logLifecycleEvent({
    required String event,
    Map<String, dynamic>? details,
  }) {
    log(
      level: LogLevel.INFO,
      message: 'Lifecycle: $event',
      tag: 'LIFECYCLE',
      data: {
        'lifecycle_event': event,
        'timestamp': DateTime.now().toIso8601String(),
        'app_state': _getAppState(),
        'session_id': _currentSessionId,
        'uptime': _getAppUptime(),
        ...?details,
      },
    );
  }

  /// Set user context for logging
  static void setUserId(String userId) {
    _currentUserId = userId;
    info('User context updated', data: {'user_id': userId});
  }

  /// Set session context for logging
  static void setSessionId(String sessionId) {
    _currentSessionId = sessionId;
    info('Session context updated', data: {'session_id': sessionId});
  }

  /// Check if logging should occur for the given level
  static bool _shouldLog(LogLevel level) {
    return level.level >= _minLevel.level;
  }

  /// Handle critical logs with immediate actions
  static void _handleCriticalLog(LogEntry entry) {
    // Force immediate flush for critical logs
    for (final output in _outputs) {
      if (output is FileLogOutput) {
        output.flush();
      }
    }

    // Send immediate alert for fatal errors in production
    if (kReleaseMode && entry.level == LogLevel.FATAL) {
      _sendFatalErrorAlert(entry);
    }

    // Add breadcrumb for crash reporting
    FirebaseCrashlytics.instance.log(
      'Critical log: ${entry.level.name} - ${entry.message}',
    );
  }

  /// Get caller information for automatic tagging
  static String _getCallerTag() {
    try {
      final trace = StackTrace.current.toString();
      final lines = trace.split('\n');
      if (lines.length > 3) {
        final callerLine = lines[3];
        final match = RegExp(r'(\w+)\.dart:(\d+):(\d+)').firstMatch(callerLine);
        if (match != null) {
          return '${match.group(1)}:${match.group(2)}';
        }
      }
    } catch (e) {
      // Fallback if stack trace parsing fails
    }
    return 'UNKNOWN';
  }

  /// Build comprehensive context for each log entry
  static Map<String, dynamic> _buildContext() {
    return {
      'app_version': _getAppVersion(),
      'build_number': _getBuildNumber(),
      'platform': Platform.operatingSystem,
      'platform_version': Platform.operatingSystemVersion,
      'current_screen': _getCurrentScreen(),
      'memory_usage': _getCurrentMemoryUsage(),
      'battery_level': _getBatteryLevel(),
      'network_status': _getNetworkStatus(),
      'auth_status': _getAuthStatus(),
      'device_model': _getDeviceModel(),
      'locale': _getCurrentLocale(),
      'timezone': _getTimezone(),
      'app_uptime': _getAppUptime(),
      'session_duration': _getSessionDuration(),
      'thread_id': _getCurrentThreadId(),
    };
  }

  /// Update logging statistics
  static void _updateLogStats(LogLevel level) {
    final key = level.name;
    _logCounts[key] = (_logCounts[key] ?? 0) + 1;
  }

  /// Start periodic statistics collection
  static void _startStatsCollection() {
    _statsTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _reportLogStats();
    });
  }

  /// Report logging statistics
  static void _reportLogStats() {
    if (_logCounts.isNotEmpty) {
      logBusinessEvent(
        event: 'logging_stats',
        category: 'system',
        properties: {
          'log_counts': Map.from(_logCounts),
          'total_logs': _logCounts.values.reduce((a, b) => a + b),
          'error_rate': (_logCounts['ERROR'] ?? 0) / 
                       (_logCounts.values.reduce((a, b) => a + b)),
        },
      );
      
      // Reset counters
      _logCounts.clear();
    }
  }

  /// Check for rate limiting
  static void _checkRateLimit(LogLevel level) {
    // Implementation for rate limiting to prevent log spam
    // Could be enhanced with more sophisticated rate limiting
  }

  /// Format duration for human readability
  static String _formatDuration(Duration duration) {
    if (duration.inMilliseconds < 1000) {
      return '${duration.inMilliseconds}ms';
    } else if (duration.inSeconds < 60) {
      final seconds = duration.inSeconds;
      final milliseconds = duration.inMilliseconds % 1000;
      return '${seconds}.${milliseconds.toString().padLeft(3, '0')}s';
    } else {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    }
  }

  /// Get performance grade based on duration
  static String _getPerformanceGrade(int milliseconds) {
    if (milliseconds < 100) return 'A';
    if (milliseconds < 500) return 'B';
    if (milliseconds < 1000) return 'C';
    if (milliseconds < 3000) return 'D';
    return 'F';
  }

  /// Send security alert for critical events
  static void _sendSecurityAlert(String event, Map<String, dynamic>? details) {
    // Implementation for sending security alerts
    error('Critical security event: $event', data: details);
  }

  /// Send fatal error alert
  static void _sendFatalErrorAlert(LogEntry entry) {
    // Implementation for sending fatal error alerts
    print('FATAL ERROR ALERT: ${entry.message}');
  }

  /// Flush all log outputs
  static Future<void> flush() async {
    for (final output in _outputs) {
      try {
        await output.flush();
      } catch (e) {
        print('Failed to flush output: $e');
      }
    }
  }

  /// Dispose logging system
  static void dispose() {
    _statsTimer?.cancel();
    for (final output in _outputs) {
      output.dispose();
    }
    _outputs.clear();
    _isInitialized = false;
  }

  // Context helper methods (would be implemented with actual services)
  static String _getCurrentScreen() => 'unknown';
  static int _getCurrentMemoryUsage() => 0;
  static int _getBatteryLevel() => 100;
  static String _getNetworkStatus() => 'connected';
  static String _getAuthStatus() => 'authenticated';
  static String _getDeviceModel() => 'unknown';
  static String _getCurrentLocale() => 'en_US';
  static String _getTimezone() => 'UTC';
  static int _getAppUptime() => 0;
  static int _getSessionDuration() => 0;
  static String _getCurrentThreadId() => 'main';
  static String _getAppVersion() => '1.0.0';
  static String _getBuildNumber() => '1';
  static double _getCurrentCpuUsage() => 0.0;
  static String _getCurrentIP() => '127.0.0.1';
  static String _getUserAgent() => 'ConnectPro/1.0.0';
  static String _getDeviceId() => 'device_123';
  static String _getApproximateLocation() => 'Unknown';
  static String _getNetworkType() => 'WiFi';
  static String _getConnectionQuality() => 'Good';
  static String _getAppState() => 'active';
}

/// Abstract base class for log outputs
abstract class LogOutput {
  Future<void> initialize();
  void write(LogEntry entry);
  Future<void> flush();
  void dispose();
}
