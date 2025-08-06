/// Lifecycle logging mixin for StatefulWidget monitoring
/// 
/// This file provides a reusable mixin that automatically logs
/// StatefulWidget lifecycle events for educational and debugging purposes.
library;

import 'package:flutter/material.dart';
import '../../core/utils/lifecycle_logger.dart';
import '../../core/utils/performance_monitor.dart';

/// Mixin for automatic lifecycle logging and performance monitoring
/// 
/// Provides comprehensive lifecycle event logging and performance tracking
/// for StatefulWidget classes with automatic timing measurements.
mixin LifecycleMixin<T extends StatefulWidget> on State<T> {
  
  /// Widget name for logging (defaults to runtime type)
  String get widgetName => widget.runtimeType.toString();

  /// Whether to enable detailed lifecycle logging
  bool get enableLifecycleLogging => true;

  /// Whether to enable performance monitoring
  bool get enablePerformanceMonitoring => true;

  /// Whether to enable automatic setState timing
  bool get enableSetStateMonitoring => true;

  /// Custom initialization callback
  void onInitStateCallback() {}

  /// Custom dependency change callback
  void onDidChangeDependenciesCallback() {}

  /// Custom widget update callback
  void onDidUpdateWidgetCallback(T oldWidget) {}

  /// Custom deactivate callback
  void onDeactivateCallback() {}

  /// Custom dispose callback
  void onDisposeCallback() {}

  @override
  void initState() {
    super.initState();
    
    if (enableLifecycleLogging) {
      lifecycleLogger.logInitState(
        widgetName,
        details: 'Widget initialized with state: ${widget.toString()}',
      );
    }

    if (enablePerformanceMonitoring) {
      performanceMonitor.initialize();
    }

    // Call custom initialization
    onInitStateCallback();
  }

  @override
  void didChangeDependencies() {
    if (enableLifecycleLogging) {
      lifecycleLogger.logDidChangeDependencies(
        widgetName,
        details: 'Dependencies changed, context: ${context.widget.runtimeType}',
      );
    }

    super.didChangeDependencies();
    
    // Call custom dependency change callback
    onDidChangeDependenciesCallback();
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    
    if (enablePerformanceMonitoring) {
      // Measure build performance
      final buildStart = DateTime.now();
      result = buildWidget(context);
      final buildDuration = DateTime.now().difference(buildStart);
      
      performanceMonitor.recordBuild(
        widgetName,
        buildDuration,
        details: 'Build completed for ${widget.runtimeType}',
      );

      if (enableLifecycleLogging) {
        lifecycleLogger.logBuild(
          widgetName,
          details: 'Build completed with ${buildDuration.inMicroseconds}μs',
          buildTime: buildDuration,
        );
      }
    } else {
      result = buildWidget(context);
      
      if (enableLifecycleLogging) {
        lifecycleLogger.logBuild(
          widgetName,
          details: 'Build completed (timing disabled)',
        );
      }
    }

    return result;
  }

  /// Abstract build method that subclasses must implement
  /// 
  /// This replaces the normal build method to allow performance monitoring
  Widget buildWidget(BuildContext context);

  @override
  void didUpdateWidget(T oldWidget) {
    if (enableLifecycleLogging) {
      lifecycleLogger.logDidUpdateWidget(
        widgetName,
        details: 'Widget updated from ${oldWidget.runtimeType} to ${widget.runtimeType}',
      );
    }

    super.didUpdateWidget(oldWidget);
    
    // Call custom widget update callback
    onDidUpdateWidgetCallback(oldWidget);
  }

  @override
  void deactivate() {
    if (enableLifecycleLogging) {
      lifecycleLogger.logDeactivate(
        widgetName,
        details: 'Widget deactivated, mounted: $mounted',
      );
    }

    // Call custom deactivate callback
    onDeactivateCallback();
    
    super.deactivate();
  }

  @override
  void dispose() {
    if (enableLifecycleLogging) {
      lifecycleLogger.logDispose(
        widgetName,
        details: 'Widget disposed, final state cleanup',
      );
    }

    // Call custom dispose callback
    onDisposeCallback();

    super.dispose();
  }

  /// Enhanced setState with performance monitoring
  /// 
  /// Wraps the standard setState with performance tracking and logging
  void setStateWithMonitoring(VoidCallback fn, [String? description]) {
    if (!mounted) {
      if (enableLifecycleLogging) {
        lifecycleLogger.logSetState(
          widgetName,
          details: 'setState called on unmounted widget - IGNORED',
        );
      }
      return;
    }

    if (enableSetStateMonitoring && enablePerformanceMonitoring) {
      final setStateStart = DateTime.now();
      
      setState(() {
        fn();
      });
      
      final setStateDuration = DateTime.now().difference(setStateStart);
      
      performanceMonitor.recordSetState(
        widgetName,
        setStateDuration,
        details: description ?? 'setState operation',
      );

      if (enableLifecycleLogging) {
        lifecycleLogger.logSetState(
          widgetName,
          details: '${description ?? "setState"} (${setStateDuration.inMicroseconds}μs)',
          setStateTime: setStateDuration,
        );
      }
    } else {
      setState(fn);
      
      if (enableLifecycleLogging) {
        lifecycleLogger.logSetState(
          widgetName,
          details: description ?? 'setState operation (monitoring disabled)',
        );
      }
    }
  }

  /// Safe setState that checks mounted state
  /// 
  /// Prevents setState calls on unmounted widgets
  void safeSetState(VoidCallback fn, [String? description]) {
    if (mounted) {
      setStateWithMonitoring(fn, description);
    } else if (enableLifecycleLogging) {
      lifecycleLogger.logSetState(
        widgetName,
        details: 'Safe setState: widget not mounted - SKIPPED',
      );
    }
  }

  /// Batch multiple setState operations
  /// 
  /// Combines multiple state updates into a single setState call for better performance
  void batchSetState(List<VoidCallback> operations, [String? description]) {
    if (!mounted) return;

    setStateWithMonitoring(() {
      for (final operation in operations) {
        operation();
      }
    }, description ?? 'Batched setState (${operations.length} operations)');
  }

  /// Async setState with proper error handling
  /// 
  /// Safely performs async operations and updates state
  Future<void> asyncSetState(
    Future<void> Function() asyncOperation,
    VoidCallback onSuccess, {
    void Function(Object error)? onError,
    String? description,
  }) async {
    try {
      await asyncOperation();
      
      if (mounted) {
        setStateWithMonitoring(
          onSuccess,
          description ?? 'Async setState success',
        );
      }
    } catch (error) {
      if (enableLifecycleLogging) {
        lifecycleLogger.logSetState(
          widgetName,
          details: 'Async setState error: $error',
        );
      }
      
      if (onError != null && mounted) {
        setStateWithMonitoring(
          () => onError(error),
          'Async setState error handling',
        );
      }
    }
  }

  /// Get lifecycle statistics for this widget
  Map<LifecycleEvent, int> getLifecycleStatistics() {
    final entries = lifecycleLogger.getEntriesForWidget(widgetName);
    final statistics = <LifecycleEvent, int>{};
    
    for (final event in LifecycleEvent.values) {
      statistics[event] = entries.where((entry) => entry.event == event).length;
    }
    
    return statistics;
  }

  /// Get performance statistics for this widget
  Map<MetricType, PerformanceStatistics> getPerformanceStatistics() {
    return performanceMonitor.getStatisticsForWidget(widgetName);
  }

  /// Export lifecycle log for this widget
  String exportLifecycleLog() {
    return lifecycleLogger.exportLogs(widgetFilter: widgetName);
  }

  /// Check if widget has performance issues
  bool hasPerformanceIssues() {
    final suggestions = performanceMonitor.getOptimizationSuggestions();
    return suggestions.any((suggestion) => suggestion.widget == widgetName);
  }

  /// Get optimization suggestions for this widget
  List<OptimizationSuggestion> getOptimizationSuggestions() {
    return performanceMonitor.getOptimizationSuggestions()
        .where((suggestion) => suggestion.widget == widgetName)
        .toList();
  }
}

