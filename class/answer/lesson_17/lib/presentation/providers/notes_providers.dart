import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/tag_entity.dart';
import 'storage_providers.dart';

// Repository provider that uses the current storage backend
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final dataSource = ref.watch(currentDataSourceProvider);
  return NotesRepositoryImpl(localDataSource: dataSource);
});

// Notes providers
final allNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = ref.watch(notesRepositoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  
  if (searchQuery.trim().isNotEmpty) {
    return await repository.searchNotes(searchQuery);
  }
  
  return await repository.getAllNotes();
});

final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repository = ref.watch(notesRepositoryProvider);
  return await repository.getAllCategories();
});

final tagsProvider = FutureProvider<List<TagEntity>>((ref) async {
  final repository = ref.watch(notesRepositoryProvider);
  return await repository.getAllTags();
});

final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(notesRepositoryProvider);
  return await repository.getStatistics();
});

// UI state providers
final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final selectedTagsProvider = StateProvider<List<String>>((ref) => []);

final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

final showArchivedProvider = StateProvider<bool>((ref) => false);

// Filtered notes provider
final filteredNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repository = ref.watch(notesRepositoryProvider);
  final categoryId = ref.watch(selectedCategoryProvider);
  final tagIds = ref.watch(selectedTagsProvider);
  final favoritesOnly = ref.watch(showFavoritesOnlyProvider);
  final showArchived = ref.watch(showArchivedProvider);
  
  return await repository.getFilteredNotes(
    categoryId: categoryId,
    tagIds: tagIds.isNotEmpty ? tagIds : null,
    isFavorite: favoritesOnly ? true : null,
    isArchived: showArchived,
  );
});

// Note actions
class NotesActions {
  final Ref ref;
  
  NotesActions(this.ref);
  
  Future<void> createNote(NoteEntity note) async {
    final repository = ref.read(notesRepositoryProvider);
    await repository.createNote(note);
    ref.invalidate(allNotesProvider);
    ref.invalidate(statisticsProvider);
  }
  
  Future<void> updateNote(NoteEntity note) async {
    final repository = ref.read(notesRepositoryProvider);
    await repository.updateNote(note);
    ref.invalidate(allNotesProvider);
    ref.invalidate(statisticsProvider);
  }
  
  Future<void> deleteNote(String noteId) async {
    final repository = ref.read(notesRepositoryProvider);
    await repository.deleteNote(noteId);
    ref.invalidate(allNotesProvider);
    ref.invalidate(statisticsProvider);
  }
  
  Future<void> toggleFavorite(NoteEntity note) async {
    final updatedNote = note.copyWith(isFavorite: !note.isFavorite);
    await updateNote(updatedNote);
  }
  
  Future<void> toggleArchived(NoteEntity note) async {
    final updatedNote = note.copyWith(isArchived: !note.isArchived);
    await updateNote(updatedNote);
  }
}

final notesActionsProvider = Provider<NotesActions>((ref) {
  return NotesActions(ref);
});