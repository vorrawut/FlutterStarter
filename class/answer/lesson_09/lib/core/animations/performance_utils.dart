/// Performance monitoring utilities for animations
/// 
/// This file provides tools for monitoring animation performance,
/// detecting memory leaks, and optimizing animation behavior.
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../constants/animation_constants.dart';

/// Animation performance monitoring system
/// 
/// Tracks animation performance metrics including frame rates,
/// memory usage, and timing statistics for optimization.
class AnimationPerformanceMonitor {
  /// Creates a performance monitor
  AnimationPerformanceMonitor();

  /// Animation event records
  final List<AnimationEvent> _events = [];

  /// Frame timing records
  final List<FrameTiming> _frameTimings = [];

  /// Performance metrics cache
  AnimationPerformanceData? _cachedMetrics;

  /// Cache invalidation flag
  bool _metricsInvalid = true;

  /// Maximum number of events to keep in memory
  static const int maxEventHistory = 1000;

  /// Maximum number of frame timings to keep
  static const int maxFrameHistory = 500;

  /// Record an animation event
  /// 
  /// Captures animation lifecycle events for performance analysis.
  void recordAnimationEvent(
    String animationId,
    AnimationStatus status,
    Duration duration,
  ) {
    final event = AnimationEvent(
      animationId: animationId,
      status: status,
      timestamp: DateTime.now(),
      duration: duration,
    );

    _events.add(event);
    _metricsInvalid = true;

    // Trim history if too large
    if (_events.length > maxEventHistory) {
      _events.removeRange(0, _events.length - maxEventHistory);
    }

    // Log performance warnings
    _checkPerformanceWarnings(event);
  }

  /// Record frame timing information
  /// 
  /// Captures frame rendering performance for animation optimization.
  void recordFrameTiming(Duration frameDuration) {
    final timing = FrameTiming(
      duration: frameDuration,
      timestamp: DateTime.now(),
    );

    _frameTimings.add(timing);
    _metricsInvalid = true;

    // Trim history if too large
    if (_frameTimings.length > maxFrameHistory) {
      _frameTimings.removeRange(0, _frameTimings.length - maxFrameHistory);
    }
  }

  /// Get comprehensive performance metrics
  /// 
  /// Returns analyzed performance data for optimization insights.
  AnimationPerformanceData getMetrics() {
    if (!_metricsInvalid && _cachedMetrics != null) {
      return _cachedMetrics!;
    }

    _cachedMetrics = _calculateMetrics();
    _metricsInvalid = false;
    return _cachedMetrics!;
  }

  /// Clear all performance data
  /// 
  /// Resets all recorded events and timings.
  void clearMetrics() {
    _events.clear();
    _frameTimings.clear();
    _cachedMetrics = null;
    _metricsInvalid = true;
  }

  /// Calculate performance metrics from recorded data
  AnimationPerformanceData _calculateMetrics() {
    // Animation statistics
    final totalAnimations = _events.where((e) => e.status == AnimationStatus.completed).length;
    final runningAnimations = _events.where((e) => e.status == AnimationStatus.forward).length;
    
    // Duration statistics
    final durations = _events
        .where((e) => e.status == AnimationStatus.completed)
        .map((e) => e.duration.inMilliseconds)
        .toList();
    
    final avgDuration = durations.isEmpty 
        ? 0.0 
        : durations.reduce((a, b) => a + b) / durations.length;
    
    // Frame rate statistics
    final frameDurations = _frameTimings.map((t) => t.duration.inMicroseconds).toList();
    final avgFrameTime = frameDurations.isEmpty
        ? 0.0
        : frameDurations.reduce((a, b) => a + b) / frameDurations.length;
    
    final estimatedFPS = avgFrameTime > 0 ? 1000000 / avgFrameTime : 0.0;
    
    // Performance warnings
    final warnings = _generateWarnings();

    return AnimationPerformanceData(
      totalAnimations: totalAnimations,
      runningAnimations: runningAnimations,
      averageDuration: Duration(milliseconds: avgDuration.round()),
      averageFrameTime: Duration(microseconds: avgFrameTime.round()),
      estimatedFPS: estimatedFPS,
      droppedFrames: _countDroppedFrames(),
      memoryEvents: _events.length,
      warnings: warnings,
    );
  }

