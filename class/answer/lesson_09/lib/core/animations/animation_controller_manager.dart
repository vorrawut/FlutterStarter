/// Animation controller lifecycle management
/// 
/// This file provides a centralized system for managing animation controllers,
/// ensuring proper disposal, performance monitoring, and memory management.
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../constants/animation_constants.dart';
import 'performance_utils.dart';

/// Manages animation controller lifecycle and performance
/// 
/// Provides centralized management of animation controllers with automatic
/// disposal, performance monitoring, and memory leak prevention.
class AnimationControllerManager {
  /// Creates an animation controller manager
  AnimationControllerManager({
    required this.vsync,
  });

  /// Ticker provider for animation controllers
  final TickerProvider vsync;

  /// Map of active animation controllers
  final Map<String, AnimationController> _controllers = {};

  /// Performance monitor
  final AnimationPerformanceMonitor _performanceMonitor = AnimationPerformanceMonitor();

  /// Disposed state flag
  bool _disposed = false;

  /// Get all active controller names
  List<String> get activeControllers => _controllers.keys.toList();

  /// Get the number of active controllers
  int get activeControllerCount => _controllers.length;

  /// Check if manager is disposed
  bool get isDisposed => _disposed;

  /// Create a new animation controller with automatic management
  /// 
  /// [id] - Unique identifier for the controller
  /// [duration] - Animation duration
  /// [reverseDuration] - Optional reverse duration
  /// [debugLabel] - Debug label for performance monitoring
  /// [lowerBound] - Lower bound for animation value (default: 0.0)
  /// [upperBound] - Upper bound for animation value (default: 1.0)
  AnimationController createController({
    required String id,
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    if (_disposed) {
      throw StateError('Cannot create controller on disposed manager');
    }

    // Dispose existing controller with same ID
    disposeController(id);

    // Validate duration for performance
    if (duration > AnimationConstants.maxAnimationDuration) {
      debugPrint('Warning: Animation duration $duration exceeds recommended maximum');
    }

    // Create new controller
    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel ?? id,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: vsync,
    );

    // Add performance monitoring
    controller.addStatusListener((status) {
      _performanceMonitor.recordAnimationEvent(
        id,
        status,
        duration,
      );
    });

    // Store controller
    _controllers[id] = controller;

    // Monitor for memory leaks
    _checkControllerCount();

    return controller;
  }

  /// Get an existing animation controller
  /// 
  /// Returns null if controller with [id] doesn't exist.
  AnimationController? getController(String id) {
    return _controllers[id];
  }

