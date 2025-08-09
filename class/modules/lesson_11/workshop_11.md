# 🌳 Workshop

## 🎯 **What We're Building**

Create a **comprehensive shopping cart application** that demonstrates the evolution from local state to shared state management:
- **Shopping Cart System** with products, cart management, and user profiles
- **InheritedWidget Implementation** showing Flutter's built-in dependency injection
- **Provider Migration** demonstrating the benefits of the Provider package
- **ChangeNotifier Patterns** with reactive state management
- **Performance Optimization** with selective rebuilds and efficient updates
- **Clean Architecture** separating business logic from UI components
- **Comprehensive Testing** for both state models and widget integration

## ✅ **Expected Outcome**

A professional e-commerce application featuring:
- 🛍️ **Product Catalog** - Browse and search products with filtering
- 🛒 **Shopping Cart** - Add, remove, and modify items with real-time updates
- 👤 **User Management** - Profile management with preferences and settings
- 🔄 **State Sharing** - Seamless data flow across all application screens
- ⚡ **Performance Optimized** - Efficient rebuilds with Provider patterns
- 🧪 **Fully Tested** - Comprehensive test coverage for all state operations

## 🏗️ **Project Architecture**

We'll build a clean architecture shopping application:

```
lib/
├── core/
│   ├── models/                   # 📊 Data models
│   │   ├── product.dart         # Product entity
│   │   ├── cart_item.dart       # Cart item model
│   │   ├── user_profile.dart    # User profile model
│   │   └── app_settings.dart    # Application settings
│   ├── services/                # 🔧 Business services
│   │   ├── product_service.dart     # Product data service
│   │   ├── cart_service.dart       # Cart business logic
│   │   └── user_service.dart       # User management
│   └── utils/
│       └── price_formatter.dart    # Utility functions
├── providers/                   # 🌳 State management
│   ├── shopping_cart_provider.dart  # Cart state management
│   ├── user_profile_provider.dart   # User state management
│   ├── product_provider.dart       # Product state management
│   └── app_settings_provider.dart   # Settings state management
├── presentation/
│   ├── screens/                 # 📱 Application screens
│   │   ├── product_list_screen.dart # Product browsing
│   │   ├── product_detail_screen.dart # Product details
│   │   ├── cart_screen.dart        # Shopping cart view
│   │   ├── profile_screen.dart     # User profile
│   │   └── settings_screen.dart    # App settings
│   ├── widgets/                 # 🧩 Reusable components
│   │   ├── product_card.dart       # Product display card
│   │   ├── cart_item_widget.dart   # Cart item display
│   │   ├── cart_summary.dart       # Cart totals and summary
│   │   ├── user_avatar.dart        # User profile display
│   │   └── price_display.dart      # Formatted price display
│   └── inherited/               # 🔗 InheritedWidget implementations
│       ├── shopping_cart_inherited.dart # Cart InheritedWidget
│       └── user_profile_inherited.dart  # User InheritedWidget
└── main.dart                    # 🚀 Application entry point
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Core Data Models** ⏱️ *15 minutes*

Create the foundational data models for our shopping application:

```dart
// lib/core/models/product.dart
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    List<String>? tags,
    double? rating,
    int? reviewCount,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        category,
        tags,
        rating,
        reviewCount,
        isAvailable,
      ];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
  }
}

// lib/core/models/cart_item.dart
import 'package:equatable/equatable.dart';
import 'product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory CartItem.create(Product product, {int quantity = 1}) {
    return CartItem(
      product: product,
      quantity: quantity,
      addedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [product, quantity, addedAt];

  @override
  String toString() {
    return 'CartItem(product: ${product.name}, quantity: $quantity, total: \$${totalPrice.toStringAsFixed(2)})';
  }
}

// lib/core/models/user_profile.dart
import 'package:equatable/equatable.dart';

