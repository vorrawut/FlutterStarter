/// Task filter configuration for query operations
/// 
/// This file defines filtering and sorting options for tasks,
/// implementing immutable patterns for predictable filter updates.
library;

import 'package:flutter/foundation.dart';
import 'task.dart';

/// Sort order enumeration
enum SortOrder {
  ascending('Ascending'),
  descending('Descending');

  const SortOrder(this.label);

  /// Display label for the sort order
  final String label;
}

/// Sort field enumeration
enum TaskSortField {
  createdAt('Date Created'),
  dueDate('Due Date'),
  priority('Priority'),
  title('Title'),
  status('Status');

  const TaskSortField(this.label);

  /// Display label for the sort field
  final String label;
}

/// Immutable task filter configuration
/// 
/// Provides filtering and sorting options for task lists
/// with immutable update patterns.
@immutable
class TaskFilter {
  /// Creates a new TaskFilter instance
  const TaskFilter({
    this.statusFilter,
    this.priorityFilter,
    this.searchQuery = '',
    this.tagFilter,
    this.showOverdueOnly = false,
    this.showDueSoonOnly = false,
    this.sortField = TaskSortField.createdAt,
    this.sortOrder = SortOrder.descending,
    this.dateRangeStart,
    this.dateRangeEnd,
  });

  /// Filter by specific status (null means all statuses)
  final TaskStatus? statusFilter;

  /// Filter by specific priority (null means all priorities)
  final TaskPriority? priorityFilter;

  /// Search query for title and description
  final String searchQuery;

  /// Filter by specific tag (null means all tags)
  final String? tagFilter;

  /// Show only overdue tasks
  final bool showOverdueOnly;

  /// Show only tasks due soon
  final bool showDueSoonOnly;

  /// Field to sort by
  final TaskSortField sortField;

  /// Sort order (ascending or descending)
  final SortOrder sortOrder;

  /// Filter by date range start
  final DateTime? dateRangeStart;

  /// Filter by date range end
  final DateTime? dateRangeEnd;

  /// Create a copy with modified fields (immutable update pattern)
  TaskFilter copyWith({
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? searchQuery,
    String? tagFilter,
    bool? showOverdueOnly,
    bool? showDueSoonOnly,
    TaskSortField? sortField,
    SortOrder? sortOrder,
    DateTime? dateRangeStart,
    DateTime? dateRangeEnd,
  }) {
    return TaskFilter(
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      tagFilter: tagFilter ?? this.tagFilter,
      showOverdueOnly: showOverdueOnly ?? this.showOverdueOnly,
      showDueSoonOnly: showDueSoonOnly ?? this.showDueSoonOnly,
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
      dateRangeStart: dateRangeStart ?? this.dateRangeStart,
      dateRangeEnd: dateRangeEnd ?? this.dateRangeEnd,
    );
  }

  /// Create default filter (no filters, sort by creation date descending)
  factory TaskFilter.defaultFilter() {
    return const TaskFilter();
  }

  /// Create filter for active tasks only
  factory TaskFilter.activeTasks() {
    return const TaskFilter(
      statusFilter: TaskStatus.pending,
    );
  }

  /// Create filter for completed tasks only
  factory TaskFilter.completedTasks() {
    return const TaskFilter(
      statusFilter: TaskStatus.completed,
      sortField: TaskSortField.createdAt,
      sortOrder: SortOrder.descending,
    );
  }

  /// Create filter for high priority tasks
  factory TaskFilter.highPriorityTasks() {
    return const TaskFilter(
      priorityFilter: TaskPriority.high,
      sortField: TaskSortField.priority,
      sortOrder: SortOrder.descending,
    );
  }

  /// Create filter for overdue tasks
  factory TaskFilter.overdueTasks() {
    return const TaskFilter(
      showOverdueOnly: true,
      sortField: TaskSortField.dueDate,
      sortOrder: SortOrder.ascending,
    );
  }

