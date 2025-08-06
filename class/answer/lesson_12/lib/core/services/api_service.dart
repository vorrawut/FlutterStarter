import 'dart:convert';
import 'dart:math';
import '../models/todo.dart';

// Simulated API service for demonstration
class ApiService {
  final Duration _networkDelay = const Duration(milliseconds: 500);
  final List<Todo> _mockTodos = [];
  final Random _random = Random();

  // Simulate network requests with realistic delays
  Future<List<Todo>> fetchTodos(String userId) async {
    await Future.delayed(_networkDelay);
    
    // Simulate occasional network errors
    if (_random.nextDouble() < 0.1) {
      throw Exception('Network error: Failed to fetch todos');
    }

    // Return user-specific todos
    return _mockTodos.where((todo) => todo.userId == userId).toList();
  }

  Future<Todo> createTodo(Todo todo) async {
    await Future.delayed(_networkDelay);
    
    // Simulate validation errors
    if (todo.title.trim().isEmpty) {
      throw Exception('Validation error: Title cannot be empty');
    }

    // Simulate server-side ID assignment
    final createdTodo = todo.copyWith(
      id: _generateId(),
      createdAt: DateTime.now(),
    );
    
    _mockTodos.add(createdTodo);
    return createdTodo;
  }

  Future<Todo> updateTodo(Todo todo) async {
    await Future.delayed(_networkDelay);
    
    final index = _mockTodos.indexWhere((t) => t.id == todo.id);
    if (index == -1) {
      throw Exception('Todo not found');
    }
    
    _mockTodos[index] = todo;
    return todo;
  }

  Future<void> deleteTodo(String todoId) async {
    await Future.delayed(_networkDelay);
    
    final index = _mockTodos.indexWhere((t) => t.id == todoId);
    if (index == -1) {
      throw Exception('Todo not found');
    }
    
    _mockTodos.removeAt(index);
  }

  Future<void> syncTodos(String userId, List<Todo> localTodos) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate cloud synchronization
    final serverTodos = _mockTodos.where((t) => t.userId == userId).toList();
    
    // In a real implementation, this would handle conflict resolution
    // For demo purposes, we'll just merge and prefer local changes
    final syncedTodos = <String, Todo>{};
    
    // Add server todos
    for (final todo in serverTodos) {
      syncedTodos[todo.id] = todo;
    }
    
    // Override with local todos (local wins in conflict)
    for (final todo in localTodos) {
      syncedTodos[todo.id] = todo;
    }
    
    // Update server state
    _mockTodos.removeWhere((t) => t.userId == userId);
    _mockTodos.addAll(syncedTodos.values);
  }

  Future<Map<String, dynamic>> getAnalytics(String userId) async {
    await Future.delayed(_networkDelay);
    
    final userTodos = _mockTodos.where((t) => t.userId == userId);
    
    return {
      'total': userTodos.length,
      'completed': userTodos.where((t) => t.isCompleted).length,
      'pending': userTodos.where((t) => t.status == TodoStatus.pending).length,
      'inProgress': userTodos.where((t) => t.status == TodoStatus.inProgress).length,
      'overdue': userTodos.where((t) => t.isOverdue).length,
      'completionRate': userTodos.isNotEmpty 
          ? userTodos.where((t) => t.isCompleted).length / userTodos.length 
          : 0.0,
    };
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           _random.nextInt(1000).toString();
  }

  // Initialize with sample data for demo
  void initializeSampleData(String userId) {
    if (_mockTodos.any((t) => t.userId == userId)) return;

    final sampleTodos = [
      Todo.create(
        title: 'Learn Riverpod fundamentals',
        description: 'Study the core concepts and provider types',
        userId: userId,
        priority: TodoPriority.high,
        tags: ['learning', 'flutter'],
        dueDate: DateTime.now().add(const Duration(days: 3)),
      ),
      Todo.create(
        title: 'Build a todo app',
        description: 'Implement a production-ready todo application using Riverpod',
        userId: userId,
        priority: TodoPriority.medium,
        tags: ['project', 'riverpod'],
        dueDate: DateTime.now().add(const Duration(days: 7)),
      ),
      Todo.create(
        title: 'Review AsyncValue patterns',
        description: 'Understand loading, data, and error states',
        userId: userId,
        priority: TodoPriority.medium,
        tags: ['async', 'state-management'],
      ).updateStatus(TodoStatus.inProgress),
      Todo.create(
        title: 'Write comprehensive tests',
        description: 'Test providers, widgets, and business logic',
        userId: userId,
        priority: TodoPriority.low,
        tags: ['testing', 'quality'],
        dueDate: DateTime.now().subtract(const Duration(days: 1)), // Overdue
      ),
      Todo.create(
        title: 'Setup CI/CD pipeline',
        description: 'Automated testing and deployment',
        userId: userId,
        priority: TodoPriority.urgent,
        tags: ['devops', 'automation'],
        dueDate: DateTime.now().add(const Duration(days: 14)),
      ).markCompleted(),
    ];

    _mockTodos.addAll(sampleTodos);
  }
}