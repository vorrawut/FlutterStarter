# 📊 Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **🚨 Production Error Handling Excellence** - Comprehensive error handling strategies for enterprise Flutter applications
- **📋 Advanced Logging Frameworks** - Professional logging with structured data, performance tracking, and analytics integration
- **💥 Crash Reporting & Monitoring** - Real-time crash detection, automatic reporting, and intelligent error aggregation
- **📊 Performance Monitoring** - Application performance tracking, bottleneck identification, and optimization insights
- **🔍 Real-Time Error Tracking** - Live error monitoring, alerting systems, and proactive issue resolution
- **👤 User Experience Excellence** - Graceful error handling, user-friendly error states, and recovery guidance
- **🔧 Production Debugging** - Advanced debugging techniques for production applications and remote diagnostics
- **⚡ Error Recovery Mechanisms** - Automatic recovery, fallback strategies, and resilient application architecture

## 🚨 **Production Error Handling Excellence**

### **Comprehensive Error Handling Strategy**

Production Flutter applications require sophisticated error handling that goes beyond simple try-catch blocks:

```dart
// Enterprise Error Handling Framework
class ProductionErrorHandler {
  static const errorCategories = {
    'Network Errors': {
      'Description': 'Connectivity, API, and service communication failures',
      'Impact': 'User functionality disruption, data synchronization issues',
      'Recovery': 'Retry mechanisms, offline mode, cached data fallback',
      'Examples': [
        'Network connection lost during chat message sending',
        'API rate limiting during social feed refresh',
        'Firebase service temporary unavailability',
        'Large file upload interruption',
      ],
      'Handling Strategy': {
        'Immediate': 'Show user-friendly error message with retry option',
        'Background': 'Queue operations for retry when connection restored',
        'Fallback': 'Use cached data to maintain app functionality',
        'Recovery': 'Automatic retry with exponential backoff',
      },
    },
    
    'Authentication Errors': {
      'Description': 'User authentication and authorization failures',
      'Impact': 'Access restriction, security concerns, user workflow disruption',
      'Recovery': 'Token refresh, re-authentication flow, secure fallback',
      'Examples': [
        'Expired authentication tokens during app usage',
        'Multi-factor authentication failures',
        'Social login provider service outages',
        'Permission elevation requirements for sensitive operations',
      ],
      'Handling Strategy': {
        'Token Refresh': 'Automatic background token renewal',
        'Re-authentication': 'Seamless login flow without losing user context',
        'Permission Handling': 'Clear explanation and guidance for users',
        'Security Logging': 'Comprehensive audit trail for security events',
      },
    },
    
    'Data Validation Errors': {
      'Description': 'User input validation and data integrity failures',
      'Impact': 'Data corruption prevention, user experience disruption',
      'Recovery': 'Input correction guidance, data validation feedback',
      'Examples': [
        'Invalid email format during registration',
        'File size exceeding limits during media upload',
        'Profanity detection in chat messages',
        'Character limits exceeded in post content',
      ],
      'Handling Strategy': {
        'Real-time Validation': 'Immediate feedback during user input',
        'Clear Guidance': 'Specific instructions for error correction',
        'Progressive Enhancement': 'Allow partial completion with validation warnings',
        'Context Preservation': 'Maintain user input during validation errors',
      },
    },
    
    'System Resource Errors': {
      'Description': 'Memory, storage, and system capability limitations',
      'Impact': 'Application performance degradation, feature unavailability',
      'Recovery': 'Resource optimization, feature graceful degradation',
      'Examples': [
        'Out of memory during large image processing',
        'Insufficient storage for file downloads',
        'Camera unavailable due to hardware issues',
        'Background processing limitations on low-end devices',
      ],
      'Handling Strategy': {
        'Resource Monitoring': 'Proactive resource usage tracking',
        'Graceful Degradation': 'Reduce functionality based on available resources',
        'User Communication': 'Clear explanation of resource limitations',
        'Alternative Solutions': 'Offer lower-resource alternatives',
      },
    },
  };

  // Error Classification and Prioritization
  static ErrorPriority classifyError(Exception error, Map<String, dynamic> context) {
    if (error is NetworkException) {
      return context['isBackgroundOperation'] == true 
          ? ErrorPriority.low 
          : ErrorPriority.medium;
    }
    
    if (error is AuthenticationException) {
      return context['isSecuritySensitive'] == true 
          ? ErrorPriority.critical 
          : ErrorPriority.high;
    }
    
    if (error is DataCorruptionException) {
      return ErrorPriority.critical;
    }
    
    if (error is UserInputException) {
      return ErrorPriority.low;
    }
    
    return ErrorPriority.medium;
  }

  // Contextual Error Recovery
  static Future<ErrorRecoveryResult> attemptRecovery(
    Exception error, 
    Map<String, dynamic> context,
  ) async {
    switch (error.runtimeType) {
      case NetworkException:
        return await _handleNetworkError(error as NetworkException, context);
      case AuthenticationException:
        return await _handleAuthError(error as AuthenticationException, context);
      case ValidationException:
        return await _handleValidationError(error as ValidationException, context);
      default:
        return await _handleGenericError(error, context);
    }
  }

  // Network Error Recovery with Intelligent Retry
  static Future<ErrorRecoveryResult> _handleNetworkError(
    NetworkException error, 
    Map<String, dynamic> context,
  ) async {
    // Check if operation can be queued for retry
    if (context['canBeQueued'] == true) {
      await OfflineOperationQueue.enqueue(context['operation']);
      return ErrorRecoveryResult.queued(
        message: 'Operation queued for when connection is restored',
        shouldShowToUser: true,
      );
    }

    // Attempt immediate retry for critical operations
    if (context['isCritical'] == true) {
      try {
        await Future.delayed(Duration(seconds: 2));
        final result = await (context['retryOperation'] as Function)();
        return ErrorRecoveryResult.recovered(
          data: result,
          message: 'Operation completed successfully',
        );
      } catch (retryError) {
        return ErrorRecoveryResult.failed(
          error: retryError,
          message: 'Unable to complete operation. Please try again later.',
          shouldShowToUser: true,
        );
      }
    }

    // Use cached data if available
    if (context['cachedData'] != null) {
      return ErrorRecoveryResult.fallback(
        data: context['cachedData'],
        message: 'Showing cached content',
        shouldShowToUser: false,
      );
    }

    return ErrorRecoveryResult.failed(
      error: error,
      message: 'Please check your internet connection and try again',
      shouldShowToUser: true,
    );
  }

  // Authentication Error Recovery with Token Management
  static Future<ErrorRecoveryResult> _handleAuthError(
    AuthenticationException error, 
    Map<String, dynamic> context,
  ) async {
    switch (error.type) {
      case AuthErrorType.tokenExpired:
        try {
          await AuthService.refreshToken();
          final result = await (context['retryOperation'] as Function)();
          return ErrorRecoveryResult.recovered(
            data: result,
            message: 'Authentication refreshed successfully',
          );
        } catch (refreshError) {
          // Redirect to login if refresh fails
          NavigationService.navigateToLogin();
          return ErrorRecoveryResult.redirected(
            message: 'Please sign in again to continue',
            shouldShowToUser: true,
          );
        }
        
      case AuthErrorType.insufficientPermissions:
        return ErrorRecoveryResult.failed(
          error: error,
          message: 'You don\'t have permission to perform this action',
          shouldShowToUser: true,
          actionButton: ActionButton(
            text: 'Contact Support',
            onPressed: () => SupportService.contactSupport(context['operation']),
          ),
        );
        
      case AuthErrorType.accountLocked:
        return ErrorRecoveryResult.failed(
          error: error,
          message: 'Your account has been temporarily locked for security',
          shouldShowToUser: true,
          actionButton: ActionButton(
            text: 'Learn More',
            onPressed: () => HelpService.showAccountLockInfo(),
          ),
        );
        
      default:
        NavigationService.navigateToLogin();
        return ErrorRecoveryResult.redirected(
          message: 'Authentication required. Please sign in.',
          shouldShowToUser: true,
        );
    }
  }
}
```

