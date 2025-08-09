# 🔄 Lesson 10: setState & Stateful Widgets - Workshop (Part 2)

## **Step 4: Task UI Components** ⏱️ *25 minutes*

Build reusable UI components with proper state management patterns:

```dart
// lib/presentation/widgets/task_item.dart
import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../mixins/lifecycle_mixin.dart';

/// Individual task item widget demonstrating efficient setState usage
class TaskItem extends StatefulWidget {
  final Task task;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onCompletionChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
    this.onCompletionChanged,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> 
    with LifecycleMixin<TaskItem>, SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isPressed = false;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setStateWithLogging(() {
      _isPressed = true;
    }, 'task item pressed');
    
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setStateWithLogging(() {
      _isPressed = false;
    }, 'task item released');
    
    _animationController.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setStateWithLogging(() {
      _isPressed = false;
    }, 'task item tap cancelled');
    
    _animationController.reverse();
  }

  void _toggleActions() {
    setStateWithLogging(() {
      _showActions = !_showActions;
    }, 'task actions toggled');
  }

  @override
  Widget buildWithLogging(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: _buildTaskCard(context),
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = widget.task.status == TaskStatus.completed;
    
    return Card(
      elevation: _isPressed ? 8 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onLongPress: _toggleActions,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isCompleted 
                ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskHeader(context),
              const SizedBox(height: 8),
              _buildTaskContent(context),
              if (widget.task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildTaskTags(context),
              ],
              if (_showActions) ...[
                const SizedBox(height: 12),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = widget.task.status == TaskStatus.completed;
    
    return Row(
      children: [
        // Completion checkbox
        GestureDetector(
          onTap: () {
            widget.onCompletionChanged?.call(!isCompleted);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted 
                  ? theme.colorScheme.primary 
                  : Colors.transparent,
              border: Border.all(
                color: isCompleted 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.outline,
                width: 2,
              ),
            ),
            child: isCompleted
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  )
                : null,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Task title
        Expanded(
          child: Text(
            widget.task.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted 
                  ? theme.colorScheme.onSurfaceVariant 
                  : theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Priority indicator
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: widget.task.priorityColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskContent(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = widget.task.status == TaskStatus.completed;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        if (widget.task.description.isNotEmpty)
          Text(
            widget.task.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isCompleted 
                  ? theme.colorScheme.onSurfaceVariant 
                  : theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        
        // Due date and status
        const SizedBox(height: 4),
        Row(
          children: [
            if (widget.task.dueDate != null) ...[
              Icon(
                Icons.schedule,
                size: 16,
                color: widget.task.isOverdue 
                    ? theme.colorScheme.error 
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(widget.task.dueDate!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: widget.task.isOverdue 
                      ? theme.colorScheme.error 
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            
            const Spacer(),
            
            // Status chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(widget.task.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.task.status.name.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(widget.task.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskTags(BuildContext context) {
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: widget.task.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.edit,
          label: 'Edit',
          onPressed: widget.onEdit,
        ),
        _buildActionButton(
          icon: Icons.delete,
          label: 'Delete',
          onPressed: widget.onDelete,
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: buttonColor, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: buttonColor),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference < 0) return '${-difference} days overdue';
    return 'In $difference days';
  }

  Color _getStatusColor(TaskStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case TaskStatus.pending:
        return theme.colorScheme.secondary;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return theme.colorScheme.error;
    }
  }
}

// lib/presentation/widgets/task_form.dart
import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../mixins/lifecycle_mixin.dart';
import '../mixins/validation_mixin.dart';

/// Task creation/editing form with comprehensive validation
class TaskForm extends StatefulWidget {
  final Task? initialTask;
  final ValueChanged<Task> onSubmit;
  final VoidCallback? onCancel;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> 
    with LifecycleMixin<TaskForm>, ValidationMixin {
  
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _selectedDueDate;
  List<String> _tags = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    
    _titleController = TextEditingController(
      text: widget.initialTask?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialTask?.description ?? '',
    );
    _tagsController = TextEditingController();
    
    if (widget.initialTask != null) {
      _selectedPriority = widget.initialTask!.priority;
      _selectedDueDate = widget.initialTask!.dueDate;
      _tags = List.from(widget.initialTask!.tags);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (selectedDate != null) {
      setStateWithLogging(() {
        _selectedDueDate = selectedDate;
      }, 'due date selected');
    }
  }

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setStateWithLogging(() {
        _tags.add(tag);
        _tagsController.clear();
      }, 'tag added');
    }
  }

  void _removeTag(String tag) {
    setStateWithLogging(() {
      _tags.remove(tag);
    }, 'tag removed');
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setStateWithLogging(() {
      _isSubmitting = true;
    }, 'form submission started');

    try {
      // Create or update task
      final task = widget.initialTask?.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        tags: _tags,
      ) ?? Task.create(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        tags: _tags,
      );
      
      // Simulate processing time
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        widget.onSubmit(task);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setStateWithLogging(() {
          _isSubmitting = false;
        }, 'form submission completed');
      }
    }
  }

  @override
  Widget buildWithLogging(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTask != null ? 'Edit Task' : 'Create Task'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onCancel,
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('SAVE'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title *',
                hintText: 'Enter a descriptive title',
                border: OutlineInputBorder(),
              ),
              validator: validateRequired,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 16),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add more details about this task',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 16),
            
            // Priority selection
            _buildPrioritySection(),
            
            const SizedBox(height: 16),
            
            // Due date selection
            _buildDueDateSection(),
            
            const SizedBox(height: 16),
            
            // Tags section
            _buildTagsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TaskPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            return FilterChip(
              label: Text(priority.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setStateWithLogging(() {
                    _selectedPriority = priority;
                  }, 'priority changed');
                }
              },
              backgroundColor: priority.name == 'urgent' 
                  ? Colors.red.withOpacity(0.1)
                  : priority.name == 'high'
                      ? Colors.orange.withOpacity(0.1)
                      : null,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDueDateSection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDueDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedDueDate != null
                      ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                      : 'Select due date (optional)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _selectedDueDate != null
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (_selectedDueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setStateWithLogging(() {
                        _selectedDueDate = null;
                      }, 'due date cleared');
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        
        // Tag input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  hintText: 'Add a tag',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addTag,
              child: const Text('Add'),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Tag display
        if (_tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _tags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeTag(tag),
              );
            }).toList(),
          ),
      ],
    );
  }
}

// lib/presentation/mixins/validation_mixin.dart
mixin ValidationMixin {
  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  String? validateMinLength(String? value, int minLength) {
    if (value == null || value.trim().length < minLength) {
      return 'Must be at least $minLength characters long';
    }
    return null;
  }

  String? validateMaxLength(String? value, int maxLength) {
    if (value != null && value.trim().length > maxLength) {
      return 'Must be no more than $maxLength characters long';
    }
    return null;
  }
}
```

