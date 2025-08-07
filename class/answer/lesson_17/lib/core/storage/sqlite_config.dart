import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/storage_constants.dart';
import '../../data/models/note.dart';
import '../../data/models/category.dart';
import '../../data/models/tag.dart';

class SQLiteConfig {
  static Database? _database;
  static bool _initialized = false;

  static Future<Database> get database async {
    if (_database != null && _initialized) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, StorageConstants.sqliteDbName);

    return await openDatabase(
      path,
      version: StorageConstants.sqliteDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  static Future<void> _onConfigure(Database db) async {
    // Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');
    
    // Optimize performance
    await db.execute('PRAGMA cache_size = 10000');
    await db.execute('PRAGMA temp_store = MEMORY');
    await db.execute('PRAGMA journal_mode = WAL');
    await db.execute('PRAGMA synchronous = NORMAL');
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute(StorageConstants.createCategoriesTable);
    await db.execute(StorageConstants.createTagsTable);
    await db.execute(StorageConstants.createNotesTable);
    await db.execute(StorageConstants.createNoteTagsTable);

    // Create indexes
    final indexes = StorageConstants.createNotesIndexes.split(';');
    for (final index in indexes) {
      if (index.trim().isNotEmpty) {
        await db.execute(index.trim());
      }
    }

    // Try to create FTS table (if supported)
    try {
      await db.execute(StorageConstants.createNotesSearchTable);
    } catch (e) {
      // FTS not supported, continue without it
      print('FTS not supported: $e');
    }

    // Insert default data
    await _insertDefaultData(db);
    
    _initialized = true;
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Example: Add new columns, tables, or indexes
      // This is where you'd implement migration logic
      print('Upgrading database from version $oldVersion to $newVersion');
    }
  }

  static Future<void> _insertDefaultData(Database db) async {
    // Insert default category
    final defaultCategory = Category.defaultCategory();
    await db.insert(
      StorageConstants.categoriesTable,
      defaultCategory.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // Insert predefined categories
    final predefinedCategories = PredefinedCategories.generatePredefined();
    for (final category in predefinedCategories) {
      await db.insert(
        StorageConstants.categoriesTable,
        category.toSqlite(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    // Insert predefined tags
    final predefinedTags = PredefinedTags.generatePredefined();
    for (final tag in predefinedTags) {
      await db.insert(
        StorageConstants.tagsTable,
        tag.toSqlite(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // Notes operations
  static Future<String> insertNote(Note note) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Insert note
      await txn.insert(
        StorageConstants.notesTable,
        note.toSqlite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert note-tag relationships
      await _insertNoteTags(txn, note.id, note.tagIds);

      // Update FTS index if available
      await _updateSearchIndex(txn, note);
    });

    return note.id;
  }

  static Future<void> updateNote(Note note) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Update note
      await txn.update(
        StorageConstants.notesTable,
        note.toSqlite(),
        where: '${StorageConstants.noteIdColumn} = ?',
        whereArgs: [note.id],
      );

      // Update note-tag relationships
      await _deleteNoteTags(txn, note.id);
      await _insertNoteTags(txn, note.id, note.tagIds);

      // Update FTS index if available
      await _updateSearchIndex(txn, note);
    });
  }

  static Future<void> deleteNote(String noteId) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Delete note (cascades to note_tags due to foreign key)
      await txn.delete(
        StorageConstants.notesTable,
        where: '${StorageConstants.noteIdColumn} = ?',
        whereArgs: [noteId],
      );

      // Delete from FTS index if available
      await _deleteFromSearchIndex(txn, noteId);
    });
  }

  static Future<Note?> getNote(String noteId) async {
    final db = await database;
    
    final result = await db.query(
      StorageConstants.notesTable,
      where: '${StorageConstants.noteIdColumn} = ?',
      whereArgs: [noteId],
    );

    if (result.isEmpty) return null;

    final note = Note.fromSqlite(result.first);
    final tagIds = await _getNoteTags(db, noteId);
    
    return note.copyWith(tagIds: tagIds);
  }

