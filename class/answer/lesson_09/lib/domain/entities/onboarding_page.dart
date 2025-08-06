/// Onboarding page entity for animation-rich onboarding flow
/// 
/// This file defines the core onboarding page entity with animation
/// configurations and content structure for the animated onboarding experience.
library;

import 'package:flutter/material.dart';
import '../../core/constants/animation_constants.dart';
import 'animation_config.dart';

/// Onboarding page entity
/// 
/// Represents a single page in the onboarding flow with content,
/// visuals, and animation configurations.
class OnboardingPage {
  /// Creates an onboarding page
  const OnboardingPage({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.primaryColor,
    required this.secondaryColor,
    required this.features,
    required this.animationConfig,
    this.backgroundGradient,
    this.ctaText,
    this.skipText = 'Skip',
    this.nextText = 'Next',
  });

  /// Unique identifier for the page
  final String id;

  /// Main title of the page
  final String title;

  /// Subtitle or tagline
  final String subtitle;

  /// Detailed description
  final String description;

  /// Path to the main illustration or image
  final String imagePath;

  /// Primary color theme for the page
  final Color primaryColor;

  /// Secondary color theme for the page
  final Color secondaryColor;

  /// List of key features or benefits
  final List<OnboardingFeature> features;

  /// Animation configuration for this page
  final OnboardingAnimationConfig animationConfig;

  /// Optional background gradient
  final LinearGradient? backgroundGradient;

  /// Call-to-action text (for final page)
  final String? ctaText;

  /// Skip button text
  final String skipText;

  /// Next button text
  final String nextText;

