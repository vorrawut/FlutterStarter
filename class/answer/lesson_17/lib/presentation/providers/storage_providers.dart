import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/storage_constants.dart';
import '../../data/datasources/local/hive_notes_datasource.dart';
import '../../data/datasources/local/sqlite_notes_datasource.dart';

// Current storage type provider
class StorageTypeNotifier extends StateNotifier<String> {
  StorageTypeNotifier() : super(StorageConstants.defaultStorageType) {
    _loadStorageType();
  }

  Future<void> _loadStorageType() async {
    final prefs = await SharedPreferences.getInstance();
    final storageType = prefs.getString(StorageConstants.storageTypeKey) ?? 
                       StorageConstants.defaultStorageType;
    state = storageType;
  }

  Future<void> switchStorage(String newType) async {
    if (state == newType) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageConstants.storageTypeKey, newType);
    
    // Clear data from both storage systems to ensure clean switch
    final hiveDataSource = HiveNotesDataSource();
    final sqliteDataSource = SQLiteNotesDataSource();
    
    await hiveDataSource.clearAllData();
    await sqliteDataSource.clearAllData();
    
    state = newType;
  }
}

final currentStorageTypeProvider = StateNotifierProvider<StorageTypeNotifier, String>((ref) {
  return StorageTypeNotifier();
});

// Data source providers based on current storage type
final currentDataSourceProvider = Provider<NotesLocalDataSource>((ref) {
  final storageType = ref.watch(currentStorageTypeProvider);
  
  switch (storageType) {
    case 'hive':
      return HiveNotesDataSource();
    case 'sqlite':
      return SQLiteNotesDataSource();
    default:
      return HiveNotesDataSource();
  }
});

// Statistics providers for comparison
final hiveStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final hiveDataSource = HiveNotesDataSource();
  return await hiveDataSource.getStatistics();
});

final sqliteStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final sqliteDataSource = SQLiteNotesDataSource();
  return await sqliteDataSource.getStatistics();
});

// Current storage statistics
final currentStorageStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dataSource = ref.watch(currentDataSourceProvider);
  return await dataSource.getStatistics();
});

// Storage performance metrics
final storagePerformanceProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final hiveStats = await ref.read(hiveStatsProvider.future);
  final sqliteStats = await ref.read(sqliteStatsProvider.future);
  
  return {
    'hive': hiveStats['performance_stats'] ?? {},
    'sqlite': sqliteStats['performance_stats'] ?? {},
    'comparison': {
      'hive_notes': hiveStats['total_notes'] ?? 0,
      'sqlite_notes': sqliteStats['total_notes'] ?? 0,
      'hive_storage_type': hiveStats['storage_type'] ?? 'hive',
      'sqlite_storage_type': sqliteStats['storage_type'] ?? 'sqlite',
    },
  };
});