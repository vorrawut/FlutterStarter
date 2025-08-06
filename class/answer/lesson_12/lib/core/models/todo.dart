import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum TodoStatus { pending, inProgress, completed, archived }

enum TodoPriority { low, medium, high, urgent }

enum TodoSortBy { createdAt, dueDate, priority, title, status }

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final TodoStatus status;
  final TodoPriority priority;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<String> tags;
  final String userId;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.tags,
    required this.userId,
  });

  factory Todo.create({
    required String title,
    required String description,
    required String userId,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
  }) {
    return Todo(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: TodoStatus.pending,
      priority: priority,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      completedAt: null,
      tags: tags,
      userId: userId,
    );
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    TodoStatus? status,
    TodoPriority? priority,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
    String? userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
    );
  }

  Todo markCompleted() {
    return copyWith(
      status: TodoStatus.completed,
      completedAt: DateTime.now(),
    );
  }

  Todo markPending() {
    return copyWith(
      status: TodoStatus.pending,
      completedAt: null,
    );
  }

  Todo updateStatus(TodoStatus newStatus) {
    return copyWith(
      status: newStatus,
      completedAt: newStatus == TodoStatus.completed ? DateTime.now() : null,
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

  int get daysUntilDue {
    if (dueDate == null) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'tags': tags,
      'userId': userId,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: TodoStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TodoStatus.pending,
      ),
      priority: TodoPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TodoPriority.medium,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      tags: List<String>.from(json['tags'] as List),
      userId: json['userId'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        priority,
        createdAt,
        dueDate,
        completedAt,
        tags,
        userId,
      ];

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, status: $status, priority: $priority)';
  }
}