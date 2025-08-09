# 🚀 Workshop

## 🎯 **What We're Building**

Create a **comprehensive todo application with cloud sync** that demonstrates advanced Riverpod 2.0 patterns:
- **Todo Management** with CRUD operations using StateNotifierProvider
- **Async State Handling** with FutureProvider and AsyncValue patterns
- **Real-time Sync** with StreamProvider for cloud synchronization
- **Advanced Filtering** using family providers and computed state
- **User Authentication** with async providers and state persistence
- **Offline Support** with error handling and optimistic updates
- **Clean Architecture** integrating Riverpod with domain-driven design
- **Comprehensive Testing** with ProviderContainer and mock overrides

## ✅ **Expected Outcome**

A professional todo application featuring:
- 📝 **Smart Todo Management** - Create, edit, complete, and delete todos with async operations
- ☁️ **Cloud Synchronization** - Real-time sync with Firebase and offline support
- 🔍 **Advanced Search & Filtering** - Category filtering, search, and smart sorting
- 👤 **User Authentication** - Secure login with persistent state management
- ⚡ **Performance Optimized** - Efficient updates with autoDispose and family modifiers
- 🧪 **Fully Tested** - Comprehensive test coverage with Riverpod testing patterns

## 🏗️ **Project Architecture**

We'll build a clean architecture todo application with Riverpod:

```
lib/
├── core/
│   ├── models/                   # 📊 Domain models
│   │   ├── todo.dart            # Todo entity with business logic
│   │   ├── user.dart            # User model with authentication
│   │   ├── todo_filter.dart     # Filtering and search criteria
│   │   └── app_state.dart       # Application state container
│   ├── services/                # 🔧 External services
│   │   ├── api_service.dart     # HTTP API client
│   │   ├── auth_service.dart    # Authentication service
│   │   └── storage_service.dart # Local storage service
│   └── utils/
│       ├── date_utils.dart      # Date formatting utilities
│       └── validation_utils.dart # Input validation
├── providers/                   # 🚀 Riverpod providers
│   ├── auth_providers.dart      # Authentication state providers
│   ├── todo_providers.dart      # Todo state and operations
│   ├── filter_providers.dart    # Filtering and search providers
│   └── app_providers.dart       # Application-wide providers
├── presentation/
│   ├── screens/                 # 📱 Application screens
│   │   ├── auth/                # Authentication screens
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── todos/               # Todo management screens
│   │   │   ├── todo_list_screen.dart
│   │   │   ├── todo_detail_screen.dart
│   │   │   └── add_todo_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   ├── widgets/                 # 🧩 Reusable components
│   │   ├── todo_item.dart       # Individual todo display
│   │   ├── todo_form.dart       # Todo creation/editing form
│   │   ├── filter_bar.dart      # Search and filter controls
│   │   ├── loading_state.dart   # Loading state widget
│   │   └── error_state.dart     # Error display widget
│   └── controllers/             # 🎛️ UI state controllers
│       └── todo_controller.dart # Todo UI state management
└── main.dart                    # 🚀 Application entry point
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Core Domain Models** ⏱️ *15 minutes*

Create the foundational data models for our todo application:

```dart
// lib/core/models/todo.dart
import 'package:equatable/equatable.dart';

enum TodoPriority { low, medium, high, urgent }
enum TodoStatus { pending, inProgress, completed, archived }

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final TodoPriority priority;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<String> tags;
  final String userId;
  final bool isSynced;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
    required this.userId,
    this.isSynced = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    TodoPriority? priority,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
    String? userId,
    bool? isSynced,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  // Business logic methods
  Todo markCompleted() {
    return copyWith(
      status: TodoStatus.completed,
      completedAt: DateTime.now(),
    );
  }

  Todo markIncomplete() {
    return copyWith(
      status: TodoStatus.pending,
      completedAt: null,
    );
  }

  bool get isCompleted => status == TodoStatus.completed;
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  int get daysSinceCreated {
    return DateTime.now().difference(createdAt).inDays;
  }

  // Factory constructors
  factory Todo.create({
    required String title,
    required String description,
    required String userId,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
  }) {
    return Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      status: TodoStatus.pending,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      tags: tags,
      userId: userId,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'tags': tags,
      'userId': userId,
      'isSynced': isSynced,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: TodoPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TodoPriority.medium,
      ),
      status: TodoStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TodoStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'] as String) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String) 
          : null,
      tags: List<String>.from(json['tags'] ?? []),
      userId: json['userId'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        createdAt,
        dueDate,
        completedAt,
        tags,
        userId,
        isSynced,
      ];

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, status: $status, priority: $priority)';
  }
}

