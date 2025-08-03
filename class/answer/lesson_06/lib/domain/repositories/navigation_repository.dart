import '../entities/navigation_item.dart';

/// Navigation repository interface defining navigation operations
/// Following clean architecture principles - domain layer defines contracts
abstract class NavigationRepository {
  /// Navigate to a specific route
  Future<NavigationResult> navigateToRoute(
    String route, {
    Map<String, dynamic>? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  });

  /// Navigate back to previous route
  Future<NavigationResult> navigateBack();

  /// Navigate and replace current route
  Future<NavigationResult> navigateAndReplace(
    String route, {
    Map<String, dynamic>? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  });

  /// Navigate and clear entire navigation stack
  Future<NavigationResult> navigateAndClearStack(
    String route, {
    Map<String, dynamic>? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  });

  /// Get current route path
  String getCurrentRoute();

  /// Get current route name
  String getCurrentRouteName();

  /// Check if navigation can go back
  bool canNavigateBack();

  /// Get navigation history
  List<String> getNavigationHistory();

  /// Get main navigation items (bottom navigation)
  List<NavigationItem> getMainNavigationItems();

  /// Get drawer navigation items
  List<NavigationItem> getDrawerNavigationItems();

  /// Get profile menu navigation items
  List<NavigationItem> getProfileMenuItems();

  /// Filter navigation items based on authentication status
  List<NavigationItem> filterNavigationItems(
    List<NavigationItem> items,
    bool isAuthenticated,
  );

  /// Update navigation item badge count
  Future<void> updateNavigationItemBadge(String itemId, int? badgeCount);

  /// Clear all navigation badges
  Future<void> clearAllNavigationBadges();

  /// Get navigation item by ID
  NavigationItem? getNavigationItemById(String id);

  /// Check if route requires authentication
  bool isProtectedRoute(String route);

  /// Get route metadata
  Map<String, dynamic> getRouteMetadata(String route);

  /// Track navigation analytics
  Future<void> trackNavigation(String from, String to, {
    Map<String, dynamic>? metadata,
  });

  /// Get navigation analytics data
  Future<NavigationAnalytics> getNavigationAnalytics();
}

/// Navigation result class for operation outcomes
class NavigationResult {
  final bool isSuccess;
  final String? errorMessage;
  final NavigationResultType type;
  final Map<String, dynamic>? metadata;

  const NavigationResult._({
    required this.isSuccess,
    this.errorMessage,
    required this.type,
    this.metadata,
  });

  /// Success result
  factory NavigationResult.success({Map<String, dynamic>? metadata}) {
    return NavigationResult._(
      isSuccess: true,
      type: NavigationResultType.success,
      metadata: metadata,
    );
  }

  /// Error result
  factory NavigationResult.error(String message, {Map<String, dynamic>? metadata}) {
    return NavigationResult._(
      isSuccess: false,
      errorMessage: message,
      type: NavigationResultType.error,
      metadata: metadata,
    );
  }

  /// Redirected to login result
  factory NavigationResult.redirectedToLogin({Map<String, dynamic>? metadata}) {
    return NavigationResult._(
      isSuccess: true,
      type: NavigationResultType.redirectedToLogin,
      metadata: metadata,
    );
  }

  /// Route not found result
  factory NavigationResult.routeNotFound(String route, {Map<String, dynamic>? metadata}) {
    return NavigationResult._(
      isSuccess: false,
      errorMessage: 'Route not found: $route',
      type: NavigationResultType.routeNotFound,
      metadata: metadata,
    );
  }

  /// Permission denied result
  factory NavigationResult.permissionDenied(String route, {Map<String, dynamic>? metadata}) {
    return NavigationResult._(
      isSuccess: false,
      errorMessage: 'Permission denied for route: $route',
      type: NavigationResultType.permissionDenied,
      metadata: metadata,
    );
  }

  /// Navigation cancelled result
  factory NavigationResult.cancelled({Map<String, dynamic>? metadata}) {
    return NavigationResult._(
      isSuccess: false,
      errorMessage: 'Navigation cancelled by user',
      type: NavigationResultType.cancelled,
      metadata: metadata,
    );
  }

  bool get isError => !isSuccess;
  bool get isRedirectedToLogin => type == NavigationResultType.redirectedToLogin;
  bool get isRouteNotFound => type == NavigationResultType.routeNotFound;
  bool get isPermissionDenied => type == NavigationResultType.permissionDenied;
  bool get isCancelled => type == NavigationResultType.cancelled;

  @override
  String toString() {
    return 'NavigationResult(isSuccess: $isSuccess, type: $type, error: $errorMessage)';
  }
}

/// Navigation result type enumeration
enum NavigationResultType {
  success,
  error,
  redirectedToLogin,
  routeNotFound,
  permissionDenied,
  cancelled,
}

/// Navigation analytics data
class NavigationAnalytics {
  final Map<String, int> routeVisitCounts;
  final Map<String, Duration> routeTimeSpent;
  final List<NavigationEvent> recentEvents;
  final Map<String, double> routeEngagementScores;
  final DateTime lastUpdated;

  const NavigationAnalytics({
    required this.routeVisitCounts,
    required this.routeTimeSpent,
    required this.recentEvents,
    required this.routeEngagementScores,
    required this.lastUpdated,
  });

  /// Get most visited routes
  List<String> getMostVisitedRoutes({int limit = 5}) {
    final sorted = routeVisitCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toList();
  }

  /// Get total navigation events
  int get totalNavigationEvents {
    return routeVisitCounts.values.fold(0, (sum, count) => sum + count);
  }

  /// Get average session duration
  Duration get averageSessionDuration {
    if (routeTimeSpent.isEmpty) return Duration.zero;
    final totalMilliseconds = routeTimeSpent.values
        .fold(0, (sum, duration) => sum + duration.inMilliseconds);
    return Duration(milliseconds: totalMilliseconds ~/ routeTimeSpent.length);
  }
}

/// Navigation event for analytics
class NavigationEvent {
  final String from;
  final String to;
  final DateTime timestamp;
  final Duration? duration;
  final Map<String, dynamic>? metadata;

  const NavigationEvent({
    required this.from,
    required this.to,
    required this.timestamp,
    this.duration,
    this.metadata,
  });

  @override
  String toString() {
    return 'NavigationEvent(from: $from, to: $to, timestamp: $timestamp)';
  }
}

/// Navigation state interface
abstract class NavigationState {
  /// Current route
  String get currentRoute;

  /// Current route name
  String get currentRouteName;

  /// Navigation history
  List<String> get navigationHistory;

  /// Can navigate back
  bool get canGoBack;

  /// Current navigation index (for bottom navigation)
  int get currentNavigationIndex;

  /// Is drawer open
  bool get isDrawerOpen;

  /// Navigation metadata
  Map<String, dynamic> get metadata;
}

/// Navigation configuration interface
abstract class NavigationConfiguration {
  /// Get route definitions
  Map<String, dynamic> getRouteDefinitions();

  /// Get route guards configuration
  Map<String, List<String>> getRouteGuards();

  /// Get default route
  String getDefaultRoute();

  /// Get error route
  String getErrorRoute();

  /// Get authentication routes
  List<String> getAuthenticationRoutes();

  /// Get protected routes
  List<String> getProtectedRoutes();

  /// Get public routes
  List<String> getPublicRoutes();

  /// Validate route configuration
  bool validateConfiguration();
}