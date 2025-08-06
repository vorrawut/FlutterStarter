import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/dependency_injection.dart';
import '../core/models/todo.dart';
import '../core/services/api_service.dart';
import 'auth_providers.dart';

// Todo state notifier for managing todo operations
class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoNotifier(this._apiService, this._userId) : super(const AsyncValue.loading()) {
    if (_userId != null) {
      _initializeTodos();
    }
  }

  final ApiService _apiService;
  final String? _userId;

  Future<void> _initializeTodos() async {
    try {
      if (_userId == null) {
        state = const AsyncValue.data([]);
        return;
      }

      // Initialize sample data for demo
      _apiService.initializeSampleData(_userId!);
      
      final todos = await _apiService.fetchTodos(_userId!);
      state = AsyncValue.data(todos);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
  }) async {
    if (_userId == null) return;

    final newTodo = Todo.create(
      title: title,
      description: description,
      userId: _userId!,
      priority: priority,
      dueDate: dueDate,
      tags: tags,
    );

    // Optimistic update
    state.whenData((todos) {
      state = AsyncValue.data([...todos, newTodo]);
    });

    try {
      final createdTodo = await _apiService.createTodo(newTodo);
      
      // Update with server response
      state.whenData((todos) {
        final updatedTodos = todos.map((todo) {
          return todo.id == newTodo.id ? createdTodo : todo;
        }).toList();
        state = AsyncValue.data(updatedTodos);
      });
    } catch (error) {
      // Rollback optimistic update
      state.whenData((todos) {
        final rolledBackTodos = todos.where((todo) => todo.id != newTodo.id).toList();
        state = AsyncValue.data(rolledBackTodos);
      });
      rethrow;
    }
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    if (_userId == null) return;

    // Optimistic update
    state.whenData((todos) {
      final updatedTodos = todos.map((todo) {
        return todo.id == updatedTodo.id ? updatedTodo : todo;
      }).toList();
      state = AsyncValue.data(updatedTodos);
    });

    try {
      final serverTodo = await _apiService.updateTodo(updatedTodo);
      
      // Update with server response
      state.whenData((todos) {
        final updatedTodos = todos.map((todo) {
          return todo.id == serverTodo.id ? serverTodo : todo;
        }).toList();
        state = AsyncValue.data(updatedTodos);
      });
    } catch (error) {
      // Rollback on error - would need to store original state for proper rollback
      await refresh();
      rethrow;
    }
  }

  Future<void> deleteTodo(String todoId) async {
    if (_userId == null) return;

    Todo? deletedTodo;
    
    // Optimistic update
    state.whenData((todos) {
      deletedTodo = todos.firstWhere((todo) => todo.id == todoId);
      final updatedTodos = todos.where((todo) => todo.id != todoId).toList();
      state = AsyncValue.data(updatedTodos);
    });

    try {
      await _apiService.deleteTodo(todoId);
    } catch (error) {
      // Rollback optimistic update
      if (deletedTodo != null) {
        state.whenData((todos) {
          state = AsyncValue.data([...todos, deletedTodo!]);
        });
      }
      rethrow;
    }
  }

  Future<void> toggleTodoCompletion(String todoId) async {
    final currentTodos = state.valueOrNull ?? [];
    final todo = currentTodos.firstWhere((t) => t.id == todoId);
    
    final updatedTodo = todo.isCompleted 
        ? todo.markPending() 
        : todo.markCompleted();
    
    await updateTodo(updatedTodo);
  }

  Future<void> updateTodoStatus(String todoId, TodoStatus status) async {
    final currentTodos = state.valueOrNull ?? [];
    final todo = currentTodos.firstWhere((t) => t.id == todoId);
    final updatedTodo = todo.updateStatus(status);
    
    await updateTodo(updatedTodo);
  }

  Future<void> refresh() async {
    if (_userId == null) return;
    
    try {
      state = const AsyncValue.loading();
      final todos = await _apiService.fetchTodos(_userId!);
      state = AsyncValue.data(todos);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> syncWithCloud() async {
    if (_userId == null) return;
    
    final currentTodos = state.valueOrNull ?? [];
    
    try {
      await _apiService.syncTodos(_userId!, currentTodos);
      await refresh(); // Refresh after sync
    } catch (error, stackTrace) {
      // Don't update state on sync error, just rethrow
      rethrow;
    }
  }
}

// Main todo provider
final todoNotifierProvider = StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  return TodoNotifier(apiService, userId);
});

// Computed providers for todo statistics
final todoStatsProvider = Provider<Map<String, int>>((ref) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => {},
    error: (_, __) => {},
    data: (todos) {
      return {
        'total': todos.length,
        'completed': todos.where((todo) => todo.isCompleted).length,
        'pending': todos.where((todo) => todo.status == TodoStatus.pending).length,
        'inProgress': todos.where((todo) => todo.status == TodoStatus.inProgress).length,
        'overdue': todos.where((todo) => todo.isOverdue).length,
      };
    },
  );
});

// Provider for todo count by priority
final todoCountByPriorityProvider = Provider<Map<TodoPriority, int>>((ref) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.when(
    loading: () => {},
    error: (_, __) => {},
    data: (todos) {
      final counts = <TodoPriority, int>{};
      for (final priority in TodoPriority.values) {
        counts[priority] = todos.where((todo) => todo.priority == priority).length;
      }
      return counts;
    },
  );
});

// Provider for completion rate
final completionRateProvider = Provider<double>((ref) {
  final stats = ref.watch(todoStatsProvider);
  final total = stats['total'] ?? 0;
  final completed = stats['completed'] ?? 0;
  
  return total > 0 ? completed / total : 0.0;
});

// Provider for analytics data
final analyticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) return {};
  
  return await apiService.getAnalytics(userId);
});