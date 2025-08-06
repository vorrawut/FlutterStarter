import '../entities/news_article.dart';
import '../entities/news_source.dart';

abstract class NewsRepository {
  /// Get top headlines
  Future<List<NewsArticle>> getTopHeadlines({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  });

  /// Search articles
  Future<List<NewsArticle>> searchArticles({
    required String query,
    String? language,
    String? sortBy,
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 20,
  });

  /// Get available news sources
  Future<List<NewsSource>> getSources({
    String? category,
    String? language,
    String? country,
  });

  /// Get headlines by category
  Future<List<NewsArticle>> getHeadlinesByCategory(
    String category, {
    String? country,
    int page = 1,
    int pageSize = 20,
  });

  /// Get headlines from specific sources
  Future<List<NewsArticle>> getHeadlinesFromSources(
    List<String> sourceIds, {
    int page = 1,
    int pageSize = 20,
  });

  /// Get trending articles
  Future<List<NewsArticle>> getTrendingArticles({
    String query = 'trending',
    String? language,
    int page = 1,
    int pageSize = 20,
  });

  /// Get recent articles (last 24 hours)
  Future<List<NewsArticle>> getRecentArticles({
    String query = 'news',
    String? language,
    int page = 1,
    int pageSize = 20,
  });
}