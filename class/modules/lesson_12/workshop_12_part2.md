# 🚀 Workshop (Part 2)

## **Step 4: Advanced Filter Providers** ⏱️ *25 minutes*

Implement sophisticated filtering with family providers and computed state:

```dart
// lib/providers/filter_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/todo.dart';
import '../core/models/todo_filter.dart';
import 'todo_providers.dart';

// Current filter state
final todoFilterProvider = StateProvider<TodoFilter>((ref) {
  return const TodoFilter();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected status filter
final statusFilterProvider = StateProvider<TodoStatus?>((ref) => null);

// Selected priority filter
final priorityFilterProvider = StateProvider<TodoPriority?>((ref) => null);

// Selected tags filter
final tagsFilterProvider = StateProvider<List<String>>((ref) => []);

// Show overdue only toggle
final showOverdueOnlyProvider = StateProvider<bool>((ref) => false);

// Sort configuration
final sortConfigProvider = StateProvider<SortConfig>((ref) {
  return const SortConfig();
});

class SortConfig {
  final TodoSortBy sortBy;
  final bool ascending;

  const SortConfig({
    this.sortBy = TodoSortBy.createdAt,
    this.ascending = false,
  });

  SortConfig copyWith({
    TodoSortBy? sortBy,
    bool? ascending,
  }) {
    return SortConfig(
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}

// Computed filter from individual filter states
final computedFilterProvider = Provider<TodoFilter>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final status = ref.watch(statusFilterProvider);
  final priority = ref.watch(priorityFilterProvider);
  final tags = ref.watch(tagsFilterProvider);
  final showOverdueOnly = ref.watch(showOverdueOnlyProvider);
  final sortConfig = ref.watch(sortConfigProvider);

  return TodoFilter(
    searchQuery: searchQuery,
    status: status,
    priority: priority,
    tags: tags,
    showOverdueOnly: showOverdueOnly,
    sortBy: sortConfig.sortBy,
    sortAscending: sortConfig.ascending,
  );
});

// Filtered and sorted todos
final filteredTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todosAsync = ref.watch(todoNotifierProvider);
  final filter = ref.watch(computedFilterProvider);

  return todosAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    data: (todos) {
      final filteredTodos = filter.apply(todos);
      return AsyncValue.data(filteredTodos);
    },
  );
});

// Family provider for todos by tag
final todosByTagProvider = Provider.family<List<Todo>, String>((ref, tag) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (todos) => todos.where((todo) => todo.tags.contains(tag)).toList(),
  );
});

// Family provider for todos by priority
final todosByPriorityProvider = Provider.family<List<Todo>, TodoPriority>((ref, priority) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (todos) => todos.where((todo) => todo.priority == priority).toList(),
  );
});

// Family provider for todos by status
final todosByStatusProvider = Provider.family<List<Todo>, TodoStatus>((ref, status) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (todos) => todos.where((todo) => todo.status == status).toList(),
  );
});

// Available tags provider (computed from all todos)
final availableTagsProvider = Provider<List<String>>((ref) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (todos) {
      final tagSet = <String>{};
      for (final todo in todos) {
        tagSet.addAll(todo.tags);
      }
      final tags = tagSet.toList();
      tags.sort();
      return tags;
    },
  );
});

// Filter state helpers
final hasActiveFiltersProvider = Provider<bool>((ref) {
  final filter = ref.watch(computedFilterProvider);
  return filter.hasActiveFilters;
});

final filterCountProvider = Provider<int>((ref) {
  final filter = ref.watch(computedFilterProvider);
  int count = 0;
  
  if (filter.searchQuery.isNotEmpty) count++;
  if (filter.status != null) count++;
  if (filter.priority != null) count++;
  if (filter.tags.isNotEmpty) count++;
  if (filter.showOverdueOnly) count++;
  
  return count;
});

// Filter actions
class FilterActions {
  static void clearAllFilters(WidgetRef ref) {
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(statusFilterProvider.notifier).state = null;
    ref.read(priorityFilterProvider.notifier).state = null;
    ref.read(tagsFilterProvider.notifier).state = [];
    ref.read(showOverdueOnlyProvider.notifier).state = false;
  }

  static void setSearchQuery(WidgetRef ref, String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  static void setStatusFilter(WidgetRef ref, TodoStatus? status) {
    ref.read(statusFilterProvider.notifier).state = status;
  }

  static void setPriorityFilter(WidgetRef ref, TodoPriority? priority) {
    ref.read(priorityFilterProvider.notifier).state = priority;
  }

  static void toggleTag(WidgetRef ref, String tag) {
    final currentTags = ref.read(tagsFilterProvider);
    if (currentTags.contains(tag)) {
      ref.read(tagsFilterProvider.notifier).state = 
          currentTags.where((t) => t != tag).toList();
    } else {
      ref.read(tagsFilterProvider.notifier).state = [...currentTags, tag];
    }
  }

  static void toggleOverdueOnly(WidgetRef ref) {
    final current = ref.read(showOverdueOnlyProvider);
    ref.read(showOverdueOnlyProvider.notifier).state = !current;
  }

  static void setSortConfig(WidgetRef ref, TodoSortBy sortBy, bool ascending) {
    ref.read(sortConfigProvider.notifier).state = SortConfig(
      sortBy: sortBy,
      ascending: ascending,
    );
  }
}
```

