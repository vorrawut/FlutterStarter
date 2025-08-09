import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/news_response.dart';
import '../../models/sources_response.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: "https://newsapi.org/v2/")
abstract class NewsApiService {
  factory NewsApiService(Dio dio) = _NewsApiService;

  @GET("/top-headlines")
  Future<NewsResponse> getTopHeadlines({
    @Query("country") String? country,
    @Query("category") String? category,
    @Query("sources") String? sources,
    @Query("q") String? query,
    @Query("pageSize") int? pageSize,
    @Query("page") int? page,
    @Query("apiKey") required String apiKey,
  });

  @GET("/everything")
  Future<NewsResponse> searchArticles({
    @Query("q") required String query,
    @Query("searchIn") String? searchIn,
    @Query("sources") String? sources,
    @Query("domains") String? domains,
    @Query("excludeDomains") String? excludeDomains,
    @Query("from") String? from,
    @Query("to") String? to,
    @Query("language") String? language,
    @Query("sortBy") String? sortBy,
    @Query("pageSize") int? pageSize,
    @Query("page") int? page,
    @Query("apiKey") required String apiKey,
  });

  @GET("/sources")
  Future<SourcesResponse> getSources({
    @Query("category") String? category,
    @Query("language") String? language,
    @Query("country") String? country,
    @Query("apiKey") required String apiKey,
  });
}
