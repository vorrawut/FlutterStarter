import '../../../core/storage/hive_config.dart';
import '../../../core/constants/storage_constants.dart';
import '../../models/note.dart';
import '../../models/category.dart';
import '../../models/tag.dart';

abstract class NotesLocalDataSource {
  // Notes
  Future<String> createNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String noteId);
  Future<Note?> getNote(String noteId);
  Future<List<Note>> getAllNotes();
  Future<List<Note>> getFilteredNotes({
    String? categoryId,
    List<String>? tagIds,
    bool? isFavorite,
    bool? isArchived,
    NotePriority? priority,
  });
  Future<List<Note>> searchNotes(String query);
  
  // Categories
  Future<String> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String categoryId);
  Future<Category?> getCategory(String categoryId);
  Future<List<Category>> getAllCategories();
  
  // Tags
  Future<String> createTag(Tag tag);
  Future<void> updateTag(Tag tag);
  Future<void> deleteTag(String tagId);
  Future<Tag?> getTag(String tagId);
  Future<List<Tag>> getAllTags();
  
  // Utility
  Future<void> clearAllData();
  Future<Map<String, dynamic>> getStatistics();
}

class HiveNotesDataSource implements NotesLocalDataSource {
  
  @override
  Future<String> createNote(Note note) async {
    final box = HiveConfig.getNotesBox();
    await box.put(note.id, note);
    
    // Update tag usage counts
    await _updateTagUsageCounts(note.tagIds, increment: true);
    
    // Record analytics
    HiveConfig.recordEvent(StorageConstants.eventNoteCreated, {
      'note_id': note.id,
      'category_id': note.categoryId,
      'tags_count': note.tagIds.length,
      'has_reminder': note.hasReminder,
      'priority': note.priority.name,
    });
    
    return note.id;
  }

  @override
  Future<void> updateNote(Note note) async {
    final box = HiveConfig.getNotesBox();
    final oldNote = box.get(note.id);
    
    await box.put(note.id, note);
    
    // Update tag usage counts
    if (oldNote != null) {
      await _updateTagUsageCounts(oldNote.tagIds, increment: false);
    }
    await _updateTagUsageCounts(note.tagIds, increment: true);
    
    // Record analytics
    HiveConfig.recordEvent(StorageConstants.eventNoteUpdated, {
      'note_id': note.id,
      'category_changed': oldNote?.categoryId != note.categoryId,
      'tags_changed': oldNote?.tagIds != note.tagIds,
      'word_count': note.wordCount,
    });
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final box = HiveConfig.getNotesBox();
    final note = box.get(noteId);
    
    if (note != null) {
      await box.delete(noteId);
      
      // Update tag usage counts
      await _updateTagUsageCounts(note.tagIds, increment: false);
      
      // Record analytics
      HiveConfig.recordEvent(StorageConstants.eventNoteDeleted, {
        'note_id': noteId,
        'category_id': note.categoryId,
        'was_favorite': note.isFavorite,
        'was_archived': note.isArchived,
      });
    }
  }

  @override
  Future<Note?> getNote(String noteId) async {
    final box = HiveConfig.getNotesBox();
    return box.get(noteId);
  }

  @override
  Future<List<Note>> getAllNotes() async {
    final box = HiveConfig.getNotesBox();
    return box.values.toList();
  }

  @override
  Future<List<Note>> getFilteredNotes({
    String? categoryId,
    List<String>? tagIds,
    bool? isFavorite,
    bool? isArchived,
    NotePriority? priority,
  }) async {
    return HiveConfig.getNotesFiltered(
      categoryId: categoryId,
      tagIds: tagIds,
      isFavorite: isFavorite,
      isArchived: isArchived,
      priority: priority,
    );
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    final results = HiveConfig.searchNotes(query);
    
    // Record search analytics
    HiveConfig.recordEvent(StorageConstants.eventSearchPerformed, {
      'query': query,
      'results_count': results.length,
      'query_length': query.length,
    });
    
    return results;
  }

  @override
  Future<String> createCategory(Category category) async {
    final box = HiveConfig.getCategoriesBox();
    
    // Check for duplicates
    final existing = box.values.where((c) => c.name.toLowerCase() == category.name.toLowerCase());
    if (existing.isNotEmpty) {
      throw Exception(StorageConstants.errorDuplicateCategory);
    }
    
    await box.put(category.id, category);
    
    // Record analytics
    HiveConfig.recordEvent(StorageConstants.eventCategoryCreated, {
      'category_id': category.id,
      'category_name': category.name,
    });
    
    return category.id;
  }

  @override
  Future<void> updateCategory(Category category) async {
    final box = HiveConfig.getCategoriesBox();
    await box.put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final box = HiveConfig.getCategoriesBox();
    
    // Don't allow deleting default category
    if (categoryId == StorageConstants.defaultCategoryId) {
      throw Exception('Cannot delete default category');
    }
    
    // Move notes to default category
    final notesBox = HiveConfig.getNotesBox();
    final notesToUpdate = notesBox.values.where((note) => note.categoryId == categoryId);
    
    for (final note in notesToUpdate) {
      final updatedNote = note.copyWith(categoryId: StorageConstants.defaultCategoryId);
      await notesBox.put(note.id, updatedNote);
    }
    
    await box.delete(categoryId);
  }