### **Advanced Error Context Collection**

```dart
// Comprehensive Error Context Framework
class ErrorContextCollector {
  static Map<String, dynamic> collectContext({
    required Exception error,
    String? userId,
    String? screenName,
    Map<String, dynamic>? additionalContext,
  }) {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'errorType': error.runtimeType.toString(),
      'errorMessage': error.toString(),
      'stackTrace': StackTrace.current.toString(),
      
      // User Context
      'userId': userId,
      'userAgent': Platform.operatingSystem,
      'deviceInfo': _getDeviceInfo(),
      'appVersion': _getAppVersion(),
      'buildNumber': _getBuildNumber(),
      
      // Application State
      'screenName': screenName,
      'navigationStack': NavigationService.getCurrentStack(),
      'appState': _getAppState(),
      'memoryUsage': _getMemoryUsage(),
      'networkStatus': _getNetworkStatus(),
      
      // Performance Context
      'cpuUsage': _getCpuUsage(),
      'batteryLevel': _getBatteryLevel(),
      'availableStorage': _getAvailableStorage(),
      'renderingPerformance': _getRenderingMetrics(),
      
      // Feature Context
      'activeFeatures': _getActiveFeatures(),
      'experimentalFlags': _getExperimentalFlags(),
      'userPermissions': _getUserPermissions(),
      
      // Custom Context
      ...?additionalContext,
    };
  }

  static DeviceInfo _getDeviceInfo() {
    return DeviceInfo(
      platform: Platform.operatingSystem,
      version: Platform.operatingSystemVersion,
      model: '', // Would get from device_info_plus
      manufacturer: '', // Would get from device_info_plus
      screenResolution: MediaQuery.of(NavigationService.context).size,
      pixelDensity: MediaQuery.of(NavigationService.context).devicePixelRatio,
    );
  }

  static AppStateInfo _getAppState() {
    return AppStateInfo(
      authenticationState: AuthService.isAuthenticated(),
      connectionState: NetworkService.getConnectionState(),
      backgroundState: WidgetsBinding.instance.lifecycleState,
      activeProviders: _getActiveProviders(),
      cacheStatus: _getCacheStatus(),
    );
  }

  static PerformanceMetrics _getRenderingMetrics() {
    return PerformanceMetrics(
      frameRate: PerformanceService.getCurrentFrameRate(),
      frameRenderTime: PerformanceService.getAverageRenderTime(),
      memoryPressure: PerformanceService.getMemoryPressure(),
      thermalState: PerformanceService.getThermalState(),
    );
  }
}
```

