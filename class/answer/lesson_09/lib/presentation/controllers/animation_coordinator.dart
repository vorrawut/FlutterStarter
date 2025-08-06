/// Animation coordinator for complex animation sequences
/// 
/// This file provides centralized coordination of complex animation sequences,
/// managing timing, dependencies, and orchestration of multiple animations.
library;

import 'package:flutter/material.dart';
import '../../core/animations/animation_controller_manager.dart';
import '../../core/animations/custom_curves.dart';
import '../../core/constants/animation_constants.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/entities/animation_config.dart';
import '../../domain/repositories/onboarding_repository.dart';

/// Coordinates complex animation sequences for onboarding
/// 
/// Manages the orchestration of multiple animations, timing coordination,
/// and provides high-level animation control for the onboarding experience.
class AnimationCoordinator extends ChangeNotifier {
  /// Creates an animation coordinator
  AnimationCoordinator();

  /// Animation controller manager for lifecycle management
  AnimationControllerManager? _controllerManager;

  /// Current animation state
  AnimationState _currentState = AnimationState.idle;

  /// User preferences affecting animations
  OnboardingPreferences _preferences = const OnboardingPreferences();

  /// Currently playing animation sequence
  String? _currentSequence;

  /// Animation performance tracking
  final List<AnimationPerformanceMetric> _performanceMetrics = [];

  // Getters

  /// Current animation state
  AnimationState get currentState => _currentState;

  /// User preferences
  OnboardingPreferences get preferences => _preferences;

  /// Currently playing animation sequence
  String? get currentSequence => _currentSequence;

  /// Whether animations are currently playing
  bool get isAnimating => _currentState == AnimationState.playing;

  /// Whether animations are paused
  bool get isPaused => _currentState == AnimationState.paused;

  /// Whether animations are idle
  bool get isIdle => _currentState == AnimationState.idle;

  /// Performance metrics
  List<AnimationPerformanceMetric> get performanceMetrics => List.unmodifiable(_performanceMetrics);

  /// Initialize the animation coordinator
  /// 
  /// Sets up the controller manager and prepares for animation coordination.
  Future<void> initialize() async {
    // Controller manager will be provided by the parent widget
    // with proper TickerProvider context
  }

  /// Set the animation controller manager
  /// 
  /// Called by parent widgets to provide the controller manager
  /// with proper TickerProvider context.
  void setControllerManager(AnimationControllerManager manager) {
    _controllerManager?.dispose();
    _controllerManager = manager;
  }

  /// Update user preferences
  /// 
  /// Applies user preferences to animation behavior including
  /// reduced motion and animation speed adjustments.
  void updatePreferences(OnboardingPreferences preferences) {
    _preferences = preferences;
    notifyListeners();
  }

  /// Play entrance animation for a page
  /// 
  /// Orchestrates the entrance animation sequence for all elements
  /// on the given onboarding page.
  Future<void> playEntranceAnimation(OnboardingPage page) async {
    if (_controllerManager == null) return;

    try {
      _currentState = AnimationState.playing;
      _currentSequence = 'entrance_${page.id}';
      notifyListeners();

      final startTime = DateTime.now();

      // Get animation configuration
      final animConfig = page.animationConfig;
      
      // Apply user preferences
      final effectiveConfig = _applyPreferences(animConfig);

      // Play entrance sequence based on pattern
      switch (effectiveConfig.entrancePattern) {
        case EntrancePattern.dramatic:
          await _playDramaticEntrance(page, effectiveConfig);
          break;
        case EntrancePattern.elegant:
          await _playElegantEntrance(page, effectiveConfig);
          break;
        case EntrancePattern.staggered:
          await _playStaggeredEntrance(page, effectiveConfig);
          break;
        case EntrancePattern.playful:
          await _playPlayfulEntrance(page, effectiveConfig);
          break;
        case EntrancePattern.minimal:
          await _playMinimalEntrance(page, effectiveConfig);
          break;
        case EntrancePattern.custom:
          await _playCustomEntrance(page, effectiveConfig);
          break;
      }

      // Record performance metrics
      final duration = DateTime.now().difference(startTime);
      _recordPerformanceMetric(AnimationPerformanceMetric(
        sequenceName: _currentSequence!,
        duration: duration,
        elementCount: effectiveConfig.elementAnimations.length,
        patternType: effectiveConfig.entrancePattern.toString(),
        timestamp: startTime,
      ));

      _currentState = AnimationState.idle;
      _currentSequence = null;
      notifyListeners();

    } catch (error) {
      _currentState = AnimationState.error;
      _currentSequence = null;
      notifyListeners();
      rethrow;
    }
  }

  /// Play exit animation for current page
  /// 
  /// Orchestrates the exit animation sequence for the current page.
  Future<void> playExitAnimation() async {
    if (_controllerManager == null) return;

    try {
      _currentState = AnimationState.playing;
      _currentSequence = 'exit_transition';
      notifyListeners();

      // Create simple exit animation
      final controller = _controllerManager!.createController(
        id: 'exit_animation',
        duration: AnimationConstants.fastDuration,
      );

      await controller.reverse();

      _currentState = AnimationState.idle;
      _currentSequence = null;
      notifyListeners();

    } catch (error) {
      _currentState = AnimationState.error;
      _currentSequence = null;
      notifyListeners();
      rethrow;
    }
  }

