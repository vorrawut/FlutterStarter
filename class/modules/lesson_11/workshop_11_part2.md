# 🌳 Lesson 11: InheritedWidget & Provider - Workshop (Part 2)

## **Step 4: UI Components with Provider Integration** ⏱️ *35 minutes*

Build UI components that demonstrate efficient Provider usage patterns:

```dart
// lib/presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/product.dart';
import '../../providers/shopping_cart_provider.dart';
import '../../providers/user_profile_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductInfo(context),
            _buildProductActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.image_not_supported,
                size: 48,
                color: Colors.grey,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name and favorite button
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildFavoriteButton(context),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.category,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Description
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          // Rating and reviews
          Row(
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: Colors.amber[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${product.rating}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              Text(
                '(${product.reviewCount} reviews)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProvider, child) {
        final isFavorite = userProvider.userProfile.favoriteCategories
            .contains(product.category);
        
        return IconButton(
          onPressed: () {
            if (isFavorite) {
              userProvider.removeFavoriteCategory(product.category);
            } else {
              userProvider.addFavoriteCategory(product.category);
            }
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
        );
      },
    );
  }

  Widget _buildProductActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Price
          Expanded(
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          // Cart controls
          _buildCartControls(context),
        ],
      ),
    );
  }

  Widget _buildCartControls(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, cartProvider, child) {
        final cartItem = cartProvider.findItem(product.id);
        
        if (cartItem == null) {
          // Add to cart button
          return ElevatedButton.icon(
            onPressed: () {
              cartProvider.addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart, size: 18),
            label: const Text('Add'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 36),
            ),
          );
        } else {
          // Quantity controls
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    cartProvider.decrementItem(product.id);
                  },
                  icon: const Icon(Icons.remove, size: 18),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${cartItem.quantity}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cartProvider.incrementItem(product.id);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// lib/presentation/widgets/cart_summary.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_cart_provider.dart';

class CartSummary extends StatelessWidget {
  final bool showDetails;
  final VoidCallback? onCheckout;

  const CartSummary({
    super.key,
    this.showDetails = true,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.isEmpty) {
          return const SizedBox();
        }

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryHeader(context, cartProvider),
                if (showDetails) ...[
                  const SizedBox(height: 16),
                  _buildSummaryDetails(context, cartProvider),
                ],
                const SizedBox(height: 16),
                _buildCheckoutButton(context, cartProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryHeader(BuildContext context, ShoppingCartProvider cartProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${cartProvider.itemCount} items',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryDetails(BuildContext context, ShoppingCartProvider cartProvider) {
    final summary = cartProvider.getSummary();
    final categoryBreakdown = summary['categoryBreakdown'] as Map<String, dynamic>;
    final categoryCount = categoryBreakdown['count'] as Map<String, int>;
    final categoryTotal = categoryBreakdown['total'] as Map<String, double>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(
          'Breakdown by Category',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...categoryCount.entries.map((entry) {
          final category = entry.key;
          final count = entry.value;
          final total = categoryTotal[category] ?? 0.0;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$category ($count items)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, ShoppingCartProvider cartProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: cartProvider.isEmpty ? null : onCheckout,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Proceed to Checkout',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// lib/presentation/widgets/cart_item_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/cart_item.dart';
import '../../providers/shopping_cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildProductImage(),
            const SizedBox(width: 12),
            Expanded(child: _buildProductInfo(context)),
            const SizedBox(width: 12),
            _buildQuantityControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          cartItem.product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItem.product.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          cartItem.product.category,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '\$${cartItem.product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Text(' × '),
            Text(
              '${cartItem.quantity}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(' = '),
            Text(
              '\$${cartItem.totalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, cartProvider, child) {
        return Column(
          children: [
            // Quantity controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      cartProvider.incrementItem(cartItem.product.id);
                    },
                    icon: const Icon(Icons.add, size: 18),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${cartItem.quantity}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cartProvider.decrementItem(cartItem.product.id);
                    },
                    icon: const Icon(Icons.remove, size: 18),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Remove button
            IconButton(
              onPressed: () {
                _showRemoveDialog(context, cartProvider);
              },
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        );
      },
    );
  }

  void _showRemoveDialog(BuildContext context, ShoppingCartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove ${cartItem.product.name} from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.removeItem(cartItem.product.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${cartItem.product.name} removed from cart'),
                ),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/widgets/user_avatar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProvider, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: size / 2 - 1,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: userProvider.userProfile.avatarUrl != null
                  ? NetworkImage(userProvider.userProfile.avatarUrl!)
                  : null,
              child: userProvider.userProfile.avatarUrl == null
                  ? Icon(
                      userProvider.isGuest ? Icons.person_outline : Icons.person,
                      size: size * 0.6,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
```