  /// Create filter for tasks due soon
  factory TaskFilter.tasksDueSoon() {
    return const TaskFilter(
      showDueSoonOnly: true,
      sortField: TaskSortField.dueDate,
      sortOrder: SortOrder.ascending,
    );
  }

  /// Clear all filters except sorting
  TaskFilter clearFilters() {
    return TaskFilter(
      sortField: sortField,
      sortOrder: sortOrder,
    );
  }

  /// Clear search query
  TaskFilter clearSearch() {
    return copyWith(searchQuery: '');
  }

  /// Apply search query
  TaskFilter withSearch(String query) {
    return copyWith(searchQuery: query.trim());
  }

  /// Toggle sort order
  TaskFilter toggleSortOrder() {
    return copyWith(
      sortOrder: sortOrder == SortOrder.ascending 
          ? SortOrder.descending 
          : SortOrder.ascending,
    );
  }

  /// Check if task matches this filter
  bool matches(Task task) {
    // Status filter
    if (statusFilter != null && task.status != statusFilter) {
      return false;
    }

    // Priority filter
    if (priorityFilter != null && task.priority != priorityFilter) {
      return false;
    }

    // Search query filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      final titleMatch = task.title.toLowerCase().contains(query);
      final descriptionMatch = task.description.toLowerCase().contains(query);
      final tagMatch = task.tags.any((tag) => tag.toLowerCase().contains(query));
      
      if (!titleMatch && !descriptionMatch && !tagMatch) {
        return false;
      }
    }

    // Tag filter
    if (tagFilter != null && !task.tags.contains(tagFilter)) {
      return false;
    }

    // Overdue filter
    if (showOverdueOnly && !task.isOverdue) {
      return false;
    }

    // Due soon filter
    if (showDueSoonOnly && !task.isDueSoon) {
      return false;
    }

    // Date range filter
    if (dateRangeStart != null && task.createdAt.isBefore(dateRangeStart!)) {
      return false;
    }

    if (dateRangeEnd != null && task.createdAt.isAfter(dateRangeEnd!)) {
      return false;
    }