enum UserRole { guest, customer, premium, admin }

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final UserRole role;
  final List<String> favoriteCategories;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = UserRole.customer,
    this.favoriteCategories = const [],
    this.preferences = const {},
    required this.createdAt,
    required this.lastLoginAt,
  });

  bool get isGuest => role == UserRole.guest;
  bool get isPremium => role == UserRole.premium || role == UserRole.admin;
  bool get isAdmin => role == UserRole.admin;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
    List<String>? favoriteCategories,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  factory UserProfile.guest() {
    final now = DateTime.now();
    return UserProfile(
      id: 'guest',
      name: 'Guest User',
      email: 'guest@example.com',
      role: UserRole.guest,
      createdAt: now,
      lastLoginAt: now,
    );
  }

  factory UserProfile.create({
    required String name,
    required String email,
    String? avatarUrl,
    UserRole role = UserRole.customer,
  }) {
    final now = DateTime.now();
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      role: role,
      createdAt: now,
      lastLoginAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        role,
        favoriteCategories,
        preferences,
        createdAt,
        lastLoginAt,
      ];
}

// lib/core/models/app_settings.dart
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum AppTheme { light, dark, system }
enum Currency { usd, eur, gbp, jpy }

class AppSettings extends Equatable {
  final AppTheme theme;
  final Currency currency;
  final Locale locale;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final double textScaleFactor;
  final Map<String, dynamic> customSettings;

  const AppSettings({
    this.theme = AppTheme.system,
    this.currency = Currency.usd,
    this.locale = const Locale('en', 'US'),
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.textScaleFactor = 1.0,
    this.customSettings = const {},
  });

  String get currencySymbol {
    switch (currency) {
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
      case Currency.gbp:
        return '£';
      case Currency.jpy:
        return '¥';
    }
  }

  String formatPrice(double price) {
    return '$currencySymbol${price.toStringAsFixed(2)}';
  }

  AppSettings copyWith({
    AppTheme? theme,
    Currency? currency,
    Locale? locale,
    bool? notificationsEnabled,
    bool? biometricEnabled,
    double? textScaleFactor,
    Map<String, dynamic>? customSettings,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      currency: currency ?? this.currency,
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  @override
  List<Object?> get props => [
        theme,
        currency,
        locale,
        notificationsEnabled,
        biometricEnabled,
        textScaleFactor,
        customSettings,
      ];
}
```

### **Step 2: InheritedWidget Implementation** ⏱️ *25 minutes*

First, let's implement state sharing using pure InheritedWidget to understand the fundamentals:

```dart
// lib/presentation/inherited/shopping_cart_inherited.dart
import 'package:flutter/material.dart';
import '../../core/models/cart_item.dart';
import '../../core/models/product.dart';

class ShoppingCartInheritedWidget extends InheritedWidget {
  final List<CartItem> cartItems;
  final Function(Product, {int quantity}) addToCart;
  final Function(String) removeFromCart;
  final Function(String, int) updateQuantity;
  final Function() clearCart;

  const ShoppingCartInheritedWidget({
    super.key,
    required this.cartItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateQuantity,
    required this.clearCart,
    required super.child,
  });

  // Calculate derived state
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  bool get isEmpty => cartItems.isEmpty;
  bool get isNotEmpty => cartItems.isNotEmpty;

  // Find item by product ID
  CartItem? findItem(String productId) {
    try {
      return cartItems.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Check if product is in cart
  bool containsProduct(String productId) => findItem(productId) != null;

  @override
  bool updateShouldNotify(ShoppingCartInheritedWidget oldWidget) {
    // Notify dependents when cart items change
    return cartItems != oldWidget.cartItems;
  }

  // Static access method
  static ShoppingCartInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShoppingCartInheritedWidget>();
  }

  // Helper methods for safe access
  static List<CartItem> cartItemsOf(BuildContext context) {
    final widget = of(context);
    assert(widget != null, 'ShoppingCartInheritedWidget not found in context');
    return widget!.cartItems;
  }

  static int itemCountOf(BuildContext context) {
    final widget = of(context);
    assert(widget != null, 'ShoppingCartInheritedWidget not found in context');
    return widget!.itemCount;
  }

  static double totalPriceOf(BuildContext context) {
    final widget = of(context);
    assert(widget != null, 'ShoppingCartInheritedWidget not found in context');
    return widget!.totalPrice;
  }

  static void addToCartOf(BuildContext context, Product product, {int quantity = 1}) {
    final widget = of(context);
    assert(widget != null, 'ShoppingCartInheritedWidget not found in context');
    widget!.addToCart(product, quantity: quantity);
  }

  static void removeFromCartOf(BuildContext context, String productId) {
    final widget = of(context);
    assert(widget != null, 'ShoppingCartInheritedWidget not found in context');
    widget!.removeFromCart(productId);
  }

  static void updateQuantityOf(BuildContext context, String productId, int quantity) {
    final widget = of(context);
    assert(widget != null, 'ShoppingCartInheritedWidget not found in context');
    widget!.updateQuantity(productId, quantity);
  }
}

// Stateful wrapper to manage cart state
class ShoppingCartProvider extends StatefulWidget {
  final Widget child;

  const ShoppingCartProvider({super.key, required this.child});

  @override
  State<ShoppingCartProvider> createState() => _ShoppingCartProviderState();
}

class _ShoppingCartProviderState extends State<ShoppingCartProvider> {
  List<CartItem> _cartItems = [];

  void _addToCart(Product product, {int quantity = 1}) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex >= 0) {
        // Update existing item quantity
        final existingItem = _cartItems[existingIndex];
        _cartItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      } else {
        // Add new item
        _cartItems.add(CartItem.create(product, quantity: quantity));
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == productId);
    });
  }

  void _updateQuantity(String productId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _removeFromCart(productId);
        return;
      }

      final index = _cartItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index >= 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShoppingCartInheritedWidget(
      cartItems: _cartItems,
      addToCart: _addToCart,
      removeFromCart: _removeFromCart,
      updateQuantity: _updateQuantity,
      clearCart: _clearCart,
      child: widget.child,
    );
  }
}

