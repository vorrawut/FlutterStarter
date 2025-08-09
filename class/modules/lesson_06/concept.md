# 🧭 Concepts

## 🎯 **Learning Objective**

Master Flutter's navigation system by building a professional multi-screen application with modern routing patterns, deep linking, and clean architecture principles. This lesson transforms students from basic navigation users to experts who can implement complex navigation flows in production applications.

## 📚 **Key Concepts**

### **🧭 Navigation Fundamentals**

#### **Navigator 1.0 vs Navigator 2.0**
- **Navigator 1.0 (Imperative)** - Simple push/pop operations
- **Navigator 2.0 (Declarative)** - Complete control over navigation stack
- **When to use each** - Complexity vs simplicity trade-offs
- **Migration strategies** - Upgrading existing applications

#### **Navigation Stack Management**
```dart
// Navigator 1.0 - Imperative approach
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => DetailScreen()),
);

// Navigator 2.0 - Declarative approach
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/detail':
        return MaterialPageRoute(builder: (_) => DetailScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
```

### **🛣️ Routing Architecture**

#### **Route Definition Patterns**
- **Named Routes** - String-based route identification
- **Generated Routes** - Dynamic route creation
- **Route Guards** - Authentication and authorization
- **Route Parameters** - Data passing between screens

#### **Deep Linking & URL Handling**
```dart
// URL structure design
/home              -> HomeScreen()
/profile           -> ProfileScreen()
/profile/settings  -> ProfileSettingsScreen()
/product/123       -> ProductDetailScreen(id: 123)

// Route parameter extraction
class RouteParser {
  static Map<String, String> parseParameters(String route) {
    final uri = Uri.parse(route);
    return uri.queryParameters;
  }
}
```

### **🏗️ Navigation Architecture Patterns**

#### **Repository Pattern for Navigation**
```dart
abstract class NavigationRepository {
  Future<void> navigateToScreen(String route, {Map<String, dynamic>? args});
  Future<void> navigateBack();
  Future<void> navigateAndReplace(String route);
  String getCurrentRoute();
}

class NavigationRepositoryImpl implements NavigationRepository {
  final GlobalKey<NavigatorState> _navigatorKey;
  
  @override
  Future<void> navigateToScreen(String route, {Map<String, dynamic>? args}) async {
    await _navigatorKey.currentState?.pushNamed(route, arguments: args);
  }
}
```

#### **Navigation Use Cases**
```dart
class NavigateToProfileUseCase {
  final NavigationRepository _navigationRepository;
  final UserRepository _userRepository;
  
  Future<NavigationResult> execute(String userId) async {
    // Business logic: Check if user has access
    final user = await _userRepository.getUserById(userId);
    if (user == null) {
      return NavigationResult.error('User not found');
    }
    
    // Navigate to profile
    await _navigationRepository.navigateToScreen(
      '/profile',
      args: {'userId': userId},
    );
    
    return NavigationResult.success();
  }
}
```

### **📱 Multi-Screen Application Design**

#### **Screen Hierarchy Planning**
```
📱 App Navigation Structure
├── 🏠 Home Screen (/)
│   ├── 📊 Dashboard Tab
│   ├── 🛍️ Products Tab
│   └── 👤 Profile Tab
├── 📋 Product Detail (/product/:id)
│   ├── 📸 Image Gallery
│   ├── 📝 Product Info
│   └── 🛒 Add to Cart
├── 👤 Profile (/profile)
│   ├── ⚙️ Settings (/profile/settings)
│   ├── 📦 Orders (/profile/orders)
│   └── ❤️ Favorites (/profile/favorites)
└── 🔐 Authentication
    ├── 📝 Login (/login)
    └── 📝 Register (/register)
```

#### **Navigation Flow Design**
- **Linear Flow** - Sequential screen progression
- **Hierarchical Flow** - Parent-child relationships
- **Tab-based Flow** - Parallel screen access
- **Modal Flow** - Overlay-based navigation