## **Step 5: Complete App Integration** ⏱️ *20 minutes*

Integrate all components into a working application:

```dart
// lib/presentation/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../../core/models/app_state.dart';
import '../../core/utils/performance_monitor.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_item.dart';
import '../widgets/task_form.dart';
import '../widgets/empty_state.dart';

/// Main task list screen demonstrating state lifting and performance optimization
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TaskController(
      builder: (context, appState, controller) {
        return Scaffold(
          appBar: _buildAppBar(context, appState),
          body: _buildBody(context, appState, controller),
          floatingActionButton: _buildFAB(context, controller),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppState appState) {
    return AppBar(
      title: const Text('Task Manager'),
      subtitle: _buildTaskStats(context, appState),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.analytics),
          onPressed: () => _showPerformanceReport(context),
        ),
      ],
    );
  }

  Widget? _buildTaskStats(BuildContext context, AppState appState) {
    final stats = appState.taskStats;
    return Text(
      '${stats['completed']}/${stats['total']} completed',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildBody(BuildContext context, AppState appState, TaskController controller) {
    if (appState.isLoading && appState.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appState.errorMessage != null) {
      return _buildErrorState(context, appState, controller);
    }

    if (appState.filteredTasks.isEmpty) {
      return EmptyState(
        title: appState.tasks.isEmpty ? 'No tasks yet' : 'No matching tasks',
        subtitle: appState.tasks.isEmpty 
            ? 'Create your first task to get started'
            : 'Try adjusting your filters',
        actionLabel: appState.tasks.isEmpty ? 'Create Task' : 'Clear Filters',
        onAction: appState.tasks.isEmpty 
            ? () => _showTaskForm(context, controller)
            : () => controller.clearFilters(),
      );
    }

    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () => controller.refresh(),
      child: _buildTaskList(context, appState, controller),
    );
  }

  Widget _buildErrorState(BuildContext context, AppState appState, TaskController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            appState.errorMessage!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              controller.clearError();
              controller.refresh();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, AppState appState, TaskController controller) {
    final tasks = appState.filteredTasks;
    
    return ListView.builder(
      itemCount: tasks.length + (appState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= tasks.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        final task = tasks[index];
        return TaskItem(
          key: ValueKey(task.id),
          task: task,
          onTap: () => _showTaskDetail(context, task),
          onCompletionChanged: (completed) {
            PerformanceMonitor.startMeasurement('toggleTaskFromList');
            controller.toggleTaskCompletion(task.id);
            PerformanceMonitor.endMeasurement('toggleTaskFromList');
          },
          onEdit: () => _showTaskForm(context, controller, task),
          onDelete: () => _confirmDelete(context, controller, task),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context, TaskController controller) {
    return FloatingActionButton(
      onPressed: () => _showTaskForm(context, controller),
      tooltip: 'Create Task',
      child: const Icon(Icons.add),
    );
  }

  void _showTaskForm(BuildContext context, TaskController controller, [Task? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => TaskForm(
        initialTask: task,
        onSubmit: (newTask) {
          Navigator.pop(context);
          if (task != null) {
            controller.updateTask(newTask);
          } else {
            controller.addTask(newTask);
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _showTaskDetail(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              Text(task.description),
              const SizedBox(height: 8),
            ],
            Text('Priority: ${task.priority.name}'),
            Text('Status: ${task.status.name}'),
            if (task.dueDate != null)
              Text('Due: ${task.dueDate!.toLocal()}'),
            if (task.tags.isNotEmpty)
              Text('Tags: ${task.tags.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskController controller, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteTask(task.id);
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

  void _showFilterDialog(BuildContext context) {
    // Implementation for filter dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: const Text('Filter options would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPerformanceReport(BuildContext context) {
    final report = PerformanceMonitor.getPerformanceReport();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Performance Report'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: report.entries.map((entry) {
              final stats = entry.value;
              return ListTile(
                title: Text(entry.key),
                subtitle: Text(
                  'Avg: ${stats['average']}\n'
                  'Count: ${stats['count']}\n'
                  'Min: ${stats['min']}, Max: ${stats['max']}',
                ),
                isThreeLine: true,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              PerformanceMonitor.clearMeasurements();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/widgets/empty_state.dart
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// lib/main.dart
import 'package:flutter/material.dart';
import 'presentation/screens/task_list_screen.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager - setState Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const TaskListScreen(),
    );
  }
}
```

