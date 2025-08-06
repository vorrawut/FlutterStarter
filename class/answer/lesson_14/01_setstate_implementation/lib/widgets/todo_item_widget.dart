import 'package:flutter/material.dart';
import '../../../shared/models/todo.dart';

class TodoItemWidget extends StatefulWidget {
  final Todo todo;
  final VoidCallback onToggled;
  final Function(Todo) onUpdated;
  final VoidCallback onDeleted;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggled,
    required this.onUpdated,
    required this.onDeleted,
  });

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: widget.todo.isCompleted ? 1 : 2,
            child: InkWell(
              onTap: () => _showEditDialog(context),
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _animationController.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget.todo.isCompleted
                      ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme),
                    if (widget.todo.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildDescription(theme),
                    ],
                    const SizedBox(height: 8),
                    _buildMetadata(theme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        // Completion checkbox
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: widget.todo.isCompleted,
            onChanged: (_) => widget.onToggled(),
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
                _showEditDialog(context);
                break;
              case 'delete':
                _showDeleteConfirmation(context);
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

  Widget _buildDescription(ThemeData theme) {
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

  Widget _buildMetadata(ThemeData theme) {
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
            widget.todo.statusDisplayName.toUpperCase(),
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
        
        // Tags
        if (widget.todo.tags.isNotEmpty) ...[
          Icon(
            Icons.local_offer,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            widget.todo.tags.length.toString(),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
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
      case TodoStatus.cancelled:
        return Colors.red;
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

  void _showEditDialog(BuildContext context) {
    // For setState pattern, we keep edit functionality simple
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: const Text('Edit functionality would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${widget.todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDeleted();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}