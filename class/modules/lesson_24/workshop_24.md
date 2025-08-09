# 📊 Workshop

## 🎯 **What We're Building**

Implement comprehensive production monitoring and error handling for **ConnectPro Ultimate**, demonstrating:
- **🚨 Production Error Handling Excellence** - Robust error handling with intelligent recovery mechanisms and user-friendly feedback
- **📋 Advanced Logging Framework** - Structured logging with multiple outputs, performance tracking, and analytics integration
- **💥 Crash Reporting & Monitoring** - Real-time crash detection with Firebase Crashlytics and custom reporting endpoints
- **📊 Performance Monitoring** - Application performance tracking with bottleneck identification and optimization insights
- **🔍 Real-Time Error Tracking** - Live error monitoring with alerting systems and proactive issue resolution
- **👤 User Experience Excellence** - Graceful error handling with recovery guidance and seamless user experience
- **🔧 Production Debugging** - Advanced debugging tools for production applications and remote diagnostics

## ✅ **Expected Outcome**

A production-ready monitoring and error handling system featuring:
- 🚨 **Comprehensive Error Handling** - Intelligent error classification, recovery mechanisms, and user-friendly feedback
- 📋 **Advanced Logging Infrastructure** - Multi-output logging with structured data and performance analytics
- 💥 **Real-Time Crash Reporting** - Immediate crash detection with detailed context and automatic reporting
- 📊 **Performance Monitoring** - Continuous performance tracking with optimization insights and alerting
- 🔍 **Live Error Tracking** - Real-time error monitoring with trend analysis and proactive resolution
- 👤 **Exceptional User Experience** - Graceful error states with clear guidance and recovery options

## 🏗️ **Enhanced Production Monitoring Architecture**

Building comprehensive error handling and monitoring for ConnectPro Ultimate:

```
connectpro_ultimate_production_monitoring/
├── lib/
│   ├── core/
│   │   ├── error_handling/               # 🚨 Production error handling
│   │   │   ├── error_handler.dart        # Central error handling system
│   │   │   ├── error_recovery.dart       # Intelligent recovery mechanisms
│   │   │   ├── error_context.dart        # Error context collection
│   │   │   ├── error_classification.dart # Error type classification
│   │   │   └── user_friendly_errors.dart # User-facing error handling
│   │   ├── logging/                      # 📋 Advanced logging framework
│   │   │   ├── logger.dart               # Central logging system
│   │   │   ├── log_outputs/              # Multiple output destinations
│   │   │   │   ├── console_output.dart   # Development console logging
│   │   │   │   ├── file_output.dart      # Local file persistence
│   │   │   │   ├── firebase_output.dart  # Firebase Analytics integration
│   │   │   │   └── crash_output.dart     # Crashlytics integration
│   │   │   ├── log_formatters.dart       # Log message formatting
│   │   │   └── log_filters.dart          # Log filtering and routing
│   │   ├── monitoring/                   # 📊 Performance monitoring
│   │   │   ├── performance_monitor.dart  # Performance tracking system
│   │   │   ├── memory_monitor.dart       # Memory usage tracking
│   │   │   ├── network_monitor.dart      # Network performance monitoring
│   │   │   ├── ui_monitor.dart           # UI performance tracking
│   │   │   └── metrics_collector.dart    # Metrics aggregation
│   │   ├── crash_reporting/              # 💥 Crash reporting system
│   │   │   ├── crash_reporter.dart       # Central crash reporting
│   │   │   ├── crash_interceptors.dart   # Crash type interceptors
│   │   │   ├── breadcrumb_service.dart   # User action tracking
│   │   │   └── crash_analytics.dart      # Crash trend analysis
│   │   └── debugging/                    # 🔧 Production debugging
│   │       ├── remote_debugger.dart      # Remote debugging capabilities
│   │       ├── log_viewer.dart           # In-app log viewing
│   │       ├── performance_profiler.dart # Performance profiling tools
│   │       └── diagnostic_tools.dart     # System diagnostic utilities
│   ├── features/
│   │   ├── error_reporting/              # 🔍 Error reporting UI
│   │   │   ├── error_report_screen.dart  # User error reporting interface
│   │   │   ├── feedback_form.dart        # User feedback collection
│   │   │   └── error_details_dialog.dart # Error details presentation
│   │   ├── monitoring_dashboard/         # 📈 Monitoring dashboard
│   │   │   ├── performance_dashboard.dart # Performance metrics display
│   │   │   ├── error_trends_chart.dart   # Error trend visualization
│   │   │   └── system_health_widget.dart # System health indicators
│   │   └── debug_console/                # 🛠️ Debug console UI
│   │       ├── log_console_screen.dart   # Real-time log viewing
│   │       ├── performance_graphs.dart   # Performance visualization
│   │       └── diagnostic_panel.dart     # System diagnostic interface
│   ├── data/
│   │   ├── repositories/
│   │   │   ├── error_repository.dart     # Error data management
│   │   │   ├── metrics_repository.dart   # Performance metrics storage
│   │   │   └── crash_repository.dart     # Crash data repository
│   │   └── models/
│   │       ├── error_models.dart         # Error data models
│   │       ├── log_models.dart           # Log entry models
│   │       ├── performance_models.dart   # Performance metric models
│   │       └── crash_models.dart         # Crash report models
│   └── presentation/
│       ├── widgets/
│       │   ├── error_widgets/            # Error state widgets
│       │   │   ├── error_boundary.dart   # Error boundary wrapper
│       │   │   ├── error_fallback.dart   # Fallback UI components
│       │   │   ├── retry_widget.dart     # Retry action components
│   │   │   │   └── offline_banner.dart   # Network error indicators
│       │   ├── monitoring_widgets/       # Monitoring UI components
│       │   │   ├── performance_indicator.dart # Performance status display
│       │   │   ├── memory_usage_chart.dart # Memory usage visualization
│       │   │   └── error_rate_badge.dart # Error rate indicators
│       │   └── debug_widgets/            # Debug UI components
│       │       ├── log_entry_tile.dart   # Log entry display
│       │       ├── performance_meter.dart # Performance measurement
│       │       └── diagnostic_card.dart  # Diagnostic information display
│       └── providers/
│           ├── error_provider.dart       # Error state management
│           ├── logging_provider.dart     # Logging configuration
│           ├── monitoring_provider.dart  # Performance monitoring state
│           └── debug_provider.dart       # Debug console state
├── test/
│   ├── error_handling/                   # Error handling tests
│   │   ├── error_handler_test.dart       # Error handling unit tests
│   │   ├── error_recovery_test.dart      # Recovery mechanism tests
│   │   └── error_classification_test.dart # Error classification tests
│   ├── logging/                          # Logging framework tests
│   │   ├── logger_test.dart              # Logger functionality tests
│   │   ├── log_output_test.dart          # Output destination tests
│   │   └── log_filtering_test.dart       # Log filtering tests
│   ├── monitoring/                       # Performance monitoring tests
│   │   ├── performance_monitor_test.dart # Performance tracking tests
│   │   ├── memory_monitor_test.dart      # Memory monitoring tests
│   │   └── metrics_collector_test.dart   # Metrics collection tests
│   └── crash_reporting/                  # Crash reporting tests
│       ├── crash_reporter_test.dart      # Crash reporting tests
│       ├── crash_interceptor_test.dart   # Interceptor tests
│       └── breadcrumb_test.dart          # Breadcrumb tracking tests
├── integration_test/
│   ├── error_handling_integration_test.dart # Error handling integration tests
│   ├── monitoring_integration_test.dart  # Monitoring system integration tests
│   └── crash_reporting_integration_test.dart # Crash reporting integration tests
├── config/
│   ├── monitoring_config.yaml           # Monitoring configuration
│   ├── logging_config.yaml              # Logging configuration
│   └── error_handling_config.yaml       # Error handling configuration
└── docs/
    ├── error_handling_guide.md          # Error handling documentation
    ├── logging_best_practices.md        # Logging best practices
    ├── monitoring_setup.md              # Monitoring setup guide
    └── production_debugging.md          # Production debugging guide
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Production Error Handling Setup** ⏱️ *15 minutes*

Create comprehensive error handling infrastructure:

```dart
// lib/core/error_handling/error_handler.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../logging/logger.dart';
import 'error_classification.dart';
import 'error_recovery.dart';
import 'error_context.dart';

