import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/entities/news_source.dart';
import '../../domain/repositories/news_repository.dart';
import '../../core/errors/api_error.dart';
import '../../core/errors/network_exceptions.dart';
import '../services/news_api_service.dart';
import '../models/article.dart';
import '../models/source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiService _apiService;
  final Connectivity _connectivity;

  NewsRepositoryImpl({
    required NewsApiService apiService,
    required Connectivity connectivity,
  })  : _apiService = apiService,
        _connectivity = connectivity;

  @override
  Future<List<NewsArticle>> getTopHeadlines({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _apiService.getTopHeadlines(
        country: country,
        category: category,
        page: page,
        pageSize: pageSize,
      );

      if (response.isSuccess) {
        return response.articles.map(_mapArticleToEntity).toList();
      } else {
        throw NetworkExceptions.badRequest(message: response.errorMessage);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw NetworkExceptions.unexpectedError(originalError: e);
    }
  }

  @override
  Future<List<NewsArticle>> searchArticles({
    required String query,
    String? language,
    String? sortBy,
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _apiService.searchEverything(
        query: query,
        language: language,
        sortBy: sortBy,
        from: from?.toIso8601String(),
        to: to?.toIso8601String(),
        page: page,
        pageSize: pageSize,
      );

      if (response.isSuccess) {
        return response.articles.map(_mapArticleToEntity).toList();
      } else {
        throw NetworkExceptions.badRequest(message: response.errorMessage);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw NetworkExceptions.unexpectedError(originalError: e);
    }
  }

  @override
  Future<List<NewsSource>> getSources({
    String? category,
    String? language,
    String? country,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _apiService.getSources(
        category: category,
        language: language,
        country: country,
      );

      if (response.isSuccess) {
        return response.articles.map(_mapSourceToEntity).toList();
      } else {
        throw NetworkExceptions.badRequest(message: response.errorMessage);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw NetworkExceptions.unexpectedError(originalError: e);
    }
  }

  @override
  Future<List<NewsArticle>> getHeadlinesByCategory(
    String category, {
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    return getTopHeadlines(
      category: category,
      country: country,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<NewsArticle>> getHeadlinesFromSources(
    List<String> sourceIds, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _apiService.getHeadlinesFromSources(
        sourceIds,
        page: page,
        pageSize: pageSize,
      );

      if (response.isSuccess) {
        return response.articles.map(_mapArticleToEntity).toList();
      } else {
        throw NetworkExceptions.badRequest(message: response.errorMessage);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw NetworkExceptions.unexpectedError(originalError: e);
    }
  }

  @override
  Future<List<NewsArticle>> getTrendingArticles({
    String query = 'trending',
    String? language,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _apiService.getTrendingArticles(
        query,
        language: language,
        page: page,
        pageSize: pageSize,
      );

      if (response.isSuccess) {
        return response.articles.map(_mapArticleToEntity).toList();
      } else {
        throw NetworkExceptions.badRequest(message: response.errorMessage);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw NetworkExceptions.unexpectedError(originalError: e);
    }
  }

  @override
  Future<List<NewsArticle>> getRecentArticles({
    String query = 'news',
    String? language,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _apiService.getRecentArticles(
        query,
        language: language,
        page: page,
        pageSize: pageSize,
      );

      if (response.isSuccess) {
        return response.articles.map(_mapArticleToEntity).toList();
      } else {
        throw NetworkExceptions.badRequest(message: response.errorMessage);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw NetworkExceptions.unexpectedError(originalError: e);
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkExceptions.noInternetConnection();
    }
  }

  NewsArticle _mapArticleToEntity(Article article) {
    return NewsArticle(
      id: article.url.hashCode.toString(), // Generate ID from URL
      title: article.title,
      description: article.description ?? '',
      content: article.content ?? '',
      url: article.url,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      author: article.author,
      source: article.source != null 
          ? _mapSourceToEntity(article.source!)
          : null,
      isBookmarked: article.isBookmarked,
      isRead: article.isRead,
      readAt: article.readAt,
    );
  }

  NewsSource _mapSourceToEntity(Source source) {
    return NewsSource(
      id: source.id ?? source.name.hashCode.toString(),
      name: source.name,
      description: source.description ?? '',
      url: source.url,
      category: source.category,
      language: source.language,
      country: source.country,
    );
  }
}