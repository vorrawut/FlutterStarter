import 'package:flutter/material.dart';

/// Application-wide constants following design system principles
class AppConstants {
  // App Information
  static const String appName = 'FlutterShop';
  static const String appVersion = '1.0.0';
  static const String fontFamily = 'Inter';

  // Spacing Scale (8pt grid system)
  static const double spaceXs = 4.0;   // 4px
  static const double spaceSm = 8.0;   // 8px
  static const double spaceMd = 12.0;  // 12px
  static const double spaceLg = 16.0;  // 16px
  static const double spaceXl = 20.0;  // 20px
  static const double space2xl = 24.0; // 24px
  static const double space3xl = 32.0; // 32px
  static const double space4xl = 40.0; // 40px
  static const double space5xl = 48.0; // 48px
  static const double space6xl = 64.0; // 64px

  // Border Radius Scale
  static const double radiusXs = 2.0;  // 2px
  static const double radiusSm = 4.0;  // 4px
  static const double radiusMd = 8.0;  // 8px
  static const double radiusLg = 12.0; // 12px
  static const double radiusXl = 16.0; // 16px
  static const double radius2xl = 24.0; // 24px
  static const double radius3xl = 32.0; // 32px

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Breakpoints for responsive design
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointLargeDesktop = 1440.0;

  // Layout Constants
  static const double maxContentWidth = 1200.0;
  static const double cardAspectRatio = 1.2;
  static const int maxGridColumns = 4;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Navigation Constants
  static const double bottomNavHeight = 80.0;
  static const double appBarHeight = 56.0;
  static const double drawerWidth = 280.0;

  // Product Constants
  static const int productsPerPage = 20;
  static const double productImageAspectRatio = 1.0;
  static const int maxCartItems = 99;

  // Animation Constants
  static const double parallaxMultiplier = 0.5;
  static const double scaleAnimationFactor = 0.95;

  // Shadow Definitions
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 25,
          offset: const Offset(0, 15),
        ),
      ];

  // Z-Index Constants
  static const int zIndexBase = 0;
  static const int zIndexDropdown = 1000;
  static const int zIndexModal = 2000;
  static const int zIndexTooltip = 3000;
  static const int zIndexToast = 4000;
}

/// App color constants
class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF10B981);
  static const Color accent = Color(0xFF8B5CF6);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFFBF00);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);
  
  // E-commerce specific colors
  static const Color addToCartButton = Color(0xFF059669);
  static const Color buyNowButton = Color(0xFFDC2626);
  static const Color favoriteColor = Color(0xFFE11D48);
  static const Color ratingColor = Color(0xFFFBBF24);
  
  // Neutral colors
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);
}

/// Screen size categories for responsive design
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Extension to get screen size from width
extension ScreenSizeExtension on double {
  ScreenSize get screenSize {
    if (this < AppConstants.breakpointMobile) return ScreenSize.mobile;
    if (this < AppConstants.breakpointTablet) return ScreenSize.tablet;
    if (this < AppConstants.breakpointDesktop) return ScreenSize.desktop;
    return ScreenSize.largeDesktop;
  }
}

/// Common string constants
class AppStrings {
  // App
  static const String appName = 'FlutterShop';
  static const String appSlogan = 'Your one-stop shopping destination';

  // Navigation
  static const String homeTab = 'Home';
  static const String productsTab = 'Products';
  static const String cartTab = 'Cart';
  static const String profileTab = 'Profile';

  // Authentication
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';

  // Product
  static const String products = 'Products';
  static const String productDetails = 'Product Details';
  static const String addToCart = 'Add to Cart';
  static const String buyNow = 'Buy Now';
  static const String outOfStock = 'Out of Stock';
  static const String inStock = 'In Stock';
  static const String reviews = 'Reviews';
  static const String description = 'Description';

  // Cart
  static const String cart = 'Cart';
  static const String checkout = 'Checkout';
  static const String emptyCart = 'Your cart is empty';
  static const String continueShopping = 'Continue Shopping';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
  static const String shipping = 'Shipping';
  static const String tax = 'Tax';

  // Profile
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String orders = 'Orders';
  static const String favorites = 'Favorites';
  static const String addresses = 'Addresses';
  static const String paymentMethods = 'Payment Methods';
  static const String notifications = 'Notifications';

  // Common
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';

  // Error Messages
  static const String networkError = 'Network error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String authenticationError = 'Authentication failed';
  static const String permissionDenied = 'Permission denied';
  static const String notFound = 'Not found';

  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String addedToCart = 'Added to cart';
  static const String orderPlaced = 'Order placed successfully';
}

/// Product categories
enum ProductCategory {
  electronics('Electronics'),
  clothing('Clothing'),
  books('Books'),
  home('Home & Garden'),
  sports('Sports & Outdoors'),
  beauty('Beauty & Personal Care'),
  toys('Toys & Games'),
  automotive('Automotive');

  const ProductCategory(this.displayName);
  final String displayName;
}

/// Order status enumeration
enum OrderStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  processing('Processing'),
  shipped('Shipped'),
  delivered('Delivered'),
  cancelled('Cancelled'),
  refunded('Refunded');

  const OrderStatus(this.displayName);
  final String displayName;
}

/// Payment status enumeration
enum PaymentStatus {
  pending('Pending'),
  processing('Processing'),
  completed('Completed'),
  failed('Failed'),
  refunded('Refunded');

  const PaymentStatus(this.displayName);
  final String displayName;
}