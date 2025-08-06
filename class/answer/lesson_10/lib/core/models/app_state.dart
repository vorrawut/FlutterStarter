/// Application state container for task management
/// 
/// This file defines the main application state with immutable patterns,
/// loading states, error handling, and performance tracking.
library;

import 'package:flutter/foundation.dart';
import 'task.dart';
import 'task_filter.dart';

/// Loading state enumeration
enum LoadingState {
  idle('Idle'),
  loading('Loading'),
  success('Success'),
  error('Error');

  const LoadingState(this.label);

  /// Display label for the loading state
  final String label;

  /// Whether the state represents loading
  bool get isLoading => this == LoadingState.loading;

  /// Whether the state represents success
  bool get isSuccess => this == LoadingState.success;

  /// Whether the state represents an error
  bool get isError => this == LoadingState.error;

  /// Whether the state is idle
  bool get isIdle => this == LoadingState.idle;
}

/// Operation type enumeration for tracking different async operations
enum OperationType {
  loadTasks('Loading Tasks'),
  createTask('Creating Task'),
  updateTask('Updating Task'),
  deleteTask('Deleting Task'),
  searchTasks('Searching Tasks');

  const OperationType(this.label);

  /// Display label for the operation
  final String label;
}

/// Immutable application state container
/// 
/// Contains all application state including tasks, filters, loading states,
/// and error information with immutable update patterns.
@immutable
class AppState {
  /// Creates a new AppState instance
  const AppState({
    this.tasks = const [],
    this.filter = const TaskFilter(),
    this.loadingState = LoadingState.idle,
    this.currentOperation,
    this.errorMessage,
    this.selectedTaskId,
    this.lastUpdated,
    this.performanceMetrics = const {},
  });

  /// List of all tasks
  final List<Task> tasks;

  /// Current filter configuration
  final TaskFilter filter;

  /// Current loading state
  final LoadingState loadingState;

  /// Current operation being performed
  final OperationType? currentOperation;

  /// Error message if in error state
  final String? errorMessage;

  /// Currently selected task ID
  final String? selectedTaskId;

  /// When the state was last updated
  final DateTime? lastUpdated;

  /// Performance metrics for monitoring
  final Map<String, dynamic> performanceMetrics;

  /// Create a copy with modified fields (immutable update pattern)
  AppState copyWith({
    List<Task>? tasks,
    TaskFilter? filter,
    LoadingState? loadingState,
    OperationType? currentOperation,
    String? errorMessage,
    String? selectedTaskId,
    DateTime? lastUpdated,
    Map<String, dynamic>? performanceMetrics,
  }) {
    return AppState(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      loadingState: loadingState ?? this.loadingState,
      currentOperation: currentOperation ?? this.currentOperation,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTaskId: selectedTaskId ?? this.selectedTaskId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
    );
  }

  /// Create initial state
  factory AppState.initial() {
    return AppState(
      lastUpdated: DateTime.now(),
    );
  }

  /// Create loading state with operation
  AppState loading(OperationType operation) {
    return copyWith(
      loadingState: LoadingState.loading,
      currentOperation: operation,
      errorMessage: null,
      lastUpdated: DateTime.now(),
    );
  }

  /// Create success state
  AppState success({
    List<Task>? tasks,
    TaskFilter? filter,
  }) {
    return copyWith(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      loadingState: LoadingState.success,
      currentOperation: null,
      errorMessage: null,
      lastUpdated: DateTime.now(),
    );
  }

  /// Create error state
  AppState error(String message) {
    return copyWith(
      loadingState: LoadingState.error,
      errorMessage: message,
      currentOperation: null,
      lastUpdated: DateTime.now(),
    );
  }

  /// Clear error state
  AppState clearError() {
    return copyWith(
      loadingState: LoadingState.idle,
      errorMessage: null,
      currentOperation: null,
    );
  }

  /// Update tasks
  AppState updateTasks(List<Task> newTasks) {
    return copyWith(
      tasks: newTasks,
      lastUpdated: DateTime.now(),
    );
  }

