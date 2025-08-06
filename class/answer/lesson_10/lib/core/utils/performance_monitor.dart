/// Performance monitoring utility for setState operations
/// 
/// This file provides comprehensive performance monitoring for setState
/// operations, build times, and widget performance optimization.
library;

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Performance metric types
enum MetricType {
  setState('setState'),
  build('build'),
  layout('layout'),
  paint('paint'),
  frameRender('frameRender');

  const MetricType(this.label);

  /// Display label for the metric type
  final String label;
}

/// Performance measurement data
@immutable
class PerformanceMeasurement {
  /// Creates a performance measurement
  const PerformanceMeasurement({
    required this.metricType,
    required this.widgetName,
    required this.duration,
    required this.timestamp,
    this.details,
    this.memoryUsage,
  });

  /// Type of performance metric
  final MetricType metricType;

  /// Name of the widget being measured
  final String widgetName;

  /// Duration of the operation
  final Duration duration;

  /// When the measurement was taken
  final DateTime timestamp;

  /// Optional details about the measurement
  final String? details;

  /// Memory usage during the operation (if available)
  final int? memoryUsage;

  /// Whether this measurement indicates a performance issue
  bool get isSlowOperation {
    switch (metricType) {
      case MetricType.setState:
        return duration.inMicroseconds > 1000; // > 1ms
      case MetricType.build:
        return duration.inMicroseconds > 5000; // > 5ms
      case MetricType.layout:
        return duration.inMicroseconds > 2000; // > 2ms
      case MetricType.paint:
        return duration.inMicroseconds > 3000; // > 3ms
      case MetricType.frameRender:
        return duration.inMicroseconds > 16666; // > 16.67ms (60fps)
    }
  }

  /// Get performance grade (A-F)
  String get performanceGrade {
    final microseconds = duration.inMicroseconds;
    
    switch (metricType) {
      case MetricType.setState:
        if (microseconds <= 100) return 'A';
        if (microseconds <= 500) return 'B';
        if (microseconds <= 1000) return 'C';
        if (microseconds <= 2000) return 'D';
        return 'F';
      
      case MetricType.build:
        if (microseconds <= 1000) return 'A';
        if (microseconds <= 3000) return 'B';
        if (microseconds <= 5000) return 'C';
        if (microseconds <= 8000) return 'D';
        return 'F';
      
      case MetricType.frameRender:
        if (microseconds <= 13333) return 'A'; // < 13.33ms (75fps)
        if (microseconds <= 16666) return 'B'; // < 16.67ms (60fps)
        if (microseconds <= 20000) return 'C'; // < 20ms (50fps)
        if (microseconds <= 33333) return 'D'; // < 33.33ms (30fps)
        return 'F';
      
      default:
        if (microseconds <= 1000) return 'A';
        if (microseconds <= 2000) return 'B';
        if (microseconds <= 4000) return 'C';
        if (microseconds <= 8000) return 'D';
        return 'F';
    }
  }

  @override
  String toString() {
    return 'PerformanceMeasurement('
        'type: ${metricType.label}, '
        'widget: $widgetName, '
        'duration: ${duration.inMicroseconds}μs, '
        'grade: $performanceGrade'
        ')';
  }
}

/// Performance monitoring and optimization utility
/// 
/// Provides comprehensive performance tracking for Flutter widgets
/// with real-time monitoring, optimization suggestions, and reporting.
class PerformanceMonitor {
  /// Creates a performance monitor
  PerformanceMonitor({
    this.maxMeasurements = 1000,
    this.enableFrameMonitoring = true,
    this.enableMemoryTracking = false,
    this.enableConsoleWarnings = true,
  });

  /// Maximum number of measurements to keep
  final int maxMeasurements;

  /// Whether to monitor frame rendering performance
  final bool enableFrameMonitoring;

  /// Whether to track memory usage
  final bool enableMemoryTracking;

  /// Whether to log performance warnings to console
  final bool enableConsoleWarnings;

  /// List of performance measurements
  final Queue<PerformanceMeasurement> _measurements = Queue<PerformanceMeasurement>();

  /// Active timing measurements
  final Map<String, DateTime> _activeTimings = {};

  /// Frame callback for monitoring
  FrameCallback? _frameCallback;

  /// Whether frame monitoring is active
  bool _frameMonitoringActive = false;

  /// Initialize performance monitoring
  void initialize() {
    if (enableFrameMonitoring && !_frameMonitoringActive) {
      _startFrameMonitoring();
    }
  }

