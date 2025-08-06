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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).login(
                    'demo@todomaster.com',
                    'password',
                  );
                },
                child: const Text('Retry'),
              ),
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
            const Text('Welcome to TodoMaster Pro'),
            const Text('Please log in to view your todos'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).login(
                  'demo@todomaster.com',
                  'password',
                );
              },
              child: const Text('Demo Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoMaster Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(todoNotifierProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            onPressed: () async {
              try {
                await ref.read(todoNotifierProvider.notifier).syncWithCloud();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Synced with cloud successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sync failed: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (action) {
              switch (action) {
                case 'logout':
                  ref.read(authNotifierProvider.notifier).logout();
                  break;
                case 'analytics':
                  _showAnalytics();
                  break;
                case 'profile':
                  _showProfile();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'analytics', child: Text('Analytics')),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddTodo(),
        icon: const Icon(Icons.add),
        label: const Text('Add Todo'),
      ),
    );
  }

  Widget _buildTodosList() {
    final filteredTodosAsync = ref.watch(filteredTodosProvider);
    
    return filteredTodosAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading todos...'),
          ],
        ),
      ),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
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
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              textAlign: TextAlign.center,
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

  void _showAnalytics() {
    final analytics = ref.read(analyticsProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analytics'),
        content: analytics.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Error: $error'),
          data: (data) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Todos: ${data['total']}'),
              Text('Completed: ${data['completed']}'),
              Text('Completion Rate: ${((data['completionRate'] ?? 0.0) * 100).toStringAsFixed(1)}%'),
              Text('Overdue: ${data['overdue']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showProfile() {
    final user = ref.read(currentUserProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user?.name}'),
            Text('Email: ${user?.email}'),
            Text('User ID: ${user?.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}