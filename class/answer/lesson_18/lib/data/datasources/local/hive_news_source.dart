import 'package:hive/hive.dart';
import 'dart:developer';

import '../../../domain/entities/article.dart';
import '../../models/article_hive_model.dart';

abstract class HiveNewsSource {
  Future<void> initialize();
  Future<List<Article>> getArticles({
    String? category,
    int? limit,
    int? offset,
  });
  Future<void> saveArticles(List<Article> articles);
  Future<List<Article>> searchArticles(String query);
  Future<void> toggleBookmark(String articleId);
  Future<List<Article>> getBookmarkedArticles();
  Future<void> clearCache();
  Future<int> getCacheSize();
}

class HiveNewsSourceImpl implements HiveNewsSource {
  late final Box<ArticleHiveModel> _articlesBox;
  late final Box<String> _bookmarksBox;
  
  @override
  Future<void> initialize() async {
    try {
      // Register adapters if not already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ArticleHiveModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(SourceHiveModelAdapter());
      }

      // Open boxes
      _articlesBox = await Hive.openBox<ArticleHiveModel>('articles');
      _bookmarksBox = await Hive.openBox<String>('bookmarks');
      
      log('Hive initialized successfully');
    } catch (e) {
      log('Failed to initialize Hive: $e');
      rethrow;
    }
  }

  @override
  Future<List<Article>> getArticles({
    String? category,
    int? limit,
    int? offset,
  }) async {
    try {
      var articleModels = _articlesBox.values.toList();

      // Filter by category if specified
      if (category != null && category.isNotEmpty) {
        articleModels = articleModels.where((article) => 
          article.categories.contains(category)).toList();
      }

      // Sort by published date (newest first)
      articleModels.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      // Apply pagination
      if (offset != null) {
        articleModels = articleModels.skip(offset).toList();
      }
      if (limit != null) {
        articleModels = articleModels.take(limit).toList();
      }

      // Convert to domain entities and check bookmark status
      final articles = <Article>[];
      for (final model in articleModels) {
        final isBookmarked = _bookmarksBox.containsKey(model.id);
        articles.add(model.toDomain().copyWith(isBookmarked: isBookmarked));
      }

      return articles;
    } catch (e) {
      log('Failed to get articles from Hive: $e');
      return [];
    }
  }

  @override
  Future<void> saveArticles(List<Article> articles) async {
    try {
      final models = articles.map((article) => 
          ArticleHiveModel.fromDomain(article)).toList();
      
      for (final model in models) {
        await _articlesBox.put(model.id, model);
      }
      
      log('Saved ${articles.length} articles to Hive');
    } catch (e) {
      log('Failed to save articles to Hive: $e');
    }
  }

  @override
  Future<List<Article>> searchArticles(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase();
      
      final matchingModels = _articlesBox.values.where((article) {
        return article.title.toLowerCase().contains(lowercaseQuery) ||
               (article.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (article.content?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               article.categories.any((cat) => 
                   cat.toLowerCase().contains(lowercaseQuery));
      }).toList();

      // Sort by relevance (title matches first, then description, then content)
      matchingModels.sort((a, b) {
        final aTitle = a.title.toLowerCase().contains(lowercaseQuery);
        final bTitle = b.title.toLowerCase().contains(lowercaseQuery);
        
        if (aTitle && !bTitle) return -1;
        if (!aTitle && bTitle) return 1;
        
        // If both or neither match title, sort by date
        return b.publishedAt.compareTo(a.publishedAt);
      });

      // Convert to domain entities and check bookmark status
      final articles = <Article>[];
      for (final model in matchingModels) {
        final isBookmarked = _bookmarksBox.containsKey(model.id);
        articles.add(model.toDomain().copyWith(isBookmarked: isBookmarked));
      }

      return articles;
    } catch (e) {
      log('Failed to search articles in Hive: $e');
      return [];
    }
  }

  @override
  Future<void> toggleBookmark(String articleId) async {
    try {
      if (_bookmarksBox.containsKey(articleId)) {
        await _bookmarksBox.delete(articleId);
        log('Removed bookmark for article: $articleId');
      } else {
        await _bookmarksBox.put(articleId, articleId);
        log('Added bookmark for article: $articleId');
      }
    } catch (e) {
      log('Failed to toggle bookmark: $e');
    }
  }

  @override
  Future<List<Article>> getBookmarkedArticles() async {
    try {
      final bookmarkedIds = _bookmarksBox.values.toSet();
      final bookmarkedModels = _articlesBox.values
          .where((article) => bookmarkedIds.contains(article.id))
          .toList();

      // Sort by most recently bookmarked
      bookmarkedModels.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      return bookmarkedModels
          .map((model) => model.toDomain().copyWith(isBookmarked: true))
          .toList();
    } catch (e) {
      log('Failed to get bookmarked articles: $e');
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _articlesBox.clear();
      log('Cleared Hive articles cache');
    } catch (e) {
      log('Failed to clear Hive cache: $e');
    }
  }

  @override
  Future<int> getCacheSize() async {
    try {
      return _articlesBox.length;
    } catch (e) {
      log('Failed to get Hive cache size: $e');
      return 0;
    }
  }
}
