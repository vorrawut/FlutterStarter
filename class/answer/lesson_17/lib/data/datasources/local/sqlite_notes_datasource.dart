import '../../../core/storage/sqlite_config.dart';
import '../../../core/constants/storage_constants.dart';
import '../../models/note.dart';
import '../../models/category.dart';
import '../../models/tag.dart';
import 'hive_notes_datasource.dart';

class SQLiteNotesDataSource implements NotesLocalDataSource {
  
  @override
  Future<String> createNote(Note note) async {
    final noteId = await SQLiteConfig.insertNote(note);
    
    // Record analytics (would be stored in SQLite analytics table in real app)
    _recordEvent(StorageConstants.eventNoteCreated, {
      'note_id': note.id,
      'category_id': note.categoryId,
      'tags_count': note.tagIds.length,
      'has_reminder': note.hasReminder,
      'priority': note.priority.name,
    });
    
    return noteId;
  }

  @override
  Future<void> updateNote(Note note) async {
    final oldNote = await getNote(note.id);
    await SQLiteConfig.updateNote(note);
    
    // Record analytics
    _recordEvent(StorageConstants.eventNoteUpdated, {
      'note_id': note.id,
      'category_changed': oldNote?.categoryId != note.categoryId,
      'tags_changed': oldNote?.tagIds != note.tagIds,
      'word_count': note.wordCount,
    });
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final note = await getNote(noteId);
    await SQLiteConfig.deleteNote(noteId);
    
    if (note != null) {
      // Record analytics
      _recordEvent(StorageConstants.eventNoteDeleted, {
        'note_id': noteId,
        'category_id': note.categoryId,
        'was_favorite': note.isFavorite,
        'was_archived': note.isArchived,
      });
    }
  }

  @override
  Future<Note?> getNote(String noteId) async {
    return await SQLiteConfig.getNote(noteId);
  }

  @override
  Future<List<Note>> getAllNotes() async {
    return await SQLiteConfig.getAllNotes(
      orderBy: StorageConstants.noteUpdatedAtColumn,
      ascending: false,
    );
  }

  @override
  Future<List<Note>> getFilteredNotes({
    String? categoryId,
    List<String>? tagIds,
    bool? isFavorite,
    bool? isArchived,
    NotePriority? priority,
  }) async {
    return await SQLiteConfig.getAllNotes(
      categoryId: categoryId,
      tagIds: tagIds,
      isFavorite: isFavorite,
      isArchived: isArchived,
      priority: priority,
      orderBy: StorageConstants.noteUpdatedAtColumn,
      ascending: false,
    );
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    final results = await SQLiteConfig.searchNotes(query);
    
    // Record search analytics
    _recordEvent(StorageConstants.eventSearchPerformed, {
      'query': query,
      'results_count': results.length,
      'query_length': query.length,
    });
    
    return results;
  }

  @override
  Future<String> createCategory(Category category) async {
    // Check for duplicates
    final existing = await getAllCategories();
    final duplicates = existing.where((c) => 
        c.name.toLowerCase() == category.name.toLowerCase());
    
    if (duplicates.isNotEmpty) {
      throw Exception(StorageConstants.errorDuplicateCategory);
    }
    
    final categoryId = await SQLiteConfig.insertCategory(category);
    
    // Record analytics
    _recordEvent(StorageConstants.eventCategoryCreated, {
      'category_id': category.id,
      'category_name': category.name,
    });
    
    return categoryId;
  }

