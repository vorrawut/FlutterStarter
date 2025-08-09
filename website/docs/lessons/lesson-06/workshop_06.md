# 🛠️ Workshop 6: Navigation & Routing Masterclass

## 🎯 **What We're Building**

A comprehensive **multi-screen e-commerce application** called **"FlutterShop"** that demonstrates professional navigation patterns, clean architecture, and modern routing techniques. This application will feature:

- **🏠 Home Screen** with product categories and featured items
- **🛍️ Product Catalog** with search and filtering
- **📱 Product Details** with image gallery and reviews
- **🛒 Shopping Cart** with checkout flow
- **👤 User Profile** with settings and order history
- **🔐 Authentication** with login and registration
- **🧭 Professional Navigation** with tabs, drawers, and deep linking

## ✅ **Expected Outcome**

By the end of this workshop, you'll have built a production-ready Flutter application that demonstrates:

- ✅ **Clean Navigation Architecture** - Repository pattern for navigation
- ✅ **Multi-Screen Management** - Complex navigation flows
- ✅ **Route Guards** - Authentication-based navigation
- ✅ **Deep Linking** - URL-based navigation support
- ✅ **Navigation State** - Centralized navigation management
- ✅ **Professional UI** - Tabs, drawers, and custom transitions
- ✅ **Testing Strategy** - Testable navigation components

## 👨‍💻 **Steps to Complete**

### **📁 Step 1: Project Setup & Architecture**

#### **1.1 Create Clean Architecture Structure**
```bash
mkdir -p lib/{core/{constants,theme,utils,navigation},data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{controllers,screens,widgets}}
```

#### **1.2 Set Up Dependencies**
Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  equatable: ^2.0.5
  go_router: ^12.1.3  # Modern navigation solution
  shared_preferences: ^2.2.2
```

#### **1.3 Create Navigation Constants**
```dart
// lib/core/constants/app_routes.dart
class AppRoutes {
  // Main routes
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  
  // Product routes
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String productSearch = '/products/search';
  
  // User routes
  static const String profile = '/profile';
  static const String profileSettings = '/profile/settings';
  static const String profileOrders = '/profile/orders';
  
  // Shopping routes
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
}
```

### **📱 Step 2: Domain Layer - Navigation Entities**

#### **2.1 Create Navigation Entities**
```dart
// lib/domain/entities/navigation_item.dart
class NavigationItem extends Equatable {
  final String route;
  final String title;
  final IconData icon;
  final bool requiresAuth;
  final List<NavigationItem>? children;

  const NavigationItem({
    required this.route,
    required this.title,
    required this.icon,
    this.requiresAuth = false,
    this.children,
  });

  @override
  List<Object?> get props => [route, title, icon, requiresAuth, children];
}
```

#### **2.2 Create User Authentication Entity**
```dart
// lib/domain/entities/user.dart
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isVerified;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl, isVerified];
}
```

#### **2.3 Create Product Entity**
```dart
// lib/domain/entities/product.dart
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String category;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.reviewCount,
  });

  @override
  List<Object?> get props => [
    id, name, description, price, imageUrls, category, rating, reviewCount
  ];
}
```

### **🗄️ Step 3: Data Layer - Navigation Repository**

#### **3.1 Create Navigation Repository Interface**
```dart
// lib/domain/repositories/navigation_repository.dart
abstract class NavigationRepository {
  Future<void> navigateToRoute(String route, {Map<String, dynamic>? extra});
  Future<void> navigateBack();
  Future<void> navigateAndReplace(String route, {Map<String, dynamic>? extra});
  Future<void> navigateAndClearStack(String route, {Map<String, dynamic>? extra});
  String getCurrentRoute();
  bool canNavigateBack();
  List<NavigationItem> getMainNavigationItems();
  List<NavigationItem> getDrawerNavigationItems();
}
```

#### **3.2 Implement Navigation Repository**
```dart
// lib/data/repositories/navigation_repository_impl.dart
class NavigationRepositoryImpl implements NavigationRepository {
  final GoRouter _goRouter;
  
  NavigationRepositoryImpl(this._goRouter);

  @override
  Future<void> navigateToRoute(String route, {Map<String, dynamic>? extra}) async {
    _goRouter.go(route, extra: extra);
  }

  @override
  Future<void> navigateBack() async {
    if (_goRouter.canPop()) {
      _goRouter.pop();
    }
  }

  @override
  String getCurrentRoute() {
    return _goRouter.routerDelegate.currentConfiguration.uri.toString();
  }

