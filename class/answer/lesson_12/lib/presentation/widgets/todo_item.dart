import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/todo.dart';
import '../../providers/todo_providers.dart';

class TodoItem extends ConsumerStatefulWidget {
  final Todo todo;
  final VoidCallback? onTap;

  const TodoItem({
    super.key,
    required this.todo,
    this.onTap,
  });

  @override
  ConsumerState<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleCompletion() async {
    if (_isUpdating) return;
    
    setState(() {
      _isUpdating = true;
    });

    try {
      await ref.read(todoNotifierProvider.notifier)
          .toggleTodoCompletion(widget.todo.id);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update todo: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _deleteTodo() async {
    final confirmed = await _showDeleteConfirmation();
    if (!confirmed) return;

    try {
      await ref.read(todoNotifierProvider.notifier).deleteTodo(widget.todo.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Todo "${widget.todo.title}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // In a real app, implement undo functionality
              },
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete todo: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${widget.todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildTodoCard(theme),
        );
      },
    );
  }

  Widget _buildTodoCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: widget.todo.isCompleted ? 1 : 2,
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.todo.isCompleted 
                ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTodoHeader(theme),
              if (widget.todo.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildTodoDescription(theme),
              ],
              const SizedBox(height: 8),
              _buildTodoMetadata(theme),
              if (widget.todo.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildTodoTags(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodoHeader(ThemeData theme) {
    return Row(
      children: [
        // Completion checkbox
        SizedBox(
          width: 24,
          height: 24,
          child: _isUpdating
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                )
              : Checkbox(
                  value: widget.todo.isCompleted,
                  onChanged: (_) => _toggleCompletion(),
                  shape: const CircleBorder(),
                ),
        ),
        
        const SizedBox(width: 12),
        
        // Title
        Expanded(
          child: Text(
            widget.todo.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: widget.todo.isCompleted 
                  ? TextDecoration.lineThrough 
                  : null,
              color: widget.todo.isCompleted 
                  ? theme.colorScheme.onSurfaceVariant 
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
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
            color: _getPriorityColor(widget.todo.priority),
            shape: BoxShape.circle,
          ),
        ),
        
        // Actions menu
        PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'edit':
                widget.onTap?.call();
                break;
              case 'delete':
                _deleteTodo();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodoDescription(ThemeData theme) {
    return Text(
      widget.todo.description,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: widget.todo.isCompleted 
            ? theme.colorScheme.onSurfaceVariant 
            : theme.colorScheme.onSurfaceVariant,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTodoMetadata(ThemeData theme) {
    return Row(
      children: [
        // Status chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getStatusColor(widget.todo.status).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.todo.status.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: _getStatusColor(widget.todo.status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Due date
        if (widget.todo.dueDate != null) ...[
          Icon(
            Icons.schedule,
            size: 16,
            color: widget.todo.isOverdue 
                ? Colors.red 
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDueDate(widget.todo.dueDate!),
            style: theme.textTheme.bodySmall?.copyWith(
              color: widget.todo.isOverdue 
                  ? Colors.red 
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        
        const Spacer(),
        
        // Created date
        Text(
          '${widget.todo.daysSinceCreated}d ago',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTodoTags(ThemeData theme) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: widget.todo.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return Colors.green;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.high:
        return Colors.red;
      case TodoPriority.urgent:
        return Colors.purple;
    }
  }

  Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Colors.grey;
      case TodoStatus.inProgress:
        return Colors.blue;
      case TodoStatus.completed:
        return Colors.green;
      case TodoStatus.archived:
        return Colors.brown;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference < 0) return '${-difference} days overdue';
    return 'In $difference days';
  }
}