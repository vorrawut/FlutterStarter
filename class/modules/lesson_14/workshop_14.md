# 🎯 Workshop

## 🎯 **What We're Building**

A **comprehensive comparison laboratory** where we implement the same application features using all four state management patterns:
- **Multi-Pattern Todo Application** - Same functionality, different state management approaches
- **Performance Benchmarking Suite** - Tools to measure and compare pattern performance
- **Migration Playground** - Step-by-step refactoring between patterns
- **Decision Framework Tool** - Interactive tool to help choose the right pattern
- **Architecture Documentation** - Complete analysis and recommendations for team use

## ✅ **Expected Outcome**

A complete understanding of when and how to use each state management pattern:
- 🔄 **Pattern Implementations** - Same app built with setState, Provider, Riverpod, and Bloc
- 📊 **Performance Analysis** - Memory, CPU, and build efficiency comparisons
- 🎯 **Decision Framework** - Clear criteria for choosing the right pattern
- 📈 **Migration Strategies** - Step-by-step guides for pattern transitions
- 📋 **Team Guidelines** - Documentation for consistent architectural decisions

## 🏗️ **Workshop Architecture**

We'll create a comparison laboratory with multiple implementations:

```
comparison_lab/
├── 01_setstate_implementation/          # 📱 Pure Flutter implementation
│   ├── lib/
│   │   ├── models/                     # Shared domain models
│   │   ├── widgets/                    # StatefulWidget implementations
│   │   └── main.dart                   # setState-based app
│   └── analysis/
│       ├── performance_report.md       # Performance measurements
│       └── pros_cons_analysis.md       # Detailed analysis
├── 02_provider_implementation/          # 🔄 Provider-based implementation
│   ├── lib/
│   │   ├── models/                     # Domain models
│   │   ├── providers/                  # ChangeNotifier providers
│   │   ├── widgets/                    # Consumer widgets
│   │   └── main.dart                   # Provider-based app
│   └── analysis/
│       ├── performance_report.md       # Performance measurements
│       └── migration_from_setstate.md  # Migration guide
├── 03_riverpod_implementation/          # ⚡ Riverpod 2.0 implementation
│   ├── lib/
│   │   ├── models/                     # Domain models
│   │   ├── providers/                  # Riverpod providers
│   │   ├── widgets/                    # ConsumerWidget implementations
│   │   └── main.dart                   # Riverpod-based app
│   └── analysis/
│       ├── performance_report.md       # Performance measurements
│       └── migration_from_provider.md  # Migration guide
├── 04_bloc_implementation/              # 🎯 Bloc-based implementation
│   ├── lib/
│   │   ├── models/                     # Domain models
│   │   ├── blocs/                      # Bloc and Cubit implementations
│   │   ├── widgets/                    # BlocBuilder widgets
│   │   └── main.dart                   # Bloc-based app
│   └── analysis/
│       ├── performance_report.md       # Performance measurements
│       └── migration_from_riverpod.md  # Migration guide
├── performance_benchmarking/            # 📊 Performance testing tools
│   ├── memory_profiler.dart           # Memory usage analysis
│   ├── cpu_profiler.dart              # CPU performance tests
│   ├── build_efficiency_test.dart     # Widget rebuild analysis
│   └── comparison_report.dart          # Automated comparison report
├── decision_framework/                  # 🤔 Decision-making tools
│   ├── pattern_selector.dart          # Interactive pattern selection
│   ├── complexity_analyzer.dart       # Project complexity assessment
│   └── team_readiness_quiz.dart       # Team skill assessment
└── documentation/                       # 📚 Complete analysis
    ├── architecture_comparison.md      # Technical comparison
    ├── team_guidelines.md             # Development team guidelines
    ├── migration_strategies.md        # Pattern transition guides
    └── best_practices.md              # Consolidated best practices
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Shared Domain Models** ⏱️ *15 minutes*

Create consistent domain models used across all implementations:

```dart
// shared/models/todo.dart
import 'package:equatable/equatable.dart';

