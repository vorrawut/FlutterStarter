# 🔄 Workshop

## 🎯 **What We're Building**

Create a **comprehensive task management application** that demonstrates mastery of StatefulWidget lifecycle and setState patterns:
- **Interactive Task Manager** with create, read, update, delete operations
- **Lifecycle Demonstration** showing all StatefulWidget lifecycle methods
- **State Lifting Examples** with parent-child communication patterns
- **Performance Optimization** with efficient rebuilding strategies
- **Error Handling** with validation and async operation management
- **Clean Architecture** applying separation of concerns to state management

## ✅ **Expected Outcome**

A professional task management app featuring:
- 📝 **Task Management** - Create, edit, complete, and delete tasks with local state
- 🔄 **Lifecycle Awareness** - Proper resource management and cleanup
- ⚡ **Performance Optimized** - Efficient state updates and minimal rebuilds
- 🎯 **State Architecture** - Clean separation between UI and business logic
- ✅ **Error Handling** - Robust validation and async operation management
- 🧪 **Comprehensive Testing** - Unit and widget tests for all state operations

## 🏗️ **Project Structure**

We'll build a clean architecture task management system:

```
lib/
├── core/
│   ├── models/                   # 📊 Data models
│   │   ├── task.dart            # Task entity with immutable patterns
│   │   ├── task_filter.dart     # Filter options for tasks
│   │   └── app_state.dart       # Application state model
│   ├── repositories/            # 📚 Data access layer
│   │   ├── task_repository.dart     # Abstract task repository
│   │   └── local_task_repository.dart # Local storage implementation
│   ├── services/                # 🔧 Business services
│   │   ├── task_service.dart    # Task business logic
│   │   └── validation_service.dart # Input validation
│   └── utils/
│       ├── lifecycle_logger.dart   # Lifecycle debugging utility
│       └── performance_monitor.dart # Performance monitoring
├── presentation/
│   ├── controllers/             # 🎛️ State management
│   │   ├── task_controller.dart     # Main task state controller
│   │   └── filter_controller.dart   # Filter state management
│   ├── screens/                 # 📱 Screen widgets
│   │   ├── task_list_screen.dart    # Main task list view
│   │   ├── task_detail_screen.dart  # Task creation/editing
│   │   └── lifecycle_demo_screen.dart # Lifecycle demonstration
│   ├── widgets/                 # 🧩 Reusable components
│   │   ├── task_item.dart           # Individual task widget
│   │   ├── task_form.dart           # Task creation/edit form
│   │   ├── task_filter_bar.dart     # Filter selection widget
│   │   ├── empty_state.dart         # Empty state display
│   │   └── loading_indicator.dart   # Loading state widget
│   └── mixins/                  # 🔄 Reusable behaviors
│       ├── lifecycle_mixin.dart     # Lifecycle logging mixin
│       └── validation_mixin.dart    # Input validation mixin
└── main.dart                    # 🚀 Application entry point
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Core Data Models** ⏱️ *15 minutes*

Create immutable data models with proper state management patterns:

```dart
// lib/core/models/task.dart
import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { pending, inProgress, completed, cancelled }

/// Immutable task model following best practices
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<String> tags;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
  });

  /// Create a copy with updated properties - essential for immutable state
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
    );
  }

  /// Mark task as completed
  Task markCompleted() {
    return copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Get priority color for UI
  Color get priorityColor {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  /// Factory constructor for creating new tasks
  factory Task.create({
    required String title,
    required String description,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      tags: tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        createdAt,
        dueDate,
        completedAt,
        tags,
      ];

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, priority: $priority)';
  }
}

// lib/core/models/task_filter.dart
import 'package:equatable/equatable.dart';
import 'task.dart';

/// Filter configuration for task lists
class TaskFilter extends Equatable {
  final TaskStatus? status;
  final TaskPriority? priority;
  final bool showOverdueOnly;
  final String searchQuery;
  final List<String> selectedTags;

  const TaskFilter({
    this.status,
    this.priority,
    this.showOverdueOnly = false,
    this.searchQuery = '',
    this.selectedTags = const [],
  });

