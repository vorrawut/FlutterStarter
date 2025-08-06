/// Animation mixins for reusable animation behaviors
/// 
/// This file provides mixins that encapsulate common animation patterns,
/// making it easy to add consistent animation behaviors to widgets.
library;

import 'package:flutter/material.dart';
import '../constants/animation_constants.dart';
import 'animation_controller_manager.dart';
import 'custom_curves.dart';

/// Mixin for entrance animations
/// 
/// Provides ready-to-use entrance animation patterns including
/// fade-in, slide-in, scale-in, and staggered entrance effects.
mixin EntranceAnimationMixin<T extends StatefulWidget>
    on State<T>, AnimationControllerManagerMixin<T> {

  /// Fade entrance animation
  late final Animation<double> fadeAnimation;

  /// Slide entrance animation
  late final Animation<Offset> slideAnimation;

  /// Scale entrance animation
  late final Animation<double> scaleAnimation;

  /// Rotation entrance animation
  late final Animation<double> rotationAnimation;

  /// Initialize entrance animations
  void initializeEntranceAnimations({
    Duration duration = AnimationConstants.mediumDuration,
    Curve curve = AnimationCurves.gentleSpring,
    double slideDistance = AnimationConstants.slideDistanceMedium,
    Axis slideDirection = Axis.vertical,
  }) {
    final controller = createManagedController(
      id: 'entrance',
      duration: duration,
      debugLabel: 'EntranceAnimation',
    );

    // Fade animation
    fadeAnimation = Tween<double>(
      begin: AnimationConstants.fadeStart,
      end: AnimationConstants.fadeEnd,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    // Slide animation
    final slideOffset = slideDirection == Axis.vertical
        ? Offset(0.0, slideDistance / 100)
        : Offset(slideDistance / 100, 0.0);

    slideAnimation = Tween<Offset>(
      begin: slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.2, 1.0, curve: curve),
    ));

    // Scale animation
    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.3, 1.0, curve: AnimationCurves.gentleSpring),
    ));

    // Rotation animation (subtle)
    rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
  }

  /// Start entrance animation
  Future<void> startEntranceAnimation() async {
    final controller = getManagedController('entrance');
    if (controller != null) {
      await controller.forward();
    }
  }

  /// Reverse entrance animation
  Future<void> reverseEntranceAnimation() async {
    final controller = getManagedController('entrance');
    if (controller != null) {
      await controller.reverse();
    }
  }

  /// Build entrance animated widget
  Widget buildEntranceAnimatedWidget({
    required Widget child,
    bool enableFade = true,
    bool enableSlide = true,
    bool enableScale = true,
    bool enableRotation = false,
  }) {
    Widget animatedChild = child;

    // Apply rotation
    if (enableRotation) {
      animatedChild = AnimatedBuilder(
        animation: rotationAnimation,
        builder: (context, child) => Transform.rotate(
          angle: rotationAnimation.value,
          child: child,
        ),
        child: animatedChild,
      );
    }

    // Apply scale
    if (enableScale) {
      animatedChild = AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        ),
        child: animatedChild,
      );
    }

    // Apply slide
    if (enableSlide) {
      animatedChild = AnimatedBuilder(
        animation: slideAnimation,
        builder: (context, child) => SlideTransition(
          position: slideAnimation,
          child: child,
        ),
        child: animatedChild,
      );
    }

    // Apply fade
    if (enableFade) {
      animatedChild = AnimatedBuilder(
        animation: fadeAnimation,
        builder: (context, child) => FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
        child: animatedChild,
      );
    }

    return animatedChild;
  }
}