// lib/presentation/inherited/user_profile_inherited.dart
import 'package:flutter/material.dart';
import '../../core/models/user_profile.dart';

class UserProfileInheritedWidget extends InheritedWidget {
  final UserProfile userProfile;
  final Function(UserProfile) updateProfile;
  final Function() logout;

  const UserProfileInheritedWidget({
    super.key,
    required this.userProfile,
    required this.updateProfile,
    required this.logout,
    required super.child,
  });

  @override
  bool updateShouldNotify(UserProfileInheritedWidget oldWidget) {
    return userProfile != oldWidget.userProfile;
  }

  static UserProfileInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProfileInheritedWidget>();
  }

  static UserProfile userProfileOf(BuildContext context) {
    final widget = of(context);
    assert(widget != null, 'UserProfileInheritedWidget not found in context');
    return widget!.userProfile;
  }

  static void updateProfileOf(BuildContext context, UserProfile newProfile) {
    final widget = of(context);
    assert(widget != null, 'UserProfileInheritedWidget not found in context');
    widget!.updateProfile(newProfile);
  }

  static void logoutOf(BuildContext context) {
    final widget = of(context);
    assert(widget != null, 'UserProfileInheritedWidget not found in context');
    widget!.logout();
  }
}

class UserProfileProvider extends StatefulWidget {
  final Widget child;

  const UserProfileProvider({super.key, required this.child});

  @override
  State<UserProfileProvider> createState() => _UserProfileProviderState();
}

class _UserProfileProviderState extends State<UserProfileProvider> {
  UserProfile _userProfile = UserProfile.guest();

  void _updateProfile(UserProfile newProfile) {
    setState(() {
      _userProfile = newProfile.copyWith(lastLoginAt: DateTime.now());
    });
  }