  TaskFilter copyWith({
    TaskStatus? status,
    TaskPriority? priority,
    bool? showOverdueOnly,
    String? searchQuery,
    List<String>? selectedTags,
  }) {
    return TaskFilter(
      status: status ?? this.status,
      priority: priority ?? this.priority,
      showOverdueOnly: showOverdueOnly ?? this.showOverdueOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }

  /// Apply filter to a list of tasks
  List<Task> apply(List<Task> tasks) {
    return tasks.where((task) {
      // Status filter
      if (status != null && task.status != status) return false;
      
      // Priority filter
      if (priority != null && task.priority != priority) return false;
      
      // Overdue filter
      if (showOverdueOnly && !task.isOverdue) return false;
      
      // Search query filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!task.title.toLowerCase().contains(query) &&
            !task.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Tags filter
      if (selectedTags.isNotEmpty) {
        if (!selectedTags.any((tag) => task.tags.contains(tag))) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }

  /// Check if filter has any active conditions
  bool get hasActiveFilters {
    return status != null ||
           priority != null ||
           showOverdueOnly ||
           searchQuery.isNotEmpty ||
           selectedTags.isNotEmpty;
  }

  /// Clear all filters
  TaskFilter clear() {
    return const TaskFilter();
  }

  @override
  List<Object?> get props => [
        status,
        priority,
        showOverdueOnly,
        searchQuery,
        selectedTags,
      ];
}

// lib/core/models/app_state.dart
import 'package:equatable/equatable.dart';
import 'task.dart';
import 'task_filter.dart';

/// Application state container
class AppState extends Equatable {
  final List<Task> tasks;
  final TaskFilter currentFilter;
  final bool isLoading;
  final String? errorMessage;
  final Task? selectedTask;

  const AppState({
    this.tasks = const [],
    this.currentFilter = const TaskFilter(),
    this.isLoading = false,
    this.errorMessage,
    this.selectedTask,
  });

  AppState copyWith({
    List<Task>? tasks,
    TaskFilter? currentFilter,
    bool? isLoading,
    String? errorMessage,
    Task? selectedTask,
  }) {
    return AppState(
      tasks: tasks ?? this.tasks,
      currentFilter: currentFilter ?? this.currentFilter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTask: selectedTask ?? this.selectedTask,
    );
  }

  /// Get filtered tasks based on current filter
  List<Task> get filteredTasks => currentFilter.apply(tasks);

  /// Get task statistics
  Map<String, int> get taskStats {
    return {
      'total': tasks.length,
      'completed': tasks.where((t) => t.status == TaskStatus.completed).length,
      'pending': tasks.where((t) => t.status == TaskStatus.pending).length,
      'overdue': tasks.where((t) => t.isOverdue).length,
    };
  }

  /// Clear error state
  AppState clearError() => copyWith(errorMessage: null);

  /// Set loading state
  AppState setLoading(bool loading) => copyWith(isLoading: loading);

  @override
  List<Object?> get props => [
        tasks,
        currentFilter,
        isLoading,
        errorMessage,
        selectedTask,
      ];
}
```

### **Step 2: Lifecycle Monitoring Utilities** ⏱️ *10 minutes*

Create utilities for monitoring widget lifecycle and performance:

```dart
// lib/core/utils/lifecycle_logger.dart
import 'package:flutter/material.dart';

/// Utility for logging widget lifecycle events
class LifecycleLogger {
  final String widgetName;
  final bool enableLogging;

  const LifecycleLogger({
    required this.widgetName,
    this.enableLogging = true,
  });

  void logCreateState() {
    if (enableLogging) {
      debugPrint('📦 [$widgetName] createState() called');
    }
  }

  void logInitState() {
    if (enableLogging) {
      debugPrint('🚀 [$widgetName] initState() called');
    }
  }

  void logDidChangeDependencies() {
    if (enableLogging) {
      debugPrint('🔄 [$widgetName] didChangeDependencies() called');
    }
  }

  void logBuild() {
    if (enableLogging) {
      debugPrint('🏗️ [$widgetName] build() called');
    }
  }

  void logDidUpdateWidget() {
    if (enableLogging) {
      debugPrint('🔄 [$widgetName] didUpdateWidget() called');
    }
  }

  void logDeactivate() {
    if (enableLogging) {
      debugPrint('⏸️ [$widgetName] deactivate() called');
    }
  }

  void logDispose() {
    if (enableLogging) {
      debugPrint('🗑️ [$widgetName] dispose() called');
    }
  }

  void logSetState(String reason) {
    if (enableLogging) {
      debugPrint('⚡ [$widgetName] setState() called - $reason');
    }
  }

  void logError(Object error, StackTrace stackTrace) {
    if (enableLogging) {
      debugPrint('❌ [$widgetName] Error: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}

// lib/presentation/mixins/lifecycle_mixin.dart
import 'package:flutter/material.dart';
import '../../core/utils/lifecycle_logger.dart';

/// Mixin that adds lifecycle logging to StatefulWidget
mixin LifecycleMixin<T extends StatefulWidget> on State<T> {
  late LifecycleLogger _logger;

  @override
  void initState() {
    super.initState();
    _logger = LifecycleLogger(widgetName: widget.runtimeType.toString());
    _logger.logInitState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.logDidChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _logger.logBuild();
    return buildWithLogging(context);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.logDidUpdateWidget();
  }

  @override
  void deactivate() {
    _logger.logDeactivate();
    super.deactivate();
  }

  @override
  void dispose() {
    _logger.logDispose();
    super.dispose();
  }

  /// Wrapper for setState with logging
  void setStateWithLogging(VoidCallback fn, String reason) {
    _logger.logSetState(reason);
    setState(fn);
  }

  /// Method that subclasses must implement instead of build
  Widget buildWithLogging(BuildContext context);

  /// Access to logger for custom logging
  LifecycleLogger get logger => _logger;
}

// lib/core/utils/performance_monitor.dart
import 'package:flutter/material.dart';

/// Performance monitoring utility for setState operations
class PerformanceMonitor {
  static final Map<String, List<Duration>> _measurements = {};
  static final Map<String, DateTime> _startTimes = {};

  /// Start measuring performance for a specific operation
  static void startMeasurement(String operationName) {
    _startTimes[operationName] = DateTime.now();
  }

  /// End measurement and log results
  static void endMeasurement(String operationName) {
    final startTime = _startTimes[operationName];
    if (startTime == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    
    _measurements.putIfAbsent(operationName, () => []);
    _measurements[operationName]!.add(duration);
    
    debugPrint('⏱️ [$operationName] took ${duration.inMicroseconds}μs');
    
    _startTimes.remove(operationName);
  }

  /// Get average performance for an operation
  static Duration? getAveragePerformance(String operationName) {
    final measurements = _measurements[operationName];
    if (measurements == null || measurements.isEmpty) return null;

    final totalMicroseconds = measurements
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b);
    
    return Duration(microseconds: totalMicroseconds ~/ measurements.length);
  }

  /// Clear all measurements
  static void clearMeasurements() {
    _measurements.clear();
    _startTimes.clear();
  }

  /// Get performance report
  static Map<String, Map<String, dynamic>> getPerformanceReport() {
    final report = <String, Map<String, dynamic>>{};
    
    for (final entry in _measurements.entries) {
      final measurements = entry.value;
      if (measurements.isNotEmpty) {
        final totalMicroseconds = measurements
            .map((d) => d.inMicroseconds)
            .reduce((a, b) => a + b);
        
        report[entry.key] = {
          'count': measurements.length,
          'average': Duration(microseconds: totalMicroseconds ~/ measurements.length),
          'min': measurements.reduce((a, b) => a < b ? a : b),
          'max': measurements.reduce((a, b) => a > b ? a : b),
          'total': Duration(microseconds: totalMicroseconds),
        };
      }
    }
    
    return report;
  }
}
```

### **Step 3: Task Management State Controller** ⏱️ *25 minutes*

Create the main state controller with proper StatefulWidget patterns:

```dart
// lib/presentation/controllers/task_controller.dart
import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../../core/models/app_state.dart';
import '../../core/utils/performance_monitor.dart';
import '../mixins/lifecycle_mixin.dart';

/// Main task management controller demonstrating setState best practices
class TaskController extends StatefulWidget {
  final Widget Function(BuildContext context, AppState state, TaskController controller) builder;

  const TaskController({
    super.key,
    required this.builder,
  });

  @override
  State<TaskController> createState() {
    logger.logCreateState();
    return _TaskControllerState();
  }

  static const logger = LifecycleLogger(widgetName: 'TaskController');
}

class _TaskControllerState extends State<TaskController> 
    with LifecycleMixin<TaskController>, TickerProviderStateMixin {
  
  AppState _appState = const AppState();
  late AnimationController _loadingController;
  Timer? _autoSaveTimer;

  // Getters for accessing state
  AppState get appState => _appState;
  List<Task> get tasks => _appState.tasks;
  List<Task> get filteredTasks => _appState.filteredTasks;
  bool get isLoading => _appState.isLoading;
  String? get errorMessage => _appState.errorMessage;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Load initial data
    _loadTasks();
    
    // Set up auto-save timer
    _setupAutoSave();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Example of accessing inherited widgets safely
    final theme = Theme.of(context);
    logger.logBuild(); // Custom logging
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  /// Load tasks from repository (simulated)
  Future<void> _loadTasks() async {
    PerformanceMonitor.startMeasurement('loadTasks');
    
    setStateWithLogging(() {
      _appState = _appState.setLoading(true).clearError();
    }, 'starting task load');

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate sample tasks
      final sampleTasks = _generateSampleTasks();
      
      if (mounted) {
        setStateWithLogging(() {
          _appState = _appState.copyWith(
            tasks: sampleTasks,
            isLoading: false,
          );
        }, 'tasks loaded successfully');
      }
    } catch (error) {
      if (mounted) {
        setStateWithLogging(() {
          _appState = _appState.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load tasks: $error',
          );
        }, 'task load failed');
      }
    } finally {
      PerformanceMonitor.endMeasurement('loadTasks');
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    PerformanceMonitor.startMeasurement('addTask');
    
    setStateWithLogging(() {
      _appState = _appState.setLoading(true);
    }, 'adding new task');

    try {
      // Simulate save operation
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setStateWithLogging(() {
          final updatedTasks = List<Task>.from(_appState.tasks)..add(task);
          _appState = _appState.copyWith(
            tasks: updatedTasks,
            isLoading: false,
          );
        }, 'task added successfully');
      }
    } catch (error) {
      if (mounted) {
        setStateWithLogging(() {
          _appState = _appState.copyWith(
            isLoading: false,
            errorMessage: 'Failed to add task: $error',
          );
        }, 'add task failed');
      }
    } finally {
      PerformanceMonitor.endMeasurement('addTask');
    }
  }

  /// Update existing task
  Future<void> updateTask(Task updatedTask) async {
    PerformanceMonitor.startMeasurement('updateTask');
    
    setStateWithLogging(() {
      _appState = _appState.setLoading(true);
    }, 'updating task');

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        setStateWithLogging(() {
          final updatedTasks = _appState.tasks.map((task) {
            return task.id == updatedTask.id ? updatedTask : task;
          }).toList();
          
          _appState = _appState.copyWith(
            tasks: updatedTasks,
            isLoading: false,
          );
        }, 'task updated successfully');
      }
    } catch (error) {
      if (mounted) {
        setStateWithLogging(() {
          _appState = _appState.copyWith(
            isLoading: false,
            errorMessage: 'Failed to update task: $error',
          );
        }, 'update task failed');
      }
    } finally {
      PerformanceMonitor.endMeasurement('updateTask');
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    PerformanceMonitor.startMeasurement('deleteTask');
    
    // Optimistic update - remove immediately, add back if fails
    final taskToDelete = _appState.tasks.firstWhere((t) => t.id == taskId);
    
    setStateWithLogging(() {
      final updatedTasks = _appState.tasks.where((t) => t.id != taskId).toList();
      _appState = _appState.copyWith(tasks: updatedTasks);
    }, 'optimistic delete');

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Success - task already removed
    } catch (error) {
      if (mounted) {
        // Rollback - add task back
        setStateWithLogging(() {
          final rollbackTasks = List<Task>.from(_appState.tasks)..add(taskToDelete);
          _appState = _appState.copyWith(
            tasks: rollbackTasks,
            errorMessage: 'Failed to delete task: $error',
          );
        }, 'delete rollback');
      }
    } finally {
      PerformanceMonitor.endMeasurement('deleteTask');
    }
  }

  /// Toggle task completion status
  void toggleTaskCompletion(String taskId) {
    PerformanceMonitor.startMeasurement('toggleTask');
    
    final task = _appState.tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.status == TaskStatus.completed
        ? task.copyWith(status: TaskStatus.pending, completedAt: null)
        : task.markCompleted();
    
    setStateWithLogging(() {
      final updatedTasks = _appState.tasks.map((t) {
        return t.id == taskId ? updatedTask : t;
      }).toList();
      
      _appState = _appState.copyWith(tasks: updatedTasks);
    }, 'task completion toggled');
    
    PerformanceMonitor.endMeasurement('toggleTask');
  }

  /// Apply filter to tasks
  void applyFilter(TaskFilter filter) {
    setStateWithLogging(() {
      _appState = _appState.copyWith(currentFilter: filter);
    }, 'filter applied');
  }

  /// Clear all filters
  void clearFilters() {
    setStateWithLogging(() {
      _appState = _appState.copyWith(currentFilter: const TaskFilter());
    }, 'filters cleared');
  }

  /// Clear error message
  void clearError() {
    setStateWithLogging(() {
      _appState = _appState.clearError();
    }, 'error cleared');
  }

  /// Refresh tasks
  Future<void> refresh() async {
    await _loadTasks();
  }

  /// Setup auto-save functionality
  void _setupAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted && _appState.tasks.isNotEmpty) {
        logger.logSetState('auto-save triggered');
        // In a real app, this would save to local storage
        debugPrint('🔄 Auto-save triggered - ${_appState.tasks.length} tasks');
      }
    });
  }