  @override
  Future<Category?> getCategory(String categoryId) async {
    final box = HiveConfig.getCategoriesBox();
    return box.get(categoryId);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final box = HiveConfig.getCategoriesBox();
    final notesBox = HiveConfig.getNotesBox();
    
    final categories = box.values.toList();
    
    // Update note counts
    final categoriesWithCounts = <Category>[];
    for (final category in categories) {
      final noteCount = notesBox.values.where((note) => note.categoryId == category.id).length;
      categoriesWithCounts.add(category.updateNoteCount(noteCount));
    }
    
    // Sort by order index, then by name
    categoriesWithCounts.sort((a, b) {
      final orderComparison = a.orderIndex.compareTo(b.orderIndex);
      if (orderComparison != 0) return orderComparison;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    
    return categoriesWithCounts;
  }

  @override
  Future<String> createTag(Tag tag) async {
    final box = HiveConfig.getTagsBox();
    
    // Check for duplicates
    final existing = box.values.where((t) => t.name.toLowerCase() == tag.name.toLowerCase());
    if (existing.isNotEmpty) {
      throw Exception(StorageConstants.errorDuplicateTag);
    }
    
    await box.put(tag.id, tag);
    return tag.id;
  }

  @override
  Future<void> updateTag(Tag tag) async {
    final box = HiveConfig.getTagsBox();
    await box.put(tag.id, tag);
  }

  @override
  Future<void> deleteTag(String tagId) async {
    final box = HiveConfig.getTagsBox();
    
    // Remove tag from all notes
    final notesBox = HiveConfig.getNotesBox();
    final notesToUpdate = notesBox.values.where((note) => note.tagIds.contains(tagId));
    
    for (final note in notesToUpdate) {
      final updatedNote = note.removeTag(tagId);
      await notesBox.put(note.id, updatedNote);
    }
    
    await box.delete(tagId);
  }

  @override
  Future<Tag?> getTag(String tagId) async {
    final box = HiveConfig.getTagsBox();
    return box.get(tagId);
  }

  @override
  Future<List<Tag>> getAllTags() async {
    final box = HiveConfig.getTagsBox();
    final notesBox = HiveConfig.getNotesBox();
    
    final tags = box.values.toList();
    
    // Update usage counts
    final tagsWithCounts = <Tag>[];
    for (final tag in tags) {
      final usageCount = notesBox.values.where((note) => note.tagIds.contains(tag.id)).length;
      tagsWithCounts.add(tag.updateUsageCount(usageCount));
    }
    
    // Sort by usage count (descending), then by name
    tagsWithCounts.sort((a, b) {
      final usageComparison = b.usageCount.compareTo(a.usageCount);
      if (usageComparison != 0) return usageComparison;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    
    return tagsWithCounts;
  }

  @override
  Future<void> clearAllData() async {
    await HiveConfig.clearAllData();
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    final notesBox = HiveConfig.getNotesBox();
    final categoriesBox = HiveConfig.getCategoriesBox();
    final tagsBox = HiveConfig.getTagsBox();
    
    final notes = notesBox.values.toList();
    
    return {
      'total_notes': notes.length,
      'favorite_notes': notes.where((n) => n.isFavorite).length,
      'archived_notes': notes.where((n) => n.isArchived).length,
      'notes_with_reminders': notes.where((n) => n.hasReminder).length,
      'overdue_notes': notes.where((n) => n.isOverdue).length,
      'total_categories': categoriesBox.length,
      'total_tags': tagsBox.length,
      'average_note_length': notes.isEmpty ? 0 : 
          notes.map((n) => n.content.length).reduce((a, b) => a + b) / notes.length,
      'total_words': notes.fold<int>(0, (sum, note) => sum + note.wordCount),
      'performance_stats': HiveConfig.getPerformanceStats(),
      'storage_type': 'hive',
    };
  }

  Future<void> _updateTagUsageCounts(List<String> tagIds, {required bool increment}) async {
    final box = HiveConfig.getTagsBox();
    
    for (final tagId in tagIds) {
      final tag = box.get(tagId);
      if (tag != null) {
        final updatedTag = increment ? tag.incrementUsage() : tag.decrementUsage();
        await box.put(tagId, updatedTag);
      }
    }
  }

  // Batch operations for performance
  Future<void> createNotesBatch(List<Note> notes) async {
    final box = HiveConfig.getNotesBox();
    final notesMap = <String, Note>{};
    
    for (final note in notes) {
      notesMap[note.id] = note;
    }
    
    await box.putAll(notesMap);
  }

  Future<void> updateNotesBatch(List<Note> notes) async {
    await createNotesBatch(notes); // Same operation for Hive
  }

  // Export/Import functionality
  Future<Map<String, dynamic>> exportData() async {
    return await HiveConfig.exportData();
  }

  Future<void> importData(Map<String, dynamic> data) async {
    await HiveConfig.importData(data);
  }
}