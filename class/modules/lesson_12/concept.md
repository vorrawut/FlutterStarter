# 🎯 Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **Riverpod Fundamentals** - Understanding the evolution from Provider to Riverpod 2.0
- **Provider Types** - StateProvider, StateNotifierProvider, FutureProvider, StreamProvider
- **Async State Management** - Handling loading, data, and error states with AsyncValue
- **Provider Modifiers** - autoDispose, family, and advanced provider patterns
- **Compile-time Safety** - Type-safe state management without BuildContext dependencies
- **Testing Excellence** - Superior testing patterns with ProviderContainer
- **Clean Architecture** - Integrating Riverpod with domain-driven design patterns

## 📚 **Core Concepts**

### **1. What is Riverpod and Why Use It?**

Riverpod (anagram of Provider) is a complete rewrite of Provider that addresses its limitations while adding powerful new features.

#### **Provider vs Riverpod Comparison**
```dart
// ❌ Provider - Requires BuildContext, runtime errors possible
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Runtime error if provider not found
    final cart = context.watch<ShoppingCart>();
    
    // Must use context for access
    return ElevatedButton(
      onPressed: () {
        context.read<ShoppingCart>().addItem(product);
      },
      child: Text('Add to Cart'),
    );
  }
}

// ✅ Riverpod - No BuildContext required, compile-time safety
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Compile-time safety
    final cart = ref.watch(cartProvider);
    
    // No context required for mutations
    return ElevatedButton(
      onPressed: () {
        ref.read(cartProvider.notifier).addItem(product);
      },
      child: Text('Add to Cart'),
    );
  }
}
```

#### **Key Advantages of Riverpod**
1. **Compile-time Safety** - Provider existence verified at compile time
2. **No BuildContext Dependency** - Access providers anywhere, including in business logic
3. **Better Async Support** - Built-in loading, data, and error states
4. **Superior Testing** - Test providers in isolation with ProviderContainer
5. **Performance Optimizations** - Automatic disposal and fine-grained rebuilds
6. **Developer Experience** - Better error messages and debugging tools

### **2. Provider Types in Riverpod**

Riverpod offers different provider types for different use cases:

#### **Provider - For Immutable Values**
```dart
// Simple values that don't change
final apiBaseUrlProvider = Provider<String>((ref) {
  return 'https://api.example.com';
});

// Computed values
final formattedDateProvider = Provider<String>((ref) {
  final now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
});

// Dependency injection
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

// Usage
class ApiService {
  ApiService(this.ref);
  final Ref ref;
  
  Future<List<Todo>> fetchTodos() async {
    final baseUrl = ref.read(apiBaseUrlProvider);
    final client = ref.read(httpClientProvider);
    
    final response = await client.get(Uri.parse('$baseUrl/todos'));
    // ... handle response
  }
}
```

#### **StateProvider - For Simple Mutable State**
```dart
// Simple state like counters, selections, toggles
final counterProvider = StateProvider<int>((ref) => 0);
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// Usage in widgets
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('Count: $counter'),
        ElevatedButton(
          onPressed: () {
            // Increment state
            ref.read(counterProvider.notifier).state++;
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

#### **StateNotifierProvider - For Complex State Management**
```dart
// Complex state with business logic
class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);
  
  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    state = [...state, newTodo];
  }
  
  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
  }
  
  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
  
  void updateTodo(String id, String newTitle) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(title: newTitle)
        else
          todo,
    ];
  }
}

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>(
  (ref) => TodoList(),
);

// Usage
class TodoListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.title),
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) {
              ref.read(todoListProvider.notifier).toggleTodo(todo.id);
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(todoListProvider.notifier).removeTodo(todo.id);
            },
          ),
        );
      },
    );
  }
}
```

#### **FutureProvider - For Async Operations**
```dart
// Async data fetching
final todosProvider = FutureProvider<List<Todo>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchTodos();
});

// Dependent async providers
final userTodosProvider = FutureProvider.family<List<Todo>, String>((ref, userId) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchUserTodos(userId);
});

// Usage with AsyncValue
class TodosWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosProvider);
    
    return todosAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
      data: (todos) => ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return TodoItem(todo: todos[index]);
        },
      ),
    );
  }
}
```

#### **StreamProvider - For Real-time Data**
```dart
// Real-time data streams
final todoStreamProvider = StreamProvider<List<Todo>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return apiService.todoStream(); // Returns Stream<List<Todo>>
});

// Firebase Firestore example
final firebaseTodosProvider = StreamProvider<List<Todo>>((ref) {
  return FirebaseFirestore.instance
      .collection('todos')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Todo.fromJson(doc.data()))
          .toList());
});

