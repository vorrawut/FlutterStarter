/// Main task list screen with comprehensive state management
/// 
/// This file demonstrates professional StatefulWidget patterns by integrating
/// all components into a cohesive task management experience.
library;

import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../../core/models/task_filter.dart';
import '../../core/models/app_state.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_item.dart';
import '../widgets/task_form.dart';
import '../widgets/empty_state.dart';
import '../mixins/lifecycle_mixin.dart';

/// Main task list screen demonstrating complete state management
/// 
/// Showcases StatefulWidget patterns, lifecycle management, performance
/// optimization, and integration of multiple stateful components.
class TaskListScreen extends StatefulWidget {
  /// Creates a task list screen
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with TickerProviderStateMixin, LifecycleMixin<TaskListScreen> {

  /// Animation controllers for screen transitions
  late AnimationController _refreshController;
  late AnimationController _fabController;
  late AnimationController _filterController;

  /// Animations
  late Animation<double> _refreshAnimation;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _filterSlideAnimation;

  /// UI state
  bool _isSearchVisible = false;
  bool _isFilterVisible = false;
  String? _selectedTaskId;
  
  /// Controllers
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  /// Performance tracking
  DateTime? _lastScrollUpdate;
  int _buildCount = 0;

  @override
  String get widgetName => 'TaskListScreen';

  @override
  bool get enableLifecycleLogging => true;

  @override
  bool get enablePerformanceMonitoring => true;

  @override
  void onInitStateCallback() {
    _initializeControllers();
    _initializeAnimations();
    _setupScrollListener();
  }

  @override
  void onDisposeCallback() {
    _disposeControllers();
    _disposeAnimations();
  }

  /// Initialize controllers
  void _initializeControllers() {
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  /// Initialize animations
  void _initializeAnimations() {
    // Refresh animation
    _refreshController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_refreshController);

    // FAB animation
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));

