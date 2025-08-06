import 'package:flutter/material.dart';
import '../../../shared/models/todo.dart';
import '../../../shared/models/todo_filter.dart';

class FilterWidget extends StatefulWidget {
  final TodoFilter filter;
  final Function(TodoFilter) onFilterChanged;
  final List<String> availableTags;

  const FilterWidget({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.availableTags,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        setState(() {
                          _searchController.clear();
                        });
                        _updateFilter(searchQuery: '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) => _updateFilter(searchQuery: query),
          ),
          
          const SizedBox(height: 12),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Clear filters
                if (widget.filter.hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: const Text('Clear All'),
                      onPressed: _clearAllFilters,
                      backgroundColor: Colors.red.withOpacity(0.1),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                
                // Status filter
                _buildStatusChip(),
                
                const SizedBox(width: 8),
                
                // Priority filter
                _buildPriorityChip(),
                
                const SizedBox(width: 8),
                
                // Overdue filter
                FilterChip(
                  label: const Text('OVERDUE'),
                  selected: widget.filter.showOverdueOnly,
                  onSelected: (selected) => _updateFilter(showOverdueOnly: selected),
                  backgroundColor: widget.filter.showOverdueOnly 
                      ? Colors.red.withOpacity(0.1) 
                      : null,
                ),
                
                const SizedBox(width: 8),
                
                // Sort options
                _buildSortChip(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return FilterChip(
      label: Text(widget.filter.status?.name.toUpperCase() ?? 'STATUS'),
      selected: widget.filter.status != null,
      onSelected: (selected) {
        if (selected) {
          _showStatusDialog();
        } else {
          _updateFilter(status: null);
        }
      },
    );
  }

  Widget _buildPriorityChip() {
    return FilterChip(
      label: Text(widget.filter.priority?.name.toUpperCase() ?? 'PRIORITY'),
      selected: widget.filter.priority != null,
      onSelected: (selected) {
        if (selected) {
          _showPriorityDialog();
        } else {
          _updateFilter(priority: null);
        }
      },
    );
  }

  Widget _buildSortChip() {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('SORT'),
          const SizedBox(width: 4),
          Icon(
            widget.filter.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            size: 16,
          ),
        ],
      ),
      onPressed: _showSortDialog,
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
                _updateFilter(status: status);
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
                _updateFilter(priority: priority);
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
          children: TodoSortBy.values.map((sortBy) {
            return ListTile(
              title: Text(_getSortDisplayName(sortBy)),
              onTap: () {
                final ascending = widget.filter.sortBy == sortBy 
                    ? !widget.filter.sortAscending 
                    : false;
                _updateFilter(sortBy: sortBy, sortAscending: ascending);
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

  void _updateFilter({
    String? searchQuery,
    TodoStatus? status,
    TodoPriority? priority,
    List<String>? tags,
    bool? showOverdueOnly,
    TodoSortBy? sortBy,
    bool? sortAscending,
  }) {
    final newFilter = widget.filter.copyWith(
      searchQuery: searchQuery,
      status: status,
      priority: priority,
      tags: tags,
      showOverdueOnly: showOverdueOnly,
      sortBy: sortBy,
      sortAscending: sortAscending,
    );
    widget.onFilterChanged(newFilter);
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
    });
    widget.onFilterChanged(const TodoFilter());
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