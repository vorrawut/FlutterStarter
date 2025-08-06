/// Custom animation curves for physics-based motion
/// 
/// This file provides custom animation curves that create natural,
/// physics-based motion including spring, elastic, and anticipation curves.
library;

import 'dart:math';
import 'package:flutter/material.dart';

/// Custom spring curve for natural bounce motion
/// 
/// Creates a spring-like motion that overshoots slightly before settling.
/// Perfect for entrance animations and playful interactions.
class SpringCurve extends Curve {
  /// Creates a spring curve with customizable parameters
  const SpringCurve({
    this.damping = 0.7,
    this.stiffness = 1.0,
    this.mass = 1.0,
  });

  /// Damping factor (0.0 = no damping, 1.0 = critical damping)
  final double damping;

  /// Spring stiffness (higher = stiffer spring)
  final double stiffness;

  /// Mass of the animated object
  final double mass;

  @override
  double transform(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    // Calculate spring physics
    final double dampingRatio = damping;
    final double angularFreq = sqrt(stiffness / mass);
    final double dampedFreq = angularFreq * sqrt(1.0 - dampingRatio * dampingRatio);
    
    // Spring equation with damping
    final double amplitude = exp(-dampingRatio * angularFreq * t);
    final double oscillation = cos(dampedFreq * t) + 
                              (dampingRatio * angularFreq / dampedFreq) * sin(dampedFreq * t);
    
    return 1.0 - amplitude * oscillation;
  }

  @override
  String toString() => 'SpringCurve(damping: $damping, stiffness: $stiffness, mass: $mass)';
}

/// Elastic curve with customizable bounce
/// 
/// Creates an elastic motion that bounces several times before settling.
/// Great for attention-grabbing animations and playful feedback.
class ElasticCurve extends Curve {
  /// Creates an elastic curve
  const ElasticCurve({
    this.period = 0.4,
    this.amplitude = 1.0,
  });

  /// Period of the elastic oscillation
  final double period;

  /// Amplitude of the elastic bounce
  final double amplitude;

  @override
  double transform(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    final double s = period / 4.0;
    t = t - 1.0;
    return -(amplitude * pow(2.0, 10.0 * t) * sin((t - s) * (2.0 * pi) / period));
  }

  @override
  String toString() => 'ElasticCurve(period: $period, amplitude: $amplitude)';
}

/// Anticipation curve that pulls back before moving forward
/// 
/// Creates motion that briefly moves in the opposite direction before
/// proceeding to the target. Perfect for dramatic, attention-grabbing effects.
class AnticipationCurve extends Curve {
  /// Creates an anticipation curve
  const AnticipationCurve({
    this.anticipation = 0.2,
    this.overshoot = 1.1,
  });

  /// Amount of anticipation (pullback) before the main motion
  final double anticipation;

  /// Amount of overshoot past the target
  final double overshoot;

  @override
  double transform(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    // Anticipation phase (first 20% of animation)
    if (t < 0.2) {
      return -anticipation * (1.0 - t / 0.2);
    }
    
    // Main motion phase with overshoot
    final double adjustedT = (t - 0.2) / 0.8;
    final double overshootPoint = 0.8;
    
    if (adjustedT < overshootPoint) {
      // Accelerating towards overshoot
      final double progress = adjustedT / overshootPoint;
      return overshoot * (progress * progress);
    } else {
      // Settling back to final position
      final double settleProgress = (adjustedT - overshootPoint) / (1.0 - overshootPoint);
      return overshoot - (overshoot - 1.0) * settleProgress;
    }
  }

  @override
  String toString() => 'AnticipationCurve(anticipation: $anticipation, overshoot: $overshoot)';
}

/// Bounce curve that simulates a ball bouncing
/// 
/// Creates motion that bounces several times with decreasing amplitude.
/// Perfect for playful interactions and physics-based feedback.
class BounceCurve extends Curve {
  /// Creates a bounce curve
  const BounceCurve({
    this.bounces = 3,
    this.decay = 0.6,
  });

  /// Number of bounces
  final int bounces;

  /// Decay factor for each bounce (0.0 = no decay, 1.0 = complete decay)
  final double decay;

  @override
  double transform(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    double progress = t;
    double amplitude = 1.0;
    
    for (int i = 0; i < bounces; i++) {
      final double bounceStart = i / bounces;
      final double bounceEnd = (i + 1) / bounces;
      
      if (progress >= bounceStart && progress <= bounceEnd) {
        final double bounceProgress = (progress - bounceStart) / (bounceEnd - bounceStart);
        final double bounceHeight = amplitude * (1.0 - pow(bounceProgress, 2));
        return 1.0 - bounceHeight;
      }
      
      amplitude *= (1.0 - decay);
    }
    
    return 1.0;
  }

  @override
  String toString() => 'BounceCurve(bounces: $bounces, decay: $decay)';
}