## **Step 6: Testing Implementation** ⏱️ *15 minutes*

Create comprehensive tests for stateful widgets:

```dart
// test/task_controller_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_10/core/models/task.dart';
import 'package:lesson_10/presentation/controllers/task_controller.dart';

void main() {
  group('TaskController Tests', () {
    testWidgets('should load initial tasks', (tester) async {
      // Arrange
      Widget testWidget = MaterialApp(
        home: TaskController(
          builder: (context, appState, controller) {
            return Scaffold(
              body: Text('Tasks: ${appState.tasks.length}'),
            );
          },
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);
      await tester.pump(); // Allow initState to complete
      await tester.pump(const Duration(seconds: 2)); // Wait for async load

      // Assert
      expect(find.textContaining('Tasks: '), findsOneWidget);
      expect(find.textContaining('Tasks: 0'), findsNothing); // Should have loaded tasks
    });

    testWidgets('should add new task', (tester) async {
      late TaskController capturedController;
      
      Widget testWidget = MaterialApp(
        home: TaskController(
          builder: (context, appState, controller) {
            capturedController = controller;
            return Scaffold(
              body: Column(
                children: [
                  Text('Tasks: ${appState.tasks.length}'),
                  ElevatedButton(
                    key: const Key('add_task_button'),
                    onPressed: () {
                      final newTask = Task.create(
                        title: 'Test Task',
                        description: 'Test Description',
                      );
                      controller.addTask(newTask);
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);
      await tester.pump(const Duration(seconds: 2)); // Wait for initial load
      
      final initialTaskCount = capturedController.tasks.length;
      
      await tester.tap(find.byKey(const Key('add_task_button')));
      await tester.pump(); // Trigger setState
      await tester.pump(const Duration(milliseconds: 600)); // Wait for async add

      // Assert
      expect(capturedController.tasks.length, equals(initialTaskCount + 1));
    });

    testWidgets('should toggle task completion', (tester) async {
      late TaskController capturedController;
      
      Widget testWidget = MaterialApp(
        home: TaskController(
          builder: (context, appState, controller) {
            capturedController = controller;
            return Scaffold(
              body: Column(
                children: [
                  Text('Tasks: ${appState.tasks.length}'),
                  if (appState.tasks.isNotEmpty)
                    ElevatedButton(
                      key: const Key('toggle_task_button'),
                      onPressed: () {
                        controller.toggleTaskCompletion(appState.tasks.first.id);
                      },
                      child: Text('Toggle: ${appState.tasks.first.status.name}'),
                    ),
                ],
              ),
            );
          },
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);
      await tester.pump(const Duration(seconds: 2)); // Wait for initial load
      
      if (capturedController.tasks.isNotEmpty) {
        final firstTask = capturedController.tasks.first;
        final originalStatus = firstTask.status;
        
        await tester.tap(find.byKey(const Key('toggle_task_button')));
        await tester.pump(); // Trigger setState

        // Assert
        final updatedTask = capturedController.tasks.firstWhere((t) => t.id == firstTask.id);
        expect(updatedTask.status, isNot(equals(originalStatus)));
      }
    });
  });

  group('Task Model Tests', () {
    test('should create task with correct properties', () {
      // Arrange & Act
      final task = Task.create(
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        tags: ['test', 'flutter'],
      );

      // Assert
      expect(task.title, equals('Test Task'));
      expect(task.description, equals('Test Description'));
      expect(task.priority, equals(TaskPriority.high));
      expect(task.status, equals(TaskStatus.pending));
      expect(task.tags, containsAll(['test', 'flutter']));
      expect(task.createdAt, isNotNull);
    });

    test('should mark task as completed', () {
      // Arrange
      final task = Task.create(title: 'Test', description: 'Test');

      // Act
      final completedTask = task.markCompleted();

      // Assert
      expect(completedTask.status, equals(TaskStatus.completed));
      expect(completedTask.completedAt, isNotNull);
      expect(task.status, equals(TaskStatus.pending)); // Original unchanged
    });

    test('should detect overdue tasks', () {
      // Arrange
      final overdueTask = Task.create(
        title: 'Overdue Task',
        description: 'This task is overdue',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      
      final futureTask = Task.create(
        title: 'Future Task',
        description: 'This task is in the future',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );

      // Act & Assert
      expect(overdueTask.isOverdue, isTrue);
      expect(futureTask.isOverdue, isFalse);
    });
  });
}
```