## **Step 5: Advanced UI Components** ⏱️ *35 minutes*

Build sophisticated UI components using Riverpod patterns:

```dart
// lib/presentation/widgets/todo_item.dart
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
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

// lib/presentation/widgets/filter_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/todo.dart';
import '../../providers/filter_providers.dart';

class FilterBar extends ConsumerStatefulWidget {
  const FilterBar({super.key});

  @override
  ConsumerState<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<FilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentQuery = ref.read(searchQueryProvider);
    _searchController.text = currentQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    final filterCount = ref.watch(filterCountProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search todos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        FilterActions.setSearchQuery(ref, '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) {
              FilterActions.setSearchQuery(ref, query);
            },
          ),
          
          const SizedBox(height: 12),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Clear filters button
                if (hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text('Clear All ($filterCount)'),
                      onPressed: () => FilterActions.clearAllFilters(ref),
                      backgroundColor: Colors.red.withOpacity(0.1),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                
                // Status filter
                _buildStatusFilter(),
                
                const SizedBox(width: 8),
                
                // Priority filter
                _buildPriorityFilter(),
                
                const SizedBox(width: 8),
                
                // Overdue filter
                _buildOverdueFilter(),
                
                const SizedBox(width: 8),
                
                // Sort options
                _buildSortFilter(),
                
                const SizedBox(width: 8),
                
                // Tags filter
                _buildTagsFilter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    final selectedStatus = ref.watch(statusFilterProvider);
    
    return FilterChip(
      label: Text(selectedStatus?.name.toUpperCase() ?? 'STATUS'),
      selected: selectedStatus != null,
      onSelected: (selected) {
        if (selected) {
          _showStatusDialog();
        } else {
          FilterActions.setStatusFilter(ref, null);
        }
      },
    );
  }

  Widget _buildPriorityFilter() {
    final selectedPriority = ref.watch(priorityFilterProvider);
    
    return FilterChip(
      label: Text(selectedPriority?.name.toUpperCase() ?? 'PRIORITY'),
      selected: selectedPriority != null,
      onSelected: (selected) {
        if (selected) {
          _showPriorityDialog();
        } else {
          FilterActions.setPriorityFilter(ref, null);
        }
      },
    );
  }

  Widget _buildOverdueFilter() {
    final showOverdueOnly = ref.watch(showOverdueOnlyProvider);
    
    return FilterChip(
      label: const Text('OVERDUE'),
      selected: showOverdueOnly,
      onSelected: (_) => FilterActions.toggleOverdueOnly(ref),
      backgroundColor: showOverdueOnly ? Colors.red.withOpacity(0.1) : null,
    );
  }

  Widget _buildSortFilter() {
    final sortConfig = ref.watch(sortConfigProvider);
    
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('SORT'),
          const SizedBox(width: 4),
          Icon(
            sortConfig.ascending ? Icons.arrow_upward : Icons.arrow_downward,
            size: 16,
          ),
        ],
      ),
      onPressed: _showSortDialog,
    );
  }

  Widget _buildTagsFilter() {
    final selectedTags = ref.watch(tagsFilterProvider);
    final availableTags = ref.watch(availableTagsProvider);
    
    if (availableTags.isEmpty) return const SizedBox();
    
    return ActionChip(
      label: Text(selectedTags.isEmpty 
          ? 'TAGS' 
          : 'TAGS (${selectedTags.length})'),
      onPressed: () => _showTagsDialog(availableTags),
    );
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TodoStatus.values.map((status) {
            return ListTile(
              title: Text(status.name.toUpperCase()),
              onTap: () {
                FilterActions.setStatusFilter(ref, status);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPriorityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TodoPriority.values.map((priority) {
            return ListTile(
              title: Text(priority.name.toUpperCase()),
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getPriorityColor(priority),
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                FilterActions.setPriorityFilter(ref, priority);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...TodoSortBy.values.map((sortBy) {
              return ListTile(
                title: Text(_getSortDisplayName(sortBy)),
                onTap: () {
                  final currentSort = ref.read(sortConfigProvider);
                  final ascending = currentSort.sortBy == sortBy 
                      ? !currentSort.ascending 
                      : false;
                  FilterActions.setSortConfig(ref, sortBy, ascending);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTagsDialog(List<String> availableTags) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Tags'),
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer(
            builder: (context, ref, child) {
              final selectedTags = ref.watch(tagsFilterProvider);
              
              return ListView(
                shrinkWrap: true,
                children: availableTags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return CheckboxListTile(
                    title: Text(tag),
                    value: isSelected,
                    onChanged: (_) => FilterActions.toggleTag(ref, tag),
                  );
                }).toList(),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
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

  String _getSortDisplayName(TodoSortBy sortBy) {
    switch (sortBy) {
      case TodoSortBy.createdAt:
        return 'Date Created';
      case TodoSortBy.dueDate:
        return 'Due Date';
      case TodoSortBy.priority:
        return 'Priority';
      case TodoSortBy.title:
        return 'Title';
      case TodoSortBy.status:
        return 'Status';
    }
  }
}

// lib/presentation/widgets/todo_stats.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/todo_providers.dart';

class TodoStats extends ConsumerWidget {
  const TodoStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(todoStatsProvider);
    
    if (stats.isEmpty) {
      return const SizedBox();
    }
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todo Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatItem(context, 'Total', stats['total'] ?? 0, Colors.blue)),
                Expanded(child: _buildStatItem(context, 'Completed', stats['completed'] ?? 0, Colors.green)),
                Expanded(child: _buildStatItem(context, 'Pending', stats['pending'] ?? 0, Colors.orange)),
                Expanded(child: _buildStatItem(context, 'Overdue', stats['overdue'] ?? 0, Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
```