## 📋 **Advanced Logging Framework**

### **Structured Logging Architecture**

```dart
// Enterprise Logging Framework with Multiple Outputs
class AdvancedLogger {
  static const logLevels = {
    'TRACE': {
      'Level': 0,
      'Purpose': 'Detailed execution flow for debugging complex issues',
      'Production': false,
      'Examples': [
        'Function entry/exit with parameters',
        'Loop iterations and conditions',
        'State transitions in detail',
        'Performance measurement points',
      ],
    },
    
    'DEBUG': {
      'Level': 1,
      'Purpose': 'Development debugging information and diagnostic data',
      'Production': false,
      'Examples': [
        'User interaction events and responses',
        'Data transformation and validation steps',
        'Cache hits and misses',
        'Network request/response details',
      ],
    },
    
    'INFO': {
      'Level': 2,
      'Purpose': 'General application flow and important events',
      'Production': true,
      'Examples': [
        'User authentication and authorization events',
        'Feature usage and engagement metrics',
        'System startup and shutdown events',
        'Configuration changes and updates',
      ],
    },
    
    'WARN': {
      'Level': 3,
      'Purpose': 'Potential issues that don\'t prevent operation',
      'Production': true,
      'Examples': [
        'Deprecated feature usage warnings',
        'Performance degradation indicators',
        'Resource usage approaching limits',
        'Retry attempts and fallback activations',
      ],
    },
    
    'ERROR': {
      'Level': 4,
      'Purpose': 'Error conditions that disrupt normal operation',
      'Production': true,
      'Examples': [
        'Unhandled exceptions and crashes',
        'API failures and timeout errors',
        'Data corruption or validation failures',
        'Security violations and unauthorized access',
      ],
    },
    
    'FATAL': {
      'Level': 5,
      'Purpose': 'Critical errors that may cause application termination',
      'Production': true,
      'Examples': [
        'Unrecoverable system errors',
        'Critical security breaches',
        'Data loss or corruption events',
        'Application initialization failures',
      ],
    },
  };

  // Multi-Output Logging System
  static final List<LogOutput> _outputs = [
    ConsoleLogOutput(),
    FileLogOutput(),
    FirebaseLogOutput(),
    AnalyticsLogOutput(),
    CrashReportingOutput(),
  ];

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
    final logEntry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag ?? _getCallerTag(),
      data: data,
      error: error,
      stackTrace: stackTrace,
      userId: userId ?? AuthService.getCurrentUserId(),
      sessionId: sessionId ?? SessionService.getCurrentSessionId(),
      context: ErrorContextCollector.collectContext(
        error: error ?? Exception(message),
        userId: userId,
        screenName: NavigationService.getCurrentScreen(),
        additionalContext: data,
      ),
    );

    // Filter based on production/debug settings
    if (_shouldLog(level)) {
      _outputs.forEach((output) => output.write(logEntry));
    }

    // Handle critical errors immediately
    if (level == LogLevel.FATAL || level == LogLevel.ERROR) {
      _handleCriticalLog(logEntry);
    }
  }

  // Specialized Logging Methods
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

  // Performance Logging
  static void logPerformance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metrics,
  }) {
    log(
      level: LogLevel.INFO,
      message: 'Performance: $operation completed in ${duration.inMilliseconds}ms',
      tag: 'PERFORMANCE',
      data: {
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
        'duration_readable': _formatDuration(duration),
        ...?metrics,
      },
    );
  }

  // User Interaction Logging
  static void logUserAction({
    required String action,
    String? screen,
    Map<String, dynamic>? details,
  }) {
    log(
      level: LogLevel.INFO,
      message: 'User Action: $action',
      tag: 'USER_INTERACTION',
      data: {
        'action': action,
        'screen': screen ?? NavigationService.getCurrentScreen(),
        'timestamp': DateTime.now().toIso8601String(),
        ...?details,
      },
    );
  }

  // Business Logic Logging
  static void logBusinessEvent({
    required String event,
    required String category,
    Map<String, dynamic>? properties,
  }) {
    log(
      level: LogLevel.INFO,
      message: 'Business Event: $event',
      tag: 'BUSINESS_LOGIC',
      data: {
        'event': event,
        'category': category,
        'properties': properties,
        'user_id': AuthService.getCurrentUserId(),
        'session_id': SessionService.getCurrentSessionId(),
      },
    );
  }

  // Security Logging
  static void logSecurityEvent({
    required String event,
    required SecurityLevel level,
    Map<String, dynamic>? details,
  }) {
    log(
      level: level == SecurityLevel.critical ? LogLevel.ERROR : LogLevel.WARN,
      message: 'Security Event: $event',
      tag: 'SECURITY',
      data: {
        'security_event': event,
        'security_level': level.toString(),
        'ip_address': NetworkService.getCurrentIP(),
        'user_agent': DeviceService.getUserAgent(),
        ...?details,
      },
    );
  }

  static bool _shouldLog(LogLevel level) {
    if (kDebugMode) return true;
    return level.index >= LogLevel.INFO.index;
  }

  static void _handleCriticalLog(LogEntry entry) {
    // Immediate crash reporting
    CrashReportingService.reportCrash(entry);
    
    // Real-time alerting for production
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

  static String _formatDuration(Duration duration) {
    if (duration.inMilliseconds < 1000) {
      return '${duration.inMilliseconds}ms';
    } else if (duration.inSeconds < 60) {
      return '${duration.inSeconds}.${duration.inMilliseconds % 1000}s';
    } else {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
  }
}
```

