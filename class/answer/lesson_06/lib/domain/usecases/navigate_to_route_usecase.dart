import '../entities/user.dart';
import '../repositories/navigation_repository.dart';
import '../repositories/auth_repository.dart';
import '../../core/constants/app_routes.dart';

/// Use case for navigating to routes with authentication checks
/// Encapsulates business logic for route navigation
class NavigateToRouteUseCase {
  final NavigationRepository _navigationRepository;
  final AuthRepository _authRepository;

  const NavigateToRouteUseCase(
    this._navigationRepository,
    this._authRepository,
  );

  /// Execute navigation to a specific route
  Future<NavigationResult> execute(
    String route, {
    Map<String, dynamic>? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    bool bypassAuth = false,
  }) async {
    try {
      // Track the navigation attempt
      final currentRoute = _navigationRepository.getCurrentRoute();
      await _navigationRepository.trackNavigation(
        currentRoute,
        route,
        metadata: {
          'timestamp': DateTime.now().toIso8601String(),
          'bypassAuth': bypassAuth,
          'hasExtra': extra != null,
          'hasPathParams': pathParameters != null,
          'hasQueryParams': queryParameters != null,
        },
      );

      // Check if route requires authentication (unless bypassed)
      if (!bypassAuth && _navigationRepository.isProtectedRoute(route)) {
        final isAuthenticated = await _authRepository.isAuthenticated();
        
        if (!isAuthenticated) {
          // Store intended route for after login
          final loginResult = await _navigationRepository.navigateToRoute(
            AppRoutes.login,
            extra: {
              'redirectRoute': route,
              'redirectExtra': extra,
              'redirectPathParameters': pathParameters,
              'redirectQueryParameters': queryParameters,
            },
          );
          
          if (loginResult.isSuccess) {
            return NavigationResult.redirectedToLogin(metadata: {
              'intendedRoute': route,
              'redirectedAt': DateTime.now().toIso8601String(),
            });
          } else {
            return loginResult;
          }
        }

        // Additional role-based checks for authenticated users
        final currentUser = await _authRepository.getCurrentUser();
        if (currentUser != null) {
          final hasPermission = await _checkRoutePermissions(route, currentUser);
          if (!hasPermission) {
            return NavigationResult.permissionDenied(
              route,
              metadata: {
                'userId': currentUser.id,
                'userRole': currentUser.role.name,
                'attemptedAt': DateTime.now().toIso8601String(),
              },
            );
          }
        }
      }

      // Validate route parameters
      final validationResult = _validateRouteParameters(
        route,
        pathParameters,
        queryParameters,
      );
      
      if (!validationResult.isValid) {
        return NavigationResult.error(
          'Invalid route parameters: ${validationResult.errors.join(', ')}',
          metadata: {
            'route': route,
            'validation_errors': validationResult.errors,
          },
        );
      }

      // Execute the navigation
      final result = await _navigationRepository.navigateToRoute(
        route,
        extra: extra,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );

      return result;
    } catch (e) {
      return NavigationResult.error(
        'Navigation failed: $e',
        metadata: {
          'route': route,
          'exception': e.toString(),
          'stackTrace': StackTrace.current.toString(),
        },
      );
    }
  }

  /// Execute navigation with replacement (replacing current route)
  Future<NavigationResult> executeWithReplacement(
    String route, {
    Map<String, dynamic>? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Check authentication for protected routes
      if (_navigationRepository.isProtectedRoute(route)) {
        final isAuthenticated = await _authRepository.isAuthenticated();
        if (!isAuthenticated) {
          return NavigationResult.redirectedToLogin(metadata: {
            'intendedRoute': route,
            'navigationType': 'replacement',
          });
        }
      }

      final result = await _navigationRepository.navigateAndReplace(
        route,
        extra: extra,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );

      return result;
    } catch (e) {
      return NavigationResult.error('Navigation replacement failed: $e');
    }
  }

  /// Execute navigation with stack clear (new navigation stack)
  Future<NavigationResult> executeWithStackClear(
    String route, {
    Map<String, dynamic>? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _navigationRepository.navigateAndClearStack(
        route,
        extra: extra,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );

      return result;
    } catch (e) {
      return NavigationResult.error('Navigation with stack clear failed: $e');
    }
  }

  /// Navigate back with validation
  Future<NavigationResult> executeBack() async {
    try {
      if (!_navigationRepository.canNavigateBack()) {
        return NavigationResult.error('Cannot navigate back - no previous route');
      }

      final result = await _navigationRepository.navigateBack();
      return result;
    } catch (e) {
      return NavigationResult.error('Back navigation failed: $e');
    }
  }

  /// Navigate to product detail with validation
  Future<NavigationResult> navigateToProduct(String productId) async {
    if (productId.isEmpty) {
      return NavigationResult.error('Product ID cannot be empty');
    }

    return execute(
      AppRoutes.productDetailRoute(productId),
      extra: {'productId': productId},
    );
  }