  /// Create a copy with modified values
  OnboardingPage copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? imagePath,
    Color? primaryColor,
    Color? secondaryColor,
    List<OnboardingFeature>? features,
    OnboardingAnimationConfig? animationConfig,
    LinearGradient? backgroundGradient,
    String? ctaText,
    String? skipText,
    String? nextText,
  }) {
    return OnboardingPage(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      features: features ?? this.features,
      animationConfig: animationConfig ?? this.animationConfig,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      ctaText: ctaText ?? this.ctaText,
      skipText: skipText ?? this.skipText,
      nextText: nextText ?? this.nextText,
    );
  }

  @override
  String toString() {
    return 'OnboardingPage('
        'id: $id, '
        'title: $title, '
        'features: ${features.length}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingPage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Onboarding feature entity
/// 
/// Represents a key feature or benefit highlighted in the onboarding page.
class OnboardingFeature {
  /// Creates an onboarding feature
  const OnboardingFeature({
    required this.icon,
    required this.title,
    required this.description,
    this.color,
    this.animationDelay,
  });

  /// Icon representing the feature
  final IconData icon;

  /// Feature title
  final String title;

  /// Feature description
  final String description;

  /// Optional color override
  final Color? color;

  /// Animation delay for staggered entrance
  final Duration? animationDelay;

  /// Create a copy with modified values
  OnboardingFeature copyWith({
    IconData? icon,
    String? title,
    String? description,
    Color? color,
    Duration? animationDelay,
  }) {
    return OnboardingFeature(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      animationDelay: animationDelay ?? this.animationDelay,
    );
  }

  @override
  String toString() {
    return 'OnboardingFeature(title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingFeature &&
        other.icon == icon &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => Object.hash(icon, title, description);
}

/// Onboarding page type enumeration
/// 
/// Defines the different types of onboarding pages for appropriate
/// animation and layout selection.
enum OnboardingPageType {
  /// Welcome/introduction page
  welcome,

  /// Feature showcase page
  feature,

  /// Benefits or value proposition page
  benefits,

  /// Call-to-action or final page
  callToAction,

  /// Custom page type
  custom,
}

/// Onboarding flow configuration
/// 
/// Configures the overall onboarding flow behavior and navigation.
class OnboardingFlowConfig {
  /// Creates an onboarding flow configuration
  const OnboardingFlowConfig({
    required this.pages,
    this.allowSkip = true,
    this.showProgress = true,
    this.autoAdvance = false,
    this.autoAdvanceDuration = const Duration(seconds: 5),
    this.loopAnimation = false,
    this.persistProgress = true,
    this.backgroundMusicPath,
    this.soundEffectsEnabled = true,
  });

  /// List of onboarding pages
  final List<OnboardingPage> pages;

  /// Whether users can skip the onboarding
  final bool allowSkip;

  /// Whether to show progress indicators
  final bool showProgress;

  /// Whether pages auto-advance
  final bool autoAdvance;

  /// Duration for auto-advance
  final Duration autoAdvanceDuration;

  /// Whether animations loop continuously
  final bool loopAnimation;

  /// Whether to persist onboarding progress
  final bool persistProgress;

  /// Optional background music file path
  final String? backgroundMusicPath;

  /// Whether sound effects are enabled
  final bool soundEffectsEnabled;

  /// Get total number of pages
  int get pageCount => pages.length;

  /// Check if this is the last page
  bool isLastPage(int index) => index >= pages.length - 1;

  /// Check if this is the first page
  bool isFirstPage(int index) => index <= 0;

  /// Get page by index safely
  OnboardingPage? getPage(int index) {
    if (index >= 0 && index < pages.length) {
      return pages[index];
    }
    return null;
  }

  /// Create a copy with modified values
  OnboardingFlowConfig copyWith({
    List<OnboardingPage>? pages,
    bool? allowSkip,
    bool? showProgress,
    bool? autoAdvance,
    Duration? autoAdvanceDuration,
    bool? loopAnimation,
    bool? persistProgress,
    String? backgroundMusicPath,
    bool? soundEffectsEnabled,
  }) {
    return OnboardingFlowConfig(
      pages: pages ?? this.pages,
      allowSkip: allowSkip ?? this.allowSkip,
      showProgress: showProgress ?? this.showProgress,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      autoAdvanceDuration: autoAdvanceDuration ?? this.autoAdvanceDuration,
      loopAnimation: loopAnimation ?? this.loopAnimation,
      persistProgress: persistProgress ?? this.persistProgress,
      backgroundMusicPath: backgroundMusicPath ?? this.backgroundMusicPath,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
    );
  }

  @override
  String toString() {
    return 'OnboardingFlowConfig(pages: ${pages.length}, allowSkip: $allowSkip)';
  }
}

/// Predefined onboarding page templates
/// 
/// Provides ready-to-use onboarding page configurations for common scenarios.
class OnboardingPageTemplates {
  /// Private constructor
  const OnboardingPageTemplates._();

  /// Welcome page template
  static OnboardingPage createWelcomePage({
    required String appName,
    required String tagline,
    String imagePath = 'assets/images/welcome.png',
    Color primaryColor = Colors.blue,
    Color secondaryColor = Colors.blueAccent,
  }) {
    return OnboardingPage(
      id: 'welcome',
      title: 'Welcome to $appName',
      subtitle: tagline,
      description: 'Get ready to experience something amazing. We\'re excited to have you on board!',
      imagePath: imagePath,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      features: [],
      animationConfig: OnboardingAnimationConfig.dramatic(),
      backgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor.withOpacity(0.1), secondaryColor.withOpacity(0.1)],
      ),
    );
  }

  /// Feature showcase page template
  static OnboardingPage createFeaturePage({
    required String title,
    required String subtitle,
    required String description,
    required List<OnboardingFeature> features,
    String imagePath = 'assets/images/features.png',
    Color primaryColor = Colors.green,
    Color secondaryColor = Colors.greenAccent,
  }) {
    return OnboardingPage(
      id: 'features',
      title: title,
      subtitle: subtitle,
      description: description,
      imagePath: imagePath,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      features: features,
      animationConfig: OnboardingAnimationConfig.staggered(),
    );
  }

  /// Call-to-action page template
  static OnboardingPage createCallToActionPage({
    required String title,
    required String subtitle,
    required String description,
    required String ctaText,
    String imagePath = 'assets/images/get_started.png',
    Color primaryColor = Colors.purple,
    Color secondaryColor = Colors.purpleAccent,
  }) {
    return OnboardingPage(
      id: 'cta',
      title: title,
      subtitle: subtitle,
      description: description,
      imagePath: imagePath,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      features: [],
      animationConfig: OnboardingAnimationConfig.elegant(),
      ctaText: ctaText,
    );
  }

  /// Create a complete onboarding flow
  static OnboardingFlowConfig createDefaultFlow({
    required String appName,
    required String tagline,
  }) {
    return OnboardingFlowConfig(
      pages: [
        createWelcomePage(appName: appName, tagline: tagline),
        createFeaturePage(
          title: 'Powerful Features',
          subtitle: 'Everything you need',
          description: 'Discover the amazing features that make $appName special.',
          features: [
            const OnboardingFeature(
              icon: Icons.speed,
              title: 'Lightning Fast',
              description: 'Optimized for speed and performance',
            ),
            const OnboardingFeature(
              icon: Icons.security,
              title: 'Secure & Private',
              description: 'Your data is safe and encrypted',
            ),
            const OnboardingFeature(
              icon: Icons.design_services,
              title: 'Beautiful Design',
              description: 'Crafted with attention to detail',
            ),
          ],
        ),
        createCallToActionPage(
          title: 'Ready to Begin?',
          subtitle: 'Let\'s get started',
          description: 'You\'re all set! Time to explore what $appName can do for you.',
          ctaText: 'Get Started',
        ),
      ],
    );
  }
}