  @override
  List<NavigationItem> getMainNavigationItems() {
    return [
      NavigationItem(
        route: AppRoutes.home,
        title: 'Home',
        icon: Icons.home,
      ),
      NavigationItem(
        route: AppRoutes.products,
        title: 'Products',
        icon: Icons.shopping_bag,
      ),
      NavigationItem(
        route: AppRoutes.cart,
        title: 'Cart',
        icon: Icons.shopping_cart,
      ),
      NavigationItem(
        route: AppRoutes.profile,
        title: 'Profile',
        icon: Icons.person,
        requiresAuth: true,
      ),
    ];
  }
}
```

### **🎯 Step 4: Use Cases - Navigation Logic**

#### **4.1 Create Navigation Use Cases**
```dart
// lib/domain/usecases/navigate_to_route_usecase.dart
class NavigateToRouteUseCase {
  final NavigationRepository _navigationRepository;
  final AuthRepository _authRepository;

  NavigateToRouteUseCase(this._navigationRepository, this._authRepository);

  Future<NavigationResult> execute(String route, {Map<String, dynamic>? extra}) async {
    try {
      // Check if route requires authentication
      if (_requiresAuth(route)) {
        final user = await _authRepository.getCurrentUser();
        if (user == null) {
          await _navigationRepository.navigateToRoute(AppRoutes.login);
          return NavigationResult.redirectedToLogin();
        }
      }

      await _navigationRepository.navigateToRoute(route, extra: extra);
      return NavigationResult.success();
    } catch (e) {
      return NavigationResult.error(e.toString());
    }
  }

  bool _requiresAuth(String route) {
    final protectedRoutes = [
      AppRoutes.profile,
      AppRoutes.profileSettings,
      AppRoutes.profileOrders,
      AppRoutes.cart,
      AppRoutes.checkout,
    ];
    return protectedRoutes.contains(route);
  }
}
```

#### **4.2 Create Authentication Use Case**
```dart
// lib/domain/usecases/authenticate_user_usecase.dart
class AuthenticateUserUseCase {
  final AuthRepository _authRepository;
  final NavigationRepository _navigationRepository;

  AuthenticateUserUseCase(this._authRepository, this._navigationRepository);

  Future<AuthResult> login(String email, String password) async {
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        // Navigate to home after successful login
        await _navigationRepository.navigateAndReplace(AppRoutes.home);
        return AuthResult.success(user);
      } else {
        return AuthResult.error('Invalid credentials');
      }
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _navigationRepository.navigateAndClearStack(AppRoutes.login);
  }
}
```

### **🎨 Step 5: Presentation Layer - Navigation Setup**

#### **5.1 Create App Router Configuration**
```dart
// lib/core/navigation/app_router.dart
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      routes: [
        // Splash route
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),

        // Authentication routes
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
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
              builder: (context, state) => const HomeScreen(),
            ),

            // Products routes
            GoRoute(
              path: AppRoutes.products,
              builder: (context, state) => const ProductListScreen(),
              routes: [
                GoRoute(
                  path: '/:id',
                  builder: (context, state) {
                    final productId = state.pathParameters['id']!;
                    return ProductDetailScreen(productId: productId);
                  },
                ),
              ],
            ),

            // Cart route
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),

            // Profile routes
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) => const ProfileSettingsScreen(),
                ),
                GoRoute(
                  path: '/orders',
                  builder: (context, state) => const OrderHistoryScreen(),
                ),
              ],
            ),
          ],
        ),

        // Checkout flow
        GoRoute(
          path: AppRoutes.checkout,
          builder: (context, state) => const CheckoutScreen(),
        ),
      ],
      redirect: (context, state) {
        // Handle authentication redirects
        return _handleAuthRedirect(context, state);
      },
    );
  }

  static String? _handleAuthRedirect(BuildContext context, GoRouterState state) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final isLoggedIn = authController.isAuthenticated;
    final isOnAuthPage = [AppRoutes.login, AppRoutes.register].contains(state.uri.path);

    // Redirect to login if accessing protected route while not authenticated
    if (!isLoggedIn && !isOnAuthPage && _isProtectedRoute(state.uri.path)) {
      return AppRoutes.login;
    }

    // Redirect to home if already logged in and on auth page
    if (isLoggedIn && isOnAuthPage) {
      return AppRoutes.home;
    }

    return null; // No redirect needed
  }

  static bool _isProtectedRoute(String path) {
    final protectedRoutes = [
      AppRoutes.profile,
      AppRoutes.profileSettings,
      AppRoutes.profileOrders,
      AppRoutes.cart,
      AppRoutes.checkout,
    ];
    return protectedRoutes.any((route) => path.startsWith(route));
  }
}
```

#### **5.2 Create Navigation Controller**
```dart
// lib/presentation/controllers/navigation_controller.dart
class NavigationController extends ChangeNotifier {
  final NavigateToRouteUseCase _navigateToRouteUseCase;
  final GetNavigationItemsUseCase _getNavigationItemsUseCase;