class ProductionErrorHandler {
  static bool _isInitialized = false;
  static final ErrorRecoveryService _recoveryService = ErrorRecoveryService();
  static final ErrorContextCollector _contextCollector = ErrorContextCollector();

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Set up Flutter error handling
    FlutterError.onError = handleFlutterError;

    // Set up Dart error handling
    PlatformDispatcher.instance.onError = handleDartError;

    _isInitialized = true;
    AdvancedLogger.info('Production error handler initialized');
  }

  static void handleFlutterError(FlutterErrorDetails details) {
    final errorInfo = ErrorInfo(
      error: details.exception,
      stackTrace: details.stack,
      context: _contextCollector.collectFlutterErrorContext(details),
      timestamp: DateTime.now(),
      type: ErrorType.flutter,
    );

    _processError(errorInfo);
  }

  static bool handleDartError(Object error, StackTrace stackTrace) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      context: _contextCollector.collectDartErrorContext(error),
      timestamp: DateTime.now(),
      type: ErrorType.dart,
    );

    _processError(errorInfo);
    return true;
  }

  static Future<void> handleCustomError(
    Exception error, {
    StackTrace? stackTrace,
    String? userId,
    String? operation,
    Map<String, dynamic>? additionalContext,
  }) async {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
      context: _contextCollector.collectCustomErrorContext(
        error: error,
        userId: userId,
        operation: operation,
        additionalContext: additionalContext,
      ),
      timestamp: DateTime.now(),
      type: ErrorType.custom,
    );

    await _processError(errorInfo);
  }

  static Future<void> _processError(ErrorInfo errorInfo) async {
    // Classify error severity and type
    final classification = ErrorClassifier.classify(errorInfo);
    
    // Log the error with appropriate level
    _logError(errorInfo, classification);
    
    // Report to crash reporting services
    await _reportCrash(errorInfo, classification);
    
    // Attempt error recovery
    final recoveryResult = await _recoveryService.attemptRecovery(
      errorInfo, 
      classification,
    );
    
    // Handle user experience
    await _handleUserExperience(errorInfo, classification, recoveryResult);
    
    // Update error metrics
    _updateErrorMetrics(errorInfo, classification);
  }

  static void _logError(ErrorInfo errorInfo, ErrorClassification classification) {
    final logLevel = _getLogLevel(classification.severity);
    
    AdvancedLogger.log(
      level: logLevel,
      message: 'Error: ${errorInfo.error}',
      tag: 'ERROR_HANDLER',
      error: errorInfo.error is Exception 
          ? errorInfo.error as Exception 
          : Exception(errorInfo.error.toString()),
      stackTrace: errorInfo.stackTrace,
      data: {
        'error_type': errorInfo.type.toString(),
        'severity': classification.severity.toString(),
        'category': classification.category,
        'can_recover': classification.canRecover,
        'context': errorInfo.context,
      },
    );
  }

  static Future<void> _reportCrash(
    ErrorInfo errorInfo, 
    ErrorClassification classification,
  ) async {
    // Report to Firebase Crashlytics
    await FirebaseCrashlytics.instance.recordError(
      errorInfo.error,
      errorInfo.stackTrace,
      fatal: classification.severity == ErrorSeverity.critical,
      information: [
        'Error Type: ${errorInfo.type}',
        'Severity: ${classification.severity}',
        'Category: ${classification.category}',
        'Can Recover: ${classification.canRecover}',
        'User ID: ${errorInfo.context['userId'] ?? 'anonymous'}',
        'Screen: ${errorInfo.context['currentScreen'] ?? 'unknown'}',
        'App Version: ${errorInfo.context['appVersion'] ?? 'unknown'}',
      ],
    );

    // Report to custom analytics
    await _reportToCustomAnalytics(errorInfo, classification);
  }

  static Future<void> _reportToCustomAnalytics(
    ErrorInfo errorInfo,
    ErrorClassification classification,
  ) async {
    try {
      // Custom error reporting endpoint
      final errorReport = {
        'timestamp': errorInfo.timestamp.toIso8601String(),
        'error_message': errorInfo.error.toString(),
        'error_type': errorInfo.type.toString(),
        'severity': classification.severity.toString(),
        'category': classification.category,
        'stack_trace': errorInfo.stackTrace.toString(),
        'context': errorInfo.context,
        'app_version': errorInfo.context['appVersion'],
        'platform': errorInfo.context['platform'],
        'user_id': errorInfo.context['userId'],
      };

      // Send to monitoring service (implementation depends on your service)
      await MonitoringService.reportError(errorReport);
    } catch (e) {
      AdvancedLogger.warn('Failed to report to custom analytics: $e');
    }
  }

  static Future<void> _handleUserExperience(
    ErrorInfo errorInfo,
    ErrorClassification classification,
    ErrorRecoveryResult recoveryResult,
  ) async {
    if (classification.severity == ErrorSeverity.critical) {
      // Show critical error dialog
      await UserErrorHandler.showCriticalErrorDialog(
        error: errorInfo.error.toString(),
        canRestart: recoveryResult.canRestart,
        canRetry: recoveryResult.canRetry,
      );
    } else if (classification.shouldShowToUser) {
      // Show user-friendly error message
      await UserErrorHandler.showErrorSnackbar(
        message: _getUserFriendlyMessage(classification),
        canRetry: recoveryResult.canRetry,
        retryAction: recoveryResult.retryAction,
      );
    }
  }

  static void _updateErrorMetrics(
    ErrorInfo errorInfo,
    ErrorClassification classification,
  ) {
    // Update error rate metrics
    ErrorMetrics.recordError(
      type: errorInfo.type,
      severity: classification.severity,
      category: classification.category,
      timestamp: errorInfo.timestamp,
    );
  }

  static LogLevel _getLogLevel(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return LogLevel.WARN;
      case ErrorSeverity.medium:
        return LogLevel.ERROR;
      case ErrorSeverity.high:
        return LogLevel.ERROR;
      case ErrorSeverity.critical:
        return LogLevel.FATAL;
    }
  }

  static String _getUserFriendlyMessage(ErrorClassification classification) {
    switch (classification.category) {
      case 'network':
        return 'Connection issue detected. Please check your internet and try again.';
      case 'authentication':
        return 'Authentication required. Please sign in to continue.';
      case 'validation':
        return 'Please check your input and try again.';
      case 'permission':
        return 'Permission required to access this feature.';
      case 'storage':
        return 'Storage issue detected. Please free up space and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

// lib/core/error_handling/error_classification.dart
enum ErrorType { flutter, dart, network, authentication, validation, custom }
enum ErrorSeverity { low, medium, high, critical }

class ErrorInfo {
  final Object error;
  final StackTrace? stackTrace;
  final Map<String, dynamic> context;
  final DateTime timestamp;
  final ErrorType type;

  ErrorInfo({
    required this.error,
    this.stackTrace,
    required this.context,
    required this.timestamp,
    required this.type,
  });
}

class ErrorClassification {
  final ErrorSeverity severity;
  final String category;
  final bool canRecover;
  final bool shouldShowToUser;
  final Duration retryDelay;

  ErrorClassification({
    required this.severity,
    required this.category,
    required this.canRecover,
    required this.shouldShowToUser,
    this.retryDelay = const Duration(seconds: 2),
  });
}

class ErrorClassifier {
  static ErrorClassification classify(ErrorInfo errorInfo) {
    final errorString = errorInfo.error.toString().toLowerCase();
    
    // Network errors
    if (errorString.contains('socketexception') || 
        errorString.contains('httpsexception') ||
        errorString.contains('timeout')) {
      return ErrorClassification(
        severity: ErrorSeverity.medium,
        category: 'network',
        canRecover: true,
        shouldShowToUser: true,
        retryDelay: Duration(seconds: 3),
      );
    }
    
    // Authentication errors
    if (errorString.contains('authentication') ||
        errorString.contains('unauthorized') ||
        errorString.contains('token')) {
      return ErrorClassification(
        severity: ErrorSeverity.high,
        category: 'authentication',
        canRecover: true,
        shouldShowToUser: true,
        retryDelay: Duration(seconds: 1),
      );
    }
    
    // Validation errors
    if (errorString.contains('validation') ||
        errorString.contains('invalid') ||
        errorString.contains('format')) {
      return ErrorClassification(
        severity: ErrorSeverity.low,
        category: 'validation',
        canRecover: true,
        shouldShowToUser: true,
        retryDelay: Duration.zero,
      );
    }
    
    // Memory errors
    if (errorString.contains('memory') ||
        errorString.contains('outofmemory')) {
      return ErrorClassification(
        severity: ErrorSeverity.critical,
        category: 'memory',
        canRecover: false,
        shouldShowToUser: true,
        retryDelay: Duration(seconds: 5),
      );
    }
    
    // Permission errors
    if (errorString.contains('permission') ||
        errorString.contains('access')) {
      return ErrorClassification(
        severity: ErrorSeverity.medium,
        category: 'permission',
        canRecover: true,
        shouldShowToUser: true,
        retryDelay: Duration(seconds: 1),
      );
    }
    
    // Default classification
    return ErrorClassification(
      severity: ErrorSeverity.medium,
      category: 'general',
      canRecover: false,
      shouldShowToUser: true,
      retryDelay: Duration(seconds: 2),
    );
  }
}
```

### **Step 2: Advanced Logging Framework Implementation** ⏱️ *15 minutes*

Implement comprehensive logging with multiple outputs:

```dart
// lib/core/logging/logger.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'log_outputs/console_output.dart';
import 'log_outputs/file_output.dart';
import 'log_outputs/firebase_output.dart';
import 'log_outputs/crash_output.dart';

enum LogLevel {
  TRACE(0),
  DEBUG(1),
  INFO(2),
  WARN(3),
  ERROR(4),
  FATAL(5);

  const LogLevel(this.level);
  final int level;
}

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

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'level': level.toString(),
      'message': message,
      'tag': tag,
      'data': data,
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
      'userId': userId,
      'sessionId': sessionId,
      'context': context,
    };
  }
}