    // Filter panel animation
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _filterSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _filterController,
      curve: Curves.easeOut,
    ));
  }

  /// Setup scroll listener for performance monitoring
  void _setupScrollListener() {
    _scrollController.addListener(() {
      final now = DateTime.now();
      if (_lastScrollUpdate == null || 
          now.difference(_lastScrollUpdate!).inMilliseconds > 16) {
        _lastScrollUpdate = now;
        
        // Hide/show FAB based on scroll direction
        if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (_fabController.value == 0.0) {
            _fabController.forward();
          }
        } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (_fabController.value == 1.0) {
            _fabController.reverse();
          }
        }
      }
    });
  }

  /// Dispose controllers
  void _disposeControllers() {
    _searchController.dispose();
    _scrollController.dispose();
  }

  /// Dispose animations
  void _disposeAnimations() {
    _refreshController.dispose();
    _fabController.dispose();
    _filterController.dispose();
  }

  /// Toggle search visibility
  void _toggleSearch() {
    setStateWithMonitoring(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _clearSearch();
      }
    }, 'Toggle search: $_isSearchVisible');
  }

  /// Toggle filter visibility
  void _toggleFilter() {
    setStateWithMonitoring(() {
      _isFilterVisible = !_isFilterVisible;
    }, 'Toggle filter: $_isFilterVisible');

    if (_isFilterVisible) {
      _filterController.forward();
    } else {
      _filterController.reverse();
    }
  }

  /// Handle search
  void _handleSearch(String query) {
    final controller = TaskController.of(context);
    controller.searchTasks(query);
  }

  /// Clear search
  void _clearSearch() {
    final controller = TaskController.of(context);
    _searchController.clear();
    controller.searchTasks('');
  }

  /// Handle refresh
  Future<void> _handleRefresh() async {
    _refreshController.forward();
    
    try {
      final controller = TaskController.of(context);
      await controller.refreshTasks();
    } finally {
      if (mounted) {
        _refreshController.reverse();
      }
    }
  }

  /// Show create task form
  void _showCreateTaskForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskForm(
          title: 'Create Task',
          onSubmit: (task) async {
            final controller = TaskController.of(context);
            await controller.createTask(task);
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task created successfully!')),
              );
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  /// Show edit task form
  void _showEditTaskForm(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskForm(
          title: 'Edit Task',
          submitLabel: 'Update Task',
          initialTask: task,
          onSubmit: (updatedTask) async {
            final controller = TaskController.of(context);
            await controller.updateTask(updatedTask);
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task updated successfully!')),
              );
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  /// Show delete confirmation
  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final controller = TaskController.of(context);
              await controller.deleteTask(task.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task deleted successfully!')),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Handle task selection
  void _handleTaskTap(Task task) {
    setStateWithMonitoring(() {
      _selectedTaskId = _selectedTaskId == task.id ? null : task.id;
    }, 'Select task: ${task.id}');

    final controller = TaskController.of(context);
    controller.selectTask(_selectedTaskId);
  }

  /// Handle task status toggle
  Future<void> _handleTaskStatusToggle(Task task) async {
    final controller = TaskController.of(context);
    await controller.toggleTaskStatus(task.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    _buildCount++;
    
    return TaskController(
      onStateChanged: (state) {
        // Handle state changes for performance monitoring
        final metrics = {
          'buildCount': _buildCount,
          'lastUpdate': DateTime.now().millisecondsSinceEpoch,
          'taskCount': state.tasks.length,
          'filteredTaskCount': state.filteredTasks.length,
        };
        
        final controller = TaskController.of(context);
        controller.updatePerformanceMetrics(metrics);
      },
      child: (controller) => _buildScaffold(context, controller),
    );
  }

  /// Build main scaffold
  Widget _buildScaffold(BuildContext context, TaskControllerState controller) {
    return Scaffold(
      appBar: _buildAppBar(context, controller),
      body: _buildBody(context, controller),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Build app bar with search and filter
  PreferredSizeWidget _buildAppBar(BuildContext context, TaskControllerState controller) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: _isSearchVisible 
          ? _buildSearchField(controller)
          : const Text('Task Manager'),
      actions: [
        // Search toggle
        IconButton(
          onPressed: _toggleSearch,
          icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
        ),
        
        // Filter toggle
        IconButton(
          onPressed: _toggleFilter,
          icon: const Icon(Icons.filter_list),
        ),
        
        // Refresh
        AnimatedBuilder(
          animation: _refreshAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _refreshAnimation.value * 2 * 3.14159,
              child: IconButton(
                onPressed: _handleRefresh,
                icon: const Icon(Icons.refresh),
              ),
            );
          },
        ),
        
        // Statistics menu
        _buildStatisticsMenu(controller),
      ],
      bottom: _isFilterVisible ? _buildFilterBar(controller) : null,
    );
  }

  /// Build search field
  Widget _buildSearchField(TaskControllerState controller) {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Search tasks...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      autofocus: true,
      onChanged: _handleSearch,
      onSubmitted: _handleSearch,
    );
  }

  /// Build filter bar
  PreferredSizeWidget _buildFilterBar(TaskControllerState controller) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: SlideTransition(
        position: _filterSlideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          child: Row(
            children: [
              // Status filter
              Expanded(child: _buildStatusFilter(controller)),
              const SizedBox(width: 8),
              
              // Priority filter
              Expanded(child: _buildPriorityFilter(controller)),
              const SizedBox(width: 8),
              
              // Clear filters
              IconButton(
                onPressed: () {
                  controller.clearFilter();
                  setStateWithMonitoring(() {
                    _isFilterVisible = false;
                  }, 'Clear filters');
                  _filterController.reverse();
                },
                icon: const Icon(Icons.clear),
                tooltip: 'Clear filters',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build status filter dropdown
  Widget _buildStatusFilter(TaskControllerState controller) {
    return DropdownButtonFormField<TaskStatus?>(
      value: controller.filter.statusFilter,
      decoration: const InputDecoration(
        labelText: 'Status',
        isDense: true,
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Statuses')),
        ...TaskStatus.values.map((status) => DropdownMenuItem(
          value: status,
          child: Text(status.label),
        )),
      ],
      onChanged: (status) {
        controller.updateFilter(controller.filter.copyWith(statusFilter: status));
      },
    );
  }

  /// Build priority filter dropdown
  Widget _buildPriorityFilter(TaskControllerState controller) {
    return DropdownButtonFormField<TaskPriority?>(
      value: controller.filter.priorityFilter,
      decoration: const InputDecoration(
        labelText: 'Priority',
        isDense: true,
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Priorities')),
        ...TaskPriority.values.map((priority) => DropdownMenuItem(
          value: priority,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: TaskPriority.getColor(priority),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(priority.label),
            ],
          ),
        )),
      ],
      onChanged: (priority) {
        controller.updateFilter(controller.filter.copyWith(priorityFilter: priority));
      },
    );
  }

  /// Build statistics menu
  Widget _buildStatisticsMenu(TaskControllerState controller) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.analytics),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'stats',
          child: const Text('View Statistics'),
        ),
        PopupMenuItem(
          value: 'performance',
          child: const Text('Performance Metrics'),
        ),
        PopupMenuItem(
          value: 'lifecycle',
          child: const Text('Lifecycle Logs'),
        ),
      ],
      onSelected: (value) => _handleMenuAction(value, controller),
    );
  }

  /// Handle menu actions
  void _handleMenuAction(String action, TaskControllerState controller) {
    switch (action) {
      case 'stats':
        _showStatistics(controller);
        break;
      case 'performance':
        _showPerformanceMetrics();
        break;
      case 'lifecycle':
        _showLifecycleLogs();
        break;
    }
  }

  /// Show statistics dialog
  void _showStatistics(TaskControllerState controller) {
    final stats = controller.statistics;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Task Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Tasks: ${stats.total}'),
            Text('Pending: ${stats.pending}'),
            Text('In Progress: ${stats.inProgress}'),
            Text('Completed: ${stats.completed}'),
            Text('Completion Rate: ${(stats.completionRate * 100).toStringAsFixed(1)}%'),
            if (stats.overdue > 0) Text('Overdue: ${stats.overdue}'),
            if (stats.dueSoon > 0) Text('Due Soon: ${stats.dueSoon}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show performance metrics
  void _showPerformanceMetrics() {
    final performanceStats = getPerformanceStatistics();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Performance Metrics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build Count: $_buildCount'),
            Text('Performance Grade: ${getPerformanceGrade()}'),
            const SizedBox(height: 8),
            ...performanceStats.entries.map((entry) {
              final stats = entry.value;
              return Text('${entry.key.label}: ${stats.count} calls, '
                         'avg: ${stats.averageDuration.inMicroseconds}μs');
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show lifecycle logs
  void _showLifecycleLogs() {
    final logs = exportLifecycleLog();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lifecycle Logs'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              logs,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Build main body
  Widget _buildBody(BuildContext context, TaskControllerState controller) {
    // Handle loading state
    if (controller.loadingState.isLoading && controller.tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading tasks...'),
          ],
        ),
      );
    }

    // Handle error state
    if (controller.loadingState.isError) {
      return CustomEmptyState(
        config: EmptyStateConfigs.error.copyWith(
          message: controller.errorMessage ?? 'An error occurred',
        ),
        onAction: () => controller.clearError(),
        onSecondaryAction: _handleRefresh,
      );
    }

    // Handle empty state
    if (controller.filteredTasks.isEmpty) {
      if (controller.filter.hasActiveFilters) {
        return CustomEmptyState(
          config: EmptyStateConfigs.noFilteredTasks,
          onAction: () => controller.clearFilter(),
          onSecondaryAction: _showCreateTaskForm,
        );
      } else {
        return CustomEmptyState(
          config: EmptyStateConfigs.noTasks,
          onAction: _showCreateTaskForm,
        );
      }
    }

    // Build task list
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: controller.filteredTasks.length,
        itemBuilder: (context, index) {
          final task = controller.filteredTasks[index];
          return TaskItem(
            key: ValueKey(task.id),
            task: task,
            isSelected: _selectedTaskId == task.id,
            onTap: () => _handleTaskTap(task),
            onToggleStatus: () => _handleTaskStatusToggle(task),
            onEdit: () => _showEditTaskForm(task),
            onDelete: () => _showDeleteConfirmation(task),
          );
        },
      ),
    );
  }

  /// Build floating action button
  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - _fabScaleAnimation.value,
          child: FloatingActionButton(
            onPressed: _showCreateTaskForm,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}