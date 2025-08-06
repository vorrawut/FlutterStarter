import 'package:equatable/equatable.dart';
import 'todo.dart';

enum TodoSortBy { createdAt, dueDate, priority, title, status }

class TodoFilter extends Equatable {
  final String searchQuery;
  final TodoStatus? status;
  final TodoPriority? priority;
  final List<String> tags;
  final bool showOverdueOnly;
  final TodoSortBy sortBy;
  final bool sortAscending;

  const TodoFilter({
    this.searchQuery = '',
    this.status,
    this.priority,
    this.tags = const [],
    this.showOverdueOnly = false,
    this.sortBy = TodoSortBy.createdAt,
    this.sortAscending = false,
  });

  TodoFilter copyWith({
    String? searchQuery,
    TodoStatus? status,
    TodoPriority? priority,
    List<String>? tags,
    bool? showOverdueOnly,
    TodoSortBy? sortBy,
    bool? sortAscending,
  }) {
    return TodoFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      showOverdueOnly: showOverdueOnly ?? this.showOverdueOnly,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  List<Todo> apply(List<Todo> todos) {
    var filtered = todos.where((todo) {
      // Search query filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!todo.title.toLowerCase().contains(query) &&
            !todo.description.toLowerCase().contains(query) &&
            !todo.tags.any((tag) => tag.toLowerCase().contains(query))) {
          return false;
        }
      }

      // Status filter
      if (status != null && todo.status != status) {
        return false;
      }

      // Priority filter
      if (priority != null && todo.priority != priority) {
        return false;
      }

      // Tags filter
      if (tags.isNotEmpty && !tags.any((tag) => todo.tags.contains(tag))) {
        return false;
      }

      // Overdue filter
      if (showOverdueOnly && !todo.isOverdue) {
        return false;
      }

      return true;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;

      switch (sortBy) {
        case TodoSortBy.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case TodoSortBy.dueDate:
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
        case TodoSortBy.priority:
          comparison = a.priority.index.compareTo(b.priority.index);
          break;
        case TodoSortBy.title:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case TodoSortBy.status:
          comparison = a.status.index.compareTo(b.status.index);
          break;
      }

      return sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  bool get hasActiveFilters {
    return searchQuery.isNotEmpty ||
        status != null ||
        priority != null ||
        tags.isNotEmpty ||
        showOverdueOnly;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        status,
        priority,
        tags,
        showOverdueOnly,
        sortBy,
        sortAscending,
      ];
}