class AdvancedLogger {
  static final List<LogOutput> _outputs = [];
  static LogLevel _minLevel = kDebugMode ? LogLevel.TRACE : LogLevel.INFO;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

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

    _isInitialized = true;
    info('Advanced logging system initialized');
  }

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

    final logEntry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag ?? _getCallerTag(),
      data: data,
      error: error,
      stackTrace: stackTrace,
      userId: userId ?? UserService.getCurrentUserId(),
      sessionId: sessionId ?? SessionService.getCurrentSessionId(),
      context: _buildContext(),
    );

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
  }

  // Convenience methods
  static void trace(String message, {Map<String, dynamic>? data}) {
    log(level: LogLevel.TRACE, message: message, data: data);
  }

  static void debug(String message, {Map<String, dynamic>? data}) {
    log(level: LogLevel.DEBUG, message: message, data: data);
  }

  static void info(String message, {Map<String, dynamic>? data}) {
    log(level: LogLevel.INFO, message: message, data: data);
  }

  static void warn(String message, {Exception? error, Map<String, dynamic>? data}) {
    log(level: LogLevel.WARN, message: message, error: error, data: data);
  }

  static void error(String message, {Exception? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    log(
      level: LogLevel.ERROR,
      message: message,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  static void fatal(String message, {Exception? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    log(
      level: LogLevel.FATAL,
      message: message,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  // Specialized logging methods
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
        'screen': screen ?? NavigationService.getCurrentScreen(),
        'timestamp': DateTime.now().toIso8601String(),
        ...?details,
      },
    );
  }

  static void logPerformance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metrics,
  }) {
    log(
      level: LogLevel.INFO,
      message: 'Performance: $operation (${duration.inMilliseconds}ms)',
      tag: 'PERFORMANCE',
      data: {
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
        'duration_readable': _formatDuration(duration),
        ...?metrics,
      },
    );
  }

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
        'user_id': UserService.getCurrentUserId(),
        'session_id': SessionService.getCurrentSessionId(),
      },
    );
  }

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
        'ip_address': NetworkService.getCurrentIP(),
        'user_agent': DeviceService.getUserAgent(),
        'device_id': DeviceService.getDeviceId(),
        ...?details,
      },
    );
  }

  static bool _shouldLog(LogLevel level) {
    return level.level >= _minLevel.level;
  }

  static void _handleCriticalLog(LogEntry entry) {
    // Force immediate flush for critical logs
    for (final output in _outputs) {
      if (output is FileLogOutput) {
        output.flush();
      }
    }

    // Send immediate alert for fatal errors in production
    if (kReleaseMode && entry.level == LogLevel.FATAL) {
      AlertingService.sendImmediateAlert(entry);
    }
  }

  static String _getCallerTag() {
    final trace = StackTrace.current.toString();
    final lines = trace.split('\n');
    if (lines.length > 3) {
      final callerLine = lines[3];
      final match = RegExp(r'(\w+)\.dart:(\d+):(\d+)').firstMatch(callerLine);
      if (match != null) {
        return '${match.group(1)}:${match.group(2)}';
      }
    }
    return 'UNKNOWN';
  }

  static Map<String, dynamic> _buildContext() {
    return {
      'app_version': PackageService.getVersion(),
      'build_number': PackageService.getBuildNumber(),
      'platform': Platform.operatingSystem,
      'platform_version': Platform.operatingSystemVersion,
      'current_screen': NavigationService.getCurrentScreen(),
      'memory_usage': PerformanceService.getCurrentMemoryUsage(),
      'network_status': NetworkService.getConnectionState(),
      'auth_status': AuthService.isAuthenticated(),
    };
  }

  static String _formatDuration(Duration duration) {
    if (duration.inMilliseconds < 1000) {
      return '${duration.inMilliseconds}ms';
    } else if (duration.inSeconds < 60) {
      return '${duration.inSeconds}.${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}s';
    } else {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
  }

  static Future<void> flush() async {
    for (final output in _outputs) {
      await output.flush();
    }
  }

  static void dispose() {
    for (final output in _outputs) {
      output.dispose();
    }
    _outputs.clear();
  }
}

