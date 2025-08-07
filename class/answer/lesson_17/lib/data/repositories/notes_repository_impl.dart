import '../../domain/repositories/notes_repository.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/tag_entity.dart';
import '../datasources/local/hive_notes_datasource.dart';
import '../models/note.dart';
import '../models/category.dart';
import '../models/tag.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource _localDataSource;

  NotesRepositoryImpl({
    required NotesLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<String> createNote(NoteEntity noteEntity) async {
    final note = _mapNoteEntityToModel(noteEntity);
    return await _localDataSource.createNote(note);
  }

  @override
  Future<void> updateNote(NoteEntity noteEntity) async {
    final note = _mapNoteEntityToModel(noteEntity);
    await _localDataSource.updateNote(note);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await _localDataSource.deleteNote(noteId);
  }

  @override
  Future<NoteEntity?> getNote(String noteId) async {
    final note = await _localDataSource.getNote(noteId);
    return note != null ? _mapNoteModelToEntity(note) : null;
  }

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    final notes = await _localDataSource.getAllNotes();
    return notes.map(_mapNoteModelToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> getFilteredNotes({
    String? categoryId,
    List<String>? tagIds,
    bool? isFavorite,
    bool? isArchived,
    NotePriority? priority,
  }) async {
    final notes = await _localDataSource.getFilteredNotes(
      categoryId: categoryId,
      tagIds: tagIds,
      isFavorite: isFavorite,
      isArchived: isArchived,
      priority: priority,
    );
    return notes.map(_mapNoteModelToEntity).toList();
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    final notes = await _localDataSource.searchNotes(query);
    return notes.map(_mapNoteModelToEntity).toList();
  }

  @override
  Future<String> createCategory(CategoryEntity categoryEntity) async {
    final category = _mapCategoryEntityToModel(categoryEntity);
    return await _localDataSource.createCategory(category);
  }

  @override
  Future<void> updateCategory(CategoryEntity categoryEntity) async {
    final category = _mapCategoryEntityToModel(categoryEntity);
    await _localDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await _localDataSource.deleteCategory(categoryId);
  }

  @override
  Future<CategoryEntity?> getCategory(String categoryId) async {
    final category = await _localDataSource.getCategory(categoryId);
    return category != null ? _mapCategoryModelToEntity(category) : null;
  }

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final categories = await _localDataSource.getAllCategories();
    return categories.map(_mapCategoryModelToEntity).toList();
  }

  @override
  Future<String> createTag(TagEntity tagEntity) async {
    final tag = _mapTagEntityToModel(tagEntity);
    return await _localDataSource.createTag(tag);
  }

  @override
  Future<void> updateTag(TagEntity tagEntity) async {
    final tag = _mapTagEntityToModel(tagEntity);
    await _localDataSource.updateTag(tag);
  }

  @override
  Future<void> deleteTag(String tagId) async {
    await _localDataSource.deleteTag(tagId);
  }

  @override
  Future<TagEntity?> getTag(String tagId) async {
    final tag = await _localDataSource.getTag(tagId);
    return tag != null ? _mapTagModelToEntity(tag) : null;
  }

  @override
  Future<List<TagEntity>> getAllTags() async {
    final tags = await _localDataSource.getAllTags();
    return tags.map(_mapTagModelToEntity).toList();
  }

  @override
  Future<void> clearAllData() async {
    await _localDataSource.clearAllData();
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    return await _localDataSource.getStatistics();
  }

  // Mapping methods from models to entities
  NoteEntity _mapNoteModelToEntity(Note note) {
    return NoteEntity(
      id: note.id,
      title: note.title,
      content: note.content,
      categoryId: note.categoryId,
      tagIds: note.tagIds,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isFavorite: note.isFavorite,
      isArchived: note.isArchived,
      color: note.color,
      priority: note.priority,
      remindAt: note.remindAt,
      encrypted: note.encrypted,
      syncStatus: note.syncStatus,
      lastSynced: note.lastSynced,
    );
  }

  CategoryEntity _mapCategoryModelToEntity(Category category) {
    return CategoryEntity(
      id: category.id,
      name: category.name,
      description: category.description,
      color: category.color,
      icon: category.icon,
      createdAt: category.createdAt,
      orderIndex: category.orderIndex,
      noteCount: category.noteCount,
    );
  }

  TagEntity _mapTagModelToEntity(Tag tag) {
    return TagEntity(
      id: tag.id,
      name: tag.name,
      color: tag.color,
      usageCount: tag.usageCount,
      createdAt: tag.createdAt,
    );
  }

  // Mapping methods from entities to models
  Note _mapNoteEntityToModel(NoteEntity entity) {
    return Note(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      categoryId: entity.categoryId,
      tagIds: entity.tagIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isFavorite: entity.isFavorite,
      isArchived: entity.isArchived,
      color: entity.color,
      priority: entity.priority,
      remindAt: entity.remindAt,
      encrypted: entity.encrypted,
      syncStatus: entity.syncStatus,
      lastSynced: entity.lastSynced,
    );
  }

  Category _mapCategoryEntityToModel(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      color: entity.color,
      icon: entity.icon,
      createdAt: entity.createdAt,
      orderIndex: entity.orderIndex,
      noteCount: entity.noteCount,
    );
  }

  Tag _mapTagEntityToModel(TagEntity entity) {
    return Tag(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      usageCount: entity.usageCount,
      createdAt: entity.createdAt,
    );
  }
}