// lib/core/models/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final Map<String, dynamic> preferences;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    required this.lastLoginAt,
    this.preferences = const {},
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'preferences': preferences,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        createdAt,
        lastLoginAt,
        preferences,
      ];
}

// lib/core/models/todo_filter.dart
import 'package:equatable/equatable.dart';
import 'todo.dart';

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

  TodoFilter clearStatus() => copyWith(status: null);
  TodoFilter clearPriority() => copyWith(priority: null);
  TodoFilter clearSearch() => copyWith(searchQuery: '');
  TodoFilter clearTags() => copyWith(tags: []);

  bool get hasActiveFilters {
    return searchQuery.isNotEmpty ||
           status != null ||
           priority != null ||
           tags.isNotEmpty ||
           showOverdueOnly;
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
      if (tags.isNotEmpty) {
        if (!tags.any((tag) => todo.tags.contains(tag))) {
          return false;
        }
      }

      // Overdue filter
      if (showOverdueOnly && !todo.isOverdue) {
        return false;
      }

      return true;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int comparison;
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
          comparison = a.title.compareTo(b.title);
          break;
        case TodoSortBy.status:
          comparison = a.status.index.compareTo(b.status.index);
          break;
      }

      return sortAscending ? comparison : -comparison;
    });

    return filtered;
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

enum TodoSortBy { createdAt, dueDate, priority, title, status }
```

### **Step 2: Services Layer** ⏱️ *20 minutes*

Implement the services that will be consumed by our providers:

```dart
// lib/core/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://api.todoapp.com';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Authentication endpoints
  Future<User> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw ApiException('Login failed: ${response.body}');
    }
  }

  Future<User> register(String email, String password, String name) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw ApiException('Registration failed: ${response.body}');
    }
  }

  // Todo endpoints
  Future<List<Todo>> fetchTodos(String userId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/todos?userId=$userId'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw ApiException('Failed to fetch todos: ${response.body}');
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/todos'),
      headers: _getAuthHeaders(),
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Todo.fromJson(data);
    } else {
      throw ApiException('Failed to create todo: ${response.body}');
    }
  }

  Future<Todo> updateTodo(Todo todo) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/todos/${todo.id}'),
      headers: _getAuthHeaders(),
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Todo.fromJson(data);
    } else {
      throw ApiException('Failed to update todo: ${response.body}');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/todos/$todoId'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode != 204) {
      throw ApiException('Failed to delete todo: ${response.body}');
    }
  }

  // Real-time todo stream (simulated)
  Stream<List<Todo>> todoStream(String userId) async* {
    while (true) {
      try {
        final todos = await fetchTodos(userId);
        yield todos;
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        // Handle stream errors gracefully
        yield [];
      }
    }
  }

  Map<String, String> _getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  String get authToken {
    // In a real app, this would come from secure storage
    return 'mock-auth-token';
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

// lib/core/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import '../models/user.dart';

class StorageService {
  static const String _todosKey = 'cached_todos';
  static const String _userKey = 'current_user';
  static const String _settingsKey = 'app_settings';

  // Todo caching
  Future<void> cacheTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = todos.map((todo) => todo.toJson()).toList();
    await prefs.setString(_todosKey, jsonEncode(todosJson));
  }

  Future<List<Todo>> getCachedTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString(_todosKey);
    
    if (todosString == null) return [];
    
    final List<dynamic> todosJson = jsonDecode(todosString);
    return todosJson.map((json) => Todo.fromJson(json)).toList();
  }

  Future<void> clearCachedTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_todosKey);
  }

  // User persistence
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    
    if (userString == null) return null;
    
    final userJson = jsonDecode(userString);
    return User.fromJson(userJson);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // App settings
  Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await getSettings();
    settings[key] = value;
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(_settingsKey);
    
    if (settingsString == null) return {};
    
    return Map<String, dynamic>.from(jsonDecode(settingsString));
  }

  Future<T?> getSetting<T>(String key, [T? defaultValue]) async {
    final settings = await getSettings();
    return settings[key] as T? ?? defaultValue;
  }
}

