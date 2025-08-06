/// Splash screen with loading animations
/// 
/// This file provides an animated splash screen that displays
/// during app initialization with elegant loading animations.
library;

import 'package:flutter/material.dart';
import '../../core/animations/custom_curves.dart';
import '../../core/constants/animation_constants.dart';
import '../../core/theme/animation_theme.dart';

/// Animated splash screen for app initialization
/// 
/// Displays a beautiful loading animation while the app
/// initializes and prepares the onboarding experience.
class SplashScreen extends StatefulWidget {
  /// Creates a splash screen
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoRotationAnimation;
  
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  
  late Animation<double> _loadingAnimation;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: AnimationCurves.dramaticElastic),
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.2, 1.0, curve: AnimationCurves.gentleSpring),
    ));

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: const Color(0xFF1A1A1A),
      end: const Color(0xFF6366F1),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    // Start logo animation immediately
    _logoController.forward();

    // Start text animation after logo
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textController.forward();
      }
    });

    // Start loading animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadingController.repeat();
      }
    });

    // Start background animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _backgroundController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundAnimation.value ?? theme.colorScheme.primary,
                  (_backgroundAnimation.value ?? theme.colorScheme.primary)
                      .withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section
                    _buildLogo(),
                    
                    const SizedBox(height: 48),
                    
                    // App title and subtitle
                    _buildTitle(),
                    
                    const SizedBox(height: 80),
                    
                    // Loading indicator
                    _buildLoadingIndicator(),
                    
                    const SizedBox(height: 24),
                    
                    // Loading text
                    _buildLoadingText(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build animated logo
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoScaleAnimation,
        _logoOpacityAnimation,
        _logoRotationAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotationAnimation.value,
            child: Opacity(
              opacity: _logoOpacityAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.animation,
                  size: 60,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build animated title section
  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: Listenable.merge([_textFadeAnimation, _textSlideAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Column(
              children: [
                Text(
                  'FlutterMaster',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Master Flutter Animations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 4,
          child: LinearProgressIndicator(
            value: null, // Indeterminate progress
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withOpacity(0.8),
            ),
          ),
        );
      },
    );
  }

  /// Build loading text
  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        final loadingTexts = [
          'Preparing animations...',
          'Loading beautiful transitions...',
          'Setting up delightful experiences...',
          'Almost ready...',
        ];
        
        final textIndex = (_loadingAnimation.value * loadingTexts.length).floor() % loadingTexts.length;
        
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            loadingTexts[textIndex],
            key: ValueKey(textIndex),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

/// Minimal splash screen for quick loading
/// 
/// A simpler version for faster initialization when needed.
class MinimalSplashScreen extends StatelessWidget {
  /// Creates a minimal splash screen
  const MinimalSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}