## **Step 5: Screen Implementation** ⏱️ *30 minutes*

Create application screens that demonstrate Provider integration:

```dart
// lib/presentation/screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/shopping_cart_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/user_avatar.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchAndFilter(context),
          Expanded(child: _buildProductGrid(context)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Shopping App'),
      actions: [
        // Cart button with badge
        Consumer<ShoppingCartProvider>(
          builder: (context, cartProvider, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
                if (cartProvider.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
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
        
        // User avatar
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: UserAvatar(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ProductProvider>().searchProducts('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) {
              context.read<ProductProvider>().searchProducts(query);
            },
          ),
          
          const SizedBox(height: 12),
          
          // Category filter
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: productProvider.selectedCategory == null,
                      onSelected: (selected) {
                        productProvider.filterByCategory(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...productProvider.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: productProvider.selectedCategory == category,
                          onSelected: (selected) {
                            productProvider.filterByCategory(
                              selected ? category : null,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  productProvider.errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => productProvider.loadProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (productProvider.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Try adjusting your search or filters'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => productProvider.clearFilters(),
                  child: const Text('Clear Filters'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: productProvider.products.length,
          itemBuilder: (context, index) {
            final product = productProvider.products[index];
            return ProductCard(
              product: product,
              onTap: () {
                // Navigate to product detail (implement later)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} details'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// lib/presentation/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          Consumer<ShoppingCartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.isEmpty) return const SizedBox();
              
              return TextButton(
                onPressed: () => _showClearCartDialog(context, cartProvider),
                child: const Text('Clear All'),
              );
            },
          ),
        ],
      ),
      body: Consumer<ShoppingCartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items[index];
                    return CartItemWidget(cartItem: cartItem);
                  },
                ),
              ),
              CartSummary(
                onCheckout: () => _handleCheckout(context, cartProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 96,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, ShoppingCartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.clear();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context, ShoppingCartProvider cartProvider) {
    // Simulate checkout process
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary:'),
            const SizedBox(height: 8),
            Text('Items: ${cartProvider.itemCount}'),
            Text('Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('This is a demo checkout. No actual payment will be processed.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              cartProvider.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../core/models/user_profile.dart';
import '../widgets/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isGuest) {
            return _buildGuestView(context, userProvider);
          }

          return _buildUserProfile(context, userProvider);
        },
      ),
    );
  }

  Widget _buildGuestView(BuildContext context, UserProfileProvider userProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const UserAvatar(size: 120),
            const SizedBox(height: 24),
            Text(
              'Welcome, Guest!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to access your profile and preferences',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showLoginDialog(context, userProvider),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserProfileProvider userProvider) {
    final user = userProvider.userProfile;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const UserAvatar(size: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.role.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showEditProfileDialog(context, userProvider),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Favorite categories
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favorite Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (user.favoriteCategories.isEmpty)
                  Text(
                    'No favorite categories yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    children: user.favoriteCategories.map((category) {
                      return Chip(
                        label: Text(category),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          userProvider.removeFavoriteCategory(category);
                        },
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Account actions
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => _showLogoutDialog(context, userProvider),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLoginDialog(BuildContext context, UserProfileProvider userProvider) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                userProvider.login(nameController.text, emailController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Welcome!')),
                );
              }
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserProfileProvider userProvider) {
    final user = userProvider.userProfile;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userProvider.updateName(nameController.text);
              userProvider.updateEmail(emailController.text);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProfileProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              userProvider.logout();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.guest:
        return Colors.grey;
      case UserRole.customer:
        return Colors.blue;
      case UserRole.premium:
        return Colors.purple;
      case UserRole.admin:
        return Colors.red;
    }
  }
}
```

