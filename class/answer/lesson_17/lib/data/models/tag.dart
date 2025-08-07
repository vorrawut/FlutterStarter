import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/storage_constants.dart';

part 'tag.g.dart';

@HiveType(typeId: StorageConstants.tagTypeId)
@JsonSerializable()
class Tag extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String color;

  @HiveField(3)
  final int usageCount;

  @HiveField(4)
  final DateTime createdAt;

  const Tag({
    required this.id,
    required this.name,
    this.color = StorageConstants.defaultTagColor,
    this.usageCount = 0,
    required this.createdAt,
  });

  factory Tag.create({
    required String id,
    required String name,
    String color = StorageConstants.defaultTagColor,
  }) {
    return Tag(
      id: id,
      name: name,
      color: color,
      createdAt: DateTime.now(),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  // SQLite conversion methods
  factory Tag.fromSqlite(Map<String, dynamic> map) {
    return Tag(
      id: map[StorageConstants.tagIdColumn] as String,
      name: map[StorageConstants.tagNameColumn] as String,
      color: map[StorageConstants.tagColorColumn] as String? ?? 
             StorageConstants.defaultTagColor,
      usageCount: map[StorageConstants.tagUsageCountColumn] as int? ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[StorageConstants.tagCreatedAtColumn] as int,
      ),
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      StorageConstants.tagIdColumn: id,
      StorageConstants.tagNameColumn: name,
      StorageConstants.tagColorColumn: color,
      StorageConstants.tagUsageCountColumn: usageCount,
      StorageConstants.tagCreatedAtColumn: createdAt.millisecondsSinceEpoch,
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    String? color,
    int? usageCount,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Tag incrementUsage() {
    return copyWith(usageCount: usageCount + 1);
  }

  Tag decrementUsage() {
    return copyWith(usageCount: usageCount > 0 ? usageCount - 1 : 0);
  }

  Tag updateUsageCount(int count) {
    return copyWith(usageCount: count);
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
    return 'Tag(id: $id, name: $displayName, usageCount: $usageCount)';
  }
}

// Predefined tags for better UX
class PredefinedTags {
  static const List<Map<String, String>> templates = [
    {'name': 'important', 'color': '#F44336'},
    {'name': 'urgent', 'color': '#FF5722'},
    {'name': 'idea', 'color': '#FF9800'},
    {'name': 'todo', 'color': '#2196F3'},
    {'name': 'completed', 'color': '#4CAF50'},
    {'name': 'meeting', 'color': '#9C27B0'},
    {'name': 'review', 'color': '#673AB7'},
    {'name': 'draft', 'color': '#607D8B'},
    {'name': 'reference', 'color': '#795548'},
    {'name': 'reminder', 'color': '#E91E63'},
    {'name': 'inspiration', 'color': '#FFEB3B'},
    {'name': 'research', 'color': '#00BCD4'},
    {'name': 'personal', 'color': '#8BC34A'},
    {'name': 'work', 'color': '#3F51B5'},
    {'name': 'project', 'color': '#009688'},
  ];

  static List<Tag> generatePredefined() {
    return templates.map((template) {
      return Tag.create(
        id: template['name']!,
        name: template['name']!,
        color: template['color']!,
      );
    }).toList();
  }
}