  static Future<List<Note>> getAllNotes({
    String? categoryId,
    List<String>? tagIds,
    bool? isFavorite,
    bool? isArchived,
    NotePriority? priority,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    
    final whereConditions = <String>[];
    final whereArgs = <dynamic>[];

    // Build WHERE clause
    if (categoryId != null) {
      whereConditions.add('${StorageConstants.noteCategoryIdColumn} = ?');
      whereArgs.add(categoryId);
    }

    if (isFavorite != null) {
      whereConditions.add('${StorageConstants.noteIsFavoriteColumn} = ?');
      whereArgs.add(isFavorite ? 1 : 0);
    }

    if (isArchived != null) {
      whereConditions.add('${StorageConstants.noteIsArchivedColumn} = ?');
      whereArgs.add(isArchived ? 1 : 0);
    }

    if (priority != null) {
      whereConditions.add('${StorageConstants.notePriorityColumn} = ?');
      whereArgs.add(priority.index);
    }

    // Build ORDER BY clause
    String? orderByClause;
    if (orderBy != null) {
      final direction = ascending ? 'ASC' : 'DESC';
      orderByClause = '$orderBy $direction';
    }

    // Build LIMIT clause
    String? limitClause;
    if (limit != null) {
      limitClause = offset != null ? 'LIMIT $limit OFFSET $offset' : 'LIMIT $limit';
    }

    // Execute query
    String query = 'SELECT * FROM ${StorageConstants.notesTable}';
    
    if (whereConditions.isNotEmpty) {
      query += ' WHERE ${whereConditions.join(' AND ')}';
    }
    
    if (orderByClause != null) {
      query += ' ORDER BY $orderByClause';
    }
    
    if (limitClause != null) {
      query += ' $limitClause';
    }

    final result = await db.rawQuery(query, whereArgs);
    final notes = <Note>[];

    for (final row in result) {
      final note = Note.fromSqlite(row);
      final noteTagIds = await _getNoteTags(db, note.id);
      
      // Apply tag filter if specified
      if (tagIds != null && tagIds.isNotEmpty) {
        if (!tagIds.every((tagId) => noteTagIds.contains(tagId))) {
          continue;
        }
      }
      
      notes.add(note.copyWith(tagIds: noteTagIds));
    }

    return notes;
  }

  static Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    
    // Try FTS search first
    try {
      final ftsResult = await db.rawQuery('''
        SELECT n.* FROM ${StorageConstants.notesTable} n
        JOIN notes_search s ON n.${StorageConstants.noteIdColumn} = s.rowid
        WHERE notes_search MATCH ?
        ORDER BY rank
      ''', [query]);
      
      if (ftsResult.isNotEmpty) {
        final notes = <Note>[];
        for (final row in ftsResult) {
          final note = Note.fromSqlite(row);
          final tagIds = await _getNoteTags(db, note.id);
          notes.add(note.copyWith(tagIds: tagIds));
        }
        return notes;
      }
    } catch (e) {
      // FTS not available, fall back to LIKE search
    }

    // Fallback to LIKE search
    final likeQuery = '%$query%';
    final result = await db.query(
      StorageConstants.notesTable,
      where: '''
        ${StorageConstants.noteTitleColumn} LIKE ? OR 
        ${StorageConstants.noteContentColumn} LIKE ?
      ''',
      whereArgs: [likeQuery, likeQuery],
      orderBy: '${StorageConstants.noteUpdatedAtColumn} DESC',
    );

    final notes = <Note>[];
    for (final row in result) {
      final note = Note.fromSqlite(row);
      final tagIds = await _getNoteTags(db, note.id);
      notes.add(note.copyWith(tagIds: tagIds));
    }

    return notes;
  }

