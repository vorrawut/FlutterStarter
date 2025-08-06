/// Lifecycle logging utility for StatefulWidget monitoring
/// 
/// This file provides comprehensive logging and monitoring of StatefulWidget
/// lifecycle methods for educational and debugging purposes.
library;

import 'package:flutter/foundation.dart';

/// Lifecycle event types
enum LifecycleEvent {
  initState('initState'),
  didChangeDependencies('didChangeDependencies'),
  build('build'),
  didUpdateWidget('didUpdateWidget'),
  deactivate('deactivate'),
  dispose('dispose'),
  setState('setState');

  const LifecycleEvent(this.methodName);

  /// Method name for the lifecycle event
  final String methodName;
}

/// Lifecycle log entry
@immutable
class LifecycleLogEntry {
  /// Creates a lifecycle log entry
  const LifecycleLogEntry({
    required this.event,
    required this.widgetName,
    required this.timestamp,
    this.details,
    this.duration,
  });

  /// The lifecycle event that occurred
  final LifecycleEvent event;

  /// Name of the widget that triggered the event
  final String widgetName;

  /// When the event occurred
  final DateTime timestamp;

  /// Optional details about the event
  final String? details;

  /// Duration of the event (if measured)
  final Duration? duration;

  /// Format timestamp for display
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}:'
           '${timestamp.second.toString().padLeft(2, '0')}.'
           '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }

  /// Get event description
  String get description {
    final buffer = StringBuffer();
    buffer.write('[$formattedTime] $widgetName.${event.methodName}()');
    
    if (details != null) {
      buffer.write(' - $details');
    }
    
    if (duration != null) {
      buffer.write(' (${duration!.inMicroseconds}μs)');
    }
    
    return buffer.toString();
  }

  @override
  String toString() => description;
}

/// Comprehensive lifecycle logger for StatefulWidget monitoring
/// 
/// Provides detailed logging and analysis of widget lifecycle events
/// for educational purposes and performance debugging.
class LifecycleLogger {
  /// Creates a lifecycle logger
  LifecycleLogger({
    this.maxEntries = 1000,
    this.enableConsoleLogging = true,
    this.enablePerformanceTracking = true,
  });

  /// Maximum number of log entries to keep
  final int maxEntries;

  /// Whether to log to console
  final bool enableConsoleLogging;

  /// Whether to track performance metrics
  final bool enablePerformanceTracking;

  /// List of log entries
  final List<LifecycleLogEntry> _entries = [];

  /// Performance metrics by event type
  final Map<LifecycleEvent, List<Duration>> _performanceMetrics = {};

  /// Active timing measurements
  final Map<String, DateTime> _activeTimings = {};

  /// Log a lifecycle event
  void logEvent(
    LifecycleEvent event,
    String widgetName, {
    String? details,
    Duration? duration,
  }) {
    final entry = LifecycleLogEntry(
      event: event,
      widgetName: widgetName,
      timestamp: DateTime.now(),
      details: details,
      duration: duration,
    );

    // Add to entries list
    _entries.add(entry);

    // Trim entries if needed
    if (_entries.length > maxEntries) {
      _entries.removeRange(0, _entries.length - maxEntries);
    }

    // Track performance metrics
    if (enablePerformanceTracking && duration != null) {
      _performanceMetrics[event] ??= [];
      _performanceMetrics[event]!.add(duration);
    }

    // Console logging
    if (enableConsoleLogging && kDebugMode) {
      debugPrint('🔄 ${entry.description}');
    }
  }

  /// Start timing measurement for an event
  void startTiming(String timingKey) {
    _activeTimings[timingKey] = DateTime.now();
  }