  /// Start frame rendering monitoring
  void _startFrameMonitoring() {
    _frameMonitoringActive = true;
    
    _frameCallback = (timeStamp) {
      final frameDuration = Duration(microseconds: timeStamp.inMicroseconds);
      
      _addMeasurement(PerformanceMeasurement(
        metricType: MetricType.frameRender,
        widgetName: 'FrameRenderer',
        duration: frameDuration,
        timestamp: DateTime.now(),
      ));
      
      // Schedule next frame callback
      if (_frameMonitoringActive) {
        SchedulerBinding.instance.addPostFrameCallback(_frameCallback!);
      }
    };
    
    SchedulerBinding.instance.addPostFrameCallback(_frameCallback!);
  }

  /// Stop frame monitoring
  void stopFrameMonitoring() {
    _frameMonitoringActive = false;
    _frameCallback = null;
  }

  /// Start timing measurement
  void startTiming(String timingKey) {
    _activeTimings[timingKey] = DateTime.now();
  }

  /// End timing measurement and record performance
  void endTiming(
    String timingKey,
    MetricType metricType,
    String widgetName, {
    String? details,
  }) {
    final startTime = _activeTimings.remove(timingKey);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      recordMeasurement(
        metricType,
        widgetName,
        duration,
        details: details,
      );
    }
  }

  /// Record a performance measurement
  void recordMeasurement(
    MetricType metricType,
    String widgetName,
    Duration duration, {
    String? details,
    int? memoryUsage,
  }) {
    final measurement = PerformanceMeasurement(
      metricType: metricType,
      widgetName: widgetName,
      duration: duration,
      timestamp: DateTime.now(),
      details: details,
      memoryUsage: memoryUsage,
    );

    _addMeasurement(measurement);
  }

  /// Add measurement to the queue
  void _addMeasurement(PerformanceMeasurement measurement) {
    _measurements.add(measurement);

    // Trim measurements if needed
    if (_measurements.length > maxMeasurements) {
      _measurements.removeFirst();
    }

    // Log warnings for slow operations
    if (enableConsoleWarnings && measurement.isSlowOperation && kDebugMode) {
      debugPrint('⚠️ Slow ${measurement.metricType.label}: '
                 '${measurement.widgetName} took ${measurement.duration.inMicroseconds}μs '
                 '(Grade: ${measurement.performanceGrade})');
    }
  }

  /// Record setState performance
  void recordSetState(String widgetName, Duration duration, {String? details}) {
    recordMeasurement(MetricType.setState, widgetName, duration, details: details);
  }

  /// Record build performance
  void recordBuild(String widgetName, Duration duration, {String? details}) {
    recordMeasurement(MetricType.build, widgetName, duration, details: details);
  }

  /// Get all measurements
  List<PerformanceMeasurement> get measurements => _measurements.toList();

  /// Get measurements for a specific widget
  List<PerformanceMeasurement> getMeasurementsForWidget(String widgetName) {
    return _measurements
        .where((measurement) => measurement.widgetName == widgetName)
        .toList();
  }

  /// Get measurements for a specific metric type
  List<PerformanceMeasurement> getMeasurementsForType(MetricType metricType) {
    return _measurements
        .where((measurement) => measurement.metricType == metricType)
        .toList();
  }

  /// Get slow operations
  List<PerformanceMeasurement> getSlowOperations() {
    return _measurements
        .where((measurement) => measurement.isSlowOperation)
        .toList();
  }

  /// Get performance statistics for a metric type
  PerformanceStatistics getStatisticsForType(MetricType metricType) {
    final typeMeasurements = getMeasurementsForType(metricType);
    return PerformanceStatistics.fromMeasurements(metricType, typeMeasurements);
  }

  /// Get performance statistics for a widget
  Map<MetricType, PerformanceStatistics> getStatisticsForWidget(String widgetName) {
    final widgetMeasurements = getMeasurementsForWidget(widgetName);
    final statistics = <MetricType, PerformanceStatistics>{};

    for (final metricType in MetricType.values) {
      final typeMeasurements = widgetMeasurements
          .where((m) => m.metricType == metricType)
          .toList();
      statistics[metricType] = PerformanceStatistics.fromMeasurements(metricType, typeMeasurements);
    }

    return statistics;
  }

  /// Get overall performance summary
  PerformanceSummary getPerformanceSummary() {
    final typeStatistics = <MetricType, PerformanceStatistics>{};
    
    for (final metricType in MetricType.values) {
      typeStatistics[metricType] = getStatisticsForType(metricType);
    }

    final slowOperations = getSlowOperations();
    final totalMeasurements = _measurements.length;

    return PerformanceSummary(
      typeStatistics: typeStatistics,
      slowOperationsCount: slowOperations.length,
      totalMeasurements: totalMeasurements,
      averageFrameRate: _calculateAverageFrameRate(),
      memoryEfficiency: _calculateMemoryEfficiency(),
    );
  }

  /// Calculate average frame rate from recent measurements
  double _calculateAverageFrameRate() {
    final frameRenderMeasurements = getMeasurementsForType(MetricType.frameRender);
    
    if (frameRenderMeasurements.isEmpty) return 0.0;

    // Use recent measurements for current frame rate
    final recentMeasurements = frameRenderMeasurements.take(60).toList();
    final totalMicroseconds = recentMeasurements
        .map((m) => m.duration.inMicroseconds)
        .fold(0, (sum, duration) => sum + duration);

    if (totalMicroseconds == 0) return 0.0;

    final averageMicroseconds = totalMicroseconds / recentMeasurements.length;
    return 1000000 / averageMicroseconds; // Convert to FPS
  }

  /// Calculate memory efficiency score
  double _calculateMemoryEfficiency() {
    if (!enableMemoryTracking) return 1.0;

    final measurementsWithMemory = _measurements
        .where((m) => m.memoryUsage != null)
        .toList();

    if (measurementsWithMemory.isEmpty) return 1.0;

    // Simple efficiency calculation based on memory usage stability
    final memoryUsages = measurementsWithMemory.map((m) => m.memoryUsage!).toList();
    final minMemory = memoryUsages.reduce((a, b) => a < b ? a : b);
    final maxMemory = memoryUsages.reduce((a, b) => a > b ? a : b);

    if (maxMemory == minMemory) return 1.0;

    final variationRatio = (maxMemory - minMemory) / maxMemory;
    return 1.0 - variationRatio.clamp(0.0, 1.0);
  }

  /// Get optimization suggestions
  List<OptimizationSuggestion> getOptimizationSuggestions() {
    final suggestions = <OptimizationSuggestion>[];
    final slowOperations = getSlowOperations();

    // Group slow operations by widget and type
    final slowByWidget = <String, List<PerformanceMeasurement>>{};
    for (final operation in slowOperations) {
      slowByWidget[operation.widgetName] ??= [];
      slowByWidget[operation.widgetName]!.add(operation);
    }

    for (final entry in slowByWidget.entries) {
      final widgetName = entry.key;
      final operations = entry.value;

      // setState optimization suggestions
      final slowSetStates = operations.where((o) => o.metricType == MetricType.setState).toList();
      if (slowSetStates.isNotEmpty) {
        suggestions.add(OptimizationSuggestion(
          widget: widgetName,
          type: OptimizationType.setState,
          severity: SeverityLevel.medium,
          description: 'Multiple slow setState operations detected',
          suggestion: 'Consider batching setState calls or using more specific state updates',
          measurements: slowSetStates,
        ));
      }

      // Build optimization suggestions
      final slowBuilds = operations.where((o) => o.metricType == MetricType.build).toList();
      if (slowBuilds.isNotEmpty) {
        suggestions.add(OptimizationSuggestion(
          widget: widgetName,
          type: OptimizationType.build,
          severity: SeverityLevel.high,
          description: 'Slow build method detected',
          suggestion: 'Consider using const constructors, RepaintBoundary, or splitting into smaller widgets',
          measurements: slowBuilds,
        ));
      }
    }

    return suggestions;
  }

  /// Clear all measurements
  void clear() {
    _measurements.clear();
    _activeTimings.clear();
  }

  /// Dispose the performance monitor
  void dispose() {
    stopFrameMonitoring();
    clear();
  }
}