## **Step 6: Screen Implementation** ⏱️ *30 minutes*

Build the main application screens using Riverpod patterns:

```dart
// lib/presentation/screens/todos/todo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/todo_providers.dart';
import '../../../providers/filter_providers.dart';
import '../../../providers/auth_providers.dart';
import '../../widgets/todo_item.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/todo_stats.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    
    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Authentication Error: $error'),
            ],
          ),
        ),
      ),
      data: (user) {
        if (user == null) {
          return _buildLoginPrompt();
        }
        
        return _buildTodoList(context);
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 64),
            const SizedBox(height: 16),
            const Text('Please log in to view your todos'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to login screen
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(todoNotifierProvider.notifier).refresh();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (action) {
              switch (action) {
                case 'logout':
                  ref.read(authNotifierProvider.notifier).logout();
                  break;
                case 'profile':
                  // Navigate to profile
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const FilterBar(),
          const TodoStats(),
          Expanded(child: _buildTodosList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTodo(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodosList() {
    final filteredTodosAsync = ref.watch(filteredTodosProvider);
    
    return filteredTodosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorState(error),
      data: (todos) {
        if (todos.isEmpty) {
          return _buildEmptyState();
        }
        
        return RefreshIndicator(
          onRefresh: () => ref.read(todoNotifierProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                key: ValueKey(todo.id),
                todo: todo,
                onTap: () => _navigateToEditTodo(todo.id),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading todos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(todoNotifierProvider.notifier).refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasActiveFilters ? Icons.search_off : Icons.check_circle_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            hasActiveFilters ? 'No matching todos' : 'No todos yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters 
                ? 'Try adjusting your filters'
                : 'Create your first todo to get started',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: hasActiveFilters 
                ? () => FilterActions.clearAllFilters(ref)
                : _navigateToAddTodo,
            child: Text(hasActiveFilters ? 'Clear Filters' : 'Create Todo'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTodo() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddTodoScreen()),
    );
  }

  void _navigateToEditTodo(String todoId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTodoScreen(todoId: todoId),
      ),
    );
  }
}

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/todos/todo_list_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App - Riverpod Demo',
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
      home: const TodoListScreen(),
    );
  }
}
```

