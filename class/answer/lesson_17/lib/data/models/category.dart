import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/storage_constants.dart';

part 'category.g.dart';

@HiveType(typeId: StorageConstants.categoryTypeId)
@JsonSerializable()
class Category extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String color;

  @HiveField(4)
  final String icon;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final int orderIndex;

  @HiveField(7)
  final int noteCount;

  const Category({
    required this.id,
    required this.name,
    this.description = '',
    this.color = StorageConstants.defaultCategoryColor,
    this.icon = 'folder',
    required this.createdAt,
    this.orderIndex = 0,
    this.noteCount = 0,
  });

  factory Category.create({
    required String id,
    required String name,
    String description = '',
    String color = StorageConstants.defaultCategoryColor,
    String icon = 'folder',
    int orderIndex = 0,
  }) {
    return Category(
      id: id,
      name: name,
      description: description,
      color: color,
      icon: icon,
      createdAt: DateTime.now(),
      orderIndex: orderIndex,
    );
  }

  factory Category.defaultCategory() {
    return Category(
      id: StorageConstants.defaultCategoryId,
      name: StorageConstants.defaultCategoryName,
      description: 'Default category for uncategorized notes',
      color: StorageConstants.defaultCategoryColor,
      icon: 'folder',
      createdAt: DateTime.now(),
      orderIndex: 0,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  // SQLite conversion methods
  factory Category.fromSqlite(Map<String, dynamic> map) {
    return Category(
      id: map[StorageConstants.categoryIdColumn] as String,
      name: map[StorageConstants.categoryNameColumn] as String,
      description: map[StorageConstants.categoryDescriptionColumn] as String? ?? '',
      color: map[StorageConstants.categoryColorColumn] as String? ?? 
             StorageConstants.defaultCategoryColor,
      icon: map[StorageConstants.categoryIconColumn] as String? ?? 'folder',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[StorageConstants.categoryCreatedAtColumn] as int,
      ),
      orderIndex: map[StorageConstants.categoryOrderColumn] as int? ?? 0,
      noteCount: 0, // Will be calculated separately
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      StorageConstants.categoryIdColumn: id,
      StorageConstants.categoryNameColumn: name,
      StorageConstants.categoryDescriptionColumn: description,
      StorageConstants.categoryColorColumn: color,
      StorageConstants.categoryIconColumn: icon,
      StorageConstants.categoryCreatedAtColumn: createdAt.millisecondsSinceEpoch,
      StorageConstants.categoryOrderColumn: orderIndex,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    String? icon,
    DateTime? createdAt,
    int? orderIndex,
    int? noteCount,
  }) {
    return Category(
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

  Category updateNoteCount(int count) {
    return copyWith(noteCount: count);
  }

  Category incrementNoteCount() {
    return copyWith(noteCount: noteCount + 1);
  }

  Category decrementNoteCount() {
    return copyWith(noteCount: noteCount > 0 ? noteCount - 1 : 0);
  }

  // Business logic methods
  bool get isDefault => id == StorageConstants.defaultCategoryId;
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
    return 'Category(id: $id, name: $displayName, noteCount: $noteCount)';
  }
}

// Predefined categories for better UX
class PredefinedCategories {
  static const List<Map<String, String>> templates = [
    {
      'name': 'Personal',
      'description': 'Personal thoughts and ideas',
      'color': '#E91E63',
      'icon': 'person',
    },
    {
      'name': 'Work',
      'description': 'Work-related notes and tasks',
      'color': '#2196F3',
      'icon': 'work',
    },
    {
      'name': 'Ideas',
      'description': 'Creative ideas and inspiration',
      'color': '#FF9800',
      'icon': 'lightbulb',
    },
    {
      'name': 'Learning',
      'description': 'Study notes and learning materials',
      'color': '#4CAF50',
      'icon': 'school',
    },
    {
      'name': 'Projects',
      'description': 'Project planning and documentation',
      'color': '#9C27B0',
      'icon': 'assignment',
    },
    {
      'name': 'Travel',
      'description': 'Travel plans and memories',
      'color': '#00BCD4',
      'icon': 'flight',
    },
    {
      'name': 'Health',
      'description': 'Health and wellness notes',
      'color': '#8BC34A',
      'icon': 'favorite',
    },
    {
      'name': 'Finance',
      'description': 'Financial planning and budgets',
      'color': '#FFC107',
      'icon': 'attach_money',
    },
  ];

  static List<Category> generatePredefined() {
    return templates.map((template) {
      return Category.create(
        id: template['name']!.toLowerCase().replaceAll(' ', '_'),
        name: template['name']!,
        description: template['description']!,
        color: template['color']!,
        icon: template['icon']!,
      );
    }).toList();
  }
}