/// Animation configuration entities for onboarding pages
/// 
/// This file defines animation configuration classes that specify
/// how different elements should animate within onboarding pages.
library;

import 'package:flutter/material.dart';
import '../../core/constants/animation_constants.dart';
import '../../core/animations/custom_curves.dart';

/// Onboarding animation configuration
/// 
/// Defines animation behavior for onboarding page elements including
/// entrance patterns, transitions, and micro-interactions.
class OnboardingAnimationConfig {
  /// Creates an onboarding animation configuration
  const OnboardingAnimationConfig({
    required this.entrancePattern,
    required this.transitionType,
    required this.elementAnimations,
    this.pageTransitionDuration = AnimationConstants.standardDuration,
    this.staggerDelay = AnimationConstants.onboardingStagger,
    this.enableParallax = true,
    this.enableMicroInteractions = true,
    this.enableSoundEffects = false,
    this.customCurve,
  });

  /// Pattern for element entrance animations
  final EntrancePattern entrancePattern;

  /// Type of page transition
  final TransitionType transitionType;

  /// Configuration for individual element animations
  final List<ElementAnimationConfig> elementAnimations;

  /// Duration for page transitions
  final Duration pageTransitionDuration;

  /// Delay between staggered element animations
  final Duration staggerDelay;

  /// Whether to enable parallax effects
  final bool enableParallax;

  /// Whether to enable micro-interactions
  final bool enableMicroInteractions;

  /// Whether to enable sound effects
  final bool enableSoundEffects;

  /// Optional custom curve override
  final Curve? customCurve;

  /// Create dramatic entrance configuration
  factory OnboardingAnimationConfig.dramatic() {
    return OnboardingAnimationConfig(
      entrancePattern: EntrancePattern.dramatic,
      transitionType: TransitionType.hero,
      pageTransitionDuration: AnimationConstants.slowDuration,
      elementAnimations: [
        ElementAnimationConfig.heroImage(),
        ElementAnimationConfig.titleWithAnticipation(),
        ElementAnimationConfig.subtitleSlide(),
        ElementAnimationConfig.descriptionFade(),
        ElementAnimationConfig.buttonBounce(),
      ],
      customCurve: AnimationCurves.strongAnticipation,
    );
  }

  /// Create elegant entrance configuration
  factory OnboardingAnimationConfig.elegant() {
    return OnboardingAnimationConfig(
      entrancePattern: EntrancePattern.elegant,
      transitionType: TransitionType.slide,
      pageTransitionDuration: AnimationConstants.mediumDuration,
      elementAnimations: [
        ElementAnimationConfig.imageSlide(),
        ElementAnimationConfig.titleSlide(),
        ElementAnimationConfig.subtitleFade(),
        ElementAnimationConfig.descriptionSlide(),
        ElementAnimationConfig.buttonSlide(),
      ],
      customCurve: AnimationCurves.gentleSpring,
    );
  }

  /// Create staggered entrance configuration
  factory OnboardingAnimationConfig.staggered() {
    return OnboardingAnimationConfig(
      entrancePattern: EntrancePattern.staggered,
      transitionType: TransitionType.fade,
      pageTransitionDuration: AnimationConstants.standardDuration,
      staggerDelay: AnimationConstants.staggerDelay,
      elementAnimations: [
        ElementAnimationConfig.imageStagger(0),
        ElementAnimationConfig.titleStagger(1),
        ElementAnimationConfig.subtitleStagger(2),
        ElementAnimationConfig.descriptionStagger(3),
        ElementAnimationConfig.featuresStagger(4),
        ElementAnimationConfig.buttonStagger(5),
      ],
    );
  }

  /// Create playful entrance configuration
  factory OnboardingAnimationConfig.playful() {
    return OnboardingAnimationConfig(
      entrancePattern: EntrancePattern.playful,
      transitionType: TransitionType.scale,
      pageTransitionDuration: AnimationConstants.mediumDuration,
      elementAnimations: [
        ElementAnimationConfig.imageBounce(),
        ElementAnimationConfig.titleBounce(),
        ElementAnimationConfig.subtitleElastic(),
        ElementAnimationConfig.descriptionWave(),
        ElementAnimationConfig.buttonElastic(),
      ],
      customCurve: AnimationCurves.bouncySpring,
      enableMicroInteractions: true,
    );
  }

