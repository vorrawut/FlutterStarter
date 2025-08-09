# 💾 Workshop

## 🎯 **What We're Building**

Create **NoteMaster Pro** - a comprehensive note-taking application that demonstrates professional local storage patterns with both Hive and SQLite, including:
- **💾 Dual Storage Implementation** - Both Hive (NoSQL) and SQLite (SQL) backends with comparison
- **📝 Advanced Note Management** - Categories, tags, search, favorites, and archive functionality
- **🏗️ Clean Architecture** - Repository pattern with offline-first data access
- **🔄 Data Synchronization** - Intelligent sync strategies and conflict resolution
- **⚡ Performance Optimization** - Efficient querying, indexing, and memory management
- **🧪 Comprehensive Testing** - Mock implementations and integration testing

## ✅ **Expected Outcome**

A production-ready note-taking application demonstrating:
- 💾 **Dual Storage Mastery** - Expert use of both Hive and SQLite with performance comparison
- 🏗️ **Clean Architecture** - Repository pattern with proper separation of concerns
- 📱 **Rich Feature Set** - Categories, tags, search, favorites, archive, and analytics
- 🔄 **Offline-First Design** - Seamless operation without internet connectivity
- ⚡ **Performance Excellence** - Optimized data operations and efficient memory usage
- 🧪 **Testing Excellence** - Comprehensive test coverage for all storage operations

## 🏗️ **Project Architecture**

We'll build a note-taking application with dual storage backends:

```
notemaster_pro/
├── lib/
│   ├── core/                          # 🔧 Core storage infrastructure
│   │   ├── storage/                   # Storage configuration and services
│   │   │   ├── hive_config.dart       # Hive setup and configuration
│   │   │   ├── sqlite_config.dart     # SQLite setup and configuration
│   │   │   └── storage_factory.dart   # Factory for storage selection
│   │   ├── constants/                 # Constants and configuration
│   │   │   ├── storage_constants.dart # Storage-related constants
│   │   │   └── app_constants.dart     # Application constants
│   │   ├── errors/                    # Error handling
│   │   │   ├── storage_exceptions.dart # Storage-specific exceptions
│   │   │   └── sync_exceptions.dart   # Synchronization exceptions
│   │   └── utils/                     # Utilities and helpers
│   │       ├── uuid_generator.dart    # UUID generation
│   │       └── date_utils.dart        # Date utilities
│   ├── data/                          # 💾 Data layer
│   │   ├── models/                    # Data models
│   │   │   ├── note.dart              # Note model with Hive/SQLite adapters
│   │   │   ├── category.dart          # Category model
│   │   │   ├── tag.dart               # Tag model
│   │   │   └── note_statistics.dart   # Analytics model
│   │   ├── datasources/               # Data source implementations
│   │   │   ├── local/                 # Local storage implementations
│   │   │   │   ├── hive_notes_datasource.dart    # Hive implementation
│   │   │   │   ├── sqlite_notes_datasource.dart  # SQLite implementation
│   │   │   │   └── shared_prefs_datasource.dart  # Settings storage
│   │   │   └── remote/                # Remote data sources (for sync)
│   │   │       └── notes_remote_datasource.dart  # Remote API client
│   │   ├── repositories/              # Repository implementations
│   │   │   ├── notes_repository_impl.dart         # Notes repository
│   │   │   ├── categories_repository_impl.dart    # Categories repository
│   │   │   └── sync_repository_impl.dart          # Synchronization repository
│   │   └── services/                  # Data services
│   │       ├── sync_service.dart      # Data synchronization service
│   │       └── backup_service.dart    # Data backup and restore
│   ├── domain/                        # 🎯 Business logic
│   │   ├── entities/                  # Domain entities
│   │   ├── repositories/              # Repository interfaces
│   │   └── usecases/                  # Business use cases
│   └── presentation/                  # 🎨 UI layer
│       ├── pages/                     # App screens
│       ├── widgets/                   # Reusable widgets
│       └── providers/                 # State management
├── test/                              # 🧪 Testing
│   ├── unit/                          # Unit tests
│   │   ├── datasources/               # Data source tests
│   │   ├── repositories/              # Repository tests
│   │   └── mocks/                     # Mock implementations
│   ├── widget/                        # Widget tests
│   └── integration/                   # Integration tests
└── assets/                            # 🎨 App assets
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Project Setup & Dependencies** ⏱️ *20 minutes*

Set up the project with local storage dependencies:

```yaml
# pubspec.yaml
name: notemaster_pro
description: Professional note-taking app with dual storage backends