  /// End timing measurement and log the event
  void endTiming(
    String timingKey,
    LifecycleEvent event,
    String widgetName, {
    String? details,
  }) {
    final startTime = _activeTimings.remove(timingKey);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      logEvent(event, widgetName, details: details, duration: duration);
    } else {
      logEvent(event, widgetName, details: details);
    }
  }

  /// Log initState event
  void logInitState(String widgetName, {String? details}) {
    logEvent(LifecycleEvent.initState, widgetName, details: details);
  }

  /// Log didChangeDependencies event
  void logDidChangeDependencies(String widgetName, {String? details}) {
    logEvent(LifecycleEvent.didChangeDependencies, widgetName, details: details);
  }

  /// Log build event with timing
  void logBuild(String widgetName, {String? details, Duration? buildTime}) {
    logEvent(LifecycleEvent.build, widgetName, details: details, duration: buildTime);
  }

  /// Log didUpdateWidget event
  void logDidUpdateWidget(String widgetName, {String? details}) {
    logEvent(LifecycleEvent.didUpdateWidget, widgetName, details: details);
  }

  /// Log deactivate event
  void logDeactivate(String widgetName, {String? details}) {
    logEvent(LifecycleEvent.deactivate, widgetName, details: details);
  }

  /// Log dispose event
  void logDispose(String widgetName, {String? details}) {
    logEvent(LifecycleEvent.dispose, widgetName, details: details);
  }

  /// Log setState event with timing
  void logSetState(String widgetName, {String? details, Duration? setStateTime}) {
    logEvent(LifecycleEvent.setState, widgetName, details: details, duration: setStateTime);
  }

  /// Get all log entries
  List<LifecycleLogEntry> get entries => List.unmodifiable(_entries);

  /// Get entries for a specific widget
  List<LifecycleLogEntry> getEntriesForWidget(String widgetName) {
    return _entries.where((entry) => entry.widgetName == widgetName).toList();
  }

  /// Get entries for a specific event type
  List<LifecycleLogEntry> getEntriesForEvent(LifecycleEvent event) {
    return _entries.where((entry) => entry.event == event).toList();
  }

  /// Get performance statistics for an event type
  PerformanceStatistics getPerformanceStats(LifecycleEvent event) {
    final durations = _performanceMetrics[event] ?? [];
    
    if (durations.isEmpty) {
      return PerformanceStatistics.empty(event);
    }

    final microseconds = durations.map((d) => d.inMicroseconds).toList()..sort();
    
    final total = microseconds.fold(0, (sum, duration) => sum + duration);
    final average = total / microseconds.length;
    final median = microseconds.length.isOdd
        ? microseconds[microseconds.length ~/ 2].toDouble()
        : (microseconds[microseconds.length ~/ 2 - 1] + microseconds[microseconds.length ~/ 2]) / 2.0;
    
    return PerformanceStatistics(
      event: event,
      count: microseconds.length,
      totalMicroseconds: total,
      averageMicroseconds: average,
      medianMicroseconds: median,
      minMicroseconds: microseconds.first,
      maxMicroseconds: microseconds.last,
    );
  }

  /// Get all performance statistics
  Map<LifecycleEvent, PerformanceStatistics> getAllPerformanceStats() {
    final stats = <LifecycleEvent, PerformanceStatistics>{};
    
    for (final event in LifecycleEvent.values) {
      stats[event] = getPerformanceStats(event);
    }
    
    return stats;
  }

  /// Clear all log entries
  void clear() {
    _entries.clear();
    _performanceMetrics.clear();
    _activeTimings.clear();
  }

  /// Get summary of widget activity
  Map<String, int> getWidgetActivitySummary() {
    final summary = <String, int>{};
    
    for (final entry in _entries) {
      summary[entry.widgetName] = (summary[entry.widgetName] ?? 0) + 1;
    }
    
    return summary;
  }

  /// Get event frequency summary
  Map<LifecycleEvent, int> getEventFrequencySummary() {
    final summary = <LifecycleEvent, int>{};
    
    for (final entry in _entries) {
      summary[entry.event] = (summary[entry.event] ?? 0) + 1;
    }
    
    return summary;
  }

  /// Export logs as formatted string
  String exportLogs({
    String? widgetFilter,
    LifecycleEvent? eventFilter,
    int? maxEntries,
  }) {
    var filteredEntries = _entries;
    
    if (widgetFilter != null) {
      filteredEntries = filteredEntries
          .where((entry) => entry.widgetName == widgetFilter)
          .toList();
    }
    
    if (eventFilter != null) {
      filteredEntries = filteredEntries
          .where((entry) => entry.event == eventFilter)
          .toList();
    }
    
    if (maxEntries != null && filteredEntries.length > maxEntries) {
      filteredEntries = filteredEntries
          .sublist(filteredEntries.length - maxEntries);
    }
    
    final buffer = StringBuffer();
    buffer.writeln('🔄 Lifecycle Logs Export');
    buffer.writeln('Exported at: ${DateTime.now()}');
    buffer.writeln('Total entries: ${filteredEntries.length}');
    
    if (widgetFilter != null) {
      buffer.writeln('Widget filter: $widgetFilter');
    }
    
    if (eventFilter != null) {
      buffer.writeln('Event filter: ${eventFilter.methodName}');
    }
    
    buffer.writeln('${'=' * 50}');
    
    for (final entry in filteredEntries) {
      buffer.writeln(entry.description);
    }
    
    return buffer.toString();
  }
}

/// Performance statistics for lifecycle events
@immutable
class PerformanceStatistics {
  /// Creates performance statistics
  const PerformanceStatistics({
    required this.event,
    required this.count,
    required this.totalMicroseconds,
    required this.averageMicroseconds,
    required this.medianMicroseconds,
    required this.minMicroseconds,
    required this.maxMicroseconds,
  });

  /// The lifecycle event
  final LifecycleEvent event;

  /// Number of measurements
  final int count;

  /// Total time in microseconds
  final int totalMicroseconds;

  /// Average time in microseconds
  final double averageMicroseconds;

  /// Median time in microseconds
  final double medianMicroseconds;

  /// Minimum time in microseconds
  final int minMicroseconds;

  /// Maximum time in microseconds
  final int maxMicroseconds;

  /// Create empty statistics
  factory PerformanceStatistics.empty(LifecycleEvent event) {
    return PerformanceStatistics(
      event: event,
      count: 0,
      totalMicroseconds: 0,
      averageMicroseconds: 0.0,
      medianMicroseconds: 0.0,
      minMicroseconds: 0,
      maxMicroseconds: 0,
    );
  }

  /// Get average duration
  Duration get averageDuration => Duration(microseconds: averageMicroseconds.round());

  /// Get median duration
  Duration get medianDuration => Duration(microseconds: medianMicroseconds.round());

  /// Get min duration
  Duration get minDuration => Duration(microseconds: minMicroseconds);

  /// Get max duration
  Duration get maxDuration => Duration(microseconds: maxMicroseconds);

  /// Get total duration
  Duration get totalDuration => Duration(microseconds: totalMicroseconds);

  /// Get formatted summary
  String get summary {
    if (count == 0) {
      return '${event.methodName}: No measurements';
    }
    
    return '${event.methodName}: $count calls, '
           'avg: ${averageDuration.inMicroseconds}μs, '
           'median: ${medianDuration.inMicroseconds}μs, '
           'range: ${minDuration.inMicroseconds}-${maxDuration.inMicroseconds}μs';
  }

  @override
  String toString() => summary;
}

/// Global lifecycle logger instance
final LifecycleLogger lifecycleLogger = LifecycleLogger();