  /// Create minimal entrance configuration
  factory OnboardingAnimationConfig.minimal() {
    return OnboardingAnimationConfig(
      entrancePattern: EntrancePattern.minimal,
      transitionType: TransitionType.fade,
      pageTransitionDuration: AnimationConstants.fastDuration,
      elementAnimations: [
        ElementAnimationConfig.imageFade(),
        ElementAnimationConfig.titleFade(),
        ElementAnimationConfig.subtitleFade(),
        ElementAnimationConfig.descriptionFade(),
        ElementAnimationConfig.buttonFade(),
      ],
      enableParallax: false,
      enableMicroInteractions: false,
    );
  }

  /// Get element animation config by type
  ElementAnimationConfig? getElementConfig(ElementType type) {
    try {
      return elementAnimations.firstWhere((config) => config.elementType == type);
    } catch (e) {
      return null;
    }
  }

  /// Create a copy with modified values
  OnboardingAnimationConfig copyWith({
    EntrancePattern? entrancePattern,
    TransitionType? transitionType,
    List<ElementAnimationConfig>? elementAnimations,
    Duration? pageTransitionDuration,
    Duration? staggerDelay,
    bool? enableParallax,
    bool? enableMicroInteractions,
    bool? enableSoundEffects,
    Curve? customCurve,
  }) {
    return OnboardingAnimationConfig(
      entrancePattern: entrancePattern ?? this.entrancePattern,
      transitionType: transitionType ?? this.transitionType,
      elementAnimations: elementAnimations ?? this.elementAnimations,
      pageTransitionDuration: pageTransitionDuration ?? this.pageTransitionDuration,
      staggerDelay: staggerDelay ?? this.staggerDelay,
      enableParallax: enableParallax ?? this.enableParallax,
      enableMicroInteractions: enableMicroInteractions ?? this.enableMicroInteractions,
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
      customCurve: customCurve ?? this.customCurve,
    );
  }

  @override
  String toString() {
    return 'OnboardingAnimationConfig('
        'entrancePattern: $entrancePattern, '
        'transitionType: $transitionType, '
        'elements: ${elementAnimations.length}'
        ')';
  }
}

/// Element animation configuration
/// 
/// Defines animation behavior for individual UI elements within onboarding pages.
class ElementAnimationConfig {
  /// Creates an element animation configuration
  const ElementAnimationConfig({
    required this.elementType,
    required this.animationType,
    required this.duration,
    required this.curve,
    this.delay = Duration.zero,
    this.startOffset = Offset.zero,
    this.endOffset = Offset.zero,
    this.startScale = 1.0,
    this.endScale = 1.0,
    this.startOpacity = 0.0,
    this.endOpacity = 1.0,
    this.startRotation = 0.0,
    this.endRotation = 0.0,
    this.springTension = 1.0,
    this.springFriction = 1.0,
  });

  /// Type of UI element
  final ElementType elementType;

  /// Type of animation
  final AnimationType animationType;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Delay before animation starts
  final Duration delay;

  /// Starting position offset
  final Offset startOffset;

  /// Ending position offset
  final Offset endOffset;

  /// Starting scale factor
  final double startScale;

  /// Ending scale factor
  final double endScale;

  /// Starting opacity
  final double startOpacity;

  /// Ending opacity
  final double endOpacity;

  /// Starting rotation (in radians)
  final double startRotation;

  /// Ending rotation (in radians)
  final double endRotation;

  /// Spring animation tension
  final double springTension;

  /// Spring animation friction
  final double springFriction;

  // Predefined configurations for common elements