dependencies:
  flutter:
    sdk: flutter
  
  # Hive Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # SQLite Storage  
  sqflite: ^2.3.0
  path: ^1.8.3
  
  # Shared Preferences
  shared_preferences: ^2.2.2
  
  # State Management
  flutter_riverpod: ^2.4.5
  
  # Utilities
  uuid: ^4.1.0
  intl: ^0.18.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  equatable: ^2.0.5
  
  # File System
  path_provider: ^2.1.1
  
  # UI Components
  flutter_staggered_grid_view: ^0.7.0
  animations: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.6
  hive_generator: ^2.0.1
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  
  # Testing
  mocktail: ^1.0.0
  integration_test:
    sdk: flutter
  
  # Linting
  flutter_lints: ^3.0.1
```

### **Step 2: Core Storage Infrastructure** ⏱️ *30 minutes*

Create the foundation storage infrastructure:

```dart
// lib/core/storage/storage_type.dart
enum StorageType {
  hive,
  sqlite,
}

// lib/core/storage/storage_factory.dart
import '../constants/storage_constants.dart';
import '../../data/datasources/local/hive_notes_datasource.dart';
import '../../data/datasources/local/sqlite_notes_datasource.dart';
import '../../domain/repositories/notes_repository.dart';

class StorageFactory {
  static Future<NotesLocalDataSource> createNotesDataSource(StorageType type) async {
    switch (type) {
      case StorageType.hive:
        final dataSource = HiveNotesDataSource();
        await dataSource.init();
        return dataSource;
        
      case StorageType.sqlite:
        final dataSource = SQLiteNotesDataSource();
        await dataSource.init();
        return dataSource;
    }
  }
  
  static StorageType getStorageTypeFromPrefs() {
    // Read from SharedPreferences or return default
    return StorageType.hive; // Default to Hive
  }
  
  static Future<void> setStorageType(StorageType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageConstants.storageTypeKey, type.name);
  }
}

// lib/core/storage/hive_config.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/note.dart';
import '../../data/models/category.dart';
import '../../data/models/tag.dart';

class HiveConfig {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TagAdapter());
    }
    
    // Open boxes
    await _openBoxes();
  }
  
  static Future<void> _openBoxes() async {
    await Hive.openBox<Note>(HiveBoxes.notes);
    await Hive.openBox<Category>(HiveBoxes.categories);
    await Hive.openBox<Tag>(HiveBoxes.tags);
    await Hive.openBox<String>(HiveBoxes.settings);
    await Hive.openBox<Map<String, dynamic>>(HiveBoxes.metadata);
  }
  
  static Future<void> close() async {
    await Hive.close();
  }
  
  static Future<void> clearAll() async {
    await Hive.deleteFromDisk();
  }
  
  static Future<void> backup(String path) async {
    // Implementation for backing up Hive data
    for (final boxName in HiveBoxes.allBoxes) {
      final box = await Hive.openBox(boxName);
      // Export box data to file
      await box.close();
    }
  }
}

class HiveBoxes {
  static const String notes = 'notes';
  static const String categories = 'categories';
  static const String tags = 'tags';
  static const String settings = 'settings';
  static const String metadata = 'metadata';
  
  static const List<String> allBoxes = [
    notes,
    categories,
    tags,
    settings,
    metadata,
  ];
}

