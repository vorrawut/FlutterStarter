import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/storage_constants.dart';

part 'note.g.dart';

@HiveType(typeId: StorageConstants.noteTypeId)
@JsonSerializable()
class Note extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String? categoryId;

  @HiveField(4)
  final List<String> tagIds;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  final bool isFavorite;

  @HiveField(8)
  final bool isArchived;

  @HiveField(9)
  final String color;

  @HiveField(10)
  final NotePriority priority;

  @HiveField(11)
  final DateTime? remindAt;

  @HiveField(12)
  final bool encrypted;

  @HiveField(13)
  final SyncStatus syncStatus;

  @HiveField(14)
  final DateTime? lastSynced;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.tagIds = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.isArchived = false,
    this.color = StorageConstants.defaultNoteColor,
    this.priority = NotePriority.normal,
    this.remindAt,
    this.encrypted = false,
    this.syncStatus = SyncStatus.synced,
    this.lastSynced,
  });

  factory Note.create({
    required String id,
    required String title,
    String content = '',
    String? categoryId,
    List<String> tagIds = const [],
    String color = StorageConstants.defaultNoteColor,
    NotePriority priority = NotePriority.normal,
    DateTime? remindAt,
    bool encrypted = false,
  }) {
    final now = DateTime.now();
    return Note(
      id: id,
      title: title,
      content: content,
      categoryId: categoryId,
      tagIds: tagIds,
      createdAt: now,
      updatedAt: now,
      color: color,
      priority: priority,
      remindAt: remindAt,
      encrypted: encrypted,
      syncStatus: SyncStatus.pendingSync,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);

  // SQLite conversion methods
  factory Note.fromSqlite(Map<String, dynamic> map) {
    return Note(
      id: map[StorageConstants.noteIdColumn] as String,
      title: map[StorageConstants.noteTitleColumn] as String,
      content: map[StorageConstants.noteContentColumn] as String? ?? '',
      categoryId: map[StorageConstants.noteCategoryIdColumn] as String?,
      tagIds: [], // Will be populated separately from junction table
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[StorageConstants.noteCreatedAtColumn] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map[StorageConstants.noteUpdatedAtColumn] as int,
      ),
      isFavorite: (map[StorageConstants.noteIsFavoriteColumn] as int) == 1,
      isArchived: (map[StorageConstants.noteIsArchivedColumn] as int) == 1,
      color: map[StorageConstants.noteColorColumn] as String? ?? 
             StorageConstants.defaultNoteColor,
      priority: NotePriority.values[
        map[StorageConstants.notePriorityColumn] as int? ?? 0
      ],
      remindAt: map[StorageConstants.noteRemindAtColumn] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[StorageConstants.noteRemindAtColumn] as int,
            )
          : null,
      encrypted: (map[StorageConstants.noteEncryptedColumn] as int? ?? 0) == 1,
      syncStatus: SyncStatus.values[
        map[StorageConstants.noteSyncStatusColumn] as int? ?? 0
      ],
      lastSynced: map[StorageConstants.noteLastSyncedColumn] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[StorageConstants.noteLastSyncedColumn] as int,
            )
          : null,
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      StorageConstants.noteIdColumn: id,
      StorageConstants.noteTitleColumn: title,
      StorageConstants.noteContentColumn: content,
      StorageConstants.noteCategoryIdColumn: categoryId,
      StorageConstants.noteCreatedAtColumn: createdAt.millisecondsSinceEpoch,
      StorageConstants.noteUpdatedAtColumn: updatedAt.millisecondsSinceEpoch,
      StorageConstants.noteIsFavoriteColumn: isFavorite ? 1 : 0,
      StorageConstants.noteIsArchivedColumn: isArchived ? 1 : 0,
      StorageConstants.noteColorColumn: color,
      StorageConstants.notePriorityColumn: priority.index,
      StorageConstants.noteRemindAtColumn: remindAt?.millisecondsSinceEpoch,
      StorageConstants.noteEncryptedColumn: encrypted ? 1 : 0,
      StorageConstants.noteSyncStatusColumn: syncStatus.index,
      StorageConstants.noteLastSyncedColumn: lastSynced?.millisecondsSinceEpoch,
    };
  }

  Note copyWith({
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
    return Note(
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

  Note markUpdated() {
    return copyWith(
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pendingSync,
    );
  }

  Note markSynced() {
    return copyWith(
      syncStatus: SyncStatus.synced,
      lastSynced: DateTime.now(),
    );
  }

  Note markFavorite(bool favorite) {
    return copyWith(isFavorite: favorite).markUpdated();
  }

  Note markArchived(bool archived) {
    return copyWith(isArchived: archived).markUpdated();
  }

  Note addTag(String tagId) {
    if (tagIds.contains(tagId)) return this;
    return copyWith(tagIds: [...tagIds, tagId]).markUpdated();
  }

  Note removeTag(String tagId) {
    return copyWith(
      tagIds: tagIds.where((id) => id != tagId).toList(),
    ).markUpdated();
  }

  // Business logic methods
  bool get hasReminder => remindAt != null;
  bool get isOverdue => hasReminder && 
                       remindAt!.isBefore(DateTime.now());
  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;
  bool get hasContent => content.trim().isNotEmpty;
  bool get hasCategory => categoryId != null && categoryId!.isNotEmpty;
  bool get hasTags => tagIds.isNotEmpty;
  bool get needsSync => syncStatus != SyncStatus.synced;
  
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);
  Duration get timeSinceUpdate => DateTime.now().difference(updatedAt);
  
  String get displayTitle => title.trim().isEmpty 
      ? StorageConstants.defaultNoteTitle 
      : title;
  
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
    return 'Note(id: $id, title: $displayTitle, priority: $priority)';
  }
}

@HiveType(typeId: StorageConstants.noteTypeId + 10)
enum NotePriority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent
}

@HiveType(typeId: StorageConstants.noteTypeId + 11)
enum SyncStatus {
  @HiveField(0)
  synced,
  @HiveField(1)
  pendingSync,
  @HiveField(2)
  syncing,
  @HiveField(3)
  syncError,
  @HiveField(4)
  conflict
}

extension NotePriorityExtension on NotePriority {
  String get displayName {
    switch (this) {
      case NotePriority.low:
        return 'Low';
      case NotePriority.normal:
        return 'Normal';
      case NotePriority.high:
        return 'High';
      case NotePriority.urgent:
        return 'Urgent';
    }
  }

  int get value => index;
}

extension SyncStatusExtension on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pendingSync:
        return 'Pending';
      case SyncStatus.syncing:
        return 'Syncing';
      case SyncStatus.syncError:
        return 'Error';
      case SyncStatus.conflict:
        return 'Conflict';
    }
  }

  bool get canSync => this == SyncStatus.pendingSync || this == SyncStatus.syncError;
}