### **Log Output Implementations**

```dart
// Multiple Log Output Destinations
abstract class LogOutput {
  void write(LogEntry entry);
  Future<void> flush();
  void configure(Map<String, dynamic> config);
}

// Console Output for Development
class ConsoleLogOutput implements LogOutput {
  @override
  void write(LogEntry entry) {
    if (kDebugMode) {
      final colorCode = _getColorCode(entry.level);
      final timestamp = entry.timestamp.toIso8601String();
      final levelStr = entry.level.toString().split('.').last.padRight(5);
      final tag = entry.tag != null ? '[${entry.tag}] ' : '';
      
      print('$colorCode$timestamp $levelStr $tag${entry.message}\x1B[0m');
      
      if (entry.error != null) {
        print('$colorCode  Error: ${entry.error}\x1B[0m');
      }
      
      if (entry.data != null && entry.data!.isNotEmpty) {
        print('$colorCode  Data: ${jsonEncode(entry.data)}\x1B[0m');
      }
    }
  }

  String _getColorCode(LogLevel level) {
    switch (level) {
      case LogLevel.TRACE: return '\x1B[37m'; // White
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
  void configure(Map<String, dynamic> config) {
    // No configuration needed for console output
  }
}

// File Output for Local Persistence
class FileLogOutput implements LogOutput {
  static const String _logFileName = 'connectpro_logs.json';
  static const int _maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int _maxFiles = 5;
  
  List<LogEntry> _buffer = [];
  Timer? _flushTimer;

  FileLogOutput() {
    // Periodic flush every 30 seconds
    _flushTimer = Timer.periodic(Duration(seconds: 30), (_) => flush());
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
    if (_buffer.isEmpty) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_logFileName');
      
      // Check file size and rotate if necessary
      if (await file.exists()) {
        final size = await file.length();
        if (size > _maxFileSize) {
          await _rotateLogFiles(directory);
        }
      }

      // Append new log entries
      final entries = _buffer.map((entry) => entry.toJson()).toList();
      final logData = entries.map((entry) => jsonEncode(entry)).join('\n') + '\n';
      
      await file.writeAsString(logData, mode: FileMode.append);
      _buffer.clear();
    } catch (e) {
      // Fallback to console if file logging fails
      print('Failed to write logs to file: $e');
    }
  }

  Future<void> _rotateLogFiles(Directory directory) async {
    for (int i = _maxFiles - 1; i >= 1; i--) {
      final oldFile = File('${directory.path}/${_logFileName}.$i');
      final newFile = File('${directory.path}/${_logFileName}.${i + 1}');
      
      if (await oldFile.exists()) {
        if (i == _maxFiles - 1) {
          await oldFile.delete(); // Delete oldest file
        } else {
          await oldFile.rename(newFile.path);
        }
      }
    }
    
    // Move current log to .1
    final currentFile = File('${directory.path}/$_logFileName');
    if (await currentFile.exists()) {
      await currentFile.rename('${directory.path}/${_logFileName}.1');
    }
  }

  @override
  void configure(Map<String, dynamic> config) {
    // Could configure max file size, rotation policy, etc.
  }

  void dispose() {
    _flushTimer?.cancel();
    flush();
  }
}

// Firebase Analytics Output
class FirebaseLogOutput implements LogOutput {
  @override
  void write(LogEntry entry) {
    // Only send significant events to Firebase Analytics
    if (entry.level.index >= LogLevel.WARN.index || 
        entry.tag == 'USER_INTERACTION' || 
        entry.tag == 'BUSINESS_LOGIC') {
      
      FirebaseAnalytics.instance.logEvent(
        name: 'app_log_event',
        parameters: {
          'log_level': entry.level.toString(),
          'log_message': entry.message.length > 100 
              ? entry.message.substring(0, 100) 
              : entry.message,
          'log_tag': entry.tag ?? 'GENERAL',
          'user_id': entry.userId,
          'session_id': entry.sessionId,
          if (entry.data != null) ...entry.data!,
        },
      );
    }
  }

  @override
  Future<void> flush() async {
    // Firebase Analytics handles buffering
  }

  @override
  void configure(Map<String, dynamic> config) {
    // Firebase Analytics configuration
  }
}

// Crashlytics Output for Error Reporting
class CrashReportingOutput implements LogOutput {
  @override
  void write(LogEntry entry) {
    if (entry.level == LogLevel.ERROR || entry.level == LogLevel.FATAL) {
      FirebaseCrashlytics.instance.log(entry.message);
      
      if (entry.error != null) {
        FirebaseCrashlytics.instance.recordError(
          entry.error,
          entry.stackTrace,
          information: [
            'Tag: ${entry.tag}',
            'User ID: ${entry.userId}',
            'Session ID: ${entry.sessionId}',
            if (entry.data != null) 'Data: ${jsonEncode(entry.data)}',
          ],
          fatal: entry.level == LogLevel.FATAL,
        );
      }
    }
  }

  @override
  Future<void> flush() async {
    // Crashlytics handles immediate reporting
  }

  @override
  void configure(Map<String, dynamic> config) {
    // Crashlytics configuration
  }
}
```

