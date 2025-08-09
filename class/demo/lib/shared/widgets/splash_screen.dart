import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/storage_service.dart';

/// Splash Screen Widget
///
/// Demonstrates:
/// - App initialization patterns (Lesson 2: Development Environment)
/// - Loading states and animations (Lesson 8: Animations)
/// - Async initialization handling
/// - Professional splash screen implementation
/// - Smooth transition animations
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Fade animation for smooth appearance
    _fadeController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Scale animation for logo
    _scaleController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Show splash for minimum duration for better UX
      await Future.delayed(const Duration(seconds: 2));

      // Check onboarding status
      final hasCompletedOnboarding = StorageService.isOnboardingComplete();

      // Check authentication status
      final authToken = StorageService.getAuthToken();
      final isAuthenticated = authToken != null;

      // Update providers
      ref.read(onboardingStateProvider.notifier).state = hasCompletedOnboarding;
      ref.read(authStateProvider.notifier).state = isAuthenticated;

      if (!mounted) return;

      // Navigate based on app state
      if (!hasCompletedOnboarding) {
        context.go(AppRoutes.onboarding);
      } else if (!isAuthenticated) {
        context.go(AppRoutes.login);
      } else {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text('Failed to initialize app: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo with Scale Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    size: 60,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.largeSpacing),

              // App Name
              Text(
                AppConstants.appName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.smallSpacing),

              // App Description
              Text(
                AppConstants.appDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largeSpacing * 2),

              // Loading Animation
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacing),

              // Loading Text
              Text(
                'Initializing...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alternative Splash Screen with Lottie Animation
///
/// Demonstrates:
/// - Lottie animation integration
/// - Rich animation loading states
/// - Custom animation controllers
class LottieSplashScreen extends ConsumerStatefulWidget {
  const LottieSplashScreen({super.key});

  @override
  ConsumerState<LottieSplashScreen> createState() => _LottieSplashScreenState();
}

class _LottieSplashScreenState extends ConsumerState<LottieSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _lottieController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for animation to complete
    await _lottieController.forward();

    // Add additional initialization logic here
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigate to next screen
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/animations/splash_animation.json',
                controller: _lottieController,
                frameRate: FrameRate.max,
                repeat: false,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to regular splash if Lottie fails
                  return const Icon(
                    Icons.school_rounded,
                    size: 80,
                  );
                },
              ),
            ),

            const SizedBox(height: AppConstants.largeSpacing),

            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