// Usage
class RealTimeTodosWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosStream = ref.watch(todoStreamProvider);
    
    return todosStream.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Stream Error: $error'),
      data: (todos) => ListView(
        children: todos.map((todo) => TodoItem(todo: todo)).toList(),
      ),
    );
  }
}
```

### **3. Provider Modifiers**

Riverpod provides powerful modifiers to customize provider behavior:

#### **autoDispose - Automatic Resource Management**
```dart
// Automatically dispose when no longer used
final autoDisposeTodosProvider = FutureProvider.autoDispose<List<Todo>>((ref) async {
  // This provider will be disposed when no widgets are listening
  final apiService = ref.read(apiServiceProvider);
  
  // Add disposal logic
  ref.onDispose(() {
    print('Disposing todos provider');
    // Clean up resources, cancel timers, etc.
  });
  
  return await apiService.fetchTodos();
});

// Conditional auto-dispose
final conditionalProvider = FutureProvider.autoDispose<String>((ref) async {
  // Keep alive while user is active
  final userActivity = ref.watch(userActivityProvider);
  
  if (userActivity.isActive) {
    ref.keepAlive(); // Prevent disposal
  }
  
  return await fetchData();
});
```

#### **family - Parameterized Providers**
```dart
// Provider that takes parameters
final todoProvider = FutureProvider.family<Todo, String>((ref, todoId) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchTodo(todoId);
});

// Multiple parameters with custom class
class TodoQuery {
  const TodoQuery({required this.userId, required this.category});
  final String userId;
  final String category;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoQuery &&
      runtimeType == other.runtimeType &&
      userId == other.userId &&
      category == other.category;
  
  @override
  int get hashCode => userId.hashCode ^ category.hashCode;
}

final filteredTodosProvider = FutureProvider.family<List<Todo>, TodoQuery>(
  (ref, query) async {
    final apiService = ref.read(apiServiceProvider);
    return await apiService.fetchFilteredTodos(
      userId: query.userId,
      category: query.category,
    );
  },
);

// Usage
class TodoDetailWidget extends ConsumerWidget {
  final String todoId;
  
  const TodoDetailWidget({required this.todoId});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAsync = ref.watch(todoProvider(todoId));
    
    return todoAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (todo) => TodoDetails(todo: todo),
    );
  }
}
```

### **4. AsyncValue - Handling Async States**

AsyncValue is Riverpod's powerful way to handle async operations with built-in loading, data, and error states.

#### **AsyncValue Patterns**
```dart
class TodoService extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoService() : super(const AsyncValue.loading()) {
    _loadTodos();
  }
  
  Future<void> _loadTodos() async {
    try {
      final todos = await ApiService.fetchTodos();
      state = AsyncValue.data(todos);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> addTodo(String title) async {
    // Optimistic update
    state.whenData((todos) {
      final newTodo = Todo(id: 'temp', title: title, isCompleted: false);
      state = AsyncValue.data([...todos, newTodo]);
    });
    
    try {
      final newTodo = await ApiService.createTodo(title);
      state.whenData((todos) {
        final updatedTodos = todos.map((todo) {
          return todo.id == 'temp' ? newTodo : todo;
        }).toList();
        state = AsyncValue.data(updatedTodos);
      });
    } catch (error, stackTrace) {
      // Rollback on error
      state.whenData((todos) {
        final rolledBackTodos = todos.where((todo) => todo.id != 'temp').toList();
        state = AsyncValue.data(rolledBackTodos);
      });
      
      // Show error
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadTodos();
  }
}

final todoServiceProvider = StateNotifierProvider<TodoService, AsyncValue<List<Todo>>>(
  (ref) => TodoService(),
);

// Advanced AsyncValue usage
class TodoListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoServiceProvider);
    
    return Scaffold(
      body: todosAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(error, ref),
        data: (todos) => _buildDataState(todos, ref),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading todos...'),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Error: $error'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(todoServiceProvider.notifier).refresh();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDataState(List<Todo> todos, WidgetRef ref) {
    if (todos.isEmpty) {
      return _buildEmptyState(ref);
    }
    
    return RefreshIndicator(
      onRefresh: () => ref.read(todoServiceProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return TodoItem(todo: todos[index]);
        },
      ),
    );
  }
  
  Widget _buildEmptyState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No todos yet'),
          SizedBox(height: 8),
          Text('Add one to get started'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to add todo screen
            },
            child: Text('Add Todo'),
          ),
        ],
      ),
    );
  }
}
```

### **5. Consumer Widgets and Hooks**

Riverpod provides different ways to consume providers in widgets:

#### **ConsumerWidget**
```dart
// Replace StatelessWidget with ConsumerWidget
class TodoCounter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final completedCount = todos.where((todo) => todo.isCompleted).length;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Total: ${todos.length}'),
            Text('Completed: $completedCount'),
            Text('Remaining: ${todos.length - completedCount}'),
          ],
        ),
      ),
    );
  }
}
```

#### **ConsumerStatefulWidget**
```dart
// Replace StatefulWidget with ConsumerStatefulWidget
class TodoForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _submitTodo() async {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      await ref.read(todoServiceProvider.notifier).addTodo(_controller.text.trim());
      _controller.clear();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Add a todo',
                border: OutlineInputBorder(),
              ),
              enabled: !_isSubmitting,
              onSubmitted: (_) => _submitTodo(),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitTodo,
            child: _isSubmitting
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Add'),
          ),
        ],
      ),
    );
  }
}
```

#### **Consumer Builder**
```dart
// Use Consumer widget for selective rebuilds
class TodoStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Todo Statistics'),
            SizedBox(height: 8),
            // Only this Consumer rebuilds when todos change
            Consumer(
              builder: (context, ref, child) {
                final todos = ref.watch(todoListProvider);
                return Text('Total: ${todos.length}');
              },
            ),
            // This doesn't rebuild
            Text('App Version: 1.0.0'),
          ],
        ),
      ),
    );
  }
}
```

### **6. Testing with Riverpod**

Riverpod's testing capabilities are significantly better than Provider:

#### **Unit Testing Providers**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoList Tests', () {
    test('should start with empty list', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      final todos = container.read(todoListProvider);
      expect(todos, isEmpty);
    });
    
    test('should add todo', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      final notifier = container.read(todoListProvider.notifier);
      notifier.addTodo('Test Todo');
      
      final todos = container.read(todoListProvider);
      expect(todos.length, equals(1));
      expect(todos.first.title, equals('Test Todo'));
    });
    
    test('should toggle todo completion', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      final notifier = container.read(todoListProvider.notifier);
      notifier.addTodo('Test Todo');
      
      final todoId = container.read(todoListProvider).first.id;
      notifier.toggleTodo(todoId);
      
      final todos = container.read(todoListProvider);
      expect(todos.first.isCompleted, isTrue);
    });
  });
  
  group('Async Provider Tests', () {
    test('should handle async operations', () async {
      final container = ProviderContainer(
        overrides: [
          // Mock the API service
          apiServiceProvider.overrideWithValue(MockApiService()),
        ],
      );
      addTearDown(container.dispose);
      
      final todosAsync = container.read(todosProvider.future);
      final todos = await todosAsync;
      
      expect(todos, isA<List<Todo>>());
    });
  });
}
```