// lib/core/storage/sqlite_config.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteConfig {
  static const String _databaseName = 'notemaster.db';
  static const int _databaseVersion = 1;
  
  static Database? _database;
  
  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
      onConfigure: _configureDatabase,
    );
  }
  
  static Future<void> _configureDatabase(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
    // Enable Write-Ahead Logging for better performance
    await db.execute('PRAGMA journal_mode = WAL');
    // Increase cache size
    await db.execute('PRAGMA cache_size = 10000');
  }
  
  static Future<void> _createDatabase(Database db, int version) async {
    // Create tables
    await db.execute(SQLiteSchema.createCategoriesTable);
    await db.execute(SQLiteSchema.createNotesTable);
    await db.execute(SQLiteSchema.createTagsTable);
    await db.execute(SQLiteSchema.createNoteTagsTable);
    await db.execute(SQLiteSchema.createNotesSearchTable);
    
    // Create indexes
    for (final index in SQLiteSchema.createIndexes) {
      await db.execute(index);
    }
    
    // Create triggers
    await db.execute(SQLiteSchema.createSearchTriggers);
    
    // Insert default data
    await _insertDefaultData(db);
  }
  
  static Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration logic for version 2
      await db.execute('ALTER TABLE notes ADD COLUMN color INTEGER DEFAULT 0');
    }
    // Add more migrations as needed
  }
  
  static Future<void> _insertDefaultData(Database db) async {
    // Insert default categories
    final defaultCategories = [
      {'id': '1', 'name': 'Personal', 'color': 0xFF2196F3, 'icon': 'person'},
      {'id': '2', 'name': 'Work', 'color': 0xFF4CAF50, 'icon': 'work'},
      {'id': '3', 'name': 'Ideas', 'color': 0xFFFF9800, 'icon': 'lightbulb'},
    ];
    
    for (final category in defaultCategories) {
      await db.insert('categories', {
        ...category,
        'description': '',
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'sort_order': 0,
      });
    }
  }
  
  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
  
  static Future<void> deleteDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}

class SQLiteSchema {
  static const String createCategoriesTable = '''
    CREATE TABLE categories (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      description TEXT,
      color INTEGER NOT NULL,
      icon TEXT NOT NULL,
      created_at INTEGER NOT NULL,
      sort_order INTEGER NOT NULL DEFAULT 0
    );
  ''';
  
  static const String createNotesTable = '''
    CREATE TABLE notes (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      category_id TEXT NOT NULL,
      is_archived INTEGER NOT NULL DEFAULT 0,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      priority INTEGER NOT NULL DEFAULT 1,
      color INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
    );
  ''';
  
  static const String createTagsTable = '''
    CREATE TABLE tags (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      color INTEGER DEFAULT 0,
      created_at INTEGER NOT NULL
    );
  ''';
  
  static const String createNoteTagsTable = '''
    CREATE TABLE note_tags (
      note_id TEXT NOT NULL,
      tag_id TEXT NOT NULL,
      PRIMARY KEY (note_id, tag_id),
      FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE,
      FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE
    );
  ''';
  
  static const String createNotesSearchTable = '''
    CREATE VIRTUAL TABLE notes_search USING fts5(
      id UNINDEXED,
      title,
      content,
      tokenize = 'porter'
    );
  ''';
  
  static const List<String> createIndexes = [
    'CREATE INDEX idx_notes_category ON notes(category_id);',
    'CREATE INDEX idx_notes_created_at ON notes(created_at DESC);',
    'CREATE INDEX idx_notes_updated_at ON notes(updated_at DESC);',
    'CREATE INDEX idx_notes_priority ON notes(priority);',
    'CREATE INDEX idx_notes_archived ON notes(is_archived);',
    'CREATE INDEX idx_notes_favorite ON notes(is_favorite);',
    'CREATE INDEX idx_categories_sort_order ON categories(sort_order);',
    'CREATE INDEX idx_note_tags_note ON note_tags(note_id);',
    'CREATE INDEX idx_note_tags_tag ON note_tags(tag_id);',
  ];
  
