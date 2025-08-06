/// Task controller for state management and business logic
/// 
/// This file demonstrates proper StatefulWidget state management patterns
/// with CRUD operations, error handling, and performance monitoring.
library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/models/app_state.dart';
import '../../core/models/task.dart';
import '../../core/models/task_filter.dart';
import '../../core/utils/lifecycle_logger.dart';
import '../../core/utils/performance_monitor.dart';
import '../mixins/lifecycle_mixin.dart';

/// Task controller demonstrating professional setState patterns
/// 
/// Manages task state with proper lifecycle handling, error management,
/// and performance optimization using StatefulWidget patterns.
class TaskController extends StatefulWidget {
  /// Creates a task controller
  const TaskController({
    super.key,
    required this.child,
    this.initialTasks = const [],
    this.onStateChanged,
  });

  /// Child widget that receives the task controller
  final Widget Function(TaskControllerState controller) child;

  /// Initial tasks to populate the controller
  final List<Task> initialTasks;

  /// Callback when state changes
  final void Function(AppState state)? onStateChanged;

  @override
  State<TaskController> createState() => _TaskControllerState();

  /// Access the controller from context
  static TaskControllerState of(BuildContext context) {
    final controller = context.findAncestorStateOfType<_TaskControllerState>();
    if (controller == null) {
      throw FlutterError(
        'TaskController.of() called with a context that does not contain a TaskController.\n'
        'No TaskController ancestor could be found starting from the context that was passed '
        'to TaskController.of().',
      );
    }
    return controller;
  }

  /// Try to access the controller from context (returns null if not found)
  static TaskControllerState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_TaskControllerState>();
  }
}