/// Mixin for micro-interaction animations
/// 
/// Provides button press, hover, and touch feedback animations
/// for delightful user interactions.
mixin MicroInteractionMixin<T extends StatefulWidget>
    on State<T>, AnimationControllerManagerMixin<T> {

  /// Scale animation for press feedback
  late final Animation<double> pressScaleAnimation;

  /// Opacity animation for press feedback
  late final Animation<double> pressOpacityAnimation;

  /// Ripple animation for touch feedback
  late final Animation<double> rippleAnimation;

  /// Initialize micro-interaction animations
  void initializeMicroInteractions({
    Duration pressDuration = AnimationConstants.microDuration,
    double pressScale = AnimationConstants.microScaleDown,
  }) {
    final pressController = createManagedController(
      id: 'press',
      duration: pressDuration,
      debugLabel: 'PressAnimation',
    );

    final rippleController = createManagedController(
      id: 'ripple',
      duration: AnimationConstants.fastDuration,
      debugLabel: 'RippleAnimation',
    );

    // Press scale animation
    pressScaleAnimation = Tween<double>(
      begin: 1.0,
      end: pressScale,
    ).animate(CurvedAnimation(
      parent: pressController,
      curve: Curves.easeInOut,
    ));

    // Press opacity animation
    pressOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: pressController,
      curve: Curves.easeInOut,
    ));

    // Ripple animation
    rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: rippleController,
      curve: Curves.easeOut,
    ));
  }

  /// Start press animation
  Future<void> startPressAnimation() async {
    final controller = getManagedController('press');
    if (controller != null) {
      await controller.forward();
    }
  }

  /// Release press animation
  Future<void> releasePressAnimation() async {
    final controller = getManagedController('press');
    if (controller != null) {
      await controller.reverse();
    }
  }

  /// Start ripple animation
  Future<void> startRippleAnimation() async {
    final controller = getManagedController('ripple');
    if (controller != null) {
      controller.reset();
      await controller.forward();
    }
  }

  /// Build micro-interaction animated widget
  Widget buildMicroInteractionWidget({
    required Widget child,
    required VoidCallback? onTap,
    bool enablePress = true,
    bool enableRipple = true,
  }) {
    Widget animatedChild = child;

    // Apply press animations
    if (enablePress) {
      animatedChild = AnimatedBuilder(
        animation: Listenable.merge([pressScaleAnimation, pressOpacityAnimation]),
        builder: (context, child) => Transform.scale(
          scale: pressScaleAnimation.value,
          child: Opacity(
            opacity: pressOpacityAnimation.value,
            child: child,
          ),
        ),
        child: animatedChild,
      );
    }

    // Apply ripple effect
    if (enableRipple) {
      animatedChild = Stack(
        children: [
          animatedChild,
          Positioned.fill(
            child: AnimatedBuilder(
              animation: rippleAnimation,
              builder: (context, child) => Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    (1.0 - rippleAnimation.value) * 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTapDown: enablePress ? (_) => startPressAnimation() : null,
      onTapUp: enablePress ? (_) {
        releasePressAnimation();
        if (enableRipple) startRippleAnimation();
        onTap?.call();
      } : null,
      onTapCancel: enablePress ? () => releasePressAnimation() : null,
      onTap: (!enablePress && !enableRipple) ? onTap : null,
      child: animatedChild,
    );
  }
}

/// Mixin for staggered list animations
/// 
/// Provides coordinated animations for lists with staggered timing
/// for smooth, professional list entrance effects.
mixin StaggeredAnimationMixin<T extends StatefulWidget>
    on State<T>, AnimationControllerManagerMixin<T> {

  /// List of staggered animations
  final List<Animation<double>> _staggeredAnimations = [];

  /// List of staggered slide animations
  final List<Animation<Offset>> _staggeredSlideAnimations = [];

  /// Initialize staggered animations for a list
  void initializeStaggeredAnimations({
    required int itemCount,
    Duration itemDuration = AnimationConstants.standardDuration,
    Duration staggerDelay = AnimationConstants.staggerDelay,
    Curve curve = AnimationCurves.gentleSpring,
  }) {
    _staggeredAnimations.clear();
    _staggeredSlideAnimations.clear();

    final totalDuration = itemDuration + (staggerDelay * itemCount);

    final controller = createManagedController(
      id: 'staggered',
      duration: totalDuration,
      debugLabel: 'StaggeredAnimation',
    );

    for (int i = 0; i < itemCount; i++) {
      final startTime = (staggerDelay.inMilliseconds * i) / totalDuration.inMilliseconds;
      final endTime = ((staggerDelay.inMilliseconds * i) + itemDuration.inMilliseconds) / totalDuration.inMilliseconds;

      // Fade animation
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(startTime, endTime.clamp(0.0, 1.0), curve: curve),
      ));
      _staggeredAnimations.add(fadeAnimation);

      // Slide animation
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(startTime, endTime.clamp(0.0, 1.0), curve: curve),
      ));
      _staggeredSlideAnimations.add(slideAnimation);
    }
  }

  /// Start staggered animation
  Future<void> startStaggeredAnimation() async {
    final controller = getManagedController('staggered');
    if (controller != null) {
      await controller.forward();
    }
  }

  /// Reverse staggered animation
  Future<void> reverseStaggeredAnimation() async {
    final controller = getManagedController('staggered');
    if (controller != null) {
      await controller.reverse();
    }
  }

  /// Build staggered list item
  Widget buildStaggeredListItem({
    required int index,
    required Widget child,
  }) {
    if (index >= _staggeredAnimations.length) {
      return child;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _staggeredAnimations[index],
        _staggeredSlideAnimations[index],
      ]),
      builder: (context, animatedChild) => SlideTransition(
        position: _staggeredSlideAnimations[index],
        child: FadeTransition(
          opacity: _staggeredAnimations[index],
          child: animatedChild,
        ),
      ),
      child: child,
    );
  }
}

