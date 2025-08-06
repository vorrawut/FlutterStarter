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
          const Text('SORT'),
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
            }),
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