### **🎨 Navigation UI Patterns**

#### **Bottom Navigation**
```dart
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
```

#### **Navigation Drawer**
```dart
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('john@example.com'),
          ),
          NavigationDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () => _navigateToHome(context),
          ),
          NavigationDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => _navigateToSettings(context),
          ),
        ],
      ),
    );
  }
}
```

### **🔒 Route Guards & Authentication**

#### **Authentication-Based Navigation**
```dart
class AuthGuard {
  static bool canAccess(String route, User? currentUser) {
    final protectedRoutes = ['/profile', '/settings', '/orders'];
    
    if (protectedRoutes.contains(route)) {
      return currentUser != null;
    }
    
    return true;
  }
}

class GuardedNavigationUseCase {
  final AuthRepository _authRepository;
  final NavigationRepository _navigationRepository;
  
  Future<void> navigateWithGuard(String route) async {
    final currentUser = await _authRepository.getCurrentUser();
    
    if (AuthGuard.canAccess(route, currentUser)) {
      await _navigationRepository.navigateToScreen(route);
    } else {
      await _navigationRepository.navigateToScreen('/login');
    }
  }
}
```

### **📊 Navigation State Management**

#### **Navigation Controller Pattern**
```dart
class NavigationController extends ChangeNotifier {
  int _currentIndex = 0;
  String _currentRoute = '/';
  final List<String> _navigationHistory = [];
  
  int get currentIndex => _currentIndex;
  String get currentRoute => _currentRoute;
  bool get canGoBack => _navigationHistory.length > 1;
  
  void navigateToTab(int index) {
    _currentIndex = index;
    _currentRoute = _getRouteForIndex(index);
    _addToHistory(_currentRoute);
    notifyListeners();
  }
  
  void navigateBack() {
    if (canGoBack) {
      _navigationHistory.removeLast();
      _currentRoute = _navigationHistory.last;
      _updateIndexFromRoute();
      notifyListeners();
    }
  }
}
```

### **🎯 Advanced Navigation Patterns**

#### **Nested Navigation**
```dart
class TabNavigator extends StatelessWidget {
  final String tabItem;
  final GlobalKey<NavigatorState> navigatorKey;
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => _getScreenForTab(tabItem, routeSettings),
        );
      },
    );
  }
}
```

#### **Route Transitions**
```dart
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType transitionType;
  
  CustomPageRoute({
    required this.child,
    required this.transitionType,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _buildTransition(animation, child, transitionType);
    },
  );
  
  Widget _buildTransition(Animation<double> animation, Widget child, PageTransitionType type) {
    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);
      case PageTransitionType.slide:
        return SlideTransition(
          position: animation.drive(Tween(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          )),
          child: child,
        );
    }
  }
}
```

## 🧠 **Best Practices**

### **✅ Navigation Architecture**
1. **Separation of Concerns** - Keep navigation logic separate from UI
2. **Repository Pattern** - Abstract navigation operations
3. **Use Cases** - Encapsulate complex navigation flows
4. **State Management** - Track navigation state centrally
5. **Route Guards** - Implement authentication checks

### **✅ Performance Optimization**
1. **Lazy Loading** - Load screens only when needed
2. **Route Caching** - Cache frequently accessed routes
3. **Memory Management** - Properly dispose of navigation controllers
4. **Transition Optimization** - Use efficient animations
5. **Deep Link Handling** - Optimize for cold starts

### **✅ User Experience**
1. **Consistent Navigation** - Use platform conventions
2. **Back Button Handling** - Implement proper back navigation
3. **Loading States** - Show progress during navigation
4. **Error Handling** - Graceful handling of navigation failures
5. **Accessibility** - Ensure navigation is accessible

