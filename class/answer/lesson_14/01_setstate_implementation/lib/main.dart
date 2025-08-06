import 'package:flutter/material.dart';
import '../../shared/models/todo.dart';
import '../../shared/models/todo_filter.dart';
import 'widgets/todo_list_widget.dart';
import 'widgets/add_todo_widget.dart';
import 'widgets/filter_widget.dart';
import 'widgets/performance_monitor.dart';

void main() {
  runApp(const SetStateApp());
}

class SetStateApp extends StatelessWidget {
  const SetStateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'setState Implementation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const SetStateTodoApp(),
    );
  }
}

class SetStateTodoApp extends StatefulWidget {
  const SetStateTodoApp({super.key});

  @override
  State<SetStateTodoApp> createState() => _SetStateTodoAppState();
}

class _SetStateTodoAppState extends State<SetStateTodoApp> {
  List<Todo> _todos = [];
  TodoFilter _filter = const TodoFilter();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _todos = [
          Todo.create(
            title: 'Learn setState Pattern',
            description: 'Understand StatefulWidget lifecycle and setState usage',
            priority: TodoPriority.high,
            tags: ['learning', 'flutter'],
          ),
          Todo.create(
            title: 'Implement Todo App',
            description: 'Build a todo application using setState',
            priority: TodoPriority.medium,
            dueDate: DateTime.now().add(const Duration(days: 3)),
            tags: ['development', 'project'],
          ),
          Todo.create(
            title: 'Performance Analysis',
            description: 'Analyze setState performance characteristics',
            priority: TodoPriority.low,
            tags: ['analysis', 'performance'],
          ),
        ];
        _isLoading = false;
      });
    });
  }

  void _addTodo(Todo todo) {
    setState(() {
      _todos = [..._todos, todo];
    });
  }

  void _updateTodo(Todo updatedTodo) {
    setState(() {
      _todos = _todos.map((todo) {
        return todo.id == updatedTodo.id ? updatedTodo : todo;
      }).toList();
    });
  }

  void _deleteTodo(String todoId) {
    setState(() {
      _todos = _todos.where((todo) => todo.id != todoId).toList();
    });
  }

  void _toggleTodoCompletion(String todoId) {
    setState(() {
      _todos = _todos.map((todo) {
        if (todo.id == todoId) {
          return todo.isCompleted ? todo.markPending() : todo.markCompleted();
        }
        return todo;
      }).toList();
    });
  }

  void _updateFilter(TodoFilter newFilter) {
    setState(() {
      _filter = newFilter;
    });
  }

  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  List<Todo> get _filteredTodos => _filter.apply(_todos);

  Map<String, int> get _statistics {
    return {
      'total': _todos.length,
      'completed': _todos.where((todo) => todo.isCompleted).length,
      'pending': _todos.where((todo) => todo.isPending).length,
      'overdue': _todos.where((todo) => todo.isOverdue).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('setState Implementation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSampleData,
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showStatistics(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Performance Monitor
          PerformanceMonitor(
            pattern: 'setState',
            todosCount: _todos.length,
            filteredCount: _filteredTodos.length,
            rebuildsCount: _getRebuildCount(),
          ),
          
          // Filter Widget
          FilterWidget(
            filter: _filter,
            onFilterChanged: _updateFilter,
            availableTags: _getAvailableTags(),
          ),
          
          // Error Display
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              color: Colors.red.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_errorMessage!)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _clearError,
                  ),
                ],
              ),
            ),
          ],
          
          // Todo List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TodoListWidget(
                    todos: _filteredTodos,
                    onTodoToggled: _toggleTodoCompletion,
                    onTodoUpdated: _updateTodo,
                    onTodoDeleted: _deleteTodo,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTodoWidget(
        onTodoAdded: _addTodo,
      ),
    );
  }

  void _showStatistics(BuildContext context) {
    final stats = _statistics;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: ${stats['total']}'),
            Text('Completed: ${stats['completed']}'),
            Text('Pending: ${stats['pending']}'),
            Text('Overdue: ${stats['overdue']}'),
            const SizedBox(height: 16),
            Text('Pattern: setState'),
            Text('Rebuilds: ${_getRebuildCount()}'),
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

  List<String> _getAvailableTags() {
    final tagSet = <String>{};
    for (final todo in _todos) {
      tagSet.addAll(todo.tags);
    }
    return tagSet.toList();
  }

  int _getRebuildCount() {
    // In a real implementation, this would track actual rebuilds
    // For demo purposes, we estimate based on state changes
    return _todos.length * 2; // Approximate rebuild count
  }
}