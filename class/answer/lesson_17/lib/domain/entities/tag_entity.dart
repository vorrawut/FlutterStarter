import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final String id;
  final String name;
  final String color;
  final int usageCount;
  final DateTime createdAt;

  const TagEntity({
    required this.id,
    required this.name,
    required this.color,
    this.usageCount = 0,
    required this.createdAt,
  });

  TagEntity copyWith({
    String? id,
    String? name,
    String? color,
    int? usageCount,
    DateTime? createdAt,
  }) {
    return TagEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business logic methods
  bool get isUsed => usageCount > 0;
  bool get isPopular => usageCount >= 5;
  
  String get displayName => name.trim().isEmpty ? 'Unnamed Tag' : name;
  
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);

  String get usageText {
    if (usageCount == 0) return 'Not used';
    if (usageCount == 1) return 'Used once';
    return 'Used $usageCount times';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        usageCount,
        createdAt,
      ];

  @override
  String toString() {
    return 'TagEntity(id: $id, name: $displayName, usageCount: $usageCount)';
  }
}