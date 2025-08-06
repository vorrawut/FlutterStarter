/// Onboarding page content with entrance animations
/// 
/// This file provides the content display for individual onboarding pages
/// with sophisticated entrance animations and responsive layouts.
library;

import 'package:flutter/material.dart';
import '../../core/animations/animation_mixins.dart';
import '../../core/animations/animation_controller_manager.dart';
import '../../core/constants/animation_constants.dart';
import '../../domain/entities/onboarding_page.dart';
import '../widgets/staggered_list.dart';

/// Content widget for individual onboarding pages
/// 
/// Displays page content with coordinated entrance animations
/// based on the page's animation configuration.
class OnboardingPageContent extends StatefulWidget {
  /// Creates onboarding page content
  const OnboardingPageContent({
    super.key,
    required this.page,
    required this.isActive,
    required this.animationComplete,
  });

  /// The onboarding page to display
  final OnboardingPage page;

  /// Whether this page is currently active
  final bool isActive;

  /// Whether entrance animation is complete
  final bool animationComplete;

  @override
  State<OnboardingPageContent> createState() => _OnboardingPageContentState();
}

class _OnboardingPageContentState extends State<OnboardingPageContent>
    with TickerProviderStateMixin, EntranceAnimationMixin, AnimationControllerManagerMixin {

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _initializePageAnimations();
  }

  void _initializePageAnimations() {
    // Initialize entrance animations based on page configuration
    initializeEntranceAnimations(
      duration: widget.page.animationConfig.pageTransitionDuration,
      curve: widget.page.animationConfig.customCurve ?? 
             widget.page.animationConfig.elementAnimations.first.curve,
      slideDirection: Axis.vertical,
    );
  }

  @override
  void didUpdateWidget(OnboardingPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Start animations when page becomes active
    if (widget.isActive && !oldWidget.isActive && !_hasAnimated) {
      _startEntranceAnimations();
      _hasAnimated = true;
    }
    
    // Reset when page becomes inactive
    if (!widget.isActive && oldWidget.isActive) {
      _hasAnimated = false;
    }
  }

  void _startEntranceAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && widget.isActive) {
        startEntranceAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return buildEntranceAnimatedWidget(
      enableFade: true,
      enableSlide: true,
      enableScale: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 48.0 : 24.0,
          vertical: 32.0,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenSize.height - 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main illustration/image
              _buildImageSection(),
              
              SizedBox(height: isLargeScreen ? 48 : 32),
              
              // Title section
              _buildTitleSection(),
              
              SizedBox(height: isLargeScreen ? 32 : 24),
              
              // Description section
              _buildDescriptionSection(),
              
              // Features section (if any)
              if (widget.page.features.isNotEmpty) ...[
                SizedBox(height: isLargeScreen ? 48 : 32),
                _buildFeaturesSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build image section
  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.page.primaryColor.withOpacity(0.1),
            widget.page.secondaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: _buildPlaceholderImage(),
      ),
    );
  }

  /// Build placeholder image (in a real app, this would load actual images)
  Widget _buildPlaceholderImage() {
    IconData iconData;
    
    // Choose icon based on page ID
    switch (widget.page.id) {
      case 'welcome':
        iconData = Icons.waving_hand;
        break;
      case 'features':
        iconData = Icons.auto_awesome;
        break;
      case 'benefits':
        iconData = Icons.star;
        break;
      case 'get_started':
        iconData = Icons.rocket_launch;
        break;
      default:
        iconData = Icons.animation;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: widget.page.primaryColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 60,
        color: widget.page.primaryColor,
      ),
    );
  }

  /// Build title section
  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          widget.page.title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.page.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          widget.page.subtitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: widget.page.secondaryColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build description section
  Widget _buildDescriptionSection() {
    return Text(
      widget.page.description,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
        height: 1.6,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build features section with staggered animations
  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.page.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        StaggeredFeatureList(
          features: widget.page.features,
          staggerDelay: widget.page.animationConfig.staggerDelay,
          animationDuration: AnimationConstants.standardDuration,
          autoStart: widget.isActive && widget.animationComplete,
        ),
      ],
    );
  }
}

/// Responsive onboarding page content
/// 
/// A variant that adapts its layout based on screen size
/// for optimal viewing on different devices.
class ResponsiveOnboardingPageContent extends StatelessWidget {
  /// Creates responsive onboarding page content
  const ResponsiveOnboardingPageContent({
    super.key,
    required this.page,
    required this.isActive,
    required this.animationComplete,
  });

  /// The onboarding page to display
  final OnboardingPage page;

  /// Whether this page is currently active
  final bool isActive;

  /// Whether entrance animation is complete
  final bool animationComplete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600 && constraints.maxWidth < 1024;
        final isDesktop = constraints.maxWidth >= 1024;

        if (isDesktop) {
          return _buildDesktopLayout();
        } else if (isTablet) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  /// Build mobile layout (single column)
  Widget _buildMobileLayout() {
    return OnboardingPageContent(
      page: page,
      isActive: isActive,
      animationComplete: animationComplete,
    );
  }

  /// Build tablet layout (enhanced spacing)
  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: OnboardingPageContent(
        page: page,
        isActive: isActive,
        animationComplete: animationComplete,
      ),
    );
  }

  /// Build desktop layout (two columns)
  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 48.0),
      child: Row(
        children: [
          // Image section
          Expanded(
            flex: 5,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    page.primaryColor.withOpacity(0.1),
                    page.secondaryColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.animation,
                  size: 120,
                  color: page.primaryColor,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 80),
          
          // Content section
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  page.title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: page.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  page.subtitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: page.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  page.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
                if (page.features.isNotEmpty) ...[
                  const SizedBox(height: 48),
                  StaggeredFeatureList(
                    features: page.features,
                    autoStart: isActive && animationComplete,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}