## 🎉 **Congratulations!**

You've successfully implemented a comprehensive task management application demonstrating:

✅ **StatefulWidget Mastery** - Complete lifecycle understanding and proper resource management  
✅ **setState Best Practices** - Efficient state updates with performance monitoring  
✅ **State Architecture** - Clean separation with immutable state objects  
✅ **Lifting State Up** - Proper parent-child communication patterns  
✅ **Error Handling** - Robust async operation management with validation  
✅ **Testing Coverage** - Comprehensive test suite for stateful widget behavior

## 🎯 **Key Learning Achievements**

### **StatefulWidget Foundation:**
1. **Lifecycle Management** - Proper use of initState, dispose, and all lifecycle methods
2. **setState Patterns** - Efficient state updates with batching and performance monitoring
3. **Resource Cleanup** - Preventing memory leaks with proper disposal
4. **Async Operations** - Safe state updates with mounted checks
5. **State Architecture** - Immutable state objects with copyWith patterns
6. **Performance Optimization** - Minimizing rebuilds and efficient rendering

### **This implementation demonstrates:**
- **✅ Production-ready state management** patterns used in professional Flutter apps
- **✅ Clean architecture** applied to local state management
- **✅ Performance excellence** with monitoring and optimization
- **✅ Comprehensive testing** strategies for stateful widgets
- **✅ Error resilience** with proper validation and error handling
- **✅ Professional code quality** with lifecycle logging and debugging tools

## 🎯 **Ready for Advanced State Management!**

With this solid foundation in setState and StatefulWidget patterns, you're now ready to:
- **Understand the limitations** of local state management
- **Appreciate the need** for global state management solutions
- **Continue to Lesson 11** - InheritedWidget & Provider for shared state
- **Build scalable applications** with proper state architecture

**You've mastered the foundation of Flutter state management! 🔄✨🚀**