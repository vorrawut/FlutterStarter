import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'core/dependency_injection.dart';
import 'core/constants/app_constants.dart';
import 'firebase_options.dart';
import 'presentation/core/app.dart';

/// ConnectPro Ultimate - Complete Social Platform
/// 
/// This is the main entry point for ConnectPro Ultimate, a comprehensive
/// social platform that integrates all Phase 5 Firebase & Cloud concepts
/// with production-ready clean architecture.
/// 
/// Features:
/// - Multi-provider authentication (Email, Google, Apple, Phone)
/// - Real-time chat with end-to-end encryption
/// - Intelligent social feed with ML-powered algorithms
/// - Advanced push notifications with FCM
/// - Serverless backend with Cloud Functions
/// - Enterprise-grade security and compliance
/// - Production monitoring and analytics
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger for development
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  try {
    // Load environment variables
    await dotenv.load(fileName: '.env');
    logger.i('Environment variables loaded successfully');

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('Firebase initialized successfully');

    // Initialize Firebase App Check for security
    await FirebaseAppCheck.instance.activate(
      // Use debug provider for development
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
    logger.i('Firebase App Check activated');

    // Initialize Firebase Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      logger.e('Flutter Fatal Error', errorDetails.exception, errorDetails.stack);
    };

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      logger.e('Uncaught Async Error', error, stack);
      return true;
    };

    // Initialize Firebase Performance Monitoring
    final performance = FirebasePerformance.instance;
    await performance.setPerformanceCollectionEnabled(true);
    logger.i('Firebase Performance Monitoring enabled');

    // Initialize dependency injection
    await configureDependencies();
    logger.i('Dependency injection configured successfully');

    // Start performance trace for app startup
    final startupTrace = performance.newTrace('app_startup');
    await startupTrace.start();

    // Run the app with Riverpod provider scope
    runApp(
      ProviderScope(
        child: ConnectProUltimateApp(),
      ),
    );

    // Stop startup trace
    await startupTrace.stop();
    logger.i('App launched successfully');

  } catch (error, stackTrace) {
    logger.e('App initialization failed', error, stackTrace);
    
    // Record error to Crashlytics if initialized
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        fatal: true,
      );
    } catch (_) {
      // Crashlytics not initialized, ignore
    }

    // Show error screen
    runApp(
      MaterialApp(
        home: AppInitializationErrorScreen(
          error: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      ),
    );
  }
}

/// Error screen displayed when app initialization fails
class AppInitializationErrorScreen extends StatelessWidget {
  final String error;
  final String stackTrace;

  const AppInitializationErrorScreen({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade600,
              ),
              const SizedBox(height: 24),
              Text(
                'App Initialization Failed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'ConnectPro Ultimate failed to initialize properly. '
                'Please check your configuration and try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ExpansionTile(
                title: Text(
                  'Error Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade800,
                  ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Stack Trace:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stackTrace,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Restart the app
                  SystemNavigator.pop();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Restart App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom error widget for better error handling in production
class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorWidget({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade600,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again or contact support',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade600,
              ),
            ),
            if (AppConstants.isDebugMode) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  errorDetails.exception.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Override the default error widget in debug mode
class DebugErrorWidgetBuilder {
  static Widget build(FlutterErrorDetails errorDetails) {
    return CustomErrorWidget(errorDetails: errorDetails);
  }
}

/// Performance monitoring helpers
class AppPerformanceMonitor {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  static final Logger _logger = Logger();

  /// Track custom performance metrics
  static Future<T> trackOperation<T>({
    required String operationName,
    required Future<T> Function() operation,
    Map<String, String>? attributes,
  }) async {
    final trace = _performance.newTrace(operationName);
    
    // Add custom attributes
    if (attributes != null) {
      for (final entry in attributes.entries) {
        trace.putAttribute(entry.key, entry.value);
      }
    }

    await trace.start();
    _logger.d('Started performance trace: $operationName');

    try {
      final result = await operation();
      trace.setMetric('success', 1);
      _logger.d('Performance trace completed successfully: $operationName');
      return result;
    } catch (error) {
      trace.setMetric('error', 1);
      trace.putAttribute('error_message', error.toString());
      _logger.e('Performance trace failed: $operationName', error);
      rethrow;
    } finally {
      await trace.stop();
    }
  }

  /// Track user journey performance
  static Future<void> trackUserJourney(String journeyName) async {
    final trace = _performance.newTrace('user_journey_$journeyName');
    await trace.start();
    // Trace will be stopped by the caller
  }

  /// Track network request performance
  static Future<void> trackNetworkRequest({
    required String url,
    required String method,
    int? statusCode,
    int? requestSize,
    int? responseSize,
  }) async {
    final trace = _performance.newHttpTrace(url, HttpMethod.Get);
    trace.requestPayloadSize = requestSize;
    trace.responsePayloadSize = responseSize;
    trace.httpResponseCode = statusCode;
    // Network traces are automatically handled by Firebase
  }
}

/// App lifecycle state management
class AppLifecycleManager extends WidgetsBindingObserver {
  static final Logger _logger = Logger();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        _logger.i('App resumed');
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        _logger.i('App paused');
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
        _logger.i('App detached');
        _handleAppDetached();
        break;
      case AppLifecycleState.inactive:
        _logger.i('App inactive');
        break;
      case AppLifecycleState.hidden:
        _logger.i('App hidden');
        break;
    }
  }

  void _handleAppResumed() {
    // Track app resume in analytics
    // Refresh critical data if needed
    // Re-establish real-time connections
  }

  void _handleAppPaused() {
    // Save critical app state
    // Pause non-essential background tasks
    // Clean up resources
  }

  void _handleAppDetached() {
    // Perform final cleanup
    // Save any unsaved data
    // Close database connections
  }
}