    return true;
  }

  /// Apply filter and sorting to a list of tasks
  List<Task> apply(List<Task> tasks) {
    // First, filter the tasks
    List<Task> filteredTasks = tasks.where(matches).toList();

    // Then, sort the filtered tasks
    filteredTasks.sort((a, b) {
      int comparison;

      switch (sortField) {
        case TaskSortField.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case TaskSortField.dueDate:
          // Handle null due dates (put them at the end)
          if (a.dueDate == null && b.dueDate == null) {
            comparison = 0;
          } else if (a.dueDate == null) {
            comparison = 1;
          } else if (b.dueDate == null) {
            comparison = -1;
          } else {
            comparison = a.dueDate!.compareTo(b.dueDate!);
          }
          break;
        case TaskSortField.priority:
          comparison = a.priority.value.compareTo(b.priority.value);
          break;
        case TaskSortField.title:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case TaskSortField.status:
          comparison = a.status.index.compareTo(b.status.index);
          break;
      }

      // Apply sort order
      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return filteredTasks;
  }

  /// Get a summary of active filters
  Map<String, String> get activeFiltersSummary {
    final summary = <String, String>{};

    if (statusFilter != null) {
      summary['Status'] = statusFilter!.label;
    }

    if (priorityFilter != null) {
      summary['Priority'] = priorityFilter!.label;
    }

    if (searchQuery.isNotEmpty) {
      summary['Search'] = '"$searchQuery"';
    }

    if (tagFilter != null) {
      summary['Tag'] = tagFilter!;
    }

    if (showOverdueOnly) {
      summary['Special'] = 'Overdue Only';
    }

    if (showDueSoonOnly) {
      summary['Special'] = 'Due Soon Only';
    }

    if (dateRangeStart != null || dateRangeEnd != null) {
      summary['Date Range'] = 'Custom Range';
    }

    return summary;
  }

  /// Check if any filters are active
  bool get hasActiveFilters {
    return statusFilter != null ||
           priorityFilter != null ||
           searchQuery.isNotEmpty ||
           tagFilter != null ||
           showOverdueOnly ||
           showDueSoonOnly ||
           dateRangeStart != null ||
           dateRangeEnd != null;
  }

  /// Get count of active filters
  int get activeFilterCount {
    return activeFiltersSummary.length;
  }

  /// Get sort description
  String get sortDescription {
    return '${sortField.label} (${sortOrder.label})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskFilter &&
        other.statusFilter == statusFilter &&
        other.priorityFilter == priorityFilter &&
        other.searchQuery == searchQuery &&
        other.tagFilter == tagFilter &&
        other.showOverdueOnly == showOverdueOnly &&
        other.showDueSoonOnly == showDueSoonOnly &&
        other.sortField == sortField &&
        other.sortOrder == sortOrder &&
        other.dateRangeStart == dateRangeStart &&
        other.dateRangeEnd == dateRangeEnd;
  }

  @override
  int get hashCode {
    return Object.hash(
      statusFilter,
      priorityFilter,
      searchQuery,
      tagFilter,
      showOverdueOnly,
      showDueSoonOnly,
      sortField,
      sortOrder,
      dateRangeStart,
      dateRangeEnd,
    );
  }

  @override
  String toString() {
    return 'TaskFilter('
        'status: $statusFilter, '
        'priority: $priorityFilter, '
        'search: "$searchQuery", '
        'activeFilters: $activeFilterCount, '
        'sort: ${sortField.label} ${sortOrder.label}'
        ')';
  }
}

/// Predefined filter presets for common use cases
class TaskFilterPresets {
  /// Private constructor
  const TaskFilterPresets._();

  /// All tasks (default view)
  static const TaskFilter all = TaskFilter();

  /// Active tasks only
  static const TaskFilter active = TaskFilter(
    statusFilter: TaskStatus.pending,
  );

  /// In progress tasks
  static const TaskFilter inProgress = TaskFilter(
    statusFilter: TaskStatus.inProgress,
  );

  /// Completed tasks
  static const TaskFilter completed = TaskFilter(
    statusFilter: TaskStatus.completed,
  );

  /// High priority tasks
  static const TaskFilter highPriority = TaskFilter(
    priorityFilter: TaskPriority.high,
  );

  /// Urgent tasks
  static const TaskFilter urgent = TaskFilter(
    priorityFilter: TaskPriority.urgent,
  );

  /// Overdue tasks
  static const TaskFilter overdue = TaskFilter(
    showOverdueOnly: true,
    sortField: TaskSortField.dueDate,
  );

  /// Tasks due soon
  static const TaskFilter dueSoon = TaskFilter(
    showDueSoonOnly: true,
    sortField: TaskSortField.dueDate,
  );

  /// Recent tasks (sorted by creation date)
  static const TaskFilter recent = TaskFilter(
    sortField: TaskSortField.createdAt,
    sortOrder: SortOrder.descending,
  );

  /// Get all preset filters
  static List<TaskFilter> get allPresets => [
    all,
    active,
    inProgress,
    completed,
    highPriority,
    urgent,
    overdue,
    dueSoon,
    recent,
  ];

  /// Get preset labels
  static const Map<TaskFilter, String> presetLabels = {
    all: 'All Tasks',
    active: 'Active',
    inProgress: 'In Progress',
    completed: 'Completed',
    highPriority: 'High Priority',
    urgent: 'Urgent',
    overdue: 'Overdue',
    dueSoon: 'Due Soon',
    recent: 'Recent',
  };

  /// Get preset icons
  static const Map<TaskFilter, IconData> presetIcons = {
    all: Icons.list,
    active: Icons.play_circle_outline,
    inProgress: Icons.pending,
    completed: Icons.check_circle_outline,
    highPriority: Icons.priority_high,
    urgent: Icons.warning,
    overdue: Icons.schedule,
    dueSoon: Icons.access_time,
    recent: Icons.history,
  };
}