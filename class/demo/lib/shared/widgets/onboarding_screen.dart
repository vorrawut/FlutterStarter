import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/storage_service.dart';

/// Onboarding Screen Widget
///
/// Demonstrates:
/// - Onboarding flow patterns (Lesson 6: Navigation)
/// - PageView and smooth transitions (Lesson 8: Animations)
/// - State persistence for first-time users
/// - Professional onboarding UX
/// - Hero animations and micro-interactions
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  int _currentPage = 0;

  // Onboarding pages data
  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Welcome to FlutterSocial Pro',
      description:
          'Connect with fellow learners, share knowledge, and grow together in your Flutter journey.',
      icon: Icons.waving_hand,
      color: Color(0xFF6366F1),
      lottieAsset: null, // Using icon instead
    ),
    const OnboardingPage(
      title: 'Join Study Groups',
      description:
          'Collaborate with peers, participate in discussions, and learn from experienced developers.',
      icon: Icons.groups,
      color: Color(0xFF8B5CF6),
      lottieAsset: null, // Using icon instead
    ),
    const OnboardingPage(
      title: 'Take Interactive Quizzes',
      description:
          'Test your knowledge, track your progress, and earn achievements as you master Flutter.',
      icon: Icons.quiz,
      color: Color(0xFF06B6D4),
      lottieAsset: null, // Using icon instead
    ),
    const OnboardingPage(
      title: 'Chat in Real-time',
      description:
          'Get instant help, share code snippets, and build lasting connections with the community.',
      icon: Icons.chat_bubble,
      color: Color(0xFF10B981),
      lottieAsset: null, // Using icon instead
    ),
    const OnboardingPage(
      title: 'Track Your Progress',
      description:
          'Monitor your learning journey, celebrate milestones, and unlock new achievement levels.',
      icon: Icons.trending_up,
      color: Color(0xFFF59E0B),
      lottieAsset: null, // Using icon instead
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fadeController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _slideController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      await StorageService.setOnboardingComplete();
      ref.read(onboardingStateProvider.notifier).state = true;

      if (mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete onboarding: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicator
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => _buildPageIndicator(index, theme),
                    ),
                  ),

                  // Skip Button
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });

                  // Trigger animations
                  _slideController.reset();
                  _slideController.forward();
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index], size);
                },
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  if (_currentPage > 0)
                    OutlinedButton(
                      onPressed: _previousPage,
                      child: const Text('Previous'),
                    )
                  else
                    const SizedBox(width: 80),

                  // Next/Get Started Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index, ThemeData theme) {
    final isActive = index == _currentPage;

    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      margin: const EdgeInsets.only(right: 8),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            isActive ? _pages[_currentPage].color : theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page, Size size) {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOut,
        )),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              SizedBox(
                height: size.height * 0.35,
                child: _buildIllustration(page),
              ),

              const SizedBox(height: AppConstants.largeSpacing * 2),

              // Title
              Text(
                page.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: page.color,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.spacing),

              // Description
              Text(
                page.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(OnboardingPage page) {
    return Hero(
      tag: 'onboarding_${page.title}',
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              page.color.withValues(alpha: 0.1),
              page.color.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: _buildAnimatedIllustration(page),
      ),
    );
  }

  Widget _buildAnimatedIllustration(OnboardingPage page) {
    // Use animated icon since Lottie assets are not available in demo
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: page.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),
        );
      },
    );
  }
}

/// Onboarding Page Data Model
///
/// Demonstrates:
/// - Data modeling for UI components
/// - Immutable data structures
/// - Type-safe configuration
@immutable
class OnboardingPage {
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.lottieAsset,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? lottieAsset;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingPage &&
        other.title == title &&
        other.description == description &&
        other.icon == icon &&
        other.color == color &&
        other.lottieAsset == lottieAsset;
  }

  @override
  int get hashCode {
    return Object.hash(title, description, icon, color, lottieAsset);
  }

  @override
  String toString() {
    return 'OnboardingPage(title: $title, description: $description, icon: $icon, color: $color, lottieAsset: $lottieAsset)';
  }
}
