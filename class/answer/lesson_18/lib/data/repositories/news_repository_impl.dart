import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/remote/news_api_service.dart';
import '../datasources/local/hive_news_source.dart';
import '../datasources/local/sqlite_news_source.dart';
import '../models/article_model.dart';
import '../mappers/article_mapper.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiService _apiService;
  final HiveNewsSource _hiveSource;
  final SQLiteNewsSource _sqliteSource;
  final Connectivity _connectivity;
  final ArticleMapper _mapper;

  // Storage preferences
  bool _preferSQLiteForSearch = true;
  bool _preferHiveForCache = true;

  NewsRepositoryImpl({
    required NewsApiService apiService,
    required HiveNewsSource hiveSource,
    required SQLiteNewsSource sqliteSource,
    required Connectivity connectivity,
    required ArticleMapper mapper,
  })  : _apiService = apiService,
        _hiveSource = hiveSource,
        _sqliteSource = sqliteSource,
        _connectivity = connectivity,
        _mapper = mapper;

  @override
  Future<List<Article>> getTopHeadlines({
    String? country,
    String? category,
    int? pageSize,
    int? page,
  }) async {
    try {
      // Check connectivity
      final connectivity = await _connectivity.checkConnectivity();
      final isOnline = connectivity != ConnectivityResult.none;

      if (isOnline) {
        // Fetch from API
        final response = await _apiService.getTopHeadlines(
          country: country,
          category: category,
          pageSize: pageSize,
          page: page,
          apiKey: _getApiKey(),
        );

        final articles = response.articles
            .map((model) => _mapper.modelToDomain(model))
            .toList();

        // Cache articles in both storage systems
        await _cacheArticles(articles, category);

        log('Fetched ${articles.length} top headlines from API');
        return articles;
      } else {
        // Fallback to local cache
        return await _getCachedArticles(category: category);
      }
    } catch (e) {
      log('Failed to get top headlines: $e');
      
      // Fallback to local cache on error
      return await _getCachedArticles(category: category);
    }
  }

  @override
  Future<List<Article>> searchArticles({
    required String query,
    String? language,
    String? sortBy,
    int? pageSize,
    int? page,
  }) async {
    try {
      // Check connectivity
      final connectivity = await _connectivity.checkConnectivity();
      final isOnline = connectivity != ConnectivityResult.none;

      // Hybrid search: combine local and remote results
      final localResults = await _searchLocal(query);
      
      if (isOnline) {
        try {
          // Fetch from API
          final response = await _apiService.searchArticles(
            query: query,
            language: language,
            sortBy: sortBy,
            pageSize: pageSize,
            page: page,
            apiKey: _getApiKey(),
          );

          final remoteArticles = response.articles
              .map((model) => _mapper.modelToDomain(model))
              .toList();

          // Cache new articles
          await _cacheArticles(remoteArticles);

          // Merge and deduplicate results
          final mergedResults = _mergeAndDeduplicate(localResults, remoteArticles);
          
          log('Hybrid search: ${localResults.length} local + ${remoteArticles.length} remote = ${mergedResults.length} total');
          return mergedResults;
        } catch (e) {
          log('Remote search failed, using local results: $e');
          return localResults;
        }
      } else {
        log('Offline search: ${localResults.length} local results');
        return localResults;
      }
    } catch (e) {
      log('Search failed: $e');
      return [];
    }
  }

  @override
  Future<void> toggleBookmark(String articleId) async {
    try {
      // Update bookmarks in both storage systems
      await Future.wait([
        _hiveSource.toggleBookmark(articleId),
        _sqliteSource.toggleBookmark(articleId),
      ]);
      
      log('Toggled bookmark for article: $articleId');
    } catch (e) {
      log('Failed to toggle bookmark: $e');
    }
  }

  @override
  Future<List<Article>> getBookmarkedArticles() async {
    try {
      // Use SQLite for bookmarks (better for relational queries)
      return await _sqliteSource.getBookmarkedArticles();
    } catch (e) {
      log('Failed to get bookmarked articles from SQLite, trying Hive: $e');
      
      // Fallback to Hive
      try {
        return await _hiveSource.getBookmarkedArticles();
      } catch (e2) {
        log('Failed to get bookmarked articles from Hive: $e2');
        return [];
      }
    }
  }

  @override
  Future<List<Article>> getCachedArticles({
    String? category,
    int? limit,
    int? offset,
  }) async {
    return await _getCachedArticles(
      category: category,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<void> clearCache() async {
    try {
      await Future.wait([
        _hiveSource.clearCache(),
        _sqliteSource.clearCache(),
      ]);
      
      log('Cleared all caches');
    } catch (e) {
      log('Failed to clear caches: $e');
    }
  }

  @override
  Future<Map<String, int>> getCacheStats() async {
    try {
      final hiveSize = await _hiveSource.getCacheSize();
      final sqliteSize = await _sqliteSource.getCacheSize();
      
      return {
        'hive': hiveSize,
        'sqlite': sqliteSize,
        'total': hiveSize + sqliteSize,
      };
    } catch (e) {
      log('Failed to get cache stats: $e');
      return {'hive': 0, 'sqlite': 0, 'total': 0};
    }
  }

  @override
  Future<void> syncData() async {
    try {
      // Sync recent articles to ensure consistency
      final recentArticles = await getTopHeadlines(pageSize: 20);
      log('Synced ${recentArticles.length} articles');
    } catch (e) {
      log('Data sync failed: $e');
    }
  }

  @override
  Future<void> switchStorageBackend(String backend) async {
    switch (backend.toLowerCase()) {
      case 'hive':
        _preferHiveForCache = true;
        _preferSQLiteForSearch = false;
        log('Switched to Hive-preferred storage');
        break;
      case 'sqlite':
        _preferHiveForCache = false;
        _preferSQLiteForSearch = true;
        log('Switched to SQLite-preferred storage');
        break;
      case 'hybrid':
      default:
        _preferHiveForCache = true;
        _preferSQLiteForSearch = true;
        log('Using hybrid storage strategy');
        break;
    }
  }

  // Private helper methods

  Future<List<Article>> _getCachedArticles({
    String? category,
    int? limit,
    int? offset,
  }) async {
    try {
      // Use preferred storage for caching
      if (_preferHiveForCache) {
        return await _hiveSource.getArticles(
          category: category,
          limit: limit,
          offset: offset,
        );
      } else {
        return await _sqliteSource.getArticles(
          category: category,
          limit: limit,
          offset: offset,
        );
      }
    } catch (e) {
      log('Failed to get cached articles from preferred storage: $e');
      
      // Fallback to alternative storage
      try {
        if (_preferHiveForCache) {
          return await _sqliteSource.getArticles(
            category: category,
            limit: limit,
            offset: offset,
          );
        } else {
          return await _hiveSource.getArticles(
            category: category,
            limit: limit,
            offset: offset,
          );
        }
      } catch (e2) {
        log('Fallback storage also failed: $e2');
        return [];
      }
    }
  }

  Future<List<Article>> _searchLocal(String query) async {
    try {
      // Use preferred storage for search
      if (_preferSQLiteForSearch) {
        return await _sqliteSource.searchArticles(query);
      } else {
        return await _hiveSource.searchArticles(query);
      }
    } catch (e) {
      log('Search failed in preferred storage: $e');
      
      // Fallback to alternative storage
      try {
        if (_preferSQLiteForSearch) {
          return await _hiveSource.searchArticles(query);
        } else {
          return await _sqliteSource.searchArticles(query);
        }
      } catch (e2) {
        log('Fallback search also failed: $e2');
        return [];
      }
    }
  }

  Future<void> _cacheArticles(List<Article> articles, [String? category]) async {
    try {
      // Cache in both storage systems for redundancy
      await Future.wait([
        _hiveSource.saveArticles(articles),
        _sqliteSource.saveArticles(articles),
      ]);
      
      log('Cached ${articles.length} articles in both storage systems');
    } catch (e) {
      log('Failed to cache articles: $e');
      
      // Try to save in at least one storage system
      try {
        await _hiveSource.saveArticles(articles);
        log('Cached articles in Hive only');
      } catch (e2) {
        try {
          await _sqliteSource.saveArticles(articles);
          log('Cached articles in SQLite only');
        } catch (e3) {
          log('Failed to cache articles in any storage system');
        }
      }
    }
  }

  List<Article> _mergeAndDeduplicate(
    List<Article> localResults,
    List<Article> remoteResults,
  ) {
    final articleMap = <String, Article>{};
    
    // Add local results first (they might have bookmark status)
    for (final article in localResults) {
      articleMap[article.id] = article;
    }
    
    // Add remote results, but don't overwrite local ones
    for (final article in remoteResults) {
      if (!articleMap.containsKey(article.id)) {
        articleMap[article.id] = article;
      }
    }
    
    // Sort by published date (newest first)
    final mergedList = articleMap.values.toList();
    mergedList.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    
    return mergedList;
  }

  String _getApiKey() {
    // In a real app, this would come from environment variables or secure storage
    return const String.fromEnvironment('NEWS_API_KEY', 
        defaultValue: 'demo-api-key');
  }
}