  static const String createSearchTriggers = '''
    CREATE TRIGGER notes_search_insert AFTER INSERT ON notes BEGIN
      INSERT INTO notes_search(id, title, content) 
      VALUES (new.id, new.title, new.content);
    END;
    
    CREATE TRIGGER notes_search_update AFTER UPDATE ON notes BEGIN
      UPDATE notes_search SET title = new.title, content = new.content 
      WHERE id = new.id;
    END;
    
    CREATE TRIGGER notes_search_delete AFTER DELETE ON notes BEGIN
      DELETE FROM notes_search WHERE id = old.id;
    END;
  ''';
}
```

### **Step 3: Data Models with Dual Storage Support** ⏱️ *35 minutes*

Create comprehensive data models that work with both storage systems:

```dart
// lib/data/models/note.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'category.dart';
import 'tag.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
@HiveType(typeId: 0)
class Note extends HiveObject with _$Note {
  const factory Note({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String content,
    @HiveField(3) required DateTime createdAt,
    @HiveField(4) required DateTime updatedAt,
    @HiveField(5) required Category category,
    @HiveField(6) @Default([]) List<Tag> tags,
    @HiveField(7) @Default(false) bool isArchived,
    @HiveField(8) @Default(false) bool isFavorite,
    @HiveField(9) @Default(1) int priority, // 1-5 scale
    @HiveField(10) @Default(0) int color, // Color as int
    @HiveField(11) String? attachmentPath,
    @HiveField(12) @Default(0) int readTime, // Estimated read time in seconds
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  
  // SQLite conversion methods
  Map<String, dynamic> toSQLiteMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'category_id': category.id,
      'is_archived': isArchived ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'priority': priority,
      'color': color,
    };
  }
  
  static Note fromSQLiteMap(Map<String, dynamic> map, Category category, List<Tag> tags) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
      category: category,
      tags: tags,
      isArchived: map['is_archived'] == 1,
      isFavorite: map['is_favorite'] == 1,
      priority: map['priority'],
      color: map['color'] ?? 0,
    );
  }
  
  // Utility methods
  bool matchesQuery(String query) {
    final lowercaseQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowercaseQuery) ||
           content.toLowerCase().contains(lowercaseQuery) ||
           tags.any((tag) => tag.name.toLowerCase().contains(lowercaseQuery));
  }
  
  int estimateReadTime() {
    // Estimate reading time based on content length
    const wordsPerMinute = 200;
    final wordCount = content.split(' ').length;
    return (wordCount / wordsPerMinute * 60).round(); // Return seconds
  }
  
  Note copyWithUpdatedTime() {
    return copyWith(updatedAt: DateTime.now());
  }
}

// lib/data/models/category.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
@HiveType(typeId: 1)
class Category extends HiveObject with _$Category {
  const factory Category({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String description,
    @HiveField(3) required int color,
    @HiveField(4) required String icon,
    @HiveField(5) required DateTime createdAt,
    @HiveField(6) @Default(0) int sortOrder,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  
  Map<String, dynamic> toSQLiteMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
      'created_at': createdAt.millisecondsSinceEpoch,
      'sort_order': sortOrder,
    };
  }
  
  static Category fromSQLiteMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      color: map['color'],
      icon: map['icon'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      sortOrder: map['sort_order'] ?? 0,
    );
  }
}