  /// Count dropped frames based on frame timing
  int _countDroppedFrames() {
    return _frameTimings
        .where((timing) => timing.duration.inMicroseconds > AnimationConstants.frameBudget * 1000)
        .length;
  }

  /// Generate performance warnings
  List<String> _generateWarnings() {
    final warnings = <String>[];
    final metrics = _calculateMetrics();

    // Check for dropped frames
    if (metrics.droppedFrames > 0) {
      warnings.add('${metrics.droppedFrames} dropped frames detected');
    }

    // Check for low frame rate
    if (metrics.estimatedFPS < 50) {
      warnings.add('Low frame rate detected: ${metrics.estimatedFPS.toStringAsFixed(1)} FPS');
    }

    // Check for too many concurrent animations
    if (metrics.runningAnimations > AnimationConstants.maxConcurrentAnimations) {
      warnings.add('Too many concurrent animations: ${metrics.runningAnimations}');
    }

    // Check for memory usage
    if (metrics.memoryEvents > maxEventHistory * 0.8) {
      warnings.add('High memory usage: ${metrics.memoryEvents} events in memory');
    }

    return warnings;
  }

  /// Check for immediate performance warnings
  void _checkPerformanceWarnings(AnimationEvent event) {
    // Check for long animation durations
    if (event.duration > AnimationConstants.maxAnimationDuration) {
      debugPrint('Warning: Long animation duration: ${event.duration}');
    }

    // Check for rapid animation starts
    final recentStarts = _events
        .where((e) => 
            e.status == AnimationStatus.forward &&
            DateTime.now().difference(e.timestamp).inMilliseconds < 100)
        .length;
    
    if (recentStarts > 5) {
      debugPrint('Warning: Many animations started rapidly: $recentStarts');
    }
  }

  /// Dispose the monitor
  void dispose() {
    clearMetrics();
  }
}

/// Animation event data class
/// 
/// Represents a single animation lifecycle event for performance tracking.
class AnimationEvent {
  /// Creates an animation event
  const AnimationEvent({
    required this.animationId,
    required this.status,
    required this.timestamp,
    required this.duration,
  });

  /// Unique identifier for the animation
  final String animationId;

  /// Animation status at time of event
  final AnimationStatus status;

  /// When the event occurred
  final DateTime timestamp;

  /// Duration of the animation
  final Duration duration;

  @override
  String toString() {
    return 'AnimationEvent(id: $animationId, status: $status, time: $timestamp)';
  }
}

/// Frame timing data class
/// 
/// Represents timing information for a single frame render.
class FrameTiming {
  /// Creates frame timing data
  const FrameTiming({
    required this.duration,
    required this.timestamp,
  });

  /// Duration to render the frame
  final Duration duration;

  /// When the frame was rendered
  final DateTime timestamp;

  /// Whether this frame was dropped (exceeded budget)
  bool get isDropped => duration.inMicroseconds > AnimationConstants.frameBudget * 1000;

  @override
  String toString() {
    return 'FrameTiming(duration: $duration, dropped: $isDropped)';
  }
}

/// Comprehensive animation performance data
/// 
/// Contains analyzed performance metrics for optimization insights.
class AnimationPerformanceData {
  /// Creates performance data
  const AnimationPerformanceData({
    required this.totalAnimations,
    required this.runningAnimations,
    required this.averageDuration,
    required this.averageFrameTime,
    required this.estimatedFPS,
    required this.droppedFrames,
    required this.memoryEvents,
    required this.warnings,
  });

  /// Total number of completed animations
  final int totalAnimations;

  /// Number of currently running animations
  final int runningAnimations;

  /// Average animation duration
  final Duration averageDuration;

  /// Average frame rendering time
  final Duration averageFrameTime;

  /// Estimated frames per second
  final double estimatedFPS;

  /// Number of dropped frames
  final int droppedFrames;

  /// Number of events in memory
  final int memoryEvents;