// lib/core/services/auth_service.dart
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  Future<User> login(String email, String password) async {
    try {
      final user = await _apiService.login(email, password);
      await _storageService.saveUser(user);
      return user;
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  Future<User> register(String email, String password, String name) async {
    try {
      final user = await _apiService.register(email, password, name);
      await _storageService.saveUser(user);
      return user;
    } catch (e) {
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _storageService.clearUser();
    await _storageService.clearCachedTodos();
  }

  Future<User?> getCurrentUser() async {
    return await _storageService.getSavedUser();
  }

  Stream<User?> get authStateChanges async* {
    // In a real app, this would listen to actual auth state changes
    yield await getCurrentUser();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
```

### **Step 3: Core Riverpod Providers** ⏱️ *30 minutes*

Create the foundational providers that demonstrate different Riverpod patterns:

```dart
// lib/providers/app_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/auth_service.dart';

// Basic dependency injection providers
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return ApiService(client: httpClient);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return AuthService(
    apiService: apiService,
    storageService: storageService,
  );
});

// App configuration providers
final appVersionProvider = Provider<String>((ref) => '1.0.0');

final isDebugModeProvider = Provider<bool>((ref) {
  return true; // In real app, check kDebugMode
});

// lib/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/user.dart';
import '../core/services/auth_service.dart';
import 'app_providers.dart';

// Current user provider with async loading
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getCurrentUser();
});

// Authentication state notifier
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }

  final Ref ref;

  Future<void> _loadCurrentUser() async {
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.login(email, password);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.register(email, password, name);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> logout() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) => AuthNotifier(ref),
);

// Computed providers based on auth state
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(data: (user) => user != null) ?? false;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(data: (user) => user?.id);
});

// lib/providers/todo_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/todo.dart';
import '../core/models/todo_filter.dart';
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import 'app_providers.dart';
import 'auth_providers.dart';