/// Mixin for loading animations
/// 
/// Provides loading states with spinning, pulsing, and breathing animations
/// for better user feedback during async operations.
mixin LoadingAnimationMixin<T extends StatefulWidget>
    on State<T>, AnimationControllerManagerMixin<T> {

  /// Rotation animation for spinners
  late final Animation<double> rotationAnimation;

  /// Pulse animation for breathing effects
  late final Animation<double> pulseAnimation;

  /// Wave animation for progress indicators
  late final Animation<double> waveAnimation;

  /// Initialize loading animations
  void initializeLoadingAnimations() {
    // Rotation animation (continuous)
    final rotationController = createManagedController(
      id: 'rotation',
      duration: const Duration(milliseconds: 1500),
      debugLabel: 'RotationAnimation',
    );

    rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(rotationController);

    // Pulse animation (repeating)
    final pulseController = createManagedController(
      id: 'pulse',
      duration: const Duration(milliseconds: 1200),
      debugLabel: 'PulseAnimation',
    );

    pulseAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: pulseController,
      curve: Curves.easeInOut,
    ));

    // Wave animation (continuous)
    final waveController = createManagedController(
      id: 'wave',
      duration: const Duration(milliseconds: 2000),
      debugLabel: 'WaveAnimation',
    );

    waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(waveController);
  }

  /// Start loading animations
  void startLoadingAnimations() {
    getManagedController('rotation')?.repeat();
    getManagedController('pulse')?.repeat(reverse: true);
    getManagedController('wave')?.repeat();
  }

  /// Stop loading animations
  void stopLoadingAnimations() {
    getManagedController('rotation')?.stop();
    getManagedController('pulse')?.stop();
    getManagedController('wave')?.stop();
  }

  /// Build rotating loading widget
  Widget buildRotatingLoader({
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: rotationAnimation,
      builder: (context, animatedChild) => Transform.rotate(
        angle: rotationAnimation.value * 2 * 3.14159,
        child: animatedChild,
      ),
      child: child,
    );
  }

  /// Build pulsing loading widget
  Widget buildPulsingLoader({
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, animatedChild) => Transform.scale(
        scale: pulseAnimation.value,
        child: Opacity(
          opacity: pulseAnimation.value,
          child: animatedChild,
        ),
      ),
      child: child,
    );
  }

  /// Build wave loading indicator
  Widget buildWaveLoader({
    required Color color,
    int barCount = 5,
    double barWidth = 4.0,
    double barHeight = 20.0,
  }) {
    return AnimatedBuilder(
      animation: waveAnimation,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(barCount, (index) {
          final delay = index / barCount;
          final animationValue = (waveAnimation.value - delay).clamp(0.0, 1.0);
          final height = barHeight * (0.3 + 0.7 * (1.0 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0));
          
          return Container(
            margin: EdgeInsets.symmetric(horizontal: barWidth / 4),
            width: barWidth,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(barWidth / 2),
            ),
          );
        }),
      ),
    );
  }
}

/// Mixin for hero animations
/// 
/// Provides hero animation patterns for smooth transitions
/// between screens with shared elements.
mixin HeroAnimationMixin<T extends StatefulWidget>
    on State<T>, AnimationControllerManagerMixin<T> {

  /// Hero fade animation
  late final Animation<double> heroFadeAnimation;

  /// Hero scale animation
  late final Animation<double> heroScaleAnimation;

  /// Initialize hero animations
  void initializeHeroAnimations({
    Duration duration = AnimationConstants.standardDuration,
  }) {
    final controller = createManagedController(
      id: 'hero',
      duration: duration,
      debugLabel: 'HeroAnimation',
    );

    heroFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    heroScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.3, 1.0, curve: AnimationCurves.gentleSpring),
    ));
  }

  /// Start hero animation
  Future<void> startHeroAnimation() async {
    final controller = getManagedController('hero');
    if (controller != null) {
      await controller.forward();
    }
  }

  /// Build hero animated widget
  Widget buildHeroAnimatedWidget({
    required String tag,
    required Widget child,
  }) {
    return Hero(
      tag: tag,
      child: AnimatedBuilder(
        animation: Listenable.merge([heroFadeAnimation, heroScaleAnimation]),
        builder: (context, animatedChild) => FadeTransition(
          opacity: heroFadeAnimation,
          child: Transform.scale(
            scale: heroScaleAnimation.value,
            child: animatedChild,
          ),
        ),
        child: child,
      ),
    );
  }
}