/// Performance statistics for a metric type
@immutable
class PerformanceStatistics {
  /// Creates performance statistics
  const PerformanceStatistics({
    required this.metricType,
    required this.count,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.totalDuration,
    required this.slowOperationsCount,
  });

  /// The metric type these statistics represent
  final MetricType metricType;

  /// Number of measurements
  final int count;

  /// Average duration
  final Duration averageDuration;

  /// Minimum duration
  final Duration minDuration;

  /// Maximum duration
  final Duration maxDuration;

  /// Total duration
  final Duration totalDuration;

  /// Number of slow operations
  final int slowOperationsCount;

  /// Create statistics from measurements
  factory PerformanceStatistics.fromMeasurements(
    MetricType metricType,
    List<PerformanceMeasurement> measurements,
  ) {
    if (measurements.isEmpty) {
      return PerformanceStatistics(
        metricType: metricType,
        count: 0,
        averageDuration: Duration.zero,
        minDuration: Duration.zero,
        maxDuration: Duration.zero,
        totalDuration: Duration.zero,
        slowOperationsCount: 0,
      );
    }

    final durations = measurements.map((m) => m.duration).toList()..sort();
    final totalMicroseconds = durations.map((d) => d.inMicroseconds).fold(0, (sum, d) => sum + d);
    final averageMicroseconds = totalMicroseconds / durations.length;
    final slowOperationsCount = measurements.where((m) => m.isSlowOperation).length;

    return PerformanceStatistics(
      metricType: metricType,
      count: measurements.length,
      averageDuration: Duration(microseconds: averageMicroseconds.round()),
      minDuration: durations.first,
      maxDuration: durations.last,
      totalDuration: Duration(microseconds: totalMicroseconds),
      slowOperationsCount: slowOperationsCount,
    );
  }

