class StorageConstants {
  // Hive Configuration
  static const String hiveNotesBox = 'notes_box';
  static const String hiveCategoriesBox = 'categories_box';
  static const String hiveTagsBox = 'tags_box';
  static const String hiveSettingsBox = 'settings_box';
  static const String hiveAnalyticsBox = 'analytics_box';
  
  // Hive Type IDs
  static const int noteTypeId = 0;
  static const int categoryTypeId = 1;
  static const int tagTypeId = 2;
  static const int settingsTypeId = 3;
  static const int analyticsTypeId = 4;
  
  // SQLite Configuration
  static const String sqliteDbName = 'notemaster.db';
  static const int sqliteDbVersion = 1;
  
  // Table Names
  static const String notesTable = 'notes';
  static const String categoriesTable = 'categories';
  static const String tagsTable = 'tags';
  static const String noteTagsTable = 'note_tags';
  static const String settingsTable = 'settings';
  static const String analyticsTable = 'analytics';
  
  // Column Names - Notes
  static const String noteIdColumn = 'id';
  static const String noteTitleColumn = 'title';
  static const String noteContentColumn = 'content';
  static const String noteCategoryIdColumn = 'category_id';
  static const String noteCreatedAtColumn = 'created_at';
  static const String noteUpdatedAtColumn = 'updated_at';
  static const String noteIsFavoriteColumn = 'is_favorite';
  static const String noteIsArchivedColumn = 'is_archived';
  static const String noteColorColumn = 'color';
  static const String notePriorityColumn = 'priority';
  static const String noteRemindAtColumn = 'remind_at';
  static const String noteEncryptedColumn = 'encrypted';
  static const String noteSyncStatusColumn = 'sync_status';
  static const String noteLastSyncedColumn = 'last_synced';
  
  // Column Names - Categories
  static const String categoryIdColumn = 'id';
  static const String categoryNameColumn = 'name';
  static const String categoryDescriptionColumn = 'description';
  static const String categoryColorColumn = 'color';
  static const String categoryIconColumn = 'icon';
  static const String categoryCreatedAtColumn = 'created_at';
  static const String categoryOrderColumn = 'order_index';
  
  // Column Names - Tags
  static const String tagIdColumn = 'id';
  static const String tagNameColumn = 'name';
  static const String tagColorColumn = 'color';
  static const String tagUsageCountColumn = 'usage_count';
  static const String tagCreatedAtColumn = 'created_at';
  
  // Column Names - Note Tags (Junction Table)
  static const String noteTagNoteIdColumn = 'note_id';
  static const String noteTagTagIdColumn = 'tag_id';
  
  // SQL Queries
  static const String createNotesTable = '''
    CREATE TABLE $notesTable (
      $noteIdColumn TEXT PRIMARY KEY,
      $noteTitleColumn TEXT NOT NULL,
      $noteContentColumn TEXT,
      $noteCategoryIdColumn TEXT,
      $noteCreatedAtColumn INTEGER NOT NULL,
      $noteUpdatedAtColumn INTEGER NOT NULL,
      $noteIsFavoriteColumn INTEGER DEFAULT 0,
      $noteIsArchivedColumn INTEGER DEFAULT 0,
      $noteColorColumn TEXT,
      $notePriorityColumn INTEGER DEFAULT 0,
      $noteRemindAtColumn INTEGER,
      $noteEncryptedColumn INTEGER DEFAULT 0,
      $noteSyncStatusColumn INTEGER DEFAULT 0,
      $noteLastSyncedColumn INTEGER,
      FOREIGN KEY ($noteCategoryIdColumn) REFERENCES $categoriesTable ($categoryIdColumn)
    )
  ''';
  
  static const String createCategoriesTable = '''
    CREATE TABLE $categoriesTable (
      $categoryIdColumn TEXT PRIMARY KEY,
      $categoryNameColumn TEXT NOT NULL UNIQUE,
      $categoryDescriptionColumn TEXT,
      $categoryColorColumn TEXT,
      $categoryIconColumn TEXT,
      $categoryCreatedAtColumn INTEGER NOT NULL,
      $categoryOrderColumn INTEGER DEFAULT 0
    )
  ''';
  