## 💥 **Crash Reporting & Monitoring**

### **Comprehensive Crash Detection and Reporting**

```dart
// Advanced Crash Reporting Framework
class CrashReportingService {
  static bool _isInitialized = false;
  static late String _crashReportingEndpoint;
  static final List<CrashInterceptor> _interceptors = [];

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize Firebase Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Set up Flutter error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Set up Dart error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleDartError(error, stack);
      return true;
    };

    // Initialize custom crash reporting
    _crashReportingEndpoint = Environment.crashReportingEndpoint;
    _setupCrashInterceptors();
    
    _isInitialized = true;
    AdvancedLogger.info('Crash reporting initialized successfully');
  }

  static void _handleFlutterError(FlutterErrorDetails details) {
    // Log the error
    AdvancedLogger.fatal(
      'Flutter Error: ${details.exceptionAsString()}',
      error: details.exception is Exception 
          ? details.exception as Exception
          : Exception(details.exception.toString()),
      stackTrace: details.stack,
      data: {
        'error_type': 'flutter_error',
        'library': details.library,
        'context': details.context?.toString(),
        'information': details.informationCollector?.call(),
      },
    );

    // Report to Crashlytics
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);

    // Apply interceptors
    for (final interceptor in _interceptors) {
      interceptor.onFlutterError(details);
    }

    // Show user-friendly error in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    } else {
      _showUserFriendlyError('An unexpected error occurred. The team has been notified.');
    }
  }

  static bool _handleDartError(Object error, StackTrace stackTrace) {
    // Log the error
    AdvancedLogger.fatal(
      'Dart Error: ${error.toString()}',
      error: error is Exception ? error : Exception(error.toString()),
      stackTrace: stackTrace,
      data: {
        'error_type': 'dart_error',
        'runtime_type': error.runtimeType.toString(),
      },
    );

    // Report to Crashlytics
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: true,
    );

    // Apply interceptors
    for (final interceptor in _interceptors) {
      interceptor.onDartError(error, stackTrace);
    }

    // Show user-friendly error
    _showUserFriendlyError('A critical error occurred. Please restart the app.');
    
    return true;
  }

  static void _setupCrashInterceptors() {
    // Network crash interceptor
    _interceptors.add(NetworkCrashInterceptor());
    
    // Memory crash interceptor
    _interceptors.add(MemoryCrashInterceptor());
    
    // UI crash interceptor
    _interceptors.add(UICrashInterceptor());
    
    // Custom business logic crash interceptor
    _interceptors.add(BusinessLogicCrashInterceptor());
  }

  static void reportCrash(LogEntry entry) {
    // Send to multiple reporting services
    _reportToFirebase(entry);
    _reportToCustomEndpoint(entry);
    _reportToAnalytics(entry);
  }

  static void _reportToFirebase(LogEntry entry) {
    FirebaseCrashlytics.instance.log(entry.message);
    
    if (entry.error != null) {
      FirebaseCrashlytics.instance.recordError(
        entry.error,
        entry.stackTrace,
        information: [
          'User ID: ${entry.userId}',
          'Session ID: ${entry.sessionId}',
          'Screen: ${entry.context['screenName']}',
          'App Version: ${entry.context['appVersion']}',
          'Device Info: ${jsonEncode(entry.context['deviceInfo'])}',
        ],
        fatal: entry.level == LogLevel.FATAL,
      );
    }
  }

  static Future<void> _reportToCustomEndpoint(LogEntry entry) async {
    try {
      final crashReport = {
        'timestamp': entry.timestamp.toIso8601String(),
        'level': entry.level.toString(),
        'message': entry.message,
        'error': entry.error?.toString(),
        'stackTrace': entry.stackTrace?.toString(),
        'context': entry.context,
        'userId': entry.userId,
        'sessionId': entry.sessionId,
        'appVersion': entry.context['appVersion'],
        'platform': Platform.operatingSystem,
      };

      await http.post(
        Uri.parse(_crashReportingEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(crashReport),
      );
    } catch (e) {
      // Fallback: store crash report locally for later upload
      await _storeCrashReportLocally(entry);
    }
  }

  static void _reportToAnalytics(LogEntry entry) {
    FirebaseAnalytics.instance.logEvent(
      name: 'app_crash',
      parameters: {
        'crash_level': entry.level.toString(),
        'crash_message': entry.message.length > 100 
            ? entry.message.substring(0, 100) 
            : entry.message,
        'error_type': entry.error?.runtimeType.toString() ?? 'unknown',
        'user_id': entry.userId,
        'session_id': entry.sessionId,
        'app_version': entry.context['appVersion'],
        'platform': Platform.operatingSystem,
      },
    );
  }

  static Future<void> _storeCrashReportLocally(LogEntry entry) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/crash_reports.json');
      
      final crashReport = {
        'timestamp': entry.timestamp.toIso8601String(),
        'level': entry.level.toString(),
        'message': entry.message,
        'error': entry.error?.toString(),
        'stackTrace': entry.stackTrace?.toString(),
        'context': entry.context,
        'userId': entry.userId,
        'sessionId': entry.sessionId,
      };

      String content = jsonEncode(crashReport) + '\n';
      await file.writeAsString(content, mode: FileMode.append);
    } catch (e) {
      // Last resort: print to console
      print('Failed to store crash report locally: $e');
    }
  }

  static void _showUserFriendlyError(String message) {
    // This would show a user-friendly error dialog
    // Implementation depends on your UI framework
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (NavigationService.context != null) {
        showDialog(
          context: NavigationService.context!,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Oops! Something went wrong'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () => _sendFeedback(),
                child: Text('Send Feedback'),
              ),
            ],
          ),
        );
      }
    });
  }

  static void _sendFeedback() {
    // Open feedback form or email
    FeedbackService.openFeedbackForm(
      subject: 'App Error Report',
      includeDeviceInfo: true,
      includeLogs: true,
    );
  }

  // User ID and Custom Keys for Crash Context
  static void setUserId(String userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  static void setCustomKey(String key, String value) {
    FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  static void addBreadcrumb(String message, {Map<String, String>? data}) {
    FirebaseCrashlytics.instance.log(message);
    
    // Also add to custom breadcrumb system
    BreadcrumbService.add(
      message: message,
      timestamp: DateTime.now(),
      data: data,
    );
  }
}

// Crash Interceptors for Specific Error Types
abstract class CrashInterceptor {
  void onFlutterError(FlutterErrorDetails details);
  void onDartError(Object error, StackTrace stackTrace);
}

class NetworkCrashInterceptor implements CrashInterceptor {
  @override
  void onFlutterError(FlutterErrorDetails details) {
    if (details.exception.toString().contains('SocketException') ||
        details.exception.toString().contains('HttpException')) {
      AdvancedLogger.warn(
        'Network-related crash detected',
        data: {
          'network_status': NetworkService.getConnectionState(),
          'last_successful_request': NetworkService.getLastSuccessfulRequest(),
        },
      );
    }
  }

  @override
  void onDartError(Object error, StackTrace stackTrace) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('HttpException')) {
      // Attempt to recover network connectivity
      NetworkService.refreshConnection();
    }
  }
}

class MemoryCrashInterceptor implements CrashInterceptor {
  @override
  void onFlutterError(FlutterErrorDetails details) {
    if (details.exception.toString().contains('OutOfMemoryError')) {
      AdvancedLogger.error(
        'Memory crash detected',
        data: {
          'memory_usage': PerformanceService.getCurrentMemoryUsage(),
          'memory_pressure': PerformanceService.getMemoryPressure(),
          'active_widgets': PerformanceService.getActiveWidgetCount(),
        },
      );
      
      // Attempt memory cleanup
      MemoryService.performEmergencyCleanup();
    }
  }

  @override
  void onDartError(Object error, StackTrace stackTrace) {
    // Check for memory-related errors
  }
}
```

This covers the first part of the Error Handling & Logging concepts, focusing on production error handling, advanced logging frameworks, and crash reporting. The lesson continues with performance monitoring, real-time error tracking, user experience during errors, and production debugging strategies.

**Ready to build bulletproof Flutter applications with enterprise-grade error handling and comprehensive monitoring! 📊✨**