  /// Hero image animation
  factory ElementAnimationConfig.heroImage() {
    return ElementAnimationConfig(
      elementType: ElementType.image,
      animationType: AnimationType.scaleAndFade,
      duration: AnimationConstants.slowDuration,
      curve: AnimationCurves.gentleSpring,
      startScale: 0.5,
      endScale: 1.0,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  /// Title with anticipation
  factory ElementAnimationConfig.titleWithAnticipation() {
    return ElementAnimationConfig(
      elementType: ElementType.title,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.mediumDuration,
      curve: AnimationCurves.gentleAnticipation,
      delay: const Duration(milliseconds: 200),
      startOffset: const Offset(0.0, -50.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  /// Subtitle slide animation
  factory ElementAnimationConfig.subtitleSlide() {
    return ElementAnimationConfig(
      elementType: ElementType.subtitle,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeOut,
      delay: const Duration(milliseconds: 400),
      startOffset: const Offset(30.0, 0.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  /// Description fade animation
  factory ElementAnimationConfig.descriptionFade() {
    return ElementAnimationConfig(
      elementType: ElementType.description,
      animationType: AnimationType.fade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeInOut,
      delay: const Duration(milliseconds: 600),
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  /// Button bounce animation
  factory ElementAnimationConfig.buttonBounce() {
    return ElementAnimationConfig(
      elementType: ElementType.button,
      animationType: AnimationType.scaleAndFade,
      duration: AnimationConstants.mediumDuration,
      curve: AnimationCurves.bouncySpring,
      delay: const Duration(milliseconds: 800),
      startScale: 0.8,
      endScale: 1.0,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  // Staggered animations
  factory ElementAnimationConfig.imageStagger(int index) {
    return ElementAnimationConfig(
      elementType: ElementType.image,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: AnimationCurves.gentleSpring,
      delay: Duration(milliseconds: index * 100),
      startOffset: const Offset(0.0, 30.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.titleStagger(int index) {
    return ElementAnimationConfig(
      elementType: ElementType.title,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeOut,
      delay: Duration(milliseconds: index * 100),
      startOffset: const Offset(-20.0, 0.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.subtitleStagger(int index) {
    return ElementAnimationConfig(
      elementType: ElementType.subtitle,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeOut,
      delay: Duration(milliseconds: index * 100),
      startOffset: const Offset(20.0, 0.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.descriptionStagger(int index) {
    return ElementAnimationConfig(
      elementType: ElementType.description,
      animationType: AnimationType.fade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeInOut,
      delay: Duration(milliseconds: index * 100),
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.featuresStagger(int index) {
    return ElementAnimationConfig(
      elementType: ElementType.features,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: AnimationCurves.gentleSpring,
      delay: Duration(milliseconds: index * 100),
      startOffset: const Offset(0.0, 20.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.buttonStagger(int index) {
    return ElementAnimationConfig(
      elementType: ElementType.button,
      animationType: AnimationType.scaleAndFade,
      duration: AnimationConstants.standardDuration,
      curve: AnimationCurves.gentleSpring,
      delay: Duration(milliseconds: index * 100),
      startScale: 0.9,
      endScale: 1.0,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  // Additional animation factories
  factory ElementAnimationConfig.imageSlide() {
    return ElementAnimationConfig(
      elementType: ElementType.image,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.mediumDuration,
      curve: Curves.easeOut,
      startOffset: const Offset(0.0, 50.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.titleSlide() {
    return ElementAnimationConfig(
      elementType: ElementType.title,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeOut,
      delay: const Duration(milliseconds: 100),
      startOffset: const Offset(-30.0, 0.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.subtitleFade() {
    return ElementAnimationConfig(
      elementType: ElementType.subtitle,
      animationType: AnimationType.fade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeInOut,
      delay: const Duration(milliseconds: 200),
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.descriptionSlide() {
    return ElementAnimationConfig(
      elementType: ElementType.description,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeOut,
      delay: const Duration(milliseconds: 300),
      startOffset: const Offset(20.0, 0.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.buttonSlide() {
    return ElementAnimationConfig(
      elementType: ElementType.button,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeOut,
      delay: const Duration(milliseconds: 400),
      startOffset: const Offset(0.0, 30.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.imageBounce() {
    return ElementAnimationConfig(
      elementType: ElementType.image,
      animationType: AnimationType.scaleAndFade,
      duration: AnimationConstants.mediumDuration,
      curve: AnimationCurves.bouncySpring,
      startScale: 0.7,
      endScale: 1.0,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.titleBounce() {
    return ElementAnimationConfig(
      elementType: ElementType.title,
      animationType: AnimationType.scaleAndFade,
      duration: AnimationConstants.standardDuration,
      curve: AnimationCurves.softBounce,
      delay: const Duration(milliseconds: 100),
      startScale: 0.9,
      endScale: 1.0,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.subtitleElastic() {
    return ElementAnimationConfig(
      elementType: ElementType.subtitle,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.standardDuration,
      curve: AnimationCurves.subtleElastic,
      delay: const Duration(milliseconds: 200),
      startOffset: const Offset(40.0, 0.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.descriptionWave() {
    return ElementAnimationConfig(
      elementType: ElementType.description,
      animationType: AnimationType.slideAndFade,
      duration: AnimationConstants.mediumDuration,
      curve: Curves.elasticOut,
      delay: const Duration(milliseconds: 300),
      startOffset: const Offset(0.0, 25.0),
      endOffset: Offset.zero,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.buttonElastic() {
    return ElementAnimationConfig(
      elementType: ElementType.button,
      animationType: AnimationType.scaleAndFade,
      duration: AnimationConstants.standardDuration,
      curve: AnimationCurves.dramaticElastic,
      delay: const Duration(milliseconds: 400),
      startScale: 0.8,
      endScale: 1.0,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.imageFade() {
    return ElementAnimationConfig(
      elementType: ElementType.image,
      animationType: AnimationType.fade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeInOut,
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.titleFade() {
    return ElementAnimationConfig(
      elementType: ElementType.title,
      animationType: AnimationType.fade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeInOut,
      delay: const Duration(milliseconds: 100),
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  factory ElementAnimationConfig.buttonFade() {
    return ElementAnimationConfig(
      elementType: ElementType.button,
      animationType: AnimationType.fade,
      duration: AnimationConstants.standardDuration,
      curve: Curves.easeInOut,
      delay: const Duration(milliseconds: 300),
      startOpacity: 0.0,
      endOpacity: 1.0,
    );
  }

  @override
  String toString() {
    return 'ElementAnimationConfig('
        'elementType: $elementType, '
        'animationType: $animationType, '
        'duration: $duration'
        ')';
  }
}

/// Entrance pattern enumeration
enum EntrancePattern {
  /// Dramatic entrance with anticipation and strong effects
  dramatic,

  /// Elegant entrance with smooth, refined animations
  elegant,

  /// Staggered entrance with coordinated timing
  staggered,

  /// Playful entrance with bouncy, elastic effects
  playful,

  /// Minimal entrance with simple fade effects
  minimal,

  /// Custom entrance pattern
  custom,
}

/// Transition type enumeration
enum TransitionType {
  /// Fade transition between pages
  fade,

  /// Slide transition between pages
  slide,

  /// Scale transition between pages
  scale,

  /// Hero transition between pages
  hero,

  /// Custom transition
  custom,
}

/// Animation type enumeration
enum AnimationType {
  /// Simple fade in/out
  fade,

  /// Slide with direction
  slide,

  /// Scale up/down
  scale,

  /// Rotation animation
  rotate,

  /// Combined slide and fade
  slideAndFade,

  /// Combined scale and fade
  scaleAndFade,

  /// Combined slide and scale
  slideAndScale,

  /// Complex multi-phase animation
  complex,

  /// Custom animation
  custom,
}

/// Element type enumeration
enum ElementType {
  /// Main image or illustration
  image,

  /// Page title
  title,

  /// Page subtitle
  subtitle,

  /// Page description
  description,

  /// Feature list
  features,

  /// Call-to-action button
  button,

  /// Progress indicator
  progress,

  /// Navigation controls
  navigation,

  /// Background elements
  background,

  /// Custom element
  custom,
}