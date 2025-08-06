import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/network/dio_config.dart';
import '../../data/services/news_api_service.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/entities/news_source.dart';
import '../../core/errors/api_error.dart';

// Core dependencies
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final newsApiServiceProvider = Provider<NewsApiService>((ref) {
  final dio = DioConfig.createNewsDio();
  return NewsApiService(dio);
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final apiService = ref.watch(newsApiServiceProvider);
  final connectivity = ref.watch(connectivityProvider);
  
  return NewsRepositoryImpl(
    apiService: apiService,
    connectivity: connectivity,
  );
});

// News state providers
final topHeadlinesProvider = FutureProvider.autoDispose.family<List<NewsArticle>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(newsRepositoryProvider);
  
  return repository.getTopHeadlines(
    country: params['country'] as String?,
    category: params['category'] as String?,
    page: params['page'] as int? ?? 1,
    pageSize: params['pageSize'] as int? ?? 20,
  );
});

final searchArticlesProvider = FutureProvider.autoDispose.family<List<NewsArticle>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(newsRepositoryProvider);
  final query = params['query'] as String;
  
  if (query.isEmpty) {
    return [];
  }
  
  return repository.searchArticles(
    query: query,
    language: params['language'] as String?,
    sortBy: params['sortBy'] as String?,
    from: params['from'] as DateTime?,
    to: params['to'] as DateTime?,
    page: params['page'] as int? ?? 1,
    pageSize: params['pageSize'] as int? ?? 20,
  );
});

final newsSourcesProvider = FutureProvider.autoDispose.family<List<NewsSource>, Map<String, String?>>((ref, params) async {
  final repository = ref.watch(newsRepositoryProvider);
  
  return repository.getSources(
    category: params['category'],
    language: params['language'],
    country: params['country'],
  );
});

final headlinesByCategoryProvider = FutureProvider.autoDispose.family<List<NewsArticle>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(newsRepositoryProvider);
  final category = params['category'] as String;
  
  return repository.getHeadlinesByCategory(
    category,
    country: params['country'] as String?,
    page: params['page'] as int? ?? 1,
    pageSize: params['pageSize'] as int? ?? 20,
  );
});

final headlinesFromSourcesProvider = FutureProvider.autoDispose.family<List<NewsArticle>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(newsRepositoryProvider);
  final sourceIds = params['sourceIds'] as List<String>;
  
  if (sourceIds.isEmpty) {
    return [];
  }
  
  return repository.getHeadlinesFromSources(
    sourceIds,
    page: params['page'] as int? ?? 1,
    pageSize: params['pageSize'] as int? ?? 20,
  );
});

final trendingArticlesProvider = FutureProvider.autoDispose.family<List<NewsArticle>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(newsRepositoryProvider);
  
  return repository.getTrendingArticles(
    query: params['query'] as String? ?? 'trending',
    language: params['language'] as String?,
    page: params['page'] as int? ?? 1,
    pageSize: params['pageSize'] as int? ?? 20,
  );
});

final recentArticlesProvider = FutureProvider.autoDispose.family<List<NewsArticle>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(newsRepositoryProvider);
  
  return repository.getRecentArticles(
    query: params['query'] as String? ?? 'news',
    language: params['language'] as String?,
    page: params['page'] as int? ?? 1,
    pageSize: params['pageSize'] as int? ?? 20,
  );
});

// UI state providers
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final selectedCountryProvider = StateProvider<String?>((ref) => 'us');
final selectedLanguageProvider = StateProvider<String?>((ref) => 'en');
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedSourcesProvider = StateProvider<List<String>>((ref) => []);

// Bookmarks and reading state (would be persisted in a real app)
final bookmarkedArticlesProvider = StateNotifierProvider<BookmarkedArticlesNotifier, List<NewsArticle>>((ref) {
  return BookmarkedArticlesNotifier();
});

final readArticlesProvider = StateNotifierProvider<ReadArticlesNotifier, Set<String>>((ref) {
  return ReadArticlesNotifier();
});

class BookmarkedArticlesNotifier extends StateNotifier<List<NewsArticle>> {
  BookmarkedArticlesNotifier() : super([]);

  void addBookmark(NewsArticle article) {
    if (!state.any((a) => a.id == article.id)) {
      state = [...state, article.copyWith(isBookmarked: true)];
    }
  }

  void removeBookmark(String articleId) {
    state = state.where((article) => article.id != articleId).toList();
  }

  void toggleBookmark(NewsArticle article) {
    if (state.any((a) => a.id == article.id)) {
      removeBookmark(article.id);
    } else {
      addBookmark(article);
    }
  }

  bool isBookmarked(String articleId) {
    return state.any((article) => article.id == articleId);
  }
}

class ReadArticlesNotifier extends StateNotifier<Set<String>> {
  ReadArticlesNotifier() : super({});

  void markAsRead(String articleId) {
    state = {...state, articleId};
  }

  void markAsUnread(String articleId) {
    state = Set.from(state)..remove(articleId);
  }

  bool isRead(String articleId) {
    return state.contains(articleId);
  }

  void clearAll() {
    state = {};
  }
}

// Network connectivity state
final connectivityStateProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.onConnectivityChanged;
});

// Error handling provider
final lastErrorProvider = StateProvider<ApiError?>((ref) => null);

// Loading state providers
final isLoadingProvider = StateProvider<bool>((ref) => false);
final isSearchingProvider = StateProvider<bool>((ref) => false);
final isRefreshingProvider = StateProvider<bool>((ref) => false);

// Pagination providers
final currentPageProvider = StateProvider.family<int, String>((ref, key) => 1);
final hasMorePagesProvider = StateProvider.family<bool, String>((ref, key) => true);

// Cache control
final shouldRefreshProvider = StateProvider<bool>((ref) => false);

// Combined providers for complex UI states
final homeNewsProvider = Provider.autoDispose<AsyncValue<Map<String, List<NewsArticle>>>>((ref) {
  final country = ref.watch(selectedCountryProvider);
  final topHeadlines = ref.watch(topHeadlinesProvider({
    'country': country,
    'pageSize': 10,
  }));
  
  final trending = ref.watch(trendingArticlesProvider({
    'pageSize': 5,
  }));
  
  final recent = ref.watch(recentArticlesProvider({
    'pageSize': 5,
  }));

  // Combine all async values
  return AsyncValue.guard(() async {
    final headlinesData = await topHeadlines.future;
    final trendingData = await trending.future;
    final recentData = await recent.future;
    
    return {
      'headlines': headlinesData,
      'trending': trendingData,
      'recent': recentData,
    };
  });
});