## **Step 7: Comprehensive Testing** ⏱️ *25 minutes*

Implement advanced testing patterns with Riverpod:

```dart
// test/providers/todo_providers_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../lib/core/models/todo.dart';
import '../lib/core/services/api_service.dart';
import '../lib/providers/todo_providers.dart';
import '../lib/providers/auth_providers.dart';

@GenerateMocks([ApiService])
import 'todo_providers_test.mocks.dart';

void main() {
  group('TodoNotifier Tests', () {
    late ProviderContainer container;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
          currentUserIdProvider.overrideWith((ref) => 'test-user-id'),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with loading state', () {
      final todosAsync = container.read(todoNotifierProvider);
      expect(todosAsync, isA<AsyncLoading>());
    });

    test('should load todos on initialization', () async {
      final mockTodos = [
        Todo.create(title: 'Test Todo 1', description: 'Description 1', userId: 'test-user-id'),
        Todo.create(title: 'Test Todo 2', description: 'Description 2', userId: 'test-user-id'),
      ];

      when(mockApiService.fetchTodos('test-user-id'))
          .thenAnswer((_) async => mockTodos);

      // Wait for initialization to complete
      await container.read(todoNotifierProvider.future);

      final todosAsync = container.read(todoNotifierProvider);
      expect(todosAsync.hasValue, isTrue);
      expect(todosAsync.value!.length, equals(2));
    });

    test('should add todo optimistically', () async {
      // Setup initial state
      final initialTodos = [
        Todo.create(title: 'Existing Todo', description: 'Description', userId: 'test-user-id'),
      ];

      when(mockApiService.fetchTodos('test-user-id'))
          .thenAnswer((_) async => initialTodos);

      await container.read(todoNotifierProvider.future);

      final createdTodo = Todo.create(
        title: 'New Todo',
        description: 'New Description',
        userId: 'test-user-id',
      );

      when(mockApiService.createTodo(any))
          .thenAnswer((_) async => createdTodo);

      // Add todo
      final notifier = container.read(todoNotifierProvider.notifier);
      await notifier.addTodo(
        title: 'New Todo',
        description: 'New Description',
      );

      // Verify optimistic update
      final todosAsync = container.read(todoNotifierProvider);
      expect(todosAsync.value!.length, equals(2));
      expect(todosAsync.value!.last.title, equals('New Todo'));
    });

    test('should handle add todo failure with rollback', () async {
      // Setup initial state
      final initialTodos = [
        Todo.create(title: 'Existing Todo', description: 'Description', userId: 'test-user-id'),
      ];

      when(mockApiService.fetchTodos('test-user-id'))
          .thenAnswer((_) async => initialTodos);

      await container.read(todoNotifierProvider.future);

      when(mockApiService.createTodo(any))
          .thenThrow(Exception('Network error'));

      // Attempt to add todo
      final notifier = container.read(todoNotifierProvider.notifier);
      
      expect(
        () => notifier.addTodo(title: 'New Todo', description: 'Description'),
        throwsException,
      );

      // Verify rollback
      final todosAsync = container.read(todoNotifierProvider);
      expect(todosAsync.value!.length, equals(1)); // Back to original
    });

    test('should toggle todo completion', () async {
      final initialTodos = [
        Todo.create(title: 'Test Todo', description: 'Description', userId: 'test-user-id'),
      ];

      when(mockApiService.fetchTodos('test-user-id'))
          .thenAnswer((_) async => initialTodos);

      await container.read(todoNotifierProvider.future);

      final todoId = container.read(todoNotifierProvider).value!.first.id;
      final completedTodo = initialTodos.first.markCompleted();

      when(mockApiService.updateTodo(any))
          .thenAnswer((_) async => completedTodo);

      // Toggle completion
      final notifier = container.read(todoNotifierProvider.notifier);
      await notifier.toggleTodoCompletion(todoId);

      // Verify update
      final todosAsync = container.read(todoNotifierProvider);
      expect(todosAsync.value!.first.isCompleted, isTrue);
    });
  });

  group('Filter Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should update search query', () {
      container.read(searchQueryProvider.notifier).state = 'test query';
      expect(container.read(searchQueryProvider), equals('test query'));
    });

    test('should update computed filter when individual filters change', () {
      container.read(searchQueryProvider.notifier).state = 'test';
      container.read(statusFilterProvider.notifier).state = TodoStatus.completed;

      final computedFilter = container.read(computedFilterProvider);
      expect(computedFilter.searchQuery, equals('test'));
      expect(computedFilter.status, equals(TodoStatus.completed));
    });

    test('should clear all filters', () {
      // Set some filters
      container.read(searchQueryProvider.notifier).state = 'test';
      container.read(statusFilterProvider.notifier).state = TodoStatus.completed;
      container.read(showOverdueOnlyProvider.notifier).state = true;

      // Clear all
      FilterActions.clearAllFilters(container);

      // Verify cleared
      expect(container.read(searchQueryProvider), isEmpty);
      expect(container.read(statusFilterProvider), isNull);
      expect(container.read(showOverdueOnlyProvider), isFalse);
    });
  });
}

// test/widgets/todo_item_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../lib/core/models/todo.dart';
import '../lib/presentation/widgets/todo_item.dart';
import '../lib/providers/todo_providers.dart';

class MockTodoNotifier extends Mock implements TodoNotifier {}

void main() {
  group('TodoItem Widget Tests', () {
    late Todo testTodo;
    late MockTodoNotifier mockNotifier;

    setUp(() {
      testTodo = Todo.create(
        title: 'Test Todo',
        description: 'Test Description',
        userId: 'test-user-id',
      );
      mockNotifier = MockTodoNotifier();
    });

    testWidgets('should display todo information correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoNotifierProvider.overrideWith((ref) => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('should toggle completion when checkbox tapped', (tester) async {
      when(mockNotifier.toggleTodoCompletion(any))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoNotifierProvider.overrideWith((ref) => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verify(mockNotifier.toggleTodoCompletion(testTodo.id)).called(1);
    });

    testWidgets('should show delete confirmation dialog', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoNotifierProvider.overrideWith((ref) => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TodoItem(todo: testTodo),
            ),
          ),
        ),
      );

      // Tap the popup menu button
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Tap delete option
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Delete Todo'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Test Todo"?'), findsOneWidget);
    });
  });
}
```

