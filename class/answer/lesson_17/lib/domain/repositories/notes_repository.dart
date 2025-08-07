import '../entities/note_entity.dart';
import '../entities/category_entity.dart';
import '../entities/tag_entity.dart';
import '../../data/models/note.dart';

abstract class NotesRepository {
  // Notes operations
  Future<String> createNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(String noteId);
  Future<NoteEntity?> getNote(String noteId);
  Future<List<NoteEntity>> getAllNotes();
  Future<List<NoteEntity>> getFilteredNotes({
    String? categoryId,
    List<String>? tagIds,
    bool? isFavorite,
    bool? isArchived,
    NotePriority? priority,
  });
  Future<List<NoteEntity>> searchNotes(String query);

  // Categories operations
  Future<String> createCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String categoryId);
  Future<CategoryEntity?> getCategory(String categoryId);
  Future<List<CategoryEntity>> getAllCategories();

  // Tags operations
  Future<String> createTag(TagEntity tag);
  Future<void> updateTag(TagEntity tag);
  Future<void> deleteTag(String tagId);
  Future<TagEntity?> getTag(String tagId);
  Future<List<TagEntity>> getAllTags();

  // Utility operations
  Future<void> clearAllData();
  Future<Map<String, dynamic>> getStatistics();
}