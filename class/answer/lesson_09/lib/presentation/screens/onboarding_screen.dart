/// Main onboarding screen with coordinated animations
/// 
/// This file provides the main onboarding experience with sophisticated
/// animation coordination, adaptive layouts, and delightful interactions.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/animations/animation_mixins.dart';
import '../../core/animations/animation_controller_manager.dart';
import '../../domain/entities/onboarding_page.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/animation_coordinator.dart';
import '../widgets/animated_page_view.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/hero_button.dart';
import '../widgets/staggered_list.dart';
import 'onboarding_page_content.dart';

/// Main onboarding screen with animation coordination
/// 
/// Orchestrates the complete onboarding experience with smooth page
/// transitions, coordinated animations, and responsive interactions.
class OnboardingScreen extends StatefulWidget {
  /// Creates an onboarding screen
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin, AnimationControllerManagerMixin {

  @override
  void initState() {
    super.initState();
    
    // Provide animation manager to coordinator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final coordinator = context.read<AnimationCoordinator>();
      coordinator.setControllerManager(animationManager);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        // Show loading state
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show error state
        if (controller.hasError) {
          return _buildErrorScreen(controller.errorMessage!);
        }

        // Show onboarding content
        if (controller.flowConfig != null) {
          return _buildOnboardingContent(controller);
        }

        return const Scaffold(
          body: Center(
            child: Text('No onboarding configuration available'),
          ),
        );
      },
    );
  }

  /// Build onboarding content
  Widget _buildOnboardingContent(OnboardingController controller) {
    final flowConfig = controller.flowConfig!;
    
    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(controller.currentPage),
        child: SafeArea(
          child: Column(
            children: [
              // Top navigation bar
              _buildTopNavigationBar(controller, flowConfig),
              
              // Progress indicator
              if (flowConfig.showProgress)
                _buildProgressSection(controller),
              
              // Main content area
              Expanded(
                child: _buildMainContent(controller, flowConfig),
              ),
              
              // Bottom navigation
              _buildBottomNavigation(controller, flowConfig),
            ],
          ),
        ),
      ),
    );
  }

  /// Build background decoration based on current page
  BoxDecoration _buildBackgroundDecoration(OnboardingPage? currentPage) {
    if (currentPage?.backgroundGradient != null) {
      return BoxDecoration(
        gradient: currentPage!.backgroundGradient,
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          currentPage?.primaryColor.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
          currentPage?.secondaryColor.withOpacity(0.1) ?? Colors.purple.withOpacity(0.1),
        ],
      ),
    );
  }

  /// Build top navigation bar
  Widget _buildTopNavigationBar(OnboardingController controller, OnboardingFlowConfig flowConfig) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (only show if not first page)
          if (!controller.isFirstPage)
            IconButton(
              onPressed: controller.isAnimating ? null : controller.previousPage,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Previous',
            )
          else
            const SizedBox(width: 48),

          // Skip button (only show if skipping is allowed)
          if (flowConfig.allowSkip && !controller.isLastPage)
            TextButton(
              onPressed: controller.isAnimating ? null : controller.skipOnboarding,
              child: Text(
                controller.currentPage?.skipText ?? 'Skip',
                style: TextStyle(
                  color: controller.currentPage?.primaryColor ?? Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  /// Build progress section
  Widget _buildProgressSection(OnboardingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        children: [
          // Linear progress indicator
          AnimatedProgressIndicator(
            progress: controller.progress,
            progressColor: controller.currentPage?.primaryColor,
            animationDuration: const Duration(milliseconds: 500),
            enableGlow: true,
            height: 6.0,
          ),
          
          const SizedBox(height: 12),
          
          // Step indicators
          if (controller.totalPages <= 5)
            StepProgressIndicator(
              totalSteps: controller.totalPages,
              currentStep: controller.currentPageIndex,
              activeColor: controller.currentPage?.primaryColor,
              stepSize: 12.0,
              spacing: 6.0,
            ),
        ],
      ),
    );
  }

  /// Build main content area
  Widget _buildMainContent(OnboardingController controller, OnboardingFlowConfig flowConfig) {
    return AnimatedPageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      enableParallax: true,
      parallaxStrength: 0.3,
      children: flowConfig.pages.map((page) {
        return OnboardingPageContent(
          page: page,
          isActive: page == controller.currentPage,
          animationComplete: controller.currentPageAnimationComplete,
        );
      }).toList(),
    );
  }

  /// Build bottom navigation
  Widget _buildBottomNavigation(OnboardingController controller, OnboardingFlowConfig flowConfig) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          // Page indicator dots (for small number of pages)
          if (controller.totalPages <= 8)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedPageIndicator(
                    pageCount: controller.totalPages,
                    currentPage: controller.currentPageIndex.toDouble(),
                    activeColor: controller.currentPage?.primaryColor,
                    size: 8.0,
                    spacing: 12.0,
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Text(
                '${controller.currentPageIndex + 1} of ${controller.totalPages}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(width: 24),

          // Next/Complete button
          HeroButton(
            heroTag: 'onboarding_next_button',
            onPressed: controller.isAnimating ? null : () {
              if (controller.isLastPage) {
                controller.completeOnboarding();
              } else {
                controller.nextPage();
              }
            },
            backgroundColor: controller.currentPage?.primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: controller.isLastPage ? 32 : 24,
              vertical: 16,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.isLastPage
                      ? (controller.currentPage?.ctaText ?? 'Get Started')
                      : (controller.currentPage?.nextText ?? 'Next'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!controller.isLastPage) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build error screen
  Widget _buildErrorScreen(String errorMessage) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              HeroButton(
                onPressed: () {
                  final controller = context.read<OnboardingController>();
                  controller.clearError();
                  controller.initialize();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('Try Again'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}