// lib/core/logging/log_outputs/console_output.dart
abstract class LogOutput {
  Future<void> initialize();
  void write(LogEntry entry);
  Future<void> flush();
  void dispose();
}

class ConsoleLogOutput implements LogOutput {
  @override
  Future<void> initialize() async {
    // No initialization needed for console
  }

  @override
  void write(LogEntry entry) {
    if (kDebugMode) {
      final colorCode = _getColorCode(entry.level);
      final timestamp = entry.timestamp.toString().substring(11, 23);
      final levelStr = entry.level.toString().split('.').last.padRight(5);
      final tag = entry.tag != null ? '[${entry.tag}] ' : '';
      
      print('$colorCode$timestamp $levelStr $tag${entry.message}\x1B[0m');
      
      if (entry.error != null) {
        print('$colorCode  ❌ ${entry.error}\x1B[0m');
      }
      
      if (entry.data != null && entry.data!.isNotEmpty) {
        print('$colorCode  📊 ${jsonEncode(entry.data)}\x1B[0m');
      }
    }
  }

  String _getColorCode(LogLevel level) {
    switch (level) {
      case LogLevel.TRACE: return '\x1B[90m'; // Gray
      case LogLevel.DEBUG: return '\x1B[36m'; // Cyan
      case LogLevel.INFO: return '\x1B[32m';  // Green
      case LogLevel.WARN: return '\x1B[33m';  // Yellow
      case LogLevel.ERROR: return '\x1B[31m'; // Red
      case LogLevel.FATAL: return '\x1B[35m'; // Magenta
    }
  }

