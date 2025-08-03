import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

// Data layer
import 'data/datasources/auth_datasource.dart';
import 'data/datasources/navigation_datasource.dart';
import 'data/datasources/product_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/navigation_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';

// Domain layer
import 'domain/usecases/authenticate_user_usecase.dart';
import 'domain/usecases/navigate_to_route_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';

// Presentation layer
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/navigation_controller.dart';
import 'presentation/controllers/product_controller.dart';
import 'presentation/controllers/cart_controller.dart';

/// Main application entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const FlutterShopApp());
}

/// Main application widget with dependency injection
class FlutterShopApp extends StatelessWidget {
  const FlutterShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _createProviders(),
      child: Consumer<AuthController>(
        builder: (context, authController, child) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            
            // Router configuration
            routerConfig: AppRouter.createRouter(),
            
            // Builder for additional setup
            builder: (context, child) {
              return MediaQuery(
                // Ensure text scaling doesn't break layouts
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }

  /// Create dependency injection providers
  List<ChangeNotifierProvider> _createProviders() {
    // Initialize data sources
    final authDataSource = LocalAuthDataSource();
    final navigationDataSource = LocalNavigationDataSource();
    final productDataSource = LocalProductDataSource();

    // Initialize repositories
    final authRepository = AuthRepositoryImpl(authDataSource);
    final navigationRepository = NavigationRepositoryImpl(navigationDataSource);
    final productRepository = ProductRepositoryImpl(productDataSource);

    // Initialize use cases
    final authenticateUserUseCase = AuthenticateUserUseCase(
      authRepository,
      navigationRepository,
    );
    final navigateToRouteUseCase = NavigateToRouteUseCase(
      navigationRepository,
      authRepository,
    );
    final getProductsUseCase = GetProductsUseCase(productRepository);

    // Create controllers with dependencies
    return [
      // Auth controller - must be first for router dependency
      ChangeNotifierProvider<AuthController>(
        create: (_) => AuthController(authenticateUserUseCase),
      ),
      
      // Navigation controller
      ChangeNotifierProvider<NavigationController>(
        create: (_) => NavigationController(
          navigateToRouteUseCase,
          navigationRepository,
        ),
      ),
      
      // Product controller
      ChangeNotifierProvider<ProductController>(
        create: (_) => ProductController(getProductsUseCase),
      ),
      
      // Cart controller
      ChangeNotifierProvider<CartController>(
        create: (_) => CartController(),
      ),
    ];
  }
}

/// App theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: AppConstants.fontFamily,
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarTheme(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.neutral500,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space2xl,
            vertical: AppConstants.spaceLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space2xl,
            vertical: AppConstants.spaceLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLg,
            vertical: AppConstants.spaceMd,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceLg,
          vertical: AppConstants.spaceLg,
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      
      // Drawer theme
      drawerTheme: DrawerThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppConstants.radiusXl),
            bottomRight: Radius.circular(AppConstants.radiusXl),
          ),
        ),
        elevation: 8,
        width: AppConstants.drawerWidth,
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        ),
        elevation: 8,
      ),
      
      // Snack bar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        contentTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      fontFamily: AppConstants.fontFamily,
      
      // Dark theme specific configurations
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarTheme(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedItemColor: AppColors.primary,
        backgroundColor: AppColors.neutral900,
      ),
    );
  }
}

/// Global error handling
class AppErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log error for debugging
    debugPrint('Error: $error');
    debugPrint('Stack trace: $stackTrace');
    
    // In production, send to crash reporting service
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}

/// App configuration
class AppConfig {
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );
  
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.fluttershop.dev',
  );
  
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
}

// Placeholder classes for missing implementations
class LocalAuthDataSource {}
class LocalNavigationDataSource {}
class LocalProductDataSource {}
class AuthRepositoryImpl {
  AuthRepositoryImpl(LocalAuthDataSource dataSource);
}
class NavigationRepositoryImpl {
  NavigationRepositoryImpl(LocalNavigationDataSource dataSource);
}
class ProductRepositoryImpl {
  ProductRepositoryImpl(LocalProductDataSource dataSource);
}
class GetProductsUseCase {
  GetProductsUseCase(ProductRepositoryImpl repository);
}
class AuthController extends ChangeNotifier {
  final AuthenticateUserUseCase _useCase;
  AuthController(this._useCase);
  bool get isAuthenticated => false; // Placeholder
}
class NavigationController extends ChangeNotifier {
  NavigationController(NavigateToRouteUseCase useCase, NavigationRepositoryImpl repository);
}
class ProductController extends ChangeNotifier {
  ProductController(GetProductsUseCase useCase);
}
class CartController extends ChangeNotifier {}