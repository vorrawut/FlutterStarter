/// Animation constants and timing configurations
/// 
/// This file defines all animation durations, curves, and configuration
/// constants used throughout the application for consistent motion design.
library;

import 'package:flutter/material.dart';

/// Central configuration for all animation timing and behavior
/// 
/// Provides consistent animation parameters following Material Design
/// motion guidelines and ensuring smooth 60fps performance.
class AnimationConstants {
  /// Private constructor to prevent instantiation
  const AnimationConstants._();

  // ========================================
  // DURATION CONSTANTS
  // ========================================

  /// Very fast animations for micro-interactions
  static const Duration microDuration = Duration(milliseconds: 100);

  /// Fast animations for quick feedback
  static const Duration fastDuration = Duration(milliseconds: 200);

  /// Standard animations for most UI transitions
  static const Duration standardDuration = Duration(milliseconds: 300);

  /// Medium animations for complex transitions
  static const Duration mediumDuration = Duration(milliseconds: 500);

  /// Slow animations for dramatic effects
  static const Duration slowDuration = Duration(milliseconds: 700);

  /// Very slow animations for storytelling
  static const Duration verySlowDuration = Duration(milliseconds: 1000);

  // ========================================
  // STAGGER TIMING
  // ========================================

  /// Delay between staggered list items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Delay between onboarding elements
  static const Duration onboardingStagger = Duration(milliseconds: 100);

  /// Delay between hero animation elements
  static const Duration heroStagger = Duration(milliseconds: 150);

  /// Delay for page transition elements
  static const Duration pageTransitionStagger = Duration(milliseconds: 75);

  // ========================================
  // CURVE CONSTANTS
  // ========================================

  /// Standard ease-in-out curve for most animations
  static const Curve standardCurve = Curves.easeInOut;

  /// Ease-out curve for entrance animations
  static const Curve entranceCurve = Curves.easeOut;

  /// Ease-in curve for exit animations
  static const Curve exitCurve = Curves.easeIn;

  /// Elastic curve for playful animations
  static const Curve elasticCurve = Curves.elasticOut;

  /// Spring curve for natural motion
  static const Curve springCurve = Curves.bounceOut;

  /// Fast-out-slow-in curve for Material Design
  static const Curve materialCurve = Curves.fastOutSlowIn;

  /// Anticipation curve for dramatic effects
  static const Curve anticipationCurve = Curves.elasticInOut;

  // ========================================
  // ANIMATION VALUES
  // ========================================

  /// Scale values for micro-interactions
  static const double microScaleDown = 0.95;
  static const double microScaleUp = 1.05;

  /// Opacity values for fade animations
  static const double fadeStart = 0.0;
  static const double fadeEnd = 1.0;
  static const double fadePartial = 0.7;

  /// Slide distances for slide animations
  static const double slideDistanceSmall = 20.0;
  static const double slideDistanceMedium = 50.0;
  static const double slideDistanceLarge = 100.0;

  /// Rotation values (in radians)
  static const double rotationQuarter = 0.785398; // π/4
  static const double rotationHalf = 1.570796;    // π/2
  static const double rotationFull = 6.283185;    // 2π

  // ========================================
  // ANIMATION CONFIGURATIONS
  // ========================================

  /// Button animation configuration
  static const AnimationConfig buttonConfig = AnimationConfig(
    duration: microDuration,
    curve: standardCurve,
    scaleDown: microScaleDown,
    scaleUp: 1.0,
  );

  /// Card entrance animation configuration
  static const AnimationConfig cardEntranceConfig = AnimationConfig(
    duration: mediumDuration,
    curve: entranceCurve,
    slideDistance: slideDistanceMedium,
    fadeStart: fadeStart,
    fadeEnd: fadeEnd,
  );

  /// Page transition animation configuration
  static const AnimationConfig pageTransitionConfig = AnimationConfig(
    duration: standardDuration,
    curve: materialCurve,
    slideDistance: slideDistanceLarge,
  );

  /// Hero animation configuration
  static const AnimationConfig heroConfig = AnimationConfig(
    duration: standardDuration,
    curve: materialCurve,
  );