  /// Performance warnings
  final List<String> warnings;

  /// Whether performance is acceptable
  bool get isPerformanceGood {
    return estimatedFPS >= 50 && 
           droppedFrames == 0 && 
           runningAnimations <= AnimationConstants.maxConcurrentAnimations;
  }

  /// Performance score (0-100)
  double get performanceScore {
    double score = 100.0;
    
    // Deduct for low FPS
    if (estimatedFPS < 60) {
      score -= (60 - estimatedFPS) * 2;
    }
    
    // Deduct for dropped frames
    score -= droppedFrames * 5;
    
    // Deduct for too many concurrent animations
    if (runningAnimations > AnimationConstants.maxConcurrentAnimations) {
      score -= (runningAnimations - AnimationConstants.maxConcurrentAnimations) * 10;
    }
    
    return score.clamp(0.0, 100.0);
  }

  @override
  String toString() {
    return 'AnimationPerformanceData(\n'
        '  totalAnimations: $totalAnimations,\n'
        '  runningAnimations: $runningAnimations,\n'
        '  averageDuration: $averageDuration,\n'
        '  estimatedFPS: ${estimatedFPS.toStringAsFixed(1)},\n'
        '  droppedFrames: $droppedFrames,\n'
        '  performanceScore: ${performanceScore.toStringAsFixed(1)},\n'
        '  warnings: ${warnings.length}\n'
        ')';
  }
}

/// Performance monitoring mixin for widgets
/// 
/// Provides automatic frame timing monitoring for animation-heavy widgets.
mixin PerformanceMonitoringMixin<T extends StatefulWidget> on State<T> {
  /// Performance monitor instance
  final AnimationPerformanceMonitor _monitor = AnimationPerformanceMonitor();

  /// Frame callback for timing measurement
  FrameCallback? _frameCallback;

  @override
  void initState() {
    super.initState();
    _startFrameMonitoring();
  }

  @override
  void dispose() {
    _stopFrameMonitoring();
    _monitor.dispose();
    super.dispose();
  }

  /// Start monitoring frame timings
  void _startFrameMonitoring() {
    _frameCallback = (timeStamp) {
      final frameDuration = Duration(microseconds: timeStamp.inMicroseconds);
      _monitor.recordFrameTiming(frameDuration);
      
      // Schedule next frame callback
      SchedulerBinding.instance.addPostFrameCallback(_frameCallback!);
    };
    
    SchedulerBinding.instance.addPostFrameCallback(_frameCallback!);
  }

  /// Stop monitoring frame timings
  void _stopFrameMonitoring() {
    _frameCallback = null;
  }

  /// Get performance metrics
  AnimationPerformanceData get performanceMetrics => _monitor.getMetrics();

  /// Record animation event
  void recordAnimationEvent(String id, AnimationStatus status, Duration duration) {
    _monitor.recordAnimationEvent(id, status, duration);
  }

  /// Clear performance metrics
  void clearPerformanceMetrics() {
    _monitor.clearMetrics();
  }
}

/// Performance monitoring widget
/// 
/// Wraps child widgets with automatic performance monitoring capabilities.
class PerformanceMonitoredWidget extends StatefulWidget {
  /// Creates a performance monitored widget
  const PerformanceMonitoredWidget({
    super.key,
    required this.child,
    this.onPerformanceUpdate,
    this.monitoringEnabled = true,
  });

  /// Child widget to monitor
  final Widget child;

  /// Callback for performance updates
  final void Function(AnimationPerformanceData data)? onPerformanceUpdate;

  /// Whether monitoring is enabled
  final bool monitoringEnabled;

  @override
  State<PerformanceMonitoredWidget> createState() => _PerformanceMonitoredWidgetState();
}

class _PerformanceMonitoredWidgetState extends State<PerformanceMonitoredWidget>
    with PerformanceMonitoringMixin {

  @override
  void initState() {
    super.initState();
    
    if (widget.monitoringEnabled) {
      // Periodic performance updates
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted && widget.onPerformanceUpdate != null) {
          widget.onPerformanceUpdate!(performanceMetrics);
        }
        return mounted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}