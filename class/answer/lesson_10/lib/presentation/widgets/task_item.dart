/// Task item widget with interactive animations and state management
/// 
/// This file demonstrates StatefulWidget patterns with user interactions,
/// animations, and proper state management for individual task items.
library;

import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../mixins/lifecycle_mixin.dart';
import '../controllers/task_controller.dart';

/// Interactive task item widget with stateful animations
/// 
/// Demonstrates proper StatefulWidget patterns including state management,
/// user interactions, animations, and performance optimization.
class TaskItem extends StatefulWidget {
  /// Creates a task item widget
  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleStatus,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.isSelected = false,
  });

  /// The task to display
  final Task task;

  /// Called when the task is tapped
  final VoidCallback? onTap;

  /// Called when status toggle is requested
  final VoidCallback? onToggleStatus;

  /// Called when edit is requested
  final VoidCallback? onEdit;

  /// Called when delete is requested
  final VoidCallback? onDelete;

  /// Whether to show action buttons
  final bool showActions;

  /// Whether this task is currently selected
  final bool isSelected;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> 
    with TickerProviderStateMixin, LifecycleMixin<TaskItem> {

  /// Animation controller for interactions
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _statusController;

  /// Animations
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _statusAnimation;

  /// UI state
  bool _isPressed = false;
  bool _isExpanded = false;
  bool _showDetails = false;

  @override
  String get widgetName => 'TaskItem-${widget.task.id}';

  @override
  void onInitStateCallback() {
    _initializeAnimations();
  }

  @override
  void onDisposeCallback() {
    _scaleController.dispose();
    _slideController.dispose();
    _statusController.dispose();
  }

  /// Initialize animations
  void _initializeAnimations() {
    // Scale animation for press feedback
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Slide animation for actions
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    // Status change animation
    _statusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _statusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statusController,
      curve: Curves.elasticOut,
    ));

    // Start entrance animation
    _slideController.forward();
  }

  @override
  void didUpdateWidget(TaskItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Animate status changes
    if (oldWidget.task.status != widget.task.status) {
      _statusController.forward(from: 0);
    }
  }

  /// Handle tap down
  void _handleTapDown(TapDownDetails details) {
    setStateWithMonitoring(() {
      _isPressed = true;
    }, 'Task tap down');
    _scaleController.forward();
  }

  /// Handle tap up
  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
    widget.onTap?.call();
  }

  /// Handle tap cancel
  void _handleTapCancel() {
    _handleTapEnd();
  }

  /// Handle tap end
  void _handleTapEnd() {
    if (_isPressed) {
      setStateWithMonitoring(() {
        _isPressed = false;
      }, 'Task tap end');
      _scaleController.reverse();
    }
  }

  /// Toggle expanded state
  void _toggleExpanded() {
    setStateWithMonitoring(() {
      _isExpanded = !_isExpanded;
      _showDetails = _isExpanded;
    }, 'Toggle task expanded: $_isExpanded');
  }

  /// Handle status toggle
  void _handleStatusToggle() {
    _statusController.forward(from: 0);
    widget.onToggleStatus?.call();
  }

  @override
  Widget buildWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _slideAnimation, _statusAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildTaskCard(theme),
          ),
        );
      },
    );
  }

  /// Build the main task card
  Widget _buildTaskCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: widget.isSelected 
            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isSelected 
              ? theme.colorScheme.primary.withOpacity(0.5)
              : theme.dividerColor.withOpacity(0.1),
          width: widget.isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            _buildTaskHeader(theme),
            if (_isExpanded) _buildTaskDetails(theme),
          ],
        ),
      ),
    );
  }

  /// Build task header
  Widget _buildTaskHeader(ThemeData theme) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status indicator with animation
            _buildStatusIndicator(theme),
            const SizedBox(width: 12),
            
            // Task content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskTitle(theme),
                  const SizedBox(height: 4),
                  _buildTaskMetadata(theme),
                ],
              ),
            ),
            
            // Action buttons
            if (widget.showActions) ...[
              const SizedBox(width: 8),
              _buildActionButtons(theme),
            ],
          ],
        ),
      ),
    );
  }

  /// Build status indicator
  Widget _buildStatusIndicator(ThemeData theme) {
    return AnimatedBuilder(
      animation: _statusAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (0.2 * _statusAnimation.value),
          child: GestureDetector(
            onTap: _handleStatusToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: widget.task.status == TaskStatus.completed
                    ? widget.task.displayColor
                    : Colors.transparent,
                border: Border.all(
                  color: widget.task.displayColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.task.status == TaskStatus.completed
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : widget.task.status == TaskStatus.inProgress
                      ? Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: widget.task.displayColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )
                      : null,
            ),
          ),
        );
      },
    );
  }

  /// Build task title
  Widget _buildTaskTitle(ThemeData theme) {
    return Text(
      widget.task.title,
      style: theme.textTheme.titleMedium?.copyWith(
        decoration: widget.task.status == TaskStatus.completed
            ? TextDecoration.lineThrough
            : null,
        color: widget.task.status == TaskStatus.completed
            ? theme.textTheme.bodySmall?.color
            : null,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build task metadata
  Widget _buildTaskMetadata(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        // Priority badge
        _buildPriorityBadge(theme),
        
        // Due date if available
        if (widget.task.dueDate != null) _buildDueDateBadge(theme),
        
        // Status badge
        _buildStatusBadge(theme),
        
        // Tags
        ...widget.task.tags.take(2).map((tag) => _buildTagChip(theme, tag)),
        
        if (widget.task.tags.length > 2)
          Text(
            '+${widget.task.tags.length - 2} more',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
      ],
    );
  }

  /// Build priority badge
  Widget _buildPriorityBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: TaskPriority.getColor(widget.task.priority).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.task.priority.label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: TaskPriority.getColor(widget.task.priority),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Build due date badge
  Widget _buildDueDateBadge(ThemeData theme) {
    final isOverdue = widget.task.isOverdue;
    final isDueSoon = widget.task.isDueSoon;
    
    Color badgeColor = theme.textTheme.bodySmall?.color ?? Colors.grey;
    if (isOverdue) badgeColor = theme.colorScheme.error;
    if (isDueSoon) badgeColor = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.warning : Icons.schedule,
            size: 12,
            color: badgeColor,
          ),
          const SizedBox(width: 2),
          Text(
            _formatDueDate(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build status badge
  Widget _buildStatusBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: widget.task.displayColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.task.statusBadge,
        style: theme.textTheme.bodySmall?.copyWith(
          color: widget.task.displayColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Build tag chip
  Widget _buildTagChip(ThemeData theme, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '#$tag',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Expand/collapse button
        IconButton(
          onPressed: _toggleExpanded,
          icon: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.expand_more),
          ),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
        ),
        
        // Edit button
        IconButton(
          onPressed: widget.onEdit,
          icon: const Icon(Icons.edit_outlined),
          iconSize: 18,
          visualDensity: VisualDensity.compact,
        ),
        
        // Delete button
        IconButton(
          onPressed: widget.onDelete,
          icon: const Icon(Icons.delete_outline),
          iconSize: 18,
          visualDensity: VisualDensity.compact,
          color: theme.colorScheme.error,
        ),
      ],
    );
  }

  /// Build task details (when expanded)
  Widget _buildTaskDetails(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.dividerColor.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            
            // Description
            if (widget.task.description.isNotEmpty) ...[
              Text(
                'Description',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.task.description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
            ],
            
            // Additional metadata
            _buildDetailedMetadata(theme),
            
            // Progress indicator
            if (widget.task.estimatedHours != null) ...[
              const SizedBox(height: 12),
              _buildProgressIndicator(theme),
            ],
          ],
        ),
      ),
    );
  }

  /// Build detailed metadata
  Widget _buildDetailedMetadata(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildMetadataItem(
          theme,
          Icons.calendar_today,
          'Created',
          _formatDate(widget.task.createdAt),
        ),
        
        if (widget.task.dueDate != null)
          _buildMetadataItem(
            theme,
            Icons.schedule,
            'Due',
            _formatDate(widget.task.dueDate!),
          ),
        
        if (widget.task.completedAt != null)
          _buildMetadataItem(
            theme,
            Icons.check_circle,
            'Completed',
            _formatDate(widget.task.completedAt!),
          ),
        
        if (widget.task.estimatedHours != null)
          _buildMetadataItem(
            theme,
            Icons.timer,
            'Estimated',
            '${widget.task.estimatedHours}h',
          ),
        
        if (widget.task.actualHours != null)
          _buildMetadataItem(
            theme,
            Icons.access_time,
            'Actual',
            '${widget.task.actualHours}h',
          ),
      ],
    );
  }

  /// Build metadata item
  Widget _buildMetadataItem(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  /// Build progress indicator
  Widget _buildProgressIndicator(ThemeData theme) {
    final progress = widget.task.progressPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.outline.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(widget.task.displayColor),
        ),
      ],
    );
  }

  /// Format due date for display
  String _formatDueDate() {
    final dueDate = widget.task.dueDate;
    if (dueDate == null) return '';
    
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (difference.isNegative) {
      final daysPast = (-difference.inDays);
      if (daysPast == 0) return 'Due today';
      if (daysPast == 1) return 'Due yesterday';
      return 'Due $daysPast days ago';
    } else {
      final daysAhead = difference.inDays;
      if (daysAhead == 0) return 'Due today';
      if (daysAhead == 1) return 'Due tomorrow';
      return 'Due in $daysAhead days';
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}