class _TaskControllerState extends State<TaskController> 
    with LifecycleMixin<TaskController>, TaskControllerState {

  /// Current application state
  AppState _currentState = AppState.initial();

  /// Timer for auto-save functionality
  Timer? _autoSaveTimer;

  /// Completer for initialization
  Completer<void>? _initializationCompleter;

  /// Whether the controller has been initialized
  bool _isInitialized = false;

  @override
  String get widgetName => 'TaskController';

  @override
  bool get enableLifecycleLogging => true;

  @override
  bool get enablePerformanceMonitoring => true;

  @override
  void onInitStateCallback() {
    _initializeController();
  }

  @override
  void onDisposeCallback() {
    _autoSaveTimer?.cancel();
    _initializationCompleter?.complete();
  }

  /// Initialize the controller with sample data
  Future<void> _initializeController() async {
    if (_isInitialized) return;

    try {
      setStateWithMonitoring(() {
        _currentState = _currentState.loading(OperationType.loadTasks);
      }, 'Initialize loading state');

      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      final initialTasks = widget.initialTasks.isEmpty 
          ? _generateSampleTasks() 
          : widget.initialTasks;

      setStateWithMonitoring(() {
        _currentState = _currentState.success(tasks: initialTasks);
        _isInitialized = true;
      }, 'Initialize with tasks');

      // Setup auto-save
      _setupAutoSave();

      // Complete initialization
      _initializationCompleter?.complete();

      // Notify state change
      widget.onStateChanged?.call(_currentState);

    } catch (error) {
      setStateWithMonitoring(() {
        _currentState = _currentState.error('Failed to initialize: $error');
      }, 'Initialize error');

      _initializationCompleter?.completeError(error);
    }
  }

  /// Generate sample tasks for demonstration
  List<Task> _generateSampleTasks() {
    final random = Random();
    final priorities = TaskPriority.values;
    final statuses = [TaskStatus.pending, TaskStatus.inProgress, TaskStatus.completed];
    
    final sampleTasks = <Task>[];
    final now = DateTime.now();

    // Create diverse sample tasks
    final taskTemplates = [
      ('Complete project documentation', 'Write comprehensive documentation for the new project features', ['documentation', 'project']),
      ('Review code changes', 'Review pull requests from team members', ['review', 'code']),
      ('Update dependencies', 'Update all project dependencies to latest versions', ['maintenance', 'dependencies']),
      ('Fix critical bug', 'Resolve the memory leak issue in the payment module', ['bug', 'critical']),
      ('Design new feature', 'Create mockups for the user profile enhancement', ['design', 'ui']),
      ('Team meeting preparation', 'Prepare agenda and materials for weekly team meeting', ['meeting', 'planning']),
      ('Database optimization', 'Optimize slow queries in the user analytics database', ['database', 'performance']),
      ('Write unit tests', 'Add comprehensive test coverage for the authentication module', ['testing', 'quality']),
    ];

    for (int i = 0; i < taskTemplates.length; i++) {
      final template = taskTemplates[i];
      final priority = priorities[random.nextInt(priorities.length)];
      final status = statuses[random.nextInt(statuses.length)];
      
      // Vary due dates
      DateTime? dueDate;
      if (random.nextBool()) {
        final daysOffset = random.nextInt(14) - 7; // -7 to +7 days
        dueDate = now.add(Duration(days: daysOffset));
      }

      // Add completion date for completed tasks
      DateTime? completedAt;
      if (status == TaskStatus.completed) {
        completedAt = now.subtract(Duration(days: random.nextInt(7)));
      }

      final task = Task(
        id: 'task_${i + 1}',
        title: template.$1,
        description: template.$2,
        priority: priority,
        status: status,
        createdAt: now.subtract(Duration(days: random.nextInt(30))),
        dueDate: dueDate,
        completedAt: completedAt,
        tags: template.$3,
        estimatedHours: random.nextBool() ? (random.nextInt(8) + 1).toDouble() : null,
        actualHours: status == TaskStatus.completed ? (random.nextInt(6) + 1).toDouble() : null,
      );

      sampleTasks.add(task);
    }

    return sampleTasks;
  }

  /// Setup auto-save timer
  void _setupAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _autoSave();
      }
    });
  }

  /// Auto-save current state
  void _autoSave() {
    // In a real app, this would save to persistent storage
    if (kDebugMode) {
      debugPrint('🔄 TaskController: Auto-save triggered (${_currentState.tasks.length} tasks)');
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return widget.child(this);
  }

  // TaskControllerState implementation

  @override
  AppState get currentState => _currentState;

  @override
  List<Task> get tasks => _currentState.tasks;

  @override
  List<Task> get filteredTasks => _currentState.filteredTasks;

  @override
  TaskFilter get filter => _currentState.filter;

  @override
  LoadingState get loadingState => _currentState.loadingState;

  @override
  String? get errorMessage => _currentState.errorMessage;

  @override
  TaskStatistics get statistics => _currentState.statistics;

  @override
  TaskStatistics get filteredStatistics => _currentState.filteredStatistics;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> waitForInitialization() async {
    if (_isInitialized) return;
    
    _initializationCompleter ??= Completer<void>();
    return _initializationCompleter!.future;
  }

  @override
  Future<void> createTask(Task task) async {
    await performanceMonitor.startTiming('create_task');
    
    try {
      setStateWithMonitoring(() {
        _currentState = _currentState.loading(OperationType.createTask);
      }, 'Create task - loading');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));

      setStateWithMonitoring(() {
        _currentState = _currentState.success().addTask(task);
      }, 'Create task - success');

      widget.onStateChanged?.call(_currentState);

    } catch (error) {
      setStateWithMonitoring(() {
        _currentState = _currentState.error('Failed to create task: $error');
      }, 'Create task - error');
    } finally {
      performanceMonitor.endTiming('create_task', MetricType.setState, widgetName);
    }
  }

  @override
  Future<void> updateTask(Task updatedTask) async {
    await performanceMonitor.startTiming('update_task');

    try {
      setStateWithMonitoring(() {
        _currentState = _currentState.loading(OperationType.updateTask);
      }, 'Update task - loading');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 200));

      setStateWithMonitoring(() {
        _currentState = _currentState.success().updateTask(updatedTask);
      }, 'Update task - success');

      widget.onStateChanged?.call(_currentState);

    } catch (error) {
      setStateWithMonitoring(() {
        _currentState = _currentState.error('Failed to update task: $error');
      }, 'Update task - error');
    } finally {
      performanceMonitor.endTiming('update_task', MetricType.setState, widgetName);
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await performanceMonitor.startTiming('delete_task');

    try {
      setStateWithMonitoring(() {
        _currentState = _currentState.loading(OperationType.deleteTask);
      }, 'Delete task - loading');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 200));

      setStateWithMonitoring(() {
        _currentState = _currentState.success().removeTask(taskId);
      }, 'Delete task - success');

      widget.onStateChanged?.call(_currentState);

    } catch (error) {
      setStateWithMonitoring(() {
        _currentState = _currentState.error('Failed to delete task: $error');
      }, 'Delete task - error');
    } finally {
      performanceMonitor.endTiming('delete_task', MetricType.setState, widgetName);
    }
  }

  @override
  Future<void> toggleTaskStatus(String taskId) async {
    final task = _currentState.getTaskById(taskId);
    if (task == null) return;

    final updatedTask = switch (task.status) {
      TaskStatus.pending => task.markInProgress(),
      TaskStatus.inProgress => task.markCompleted(),
      TaskStatus.completed => task.copyWith(status: TaskStatus.pending, completedAt: null),
      TaskStatus.cancelled => task.copyWith(status: TaskStatus.pending),
    };

    await updateTask(updatedTask);
  }

  @override
  void updateFilter(TaskFilter newFilter) {
    setStateWithMonitoring(() {
      _currentState = _currentState.updateFilter(newFilter);
    }, 'Update filter');

    widget.onStateChanged?.call(_currentState);
  }

  @override
  void clearFilter() {
    updateFilter(TaskFilter.defaultFilter());
  }

  @override
  void searchTasks(String query) {
    performanceMonitor.startTiming('search_tasks');

    setStateWithMonitoring(() {
      _currentState = _currentState.updateFilter(
        _currentState.filter.withSearch(query),
      );
    }, 'Search tasks: "$query"');

    widget.onStateChanged?.call(_currentState);
    
    performanceMonitor.endTiming('search_tasks', MetricType.setState, widgetName);
  }

  @override
  void selectTask(String? taskId) {
    setStateWithMonitoring(() {
      _currentState = _currentState.selectTask(taskId);
    }, 'Select task: $taskId');

    widget.onStateChanged?.call(_currentState);
  }

  @override
  void clearError() {
    setStateWithMonitoring(() {
      _currentState = _currentState.clearError();
    }, 'Clear error');
  }

  @override
  Task? getTaskById(String id) {
    return _currentState.getTaskById(id);
  }

  @override
  List<String> get allTags => _currentState.allTags;

  @override
  Future<void> batchUpdateTasks(List<Task> tasks) async {
    await performanceMonitor.startTiming('batch_update');

    try {
      setStateWithMonitoring(() {
        _currentState = _currentState.loading(OperationType.updateTask);
      }, 'Batch update - loading');

      // Simulate batch API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Apply all updates in a single setState
      batchSetState(
        tasks.map((task) => () {
          _currentState = _currentState.updateTask(task);
        }).toList(),
        'Batch update ${tasks.length} tasks',
      );

      setStateWithMonitoring(() {
        _currentState = _currentState.success();
      }, 'Batch update - success');

      widget.onStateChanged?.call(_currentState);

    } catch (error) {
      setStateWithMonitoring(() {
        _currentState = _currentState.error('Failed to batch update: $error');
      }, 'Batch update - error');
    } finally {
      performanceMonitor.endTiming('batch_update', MetricType.setState, widgetName);
    }
  }

  @override
  Future<void> refreshTasks() async {
    await performanceMonitor.startTiming('refresh_tasks');

    try {
      setStateWithMonitoring(() {
        _currentState = _currentState.loading(OperationType.loadTasks);
      }, 'Refresh tasks - loading');

      // Simulate refresh delay
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, this would reload from the server
      setStateWithMonitoring(() {
        _currentState = _currentState.success();
      }, 'Refresh tasks - success');

      widget.onStateChanged?.call(_currentState);

    } catch (error) {
      setStateWithMonitoring(() {
        _currentState = _currentState.error('Failed to refresh: $error');
      }, 'Refresh tasks - error');
    } finally {
      performanceMonitor.endTiming('refresh_tasks', MetricType.setState, widgetName);
    }
  }

  @override
  void updatePerformanceMetrics(Map<String, dynamic> metrics) {
    setStateWithMonitoring(() {
      _currentState = _currentState.updatePerformanceMetrics(metrics);
    }, 'Update performance metrics');
  }

  /// Demonstrate memory leak prevention
  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
    _initializationCompleter?.complete();
    _initializationCompleter = null;
    super.dispose();
  }
}

