/// Welcome screen shown after onboarding completion
/// 
/// This file provides a celebration screen that appears after
/// users complete the onboarding flow with success animations.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/animations/custom_curves.dart';
import '../../core/constants/animation_constants.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/animation_coordinator.dart';
import '../widgets/hero_button.dart';

/// Welcome screen with celebration animations
/// 
/// Displays a congratulatory message with delightful animations
/// to celebrate the completion of the onboarding experience.
class WelcomeScreen extends StatefulWidget {
  /// Creates a welcome screen
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {

  late AnimationController _celebrationController;
  late AnimationController _contentController;
  late AnimationController _particleController;

  late Animation<double> _celebrationScaleAnimation;
  late Animation<double> _celebrationRotationAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCelebrationSequence();
  }

  void _initializeAnimations() {
    // Celebration icon animation
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _celebrationScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: const Interval(0.0, 0.6, curve: AnimationCurves.dramaticElastic),
    ));

    _celebrationRotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Content animation
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.2, 1.0, curve: AnimationCurves.gentleSpring),
    ));

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);
  }

  void _startCelebrationSequence() {
    // Start celebration icon
    _celebrationController.forward();

    // Start content after delay
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _contentController.forward();
      }
    });

    // Start particles
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _particleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _contentController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating particles background
              _buildParticleBackground(),
              
              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Celebration icon
                      _buildCelebrationIcon(),
                      
                      const SizedBox(height: 48),
                      
                      // Success message
                      _buildSuccessMessage(),
                      
                      const SizedBox(height: 32),
                      
                      // Description
                      _buildDescription(),
                      
                      const SizedBox(height: 64),
                      
                      // Action buttons
                      _buildActionButtons(),
                      
                      const SizedBox(height: 32),
                      
                      // Additional options
                      _buildAdditionalOptions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build floating particle background
  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(20, (index) {
            final progress = (_particleAnimation.value + index * 0.1) % 1.0;
            final size = 4.0 + (index % 3) * 2.0;
            final opacity = (1.0 - progress) * 0.6;
            
            return Positioned(
              left: (index * 50.0) % MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height * progress,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Build celebration icon
  Widget _buildCelebrationIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _celebrationScaleAnimation,
        _celebrationRotationAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _celebrationScaleAnimation.value,
          child: Transform.rotate(
            angle: _celebrationRotationAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.celebration,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build success message
  Widget _buildSuccessMessage() {
    return AnimatedBuilder(
      animation: Listenable.merge([_contentFadeAnimation, _contentSlideAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: _contentSlideAnimation,
          child: FadeTransition(
            opacity: _contentFadeAnimation,
            child: Column(
              children: [
                Text(
                  'Congratulations! 🎉',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Animation Master Unlocked!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
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

  /// Build description
  Widget _buildDescription() {
    return AnimatedBuilder(
      animation: _contentFadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _contentFadeAnimation,
          child: Text(
            'You\'ve successfully completed the Flutter Animations masterclass! You\'re now ready to create stunning, delightful animations that will captivate your users and elevate your apps to the next level.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return AnimatedBuilder(
      animation: _contentFadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _contentFadeAnimation,
          child: Column(
            children: [
              // Primary action button
              HeroButton(
                heroTag: 'welcome_continue',
                onPressed: () {
                  // In a real app, navigate to main app
                  _showCompletionDialog();
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.rocket_launch, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Start Creating',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Secondary action button
              OutlinedButton.icon(
                onPressed: () {
                  final controller = context.read<OnboardingController>();
                  controller.resetOnboarding();
                },
                icon: const Icon(Icons.replay, size: 20),
                label: const Text(
                  'Experience Again',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build additional options
  Widget _buildAdditionalOptions() {
    return AnimatedBuilder(
      animation: _contentFadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _contentFadeAnimation,
          child: Column(
            children: [
              Text(
                'Explore More:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.analytics,
                    label: 'View Metrics',
                    onTap: _showPerformanceMetrics,
                  ),
                  _buildOptionButton(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: _showSettings,
                  ),
                  _buildOptionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: _shareExperience,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build option button
  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎊 Amazing Work!'),
        content: const Text(
          'You\'ve mastered Flutter animations! In a real app, you would now navigate to the main application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  /// Show performance metrics
  void _showPerformanceMetrics() {
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
            Text('Sequences Played: ${summary.totalSequences}'),
            Text('Average Duration: ${summary.averageDuration.inMilliseconds}ms'),
            Text('Total Elements: ${summary.totalElements}'),
            if (summary.totalSequences > 0) ...[
              const SizedBox(height: 16),
              Text('Longest Sequence: ${summary.longestSequence.sequenceName}'),
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

  /// Show settings
  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text(
          'In a real app, this would open the settings screen where users can customize their animation preferences.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  /// Share experience
  void _shareExperience() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Your Achievement'),
        content: const Text(
          'Amazing! You\'ve completed the Flutter Animations masterclass. In a real app, this would open sharing options to celebrate your achievement with friends.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Share Now'),
          ),
        ],
      ),
    );
  }
}