#### **Widget Testing with Riverpod**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoListWidget Tests', () {
    testWidgets('should display todos', (tester) async {
      final mockTodos = [
        Todo(id: '1', title: 'Test Todo 1', isCompleted: false),
        Todo(id: '2', title: 'Test Todo 2', isCompleted: true),
      ];
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoListProvider.overrideWith((ref) => mockTodos),
          ],
          child: MaterialApp(
            home: TodoListWidget(),
          ),
        ),
      );
      
      expect(find.text('Test Todo 1'), findsOneWidget);
      expect(find.text('Test Todo 2'), findsOneWidget);
    });
    
    testWidgets('should add todo when form submitted', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TodoForm(),
                  Expanded(child: TodoListWidget()),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Enter text in the form
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.tap(find.text('Add'));
      await tester.pump();
      
      // Verify todo was added
      expect(find.text('New Todo'), findsOneWidget);
    });
  });
}
```

### **7. Clean Architecture with Riverpod**

Riverpod integrates beautifully with clean architecture patterns:

#### **Domain Layer Providers**
```dart
// Use cases as providers
final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return AddTodoUseCase(repository);
});

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return GetTodosUseCase(repository);
});

// Repository providers
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dataSource = ref.read(todoDataSourceProvider);
  return TodoRepositoryImpl(dataSource);
});
```

#### **Data Layer Providers**
```dart
// Data sources
final todoDataSourceProvider = Provider<TodoDataSource>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return RemoteTodoDataSource(httpClient);
});

final localTodoDataSourceProvider = Provider<LocalTodoDataSource>((ref) {
  return HiveTodoDataSource();
});

// HTTP client
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});
```

#### **Presentation Layer State Management**
```dart
// Presentation logic with use cases
class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadTodos();
  }
  
  final Ref ref;
  
  Future<void> _loadTodos() async {
    try {
      final useCase = ref.read(getTodosUseCaseProvider);
      final todos = await useCase.execute();
      state = AsyncValue.data(todos);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> addTodo(String title) async {
    try {
      final useCase = ref.read(addTodoUseCaseProvider);
      await useCase.execute(title);
      await _loadTodos(); // Refresh list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>(
  (ref) => TodoNotifier(ref),
);
```

## 🌟 **Key Takeaways**

1. **Evolution from Provider** - Riverpod addresses Provider limitations while adding powerful features
2. **Compile-time Safety** - Provider existence and types verified at compile time
3. **No BuildContext Dependency** - Access providers in business logic without context
4. **Superior Async Support** - Built-in AsyncValue for loading, data, and error states
5. **Advanced Modifiers** - autoDispose and family for flexible provider behavior
6. **Testing Excellence** - ProviderContainer enables comprehensive testing strategies
7. **Clean Architecture** - Perfect integration with domain-driven design patterns

Understanding Riverpod 2.0 is essential for building scalable, maintainable Flutter applications with advanced state management needs. It builds upon Provider concepts while offering superior type safety, testing capabilities, and async handling.

**Ready to master the future of Flutter state management? 🚀✨**