## **Step 6: App Integration & Testing** ⏱️ *20 minutes*

Complete the application with proper Provider setup and testing:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shopping_cart_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/product_provider.dart';
import 'presentation/screens/product_list_screen.dart';

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShoppingCartProvider>(
          create: (context) => ShoppingCartProvider(),
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) => UserProfileProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping App - Provider Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.dark,
          ),
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}

// test/providers/shopping_cart_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../lib/providers/shopping_cart_provider.dart';
import '../lib/core/models/product.dart';

void main() {
  group('ShoppingCartProvider Tests', () {
    late ShoppingCartProvider cartProvider;
    late Product testProduct;

    setUp(() {
      cartProvider = ShoppingCartProvider();
      testProduct = const Product(
        id: '1',
        name: 'Test Product',
        description: 'A test product',
        price: 9.99,
        imageUrl: 'test.jpg',
        category: 'Test',
      );
    });

    test('should start empty', () {
      expect(cartProvider.isEmpty, isTrue);
      expect(cartProvider.itemCount, equals(0));
      expect(cartProvider.totalPrice, equals(0.0));
    });

    test('should add item to cart', () {
      cartProvider.addItem(testProduct);

      expect(cartProvider.isEmpty, isFalse);
      expect(cartProvider.itemCount, equals(1));
      expect(cartProvider.totalPrice, equals(9.99));
      expect(cartProvider.containsProduct('1'), isTrue);
    });

    test('should increase quantity when adding same item', () {
      cartProvider.addItem(testProduct);
      cartProvider.addItem(testProduct);

      expect(cartProvider.itemCount, equals(2));
      expect(cartProvider.totalPrice, equals(19.98));
      
      final item = cartProvider.findItem('1');
      expect(item?.quantity, equals(2));
    });

    test('should remove item from cart', () {
      cartProvider.addItem(testProduct);
      expect(cartProvider.isNotEmpty, isTrue);

      cartProvider.removeItem('1');
      expect(cartProvider.isEmpty, isTrue);
      expect(cartProvider.containsProduct('1'), isFalse);
    });

    test('should update item quantity', () {
      cartProvider.addItem(testProduct);
      cartProvider.updateQuantity('1', 5);

      expect(cartProvider.itemCount, equals(5));
      expect(cartProvider.totalPrice, equals(49.95));
    });

    test('should remove item when quantity set to 0', () {
      cartProvider.addItem(testProduct);
      cartProvider.updateQuantity('1', 0);

      expect(cartProvider.isEmpty, isTrue);
    });

    test('should clear entire cart', () {
      cartProvider.addItem(testProduct);
      cartProvider.addItem(testProduct);
      expect(cartProvider.isNotEmpty, isTrue);

      cartProvider.clear();
      expect(cartProvider.isEmpty, isTrue);
    });

    test('should notify listeners when cart changes', () {
      bool notified = false;
      cartProvider.addListener(() {
        notified = true;
      });

      cartProvider.addItem(testProduct);
      expect(notified, isTrue);
    });

    test('should provide accurate summary', () {
      cartProvider.addItem(testProduct, quantity: 2);
      
      final summary = cartProvider.getSummary();
      expect(summary['totalItems'], equals(2));
      expect(summary['totalPrice'], equals(19.98));
      expect(summary['uniqueProducts'], equals(1));
    });
  });
}