// lib/data/models/tag.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@freezed
@HiveType(typeId: 2)
class Tag extends HiveObject with _$Tag {
  const factory Tag({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) @Default(0) int color,
    @HiveField(3) required DateTime createdAt,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  
  Map<String, dynamic> toSQLiteMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
  
  static Tag fromSQLiteMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
      color: map['color'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

// lib/data/models/note_statistics.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_statistics.freezed.dart';
part 'note_statistics.g.dart';

@freezed
class NoteStatistics with _$NoteStatistics {
  const factory NoteStatistics({
    required int totalNotes,
    required int archivedNotes,
    required int favoriteNotes,
    required int totalCategories,
    required int totalTags,
    required Map<String, int> notesByCategory,
    required Map<String, int> notesByPriority,
    required Map<String, int> notesByTag,
    required double averageContentLength,
    required int totalReadTime,
    required DateTime lastUpdated,
  }) = _NoteStatistics;

  factory NoteStatistics.fromJson(Map<String, dynamic> json) => 
      _$NoteStatisticsFromJson(json);
      
  factory NoteStatistics.empty() {
    return NoteStatistics(
      totalNotes: 0,
      archivedNotes: 0,
      favoriteNotes: 0,
      totalCategories: 0,
      totalTags: 0,
      notesByCategory: {},
      notesByPriority: {},
      notesByTag: {},
      averageContentLength: 0.0,
      totalReadTime: 0,
      lastUpdated: DateTime.now(),
    );
  }
}

// lib/data/models/search_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'note.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required Note note,
    required double relevanceScore,
    required List<String> matchedTerms,
    required Map<String, List<int>> highlightPositions,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) => 
      _$SearchResultFromJson(json);
}
```

### **Step 4: Local Data Sources Implementation** ⏱️ *50 minutes*

Implement both Hive and SQLite data sources with comprehensive functionality:

```dart
// lib/data/datasources/local/notes_local_datasource.dart
import '../../models/note.dart';
import '../../models/category.dart';
import '../../models/tag.dart';
import '../../models/note_statistics.dart';
import '../../models/search_result.dart';

abstract class NotesLocalDataSource {
  // Note CRUD Operations
  Future<void> insertNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
  Future<Note?> getNoteById(String id);
  
  // Query Operations
  Future<List<Note>> getAllNotes({
    String? categoryId,
    bool? isArchived,
    bool? isFavorite,
    List<String>? tags,
    String? searchQuery,
    NoteSortOption sortBy = NoteSortOption.updatedAt,
    bool ascending = false,
    int? limit,
    int? offset,
  });
  
  // Full-text Search
  Future<List<SearchResult>> searchNotes(String query, {int? limit});
  
  // Category Operations
  Future<void> insertCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<List<Category>> getAllCategories();
  
  // Tag Operations
  Future<void> insertTag(Tag tag);
  Future<void> updateTag(Tag tag);
  Future<void> deleteTag(String id);
  Future<List<Tag>> getAllTags();
  Future<List<Tag>> getTagsForNote(String noteId);
  Future<void> linkNoteToTags(String noteId, List<String> tagIds);
  
  // Batch Operations
  Future<void> bulkInsertNotes(List<Note> notes);
  Future<void> bulkUpdateNotes(List<Note> notes);
  Future<void> bulkDeleteNotes(List<String> ids);
  
  // Analytics
  Future<NoteStatistics> getStatistics();
  
  // Reactive Streams
  Stream<List<Note>> watchNotes({
    String? categoryId,
    bool? isArchived,
  });
  
  // Database Management
  Future<void> clearAll();
  Future<void> backup(String path);
  Future<void> restore(String path);
  Future<Map<String, dynamic>> getDatabaseInfo();
}

enum NoteSortOption {
  title,
  createdAt,
  updatedAt,
  priority,
  category,
  readTime,
}

// lib/data/datasources/local/hive_notes_datasource.dart
import 'dart:async';
import 'package:hive/hive.dart';
import '../../../core/utils/uuid_generator.dart';
import 'notes_local_datasource.dart';

class HiveNotesDataSource implements NotesLocalDataSource {
  late Box<Note> _notesBox;
  late Box<Category> _categoriesBox;
  late Box<Tag> _tagsBox;
  late Box<Map<String, dynamic>> _metadataBox;
  
  final StreamController<List<Note>> _notesController = 
      StreamController<List<Note>>.broadcast();

