import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/storage_constants.dart';
import '../../data/models/note.dart';
import '../../data/models/category.dart';
import '../../data/models/tag.dart';

class HiveConfig {
  static bool _initialized = false;
  
  // Box references for performance
  static Box<Note>? _notesBox;
  static Box<Category>? _categoriesBox;
  static Box<Tag>? _tagsBox;
  static Box? _settingsBox;
  static Box? _analyticsBox;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    _registerAdapters();

    // Open boxes
    await _openBoxes();

    // Initialize default data
    await _initializeDefaultData();

    _initialized = true;
  }

  static void _registerAdapters() {
    // Register model adapters
    if (!Hive.isAdapterRegistered(StorageConstants.noteTypeId)) {
      Hive.registerAdapter(NoteAdapter());
    }
    
    if (!Hive.isAdapterRegistered(StorageConstants.categoryTypeId)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    
    if (!Hive.isAdapterRegistered(StorageConstants.tagTypeId)) {
      Hive.registerAdapter(TagAdapter());
    }

    // Register enum adapters
    if (!Hive.isAdapterRegistered(StorageConstants.noteTypeId + 10)) {
      Hive.registerAdapter(NotePriorityAdapter());
    }
    
    if (!Hive.isAdapterRegistered(StorageConstants.noteTypeId + 11)) {
      Hive.registerAdapter(SyncStatusAdapter());
    }
  }

  static Future<void> _openBoxes() async {
    // Open typed boxes
    _notesBox = await Hive.openBox<Note>(StorageConstants.hiveNotesBox);
    _categoriesBox = await Hive.openBox<Category>(StorageConstants.hiveCategoriesBox);
    _tagsBox = await Hive.openBox<Tag>(StorageConstants.hiveTagsBox);
    
    // Open untyped boxes for settings and analytics
    _settingsBox = await Hive.openBox(StorageConstants.hiveSettingsBox);
    _analyticsBox = await Hive.openBox(StorageConstants.hiveAnalyticsBox);
  }

  static Future<void> _initializeDefaultData() async {
    // Create default category if it doesn't exist
    final categoriesBox = getCategoriesBox();
    if (categoriesBox.isEmpty) {
      final defaultCategory = Category.defaultCategory();
      await categoriesBox.put(defaultCategory.id, defaultCategory);
    }
  }

  // Box getters with null checks
  static Box<Note> getNotesBox() {
    if (_notesBox == null) {
      throw Exception(StorageConstants.errorStorageNotInitialized);
    }
    return _notesBox!;
  }

  static Box<Category> getCategoriesBox() {
    if (_categoriesBox == null) {
      throw Exception(StorageConstants.errorStorageNotInitialized);
    }
    return _categoriesBox!;
  }

  static Box<Tag> getTagsBox() {
    if (_tagsBox == null) {
      throw Exception(StorageConstants.errorStorageNotInitialized);
    }
    return _tagsBox!;
  }

  static Box getSettingsBox() {
    if (_settingsBox == null) {
      throw Exception(StorageConstants.errorStorageNotInitialized);
    }
    return _settingsBox!;
  }

  static Box getAnalyticsBox() {
    if (_analyticsBox == null) {
      throw Exception(StorageConstants.errorStorageNotInitialized);
    }
    return _analyticsBox!;
  }

  // Utility methods
  static Future<void> clearAllData() async {
    await getNotesBox().clear();
    await getCategoriesBox().clear();
    await getTagsBox().clear();
    await getAnalyticsBox().clear();
    
    // Reinitialize default data
    await _initializeDefaultData();
  }

  static Future<void> compactBoxes() async {
    await getNotesBox().compact();
    await getCategoriesBox().compact();
    await getTagsBox().compact();
    await getSettingsBox().compact();
    await getAnalyticsBox().compact();
  }

  static Future<void> closeBoxes() async {
    await _notesBox?.close();
    await _categoriesBox?.close();
    await _tagsBox?.close();
    await _settingsBox?.close();
    await _analyticsBox?.close();
    
    _notesBox = null;
    _categoriesBox = null;
    _tagsBox = null;
    _settingsBox = null;
    _analyticsBox = null;
    
    _initialized = false;
  }

  // Performance monitoring
  static Map<String, dynamic> getPerformanceStats() {
    return {
      'notes_count': getNotesBox().length,
      'categories_count': getCategoriesBox().length,
      'tags_count': getTagsBox().length,
      'notes_box_size': getNotesBox().toMap().toString().length,
      'categories_box_size': getCategoriesBox().toMap().toString().length,
      'tags_box_size': getTagsBox().toMap().toString().length,
      'is_initialized': _initialized,
    };
  }

  // Backup and restore
  static Future<Map<String, dynamic>> exportData() async {
    return {
      'notes': getNotesBox().toMap(),
      'categories': getCategoriesBox().toMap(),
      'tags': getTagsBox().toMap(),
      'settings': getSettingsBox().toMap(),
      'export_timestamp': DateTime.now().toIso8601String(),
      'export_version': '1.0',
    };
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    // Clear existing data
    await clearAllData();

    // Import notes
    if (data['notes'] != null) {
      final notesData = Map<String, Note>.from(data['notes']);
      await getNotesBox().putAll(notesData);
    }

    // Import categories
    if (data['categories'] != null) {
      final categoriesData = Map<String, Category>.from(data['categories']);
      await getCategoriesBox().putAll(categoriesData);
    }

    // Import tags
    if (data['tags'] != null) {
      final tagsData = Map<String, Tag>.from(data['tags']);
      await getTagsBox().putAll(tagsData);
    }

    // Import settings
    if (data['settings'] != null) {
      final settingsData = Map<String, dynamic>.from(data['settings']);
      await getSettingsBox().putAll(settingsData);
    }
  }

  // Search functionality
  static List<Note> searchNotes(String query) {
    if (query.trim().isEmpty) return [];
    
    final notesBox = getNotesBox();
    final searchQuery = query.toLowerCase().trim();
    
    return notesBox.values.where((note) {
      return note.title.toLowerCase().contains(searchQuery) ||
             note.content.toLowerCase().contains(searchQuery);
    }).toList();
  }

  // Filtering methods
  static List<Note> getNotesFiltered({
    String? categoryId,
    List<String>? tagIds,
    bool? isFavorite,
    bool? isArchived,
    NotePriority? priority,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) {
    final notesBox = getNotesBox();
    
    return notesBox.values.where((note) {
      // Category filter
      if (categoryId != null && note.categoryId != categoryId) {
        return false;
      }
      
      // Tags filter (note must have all specified tags)
      if (tagIds != null && tagIds.isNotEmpty) {
        if (!tagIds.every((tagId) => note.tagIds.contains(tagId))) {
          return false;
        }
      }
      
      // Favorite filter
      if (isFavorite != null && note.isFavorite != isFavorite) {
        return false;
      }
      
      // Archive filter
      if (isArchived != null && note.isArchived != isArchived) {
        return false;
      }
      
      // Priority filter
      if (priority != null && note.priority != priority) {
        return false;
      }
      
      // Date range filters
      if (createdAfter != null && note.createdAt.isBefore(createdAfter)) {
        return false;
      }
      
      if (createdBefore != null && note.createdAt.isAfter(createdBefore)) {
        return false;
      }
      
      return true;
    }).toList();
  }

  // Analytics helpers
  static void recordEvent(String event, Map<String, dynamic> properties) {
    final analyticsBox = getAnalyticsBox();
    final eventData = {
      'event': event,
      'properties': properties,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    analyticsBox.add(eventData);
    
    // Keep only last 1000 events for performance
    if (analyticsBox.length > 1000) {
      analyticsBox.deleteAt(0);
    }
  }

  static bool get isInitialized => _initialized;
}