  /// Play micro-interaction animation
  /// 
  /// Plays short feedback animations for button presses and interactions.
  Future<void> playMicroInteraction(String interactionType) async {
    if (_controllerManager == null || !_preferences.animationsEnabled) return;

    try {
      final controller = _controllerManager!.createController(
        id: 'micro_$interactionType',
        duration: AnimationConstants.microDuration,
      );

      await controller.forward();
      await controller.reverse();

    } catch (error) {
      // Micro-interactions should fail silently
      debugPrint('Micro-interaction animation failed: $error');
    }
  }

  /// Pause all animations
  /// 
  /// Pauses all currently playing animations.
  void pauseAnimations() {
    if (_currentState == AnimationState.playing) {
      _controllerManager?.stopAllAnimations();
      _currentState = AnimationState.paused;
      notifyListeners();
    }
  }

  /// Resume paused animations
  /// 
  /// Resumes all paused animations.
  void resumeAnimations() {
    if (_currentState == AnimationState.paused) {
      _currentState = AnimationState.playing;
      notifyListeners();
    }
  }

  /// Stop all animations
  /// 
  /// Immediately stops and resets all animations.
  void stopAllAnimations() {
    _controllerManager?.stopAllAnimations();
    _controllerManager?.resetAllControllers();
    _currentState = AnimationState.idle;
    _currentSequence = null;
    notifyListeners();
  }

  /// Apply user preferences to animation configuration
  OnboardingAnimationConfig _applyPreferences(OnboardingAnimationConfig config) {
    if (!_preferences.animationsEnabled) {
      return config.copyWith(
        elementAnimations: config.elementAnimations
            .map((elem) => elem.copyWith(
                  duration: Duration.zero,
                  curve: Curves.linear,
                ))
            .toList(),
      );
    }

    if (_preferences.reducedMotion) {
      return config.copyWith(
        pageTransitionDuration: Duration(
          milliseconds: (config.pageTransitionDuration.inMilliseconds * 0.5).round(),
        ),
        staggerDelay: Duration(
          milliseconds: (config.staggerDelay.inMilliseconds * 0.5).round(),
        ),
        elementAnimations: config.elementAnimations
            .map((elem) => elem.copyWith(
                  duration: Duration(
                    milliseconds: (elem.duration.inMilliseconds * 0.5).round(),
                  ),
                  startOffset: Offset(
                    elem.startOffset.dx * 0.5,
                    elem.startOffset.dy * 0.5,
                  ),
                  startScale: 1.0 + (elem.startScale - 1.0) * 0.5,
                  endScale: 1.0 + (elem.endScale - 1.0) * 0.5,
                ))
            .toList(),
      );
    }

    return config;
  }

  /// Play dramatic entrance animation sequence
  Future<void> _playDramaticEntrance(
    OnboardingPage page,
    OnboardingAnimationConfig config,
  ) async {
    // Create anticipation effect
    final anticipationController = _controllerManager!.createController(
      id: 'anticipation',
      duration: const Duration(milliseconds: 200),
    );

    // Build up tension
    await anticipationController.forward();

    // Main dramatic entrance
    final mainController = _controllerManager!.createController(
      id: 'dramatic_main',
      duration: config.pageTransitionDuration,
    );

    await mainController.forward();

    // Staggered element reveals
    await _playElementAnimations(config.elementAnimations, config.staggerDelay);
  }

  /// Play elegant entrance animation sequence
  Future<void> _playElegantEntrance(
    OnboardingPage page,
    OnboardingAnimationConfig config,
  ) async {
    // Smooth, coordinated entrance
    final mainController = _controllerManager!.createController(
      id: 'elegant_main',
      duration: config.pageTransitionDuration,
    );

    // Start main animation and element animations in parallel
    final futures = <Future>[
      mainController.forward(),
      _playElementAnimations(config.elementAnimations, config.staggerDelay),
    ];

    await Future.wait(futures);
  }

  /// Play staggered entrance animation sequence
  Future<void> _playStaggeredEntrance(
    OnboardingPage page,
    OnboardingAnimationConfig config,
  ) async {
    // Pure staggered sequence
    await _playElementAnimations(config.elementAnimations, config.staggerDelay);
  }

  /// Play playful entrance animation sequence
  Future<void> _playPlayfulEntrance(
    OnboardingPage page,
    OnboardingAnimationConfig config,
  ) async {
    // Bouncy, elastic entrance
    final bounceController = _controllerManager!.createController(
      id: 'playful_bounce',
      duration: config.pageTransitionDuration,
    );

    await bounceController.forward();

    // Overlapping playful element animations
    await _playElementAnimations(config.elementAnimations, 
                                 Duration(milliseconds: config.staggerDelay.inMilliseconds ~/ 2));
  }

