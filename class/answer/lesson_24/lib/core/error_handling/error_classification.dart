import 'dart:math' as math;

/// Error types for classification
enum ErrorType { 
  flutter, 
  dart, 
  network, 
  authentication, 
  validation, 
  storage,
  memory,
  custom 
}

/// Error severity levels
enum ErrorSeverity { 
  low,      // Minor issues, app continues normally
  medium,   // Noticeable issues, some functionality affected
  high,     // Significant issues, major functionality affected
  critical  // App-breaking issues, immediate attention required
}

/// Security event severity levels
enum SecurityLevel {
  low,
  medium,
  high,
  critical
}

/// Comprehensive error information container
class ErrorInfo {
  final Object error;
  final StackTrace? stackTrace;
  final Map<String, dynamic> context;
  final DateTime timestamp;
  final ErrorType type;
  final String? library;

  ErrorInfo({
    required this.error,
    this.stackTrace,
    required this.context,
    required this.timestamp,
    required this.type,
    this.library,
  });

  @override
  String toString() {
    return 'ErrorInfo(type: $type, error: $error, timestamp: $timestamp)';
  }
}

/// Error classification result with recovery guidance
class ErrorClassification {
  final ErrorSeverity severity;
  final String category;
  final bool canRecover;
  final bool shouldShowToUser;
  final Duration retryDelay;
  final double confidenceScore;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  ErrorClassification({
    required this.severity,
    required this.category,
    required this.canRecover,
    required this.shouldShowToUser,
    this.retryDelay = const Duration(seconds: 2),
    this.confidenceScore = 1.0,
    this.tags = const [],
    this.metadata = const {},
  });

  @override
  String toString() {
    return 'ErrorClassification(severity: $severity, category: $category, '
           'canRecover: $canRecover, confidence: $confidenceScore)';
  }
}

/// Intelligent error classifier with machine learning-like capabilities
class ErrorClassifier {
  static const Map<String, double> _categoryWeights = {
    'network': 0.8,
    'authentication': 0.9,
    'validation': 0.7,
    'memory': 0.95,
    'storage': 0.8,
    'timeout': 0.75,
    'permission': 0.85,
    'rate_limit': 0.7,
    'security': 0.95,
    'ui': 0.6,
    'data_corruption': 0.9,
    'general': 0.5,
  };

  /// Classify error with intelligent analysis
  static ErrorClassification classify(ErrorInfo errorInfo) {
    final errorString = errorInfo.error.toString().toLowerCase();
    final stackTrace = errorInfo.stackTrace?.toString().toLowerCase() ?? '';
    final context = errorInfo.context;
    
    // Multi-factor classification analysis
    final networkScore = _analyzeNetworkError(errorString, stackTrace, context);
    final authScore = _analyzeAuthenticationError(errorString, stackTrace, context);
    final validationScore = _analyzeValidationError(errorString, stackTrace, context);
    final memoryScore = _analyzeMemoryError(errorString, stackTrace, context);
    final storageScore = _analyzeStorageError(errorString, stackTrace, context);
    final timeoutScore = _analyzeTimeoutError(errorString, stackTrace, context);
    final permissionScore = _analyzePermissionError(errorString, stackTrace, context);
    final rateLimitScore = _analyzeRateLimitError(errorString, stackTrace, context);
    final securityScore = _analyzeSecurityError(errorString, stackTrace, context);
    final uiScore = _analyzeUIError(errorString, stackTrace, context);
    final dataCorruptionScore = _analyzeDataCorruptionError(errorString, stackTrace, context);

    // Calculate scores for each category
    final scores = {
      'network': networkScore,
      'authentication': authScore,
      'validation': validationScore,
      'memory': memoryScore,
      'storage': storageScore,
      'timeout': timeoutScore,
      'permission': permissionScore,
      'rate_limit': rateLimitScore,
      'security': securityScore,
      'ui': uiScore,
      'data_corruption': dataCorruptionScore,
    };

    // Find the category with highest confidence score
    final bestCategory = scores.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    // If no category has high confidence, default to general
    if (bestCategory.value < 0.3) {
      return _createGeneralClassification(errorInfo);
    }

    // Create classification based on best match
    return _createClassificationForCategory(
      bestCategory.key, 
      bestCategory.value, 
      errorInfo,
    );
  }