  NavigationController(
    this._navigateToRouteUseCase,
    this._getNavigationItemsUseCase,
  );

  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<NavigationItem> get bottomNavItems => _getNavigationItemsUseCase.getBottomNavItems();
  List<NavigationItem> get drawerItems => _getNavigationItemsUseCase.getDrawerItems();

  void updateCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Future<void> navigateToRoute(String route, {Map<String, dynamic>? extra}) async {
    _setLoading(true);
    _clearError();

    final result = await _navigateToRouteUseCase.execute(route, extra: extra);
    
    if (result.isSuccess) {
      // Update current index based on route
      _updateIndexFromRoute(route);
    } else {
      _setError(result.errorMessage);
    }

    _setLoading(false);
  }

  void _updateIndexFromRoute(String route) {
    final routes = [AppRoutes.home, AppRoutes.products, AppRoutes.cart, AppRoutes.profile];
    final index = routes.indexOf(route);
    if (index != -1) {
      _currentIndex = index;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
```

### **📱 Step 6: UI Implementation - Main Navigation Shell**

#### **6.1 Create Main Navigation Shell**
```dart
// lib/presentation/screens/main_navigation_shell.dart
class MainNavigationShell extends StatefulWidget {
  final Widget child;

  const MainNavigationShell({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, navigationController, _) {
        return Scaffold(
          appBar: _buildAppBar(context),
          drawer: _buildNavigationDrawer(context),
          body: widget.child,
          bottomNavigationBar: _buildBottomNavigation(context, navigationController),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('FlutterShop'),
      actions: [
        Consumer<CartController>(
          builder: (context, cartController, _) {
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => context.go(AppRoutes.cart),
                ),
                if (cartController.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartController.itemCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _showSearchDialog(context),
        ),
      ],
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    return Consumer2<NavigationController, AuthController>(
      builder: (context, navController, authController, _) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(authController.currentUser),
              ...navController.drawerItems.map((item) => _buildDrawerItem(
                context,
                item,
                authController.isAuthenticated,
              )),
              Divider(),
              if (authController.isAuthenticated)
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () => _handleLogout(context),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(User? user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user?.name ?? 'Guest User'),
      accountEmail: Text(user?.email ?? 'Please log in'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: user?.avatarUrl != null
            ? NetworkImage(user!.avatarUrl!)
            : null,
        child: user?.avatarUrl == null
            ? Text(user?.name.substring(0, 1).toUpperCase() ?? 'G')
            : null,
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, NavigationController controller) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: controller.currentIndex,
      onTap: (index) => _handleBottomNavTap(context, index),
      items: controller.bottomNavItems.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        label: item.title,
      )).toList(),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    final routes = [AppRoutes.home, AppRoutes.products, AppRoutes.cart, AppRoutes.profile];
    if (index < routes.length) {
      context.go(routes[index]);
      context.read<NavigationController>().updateCurrentIndex(index);
    }
  }
}
```

#### **6.2 Create Individual Screens**
```dart
// lib/presentation/screens/home_screen.dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Update navigation index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationController>().updateCurrentIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildWelcomeBanner(),
        ),
        SliverToBoxAdapter(
          child: _buildFeaturedCategories(),
        ),
        SliverToBoxAdapter(
          child: _buildFeaturedProducts(),
        ),
      ],
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to FlutterShop',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Discover amazing products with great deals!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.products),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade400,
            ),
            child: Text('Shop Now'),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/screens/product_list_screen.dart
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationController>().updateCurrentIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildSearchAndFilters(),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = controller.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.go('${AppRoutes.products}/${product.id}'),
                  );
                },
                childCount: controller.products.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