// Todo state management with comprehensive async handling
class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  final Ref ref;

  Future<void> _initialize() async {
    try {
      // Load cached todos first for immediate UI
      final storageService = ref.read(storageServiceProvider);
      final cachedTodos = await storageService.getCachedTodos();
      
      if (cachedTodos.isNotEmpty) {
        state = AsyncValue.data(cachedTodos);
      }

      // Then fetch fresh data
      await refresh();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      final todos = await apiService.fetchTodos(userId);
      
      // Cache the fresh data
      final storageService = ref.read(storageServiceProvider);
      await storageService.cacheTodos(todos);
      
      state = AsyncValue.data(todos);
    } catch (error, stackTrace) {
      // If refresh fails but we have cached data, keep it
      if (state.hasValue) {
        // Optionally show a toast/snackbar about sync failure
      } else {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    // Optimistic update
    final newTodo = Todo.create(
      title: title,
      description: description,
      userId: userId,
      priority: priority,
      dueDate: dueDate,
      tags: tags,
    );

    state.whenData((todos) {
      state = AsyncValue.data([...todos, newTodo]);
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final createdTodo = await apiService.createTodo(newTodo);
      
      // Replace temporary todo with server todo
      state.whenData((todos) {
        final updatedTodos = todos.map((todo) {
          return todo.id == newTodo.id ? createdTodo : todo;
        }).toList();
        state = AsyncValue.data(updatedTodos);
      });
      
      // Update cache
      final storageService = ref.read(storageServiceProvider);
      await storageService.cacheTodos(state.value ?? []);
    } catch (error, stackTrace) {
      // Rollback optimistic update
      state.whenData((todos) {
        final rolledBackTodos = todos.where((todo) => todo.id != newTodo.id).toList();
        state = AsyncValue.data(rolledBackTodos);
      });
      
      // Re-throw to allow UI to handle the error
      rethrow;
    }
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    // Optimistic update
    state.whenData((todos) {
      final updatedTodos = todos.map((todo) {
        return todo.id == updatedTodo.id ? updatedTodo : todo;
      }).toList();
      state = AsyncValue.data(updatedTodos);
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final serverTodo = await apiService.updateTodo(updatedTodo);
      
      // Update with server response
      state.whenData((todos) {
        final finalTodos = todos.map((todo) {
          return todo.id == serverTodo.id ? serverTodo : todo;
        }).toList();
        state = AsyncValue.data(finalTodos);
      });
      
      // Update cache
      final storageService = ref.read(storageServiceProvider);
      await storageService.cacheTodos(state.value ?? []);
    } catch (error, stackTrace) {
      // Rollback and show error
      await refresh();
      rethrow;
    }
  }

  Future<void> deleteTodo(String todoId) async {
    // Store todo for rollback
    Todo? deletedTodo;
    state.whenData((todos) {
      deletedTodo = todos.firstWhere((todo) => todo.id == todoId);
    });

    // Optimistic delete
    state.whenData((todos) {
      final filteredTodos = todos.where((todo) => todo.id != todoId).toList();
      state = AsyncValue.data(filteredTodos);
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.deleteTodo(todoId);
      
      // Update cache
      final storageService = ref.read(storageServiceProvider);
      await storageService.cacheTodos(state.value ?? []);
    } catch (error, stackTrace) {
      // Rollback delete
      if (deletedTodo != null) {
        state.whenData((todos) {
          state = AsyncValue.data([...todos, deletedTodo!]);
        });
      }
      rethrow;
    }
  }

  Future<void> toggleTodoCompletion(String todoId) async {
    Todo? targetTodo;
    state.whenData((todos) {
      targetTodo = todos.firstWhere((todo) => todo.id == todoId);
    });

    if (targetTodo == null) return;

    final updatedTodo = targetTodo!.isCompleted 
        ? targetTodo!.markIncomplete() 
        : targetTodo!.markCompleted();
    
    await updateTodo(updatedTodo);
  }
}

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>(
  (ref) => TodoNotifier(ref),
);

// Real-time todo stream provider
final todoStreamProvider = StreamProvider.autoDispose<List<Todo>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value([]);
  }

  final apiService = ref.read(apiServiceProvider);
  return apiService.todoStream(userId);
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
        'completed': todos.where((t) => t.isCompleted).length,
        'pending': todos.where((t) => !t.isCompleted).length,
        'overdue': todos.where((t) => t.isOverdue).length,
      };
    },
  );
});

// Individual todo provider using family
final todoProvider = Provider.family<Todo?, String>((ref, todoId) {
  final todosAsync = ref.watch(todoNotifierProvider);
  
  return todosAsync.whenOrNull(
    data: (todos) => todos.firstWhere(
      (todo) => todo.id == todoId,
      orElse: () => todos.first, // This will throw if not found
    ),
  );
});
```

*This is part 1 of the workshop. Continue with the remaining steps to build the complete Riverpod application...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_12

# Install dependencies
flutter pub get
flutter pub add flutter_riverpod
flutter pub add shared_preferences
flutter pub add http

# Run the app
flutter run

# Test Riverpod patterns
# 1. Create and manage todos with async operations
# 2. Test offline/online scenarios
# 3. Use filtering and search functionality
# 4. Monitor state changes and rebuilds
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Riverpod Fundamentals** - Understanding the evolution from Provider to Riverpod 2.0
- **Provider Types** - StateProvider, StateNotifierProvider, FutureProvider, StreamProvider
- **Async State Management** - Handling loading, data, and error states with AsyncValue
- **Provider Modifiers** - autoDispose, family, and advanced provider patterns
- **Compile-time Safety** - Type-safe state management without BuildContext dependencies
- **Testing Excellence** - Superior testing patterns with ProviderContainer

**Ready to master the future of Flutter state management with Riverpod 2.0? 🚀✨**