  /// Analyze network-related errors
  static double _analyzeNetworkError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for network keywords
    if (errorString.contains('socketexception')) score += 0.9;
    if (errorString.contains('httpsexception')) score += 0.8;
    if (errorString.contains('timeout')) score += 0.7;
    if (errorString.contains('connection')) score += 0.6;
    if (errorString.contains('host lookup failed')) score += 0.9;
    if (errorString.contains('network is unreachable')) score += 0.9;

    // Check stack trace for network-related calls
    if (stackTrace.contains('http')) score += 0.5;
    if (stackTrace.contains('dio')) score += 0.5;
    if (stackTrace.contains('socket')) score += 0.6;

    // Check context for network status
    if (context['networkStatus'] == 'disconnected') score += 0.8;
    if (context['isOnline'] == false) score += 0.8;

    return math.min(1.0, score);
  }

  /// Analyze authentication-related errors
  static double _analyzeAuthenticationError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for authentication keywords
    if (errorString.contains('authentication')) score += 0.9;
    if (errorString.contains('unauthorized')) score += 0.8;
    if (errorString.contains('token')) score += 0.7;
    if (errorString.contains('login')) score += 0.6;
    if (errorString.contains('credential')) score += 0.8;
    if (errorString.contains('session expired')) score += 0.9;
    if (errorString.contains('invalid token')) score += 0.9;

    // Check stack trace for auth-related calls
    if (stackTrace.contains('firebase_auth')) score += 0.8;
    if (stackTrace.contains('auth')) score += 0.5;

    // Check context for authentication state
    if (context['authStatus'] == 'unauthenticated') score += 0.7;
    if (context['tokenExpired'] == true) score += 0.9;

    return math.min(1.0, score);
  }

  /// Analyze validation-related errors
  static double _analyzeValidationError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for validation keywords
    if (errorString.contains('validation')) score += 0.9;
    if (errorString.contains('invalid')) score += 0.7;
    if (errorString.contains('format')) score += 0.6;
    if (errorString.contains('required')) score += 0.5;
    if (errorString.contains('length')) score += 0.5;
    if (errorString.contains('email')) score += 0.6;
    if (errorString.contains('password')) score += 0.6;

    // Check for form validation context
    if (context['formValidation'] == true) score += 0.8;
    if (context['inputError'] == true) score += 0.7;

    return math.min(1.0, score);
  }

  /// Analyze memory-related errors
  static double _analyzeMemoryError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for memory keywords
    if (errorString.contains('outofmemoryerror')) score += 1.0;
    if (errorString.contains('memory')) score += 0.8;
    if (errorString.contains('heap')) score += 0.7;
    if (errorString.contains('allocation')) score += 0.6;

    // Check context for memory pressure
    final memoryUsage = context['memoryUsage'] as int?;
    if (memoryUsage != null && memoryUsage > 200 * 1024 * 1024) { // > 200MB
      score += 0.8;
    }

    if (context['memoryPressure'] == 'high') score += 0.9;

    return math.min(1.0, score);
  }

  /// Analyze storage-related errors
  static double _analyzeStorageError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for storage keywords
    if (errorString.contains('storage')) score += 0.8;
    if (errorString.contains('disk')) score += 0.7;
    if (errorString.contains('space')) score += 0.6;
    if (errorString.contains('file')) score += 0.5;
    if (errorString.contains('directory')) score += 0.5;
    if (errorString.contains('permission denied')) score += 0.7;

    // Check context for storage status
    if (context['storageSpace'] == 'low') score += 0.8;
    if (context['diskFull'] == true) score += 0.9;

    return math.min(1.0, score);
  }

  /// Analyze timeout-related errors
  static double _analyzeTimeoutError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for timeout keywords
    if (errorString.contains('timeout')) score += 0.9;
    if (errorString.contains('time out')) score += 0.9;
    if (errorString.contains('deadline exceeded')) score += 0.8;
    if (errorString.contains('took too long')) score += 0.7;

    // Check for slow network conditions
    if (context['networkLatency'] != null) {
      final latency = context['networkLatency'] as double;
      if (latency > 5000) score += 0.7; // > 5 seconds
    }

    return math.min(1.0, score);
  }

  /// Analyze permission-related errors
  static double _analyzePermissionError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for permission keywords
    if (errorString.contains('permission')) score += 0.9;
    if (errorString.contains('access denied')) score += 0.8;
    if (errorString.contains('forbidden')) score += 0.8;
    if (errorString.contains('not allowed')) score += 0.7;

    // Check for permission context
    if (context['permissionDenied'] == true) score += 0.9;

    return math.min(1.0, score);
  }

  /// Analyze rate limiting errors
  static double _analyzeRateLimitError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for rate limit keywords
    if (errorString.contains('rate limit')) score += 0.9;
    if (errorString.contains('too many requests')) score += 0.9;
    if (errorString.contains('quota exceeded')) score += 0.8;
    if (errorString.contains('429')) score += 0.8;

    return math.min(1.0, score);
  }

  /// Analyze security-related errors
  static double _analyzeSecurityError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for security keywords
    if (errorString.contains('security')) score += 0.9;
    if (errorString.contains('encryption')) score += 0.8;
    if (errorString.contains('certificate')) score += 0.8;
    if (errorString.contains('ssl')) score += 0.7;
    if (errorString.contains('tls')) score += 0.7;

    return math.min(1.0, score);
  }

  /// Analyze UI-related errors
  static double _analyzeUIError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for UI keywords
    if (errorString.contains('renderbox')) score += 0.8;
    if (errorString.contains('widget')) score += 0.7;
    if (errorString.contains('build')) score += 0.6;
    if (errorString.contains('layout')) score += 0.6;

    // Check stack trace for Flutter framework calls
    if (stackTrace.contains('flutter/lib/src/widgets')) score += 0.7;
    if (stackTrace.contains('flutter/lib/src/rendering')) score += 0.8;

    return math.min(1.0, score);
  }

  /// Analyze data corruption errors
  static double _analyzeDataCorruptionError(
    String errorString, 
    String stackTrace, 
    Map<String, dynamic> context,
  ) {
    double score = 0.0;

    // Check for data corruption keywords
    if (errorString.contains('corrupt')) score += 0.9;
    if (errorString.contains('invalid data')) score += 0.8;
    if (errorString.contains('parse error')) score += 0.7;
    if (errorString.contains('malformed')) score += 0.7;

    return math.min(1.0, score);
  }

  /// Create classification for a specific category
  static ErrorClassification _createClassificationForCategory(
    String category,
    double confidence,
    ErrorInfo errorInfo,
  ) {
    switch (category) {
      case 'network':
        return ErrorClassification(
          severity: ErrorSeverity.medium,
          category: category,
          canRecover: true,
          shouldShowToUser: true,
          retryDelay: const Duration(seconds: 3),
          confidenceScore: confidence,
          tags: ['network', 'connectivity'],
          metadata: {
            'can_queue': true,
            'use_cache': true,
            'retry_count': 3,
          },
        );
        
      case 'authentication':
        return ErrorClassification(
          severity: ErrorSeverity.high,
          category: category,
          canRecover: true,
          shouldShowToUser: true,
          retryDelay: const Duration(seconds: 1),
          confidenceScore: confidence,
          tags: ['auth', 'security'],
          metadata: {
            'requires_reauth': true,
            'clear_tokens': true,
          },
        );
        
      case 'memory':
        return ErrorClassification(
          severity: ErrorSeverity.critical,
          category: category,
          canRecover: false,
          shouldShowToUser: true,
          retryDelay: const Duration(seconds: 5),
          confidenceScore: confidence,
          tags: ['memory', 'performance'],
          metadata: {
            'requires_restart': true,
            'clear_cache': true,
          },
        );
        
      case 'validation':
        return ErrorClassification(
          severity: ErrorSeverity.low,
          category: category,
          canRecover: true,
          shouldShowToUser: true,
          retryDelay: Duration.zero,
          confidenceScore: confidence,
          tags: ['validation', 'user_input'],
          metadata: {
            'show_hints': true,
            'highlight_field': true,
          },
        );
        
      default:
        return ErrorClassification(
          severity: ErrorSeverity.medium,
          category: category,
          canRecover: true,
          shouldShowToUser: true,
          retryDelay: const Duration(seconds: 2),
          confidenceScore: confidence,
          tags: [category],
        );
    }
  }

  /// Create general classification for unclassified errors
  static ErrorClassification _createGeneralClassification(ErrorInfo errorInfo) {
    return ErrorClassification(
      severity: ErrorSeverity.medium,
      category: 'general',
      canRecover: false,
      shouldShowToUser: true,
      retryDelay: const Duration(seconds: 2),
      confidenceScore: 0.5,
      tags: ['general', 'unknown'],
      metadata: {
        'needs_investigation': true,
      },
    );
  }
}