  @override
  Future<void> flush() async {
    // Console output is immediate
  }

  @override
  void dispose() {
    // No cleanup needed for console
  }
}

// lib/core/logging/log_outputs/file_output.dart
class FileLogOutput implements LogOutput {
  static const String _logFileName = 'app_logs.jsonl';
  static const int _maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int _maxFiles = 3;
  
  final List<LogEntry> _buffer = [];
  Timer? _flushTimer;
  File? _currentLogFile;

  @override
  Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _currentLogFile = File('${directory.path}/$_logFileName');
      
      // Start periodic flush
      _flushTimer = Timer.periodic(Duration(seconds: 30), (_) => flush());
    } catch (e) {
      print('Failed to initialize file logging: $e');
    }
  }

  @override
  void write(LogEntry entry) {
    _buffer.add(entry);
    
    // Immediate flush for critical errors
    if (entry.level == LogLevel.ERROR || entry.level == LogLevel.FATAL) {
      flush();
    }
  }

  @override
  Future<void> flush() async {
    if (_buffer.isEmpty || _currentLogFile == null) return;

    try {
      // Check file size and rotate if necessary
      if (await _currentLogFile!.exists()) {
        final size = await _currentLogFile!.length();
        if (size > _maxFileSize) {
          await _rotateLogFiles();
        }
      }

      // Write buffered entries
      final entries = _buffer.map((entry) => jsonEncode(entry.toJson())).join('\n') + '\n';
      await _currentLogFile!.writeAsString(entries, mode: FileMode.append);
      _buffer.clear();
    } catch (e) {
      print('Failed to flush logs to file: $e');
    }
  }

  Future<void> _rotateLogFiles() async {
    if (_currentLogFile == null) return;

    try {
      final directory = _currentLogFile!.parent;
      
      // Rotate existing files
      for (int i = _maxFiles - 1; i >= 1; i--) {
        final oldFile = File('${directory.path}/$_logFileName.$i');
        final newFile = File('${directory.path}/$_logFileName.${i + 1}');
        
        if (await oldFile.exists()) {
          if (i == _maxFiles - 1) {
            await oldFile.delete();
          } else {
            await oldFile.rename(newFile.path);
          }
        }
      }
      
      // Move current file to .1
      if (await _currentLogFile!.exists()) {
        await _currentLogFile!.rename('${directory.path}/$_logFileName.1');
      }
      
      // Create new current file
      _currentLogFile = File('${directory.path}/$_logFileName');
    } catch (e) {
      print('Failed to rotate log files: $e');
    }
  }

  @override
  void dispose() {
    _flushTimer?.cancel();
    flush();
  }
}
```

### **Step 3: Performance Monitoring Implementation** ⏱️ *15 minutes*

Implement comprehensive performance tracking:

```dart
// lib/core/monitoring/performance_monitor.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../logging/logger.dart';

class PerformanceMonitor {
  static bool _isMonitoring = false;
  static Timer? _monitoringTimer;
  static final List<PerformanceMetric> _metrics = [];
  static final Map<String, Stopwatch> _activeOperations = {};

  static Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;
    AdvancedLogger.info('Performance monitoring started');

    // Monitor frame rendering
    _startFrameMonitoring();
    
    // Monitor system resources
    _startResourceMonitoring();
    