### **✅ Testing Strategy**
1. **Navigation Tests** - Test route generation and navigation flows
2. **Integration Tests** - Test complete user journeys
3. **Mock Navigation** - Use test doubles for navigation dependencies
4. **Route Parameter Tests** - Verify parameter parsing and validation
5. **Guard Tests** - Test authentication and authorization logic

## 🔍 **Common Patterns & Anti-Patterns**

### **✅ Good Practices**
```dart
// ✅ Clean route definition
class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}

// ✅ Navigation abstraction
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }
}
```

### **❌ Anti-Patterns to Avoid**
```dart
// ❌ Direct navigation in widgets
onTap: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => SomeScreen()),
);

// ❌ Hardcoded route strings
Navigator.pushNamed(context, '/some/hardcoded/route');

// ❌ Missing error handling
Navigator.pushNamed(context, routeName); // What if route doesn't exist?

// ❌ No navigation abstraction
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigation logic mixed with UI
        Navigator.of(context).pushNamed('/profile');
      },
      child: Text('Go to Profile'),
    );
  }
}
```

## 🎯 **Learning Outcomes**

### **Technical Skills**
- ✅ **Navigator 1.0 & 2.0** - Understand both navigation approaches
- ✅ **Route Management** - Design and implement route hierarchies
- ✅ **Deep Linking** - Handle URL-based navigation
- ✅ **Navigation Patterns** - Implement tabs, drawers, and nested navigation
- ✅ **Route Guards** - Implement authentication-based navigation
- ✅ **State Management** - Manage navigation state effectively

### **Architectural Understanding**
- ✅ **Clean Architecture** - Apply architectural principles to navigation
- ✅ **Repository Pattern** - Abstract navigation operations
- ✅ **Use Case Pattern** - Encapsulate navigation business logic
- ✅ **Dependency Injection** - Manage navigation dependencies
- ✅ **Testing Strategy** - Test navigation flows and components

### **Professional Development**
- ✅ **Navigation Planning** - Design navigation hierarchies
- ✅ **User Experience** - Create intuitive navigation flows
- ✅ **Performance** - Optimize navigation performance
- ✅ **Accessibility** - Ensure navigation accessibility
- ✅ **Maintainability** - Structure navigation code for long-term maintenance

## 🚀 **Real-World Applications**

### **Enterprise Applications**
- **Multi-tenant Navigation** - Role-based route access
- **Complex Workflows** - Multi-step navigation flows
- **Deep Linking** - URL-based navigation for web integration
- **Navigation Analytics** - Track user navigation patterns

### **E-commerce Applications**
- **Product Navigation** - Category hierarchies and search
- **Checkout Flow** - Multi-step purchase process
- **User Account** - Profile and order management
- **Authentication Flow** - Login and registration navigation

### **Social Media Applications**
- **Feed Navigation** - Home, profile, and detail screens
- **Media Viewing** - Full-screen media with navigation
- **Chat Navigation** - Conversation lists and detail screens
- **Settings Navigation** - Hierarchical settings organization

## 🔮 **Advanced Topics**

### **Custom Route Delegates**
```dart
class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onPopPage: _handlePopPage,
    );
  }
}
```

### **Route Information Parser**
```dart
class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    return AppRoutePath.fromUri(uri);
  }
}
```

### **Navigation Analytics**
```dart
class NavigationAnalytics {
  static void trackNavigation(String from, String to) {
    // Analytics tracking implementation
  }
  
  static void trackUserFlow(List<String> navigationPath) {
    // User flow analysis
  }
}
```

---

## 🎓 **Conclusion**

Navigation is the backbone of any mobile application. This lesson provides comprehensive coverage of Flutter's navigation system, from basic concepts to advanced patterns. Students will learn to create professional, maintainable navigation architectures that scale with application complexity.

The clean architecture approach ensures navigation logic is testable, maintainable, and follows industry best practices. By the end of this lesson, students will be capable of implementing complex navigation flows in production applications with confidence.

**Next**: [Workshop 6](workshop_06.md) - Build a complete multi-screen application with professional navigation patterns.