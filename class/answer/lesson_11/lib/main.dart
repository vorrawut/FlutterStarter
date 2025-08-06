/// Main application entry point for Lesson 11: InheritedWidget & Provider
/// 
/// This file demonstrates the complete integration of Provider patterns,
/// dependency injection, and shared state management across the app.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shopping_cart_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/product_provider.dart';
import 'providers/app_settings_provider.dart';
import 'core/models/product.dart';

/// Main application entry point
void main() {
  runApp(const ShoppingApp());
}

/// Main application widget demonstrating Provider patterns
/// 
/// Shows proper MultiProvider setup, dependency injection,
/// and comprehensive state management for a shopping application.
class ShoppingApp extends StatelessWidget {
  /// Creates the main shopping application
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App Settings Provider - Foundation for theme and configuration
        ChangeNotifierProvider<AppSettingsProvider>(
          create: (context) => AppSettingsProvider(),
        ),
        
        // User Profile Provider - Authentication and user state
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) => UserProfileProvider(),
        ),
        
        // Product Provider - Product catalog and filtering
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        
        // Shopping Cart Provider - Cart operations
        ChangeNotifierProvider<ShoppingCartProvider>(
          create: (context) => ShoppingCartProvider(),
        ),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Shopping Demo - Provider Patterns',
            debugShowCheckedModeBanner: false,
            
            // Theme configuration from Provider
            theme: _buildLightTheme(settings),
            darkTheme: _buildDarkTheme(settings),
            themeMode: settings.themeMode,
            
            // Home screen
            home: const ShoppingHomePage(),
            
            // Error handling
            builder: (context, child) {
              return _buildAppWithErrorHandling(context, child);
            },
          );
        },
      ),
    );
  }

  /// Build light theme with Provider settings
  ThemeData _buildLightTheme(AppSettingsProvider settings) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.primaryColor,
        brightness: Brightness.light,
      ),
      visualDensity: settings.visualDensity,
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      
      // Text theme with scaled font sizes
      textTheme: ThemeData.light().textTheme.apply(
        fontSizeFactor: settings.getScaledFontSize(14.0) / 14.0,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  /// Build dark theme with Provider settings
  ThemeData _buildDarkTheme(AppSettingsProvider settings) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.primaryColor,
        brightness: Brightness.dark,
      ),
      visualDensity: settings.visualDensity,
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      
      // Text theme with scaled font sizes
      textTheme: ThemeData.dark().textTheme.apply(
        fontSizeFactor: settings.getScaledFontSize(14.0) / 14.0,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  /// Build app with global error handling
  Widget _buildAppWithErrorHandling(BuildContext context, Widget? child) {
    return Builder(
      builder: (context) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

/// Main shopping home page demonstrating Provider consumption
/// 
/// Shows how to use Consumer, Selector, and context.read/watch
/// for efficient state management and rebuilds.
class ShoppingHomePage extends StatefulWidget {
  /// Creates the shopping home page
  const ShoppingHomePage({super.key});

  @override
  State<ShoppingHomePage> createState() => _ShoppingHomePageState();
}

class _ShoppingHomePageState extends State<ShoppingHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ProductListTab(),
          CartTab(),
          ProfileTab(),
          SettingsTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Build app bar with cart badge
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Shopping Demo'),
      actions: [
        // Cart icon with badge using Selector for optimal rebuilds
        Selector<ShoppingCartProvider, int>(
          selector: (context, cart) => cart.totalQuantity,
          builder: (context, totalQuantity, child) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  icon: const Icon(Icons.shopping_cart),
                ),
                if (totalQuantity > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$totalQuantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        
        // User avatar with Consumer
        Consumer<UserProfileProvider>(
          builder: (context, userProvider, child) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: userProvider.avatarUrl != null
                    ? NetworkImage(userProvider.avatarUrl!)
                    : null,
                child: userProvider.avatarUrl == null
                    ? Text(
                        userProvider.initials,
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

/// Product list tab demonstrating Provider patterns
class ProductListTab extends StatelessWidget {
  const ProductListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading products...'),
              ],
            ),
          );
        }

        if (productProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(productProvider.errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => productProvider.refreshProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final products = productProvider.filteredProducts;

        if (products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64),
                SizedBox(height: 16),
                Text('No products found'),
                Text('Try adjusting your search or filters'),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: productProvider.searchProducts,
              ),
            ),
            
            // Filter chips
            if (productProvider.hasActiveFilters)
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.filterSummary.length,
                  itemBuilder: (context, index) {
                    final entry = productProvider.filterSummary.entries.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text('${entry.key}: ${entry.value}'),
                        onDeleted: () => productProvider.clearAllFilters(),
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                    );
                  },
                ),
              ),
            
            // Product grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(context, product);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build individual product card
  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image placeholder
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(
                product.category.icon,
                size: 48,
                color: Colors.grey[600],
              ),
            ),
          ),
          
          // Product details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        product.formattedPrice,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 4),
                        Text(
                          product.formattedOriginalPrice,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Add to cart button
                      Expanded(
                        child: Consumer<ShoppingCartProvider>(
                          builder: (context, cart, child) {
                            return ElevatedButton(
                              onPressed: product.status.canAddToCart
                                  ? () => cart.addToCart(product)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                minimumSize: const Size(0, 32),
                              ),
                              child: const Text('Add', style: TextStyle(fontSize: 12)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      
                      // Wishlist button
                      Consumer<UserProfileProvider>(
                        builder: (context, user, child) {
                          final isInWishlist = user.isInWishlist(product.id);
                          return IconButton(
                            onPressed: () => user.toggleWishlist(product.id),
                            icon: Icon(
                              isInWishlist ? Icons.favorite : Icons.favorite_border,
                              color: isInWishlist ? Colors.red : null,
                            ),
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cart tab demonstrating Provider state management
class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, cart, child) {
        if (cart.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64),
                SizedBox(height: 16),
                Text('Your cart is empty'),
                Text('Add some products to get started'),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Cart items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(item.product.category.icon),
                      title: Text(item.product.name),
                      subtitle: Text(item.formattedTotalPrice),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => cart.decrementQuantity(item.id),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            onPressed: () => cart.incrementQuantity(item.id),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Cart summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:'),
                      Text(
                        cart.formattedTotalPrice,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Checkout feature coming soon!')),
                        );
                      },
                      child: const Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Profile tab demonstrating user state management
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, user, child) {
        if (!user.isAuthenticated) {
          return _buildSignInForm(context, user);
        }

        return _buildProfileView(context, user);
      },
    );
  }

  /// Build sign in form
  Widget _buildSignInForm(BuildContext context, UserProfileProvider user) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 64),
          const SizedBox(height: 16),
          const Text('Sign in to continue', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 32),
          
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: user.isLoading
                  ? null
                  : () => user.signInWithEmail(
                        emailController.text,
                        passwordController.text,
                      ),
              child: user.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign In'),
            ),
          ),
          
          if (user.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              user.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }

  /// Build profile view
  Widget _buildProfileView(BuildContext context, UserProfileProvider user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // User info card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Text(user.initials, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(user.email),
                const SizedBox(height: 8),
                Chip(label: Text(user.role.displayName)),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Wishlist
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Wishlist'),
          trailing: Text('${user.wishlistCount} items'),
          onTap: () {},
        ),
        
        // Orders
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('Orders'),
          trailing: Text('${user.orderCount} orders'),
          onTap: () {},
        ),
        
        // Loyalty points
        ListTile(
          leading: const Icon(Icons.stars),
          title: const Text('Loyalty Points'),
          trailing: Text('${user.loyaltyPoints} pts'),
          onTap: () {},
        ),
        
        const Divider(),
        
        // Sign out
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sign Out'),
          onTap: () => user.signOut(),
        ),
      ],
    );
  }
}

/// Settings tab demonstrating app settings management
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Theme settings
            const Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme Mode'),
              trailing: Text(settings.currentSettings.themeMode.label),
              onTap: () => settings.toggleThemeMode(),
            ),
            
            const Divider(),
            
            // Accessibility
            const Text('Accessibility', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              secondary: const Icon(Icons.animation),
              title: const Text('Enable Animations'),
              value: settings.enableAnimations,
              onChanged: (value) => settings.updateAccessibility(enableAnimations: value),
            ),
            
            SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: const Text('Haptic Feedback'),
              value: settings.enableHapticFeedback,
              onChanged: (value) => settings.updateAccessibility(enableHapticFeedback: value),
            ),
            
            const Divider(),
            
            // Privacy
            const Text('Privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              secondary: const Icon(Icons.analytics),
              title: const Text('Analytics'),
              value: settings.enableAnalytics,
              onChanged: (value) => settings.updatePrivacy(enableAnalytics: value),
            ),
            
            const Divider(),
            
            // About
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Version'),
              trailing: Text(settings.version),
            ),
          ],
        );
      },
    );
  }
}