/// Smooth step curve for gradual acceleration and deceleration
/// 
/// Creates smooth motion that starts slowly, accelerates, then decelerates.
/// Perfect for professional, polished animations.
class SmoothStepCurve extends Curve {
  /// Creates a smooth step curve
  const SmoothStepCurve({
    this.smoothness = 2.0,
  });

  /// Smoothness factor (higher = smoother)
  final double smoothness;

  @override
  double transform(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    // Smooth step function: t^smoothness * (smoothness+1 - smoothness*t)
    return pow(t, smoothness) * (smoothness + 1 - smoothness * t);
  }

  @override
  String toString() => 'SmoothStepCurve(smoothness: $smoothness)';
}

/// Custom curve that combines multiple curves in sequence
/// 
/// Allows chaining different curve behaviors for complex animations.
/// Perfect for multi-phase animations and complex motion design.
class SequenceCurve extends Curve {
  /// Creates a sequence curve
  const SequenceCurve({
    required this.curves,
    required this.thresholds,
  }) : assert(curves.length == thresholds.length);

  /// List of curves to sequence
  final List<Curve> curves;

  /// Threshold points where curves change (must sum to 1.0)
  final List<double> thresholds;

  @override
  double transform(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    double accumulatedThreshold = 0.0;
    double accumulatedValue = 0.0;

    for (int i = 0; i < curves.length; i++) {
      final double threshold = thresholds[i];
      final double nextAccumulatedThreshold = accumulatedThreshold + threshold;

      if (t <= nextAccumulatedThreshold) {
        final double localT = (t - accumulatedThreshold) / threshold;
        final double curveValue = curves[i].transform(localT);
        return accumulatedValue + curveValue * threshold;
      }

      accumulatedThreshold = nextAccumulatedThreshold;
      accumulatedValue += threshold;
    }

    return 1.0;
  }

  @override
  String toString() => 'SequenceCurve(curves: $curves, thresholds: $thresholds)';
}

/// Predefined custom curves for common animation patterns
/// 
/// Provides ready-to-use curves for typical animation scenarios.
class AnimationCurves {
  /// Private constructor
  const AnimationCurves._();

  /// Gentle spring for subtle interactions
  static const Curve gentleSpring = SpringCurve(
    damping: 0.8,
    stiffness: 1.2,
    mass: 1.0,
  );

  /// Bouncy spring for playful interactions
  static const Curve bouncySpring = SpringCurve(
    damping: 0.5,
    stiffness: 1.5,
    mass: 0.8,
  );

  /// Subtle elastic for micro-interactions
  static const Curve subtleElastic = ElasticCurve(
    period: 0.6,
    amplitude: 0.8,
  );

  /// Dramatic elastic for attention-grabbing effects
  static const Curve dramaticElastic = ElasticCurve(
    period: 0.3,
    amplitude: 1.2,
  );

  /// Gentle anticipation for smooth dramatic effects
  static const Curve gentleAnticipation = AnticipationCurve(
    anticipation: 0.1,
    overshoot: 1.05,
  );

  /// Strong anticipation for maximum drama
  static const Curve strongAnticipation = AnticipationCurve(
    anticipation: 0.3,
    overshoot: 1.2,
  );

  /// Soft bounce for gentle feedback
  static const Curve softBounce = BounceCurve(
    bounces: 2,
    decay: 0.7,
  );

  /// Hard bounce for impactful feedback
  static const Curve hardBounce = BounceCurve(
    bounces: 4,
    decay: 0.5,
  );

  /// Ultra smooth for premium feel
  static const Curve ultraSmooth = SmoothStepCurve(
    smoothness: 3.0,
  );

  /// Standard smooth for general use
  static const Curve standardSmooth = SmoothStepCurve(
    smoothness: 2.0,
  );

  /// Entrance sequence: anticipation → spring → settle
  static const Curve entranceSequence = SequenceCurve(
    curves: [
      AnticipationCurve(anticipation: 0.1),
      SpringCurve(damping: 0.7),
      Curves.easeOut,
    ],
    thresholds: [0.2, 0.6, 0.2],
  );

  /// Exit sequence: ease → anticipation → fast out
  static const Curve exitSequence = SequenceCurve(
    curves: [
      Curves.easeIn,
      AnticipationCurve(anticipation: 0.05),
      Curves.fastOutSlowIn,
    ],
    thresholds: [0.3, 0.3, 0.4],
  );
}

/// Extension methods for easy curve access
extension CurveExtensions on Curve {
  /// Create a delayed version of this curve
  Curve delayed(double delay) {
    return Interval(delay, 1.0, curve: this);
  }

  /// Reverse this curve
  Curve get reversed => FlippedCurve(this);

  /// Create a curve that repeats this curve multiple times
  Curve repeated(int times) {
    return SawTooth(times);
  }

  /// Combine this curve with another curve
  Curve then(Curve other, {double splitPoint = 0.5}) {
    return SequenceCurve(
      curves: [this, other],
      thresholds: [splitPoint, 1.0 - splitPoint],
    );
  }
}