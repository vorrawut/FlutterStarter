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

  factory Todo.create({
    required String title,
    required String description,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
  }) {
    return Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      tags: tags,
    );
  }

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

  // Business logic methods
  bool get isCompleted => status == TodoStatus.completed;
  bool get isPending => status == TodoStatus.pending;
  bool get isInProgress => status == TodoStatus.inProgress;
  bool get isCancelled => status == TodoStatus.cancelled;

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isHighPriority => 
      priority == TodoPriority.high || priority == TodoPriority.urgent;

  Duration? get timeToCompletion {
    if (completedAt == null) return null;
    return completedAt!.difference(createdAt);
  }

  String get statusDisplayName {
    switch (status) {
      case TodoStatus.pending:
        return 'Pending';
      case TodoStatus.inProgress:
        return 'In Progress';
      case TodoStatus.completed:
        return 'Completed';
      case TodoStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get priorityDisplayName {
    switch (priority) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
      case TodoPriority.urgent:
        return 'Urgent';
    }
  }

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
      tags: List<String>.from(json['tags'] as List),
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
      ];

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, status: $status, priority: $priority)';
  }
}