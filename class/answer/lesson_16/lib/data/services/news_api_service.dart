import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/api_response.dart';
import '../models/article.dart';
import '../models/source.dart';

part 'news_api_service.g.dart';

@RestApi()
abstract class NewsApiService {
  factory NewsApiService(Dio dio) = _NewsApiService;

  /// Get top headlines
  /// 
  /// [country] - The 2-letter ISO 3166-1 code of the country you want to get headlines for
  /// [category] - The category you want to get headlines for
  /// [sources] - A comma-separated string of identifiers for the news sources
  /// [q] - Keywords or a phrase to search for
  /// [pageSize] - The number of results to return per page (request). 20 is the default, 100 is the maximum
  /// [page] - Use this to page through the results if the total results found is greater than the page size
  @GET('/top-headlines')
  Future<ApiResponse<Article>> getTopHeadlines({
    @Query('country') String? country,
    @Query('category') String? category,
    @Query('sources') String? sources,
    @Query('q') String? query,
    @Query('pageSize') int? pageSize,
    @Query('page') int? page,
  });

  /// Search through millions of articles
  /// 
  /// [q] - Keywords or a phrase to search for (required)
  /// [qInTitle] - Keywords or a phrase to search for in the article title only
  /// [sources] - A comma-separated string of identifiers for the news sources
  /// [domains] - A comma-separated string of domains to restrict the search to
  /// [excludeDomains] - A comma-separated string of domains to remove from the results
  /// [from] - The earliest date for articles (ISO 8601 format)
  /// [to] - The latest date for articles (ISO 8601 format)
  /// [language] - The 2-letter ISO-639-1 code of the language you want to get headlines for
  /// [sortBy] - The order to sort the articles in (relevancy, popularity, publishedAt)
  /// [pageSize] - The number of results to return per page (request). 20 is the default, 100 is the maximum
  /// [page] - Use this to page through the results if the total results found is greater than the page size
  @GET('/everything')
  Future<ApiResponse<Article>> searchEverything({
    @Query('q') required String query,
    @Query('qInTitle') String? queryInTitle,
    @Query('sources') String? sources,
    @Query('domains') String? domains,
    @Query('excludeDomains') String? excludeDomains,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('language') String? language,
    @Query('sortBy') String? sortBy,
    @Query('pageSize') int? pageSize,
    @Query('page') int? page,
  });

  /// Get all available news sources
  /// 
  /// [category] - Find sources that display news of this category
  /// [language] - Find sources that display news in a specific language
  /// [country] - Find sources that display news in a specific country
  @GET('/sources')
  Future<ApiResponse<Source>> getSources({
    @Query('category') String? category,
    @Query('language') String? language,
    @Query('country') String? country,
  });

  // Convenience methods with better typing

  /// Get top headlines for a specific country
  Future<ApiResponse<Article>> getHeadlinesByCountry(
    String countryCode, {
    int? pageSize,
    int? page,
  }) {
    return getTopHeadlines(
      country: countryCode,
      pageSize: pageSize,
      page: page,
    );
  }

  /// Get top headlines for a specific category
  Future<ApiResponse<Article>> getHeadlinesByCategory(
    String category, {
    String? country,
    int? pageSize,
    int? page,
  }) {
    return getTopHeadlines(
      category: category,
      country: country,
      pageSize: pageSize,
      page: page,
    );
  }

  /// Get headlines from specific sources
  Future<ApiResponse<Article>> getHeadlinesFromSources(
    List<String> sourceIds, {
    int? pageSize,
    int? page,
  }) {
    return getTopHeadlines(
      sources: sourceIds.join(','),
      pageSize: pageSize,
      page: page,
    );
  }

  /// Search articles by keyword
  Future<ApiResponse<Article>> searchArticles(
    String keyword, {
    String? language,
    String? sortBy,
    DateTime? from,
    DateTime? to,
    int? pageSize,
    int? page,
  }) {
    return searchEverything(
      query: keyword,
      language: language,
      sortBy: sortBy,
      from: from?.toIso8601String(),
      to: to?.toIso8601String(),
      pageSize: pageSize,
      page: page,
    );
  }

  /// Search articles from specific domains
  Future<ApiResponse<Article>> searchFromDomains(
    String query,
    List<String> domains, {
    String? language,
    String? sortBy,
    int? pageSize,
    int? page,
  }) {
    return searchEverything(
      query: query,
      domains: domains.join(','),
      language: language,
      sortBy: sortBy,
      pageSize: pageSize,
      page: page,
    );
  }

  /// Get articles excluding specific domains
  Future<ApiResponse<Article>> searchExcludingDomains(
    String query,
    List<String> excludeDomains, {
    String? language,
    String? sortBy,
    int? pageSize,
    int? page,
  }) {
    return searchEverything(
      query: query,
      excludeDomains: excludeDomains.join(','),
      language: language,
      sortBy: sortBy,
      pageSize: pageSize,
      page: page,
    );
  }

  /// Get recent articles (last 24 hours)
  Future<ApiResponse<Article>> getRecentArticles(
    String query, {
    String? language,
    int? pageSize,
    int? page,
  }) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return searchEverything(
      query: query,
      from: yesterday.toIso8601String(),
      language: language,
      sortBy: 'publishedAt',
      pageSize: pageSize,
      page: page,
    );
  }

  /// Get trending articles (sorted by popularity)
  Future<ApiResponse<Article>> getTrendingArticles(
    String query, {
    String? language,
    int? pageSize,
    int? page,
  }) {
    return searchEverything(
      query: query,
      language: language,
      sortBy: 'popularity',
      pageSize: pageSize,
      page: page,
    );
  }
}