/// Abstract interface for task controller state
/// 
/// Defines the contract for task state management operations
/// to ensure consistent API across different implementations.
abstract class TaskControllerState {
  /// Current application state
  AppState get currentState;

  /// List of all tasks
  List<Task> get tasks;

  /// List of filtered tasks
  List<Task> get filteredTasks;

  /// Current filter configuration
  TaskFilter get filter;

  /// Current loading state
  LoadingState get loadingState;

  /// Current error message
  String? get errorMessage;

  /// Task statistics
  TaskStatistics get statistics;

  /// Filtered task statistics
  TaskStatistics get filteredStatistics;

  /// Whether the controller is initialized
  bool get isInitialized;

  /// All unique tags
  List<String> get allTags;

  /// Wait for controller initialization
  Future<void> waitForInitialization();

  /// Create a new task
  Future<void> createTask(Task task);

  /// Update an existing task
  Future<void> updateTask(Task updatedTask);

  /// Delete a task
  Future<void> deleteTask(String taskId);

  /// Toggle task status (pending → in progress → completed)
  Future<void> toggleTaskStatus(String taskId);

  /// Update the current filter
  void updateFilter(TaskFilter newFilter);

  /// Clear all filters
  void clearFilter();

  /// Search tasks by query
  void searchTasks(String query);

  /// Select a task
  void selectTask(String? taskId);

  /// Clear current error
  void clearError();

  /// Get task by ID
  Task? getTaskById(String id);

  /// Batch update multiple tasks
  Future<void> batchUpdateTasks(List<Task> tasks);

  /// Refresh tasks from source
  Future<void> refreshTasks();

  /// Update performance metrics
  void updatePerformanceMetrics(Map<String, dynamic> metrics);
}