  /// Navigate to order detail with validation
  Future<NavigationResult> navigateToOrder(String orderId) async {
    if (orderId.isEmpty) {
      return NavigationResult.error('Order ID cannot be empty');
    }

    return execute(
      AppRoutes.orderDetailRoute(orderId),
      extra: {'orderId': orderId},
    );
  }

  /// Navigate to category with validation
  Future<NavigationResult> navigateToCategory(String category) async {
    if (category.isEmpty) {
      return NavigationResult.error('Category cannot be empty');
    }

    return execute(
      AppRoutes.productCategoryRoute(category),
      extra: {'category': category},
    );
  }

  /// Navigate to search with query
  Future<NavigationResult> navigateToSearch({String? query}) async {
    return execute(
      AppRoutes.search,
      queryParameters: query != null ? {'q': query} : null,
    );
  }

  /// Get current navigation context
  NavigationContext getCurrentContext() {
    return NavigationContext(
      currentRoute: _navigationRepository.getCurrentRoute(),
      currentRouteName: _navigationRepository.getCurrentRouteName(),
      canGoBack: _navigationRepository.canNavigateBack(),
      navigationHistory: _navigationRepository.getNavigationHistory(),
    );
  }

  // Private helper methods

  /// Check if user has permission to access route
  Future<bool> _checkRoutePermissions(String route, User user) async {
    // Admin routes
    if (route.startsWith(AppRoutes.admin)) {
      return user.isAdmin;
    }

    // Moderator routes (if any)
    if (route.contains('/moderate/')) {
      return user.hasElevatedPrivileges;
    }

    // All other protected routes are accessible to authenticated users
    return true;
  }

  /// Validate route parameters
  RouteParameterValidationResult _validateRouteParameters(
    String route,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  ) {
    final errors = <String>[];

    // Validate product ID routes
    if (route.contains(':id')) {
      final id = pathParameters?['id'];
      if (id == null || id.isEmpty) {
        errors.add('Product ID is required');
      } else if (!_isValidId(id)) {
        errors.add('Invalid product ID format');
      }
    }

    // Validate order ID routes
    if (route.contains(':orderId')) {
      final orderId = pathParameters?['orderId'];
      if (orderId == null || orderId.isEmpty) {
        errors.add('Order ID is required');
      } else if (!_isValidId(orderId)) {
        errors.add('Invalid order ID format');
      }
    }

    // Validate category routes
    if (route.contains(':category')) {
      final category = pathParameters?['category'];
      if (category == null || category.isEmpty) {
        errors.add('Category is required');
      }
    }

    return RouteParameterValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Check if ID format is valid
  bool _isValidId(String id) {
    // Simple validation - ID should be alphanumeric and at least 3 characters
    final regex = RegExp(r'^[a-zA-Z0-9_-]{3,}$');
    return regex.hasMatch(id);
  }
}

/// Navigation context for current state
class NavigationContext {
  final String currentRoute;
  final String currentRouteName;
  final bool canGoBack;
  final List<String> navigationHistory;

  const NavigationContext({
    required this.currentRoute,
    required this.currentRouteName,
    required this.canGoBack,
    required this.navigationHistory,
  });

  @override
  String toString() {
    return 'NavigationContext(route: $currentRoute, canGoBack: $canGoBack)';
  }
}

/// Route parameter validation result
class RouteParameterValidationResult {
  final bool isValid;
  final List<String> errors;

  const RouteParameterValidationResult({
    required this.isValid,
    required this.errors,
  });

  String get errorMessage => errors.join(', ');
}

/// Navigation flow use case for complex navigation sequences
class NavigationFlowUseCase {
  final NavigateToRouteUseCase _navigateToRouteUseCase;

  const NavigationFlowUseCase(this._navigateToRouteUseCase);

  /// Execute checkout flow
  Future<NavigationResult> executeCheckoutFlow({
    Map<String, dynamic>? checkoutData,
  }) async {
    // Navigate to cart first to review items
    final cartResult = await _navigateToRouteUseCase.execute(AppRoutes.cart);
    if (!cartResult.isSuccess) return cartResult;

    // Then navigate to checkout
    return _navigateToRouteUseCase.execute(
      AppRoutes.checkout,
      extra: checkoutData,
    );
  }

  /// Execute onboarding flow
  Future<NavigationResult> executeOnboardingFlow() async {
    return _navigateToRouteUseCase.executeWithStackClear(
      AppRoutes.onboarding,
    );
  }

  /// Execute post-login flow
  Future<NavigationResult> executePostLoginFlow({
    String? redirectRoute,
    Map<String, dynamic>? redirectExtra,
  }) async {
    if (redirectRoute != null) {
      return _navigateToRouteUseCase.executeWithReplacement(
        redirectRoute,
        extra: redirectExtra,
      );
    }

    return _navigateToRouteUseCase.executeWithReplacement(AppRoutes.home);
  }

  /// Execute logout flow
  Future<NavigationResult> executeLogoutFlow() async {
    return _navigateToRouteUseCase.executeWithStackClear(AppRoutes.home);
  }
}