// test/widgets/product_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../lib/presentation/widgets/product_card.dart';
import '../lib/providers/shopping_cart_provider.dart';
import '../lib/providers/user_profile_provider.dart';
import '../lib/core/models/product.dart';

void main() {
  group('ProductCard Widget Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = const Product(
        id: '1',
        name: 'Test Product',
        description: 'A test product description',
        price: 29.99,
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Electronics',
        rating: 4.5,
        reviewCount: 42,
      );
    });

    testWidgets('should display product information correctly', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ShoppingCartProvider>(
              create: (_) => ShoppingCartProvider(),
            ),
            ChangeNotifierProvider<UserProfileProvider>(
              create: (_) => UserProfileProvider(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ProductCard(product: testProduct),
            ),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('A test product description'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(42 reviews)'), findsOneWidget);
    });

    testWidgets('should add product to cart when button pressed', (tester) async {
      final cartProvider = ShoppingCartProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ShoppingCartProvider>.value(
              value: cartProvider,
            ),
            ChangeNotifierProvider<UserProfileProvider>(
              create: (_) => UserProfileProvider(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ProductCard(product: testProduct),
            ),
          ),
        ),
      );

      expect(find.text('Add'), findsOneWidget);
      expect(cartProvider.isEmpty, isTrue);

      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(cartProvider.isEmpty, isFalse);
      expect(cartProvider.itemCount, equals(1));
      expect(cartProvider.containsProduct('1'), isTrue);
    });

    testWidgets('should show quantity controls when item in cart', (tester) async {
      final cartProvider = ShoppingCartProvider();
      cartProvider.addItem(testProduct, quantity: 2);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ShoppingCartProvider>.value(
              value: cartProvider,
            ),
            ChangeNotifierProvider<UserProfileProvider>(
              create: (_) => UserProfileProvider(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ProductCard(product: testProduct),
            ),
          ),
        ),
      );

      expect(find.text('2'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });
  });
}
```

## 🎉 **Congratulations!**

You've successfully implemented a comprehensive shopping cart application demonstrating:

✅ **InheritedWidget Mastery** - Understanding Flutter's built-in dependency injection  
✅ **Provider Excellence** - Simplified state management with reactive updates  
✅ **ChangeNotifier Patterns** - Professional reactive state models with automatic notifications  
✅ **Context Operations** - Safe and efficient access to shared state across widget trees  
✅ **Performance Optimization** - Selective rebuilds with Consumer and Selector patterns  
✅ **Clean Architecture** - Proper separation of state management and UI components

## 🎯 **Key Learning Achievements**

### **Shared State Management:**
1. **InheritedWidget Understanding** - Flutter's built-in mechanism for dependency injection
2. **Provider Simplification** - Easier state management with powerful features
3. **ChangeNotifier Mastery** - Reactive state models with automatic rebuild notifications
4. **Context Safety** - Proper usage patterns for accessing shared state
5. **Performance Optimization** - Selective rebuilds and efficient state updates
6. **Testing Strategies** - Comprehensive testing for Provider-based applications

### **This implementation demonstrates:**
- **✅ Production-ready patterns** used in professional Flutter applications
- **✅ Clean architecture** applied to shared state management
- **✅ Performance excellence** with selective rebuilds and efficient updates
- **✅ Comprehensive testing** strategies for Provider-based state management
- **✅ User experience** excellence with real-time state synchronization
- **✅ Professional code quality** with proper state organization and patterns

## 🎯 **Ready for Advanced State Management!**

With this solid foundation in InheritedWidget and Provider, you're now ready to:
- **Understand state sharing** patterns across complex widget trees
- **Appreciate Provider benefits** over manual InheritedWidget implementation
- **Continue to Lesson 12** - Riverpod 2.0 for even more advanced state management
- **Build scalable applications** with proper shared state architecture

**You've mastered shared state management with InheritedWidget and Provider! 🌳✨🚀**