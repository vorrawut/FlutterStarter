import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/todo.dart';
import '../core/models/todo_filter.dart';
import 'todo_providers.dart';

// Individual filter state providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final statusFilterProvider = StateProvider<TodoStatus?>((ref) => null);
final priorityFilterProvider = StateProvider<TodoPriority?>((ref) => null);
final tagsFilterProvider = StateProvider<List<String>>((ref) => []);
final showOverdueOnlyProvider = StateProvider<bool>((ref) => false);

// Sort configuration
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

final sortConfigProvider = StateProvider<SortConfig>((ref) {
  return const SortConfig();
});

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

// Family providers for specific filtering
final todosByTagProvider = Provider.family<List<Todo>, String>((ref, tag) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (todos) => todos.where((todo) => todo.tags.contains(tag)).toList(),
  );
});

final todosByPriorityProvider = Provider.family<List<Todo>, TodoPriority>((ref, priority) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (todos) => todos.where((todo) => todo.priority == priority).toList(),
  );
});

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

// Filter actions helper class
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