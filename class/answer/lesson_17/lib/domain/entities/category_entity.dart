import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String color;
  final String icon;
  final DateTime createdAt;
  final int orderIndex;
  final int noteCount;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.color,
    this.icon = 'folder',
    required this.createdAt,
    this.orderIndex = 0,
    this.noteCount = 0,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    String? icon,
    DateTime? createdAt,
    int? orderIndex,
    int? noteCount,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      orderIndex: orderIndex ?? this.orderIndex,
      noteCount: noteCount ?? this.noteCount,
    );
  }

  // Business logic methods
  bool get isDefault => id == 'default';
  bool get hasNotes => noteCount > 0;
  bool get hasDescription => description.trim().isNotEmpty;
  
  String get displayName => name.trim().isEmpty ? 'Unnamed Category' : name;
  
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);

  String get noteCountText {
    if (noteCount == 0) return 'No notes';
    if (noteCount == 1) return '1 note';
    return '$noteCount notes';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        icon,
        createdAt,
        orderIndex,
        noteCount,
      ];

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $displayName, noteCount: $noteCount)';
  }
}