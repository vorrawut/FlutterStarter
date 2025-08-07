import 'package:equatable/equatable.dart';
import '../../data/models/note.dart';

class NoteEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? categoryId;
  final List<String> tagIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool isArchived;
  final String color;
  final NotePriority priority;
  final DateTime? remindAt;
  final bool encrypted;
  final SyncStatus syncStatus;
  final DateTime? lastSynced;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.tagIds = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.isArchived = false,
    required this.color,
    this.priority = NotePriority.normal,
    this.remindAt,
    this.encrypted = false,
    this.syncStatus = SyncStatus.synced,
    this.lastSynced,
  });

  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    String? categoryId,
    List<String>? tagIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isArchived,
    String? color,
    NotePriority? priority,
    DateTime? remindAt,
    bool? encrypted,
    SyncStatus? syncStatus,
    DateTime? lastSynced,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      tagIds: tagIds ?? this.tagIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      priority: priority ?? this.priority,
      remindAt: remindAt ?? this.remindAt,
      encrypted: encrypted ?? this.encrypted,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  // Business logic methods
  bool get hasReminder => remindAt != null;
  bool get isOverdue => hasReminder && remindAt!.isBefore(DateTime.now());
  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;
  bool get hasContent => content.trim().isNotEmpty;
  bool get hasCategory => categoryId != null && categoryId!.isNotEmpty;
  bool get hasTags => tagIds.isNotEmpty;
  bool get needsSync => syncStatus != SyncStatus.synced;
  
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);
  Duration get timeSinceUpdate => DateTime.now().difference(updatedAt);
  
  String get displayTitle => title.trim().isEmpty ? 'Untitled Note' : title;
  
  String get excerpt {
    if (content.trim().isEmpty) return 'No content';
    if (content.length <= 100) return content.trim();
    return '${content.trim().substring(0, 97)}...';
  }

  int get wordCount {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  int get characterCount => content.length;

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        categoryId,
        tagIds,
        createdAt,
        updatedAt,
        isFavorite,
        isArchived,
        color,
        priority,
        remindAt,
        encrypted,
        syncStatus,
        lastSynced,
      ];

  @override
  String toString() {
    return 'NoteEntity(id: $id, title: $displayTitle, priority: $priority)';
  }
}