  void _logout() {
    setState(() {
      _userProfile = UserProfile.guest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileInheritedWidget(
      userProfile: _userProfile,
      updateProfile: _updateProfile,
      logout: _logout,
      child: widget.child,
    );
  }
}
```

### **Step 3: Provider Implementation** ⏱️ *30 minutes*

Now let's convert to Provider pattern for cleaner, more maintainable code:

```dart
// lib/providers/shopping_cart_provider.dart
import 'package:flutter/material.dart';
import '../core/models/cart_item.dart';
import '../core/models/product.dart';

class ShoppingCartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Getters for accessing cart state
  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  // Get items by category
  List<CartItem> getItemsByCategory(String category) {
    return _items.where((item) => item.product.category == category).toList();
  }

  // Find specific item
  CartItem? findItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Check if product is in cart
  bool containsProduct(String productId) => findItem(productId) != null;

  // Get quantity of specific product
  int getProductQuantity(String productId) {
    final item = findItem(productId);
    return item?.quantity ?? 0;
  }

  // Add item to cart
  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Update existing item
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item
      _items.add(CartItem.create(product, quantity: quantity));
    }

    notifyListeners();
  }

  // Remove item completely
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  // Increment item quantity
  void incrementItem(String productId) {
    final item = findItem(productId);
    if (item != null) {
      updateQuantity(productId, item.quantity + 1);
    }
  }

  // Decrement item quantity
  void decrementItem(String productId) {
    final item = findItem(productId);
    if (item != null) {
      updateQuantity(productId, item.quantity - 1);
    }
  }

  // Clear entire cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Get cart summary information
  Map<String, dynamic> getSummary() {
    final Map<String, int> categoryCount = {};
    final Map<String, double> categoryTotal = {};

    for (final item in _items) {
      final category = item.product.category;
      categoryCount[category] = (categoryCount[category] ?? 0) + item.quantity;
      categoryTotal[category] = (categoryTotal[category] ?? 0.0) + item.totalPrice;
    }

    return {
      'totalItems': itemCount,
      'totalPrice': totalPrice,
      'uniqueProducts': _items.length,
      'categories': categoryCount.keys.toList(),
      'categoryBreakdown': {
        'count': categoryCount,
        'total': categoryTotal,
      },
    };
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}

