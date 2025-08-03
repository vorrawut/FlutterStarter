/// Application route constants with type-safe route definitions
class AppRoutes {
  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  
  // Authentication routes
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // Main app routes (with shell navigation)
  static const String home = '/home';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String profile = '/profile';
  
  // Product routes
  static const String productDetail = '/products/:id';
  static const String productSearch = '/products/search';
  static const String productCategory = '/products/category/:category';
  static const String productReviews = '/products/:id/reviews';
  
  // Profile sub-routes
  static const String profileSettings = '/profile/settings';
  static const String profileOrders = '/profile/orders';
  static const String profileOrderDetail = '/profile/orders/:orderId';
  static const String profileFavorites = '/profile/favorites';
  static const String profileAddresses = '/profile/addresses';
  static const String profilePaymentMethods = '/profile/payment-methods';
  static const String profileNotifications = '/profile/notifications';
  
  // Shopping flow routes
  static const String checkout = '/checkout';
  static const String checkoutPayment = '/checkout/payment';
  static const String checkoutConfirmation = '/checkout/confirmation';
  static const String orderSuccess = '/order-success';
  static const String orderTracking = '/order-tracking/:orderId';
  
  // Utility routes
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  
  // Admin routes (for demo purposes)
  static const String admin = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String adminUsers = '/admin/users';
  
  // Error routes
  static const String notFound = '/404';
  static const String error = '/error';
  
  /// Get all protected routes that require authentication
  static List<String> get protectedRoutes => [
    profile,
    profileSettings,
    profileOrders,
    profileOrderDetail,
    profileFavorites,
    profileAddresses,
    profilePaymentMethods,
    profileNotifications,
    cart,
    checkout,
    checkoutPayment,
    checkoutConfirmation,
    orderSuccess,
    orderTracking,
    admin,
    adminProducts,
    adminOrders,
    adminUsers,
  ];
  
  /// Get all public routes that don't require authentication
  static List<String> get publicRoutes => [
    splash,
    onboarding,
    auth,
    login,
    register,
    forgotPassword,
    resetPassword,
    home,
    products,
    productDetail,
    productSearch,
    productCategory,
    productReviews,
    search,
    help,
    about,
    privacyPolicy,
    termsOfService,
    notFound,
    error,
  ];
  
  /// Check if a route requires authentication
  static bool isProtectedRoute(String route) {
    return protectedRoutes.any((protectedRoute) => 
      route.startsWith(protectedRoute.split(':')[0]));
  }
  
  /// Check if a route is public
  static bool isPublicRoute(String route) {
    return publicRoutes.any((publicRoute) => 
      route.startsWith(publicRoute.split(':')[0]));
  }
  
  /// Get route name from path
  static String getRouteName(String path) {
    final routeMap = {
      splash: 'Splash',
      onboarding: 'Onboarding',
      login: 'Login',
      register: 'Register',
      forgotPassword: 'Forgot Password',
      resetPassword: 'Reset Password',
      home: 'Home',
      products: 'Products',
      cart: 'Cart',
      profile: 'Profile',
      productDetail: 'Product Detail',
      productSearch: 'Search Products',
      productCategory: 'Product Category',
      profileSettings: 'Settings',
      profileOrders: 'My Orders',
      profileFavorites: 'Favorites',
      checkout: 'Checkout',
      orderSuccess: 'Order Success',
      search: 'Search',
      notifications: 'Notifications',
      help: 'Help',
      about: 'About',
    };
    
    // Find matching route pattern
    for (final entry in routeMap.entries) {
      if (path.startsWith(entry.key.split(':')[0])) {
        return entry.value;
      }
    }
    
    return 'Unknown';
  }
  
  /// Generate product detail route
  static String productDetailRoute(String productId) {
    return productDetail.replaceAll(':id', productId);
  }
  
  /// Generate product category route
  static String productCategoryRoute(String category) {
    return productCategory.replaceAll(':category', category);
  }
  
  /// Generate order detail route
  static String orderDetailRoute(String orderId) {
    return profileOrderDetail.replaceAll(':orderId', orderId);
  }
  
  /// Generate order tracking route
  static String orderTrackingRoute(String orderId) {
    return orderTracking.replaceAll(':orderId', orderId);
  }
}

/// Navigation tab indices for bottom navigation
class NavigationTabIndex {
  static const int home = 0;
  static const int products = 1;
  static const int cart = 2;
  static const int profile = 3;
  
  static const List<int> validIndices = [home, products, cart, profile];
  
  /// Get route for tab index
  static String getRouteForIndex(int index) {
    switch (index) {
      case home:
        return AppRoutes.home;
      case products:
        return AppRoutes.products;
      case cart:
        return AppRoutes.cart;
      case profile:
        return AppRoutes.profile;
      default:
        return AppRoutes.home;
    }
  }
  
  /// Get tab index for route
  static int getIndexForRoute(String route) {
    if (route.startsWith(AppRoutes.home)) return home;
    if (route.startsWith(AppRoutes.products)) return products;
    if (route.startsWith(AppRoutes.cart)) return cart;
    if (route.startsWith(AppRoutes.profile)) return profile;
    return home;
  }
}

/// Route transition types
enum RouteTransitionType {
  fade,
  slide,
  scale,
  rotation,
  slideFromBottom,
  slideFromTop,
  slideFromLeft,
  slideFromRight,
}

/// Route configuration metadata
class RouteMetadata {
  final String title;
  final bool showAppBar;
  final bool showBottomNavigation;
  final bool showDrawer;
  final RouteTransitionType transitionType;
  final Duration transitionDuration;
  final bool maintainState;
  final bool fullScreen;

  const RouteMetadata({
    required this.title,
    this.showAppBar = true,
    this.showBottomNavigation = true,
    this.showDrawer = true,
    this.transitionType = RouteTransitionType.slide,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.maintainState = true,
    this.fullScreen = false,
  });
}

/// Route metadata definitions
class AppRouteMetadata {
  static const Map<String, RouteMetadata> metadata = {
    AppRoutes.splash: RouteMetadata(
      title: 'FlutterShop',
      showAppBar: false,
      showBottomNavigation: false,
      showDrawer: false,
      fullScreen: true,
    ),
    AppRoutes.login: RouteMetadata(
      title: 'Login',
      showAppBar: false,
      showBottomNavigation: false,
      showDrawer: false,
    ),
    AppRoutes.register: RouteMetadata(
      title: 'Register',
      showAppBar: false,
      showBottomNavigation: false,
      showDrawer: false,
    ),
    AppRoutes.home: RouteMetadata(
      title: 'FlutterShop',
      showAppBar: true,
      showBottomNavigation: true,
      showDrawer: true,
    ),
    AppRoutes.products: RouteMetadata(
      title: 'Products',
      showAppBar: true,
      showBottomNavigation: true,
      showDrawer: true,
    ),
    AppRoutes.cart: RouteMetadata(
      title: 'Shopping Cart',
      showAppBar: true,
      showBottomNavigation: true,
      showDrawer: true,
    ),
    AppRoutes.profile: RouteMetadata(
      title: 'Profile',
      showAppBar: true,
      showBottomNavigation: true,
      showDrawer: true,
    ),
    AppRoutes.checkout: RouteMetadata(
      title: 'Checkout',
      showAppBar: true,
      showBottomNavigation: false,
      showDrawer: false,
    ),
  };
  
  /// Get metadata for route
  static RouteMetadata getMetadata(String route) {
    return metadata[route] ?? const RouteMetadata(title: 'FlutterShop');
  }
}