  /// Generate sample tasks for demonstration
  List<Task> _generateSampleTasks() {
    return [
      Task.create(
        title: 'Learn Flutter State Management',
        description: 'Master setState and StatefulWidget patterns',
        priority: TaskPriority.high,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        tags: ['learning', 'flutter'],
      ),
      Task.create(
        title: 'Build Task Manager App',
        description: 'Create a comprehensive task management application',
        priority: TaskPriority.medium,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        tags: ['project', 'flutter'],
      ),
      Task.create(
        title: 'Write Unit Tests',
        description: 'Add comprehensive test coverage for task operations',
        priority: TaskPriority.medium,
        tags: ['testing', 'quality'],
      ),
      Task.create(
        title: 'Code Review',
        description: 'Review task management implementation',
        priority: TaskPriority.low,
        dueDate: DateTime.now().subtract(const Duration(days: 1)), // Overdue
        tags: ['review'],
      ),
      Task.create(
        title: 'Deploy to Production',
        description: 'Deploy the task manager to production environment',
        priority: TaskPriority.urgent,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['deployment', 'production'],
      ),
    ];
  }

  @override
  Widget buildWithLogging(BuildContext context) {
    return widget.builder(context, _appState, widget);
  }
}
```

*This is part 1 of the workshop. Continue with the remaining steps to build the complete task management application...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_10

# Install dependencies
flutter pub get

# Run the app
flutter run

# Test lifecycle events
# 1. Navigate between screens to see lifecycle logs
# 2. Create, edit, and delete tasks
# 3. Apply filters and observe state changes
# 4. Monitor performance in debug output
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **StatefulWidget Lifecycle** - Complete understanding of all lifecycle methods and their proper usage
- **setState Patterns** - Efficient state updates with performance optimization
- **State Architecture** - Clean separation of concerns with immutable state objects
- **Error Handling** - Robust async operation management with proper error states
- **Performance Monitoring** - Tools and techniques for measuring setState performance
- **Testing Strategies** - Comprehensive testing approaches for stateful widgets

**Ready to master the foundation of Flutter state management? 🔄✨**