  /// Performance efficiency (0.0 to 1.0)
  double get efficiency {
    if (count == 0) return 1.0;
    return 1.0 - (slowOperationsCount / count);
  }

  @override
  String toString() {
    return 'PerformanceStatistics('
        'type: ${metricType.label}, '
        'count: $count, '
        'avg: ${averageDuration.inMicroseconds}μs, '
        'efficiency: ${(efficiency * 100).toStringAsFixed(1)}%'
        ')';
  }
}

/// Overall performance summary
@immutable
class PerformanceSummary {
  /// Creates a performance summary
  const PerformanceSummary({
    required this.typeStatistics,
    required this.slowOperationsCount,
    required this.totalMeasurements,
    required this.averageFrameRate,
    required this.memoryEfficiency,
  });

  /// Statistics by metric type
  final Map<MetricType, PerformanceStatistics> typeStatistics;

  /// Total number of slow operations
  final int slowOperationsCount;

  /// Total number of measurements
  final int totalMeasurements;

  /// Average frame rate
  final double averageFrameRate;

  /// Memory efficiency score (0.0 to 1.0)
  final double memoryEfficiency;

  /// Overall performance score (0.0 to 1.0)
  double get overallScore {
    if (totalMeasurements == 0) return 1.0;
    
    final operationEfficiency = 1.0 - (slowOperationsCount / totalMeasurements);
    final frameRateEfficiency = averageFrameRate >= 60 ? 1.0 : averageFrameRate / 60;
    
    return (operationEfficiency + frameRateEfficiency + memoryEfficiency) / 3;
  }

  /// Performance grade (A-F)
  String get performanceGrade {
    final score = overallScore;
    if (score >= 0.9) return 'A';
    if (score >= 0.8) return 'B';
    if (score >= 0.7) return 'C';
    if (score >= 0.6) return 'D';
    return 'F';
  }

  @override
  String toString() {
    return 'PerformanceSummary('
        'measurements: $totalMeasurements, '
        'slowOps: $slowOperationsCount, '
        'fps: ${averageFrameRate.toStringAsFixed(1)}, '
        'grade: $performanceGrade'
        ')';
  }
}

/// Optimization suggestion
@immutable
class OptimizationSuggestion {
  /// Creates an optimization suggestion
  const OptimizationSuggestion({
    required this.widget,
    required this.type,
    required this.severity,
    required this.description,
    required this.suggestion,
    required this.measurements,
  });

  /// Widget that needs optimization
  final String widget;

  /// Type of optimization needed
  final OptimizationType type;

  /// Severity level of the issue
  final SeverityLevel severity;

  /// Description of the performance issue
  final String description;

  /// Optimization suggestion
  final String suggestion;

  /// Related performance measurements
  final List<PerformanceMeasurement> measurements;

  @override
  String toString() {
    return 'OptimizationSuggestion('
        'widget: $widget, '
        'type: ${type.name}, '
        'severity: ${severity.name}, '
        'measurements: ${measurements.length}'
        ')';
  }
}

/// Optimization type enumeration
enum OptimizationType {
  setState,
  build,
  layout,
  paint,
  memory,
}

/// Severity level enumeration
enum SeverityLevel {
  low,
  medium,
  high,
  critical,
}

/// Global performance monitor instance
final PerformanceMonitor performanceMonitor = PerformanceMonitor();