/// Flutter Animations - Lesson 9 Implementation
/// 
/// This application demonstrates comprehensive Flutter animation patterns
/// through an interactive onboarding experience featuring coordinated
/// animation sequences, physics-based motion, and delightful micro-interactions.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/animations/animation_controller_manager.dart';
import 'core/theme/animation_theme.dart';
import 'presentation/controllers/onboarding_controller.dart';
import 'presentation/controllers/animation_coordinator.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations for optimal animation experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const FlutterAnimationsApp());
}

/// Main application widget showcasing Flutter animations
/// 
/// Demonstrates comprehensive animation patterns including entrance animations,
/// staggered sequences, physics-based motion, and coordinated transitions
/// in a professional onboarding experience.
class FlutterAnimationsApp extends StatelessWidget {
  const FlutterAnimationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations - Lesson 9',
      debugShowCheckedModeBanner: false,
      theme: AnimationTheme.lightTheme,
      darkTheme: AnimationTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AnimationApp(),
    );
  }
}

/// Main animation application with state management
/// 
/// Provides the core application structure with proper state management
/// and animation coordination for the onboarding experience.
class AnimationApp extends StatefulWidget {
  const AnimationApp({super.key});

  @override
  State<AnimationApp> createState() => _AnimationAppState();
}

class _AnimationAppState extends State<AnimationApp> 
    with TickerProviderStateMixin {
  
  late final AnimationControllerManager _animationManager;
  late final AnimationCoordinator _animationCoordinator;
  late final OnboardingController _onboardingController;

  bool _isInitialized = false;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize the application with proper dependencies
  Future<void> _initializeApp() async {
    try {
      // Initialize animation manager
      _animationManager = AnimationControllerManager(vsync: this);

      // Initialize animation coordinator
      _animationCoordinator = AnimationCoordinator();
      _animationCoordinator.setControllerManager(_animationManager);

      // Initialize onboarding controller
      _onboardingController = OnboardingController(
        animationCoordinator: _animationCoordinator,
      );

      // Initialize onboarding data
      await _onboardingController.initialize();

      setState(() {
        _isInitialized = true;
      });

    } catch (error) {
      setState(() {
        _initializationError = error.toString();
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while initializing
    if (!_isInitialized) {
      return const SplashScreen();
    }

    // Show error if initialization failed
    if (_initializationError != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Initialization Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _initializationError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isInitialized = false;
                    _initializationError = null;
                  });
                  _initializeApp();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Main application with providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _onboardingController),
        ChangeNotifierProvider.value(value: _animationCoordinator),
        Provider.value(value: _animationManager),
      ],
      child: Consumer<OnboardingController>(
        builder: (context, controller, child) {
          // Navigate based on onboarding state
          if (controller.isCompleted || controller.isSkipped) {
            return const WelcomeScreen();
          } else {
            return const OnboardingScreen();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationManager.dispose();
    _animationCoordinator.dispose();
    _onboardingController.dispose();
    super.dispose();
  }
}

/// Demo welcome screen shown after onboarding completion
/// 
/// Simple placeholder screen to demonstrate the completion of the
/// onboarding flow with smooth transition animations.
class DemoWelcomeScreen extends StatelessWidget {
  const DemoWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon with animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Welcome message
                Text(
                  'Welcome to the App!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  'You\'ve successfully completed the animated onboarding experience.\nTime to explore the amazing world of Flutter animations!',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Reset onboarding to experience it again
                        final controller = context.read<OnboardingController>();
                        controller.resetOnboarding();
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Experience Again'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Show performance metrics
                        _showPerformanceDialog(context);
                      },
                      icon: const Icon(Icons.analytics),
                      label: const Text('View Metrics'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show animation performance metrics dialog
  void _showPerformanceDialog(BuildContext context) {
    final coordinator = context.read<AnimationCoordinator>();
    final summary = coordinator.getPerformanceSummary();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Animation Performance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Sequences: ${summary.totalSequences}'),
            Text('Average Duration: ${summary.averageDuration.inMilliseconds}ms'),
            Text('Total Elements: ${summary.totalElements}'),
            if (summary.totalSequences > 0) ...[
              const SizedBox(height: 16),
              Text('Longest: ${summary.longestSequence.sequenceName}'),
              Text('Duration: ${summary.longestSequence.duration.inMilliseconds}ms'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              coordinator.clearPerformanceMetrics();
              Navigator.of(context).pop();
            },
            child: const Text('Clear Metrics'),
          ),
        ],
      ),
    );
  }
}