    // Monitor network performance
    _startNetworkMonitoring();
  }

  static void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    AdvancedLogger.info('Performance monitoring stopped');
  }

  static void _startFrameMonitoring() {
    SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
  }

  static void _onFrameTiming(List<FrameTiming> timings) {
    if (!_isMonitoring) return;

    for (final timing in timings) {
      final buildDuration = timing.buildDuration;
      final rasterDuration = timing.rasterDuration;
      final totalDuration = timing.totalSpan;

      // Log frame performance issues
      if (totalDuration.inMilliseconds > 16) { // > 60 FPS
        AdvancedLogger.warn(
          'Frame performance issue detected',
          data: {
            'build_duration_ms': buildDuration.inMilliseconds,
            'raster_duration_ms': rasterDuration.inMilliseconds,
            'total_duration_ms': totalDuration.inMilliseconds,
            'frame_number': timing.frameNumber,
          },
        );
      }

      // Record metric
      _recordMetric(PerformanceMetric(
        name: 'frame_render_time',
        value: totalDuration.inMilliseconds.toDouble(),
        unit: 'milliseconds',
        timestamp: DateTime.now(),
        tags: {
          'build_time': buildDuration.inMilliseconds.toString(),
          'raster_time': rasterDuration.inMilliseconds.toString(),
        },
      ));
    }
  }

  static void _startResourceMonitoring() {
    _monitoringTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }

      await _collectResourceMetrics();
    });
  }

  static Future<void> _collectResourceMetrics() async {
    try {
      // Memory usage
      final memoryInfo = await _getMemoryInfo();
      _recordMetric(PerformanceMetric(
        name: 'memory_usage',
        value: memoryInfo['used']?.toDouble() ?? 0.0,
        unit: 'bytes',
        timestamp: DateTime.now(),
        tags: {
          'total': memoryInfo['total']?.toString() ?? '0',
          'free': memoryInfo['free']?.toString() ?? '0',
        },
      ));

      // CPU usage (platform-specific implementation needed)
      final cpuUsage = await _getCPUUsage();
      _recordMetric(PerformanceMetric(
        name: 'cpu_usage',
        value: cpuUsage,
        unit: 'percentage',
        timestamp: DateTime.now(),
      ));

      // Battery level
      final batteryLevel = await _getBatteryLevel();
      _recordMetric(PerformanceMetric(
        name: 'battery_level',
        value: batteryLevel,
        unit: 'percentage',
        timestamp: DateTime.now(),
      ));

      // Storage usage
      final storageInfo = await _getStorageInfo();
      _recordMetric(PerformanceMetric(
        name: 'storage_usage',
        value: storageInfo['used']?.toDouble() ?? 0.0,
        unit: 'bytes',
        timestamp: DateTime.now(),
        tags: {
          'total': storageInfo['total']?.toString() ?? '0',
          'free': storageInfo['free']?.toString() ?? '0',
        },
      ));

    } catch (e) {
      AdvancedLogger.warn('Failed to collect resource metrics: $e');
    }
  }

  static void _startNetworkMonitoring() {
    // Network monitoring would be integrated with HTTP client
    // This is a placeholder for network performance tracking
  }

  // Operation timing
  static void startOperation(String operationName) {
    _activeOperations[operationName] = Stopwatch()..start();
  }

  static void endOperation(String operationName, {Map<String, dynamic>? additionalData}) {
    final stopwatch = _activeOperations.remove(operationName);
    if (stopwatch != null) {
      stopwatch.stop();
      
      AdvancedLogger.logPerformance(
        operation: operationName,
        duration: stopwatch.elapsed,
        metrics: additionalData,
      );

      _recordMetric(PerformanceMetric(
        name: 'operation_duration',
        value: stopwatch.elapsedMilliseconds.toDouble(),
        unit: 'milliseconds',
        timestamp: DateTime.now(),
        tags: {
          'operation': operationName,
          ...?additionalData?.map((k, v) => MapEntry(k, v.toString())),
        },
      ));
    }
  }

  // Convenience method for timing code blocks
  static Future<T> timeOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? additionalData,
  }) async {
    startOperation(operationName);
    try {
      final result = await operation();
      endOperation(operationName, additionalData: additionalData);
      return result;
    } catch (e) {
      endOperation(operationName, additionalData: {
        'error': e.toString(),
        ...?additionalData,
      });
      rethrow;
    }
  }

  static void _recordMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    
    // Keep only recent metrics (last 1000 entries)
    if (_metrics.length > 1000) {
      _metrics.removeRange(0, _metrics.length - 1000);
    }

    // Check for performance thresholds
    _checkPerformanceThresholds(metric);
  }

  static void _checkPerformanceThresholds(PerformanceMetric metric) {
    switch (metric.name) {
      case 'frame_render_time':
        if (metric.value > 33) { // Worse than 30 FPS
          AdvancedLogger.warn(
            'Poor frame performance detected: ${metric.value}ms',
            data: metric.toJson(),
          );
        }
        break;
      case 'memory_usage':
        if (metric.value > 200 * 1024 * 1024) { // > 200MB
          AdvancedLogger.warn(
            'High memory usage detected: ${(metric.value / 1024 / 1024).toStringAsFixed(1)}MB',
            data: metric.toJson(),
          );
        }
        break;
      case 'operation_duration':
        if (metric.value > 5000) { // > 5 seconds
          AdvancedLogger.warn(
            'Slow operation detected: ${metric.tags?['operation']} (${metric.value}ms)',
            data: metric.toJson(),
          );
        }
        break;
    }
  }

  // Platform-specific implementations (simplified)
  static Future<Map<String, int>> _getMemoryInfo() async {
    // Implementation would use platform channels
    return {
      'used': 150 * 1024 * 1024, // 150MB
      'total': 4 * 1024 * 1024 * 1024, // 4GB
      'free': 3850 * 1024 * 1024, // 3.85GB
    };
  }

  static Future<double> _getCPUUsage() async {
    // Implementation would use platform channels
    return 25.5; // 25.5%
  }

  static Future<double> _getBatteryLevel() async {
    // Implementation would use battery_plus package
    return 85.0; // 85%
  }

  static Future<Map<String, int>> _getStorageInfo() async {
    // Implementation would use platform channels
    return {
      'used': 32 * 1024 * 1024 * 1024, // 32GB
      'total': 128 * 1024 * 1024 * 1024, // 128GB
      'free': 96 * 1024 * 1024 * 1024, // 96GB
    };
  }

  // Analytics and reporting
  static List<PerformanceMetric> getMetrics({
    String? name,
    DateTime? since,
    Duration? window,
  }) {
    var filteredMetrics = _metrics.where((metric) {
      if (name != null && metric.name != name) return false;
      if (since != null && metric.timestamp.isBefore(since)) return false;
      if (window != null && 
          metric.timestamp.isBefore(DateTime.now().subtract(window))) {
        return false;
      }
      return true;
    }).toList();

    return filteredMetrics;
  }

  static Map<String, dynamic> getPerformanceSummary({Duration? window}) {
    final since = window != null 
        ? DateTime.now().subtract(window)
        : DateTime.now().subtract(Duration(hours: 1));
    
    final recentMetrics = getMetrics(since: since);
    
    final summary = <String, dynamic>{};
    
    // Group metrics by name
    final metricGroups = <String, List<PerformanceMetric>>{};
    for (final metric in recentMetrics) {
      metricGroups.putIfAbsent(metric.name, () => []).add(metric);
    }

    // Calculate statistics for each metric type
    for (final entry in metricGroups.entries) {
      final values = entry.value.map((m) => m.value).toList();
      if (values.isNotEmpty) {
        values.sort();
        summary[entry.key] = {
          'count': values.length,
          'min': values.first,
          'max': values.last,
          'avg': values.reduce((a, b) => a + b) / values.length,
          'p50': values[(values.length * 0.5).floor()],
          'p95': values[(values.length * 0.95).floor()],
          'p99': values[(values.length * 0.99).floor()],
        };
      }
    }

    return summary;
  }

  static void dispose() {
    stopMonitoring();
    _metrics.clear();
    _activeOperations.clear();
  }
}