```

### **🔒 Step 7: Authentication Integration**

#### **7.1 Create Login Screen**
```dart
// lib/presentation/screens/auth/login_screen.dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 48),
                _buildEmailField(),
                SizedBox(height: 16),
                _buildPasswordField(),
                SizedBox(height: 32),
                _buildLoginButton(),
                SizedBox(height: 16),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: authController.isLoading ? null : _handleLogin,
            child: authController.isLoading
                ? CircularProgressIndicator()
                : Text('Login'),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final result = await context.read<AuthController>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (result.isSuccess) {
        // Navigation is handled in the AuthController
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? 'Login failed')),
        );
      }
    }
  }
}
```

### **🧪 Step 8: Testing Strategy**

#### **8.1 Unit Tests for Navigation Use Cases**
```dart
// test/domain/usecases/navigate_to_route_usecase_test.dart
void main() {
  group('NavigateToRouteUseCase', () {
    late NavigateToRouteUseCase useCase;
    late MockNavigationRepository mockNavigationRepository;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockNavigationRepository = MockNavigationRepository();
      mockAuthRepository = MockAuthRepository();
      useCase = NavigateToRouteUseCase(mockNavigationRepository, mockAuthRepository);
    });

    test('should navigate to public route without authentication check', () async {
      // Arrange
      const route = AppRoutes.home;
      when(() => mockNavigationRepository.navigateToRoute(any(), extra: any(named: 'extra')))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(route);

      // Assert
      expect(result.isSuccess, true);
      verify(() => mockNavigationRepository.navigateToRoute(route, extra: null)).called(1);
      verifyNever(() => mockAuthRepository.getCurrentUser());
    });

    test('should redirect to login when accessing protected route without authentication', () async {
      // Arrange
      const route = AppRoutes.profile;
      when(() => mockAuthRepository.getCurrentUser()).thenAnswer((_) async => null);
      when(() => mockNavigationRepository.navigateToRoute(any(), extra: any(named: 'extra')))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(route);

      // Assert
      expect(result.isRedirectedToLogin, true);
      verify(() => mockNavigationRepository.navigateToRoute(AppRoutes.login, extra: null)).called(1);
    });
  });
}
```

#### **8.2 Widget Tests for Navigation Components**
```dart
// test/presentation/widgets/bottom_navigation_test.dart
void main() {
  group('BottomNavigation', () {
    testWidgets('should display all navigation items', (tester) async {
      // Arrange
      final mockNavigationController = MockNavigationController();
      when(() => mockNavigationController.currentIndex).thenReturn(0);
      when(() => mockNavigationController.bottomNavItems).thenReturn([
        NavigationItem(route: AppRoutes.home, title: 'Home', icon: Icons.home),
        NavigationItem(route: AppRoutes.products, title: 'Products', icon: Icons.shopping_bag),
      ]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NavigationController>.value(
            value: mockNavigationController,
            child: MainNavigationShell(child: Container()),
          ),
        ),
      );

      // Assert
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag), findsOneWidget);
    });
  });
}
```

### **🔧 Step 9: Performance Optimization**

#### **9.1 Route Preloading**
```dart
// lib/core/navigation/route_preloader.dart
class RoutePreloader {
  static void preloadRoutes(BuildContext context) {
    // Preload commonly accessed routes
    precacheImage(AssetImage('assets/images/home_banner.jpg'), context);
    precacheImage(AssetImage('assets/images/product_placeholder.jpg'), context);
  }

  static void preloadUserSpecificRoutes(BuildContext context, User user) {
    if (user.isVerified) {
      // Preload premium features
    }
  }
}
```

#### **9.2 Navigation Analytics**
```dart
// lib/core/navigation/navigation_analytics.dart
class NavigationAnalytics {
  static void trackRouteChange(String from, String to) {
    // Analytics implementation
    print('Navigation: $from -> $to');
  }

  static void trackUserFlow(List<String> routes) {
    // User flow tracking
    print('User flow: ${routes.join(' -> ')}');
  }
}
```

## 🚀 **How to Run**

### **1. Environment Setup**
```bash
# Ensure Flutter is installed and up to date
flutter --version

# Create new project or use existing
flutter create fluttershop_navigation
cd fluttershop_navigation
```

### **2. Dependencies Installation**
```bash
# Install dependencies
flutter pub get

# Run code generation (if using freezed or json_annotation)
flutter packages pub run build_runner build
```

### **3. Run the Application**
```bash
# Run on preferred device
flutter run

# Or run with specific flavor
flutter run --flavor development
```

### **4. Testing**
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run tests with coverage
flutter test --coverage
```

## 🎯 **Key Learning Points**

### **Navigation Architecture**
- ✅ **Clean Separation** - Navigation logic separated from UI
- ✅ **Repository Pattern** - Abstract navigation operations
- ✅ **Use Case Pattern** - Encapsulate navigation business logic
- ✅ **Dependency Injection** - Manageable navigation dependencies

### **Modern Routing**
- ✅ **GoRouter** - Declarative routing with URL support
- ✅ **Route Guards** - Authentication-based navigation
- ✅ **Deep Linking** - URL-based navigation handling
- ✅ **Route Parameters** - Type-safe parameter passing

### **Professional Patterns**
- ✅ **Shell Routes** - Persistent navigation shells
- ✅ **Nested Navigation** - Complex navigation hierarchies
- ✅ **State Management** - Centralized navigation state
- ✅ **Error Handling** - Graceful navigation error management

## 🎉 **Congratulations!**

You've successfully built a comprehensive navigation system using clean architecture principles! This application demonstrates professional-level navigation patterns that are used in production Flutter applications.

**Next Steps:**
- Explore advanced navigation patterns
- Implement custom route transitions
- Add navigation analytics
- Optimize for different screen sizes

**Continue to:** [Lesson 7 - Theming Your App](../lesson_07/) for advanced theming and design systems!