enum TodoPriority { low, medium, high, urgent }
enum TodoStatus { pending, inProgress, completed, cancelled }

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

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.priority = TodoPriority.medium,
    this.status = TodoStatus.pending,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
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
    );
  }

  // Business logic methods
  bool get isOverdue {
    if (dueDate == null || status == TodoStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isHighPriority => priority == TodoPriority.high || priority == TodoPriority.urgent;

  Duration? get timeToCompletion {
    if (completedAt == null) return null;
    return completedAt!.difference(createdAt);
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
      ];

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, status: $status, priority: $priority)';
  }
}

// shared/models/todo_filter.dart
class TodoFilter extends Equatable {
  final TodoStatus? statusFilter;
  final TodoPriority? priorityFilter;
  final String? tagFilter;
  final String searchQuery;
  final bool showCompleted;
  final bool showOverdue;

  const TodoFilter({
    this.statusFilter,
    this.priorityFilter,
    this.tagFilter,
    this.searchQuery = '',
    this.showCompleted = true,
    this.showOverdue = false,
  });

  TodoFilter copyWith({
    TodoStatus? statusFilter,
    TodoPriority? priorityFilter,
    String? tagFilter,
    String? searchQuery,
    bool? showCompleted,
    bool? showOverdue,
  }) {
    return TodoFilter(
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      tagFilter: tagFilter ?? this.tagFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      showCompleted: showCompleted ?? this.showCompleted,
      showOverdue: showOverdue ?? this.showOverdue,
    );
  }

