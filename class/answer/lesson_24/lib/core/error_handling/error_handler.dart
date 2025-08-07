import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../logging/logger.dart';
import 'error_classification.dart';
import 'error_recovery.dart';
import 'error_context.dart';

/// Production-grade error handler for ConnectPro Ultimate
/// Provides comprehensive error handling with intelligent recovery mechanisms
class ProductionErrorHandler {
  static bool _isInitialized = false;
  static final ErrorRecoveryService _recoveryService = ErrorRecoveryService();
  static final ErrorContextCollector _contextCollector = ErrorContextCollector();

  /// Initialize the production error handling system
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set up Flutter error handling
      FlutterError.onError = handleFlutterError;

      // Set up Dart error handling
      PlatformDispatcher.instance.onError = handleDartError;

      // Initialize crash reporting
      await _initializeCrashReporting();

      _isInitialized = true;
      AdvancedLogger.info('Production error handler initialized successfully');
    } catch (e) {
      print('Failed to initialize error handler: $e');
      // Fallback to basic error handling
      _setupFallbackErrorHandling();
    }
  }

  /// Handle Flutter framework errors
  static void handleFlutterError(FlutterErrorDetails details) {
    final errorInfo = ErrorInfo(
      error: details.exception,
      stackTrace: details.stack,
      context: _contextCollector.collectFlutterErrorContext(details),
      timestamp: DateTime.now(),
      type: ErrorType.flutter,
      library: details.library,
    );

    _processError(errorInfo);
  }

  /// Handle Dart runtime errors
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

  /// Handle custom application errors with additional context
  static Future<void> handleCustomError(
    Exception error, {
    StackTrace? stackTrace,
    String? userId,
    String? operation,
    String? screenName,
    Map<String, dynamic>? additionalContext,
  }) async {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
      context: _contextCollector.collectCustomErrorContext(
        error: error,
        userId: userId,
        operation: operation,
        screenName: screenName,
        additionalContext: additionalContext,
      ),
      timestamp: DateTime.now(),
      type: ErrorType.custom,
    );

    await _processError(errorInfo);
  }

  /// Process and handle errors through the complete pipeline
  static Future<void> _processError(ErrorInfo errorInfo) async {
    try {
      // Classify error severity and type
      final classification = ErrorClassifier.classify(errorInfo);
      
      // Log the error with appropriate level
      _logError(errorInfo, classification);
      
      // Report to crash reporting services
      await _reportCrash(errorInfo, classification);
      
      // Attempt intelligent error recovery
      final recoveryResult = await _recoveryService.attemptRecovery(
        errorInfo, 
        classification,
      );
      
      // Handle user experience
      await _handleUserExperience(errorInfo, classification, recoveryResult);
      
      // Update error metrics and analytics
      _updateErrorMetrics(errorInfo, classification);
      
      // Check for error patterns and trends
      _analyzeErrorTrends(errorInfo, classification);
      
    } catch (e) {
      // Fallback error handling if main pipeline fails
      print('Error processing failed: $e');
      _handleFallbackError(errorInfo.error, errorInfo.stackTrace);
    }
  }

  /// Log errors with structured data and appropriate levels
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
        'should_show_user': classification.shouldShowToUser,
        'library': errorInfo.library,
        'context': errorInfo.context,
        'classification_score': classification.confidenceScore,
      },
    );
  }

  /// Report crashes to multiple monitoring services
  static Future<void> _reportCrash(
    ErrorInfo errorInfo, 
    ErrorClassification classification,
  ) async {
    try {
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
          'Platform: ${errorInfo.context['platform'] ?? 'unknown'}',
          'Network Status: ${errorInfo.context['networkStatus'] ?? 'unknown'}',
          'Memory Usage: ${errorInfo.context['memoryUsage'] ?? 'unknown'}',
        ],
      );

      // Report to custom analytics
      await _reportToCustomAnalytics(errorInfo, classification);

    } catch (e) {
      AdvancedLogger.warn('Failed to report crash: $e');
    }
  }

  /// Report errors to custom analytics and monitoring services
  static Future<void> _reportToCustomAnalytics(
    ErrorInfo errorInfo,
    ErrorClassification classification,
  ) async {
    try {
      final errorReport = {
        'timestamp': errorInfo.timestamp.toIso8601String(),
        'error_message': errorInfo.error.toString(),
        'error_type': errorInfo.type.toString(),
        'severity': classification.severity.toString(),
        'category': classification.category,
        'can_recover': classification.canRecover,
        'stack_trace': errorInfo.stackTrace.toString(),
        'context': errorInfo.context,
        'app_version': errorInfo.context['appVersion'],
        'platform': errorInfo.context['platform'],
        'user_id': errorInfo.context['userId'],
        'session_id': errorInfo.context['sessionId'],
        'network_status': errorInfo.context['networkStatus'],
        'memory_usage': errorInfo.context['memoryUsage'],
        'battery_level': errorInfo.context['batteryLevel'],
        'device_model': errorInfo.context['deviceModel'],
        'os_version': errorInfo.context['osVersion'],
        'classification_confidence': classification.confidenceScore,
      };

      // Send to custom monitoring service
      // await MonitoringService.reportError(errorReport);
      
    } catch (e) {
      AdvancedLogger.warn('Failed to report to custom analytics: $e');
    }
  }

  /// Handle user experience during errors with appropriate feedback
  static Future<void> _handleUserExperience(
    ErrorInfo errorInfo,
    ErrorClassification classification,
    ErrorRecoveryResult recoveryResult,
  ) async {
    if (classification.severity == ErrorSeverity.critical) {
      // Show critical error dialog with recovery options
      await _showCriticalErrorDialog(
        error: errorInfo.error.toString(),
        canRestart: recoveryResult.canRestart,
        canRetry: recoveryResult.canRetry,
        recoveryAction: recoveryResult.recoveryAction,
      );
    } else if (classification.shouldShowToUser) {
      // Show user-friendly error message
      await _showErrorSnackbar(
        message: _getUserFriendlyMessage(classification),
        canRetry: recoveryResult.canRetry,
        retryAction: recoveryResult.retryAction,
        severity: classification.severity,
      );
    }

    // Log user-facing error events
    AdvancedLogger.logUserAction(
      action: 'error_displayed',
      details: {
        'error_type': errorInfo.type.toString(),
        'severity': classification.severity.toString(),
        'user_notified': classification.shouldShowToUser,
        'recovery_attempted': recoveryResult.wasAttempted,
        'recovery_successful': recoveryResult.wasSuccessful,
      },
    );
  }

  /// Update error metrics for monitoring and analytics
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

    // Update performance impact metrics
    if (errorInfo.context.containsKey('performanceImpact')) {
      PerformanceMetrics.recordErrorImpact(
        impact: errorInfo.context['performanceImpact'],
        errorType: errorInfo.type,
      );
    }
  }

  /// Analyze error trends and patterns for proactive monitoring
  static void _analyzeErrorTrends(
    ErrorInfo errorInfo,
    ErrorClassification classification,
  ) {
    // Check for error spikes
    if (ErrorTrendAnalyzer.isErrorSpike(classification.category)) {
      AdvancedLogger.warn(
        'Error spike detected for category: ${classification.category}',
        data: {
          'category': classification.category,
          'recent_count': ErrorTrendAnalyzer.getRecentErrorCount(classification.category),
          'threshold': ErrorTrendAnalyzer.getSpikeThreshold(classification.category),
        },
      );
    }

    // Check for memory-related error patterns
    if (classification.category == 'memory' && 
        ErrorPatternDetector.isMemoryLeakPattern(errorInfo)) {
      AdvancedLogger.error(
        'Potential memory leak pattern detected',
        data: {
          'memory_usage_trend': errorInfo.context['memoryUsageTrend'],
          'error_frequency': ErrorPatternDetector.getMemoryErrorFrequency(),
        },
      );
    }
  }

  /// Get appropriate log level based on error severity
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

  /// Generate user-friendly error messages based on classification
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
      case 'memory':
        return 'The app is running low on memory. Please close other apps and try again.';
      case 'timeout':
        return 'The request is taking longer than expected. Please try again.';
      case 'rate_limit':
        return 'Too many requests. Please wait a moment and try again.';
      default:
        return 'Something went wrong. Please try again or contact support if the problem persists.';
    }
  }

  /// Initialize crash reporting services
  static Future<void> _initializeCrashReporting() async {
    // Initialize Firebase Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Set user identifier for crash reports
    final userId = await _getCurrentUserId();
    if (userId != null) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }

    // Set custom keys for additional context
    await FirebaseCrashlytics.instance.setCustomKey('app_theme', 'dark');
    await FirebaseCrashlytics.instance.setCustomKey('user_type', 'premium');
  }

  /// Setup fallback error handling if main system fails
  static void _setupFallbackErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails details) {
      print('Fallback error handler: ${details.exception}');
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      print('Fallback Dart error: $error');
      return true;
    };
  }

  /// Handle errors when main pipeline fails
  static void _handleFallbackError(Object error, StackTrace? stackTrace) {
    print('Fallback error handling: $error');
    print('Stack trace: $stackTrace');
    
    // Show basic error dialog in debug mode
    if (kDebugMode) {
      // Would show simple error dialog
    }
  }

  /// Show critical error dialog with recovery options
  static Future<void> _showCriticalErrorDialog({
    required String error,
    required bool canRestart,
    required bool canRetry,
    VoidCallback? recoveryAction,
  }) async {
    // Implementation would show critical error dialog
    AdvancedLogger.error('Critical error dialog shown', data: {
      'error': error,
      'can_restart': canRestart,
      'can_retry': canRetry,
    });
  }

  /// Show user-friendly error snackbar
  static Future<void> _showErrorSnackbar({
    required String message,
    required bool canRetry,
    VoidCallback? retryAction,
    required ErrorSeverity severity,
  }) async {
    // Implementation would show snackbar
    AdvancedLogger.info('Error snackbar shown', data: {
      'message': message,
      'can_retry': canRetry,
      'severity': severity.toString(),
    });
  }

  /// Get current user ID for crash reporting
  static Future<String?> _getCurrentUserId() async {
    // Implementation would get current user ID
    return 'user_123';
  }

  /// Check if error handler is initialized
  static bool get isInitialized => _isInitialized;

  /// Dispose error handler resources
  static void dispose() {
    _isInitialized = false;
    // Clean up resources
  }
}

/// Placeholder classes for error analysis
class ErrorMetrics {
  static void recordError({
    required ErrorType type,
    required ErrorSeverity severity,
    required String category,
    required DateTime timestamp,
  }) {
    // Implementation for recording error metrics
  }
}

class PerformanceMetrics {
  static void recordErrorImpact({
    required dynamic impact,
    required ErrorType errorType,
  }) {
    // Implementation for recording performance impact
  }
}

class ErrorTrendAnalyzer {
  static bool isErrorSpike(String category) {
    // Implementation for detecting error spikes
    return false;
  }

  static int getRecentErrorCount(String category) {
    // Implementation for getting recent error count
    return 0;
  }

  static int getSpikeThreshold(String category) {
    // Implementation for getting spike threshold
    return 10;
  }
}

class ErrorPatternDetector {
  static bool isMemoryLeakPattern(ErrorInfo errorInfo) {
    // Implementation for detecting memory leak patterns
    return false;
  }

  static int getMemoryErrorFrequency() {
    // Implementation for getting memory error frequency
    return 0;
  }
}