class PerformanceMetric {
  final String name;
  final double value;
  final String unit;
  final DateTime timestamp;
  final Map<String, String>? tags;

  PerformanceMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
    };
  }
}
```

### **Step 4: User-Friendly Error States Implementation** ⏱️ *15 minutes*

Create graceful error handling for users:

```dart
// lib/presentation/widgets/error_widgets/error_boundary.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error_handling/error_handler.dart';
import '../../../core/logging/logger.dart';
import 'error_fallback.dart';

class ErrorBoundary extends ConsumerStatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? fallbackBuilder;
  final void Function(Object error, StackTrace? stackTrace)? onError;
  final String? context;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallbackBuilder,
    this.onError,
    this.context,
  });

  @override
  ConsumerState<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends ConsumerState<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallbackBuilder?.call(_error!, _stackTrace) ??
             ErrorFallbackWidget(
               error: _error!,
               stackTrace: _stackTrace,
               onRetry: _retry,
               context: widget.context,
             );
    }

    return ErrorHandler(
      onError: _handleError,
      child: widget.child,
    );
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
    });

    // Log the error
    AdvancedLogger.error(
      'Error caught by ErrorBoundary',
      error: error is Exception ? error : Exception(error.toString()),
      stackTrace: stackTrace,
      data: {
        'context': widget.context ?? 'unknown',
        'widget_type': widget.child.runtimeType.toString(),
      },
    );

    // Report to error handling system
    ProductionErrorHandler.handleCustomError(
      error is Exception ? error : Exception(error.toString()),
      stackTrace: stackTrace,
      additionalContext: {
        'boundary_context': widget.context,
        'widget_type': widget.child.runtimeType.toString(),
      },
    );

    // Call custom error handler if provided
    widget.onError?.call(error, stackTrace);
  }

  void _retry() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });

    AdvancedLogger.info(
      'User retried after error',
      data: {
        'context': widget.context,
        'error_type': _error.runtimeType.toString(),
      },
    );
  }
}

class ErrorHandler extends StatefulWidget {
  final Widget child;
  final void Function(Object error, StackTrace? stackTrace) onError;

  const ErrorHandler({
    super.key,
    required this.child,
    required this.onError,
  });

  @override
  State<ErrorHandler> createState() => _ErrorHandlerState();
}

class _ErrorHandlerState extends State<ErrorHandler> {
  @override
  void initState() {
    super.initState();
    
    // Set up error handling for this widget subtree
    FlutterError.onError = (FlutterErrorDetails details) {
      widget.onError(details.exception, details.stack);
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// lib/presentation/widgets/error_widgets/error_fallback.dart
class ErrorFallbackWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String? context;

  const ErrorFallbackWidget({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = _getErrorMessage(error);
    final canRetry = _canRetry(error);
    final showDetails = _shouldShowDetails();

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getErrorIcon(error),
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (canRetry && onRetry != null) ...[
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh),
                  label: Text('Try Again'),
                ),
                SizedBox(width: 12),
              ],
              OutlinedButton.icon(
                onPressed: () => _reportProblem(context),
                icon: Icon(Icons.bug_report),
                label: Text('Report Problem'),
              ),
            ],
          ),
          if (showDetails) ...[
            SizedBox(height: 16),
            ExpansionTile(
              title: Text('Error Details'),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Error: ${error.toString()}\n\n'
                    'Context: ${context ?? 'unknown'}\n\n'
                    'Time: ${DateTime.now().toIso8601String()}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getErrorMessage(Object error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || 
        errorString.contains('socket') ||
        errorString.contains('connection')) {
      return 'Please check your internet connection and try again.';
    }
    
    if (errorString.contains('timeout')) {
      return 'The request is taking longer than expected. Please try again.';
    }
    
    if (errorString.contains('permission')) {
      return 'Permission required to access this feature.';
    }
    
    if (errorString.contains('authentication') ||
        errorString.contains('unauthorized')) {
      return 'Please sign in to continue.';
    }
    
    if (errorString.contains('validation') ||
        errorString.contains('invalid')) {
      return 'Please check your input and try again.';
    }
    
    return 'An unexpected error occurred. Please try again or contact support if the problem persists.';
  }