  // Categories operations
  static Future<String> insertCategory(Category category) async {
    final db = await database;
    await db.insert(
      StorageConstants.categoriesTable,
      category.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return category.id;
  }

  static Future<List<Category>> getAllCategories() async {
    final db = await database;
    final result = await db.query(
      StorageConstants.categoriesTable,
      orderBy: '${StorageConstants.categoryOrderColumn} ASC, ${StorageConstants.categoryNameColumn} ASC',
    );

    final categories = <Category>[];
    for (final row in result) {
      final category = Category.fromSqlite(row);
      final noteCount = await _getCategoryNoteCount(db, category.id);
      categories.add(category.updateNoteCount(noteCount));
    }

    return categories;
  }

  // Tags operations
  static Future<String> insertTag(Tag tag) async {
    final db = await database;
    await db.insert(
      StorageConstants.tagsTable,
      tag.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return tag.id;
  }

  static Future<List<Tag>> getAllTags() async {
    final db = await database;
    final result = await db.query(
      StorageConstants.tagsTable,
      orderBy: '${StorageConstants.tagUsageCountColumn} DESC, ${StorageConstants.tagNameColumn} ASC',
    );

    return result.map((row) => Tag.fromSqlite(row)).toList();
  }

  // Helper methods
  static Future<void> _insertNoteTags(DatabaseExecutor db, String noteId, List<String> tagIds) async {
    for (final tagId in tagIds) {
      await db.insert(
        StorageConstants.noteTagsTable,
        {
          StorageConstants.noteTagNoteIdColumn: noteId,
          StorageConstants.noteTagTagIdColumn: tagId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  static Future<void> _deleteNoteTags(DatabaseExecutor db, String noteId) async {
    await db.delete(
      StorageConstants.noteTagsTable,
      where: '${StorageConstants.noteTagNoteIdColumn} = ?',
      whereArgs: [noteId],
    );
  }

  static Future<List<String>> _getNoteTags(Database db, String noteId) async {
    final result = await db.query(
      StorageConstants.noteTagsTable,
      columns: [StorageConstants.noteTagTagIdColumn],
      where: '${StorageConstants.noteTagNoteIdColumn} = ?',
      whereArgs: [noteId],
    );

    return result.map((row) => row[StorageConstants.noteTagTagIdColumn] as String).toList();
  }

  static Future<int> _getCategoryNoteCount(Database db, String categoryId) async {
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM ${StorageConstants.notesTable}
      WHERE ${StorageConstants.noteCategoryIdColumn} = ?
    ''', [categoryId]);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<void> _updateSearchIndex(DatabaseExecutor db, Note note) async {
    try {
      await db.rawInsert('''
        INSERT OR REPLACE INTO notes_search(rowid, title, content)
        VALUES (?, ?, ?)
      ''', [note.id, note.title, note.content]);
    } catch (e) {
      // FTS not available
    }
  }

  static Future<void> _deleteFromSearchIndex(DatabaseExecutor db, String noteId) async {
    try {
      await db.rawDelete('''
        DELETE FROM notes_search WHERE rowid = ?
      ''', [noteId]);
    } catch (e) {
      // FTS not available
    }
  }

  // Utility methods
  static Future<void> clearAllData() async {
    final db = await database;
    
    await db.transaction((txn) async {
      await txn.delete(StorageConstants.noteTagsTable);
      await txn.delete(StorageConstants.notesTable);
      await txn.delete(StorageConstants.tagsTable);
      await txn.delete(StorageConstants.categoriesTable);
    });

    // Reinsert default data
    await _insertDefaultData(db);
  }

  static Future<Map<String, dynamic>> getPerformanceStats() async {
    final db = await database;
    
    final notesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${StorageConstants.notesTable}')
    ) ?? 0;
    
    final categoriesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${StorageConstants.categoriesTable}')
    ) ?? 0;
    
    final tagsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${StorageConstants.tagsTable}')
    ) ?? 0;

    return {
      'notes_count': notesCount,
      'categories_count': categoriesCount,
      'tags_count': tagsCount,
      'database_path': _database?.path,
      'is_initialized': _initialized,
    };
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _initialized = false;
    }
  }
}