  /// Play minimal entrance animation sequence
  Future<void> _playMinimalEntrance(
    OnboardingPage page,
    OnboardingAnimationConfig config,
  ) async {
    // Simple, fast entrance
    final simpleController = _controllerManager!.createController(
      id: 'minimal_simple',
      duration: AnimationConstants.fastDuration,
    );

    await simpleController.forward();

    // Quick element animations
    await _playElementAnimations(config.elementAnimations, 
                                 const Duration(milliseconds: 25));
  }

  /// Play custom entrance animation sequence
  Future<void> _playCustomEntrance(
    OnboardingPage page,
    OnboardingAnimationConfig config,
  ) async {
    // Custom implementation based on page-specific requirements
    await _playElementAnimations(config.elementAnimations, config.staggerDelay);
  }

  /// Play element animations with staggered timing
  Future<void> _playElementAnimations(
    List<ElementAnimationConfig> elementConfigs,
    Duration staggerDelay,
  ) async {
    final futures = <Future>[];

    for (int i = 0; i < elementConfigs.length; i++) {
      final config = elementConfigs[i];
      final delay = staggerDelay * i + config.delay;

      futures.add(
        Future.delayed(delay, () async {
          final controller = _controllerManager!.createController(
            id: 'element_${config.elementType.toString()}_$i',
            duration: config.duration,
          );

          await controller.forward();
        }),
      );
    }

    await Future.wait(futures);
  }

  /// Record performance metric
  void _recordPerformanceMetric(AnimationPerformanceMetric metric) {
    _performanceMetrics.add(metric);

    // Keep only recent metrics to prevent memory growth
    if (_performanceMetrics.length > 100) {
      _performanceMetrics.removeRange(0, _performanceMetrics.length - 100);
    }
  }

  /// Get performance summary
  AnimationPerformanceSummary getPerformanceSummary() {
    if (_performanceMetrics.isEmpty) {
      return AnimationPerformanceSummary.empty();
    }

    final totalDuration = _performanceMetrics
        .map((m) => m.duration.inMilliseconds)
        .reduce((a, b) => a + b);

    final averageDuration = totalDuration / _performanceMetrics.length;

    final totalElements = _performanceMetrics
        .map((m) => m.elementCount)
        .reduce((a, b) => a + b);

    return AnimationPerformanceSummary(
      totalSequences: _performanceMetrics.length,
      averageDuration: Duration(milliseconds: averageDuration.round()),
      totalElements: totalElements,
      longestSequence: _performanceMetrics
          .reduce((a, b) => a.duration > b.duration ? a : b),
      shortestSequence: _performanceMetrics
          .reduce((a, b) => a.duration < b.duration ? a : b),
    );
  }

  /// Clear performance metrics
  void clearPerformanceMetrics() {
    _performanceMetrics.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _controllerManager?.dispose();
    super.dispose();
  }
}

/// Animation state enumeration
enum AnimationState {
  /// No animations playing
  idle,

  /// Animations currently playing
  playing,

  /// Animations are paused
  paused,

  /// Animation error occurred
  error,
}

/// Animation performance metric
class AnimationPerformanceMetric {
  const AnimationPerformanceMetric({
    required this.sequenceName,
    required this.duration,
    required this.elementCount,
    required this.patternType,
    required this.timestamp,
  });

  final String sequenceName;
  final Duration duration;
  final int elementCount;
  final String patternType;
  final DateTime timestamp;

  @override
  String toString() {
    return 'AnimationPerformanceMetric('
        'sequence: $sequenceName, '
        'duration: ${duration.inMilliseconds}ms, '
        'elements: $elementCount'
        ')';
  }
}

/// Animation performance summary
class AnimationPerformanceSummary {
  const AnimationPerformanceSummary({
    required this.totalSequences,
    required this.averageDuration,
    required this.totalElements,
    required this.longestSequence,
    required this.shortestSequence,
  });

  factory AnimationPerformanceSummary.empty() {
    return AnimationPerformanceSummary(
      totalSequences: 0,
      averageDuration: Duration.zero,
      totalElements: 0,
      longestSequence: AnimationPerformanceMetric(
        sequenceName: '',
        duration: Duration.zero,
        elementCount: 0,
        patternType: '',
        timestamp: DateTime.now(),
      ),
      shortestSequence: AnimationPerformanceMetric(
        sequenceName: '',
        duration: Duration.zero,
        elementCount: 0,
        patternType: '',
        timestamp: DateTime.now(),
      ),
    );
  }

  final int totalSequences;
  final Duration averageDuration;
  final int totalElements;
  final AnimationPerformanceMetric longestSequence;
  final AnimationPerformanceMetric shortestSequence;

  @override
  String toString() {
    return 'AnimationPerformanceSummary('
        'sequences: $totalSequences, '
        'avgDuration: ${averageDuration.inMilliseconds}ms, '
        'elements: $totalElements'
        ')';
  }
}