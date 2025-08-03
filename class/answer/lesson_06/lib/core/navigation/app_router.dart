import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_routes.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/screens/main/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/main/main_navigation_shell.dart';
import '../../presentation/screens/main/home_screen.dart';
import '../../presentation/screens/product/product_list_screen.dart';
import '../../presentation/screens/product/product_detail_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/profile_settings_screen.dart';
import '../../presentation/screens/profile/order_history_screen.dart';
import '../../presentation/screens/main/error_screen.dart';

/// App router configuration using GoRouter
/// Implements declarative navigation with clean architecture
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = 
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = 
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Create the router configuration
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      routes: _buildRoutes(),
      redirect: _handleGlobalRedirects,
      errorBuilder: (context, state) => ErrorScreen(
        error: state.error?.toString() ?? 'Unknown error',
        route: state.uri.toString(),
      ),
    );
  }

  /// Build route definitions
  static List<RouteBase> _buildRoutes() {
    return [
      // Splash route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Authentication routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          final redirectRoute = state.uri.queryParameters['redirect'];
          return LoginScreen(redirectRoute: redirectRoute);
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationShell(child: child);
        },
        routes: [
          // Home route
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),

          // Products routes with sub-routes
          GoRoute(
            path: AppRoutes.products,
            name: 'products',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProductListScreen(),
            ),
            routes: [
              // Product detail route
              GoRoute(
                path: '/:id',
                name: 'product-detail',
                builder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return ProductDetailScreen(productId: productId);
                },
              ),
              // Product search route
              GoRoute(
                path: '/search',
                name: 'product-search',
                builder: (context, state) {
                  final query = state.uri.queryParameters['q'];
                  return ProductListScreen(
                    searchQuery: query,
                    isSearchMode: true,
                  );
                },
              ),
              // Product category route
              GoRoute(
                path: '/category/:category',
                name: 'product-category',
                builder: (context, state) {
                  final category = state.pathParameters['category']!;
                  return ProductListScreen(
                    category: category,
                    isCategoryMode: true,
                  );
                },
              ),
            ],
          ),

          // Cart route
          GoRoute(
            path: AppRoutes.cart,
            name: 'cart',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CartScreen(),
            ),
            routes: [
              // Checkout route (outside shell)
              GoRoute(
                path: '/checkout',
                name: 'checkout',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  return const CheckoutScreen();
                },
                routes: [
                  GoRoute(
                    path: '/payment',
                    name: 'checkout-payment',
                    builder: (context, state) {
                      return const CheckoutPaymentScreen();
                    },
                  ),
                  GoRoute(
                    path: '/confirmation',
                    name: 'checkout-confirmation',
                    builder: (context, state) {
                      return const CheckoutConfirmationScreen();
                    },
                  ),
                ],
              ),
            ],
          ),

          // Profile routes with sub-routes
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
            routes: [
              // Profile settings
              GoRoute(
                path: '/settings',
                name: 'profile-settings',
                builder: (context, state) => const ProfileSettingsScreen(),
              ),
              // Order history
              GoRoute(
                path: '/orders',
                name: 'profile-orders',
                builder: (context, state) => const OrderHistoryScreen(),
              ),
              // Order detail
              GoRoute(
                path: '/orders/:orderId',
                name: 'order-detail',
                builder: (context, state) {
                  final orderId = state.pathParameters['orderId']!;
                  return OrderDetailScreen(orderId: orderId);
                },
              ),
              // Favorites
              GoRoute(
                path: '/favorites',
                name: 'profile-favorites',
                builder: (context, state) => const FavoritesScreen(),
              ),
              // Addresses
              GoRoute(
                path: '/addresses',
                name: 'profile-addresses',
                builder: (context, state) => const AddressesScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone routes (outside shell)
      GoRoute(
        path: AppRoutes.orderSuccess,
        name: 'order-success',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'];
          return OrderSuccessScreen(orderId: orderId);
        },
      ),

      // Search route (standalone)
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return SearchScreen(initialQuery: query);
        },
      ),

      // Help and support routes
      GoRoute(
        path: AppRoutes.help,
        name: 'help',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),
    ];
  }

  /// Handle global redirects for authentication
  static String? _handleGlobalRedirects(BuildContext context, GoRouterState state) {
    try {
      final authController = context.read<AuthController>();
      final isLoggedIn = authController.isAuthenticated;
      final isOnAuthPage = _isAuthenticationPage(state.uri.path);
      final isOnSplashPage = state.uri.path == AppRoutes.splash;

      // Don't redirect from splash page - let it handle the logic
      if (isOnSplashPage) return null;

      // Don't redirect on error page
      if (state.uri.path == AppRoutes.error) return null;

      // Redirect to login if accessing protected route while not authenticated
      if (!isLoggedIn && _isProtectedRoute(state.uri.path) && !isOnAuthPage) {
        final currentRoute = Uri.encodeComponent(state.uri.toString());
        return '${AppRoutes.login}?redirect=$currentRoute';
      }

      // Redirect to home if already logged in and on auth page
      if (isLoggedIn && isOnAuthPage) {
        return AppRoutes.home;
      }

      return null; // No redirect needed
    } catch (e) {
      // If context.read fails (e.g., during app startup), don't redirect
      return null;
    }
  }

  /// Check if route is an authentication page
  static bool _isAuthenticationPage(String path) {
    return [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
      AppRoutes.resetPassword,
    ].contains(path);
  }

  /// Check if route requires authentication
  static bool _isProtectedRoute(String path) {
    return AppRoutes.isProtectedRoute(path);
  }

  /// Get current route from GoRouter
  static String getCurrentRoute(GoRouter router) {
    final RouteMatch lastMatch = router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch 
        ? lastMatch.matches 
        : router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  /// Check if can navigate back
  static bool canNavigateBack(GoRouter router) {
    return router.canPop();
  }

  /// Navigate to route with type safety
  static void navigateToRoute(
    BuildContext context,
    String route, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    final uri = Uri.parse(route);
    final pathWithParams = _buildPathWithParameters(
      uri.path,
      pathParameters,
    );
    
    final queryParams = <String, dynamic>{
      ...uri.queryParameters,
      if (queryParameters != null) ...queryParameters,
    };

    if (queryParams.isNotEmpty) {
      context.go(
        Uri(path: pathWithParams, queryParameters: queryParams).toString(),
        extra: extra,
      );
    } else {
      context.go(pathWithParams, extra: extra);
    }
  }

  /// Push route (for modal navigation)
  static void pushRoute(
    BuildContext context,
    String route, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    final uri = Uri.parse(route);
    final pathWithParams = _buildPathWithParameters(
      uri.path,
      pathParameters,
    );
    
    final queryParams = <String, dynamic>{
      ...uri.queryParameters,
      if (queryParameters != null) ...queryParameters,
    };

    if (queryParams.isNotEmpty) {
      context.push(
        Uri(path: pathWithParams, queryParameters: queryParams).toString(),
        extra: extra,
      );
    } else {
      context.push(pathWithParams, extra: extra);
    }
  }

  /// Replace current route
  static void replaceRoute(
    BuildContext context,
    String route, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    final uri = Uri.parse(route);
    final pathWithParams = _buildPathWithParameters(
      uri.path,
      pathParameters,
    );
    
    final queryParams = <String, dynamic>{
      ...uri.queryParameters,
      if (queryParameters != null) ...queryParameters,
    };

    if (queryParams.isNotEmpty) {
      context.go(
        Uri(path: pathWithParams, queryParameters: queryParams).toString(),
        extra: extra,
      );
    } else {
      context.go(pathWithParams, extra: extra);
    }
  }

  /// Navigate back
  static void navigateBack(BuildContext context) {
    if (canNavigateBack(GoRouter.of(context))) {
      context.pop();
    }
  }

  /// Build path with parameters
  static String _buildPathWithParameters(
    String path,
    Map<String, String>? pathParameters,
  ) {
    if (pathParameters == null || pathParameters.isEmpty) {
      return path;
    }

    String result = path;
    pathParameters.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    
    return result;
  }

  /// Get route name from path
  static String getRouteName(String path) {
    return AppRoutes.getRouteName(path);
  }

  /// Get navigation context
  static NavigationContext getNavigationContext(BuildContext context) {
    final router = GoRouter.of(context);
    return NavigationContext(
      currentRoute: getCurrentRoute(router),
      canGoBack: canNavigateBack(router),
    );
  }
}

/// Navigation context for current state
class NavigationContext {
  final String currentRoute;
  final bool canGoBack;

  const NavigationContext({
    required this.currentRoute,
    required this.canGoBack,
  });

  @override
  String toString() {
    return 'NavigationContext(currentRoute: $currentRoute, canGoBack: $canGoBack)';
  }
}

/// Extension methods for easier navigation
extension GoRouterExtension on BuildContext {
  /// Navigate to named route
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    GoRouter.of(this).goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push named route
  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return GoRouter.of(this).pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}

// Placeholder screens (to be implemented)
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Checkout')));
}

class CheckoutPaymentScreen extends StatelessWidget {
  const CheckoutPaymentScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Payment')));
}

class CheckoutConfirmationScreen extends StatelessWidget {
  const CheckoutConfirmationScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Confirmation')));
}

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Order: $orderId')));
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Favorites')));
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Addresses')));
}

class OrderSuccessScreen extends StatelessWidget {
  final String? orderId;
  const OrderSuccessScreen({super.key, this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Success: $orderId')));
}

class SearchScreen extends StatelessWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Search: $initialQuery')));
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Help')));
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('About')));
}