  List<Todo> apply(List<Todo> todos) {
    return todos.where((todo) {
      // Status filter
      if (statusFilter != null && todo.status != statusFilter) return false;
      
      // Priority filter
      if (priorityFilter != null && todo.priority != priorityFilter) return false;
      
      // Tag filter
      if (tagFilter != null && !todo.tags.contains(tagFilter)) return false;
      
      // Search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!todo.title.toLowerCase().contains(query) &&
            !todo.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Show completed filter
      if (!showCompleted && todo.status == TodoStatus.completed) return false;
      
      // Show overdue filter
      if (showOverdue && !todo.isOverdue) return false;
      
      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [
        statusFilter,
        priorityFilter,
        tagFilter,
        searchQuery,
        showCompleted,
        showOverdue,
      ];
}

// shared/models/todo_stats.dart
class TodoStats extends Equatable {
  final int totalTodos;
  final int completedTodos;
  final int pendingTodos;
  final int overdueTodos;
  final int highPriorityTodos;
  final double completionRate;
  final Duration? averageCompletionTime;

  const TodoStats({
    required this.totalTodos,
    required this.completedTodos,
    required this.pendingTodos,
    required this.overdueTodos,
    required this.highPriorityTodos,
    required this.completionRate,
    this.averageCompletionTime,
  });

  factory TodoStats.fromTodos(List<Todo> todos) {
    final total = todos.length;
    final completed = todos.where((t) => t.status == TodoStatus.completed).length;
    final pending = todos.where((t) => t.status == TodoStatus.pending).length;
    final overdue = todos.where((t) => t.isOverdue).length;
    final highPriority = todos.where((t) => t.isHighPriority).length;
    final completionRate = total > 0 ? completed / total : 0.0;

    // Calculate average completion time
    final completedTodos = todos.where((t) => t.completedAt != null);
    Duration? averageTime;
    if (completedTodos.isNotEmpty) {
      final totalTime = completedTodos
          .map((t) => t.timeToCompletion!)
          .reduce((a, b) => a + b);
      averageTime = Duration(
        milliseconds: totalTime.inMilliseconds ~/ completedTodos.length,
      );
    }

    return TodoStats(
      totalTodos: total,
      completedTodos: completed,
      pendingTodos: pending,
      overdueTodos: overdue,
      highPriorityTodos: highPriority,
      completionRate: completionRate,
      averageCompletionTime: averageTime,
    );
  }

  @override
  List<Object?> get props => [
        totalTodos,
        completedTodos,
        pendingTodos,
        overdueTodos,
        highPriorityTodos,
        completionRate,
        averageCompletionTime,
      ];
}
```

### **Step 2: setState Implementation** ⏱️ *45 minutes*

Build the complete todo application using only setState and StatefulWidget:

```dart
// 01_setstate_implementation/lib/main.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../shared/models/todo.dart';
import '../shared/models/todo_filter.dart';
import '../shared/models/todo_stats.dart';

void main() {
  runApp(const SetStateTodoApp());
}

class SetStateTodoApp extends StatelessWidget {
  const SetStateTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'setState Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TodoHomeScreen(),
    );
  }
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> with TickerProviderStateMixin {
  // Core state
  List<Todo> _todos = [];
  TodoFilter _filter = const TodoFilter();
  
  // UI state
  bool _isLoading = false;
  String? _errorMessage;
  late TabController _tabController;
  
  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSampleData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Business logic methods
  void _loadSampleData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _todos = [
          Todo(
            id: const Uuid().v4(),
            title: 'Complete Flutter state management comparison',
            description: 'Analyze different patterns and their use cases',
            priority: TodoPriority.high,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
            dueDate: DateTime.now().add(const Duration(days: 1)),
            tags: ['flutter', 'learning'],
          ),
          Todo(
            id: const Uuid().v4(),
            title: 'Review team code submissions',
            description: 'Go through pull requests and provide feedback',
            priority: TodoPriority.medium,
            status: TodoStatus.inProgress,
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            tags: ['work', 'review'],
          ),
          Todo(
            id: const Uuid().v4(),
            title: 'Buy groceries for the week',
            description: 'Milk, bread, eggs, vegetables',
            priority: TodoPriority.low,
            status: TodoStatus.completed,
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
            completedAt: DateTime.now().subtract(const Duration(days: 1)),
            tags: ['personal', 'shopping'],
          ),
        ];
        _isLoading = false;
      });
    });
  }

  void _addTodo() {
    if (_titleController.text.trim().isEmpty) return;

    setState(() {
      final newTodo = Todo(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
      );
      _todos.add(newTodo);
      _titleController.clear();
      _descriptionController.clear();
    });

    Navigator.of(context).pop();
  }

  void _updateTodo(String id, Todo updatedTodo) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index] = updatedTodo;
      }
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  void _toggleTodoStatus(String id) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final todo = _todos[index];
        final newStatus = todo.status == TodoStatus.completed
            ? TodoStatus.pending
            : TodoStatus.completed;
        
        _todos[index] = todo.copyWith(
          status: newStatus,
          completedAt: newStatus == TodoStatus.completed ? DateTime.now() : null,
        );
      }
    });
  }

  void _updateFilter(TodoFilter newFilter) {
    setState(() {
      _filter = newFilter;
    });
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Computed properties
  List<Todo> get _filteredTodos => _filter.apply(_todos);
  TodoStats get _stats => TodoStats.fromTodos(_todos);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('setState Todo App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: 'Statistics'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodosTab(),
          _buildStatsTab(),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodosTab() {
    return Column(
      children: [
        // Search and filter
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search todos',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  _updateFilter(_filter.copyWith(searchQuery: query));
                },
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _filter.statusFilter == null,
                      onSelected: (_) => _updateFilter(_filter.copyWith(statusFilter: null)),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Pending'),
                      selected: _filter.statusFilter == TodoStatus.pending,
                      onSelected: (_) => _updateFilter(_filter.copyWith(statusFilter: TodoStatus.pending)),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Completed'),
                      selected: _filter.statusFilter == TodoStatus.completed,
                      onSelected: (_) => _updateFilter(_filter.copyWith(statusFilter: TodoStatus.completed)),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('High Priority'),
                      selected: _filter.priorityFilter == TodoPriority.high,
                      onSelected: (_) => _updateFilter(_filter.copyWith(priorityFilter: TodoPriority.high)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Todo list
        Expanded(
          child: _filteredTodos.isEmpty
              ? const Center(
                  child: Text(
                    'No todos found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = _filteredTodos[index];
                    return TodoListItem(
                      todo: todo,
                      onToggle: () => _toggleTodoStatus(todo.id),
                      onDelete: () => _deleteTodo(todo.id),
                      onEdit: (updatedTodo) => _updateTodo(todo.id, updatedTodo),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Todo Statistics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('Total Todos', _stats.totalTodos.toString()),
                  _buildStatRow('Completed', _stats.completedTodos.toString()),
                  _buildStatRow('Pending', _stats.pendingTodos.toString()),
                  _buildStatRow('Overdue', _stats.overdueTodos.toString()),
                  _buildStatRow('High Priority', _stats.highPriorityTodos.toString()),
                  _buildStatRow(
                    'Completion Rate',
                    '${(_stats.completionRate * 100).toStringAsFixed(1)}%',
                  ),
                  if (_stats.averageCompletionTime != null)
                    _buildStatRow(
                      'Avg. Completion Time',
                      '${_stats.averageCompletionTime!.inHours}h ${_stats.averageCompletionTime!.inMinutes % 60}m',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Show Completed Todos'),
            value: _filter.showCompleted,
            onChanged: (value) => _updateFilter(_filter.copyWith(showCompleted: value)),
          ),
          SwitchListTile(
            title: const Text('Show Only Overdue'),
            value: _filter.showOverdue,
            onChanged: (value) => _updateFilter(_filter.copyWith(showOverdue: value)),
          ),
          ListTile(
            title: const Text('Clear All Completed'),
            trailing: const Icon(Icons.clear_all),
            onTap: () {
              setState(() {
                _todos.removeWhere((todo) => todo.status == TodoStatus.completed);
              });
            },
          ),
          ListTile(
            title: const Text('Reset All Data'),
            trailing: const Icon(Icons.refresh),
            onTap: () {
              setState(() {
                _todos.clear();
              });
              _loadSampleData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// 01_setstate_implementation/lib/widgets/todo_list_item.dart
class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(Todo) onEdit;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: todo.status == TodoStatus.completed,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.status == TodoStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description.isNotEmpty) Text(todo.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _priorityChip(todo.priority),
                const SizedBox(width: 8),
                if (todo.isOverdue)
                  const Chip(
                    label: Text('Overdue'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditDialog(context);
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityChip(TodoPriority priority) {
    Color color;
    switch (priority) {
      case TodoPriority.low:
        color = Colors.green;
        break;
      case TodoPriority.medium:
        color = Colors.orange;
        break;
      case TodoPriority.high:
        color = Colors.red;
        break;
      case TodoPriority.urgent:
        color = Colors.purple;
        break;
    }

    return Chip(
      label: Text(priority.name.toUpperCase()),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);
    TodoPriority selectedPriority = todo.priority;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TodoPriority>(
                value: selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: TodoPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedPriority = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedTodo = todo.copyWith(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  priority: selectedPriority,
                );
                onEdit(updatedTodo);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### **Step 3: Performance Benchmarking Tools** ⏱️ *30 minutes*

Create tools to measure and compare performance across patterns:

```dart
// performance_benchmarking/memory_profiler.dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MemoryProfiler {
  static final Map<String, List<MemoryMeasurement>> _measurements = {};

  static void startMeasuring(String label) {
    if (kDebugMode) {
      developer.Timeline.startSync('memory_measurement_$label');
      _measurements[label] = [];
    }
  }

  static void recordMeasurement(String label) {
    if (kDebugMode && _measurements.containsKey(label)) {
      // In a real implementation, you would use more sophisticated memory measurement
      final measurement = MemoryMeasurement(
        timestamp: DateTime.now(),
        memoryUsage: _getApproximateMemoryUsage(),
        widgetCount: _getWidgetCount(),
      );
      _measurements[label]!.add(measurement);
    }
  }

  static void stopMeasuring(String label) {
    if (kDebugMode) {
      developer.Timeline.finishSync();
    }
  }

  static MemoryReport generateReport() {
    final reports = <String, PatternMemoryReport>{};
    
    for (final entry in _measurements.entries) {
      final measurements = entry.value;
      if (measurements.isNotEmpty) {
        final avgMemory = measurements
            .map((m) => m.memoryUsage)
            .reduce((a, b) => a + b) / measurements.length;
        
        final maxMemory = measurements
            .map((m) => m.memoryUsage)
            .reduce((a, b) => a > b ? a : b);
        
        final avgWidgets = measurements
            .map((m) => m.widgetCount)
            .reduce((a, b) => a + b) / measurements.length;

        reports[entry.key] = PatternMemoryReport(
          patternName: entry.key,
          averageMemoryUsage: avgMemory,
          peakMemoryUsage: maxMemory,
          averageWidgetCount: avgWidgets.round(),
          measurementCount: measurements.length,
        );
      }
    }

    return MemoryReport(patternReports: reports);
  }

  static double _getApproximateMemoryUsage() {
    // Simplified memory usage approximation
    // In a real implementation, use dart:developer VM service APIs
    return DateTime.now().millisecondsSinceEpoch % 100000 / 1000.0;
  }

  static int _getWidgetCount() {
    // Simplified widget count approximation
    // In a real implementation, traverse the widget tree
    return DateTime.now().millisecondsSinceEpoch % 1000;
  }

  static void clear() {
    _measurements.clear();
  }
}

class MemoryMeasurement {
  final DateTime timestamp;
  final double memoryUsage;
  final int widgetCount;

  MemoryMeasurement({
    required this.timestamp,
    required this.memoryUsage,
    required this.widgetCount,
  });
}

class PatternMemoryReport {
  final String patternName;
  final double averageMemoryUsage;
  final double peakMemoryUsage;
  final int averageWidgetCount;
  final int measurementCount;

  PatternMemoryReport({
    required this.patternName,
    required this.averageMemoryUsage,
    required this.peakMemoryUsage,
    required this.averageWidgetCount,
    required this.measurementCount,
  });
}

class MemoryReport {
  final Map<String, PatternMemoryReport> patternReports;

  MemoryReport({required this.patternReports});

  String generateMarkdownReport() {
    final buffer = StringBuffer();
    buffer.writeln('# Memory Usage Comparison Report');
    buffer.writeln();
    buffer.writeln('Generated on: ${DateTime.now()}');
    buffer.writeln();
    buffer.writeln('| Pattern | Avg Memory (MB) | Peak Memory (MB) | Avg Widgets | Measurements |');
    buffer.writeln('|---------|-----------------|------------------|-------------|--------------|');

    for (final report in patternReports.values) {
      buffer.writeln('| ${report.patternName} | ${report.averageMemoryUsage.toStringAsFixed(2)} | ${report.peakMemoryUsage.toStringAsFixed(2)} | ${report.averageWidgetCount} | ${report.measurementCount} |');
    }

    buffer.writeln();
    buffer.writeln('## Analysis');
    
    final sortedByMemory = patternReports.values.toList()
      ..sort((a, b) => a.averageMemoryUsage.compareTo(b.averageMemoryUsage));
    
    buffer.writeln('### Memory Efficiency Ranking');
    for (int i = 0; i < sortedByMemory.length; i++) {
      buffer.writeln('${i + 1}. ${sortedByMemory[i].patternName} (${sortedByMemory[i].averageMemoryUsage.toStringAsFixed(2)} MB avg)');
    }

    return buffer.toString();
  }
}

// performance_benchmarking/build_efficiency_test.dart
class BuildEfficiencyProfiler {
  static final Map<String, List<BuildMeasurement>> _buildMeasurements = {};
  static final Map<String, int> _rebuildCounts = {};

  static void startMeasuring(String pattern) {
    _buildMeasurements[pattern] = [];
    _rebuildCounts[pattern] = 0;
  }

  static void recordBuild(String pattern, {
    required int widgetsRebuilt,
    required Duration buildTime,
    required String triggerReason,
  }) {
    if (!_buildMeasurements.containsKey(pattern)) return;

    _rebuildCounts[pattern] = (_rebuildCounts[pattern] ?? 0) + 1;
    
    final measurement = BuildMeasurement(
      timestamp: DateTime.now(),
      widgetsRebuilt: widgetsRebuilt,
      buildTime: buildTime,
      triggerReason: triggerReason,
      rebuildNumber: _rebuildCounts[pattern]!,
    );

    _buildMeasurements[pattern]!.add(measurement);
  }

  static BuildEfficiencyReport generateReport() {
    final reports = <String, PatternBuildReport>{};

    for (final entry in _buildMeasurements.entries) {
      final measurements = entry.value;
      if (measurements.isNotEmpty) {
        final avgWidgetsRebuilt = measurements
            .map((m) => m.widgetsRebuilt)
            .reduce((a, b) => a + b) / measurements.length;

        final avgBuildTime = Duration(
          microseconds: (measurements
              .map((m) => m.buildTime.inMicroseconds)
              .reduce((a, b) => a + b) / measurements.length).round(),
        );

        final totalBuilds = measurements.length;
        
        reports[entry.key] = PatternBuildReport(
          patternName: entry.key,
          averageWidgetsRebuilt: avgWidgetsRebuilt,
          averageBuildTime: avgBuildTime,
          totalBuilds: totalBuilds,
          measurements: List.from(measurements),
        );
      }
    }

    return BuildEfficiencyReport(patternReports: reports);
  }

  static void clear() {
    _buildMeasurements.clear();
    _rebuildCounts.clear();
  }
}

class BuildMeasurement {
  final DateTime timestamp;
  final int widgetsRebuilt;
  final Duration buildTime;
  final String triggerReason;
  final int rebuildNumber;

  BuildMeasurement({
    required this.timestamp,
    required this.widgetsRebuilt,
    required this.buildTime,
    required this.triggerReason,
    required this.rebuildNumber,
  });
}

class PatternBuildReport {
  final String patternName;
  final double averageWidgetsRebuilt;
  final Duration averageBuildTime;
  final int totalBuilds;
  final List<BuildMeasurement> measurements;

  PatternBuildReport({
    required this.patternName,
    required this.averageWidgetsRebuilt,
    required this.averageBuildTime,
    required this.totalBuilds,
    required this.measurements,
  });
}

class BuildEfficiencyReport {
  final Map<String, PatternBuildReport> patternReports;

  BuildEfficiencyReport({required this.patternReports});

  String generateMarkdownReport() {
    final buffer = StringBuffer();
    buffer.writeln('# Build Efficiency Comparison Report');
    buffer.writeln();
    buffer.writeln('Generated on: ${DateTime.now()}');
    buffer.writeln();
    buffer.writeln('| Pattern | Avg Widgets Rebuilt | Avg Build Time (ms) | Total Builds |');
    buffer.writeln('|---------|-------------------|---------------------|--------------|');

    for (final report in patternReports.values) {
      buffer.writeln('| ${report.patternName} | ${report.averageWidgetsRebuilt.toStringAsFixed(1)} | ${report.averageBuildTime.inMilliseconds} | ${report.totalBuilds} |');
    }

    buffer.writeln();
    buffer.writeln('## Build Efficiency Ranking');
    
    final sortedByEfficiency = patternReports.values.toList()
      ..sort((a, b) => a.averageWidgetsRebuilt.compareTo(b.averageWidgetsRebuilt));
    
    for (int i = 0; i < sortedByEfficiency.length; i++) {
      buffer.writeln('${i + 1}. ${sortedByEfficiency[i].patternName} (${sortedByEfficiency[i].averageWidgetsRebuilt.toStringAsFixed(1)} widgets avg)');
    }

    return buffer.toString();
  }
}
```

*This is part 1 of the workshop. Continue with Provider, Riverpod, and Bloc implementations plus decision framework tools...*

## 🚀 **How to Run**

```bash
# Set up the comparison laboratory
mkdir state_management_comparison
cd state_management_comparison

# Create each implementation
mkdir 01_setstate_implementation
mkdir 02_provider_implementation  
mkdir 03_riverpod_implementation
mkdir 04_bloc_implementation
mkdir performance_benchmarking
mkdir decision_framework

# Install dependencies for each implementation
cd 01_setstate_implementation
flutter create . 
flutter pub add uuid equatable

cd ../02_provider_implementation
flutter create .
flutter pub add provider uuid equatable

cd ../03_riverpod_implementation
flutter create .
flutter pub add flutter_riverpod uuid equatable

cd ../04_bloc_implementation
flutter create .
flutter pub add flutter_bloc bloc_test uuid equatable

# Run each implementation and compare
flutter run # In each directory
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Pattern Comparison** - Deep understanding of when to use each state management approach
- **Performance Analysis** - Measuring and comparing memory, CPU, and build efficiency across patterns
- **Migration Strategies** - Step-by-step approaches for transitioning between patterns
- **Decision Making** - Framework for choosing the right pattern based on project requirements
- **Team Guidelines** - Documentation and standards for consistent architectural decisions

**Ready to make informed state management decisions? 🎯✨**