  Future<void> init() async {
    _notesBox = await Hive.openBox<Note>('notes');
    _categoriesBox = await Hive.openBox<Category>('categories');
    _tagsBox = await Hive.openBox<Tag>('tags');
    _metadataBox = await Hive.openBox<Map<String, dynamic>>('metadata');
    
    // Setup listeners for reactive streams
    _notesBox.listenable().addListener(_notifyNotesChanged);
    
    // Initialize default categories if empty
    if (_categoriesBox.isEmpty) {
      await _initializeDefaultCategories();
    }
  }

  void _notifyNotesChanged() {
    _notesController.add(_notesBox.values.toList());
  }

  @override
  Future<void> insertNote(Note note) async {
    await _notesBox.put(note.id, note);
    await _updateMetadata('lastNoteCreated', DateTime.now().toIso8601String());
  }

  @override
  Future<void> updateNote(Note note) async {
    await _notesBox.put(note.id, note);
    await _updateMetadata('lastNoteUpdated', DateTime.now().toIso8601String());
  }

  @override
  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
    await _updateMetadata('lastNoteDeleted', DateTime.now().toIso8601String());
  }

  @override
  Future<Note?> getNoteById(String id) async {
    return _notesBox.get(id);
  }

  @override
  Future<List<Note>> getAllNotes({
    String? categoryId,
    bool? isArchived,
    bool? isFavorite,
    List<String>? tags,
    String? searchQuery,
    NoteSortOption sortBy = NoteSortOption.updatedAt,
    bool ascending = false,
    int? limit,
    int? offset,
  }) async {
    var notes = _notesBox.values.where((note) {
      // Category filter
      if (categoryId != null && note.category.id != categoryId) {
        return false;
      }
      
      // Archive filter
      if (isArchived != null && note.isArchived != isArchived) {
        return false;
      }
      
      // Favorite filter
      if (isFavorite != null && note.isFavorite != isFavorite) {
        return false;
      }
      
      // Tags filter
      if (tags != null && tags.isNotEmpty) {
        final noteTagIds = note.tags.map((t) => t.id).toSet();
        if (!tags.any((tagId) => noteTagIds.contains(tagId))) {
          return false;
        }
      }
      
      // Search query filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        if (!note.matchesQuery(searchQuery)) {
          return false;
        }
      }
      
      return true;
    }).toList();

    // Apply sorting
    notes.sort((a, b) {
      int comparison;
      switch (sortBy) {
        case NoteSortOption.title:
          comparison = a.title.compareTo(b.title);
          break;
        case NoteSortOption.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case NoteSortOption.updatedAt:
          comparison = a.updatedAt.compareTo(b.updatedAt);
          break;
        case NoteSortOption.priority:
          comparison = a.priority.compareTo(b.priority);
          break;
        case NoteSortOption.category:
          comparison = a.category.name.compareTo(b.category.name);
          break;
        case NoteSortOption.readTime:
          comparison = a.readTime.compareTo(b.readTime);
          break;
      }
      return ascending ? comparison : -comparison;
    });

    // Apply pagination
    if (offset != null) {
      notes = notes.skip(offset).toList();
    }
    if (limit != null) {
      notes = notes.take(limit).toList();
    }

    return notes;
  }

  @override
  Future<List<SearchResult>> searchNotes(String query, {int? limit}) async {
    final searchTerms = query.toLowerCase().split(' ');
    final results = <SearchResult>[];
    
    for (final note in _notesBox.values) {
      final titleLower = note.title.toLowerCase();
      final contentLower = note.content.toLowerCase();
      
      double relevanceScore = 0;
      List<String> matchedTerms = [];
      Map<String, List<int>> highlightPositions = {};
      
      for (final term in searchTerms) {
        // Title matches (higher weight)
        if (titleLower.contains(term)) {
          relevanceScore += 3.0;
          matchedTerms.add(term);
          
          final positions = <int>[];
          int index = titleLower.indexOf(term);
          while (index != -1) {
            positions.add(index);
            index = titleLower.indexOf(term, index + 1);
          }
          highlightPositions['title'] = positions;
        }
        
        // Content matches
        if (contentLower.contains(term)) {
          relevanceScore += 1.0;
          if (!matchedTerms.contains(term)) {
            matchedTerms.add(term);
          }
          
          final positions = <int>[];
          int index = contentLower.indexOf(term);
          while (index != -1) {
            positions.add(index);
            index = contentLower.indexOf(term, index + 1);
          }
          highlightPositions['content'] = positions;
        }
        
        // Tag matches
        for (final tag in note.tags) {
          if (tag.name.toLowerCase().contains(term)) {
            relevanceScore += 2.0;
            if (!matchedTerms.contains(term)) {
              matchedTerms.add(term);
            }
          }
        }
      }
      
      if (relevanceScore > 0) {
        results.add(SearchResult(
          note: note,
          relevanceScore: relevanceScore,
          matchedTerms: matchedTerms,
          highlightPositions: highlightPositions,
        ));
      }
    }
    
    // Sort by relevance score
    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    return limit != null ? results.take(limit).toList() : results;
  }

  @override
  Future<void> insertCategory(Category category) async {
    await _categoriesBox.put(category.id, category);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final categories = _categoriesBox.values.toList();
    categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return categories;
  }

  @override
  Future<NoteStatistics> getStatistics() async {
    final notes = _notesBox.values.toList();
    final categories = _categoriesBox.values.toList();
    final tags = _tagsBox.values.toList();
    
    final notesByCategory = <String, int>{};
    final notesByPriority = <String, int>{};
    final notesByTag = <String, int>{};
    
    for (final category in categories) {
      notesByCategory[category.name] = 
          notes.where((n) => n.category.id == category.id).length;
    }
    
    for (int i = 1; i <= 5; i++) {
      notesByPriority['priority$i'] = 
          notes.where((n) => n.priority == i).length;
    }
    
    for (final tag in tags) {
      notesByTag[tag.name] = notes
          .where((n) => n.tags.any((t) => t.id == tag.id))
          .length;
    }
    
    final totalContentLength = notes.fold<int>(
      0, 
      (sum, note) => sum + note.content.length,
    );
    
    final totalReadTime = notes.fold<int>(
      0,
      (sum, note) => sum + note.readTime,
    );
    
    return NoteStatistics(
      totalNotes: notes.length,
      archivedNotes: notes.where((n) => n.isArchived).length,
      favoriteNotes: notes.where((n) => n.isFavorite).length,
      totalCategories: categories.length,
      totalTags: tags.length,
      notesByCategory: notesByCategory,
      notesByPriority: notesByPriority,
      notesByTag: notesByTag,
      averageContentLength: notes.isEmpty 
          ? 0.0 
          : totalContentLength / notes.length,
      totalReadTime: totalReadTime,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Stream<List<Note>> watchNotes({
    String? categoryId,
    bool? isArchived,
  }) {
    return _notesController.stream.map((notes) {
      return notes.where((note) {
        if (categoryId != null && note.category.id != categoryId) {
          return false;
        }
        if (isArchived != null && note.isArchived != isArchived) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Future<void> bulkInsertNotes(List<Note> notes) async {
    final Map<String, Note> noteMap = {
      for (Note note in notes) note.id: note
    };
    await _notesBox.putAll(noteMap);
  }

  Future<void> _initializeDefaultCategories() async {
    final defaultCategories = [
      Category(
        id: UUIDGenerator.generate(),
        name: 'Personal',
        description: 'Personal notes and thoughts',
        color: 0xFF2196F3,
        icon: 'person',
        createdAt: DateTime.now(),
        sortOrder: 1,
      ),
      Category(
        id: UUIDGenerator.generate(),
        name: 'Work',
        description: 'Work-related notes and tasks',
        color: 0xFF4CAF50,
        icon: 'work',
        createdAt: DateTime.now(),
        sortOrder: 2,
      ),
      Category(
        id: UUIDGenerator.generate(),
        name: 'Ideas',
        description: 'Creative ideas and inspiration',
        color: 0xFFFF9800,
        icon: 'lightbulb_outline',
        createdAt: DateTime.now(),
        sortOrder: 3,
      ),
    ];
    
    for (final category in defaultCategories) {
      await insertCategory(category);
    }
  }

  Future<void> _updateMetadata(String key, String value) async {
    final metadata = _metadataBox.get('app_metadata') ?? <String, dynamic>{};
    metadata[key] = value;
    await _metadataBox.put('app_metadata', metadata);
  }

  @override
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final notesCount = _notesBox.length;
    final categoriesCount = _categoriesBox.length;
    final tagsCount = _tagsBox.length;
    
    final metadata = _metadataBox.get('app_metadata') ?? <String, dynamic>{};
    
    return {
      'storage_type': 'Hive',
      'notes_count': notesCount,
      'categories_count': categoriesCount,
      'tags_count': tagsCount,
      'database_size': 'N/A', // Hive doesn't provide easy size calculation
      'metadata': metadata,
    };
  }

  @override
  Future<void> clearAll() async {
    await _notesBox.clear();
    await _categoriesBox.clear();
    await _tagsBox.clear();
    await _metadataBox.clear();
  }

  // Implement other required methods...
  @override
  Future<void> updateCategory(Category category) async {
    await _categoriesBox.put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categoriesBox.delete(id);
  }

  @override
  Future<void> insertTag(Tag tag) async {
    await _tagsBox.put(tag.id, tag);
  }

  @override
  Future<void> updateTag(Tag tag) async {
    await _tagsBox.put(tag.id, tag);
  }

  @override
  Future<void> deleteTag(String id) async {
    await _tagsBox.delete(id);
  }

  @override
  Future<List<Tag>> getAllTags() async {
    return _tagsBox.values.toList();
  }

  @override
  Future<List<Tag>> getTagsForNote(String noteId) async {
    final note = await getNoteById(noteId);
    return note?.tags ?? [];
  }

  @override
  Future<void> linkNoteToTags(String noteId, List<String> tagIds) async {
    final note = await getNoteById(noteId);
    if (note != null) {
      final tags = tagIds
          .map((id) => _tagsBox.get(id))
          .where((tag) => tag != null)
          .cast<Tag>()
          .toList();
      
      final updatedNote = note.copyWith(tags: tags);
      await updateNote(updatedNote);
    }
  }

  @override
  Future<void> bulkUpdateNotes(List<Note> notes) async {
    final Map<String, Note> noteMap = {
      for (Note note in notes) note.id: note
    };
    await _notesBox.putAll(noteMap);
  }

  @override
  Future<void> bulkDeleteNotes(List<String> ids) async {
    await _notesBox.deleteAll(ids);
  }

  @override
  Future<void> backup(String path) async {
    // Implementation for Hive backup
    // This would involve exporting all box data to files
  }

  @override
  Future<void> restore(String path) async {
    // Implementation for Hive restore
    // This would involve importing data from backup files
  }
}
```

*This is part 1 of the workshop. Continue with SQLite implementation, repository pattern, UI components, and testing...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_17

# Install dependencies
flutter pub get

# Generate code for models
flutter packages pub run build_runner build

# Run the app
flutter run

# Test both storage backends
# 1. Create notes with categories and tags
# 2. Test search functionality
# 3. Compare performance between Hive and SQLite
# 4. Test offline functionality and data persistence
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Dual Storage Implementation** - Expert use of both Hive and SQLite with performance comparison
- **Clean Architecture** - Repository pattern with proper separation of concerns
- **Advanced Data Operations** - Complex querying, full-text search, and analytics
- **Offline-First Design** - Robust data persistence and synchronization strategies
- **Performance Optimization** - Efficient data operations and memory management
- **Testing Excellence** - Comprehensive test coverage for local storage operations

**Ready to build data-rich applications that work seamlessly offline with professional storage patterns! 💾✨**