/// Simplified lifecycle mixin for basic monitoring
/// 
/// Provides essential lifecycle logging without performance monitoring
/// for simpler use cases.
mixin SimpleLifecycleMixin<T extends StatefulWidget> on State<T> {
  
  /// Widget name for logging
  String get widgetName => widget.runtimeType.toString();

  @override
  void initState() {
    super.initState();
    debugPrint('🔄 $widgetName.initState()');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🔄 $widgetName.didChangeDependencies()');
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('🔄 $widgetName.didUpdateWidget()');
  }

  @override
  void deactivate() {
    debugPrint('🔄 $widgetName.deactivate()');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('🔄 $widgetName.dispose()');
    super.dispose();
  }

  /// Simple setState with logging
  void loggedSetState(VoidCallback fn, [String? description]) {
    if (mounted) {
      debugPrint('🔄 $widgetName.setState() - ${description ?? "state update"}');
      setState(fn);
    }
  }
}

/// Performance-focused lifecycle mixin
/// 
/// Provides only performance monitoring without detailed lifecycle logging
/// for production use cases.
mixin PerformanceLifecycleMixin<T extends StatefulWidget> on State<T> {
  
  /// Widget name for monitoring
  String get widgetName => widget.runtimeType.toString();

  @override
  void initState() {
    super.initState();
    performanceMonitor.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final buildStart = DateTime.now();
    final result = buildWidget(context);
    final buildDuration = DateTime.now().difference(buildStart);
    
    performanceMonitor.recordBuild(widgetName, buildDuration);
    
    return result;
  }

  /// Performance-monitored build method
  Widget buildWidget(BuildContext context);

  /// Performance-monitored setState
  void performanceSetState(VoidCallback fn, [String? description]) {
    if (!mounted) return;

    final setStateStart = DateTime.now();
    setState(fn);
    final setStateDuration = DateTime.now().difference(setStateStart);
    
    performanceMonitor.recordSetState(
      widgetName,
      setStateDuration,
      details: description,
    );
  }

  /// Get performance grade for this widget
  String getPerformanceGrade() {
    final statistics = performanceMonitor.getStatisticsForWidget(widgetName);
    final buildStats = statistics[MetricType.build];
    
    if (buildStats == null || buildStats.count == 0) return 'N/A';
    
    final avgMicroseconds = buildStats.averageDuration.inMicroseconds;
    
    if (avgMicroseconds <= 1000) return 'A';
    if (avgMicroseconds <= 3000) return 'B';
    if (avgMicroseconds <= 5000) return 'C';
    if (avgMicroseconds <= 8000) return 'D';
    return 'F';
  }
}