// lib/providers/user_profile_provider.dart
import 'package:flutter/material.dart';
import '../core/models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile.guest();

  UserProfile get userProfile => _userProfile;
  
  bool get isLoggedIn => !_userProfile.isGuest;
  bool get isGuest => _userProfile.isGuest;
  bool get isPremium => _userProfile.isPremium;
  bool get isAdmin => _userProfile.isAdmin;

  // Update user profile
  void updateProfile(UserProfile newProfile) {
    _userProfile = newProfile.copyWith(lastLoginAt: DateTime.now());
    notifyListeners();
  }

  // Update specific profile fields
  void updateName(String newName) {
    _userProfile = _userProfile.copyWith(name: newName);
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _userProfile = _userProfile.copyWith(email: newEmail);
    notifyListeners();
  }

  void updateAvatar(String newAvatarUrl) {
    _userProfile = _userProfile.copyWith(avatarUrl: newAvatarUrl);
    notifyListeners();
  }

  // Add favorite category
  void addFavoriteCategory(String category) {
    if (!_userProfile.favoriteCategories.contains(category)) {
      final updatedCategories = List<String>.from(_userProfile.favoriteCategories)
        ..add(category);
      _userProfile = _userProfile.copyWith(favoriteCategories: updatedCategories);
      notifyListeners();
    }
  }

  // Remove favorite category
  void removeFavoriteCategory(String category) {
    final updatedCategories = List<String>.from(_userProfile.favoriteCategories)
      ..remove(category);
    _userProfile = _userProfile.copyWith(favoriteCategories: updatedCategories);
    notifyListeners();
  }

  // Update preferences
  void updatePreference(String key, dynamic value) {
    final updatedPreferences = Map<String, dynamic>.from(_userProfile.preferences);
    updatedPreferences[key] = value;
    _userProfile = _userProfile.copyWith(preferences: updatedPreferences);
    notifyListeners();
  }

  // Login with user data
  void login(String name, String email, {String? avatarUrl, UserRole role = UserRole.customer}) {
    _userProfile = UserProfile.create(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      role: role,
    );
    notifyListeners();
  }

  // Logout user
  void logout() {
    _userProfile = UserProfile.guest();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../core/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String? _selectedCategory;
  double _minPrice = 0.0;
  double _maxPrice = double.infinity;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get products => List.unmodifiable(_filteredProducts);
  List<Product> get allProducts => List.unmodifiable(_products);
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get unique categories
  List<String> get categories {
    final categorySet = _products.map((p) => p.category).toSet();
    return categorySet.toList()..sort();
  }

  // Load products (simulated)
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _products = _generateSampleProducts();
      _applyFilters();
      _isLoading = false;
    } catch (error) {
      _errorMessage = 'Failed to load products: $error';
      _isLoading = false;
    }
    
    notifyListeners();
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Filter by price range
  void filterByPriceRange(double minPrice, double maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _minPrice = 0.0;
    _maxPrice = double.infinity;
    _applyFilters();
    notifyListeners();
  }

  // Apply current filters
  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final matchesName = product.name.toLowerCase().contains(_searchQuery);
        final matchesDescription = product.description.toLowerCase().contains(_searchQuery);
        final matchesTags = product.tags.any((tag) => tag.toLowerCase().contains(_searchQuery));
        
        if (!matchesName && !matchesDescription && !matchesTags) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null && product.category != _selectedCategory) {
        return false;
      }

      // Price range filter
      if (product.price < _minPrice || product.price > _maxPrice) {
        return false;
      }

      // Availability filter
      if (!product.isAvailable) {
        return false;
      }

      return true;
    }).toList();
  }

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Generate sample products
  List<Product> _generateSampleProducts() {
    return [
      const Product(
        id: '1',
        name: 'Wireless Headphones',
        description: 'High-quality wireless headphones with noise cancellation',
        price: 199.99,
        imageUrl: 'https://via.placeholder.com/300x300?text=Headphones',
        category: 'Electronics',
        tags: ['audio', 'wireless', 'music'],
        rating: 4.5,
        reviewCount: 128,
      ),
      const Product(
        id: '2',
        name: 'Coffee Maker',
        description: 'Automatic coffee maker with programmable settings',
        price: 89.99,
        imageUrl: 'https://via.placeholder.com/300x300?text=Coffee+Maker',
        category: 'Kitchen',
        tags: ['coffee', 'appliance', 'morning'],
        rating: 4.2,
        reviewCount: 67,
      ),
      const Product(
        id: '3',
        name: 'Running Shoes',
        description: 'Comfortable running shoes for all terrains',
        price: 129.99,
        imageUrl: 'https://via.placeholder.com/300x300?text=Running+Shoes',
        category: 'Sports',
        tags: ['shoes', 'running', 'fitness'],
        rating: 4.7,
        reviewCount: 203,
      ),
      const Product(
        id: '4',
        name: 'Smartphone',
        description: 'Latest smartphone with advanced camera features',
        price: 699.99,
        imageUrl: 'https://via.placeholder.com/300x300?text=Smartphone',
        category: 'Electronics',
        tags: ['phone', 'camera', 'mobile'],
        rating: 4.6,
        reviewCount: 89,
      ),
      const Product(
        id: '5',
        name: 'Yoga Mat',
        description: 'Premium yoga mat with excellent grip and cushioning',
        price: 49.99,
        imageUrl: 'https://via.placeholder.com/300x300?text=Yoga+Mat',
        category: 'Sports',
        tags: ['yoga', 'fitness', 'exercise'],
        rating: 4.4,
        reviewCount: 156,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}
```

*This is part 1 of the workshop. Continue with the remaining steps to build the complete shopping application...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_11

# Install dependencies
flutter pub get
flutter pub add provider

# Run the app
flutter run

# Test state management
# 1. Browse products and add to cart
# 2. Navigate between screens and see shared state
# 3. Update user profile and see changes everywhere
# 4. Test cart operations and real-time updates
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **InheritedWidget Fundamentals** - Understanding Flutter's built-in dependency injection
- **Provider Patterns** - Simplified state management with reactive updates
- **ChangeNotifier Usage** - Reactive state models with automatic rebuild notifications
- **Context Operations** - Safe and efficient access to shared state
- **Performance Optimization** - Selective rebuilds with Consumer and Selector patterns
- **Clean Architecture** - Proper separation of state management and UI components

**Ready to master shared state management with InheritedWidget and Provider? 🌳✨**