  /// Progress indicator configuration
  static const AnimationConfig progressConfig = AnimationConfig(
    duration: slowDuration,
    curve: standardCurve,
    scaleUp: microScaleUp,
  );

  // ========================================
  // PERFORMANCE CONSTANTS
  // ========================================

  /// Target frame rate for animations
  static const int targetFPS = 60;

  /// Maximum animation duration for performance
  static const Duration maxAnimationDuration = Duration(seconds: 2);

  /// Animation frame budget in milliseconds
  static const double frameBudget = 16.67; // 1000ms / 60fps

  /// Memory allocation threshold for animations
  static const int maxConcurrentAnimations = 10;

  // ========================================
  // ACCESSIBILITY CONSTANTS
  // ========================================

  /// Reduced animation duration for accessibility
  static const Duration reducedMotionDuration = Duration(milliseconds: 100);

  /// Minimum animation duration for visibility
  static const Duration minimumDuration = Duration(milliseconds: 50);

  /// Animation scale factor for reduced motion
  static const double reducedMotionScale = 0.5;
}

/// Animation configuration data class
/// 
/// Encapsulates all animation parameters for consistent configuration
/// and easy modification of animation behavior.
class AnimationConfig {
  /// Creates an animation configuration
  const AnimationConfig({
    required this.duration,
    required this.curve,
    this.scaleDown = 1.0,
    this.scaleUp = 1.0,
    this.slideDistance = 0.0,
    this.fadeStart = 1.0,
    this.fadeEnd = 1.0,
    this.rotation = 0.0,
    this.staggerDelay,
  });

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Scale down value for press animations
  final double scaleDown;

  /// Scale up value for hover/focus animations
  final double scaleUp;

  /// Slide distance for slide animations
  final double slideDistance;

  /// Starting opacity for fade animations
  final double fadeStart;

  /// Ending opacity for fade animations
  final double fadeEnd;

  /// Rotation value for rotation animations
  final double rotation;

  /// Stagger delay for sequenced animations
  final Duration? staggerDelay;

  /// Create a copy with modified values
  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    double? scaleDown,
    double? scaleUp,
    double? slideDistance,
    double? fadeStart,
    double? fadeEnd,
    double? rotation,
    Duration? staggerDelay,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      scaleDown: scaleDown ?? this.scaleDown,
      scaleUp: scaleUp ?? this.scaleUp,
      slideDistance: slideDistance ?? this.slideDistance,
      fadeStart: fadeStart ?? this.fadeStart,
      fadeEnd: fadeEnd ?? this.fadeEnd,
      rotation: rotation ?? this.rotation,
      staggerDelay: staggerDelay ?? this.staggerDelay,
    );
  }

  /// Create a reduced motion version of this configuration
  AnimationConfig toReducedMotion() {
    return copyWith(
      duration: Duration(
        milliseconds: (duration.inMilliseconds * AnimationConstants.reducedMotionScale).round(),
      ),
      slideDistance: slideDistance * AnimationConstants.reducedMotionScale,
      scaleDown: 1.0 + (scaleDown - 1.0) * AnimationConstants.reducedMotionScale,
      scaleUp: 1.0 + (scaleUp - 1.0) * AnimationConstants.reducedMotionScale,
    );
  }

  @override
  String toString() {
    return 'AnimationConfig('
        'duration: $duration, '
        'curve: $curve, '
        'scaleDown: $scaleDown, '
        'scaleUp: $scaleUp, '
        'slideDistance: $slideDistance, '
        'fadeStart: $fadeStart, '
        'fadeEnd: $fadeEnd, '
        'rotation: $rotation, '
        'staggerDelay: $staggerDelay'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimationConfig &&
        other.duration == duration &&
        other.curve == curve &&
        other.scaleDown == scaleDown &&
        other.scaleUp == scaleUp &&
        other.slideDistance == slideDistance &&
        other.fadeStart == fadeStart &&
        other.fadeEnd == fadeEnd &&
        other.rotation == rotation &&
        other.staggerDelay == staggerDelay;
  }

  @override
  int get hashCode {
    return Object.hash(
      duration,
      curve,
      scaleDown,
      scaleUp,
      slideDistance,
      fadeStart,
      fadeEnd,
      rotation,
      staggerDelay,
    );
  }
}