  @override
  Future<void> updateCategory(Category category) async {
    final db = await SQLiteConfig.database;
    await db.update(
      StorageConstants.categoriesTable,
      category.toSqlite(),
      where: '${StorageConstants.categoryIdColumn} = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    // Don't allow deleting default category
    if (categoryId == StorageConstants.defaultCategoryId) {
      throw Exception('Cannot delete default category');
    }
    
    final db = await SQLiteConfig.database;
    
    await db.transaction((txn) async {
      // Move notes to default category
      await txn.update(
        StorageConstants.notesTable,
        {StorageConstants.noteCategoryIdColumn: StorageConstants.defaultCategoryId},
        where: '${StorageConstants.noteCategoryIdColumn} = ?',
        whereArgs: [categoryId],
      );
      
      // Delete category
      await txn.delete(
        StorageConstants.categoriesTable,
        where: '${StorageConstants.categoryIdColumn} = ?',
        whereArgs: [categoryId],
      );
    });
  }

  @override
  Future<Category?> getCategory(String categoryId) async {
    final db = await SQLiteConfig.database;
    final result = await db.query(
      StorageConstants.categoriesTable,
      where: '${StorageConstants.categoryIdColumn} = ?',
      whereArgs: [categoryId],
    );

    if (result.isEmpty) return null;
    return Category.fromSqlite(result.first);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return await SQLiteConfig.getAllCategories();
  }

  @override
  Future<String> createTag(Tag tag) async {
    // Check for duplicates
    final existing = await getAllTags();
    final duplicates = existing.where((t) => 
        t.name.toLowerCase() == tag.name.toLowerCase());
    
    if (duplicates.isNotEmpty) {
      throw Exception(StorageConstants.errorDuplicateTag);
    }
    
    return await SQLiteConfig.insertTag(tag);
  }

  @override
  Future<void> updateTag(Tag tag) async {
    final db = await SQLiteConfig.database;
    await db.update(
      StorageConstants.tagsTable,
      tag.toSqlite(),
      where: '${StorageConstants.tagIdColumn} = ?',
      whereArgs: [tag.id],
    );
  }

  @override
  Future<void> deleteTag(String tagId) async {
    final db = await SQLiteConfig.database;
    
    await db.transaction((txn) async {
      // Remove tag from note_tags junction table (handled by foreign key cascade)
      // Just delete the tag
      await txn.delete(
        StorageConstants.tagsTable,
        where: '${StorageConstants.tagIdColumn} = ?',
        whereArgs: [tagId],
      );
    });
  }

  @override
  Future<Tag?> getTag(String tagId) async {
    final db = await SQLiteConfig.database;
    final result = await db.query(
      StorageConstants.tagsTable,
      where: '${StorageConstants.tagIdColumn} = ?',
      whereArgs: [tagId],
    );

    if (result.isEmpty) return null;
    return Tag.fromSqlite(result.first);
  }

  @override
  Future<List<Tag>> getAllTags() async {
    return await SQLiteConfig.getAllTags();
  }

  @override
  Future<void> clearAllData() async {
    await SQLiteConfig.clearAllData();
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    final db = await SQLiteConfig.database;
    
    // Get note statistics
    final noteStats = await db.rawQuery('''
      SELECT 
        COUNT(*) as total_notes,
        COUNT(CASE WHEN ${StorageConstants.noteIsFavoriteColumn} = 1 THEN 1 END) as favorite_notes,
        COUNT(CASE WHEN ${StorageConstants.noteIsArchivedColumn} = 1 THEN 1 END) as archived_notes,
        COUNT(CASE WHEN ${StorageConstants.noteRemindAtColumn} IS NOT NULL THEN 1 END) as notes_with_reminders,
        COUNT(CASE WHEN ${StorageConstants.noteRemindAtColumn} IS NOT NULL 
                   AND ${StorageConstants.noteRemindAtColumn} < ? THEN 1 END) as overdue_notes,
        AVG(LENGTH(${StorageConstants.noteContentColumn})) as average_note_length,
        SUM(LENGTH(${StorageConstants.noteContentColumn}) - LENGTH(REPLACE(${StorageConstants.noteContentColumn}, ' ', '')) + 1) as total_words
      FROM ${StorageConstants.notesTable}
    ''', [DateTime.now().millisecondsSinceEpoch]);

    final categoryCount = await db.rawQuery('SELECT COUNT(*) as count FROM ${StorageConstants.categoriesTable}');
    final tagCount = await db.rawQuery('SELECT COUNT(*) as count FROM ${StorageConstants.tagsTable}');

    final stats = noteStats.first;
    final totalCategories = categoryCount.first['count'] as int;
    final totalTags = tagCount.first['count'] as int;

    return {
      'total_notes': stats['total_notes'] as int,
      'favorite_notes': stats['favorite_notes'] as int,
      'archived_notes': stats['archived_notes'] as int,
      'notes_with_reminders': stats['notes_with_reminders'] as int,
      'overdue_notes': stats['overdue_notes'] as int,
      'total_categories': totalCategories,
      'total_tags': totalTags,
      'average_note_length': stats['average_note_length'] as double? ?? 0.0,
      'total_words': stats['total_words'] as int? ?? 0,
      'performance_stats': await SQLiteConfig.getPerformanceStats(),
      'storage_type': 'sqlite',
    };
  }

  // Batch operations for performance
  Future<void> createNotesBatch(List<Note> notes) async {
    final db = await SQLiteConfig.database;
    
    await db.transaction((txn) async {
      for (final note in notes) {
        await txn.insert(
          StorageConstants.notesTable,
          note.toSqlite(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        
        // Insert note-tag relationships
        for (final tagId in note.tagIds) {
          await txn.insert(
            StorageConstants.noteTagsTable,
            {
              StorageConstants.noteTagNoteIdColumn: note.id,
              StorageConstants.noteTagTagIdColumn: tagId,
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
    });
  }

  Future<void> updateNotesBatch(List<Note> notes) async {
    final db = await SQLiteConfig.database;
    
    await db.transaction((txn) async {
      for (final note in notes) {
        await txn.update(
          StorageConstants.notesTable,
          note.toSqlite(),
          where: '${StorageConstants.noteIdColumn} = ?',
          whereArgs: [note.id],
        );
        
        // Update note-tag relationships
        await txn.delete(
          StorageConstants.noteTagsTable,
          where: '${StorageConstants.noteTagNoteIdColumn} = ?',
          whereArgs: [note.id],
        );
        
        for (final tagId in note.tagIds) {
          await txn.insert(
            StorageConstants.noteTagsTable,
            {
              StorageConstants.noteTagNoteIdColumn: note.id,
              StorageConstants.noteTagTagIdColumn: tagId,
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
    });
  }

  // Advanced query methods specific to SQLite
  Future<List<Note>> getNotesWithComplexQuery({
    String? searchQuery,
    List<String>? categoryIds,
    List<String>? tagIds,
    DateTime? createdAfter,
    DateTime? createdBefore,
    DateTime? updatedAfter,
    DateTime? updatedBefore,
    List<NotePriority>? priorities,
    bool? hasReminder,
    bool? isOverdue,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final db = await SQLiteConfig.database;
    
    final whereConditions = <String>[];
    final whereArgs = <dynamic>[];

    // Search query
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      whereConditions.add('''
        (${StorageConstants.noteTitleColumn} LIKE ? OR 
         ${StorageConstants.noteContentColumn} LIKE ?)
      ''');
      final likeQuery = '%${searchQuery.trim()}%';
      whereArgs.addAll([likeQuery, likeQuery]);
    }

    // Category filter
    if (categoryIds != null && categoryIds.isNotEmpty) {
      final placeholders = categoryIds.map((_) => '?').join(',');
      whereConditions.add('${StorageConstants.noteCategoryIdColumn} IN ($placeholders)');
      whereArgs.addAll(categoryIds);
    }

    // Date filters
    if (createdAfter != null) {
      whereConditions.add('${StorageConstants.noteCreatedAtColumn} >= ?');
      whereArgs.add(createdAfter.millisecondsSinceEpoch);
    }

    if (createdBefore != null) {
      whereConditions.add('${StorageConstants.noteCreatedAtColumn} <= ?');
      whereArgs.add(createdBefore.millisecondsSinceEpoch);
    }

    if (updatedAfter != null) {
      whereConditions.add('${StorageConstants.noteUpdatedAtColumn} >= ?');
      whereArgs.add(updatedAfter.millisecondsSinceEpoch);
    }

    if (updatedBefore != null) {
      whereConditions.add('${StorageConstants.noteUpdatedAtColumn} <= ?');
      whereArgs.add(updatedBefore.millisecondsSinceEpoch);
    }

    // Priority filter
    if (priorities != null && priorities.isNotEmpty) {
      final priorityIndexes = priorities.map((p) => p.index).toList();
      final placeholders = priorityIndexes.map((_) => '?').join(',');
      whereConditions.add('${StorageConstants.notePriorityColumn} IN ($placeholders)');
      whereArgs.addAll(priorityIndexes);
    }

    // Reminder filter
    if (hasReminder != null) {
      if (hasReminder) {
        whereConditions.add('${StorageConstants.noteRemindAtColumn} IS NOT NULL');
      } else {
        whereConditions.add('${StorageConstants.noteRemindAtColumn} IS NULL');
      }
    }

    // Overdue filter
    if (isOverdue != null && isOverdue) {
      whereConditions.add('''
        ${StorageConstants.noteRemindAtColumn} IS NOT NULL AND 
        ${StorageConstants.noteRemindAtColumn} < ?
      ''');
      whereArgs.add(DateTime.now().millisecondsSinceEpoch);
    }

    // Build query
    String query = 'SELECT * FROM ${StorageConstants.notesTable}';
    
    if (whereConditions.isNotEmpty) {
      query += ' WHERE ${whereConditions.join(' AND ')}';
    }
    
    // Order by
    if (orderBy != null) {
      final direction = ascending ? 'ASC' : 'DESC';
      query += ' ORDER BY $orderBy $direction';
    } else {
      query += ' ORDER BY ${StorageConstants.noteUpdatedAtColumn} DESC';
    }
    
    // Limit and offset
    if (limit != null) {
      query += ' LIMIT $limit';
      if (offset != null) {
        query += ' OFFSET $offset';
      }
    }

    final result = await db.rawQuery(query, whereArgs);
    final notes = <Note>[];

    for (final row in result) {
      final note = Note.fromSqlite(row);
      final tagIds = await _getNoteTags(db, note.id);
      
      // Apply tag filter if specified
      if (tagIds != null && tagIds.isNotEmpty) {
        if (!tagIds.every((tagId) => note.tagIds.contains(tagId))) {
          continue;
        }
      }
      
      notes.add(note.copyWith(tagIds: tagIds));
    }

    return notes;
  }

  Future<List<String>> _getNoteTags(database, String noteId) async {
    final result = await database.query(
      StorageConstants.noteTagsTable,
      columns: [StorageConstants.noteTagTagIdColumn],
      where: '${StorageConstants.noteTagNoteIdColumn} = ?',
      whereArgs: [noteId],
    );

    return result.map((row) => row[StorageConstants.noteTagTagIdColumn] as String).toList();
  }

  // Export/Import functionality
  Future<Map<String, dynamic>> exportData() async {
    final notes = await getAllNotes();
    final categories = await getAllCategories();
    final tags = await getAllTags();

    return {
      'notes': notes.map((n) => n.toJson()).toList(),
      'categories': categories.map((c) => c.toJson()).toList(),
      'tags': tags.map((t) => t.toJson()).toList(),
      'export_timestamp': DateTime.now().toIso8601String(),
      'export_version': '1.0',
      'storage_type': 'sqlite',
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    await clearAllData();

    if (data['categories'] != null) {
      final categoriesData = List<Map<String, dynamic>>.from(data['categories']);
      for (final categoryJson in categoriesData) {
        final category = Category.fromJson(categoryJson);
        await createCategory(category);
      }
    }

    if (data['tags'] != null) {
      final tagsData = List<Map<String, dynamic>>.from(data['tags']);
      for (final tagJson in tagsData) {
        final tag = Tag.fromJson(tagJson);
        await createTag(tag);
      }
    }

    if (data['notes'] != null) {
      final notesData = List<Map<String, dynamic>>.from(data['notes']);
      final notes = notesData.map((json) => Note.fromJson(json)).toList();
      await createNotesBatch(notes);
    }
  }

  // Simple analytics recording (in a real app, this would use a proper analytics service)
  void _recordEvent(String event, Map<String, dynamic> properties) {
    // In a real application, you would store this in an analytics table
    // or send to an analytics service
    print('Event: $event, Properties: $properties');
  }
}