  static const String createTagsTable = '''
    CREATE TABLE $tagsTable (
      $tagIdColumn TEXT PRIMARY KEY,
      $tagNameColumn TEXT NOT NULL UNIQUE,
      $tagColorColumn TEXT,
      $tagUsageCountColumn INTEGER DEFAULT 0,
      $tagCreatedAtColumn INTEGER NOT NULL
    )
  ''';
  
  static const String createNoteTagsTable = '''
    CREATE TABLE $noteTagsTable (
      $noteTagNoteIdColumn TEXT,
      $noteTagTagIdColumn TEXT,
      PRIMARY KEY ($noteTagNoteIdColumn, $noteTagTagIdColumn),
      FOREIGN KEY ($noteTagNoteIdColumn) REFERENCES $notesTable ($noteIdColumn) ON DELETE CASCADE,
      FOREIGN KEY ($noteTagTagIdColumn) REFERENCES $tagsTable ($tagIdColumn) ON DELETE CASCADE
    )
  ''';
  
  // Indexes for performance
  static const String createNotesIndexes = '''
    CREATE INDEX idx_notes_category ON $notesTable ($noteCategoryIdColumn);
    CREATE INDEX idx_notes_created_at ON $notesTable ($noteCreatedAtColumn);
    CREATE INDEX idx_notes_updated_at ON $notesTable ($noteUpdatedAtColumn);
    CREATE INDEX idx_notes_favorite ON $notesTable ($noteIsFavoriteColumn);
    CREATE INDEX idx_notes_archived ON $notesTable ($noteIsArchivedColumn);
    CREATE INDEX idx_notes_priority ON $notesTable ($notePriorityColumn);
    CREATE INDEX idx_notes_sync_status ON $notesTable ($noteSyncStatusColumn);
    CREATE INDEX idx_notes_title_content ON $notesTable ($noteTitleColumn, $noteContentColumn);
  ''';
  
  // Full-Text Search (if supported)
  static const String createNotesSearchTable = '''
    CREATE VIRTUAL TABLE notes_search USING fts5(
      title, content, content=$notesTable, content_rowid=$noteIdColumn
    )
  ''';
  
  // Storage Type Selection
  static const String storageTypeKey = 'selected_storage_type';
  static const String defaultStorageType = 'hive';
  
  // Performance Settings
  static const int batchSize = 100;
  static const int maxCacheSize = 1000;
  static const Duration cacheExpiration = Duration(minutes: 30);
  
  // Sync Configuration
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxSyncRetries = 3;
  static const Duration syncTimeout = Duration(seconds: 30);
  
  // Backup Configuration
  static const String backupFileExtension = '.nbk';
  static const String exportFileExtension = '.json';
  static const int maxBackupFiles = 5;
  
  // Analytics Events
  static const String eventNoteCreated = 'note_created';
  static const String eventNoteUpdated = 'note_updated';
  static const String eventNoteDeleted = 'note_deleted';
  static const String eventCategoryCreated = 'category_created';
  static const String eventSearchPerformed = 'search_performed';
  static const String eventSyncCompleted = 'sync_completed';
  static const String eventBackupCreated = 'backup_created';
  
  // Error Messages
  static const String errorStorageNotInitialized = 'Storage not initialized';
  static const String errorNoteNotFound = 'Note not found';
  static const String errorCategoryNotFound = 'Category not found';
  static const String errorTagNotFound = 'Tag not found';
  static const String errorDuplicateCategory = 'Category already exists';
  static const String errorDuplicateTag = 'Tag already exists';
  static const String errorInvalidData = 'Invalid data provided';
  static const String errorSyncFailed = 'Synchronization failed';
  static const String errorBackupFailed = 'Backup operation failed';
  
  // Default Values
  static const String defaultCategoryId = 'default';
  static const String defaultCategoryName = 'General';
  static const String defaultNoteTitle = 'Untitled Note';
  static const String defaultNoteColor = '#FFFFFF';
  static const String defaultCategoryColor = '#2196F3';
  static const String defaultTagColor = '#FF9800';
}