## 🎉 **Congratulations!**

You've successfully implemented a comprehensive todo application demonstrating:

✅ **Riverpod Mastery** - Understanding the evolution from Provider to Riverpod 2.0  
✅ **Advanced Provider Types** - StateProvider, StateNotifierProvider, FutureProvider, StreamProvider  
✅ **Async Excellence** - AsyncValue for loading, data, and error states with optimistic updates  
✅ **Provider Modifiers** - autoDispose, family, and computed providers  
✅ **Compile-time Safety** - Type-safe state management without BuildContext dependencies  
✅ **Testing Excellence** - Comprehensive testing with ProviderContainer and mock overrides

## 🎯 **Key Learning Achievements**

### **Riverpod Advanced Patterns:**
1. **Evolution Understanding** - Appreciating improvements from Provider to Riverpod
2. **Provider Types Mastery** - Using appropriate providers for different use cases
3. **Async State Management** - Handling complex async operations with AsyncValue
4. **Modifier Usage** - Leveraging autoDispose and family for advanced patterns
5. **Performance Optimization** - Efficient state updates and computed providers
6. **Testing Excellence** - Superior testing patterns with ProviderContainer

### **This implementation demonstrates:**
- **✅ Production-ready patterns** used in modern Flutter applications
- **✅ Type safety excellence** with compile-time guarantees
- **✅ Performance optimization** with automatic disposal and computed state
- **✅ Comprehensive testing** strategies for Riverpod-based applications
- **✅ Clean architecture** integration with dependency injection
- **✅ Real-world complexity** with async operations, filtering, and error handling

## 🎯 **Ready for Advanced State Management!**

With this solid foundation in Riverpod 2.0, you're now ready to:
- **Build complex applications** with type-safe state management
- **Handle async operations** efficiently with AsyncValue patterns
- **Test state management** comprehensively with ProviderContainer
- **Continue to Lesson 13** - Bloc & Cubit for event-driven architecture
- **Choose appropriate patterns** for different application needs

**You've mastered the future of Flutter state management with Riverpod 2.0! 🚀✨🔥**