  /// Add a new task
  AppState addTask(Task task) {
    final updatedTasks = [...tasks, task];
    return copyWith(
      tasks: updatedTasks,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update an existing task
  AppState updateTask(Task updatedTask) {
    final updatedTasks = tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();

    return copyWith(
      tasks: updatedTasks,
      lastUpdated: DateTime.now(),
    );
  }

  /// Remove a task
  AppState removeTask(String taskId) {
    final updatedTasks = tasks.where((task) => task.id != taskId).toList();
    final updatedSelectedId = selectedTaskId == taskId ? null : selectedTaskId;

    return copyWith(
      tasks: updatedTasks,
      selectedTaskId: updatedSelectedId,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update filter
  AppState updateFilter(TaskFilter newFilter) {
    return copyWith(
      filter: newFilter,
      lastUpdated: DateTime.now(),
    );
  }

  /// Select a task
  AppState selectTask(String? taskId) {
    return copyWith(
      selectedTaskId: taskId,
    );
  }

  /// Update performance metrics
  AppState updatePerformanceMetrics(Map<String, dynamic> metrics) {
    final updatedMetrics = {...performanceMetrics, ...metrics};
    return copyWith(
      performanceMetrics: updatedMetrics,
      lastUpdated: DateTime.now(),
    );
  }

  /// Get filtered tasks based on current filter
  List<Task> get filteredTasks {
    return filter.apply(tasks);
  }

  /// Get currently selected task
  Task? get selectedTask {
    if (selectedTaskId == null) return null;
    try {
      return tasks.firstWhere((task) => task.id == selectedTaskId);
    } catch (e) {
      return null;
    }
  }

  /// Get task statistics
  TaskStatistics get statistics {
    return TaskStatistics.fromTasks(tasks);
  }

  /// Get filtered task statistics
  TaskStatistics get filteredStatistics {
    return TaskStatistics.fromTasks(filteredTasks);
  }

  /// Check if state has any tasks
  bool get hasTasks => tasks.isNotEmpty;

  /// Check if filtered view has tasks
  bool get hasFilteredTasks => filteredTasks.isNotEmpty;

  /// Check if there's an active search
  bool get hasActiveSearch => filter.searchQuery.isNotEmpty;

  /// Check if there are active filters
  bool get hasActiveFilters => filter.hasActiveFilters;

  /// Get task by ID
  Task? getTaskById(String id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all unique tags from tasks
  List<String> get allTags {
    final tagSet = <String>{};
    for (final task in tasks) {
      tagSet.addAll(task.tags);
    }
    return tagSet.toList()..sort();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppState &&
        listEquals(other.tasks, tasks) &&
        other.filter == filter &&
        other.loadingState == loadingState &&
        other.currentOperation == currentOperation &&
        other.errorMessage == errorMessage &&
        other.selectedTaskId == selectedTaskId &&
        other.lastUpdated == lastUpdated &&
        mapEquals(other.performanceMetrics, performanceMetrics);
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(tasks),
      filter,
      loadingState,
      currentOperation,
      errorMessage,
      selectedTaskId,
      lastUpdated,
      Object.hashAll(performanceMetrics.entries),
    );
  }

  @override
  String toString() {
    return 'AppState('
        'tasks: ${tasks.length}, '
        'filteredTasks: ${filteredTasks.length}, '
        'loadingState: $loadingState, '
        'operation: $currentOperation, '
        'hasError: ${errorMessage != null}'
        ')';
  }
}

/// Task statistics data class
@immutable
class TaskStatistics {
  /// Creates task statistics
  const TaskStatistics({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.cancelled,
    required this.overdue,
    required this.dueSoon,
    required this.highPriority,
    required this.completionRate,
    required this.averageCompletionTime,
  });

  /// Total number of tasks
  final int total;

  /// Number of pending tasks
  final int pending;

  /// Number of in-progress tasks
  final int inProgress;

  /// Number of completed tasks
  final int completed;

  /// Number of cancelled tasks
  final int cancelled;

  /// Number of overdue tasks
  final int overdue;

  /// Number of tasks due soon
  final int dueSoon;

  /// Number of high priority tasks
  final int highPriority;

  /// Completion rate (0.0 to 1.0)
  final double completionRate;

  /// Average completion time
  final Duration? averageCompletionTime;

  /// Create statistics from a list of tasks
  factory TaskStatistics.fromTasks(List<Task> tasks) {
    final total = tasks.length;
    final pending = tasks.where((t) => t.status == TaskStatus.pending).length;
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    final cancelled = tasks.where((t) => t.status == TaskStatus.cancelled).length;
    final overdue = tasks.where((t) => t.isOverdue).length;
    final dueSoon = tasks.where((t) => t.isDueSoon).length;
    final highPriority = tasks.where((t) => t.priority == TaskPriority.high || t.priority == TaskPriority.urgent).length;

    // Calculate completion rate
    final completionRate = total > 0 ? completed / total : 0.0;

    // Calculate average completion time
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
    Duration? averageCompletionTime;
    
    if (completedTasks.isNotEmpty) {
      final totalCompletionTime = completedTasks
          .where((t) => t.completionTime != null)
          .map((t) => t.completionTime!.inMilliseconds)
          .fold(0, (sum, time) => sum + time);
      
      if (totalCompletionTime > 0) {
        averageCompletionTime = Duration(
          milliseconds: (totalCompletionTime / completedTasks.length).round(),
        );
      }
    }

    return TaskStatistics(
      total: total,
      pending: pending,
      inProgress: inProgress,
      completed: completed,
      cancelled: cancelled,
      overdue: overdue,
      dueSoon: dueSoon,
      highPriority: highPriority,
      completionRate: completionRate,
      averageCompletionTime: averageCompletionTime,
    );
  }

  /// Create empty statistics
  factory TaskStatistics.empty() {
    return const TaskStatistics(
      total: 0,
      pending: 0,
      inProgress: 0,
      completed: 0,
      cancelled: 0,
      overdue: 0,
      dueSoon: 0,
      highPriority: 0,
      completionRate: 0.0,
      averageCompletionTime: null,
    );
  }

  @override
  String toString() {
    return 'TaskStatistics('
        'total: $total, '
        'completed: $completed, '
        'completionRate: ${(completionRate * 100).toStringAsFixed(1)}%, '
        'overdue: $overdue'
        ')';
  }
}