  IconData _getErrorIcon(Object error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || 
        errorString.contains('socket') ||
        errorString.contains('connection')) {
      return Icons.wifi_off;
    }
    
    if (errorString.contains('permission')) {
      return Icons.lock;
    }
    
    if (errorString.contains('authentication')) {
      return Icons.person_off;
    }
    
    if (errorString.contains('validation')) {
      return Icons.warning;
    }
    
    return Icons.error_outline;
  }

  bool _canRetry(Object error) {
    final errorString = error.toString().toLowerCase();
    
    // Network errors can usually be retried
    if (errorString.contains('network') || 
        errorString.contains('socket') ||
        errorString.contains('timeout')) {
      return true;
    }
    
    // Validation errors should not be retried without changes
    if (errorString.contains('validation') ||
        errorString.contains('invalid')) {
      return false;
    }
    
    // Most other errors can be retried
    return true;
  }

  bool _shouldShowDetails() {
    // Show details in debug mode or for specific error types
    return kDebugMode || error.toString().contains('debug');
  }

  void _reportProblem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ErrorReportDialog(
        error: error,
        stackTrace: stackTrace,
        context: this.context,
      ),
    );
  }
}

// lib/features/error_reporting/error_report_screen.dart
class ErrorReportDialog extends StatefulWidget {
  final Object error;
  final StackTrace? stackTrace;
  final String? context;

  const ErrorReportDialog({
    super.key,
    required this.error,
    this.stackTrace,
    this.context,
  });

  @override
  State<ErrorReportDialog> createState() => _ErrorReportDialogState();
}

class _ErrorReportDialogState extends State<ErrorReportDialog> {
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  bool _includeDeviceInfo = true;
  bool _includeLogs = true;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report Problem'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help us improve by reporting this issue. '
              'Your feedback is valuable and helps us fix problems faster.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email (optional)',
                hintText: 'your.email@example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'What were you doing when this happened?',
                hintText: 'Describe the steps that led to this error...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Include device information'),
              subtitle: Text('Device model, OS version, app version'),
              value: _includeDeviceInfo,
              onChanged: (value) {
                setState(() {
                  _includeDeviceInfo = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Include app logs'),
              subtitle: Text('Recent app activity (no personal data)'),
              value: _includeLogs,
              onChanged: (value) {
                setState(() {
                  _includeLogs = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Send Report'),
        ),
      ],
    );
  }

  Future<void> _submitReport() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final report = {
        'error': widget.error.toString(),
        'stack_trace': widget.stackTrace?.toString(),
        'context': widget.context,
        'user_description': _descriptionController.text,
        'user_email': _emailController.text,
        'timestamp': DateTime.now().toIso8601String(),
        'app_version': await PackageService.getVersion(),
        'build_number': await PackageService.getBuildNumber(),
        'platform': Platform.operatingSystem,
        'platform_version': Platform.operatingSystemVersion,
        if (_includeDeviceInfo) ...await _getDeviceInfo(),
        if (_includeLogs) 'recent_logs': await _getRecentLogs(),
      };

      await ErrorReportingService.submitReport(report);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you! Your report has been submitted.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      AdvancedLogger.info(
        'User submitted error report',
        data: {
          'error_type': widget.error.runtimeType.toString(),
          'has_description': _descriptionController.text.isNotEmpty,
          'has_email': _emailController.text.isNotEmpty,
        },
      );
    } catch (e) {
      AdvancedLogger.error('Failed to submit error report: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    // Implementation would use device_info_plus package
    return {
      'device_model': 'iPhone 14 Pro',
      'device_manufacturer': 'Apple',
      'os_version': 'iOS 16.1',
      'screen_resolution': '1179x2556',
      'memory_total': '6GB',
    };
  }

  Future<List<String>> _getRecentLogs() async {
    // Get recent logs (last 50 entries, excluding sensitive data)
    return [
      'INFO: User opened chat screen',
      'DEBUG: Network request started',
      'WARN: Slow network response (2.3s)',
      'ERROR: ${widget.error}',
    ];
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
```

*This covers the core implementation of production error handling, advanced logging, performance monitoring, and user-friendly error states. The workshop continues with crash reporting integration and production debugging tools...*

## 🚀 **How to Run**

```bash
# Navigate to ConnectPro Ultimate project
cd connectpro_ultimate

# Install error handling and monitoring dependencies
flutter pub add firebase_crashlytics firebase_analytics
flutter pub add device_info_plus battery_plus path_provider
flutter pub add flutter_riverpod dio

# Initialize Firebase services
firebase init crashlytics analytics

# Run the app with error handling
flutter run --release

# Test error handling and monitoring
flutter test test/error_handling/
flutter test test/monitoring/

# Generate error reports
flutter test --reporter=expanded test/
```

## 🎯 **Learning Outcomes**

After completing this error handling workshop, you will have mastered:
- **Production Error Handling Excellence** - Comprehensive error classification, intelligent recovery, and user-friendly feedback
- **Advanced Logging Infrastructure** - Multi-output logging with structured data and performance tracking
- **Crash Reporting & Monitoring** - Real-time crash detection with automatic reporting and trend analysis
- **Performance Monitoring** - Continuous performance tracking with optimization insights and alerting
- **User Experience Excellence** - Graceful error states with clear recovery guidance and seamless experience

**Ready to build bulletproof Flutter applications with enterprise-grade error handling and comprehensive production monitoring! 📊✨**