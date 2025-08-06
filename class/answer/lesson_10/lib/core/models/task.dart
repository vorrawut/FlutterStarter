/// Task entity with business logic and validation
/// 
/// This file defines the core Task model with immutable patterns,
/// business logic, validation, and copyWith functionality for
/// predictable state updates.
library;

import 'package:flutter/foundation.dart';

/// Task priority levels
enum TaskPriority {
  low('Low', 1),
  medium('Medium', 2),
  high('High', 3),
  urgent('Urgent', 4);

  const TaskPriority(this.label, this.value);

  /// Display label for the priority
  final String label;

  /// Numeric value for sorting
  final int value;

  /// Get priority color
  static Color getColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF10B981); // Green
      case TaskPriority.medium:
        return const Color(0xFF3B82F6); // Blue
      case TaskPriority.high:
        return const Color(0xFFF59E0B); // Amber
      case TaskPriority.urgent:
        return const Color(0xFFEF4444); // Red
    }
  }
}

/// Task status enumeration
enum TaskStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled');

  const TaskStatus(this.label);

  /// Display label for the status
  final String label;

  /// Whether this status represents a completed task
  bool get isCompleted => this == TaskStatus.completed;

  /// Whether this status allows editing
  bool get isEditable => this != TaskStatus.completed && this != TaskStatus.cancelled;
}

/// Immutable Task entity with business logic
/// 
/// Represents a single task with all necessary properties,
/// validation logic, and immutable update patterns.
@immutable
class Task {
  /// Creates a new Task instance
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
    this.estimatedHours,
    this.actualHours,
  });

  /// Unique identifier for the task
  final String id;

  /// Task title (required)
  final String title;

  /// Task description (optional but recommended)
  final String description;

  /// Task priority level
  final TaskPriority priority;

  /// Current task status
  final TaskStatus status;

  /// When the task was created
  final DateTime createdAt;

  /// Optional due date
  final DateTime? dueDate;

  /// When the task was completed (if completed)
  final DateTime? completedAt;

  /// Tags associated with the task
  final List<String> tags;

  /// Estimated hours to complete
  final double? estimatedHours;

  /// Actual hours spent (if completed)
  final double? actualHours;

  /// Create a task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      tags: List<String>.from(json['tags'] as List? ?? []),
      estimatedHours: json['estimatedHours']?.toDouble(),
      actualHours: json['actualHours']?.toDouble(),
    );
  }

  /// Convert task to JSON
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
      'estimatedHours': estimatedHours,
      'actualHours': actualHours,
    };
  }

  /// Create a copy with modified fields (immutable update pattern)
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
    double? estimatedHours,
    double? actualHours,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
    );
  }

  /// Create a factory constructor for new tasks
  factory Task.create({
    required String title,
    required String description,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    List<String>? tags,
    double? estimatedHours,
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      tags: tags ?? [],
      estimatedHours: estimatedHours,
    );
  }

  /// Mark task as completed
  Task markCompleted() {
    return copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
  }

  /// Mark task as in progress
  Task markInProgress() {
    return copyWith(
      status: TaskStatus.inProgress,
    );
  }

  /// Mark task as cancelled
  Task markCancelled() {
    return copyWith(
      status: TaskStatus.cancelled,
    );
  }

  /// Add a tag to the task
  Task addTag(String tag) {
    if (tags.contains(tag)) return this;
    return copyWith(tags: [...tags, tag]);
  }

  /// Remove a tag from the task
  Task removeTag(String tag) {
    return copyWith(tags: tags.where((t) => t != tag).toList());
  }

  /// Business logic: Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || status.isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Business logic: Check if task is due soon (within 24 hours)
  bool get isDueSoon {
    if (dueDate == null || status.isCompleted) return false;
    final now = DateTime.now();
    final timeUntilDue = dueDate!.difference(now);
    return timeUntilDue.inHours <= 24 && timeUntilDue.inHours > 0;
  }

  /// Business logic: Get progress percentage
  double get progressPercentage {
    switch (status) {
      case TaskStatus.pending:
        return 0.0;
      case TaskStatus.inProgress:
        return 0.5;
      case TaskStatus.completed:
        return 1.0;
      case TaskStatus.cancelled:
        return 0.0;
    }
  }

  /// Business logic: Calculate completion time if completed
  Duration? get completionTime {
    if (completedAt == null) return null;
    return completedAt!.difference(createdAt);
  }

  /// Business logic: Check if task meets estimated time
  bool get meetsEstimate {
    if (estimatedHours == null || actualHours == null) return true;
    return actualHours! <= estimatedHours!;
  }

  /// Validation: Check if task data is valid
  TaskValidationResult validate() {
    final errors = <String>[];

    // Title validation
    if (title.trim().isEmpty) {
      errors.add('Title is required');
    } else if (title.length > 100) {
      errors.add('Title must be less than 100 characters');
    }

    // Description validation (optional but if provided, check length)
    if (description.length > 500) {
      errors.add('Description must be less than 500 characters');
    }

    // Due date validation
    if (dueDate != null && dueDate!.isBefore(createdAt)) {
      errors.add('Due date cannot be before creation date');
    }

    // Hours validation
    if (estimatedHours != null && estimatedHours! < 0) {
      errors.add('Estimated hours cannot be negative');
    }

    if (actualHours != null && actualHours! < 0) {
      errors.add('Actual hours cannot be negative');
    }

    // Status consistency validation
    if (status == TaskStatus.completed && completedAt == null) {
      errors.add('Completed tasks must have a completion date');
    }

    if (status != TaskStatus.completed && completedAt != null) {
      errors.add('Only completed tasks can have a completion date');
    }

    return TaskValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Get display color based on priority and status
  Color get displayColor {
    if (status == TaskStatus.completed) {
      return const Color(0xFF10B981); // Green for completed
    }
    if (status == TaskStatus.cancelled) {
      return const Color(0xFF6B7280); // Gray for cancelled
    }
    if (isOverdue) {
      return const Color(0xFFEF4444); // Red for overdue
    }
    return TaskPriority.getColor(priority);
  }

  /// Get status badge text
  String get statusBadge {
    if (isOverdue && !status.isCompleted) {
      return 'Overdue';
    }
    if (isDueSoon) {
      return 'Due Soon';
    }
    return status.label;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.priority == priority &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.dueDate == dueDate &&
        other.completedAt == completedAt &&
        listEquals(other.tags, tags) &&
        other.estimatedHours == estimatedHours &&
        other.actualHours == actualHours;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      priority,
      status,
      createdAt,
      dueDate,
      completedAt,
      Object.hashAll(tags),
      estimatedHours,
      actualHours,
    );
  }

  @override
  String toString() {
    return 'Task('
        'id: $id, '
        'title: $title, '
        'status: $status, '
        'priority: $priority, '
        'isOverdue: $isOverdue'
        ')';
  }
}

/// Task validation result
class TaskValidationResult {
  const TaskValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Whether the task data is valid
  final bool isValid;

  /// List of validation errors
  final List<String> errors;

  /// Get formatted error message
  String get errorMessage => errors.join('\n');

  @override
  String toString() {
    return 'TaskValidationResult(isValid: $isValid, errors: ${errors.length})';
  }
}