class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String authBaseUrl = 'https://api.newsflow.com/v1';
  
  // API Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  static const String sources = '/sources';
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String register = '/auth/register';
  
  // User Endpoints
  static const String profile = '/user/profile';
  static const String preferences = '/user/preferences';
  static const String bookmarks = '/user/bookmarks';
  
  // API Keys
  static const String newsApiKey = 'your_news_api_key_here'; // Replace with actual key
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Cache
  static const Duration cacheMaxAge = Duration(minutes: 15);
  static const Duration cacheStaleTime = Duration(hours: 1);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // Retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'NewsFlow Pro/1.0.0',
  };
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Request IDs
  static const String requestIdHeader = 'X-Request-ID';
  
  // Rate Limiting
  static const Duration rateLimitWindow = Duration(minutes: 1);
  static const int maxRequestsPerWindow = 100;
}