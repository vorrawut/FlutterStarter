/// Main application entry point for Lesson 10: setState & Stateful Widgets
/// 
/// This file demonstrates the complete integration of StatefulWidget patterns,
/// lifecycle management, performance monitoring, and clean architecture.
library;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/utils/lifecycle_logger.dart';
import 'core/utils/performance_monitor.dart';
import 'presentation/screens/task_list_screen.dart';

/// Main application entry point
void main() {
  // Initialize performance monitoring
  if (kDebugMode) {
    performanceMonitor.initialize();
    lifecycleLogger.clearAllValidation(); // Clear any previous logs
  }

  // Run the app with error handling
  runApp(const TaskManagerApp());
}

/// Main application widget demonstrating StatefulWidget patterns
/// 
/// Shows proper application-level state management, theming,
/// and lifecycle handling for a production-ready Flutter app.
class TaskManagerApp extends StatefulWidget {
  /// Creates the main application widget
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp>
    with WidgetsBindingObserver {

  /// Application lifecycle state
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  /// Error tracking
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    
    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize app components
    _initializeApp();
    
    if (kDebugMode) {
      lifecycleLogger.logInitState(
        'TaskManagerApp',
        details: 'Main app initialized with debugging enabled',
      );
    }
  }

  @override
  void dispose() {
    // Clean up resources
    WidgetsBinding.instance.removeObserver(this);
    
    if (kDebugMode) {
      // Stop performance monitoring
      performanceMonitor.dispose();
      
      // Log final statistics
      final stats = performanceMonitor.getPerformanceSummary();
      debugPrint('📊 Final Performance Summary: $stats');
      
      lifecycleLogger.logDispose(
        'TaskManagerApp',
        details: 'Main app disposed, performance monitoring stopped',
      );
    }
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    setState(() {
      _lifecycleState = state;
    });

    if (kDebugMode) {
      lifecycleLogger.logEvent(
        LifecycleEvent.didChangeDependencies,
        'TaskManagerApp',
        details: 'App lifecycle changed to: ${state.name}',
      );
    }

    // Handle lifecycle state changes
    switch (state) {
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      case AppLifecycleState.inactive:
        _handleAppInactive();
        break;
      case AppLifecycleState.hidden:
        _handleAppHidden();
        break;
    }
  }

  /// Initialize application components
  Future<void> _initializeApp() async {
    try {
      // In a real app, this might include:
      // - Database initialization
      // - Network connectivity checks
      // - User authentication
      // - Feature flag loading
      // - Crash reporting setup
      
      // Simulate initialization delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (kDebugMode) {
        debugPrint('✅ App initialization completed successfully');
      }
      
    } catch (error) {
      setState(() {
        _initializationError = error.toString();
      });
      
      if (kDebugMode) {
        debugPrint('❌ App initialization failed: $error');
      }
    }
  }

  /// Handle app paused state
  void _handleAppPaused() {
    if (kDebugMode) {
      debugPrint('⏸️ App paused - saving state if needed');
    }
    // Auto-save any pending changes
    // Pause expensive operations
    // Reduce background processing
  }

  /// Handle app resumed state
  void _handleAppResumed() {
    if (kDebugMode) {
      debugPrint('▶️ App resumed - refreshing data if needed');
    }
    // Refresh data if needed
    // Resume background operations
    // Check for updates
  }

  /// Handle app detached state
  void _handleAppDetached() {
    if (kDebugMode) {
      debugPrint('🔌 App detached - performing final cleanup');
    }
    // Perform final cleanup
    // Save critical data
  }

  /// Handle app inactive state
  void _handleAppInactive() {
    if (kDebugMode) {
      debugPrint('😴 App inactive - reducing activity');
    }
    // Reduce unnecessary processing
  }

  /// Handle app hidden state
  void _handleAppHidden() {
    if (kDebugMode) {
      debugPrint('🫥 App hidden - pausing non-essential operations');
    }
    // Pause non-essential operations
  }

  @override
  Widget build(BuildContext context) {
    // Handle initialization error
    if (_initializationError != null) {
      return MaterialApp(
        title: 'Task Manager - Error',
        home: _buildErrorScreen(),
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      title: 'Task Manager - setState & StatefulWidget Demo',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      
      // Home screen
      home: const TaskListScreen(),
      
      // Error handling
      builder: (context, child) {
        return _buildAppWithErrorHandling(context, child);
      },
    );
  }

  /// Build light theme
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),
    );
  }

  /// Build dark theme
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),
    );
  }

  /// Build app with global error handling
  Widget _buildAppWithErrorHandling(BuildContext context, Widget? child) {
    return Builder(
      builder: (context) {
        // Add global error boundary
        ErrorWidget.builder = (FlutterErrorDetails details) {
          if (kDebugMode) {
            // In debug mode, show detailed error
            return _buildDebugErrorWidget(details);
          } else {
            // In release mode, show user-friendly error
            return _buildReleaseErrorWidget();
          }
        };

        return child ?? const SizedBox.shrink();
      },
    );
  }

  /// Build initialization error screen
  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialization Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Failed to Initialize App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _initializationError ?? 'Unknown error occurred',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _initializationError = null;
                  });
                  _initializeApp();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build debug error widget
  Widget _buildDebugErrorWidget(FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Error'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Error Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              details.exception.toString(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Stack Trace:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              details.stack.toString(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build release error widget
  Widget _buildReleaseErrorWidget() {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Please restart the app and try again.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}