  /// Get an existing controller or create a new one
  /// 
  /// Convenience method that gets existing controller or creates new one
  /// if it doesn't exist.
  AnimationController getOrCreateController({
    required String id,
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    return getController(id) ?? createController(
      id: id,
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
    );
  }

  /// Dispose a specific animation controller
  /// 
  /// Properly disposes the controller and removes it from management.
  void disposeController(String id) {
    final controller = _controllers.remove(id);
    controller?.dispose();
  }

  /// Dispose all animation controllers
  /// 
  /// Disposes all managed controllers and clears the internal map.
  void disposeAllControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  /// Reset a specific controller to its initial state
  /// 
  /// Resets the controller value and stops any running animation.
  void resetController(String id) {
    final controller = _controllers[id];
    if (controller != null) {
      controller.reset();
    }
  }

  /// Reset all controllers to their initial state
  /// 
  /// Resets all managed controllers to their initial values.
  void resetAllControllers() {
    for (final controller in _controllers.values) {
      controller.reset();
    }
  }

  /// Stop all running animations
  /// 
  /// Stops all controllers without resetting their values.
  void stopAllAnimations() {
    for (final controller in _controllers.values) {
      controller.stop();
    }
  }

  /// Forward all controllers
  /// 
  /// Starts forward animation on all managed controllers.
  Future<void> forwardAllControllers() async {
    final futures = _controllers.values.map((controller) => controller.forward());
    await Future.wait(futures);
  }

  /// Reverse all controllers
  /// 
  /// Starts reverse animation on all managed controllers.
  Future<void> reverseAllControllers() async {
    final futures = _controllers.values.map((controller) => controller.reverse());
    await Future.wait(futures);
  }

  /// Create a staggered animation sequence
  /// 
  /// Creates multiple controllers with staggered timing for coordinated animations.
  List<AnimationController> createStaggeredControllers({
    required String baseId,
    required int count,
    required Duration duration,
    required Duration staggerDelay,
    String? debugLabel,
  }) {
    final controllers = <AnimationController>[];

    for (int i = 0; i < count; i++) {
      final controller = createController(
        id: '${baseId}_$i',
        duration: duration,
        debugLabel: '${debugLabel ?? baseId}_$i',
      );
      controllers.add(controller);
    }

    return controllers;
  }

  /// Start staggered animation sequence
  /// 
  /// Starts animations with staggered timing for smooth sequences.
  Future<void> startStaggeredAnimation({
    required List<String> controllerIds,
    required Duration staggerDelay,
    bool reverse = false,
  }) async {
    for (int i = 0; i < controllerIds.length; i++) {
      final controller = getController(controllerIds[i]);
      if (controller != null) {
        // Start animation with delay
        Future.delayed(staggerDelay * i, () {
          if (reverse) {
            controller.reverse();
          } else {
            controller.forward();
          }
        });
      }
    }
  }

  /// Get performance metrics for all controllers
  /// 
  /// Returns performance data for monitoring and optimization.
  AnimationPerformanceData getPerformanceMetrics() {
    return _performanceMonitor.getMetrics();
  }

  /// Clear performance metrics
  /// 
  /// Resets all performance tracking data.
  void clearPerformanceMetrics() {
    _performanceMonitor.clearMetrics();
  }

  /// Check if any controllers are currently running
  /// 
  /// Returns true if any managed controller is currently animating.
  bool get hasRunningAnimations {
    return _controllers.values.any((controller) => controller.isAnimating);
  }

  /// Get list of currently running controller IDs
  /// 
  /// Returns IDs of controllers that are currently animating.
  List<String> get runningControllerIds {
    return _controllers.entries
        .where((entry) => entry.value.isAnimating)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get list of completed controller IDs
  /// 
  /// Returns IDs of controllers that have completed their animation.
  List<String> get completedControllerIds {
    return _controllers.entries
        .where((entry) => entry.value.status == AnimationStatus.completed)
        .map((entry) => entry.key)
        .toList();
  }

  /// Check controller count for memory leaks
  /// 
  /// Warns if too many controllers are active simultaneously.
  void _checkControllerCount() {
    if (_controllers.length > AnimationConstants.maxConcurrentAnimations) {
      debugPrint(
        'Warning: ${_controllers.length} animation controllers active. '
        'Consider disposing unused controllers to prevent memory leaks.',
      );
    }
  }

  /// Dispose the manager and all controllers
  /// 
  /// Disposes all managed controllers and marks manager as disposed.
  void dispose() {
    if (_disposed) return;

    disposeAllControllers();
    _performanceMonitor.dispose();
    _disposed = true;
  }

  @override
  String toString() {
    return 'AnimationControllerManager('
        'active: ${_controllers.length}, '
        'running: ${runningControllerIds.length}, '
        'disposed: $_disposed'
        ')';
  }
}

/// Mixin for automatic animation controller management
/// 
/// Provides automatic setup and disposal of animation controller manager
/// for StatefulWidget classes.
mixin AnimationControllerManagerMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  
  /// Animation controller manager instance
  late final AnimationControllerManager animationManager;

  @override
  void initState() {
    super.initState();
    animationManager = AnimationControllerManager(vsync: this);
  }

  @override
  void dispose() {
    animationManager.dispose();
    super.dispose();
  }

  /// Create a managed animation controller
  /// 
  /// Convenience method for creating controllers with automatic management.
  AnimationController createManagedController({
    required String id,
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    return animationManager.createController(
      id: id,
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
    );
  }

  /// Get a managed controller by ID
  AnimationController? getManagedController(String id) {
    return animationManager.getController(id);
  }

  /// Dispose a managed controller by ID
  void disposeManagedController(String id) {
    animationManager.disposeController(id);
  }
}