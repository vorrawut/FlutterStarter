/// Shopping cart state management with pure InheritedWidget
/// 
/// This file demonstrates the traditional approach to state sharing using
/// InheritedWidget before showing the Provider package simplification.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/models/product.dart';
import '../../core/models/cart_item.dart';

/// Shopping cart state management using pure InheritedWidget
/// 
/// Demonstrates the traditional approach to sharing state across widgets
/// using Flutter's built-in InheritedWidget mechanism.
class ShoppingCartInheritedWidget extends InheritedWidget {
  /// Creates a shopping cart inherited widget
  const ShoppingCartInheritedWidget({
    super.key,
    required this.cartData,
    required super.child,
  });

  /// Cart state data
  final ShoppingCartData cartData;

  /// Access the shopping cart from context
  static ShoppingCartData? of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ShoppingCartInheritedWidget>();
    return widget?.cartData;
  }

  /// Access the shopping cart from context (throws if not found)
  static ShoppingCartData ofRequired(BuildContext context) {
    final cartData = of(context);
    if (cartData == null) {
      throw FlutterError(
        'ShoppingCartInheritedWidget.ofRequired() called with a context that does not '
        'contain a ShoppingCartInheritedWidget.\n'
        'No ShoppingCartInheritedWidget ancestor could be found starting from the context '
        'that was passed to ShoppingCartInheritedWidget.ofRequired().',
      );
    }
    return cartData;
  }

  @override
  bool updateShouldNotify(ShoppingCartInheritedWidget oldWidget) {
    // Only notify dependents if the cart data has actually changed
    return cartData != oldWidget.cartData;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ShoppingCartData>('cartData', cartData));
  }
}

/// Immutable shopping cart data for InheritedWidget
/// 
/// Contains the current state of the shopping cart with immutable
/// update patterns for predictable state management.
@immutable
class ShoppingCartData {
  /// Creates shopping cart data
  const ShoppingCartData({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdated,
  });

  /// List of cart items
  final List<CartItem> items;

  /// Whether cart operations are in progress
  final bool isLoading;

  /// Error message if any operation failed
  final String? errorMessage;

  /// When the cart was last updated
  final DateTime? lastUpdated;

  /// Create a copy with modified fields
  ShoppingCartData copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return ShoppingCartData(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Add item to cart
  ShoppingCartData addItem(CartItem newItem) {
    // Check if item with same product and options already exists
    final existingIndex = items.indexWhere(
      (item) => item.matchesProduct(newItem.product, newItem.selectedOptions),
    );

    List<CartItem> updatedItems;
    if (existingIndex != -1) {
      // Merge with existing item
      updatedItems = List.from(items);
      updatedItems[existingIndex] = items[existingIndex].mergeWith(newItem);
    } else {
      // Add as new item
      updatedItems = [...items, newItem];
    }

    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Remove item from cart
  ShoppingCartData removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    
    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Update item quantity
  ShoppingCartData updateItemQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeItem(itemId);
    }

    final updatedItems = items.map((item) {
      if (item.id == itemId) {
        return item.updateQuantity(newQuantity);
      }
      return item;
    }).toList();

    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Clear all items from cart
  ShoppingCartData clear() {
    return copyWith(
      items: [],
      lastUpdated: DateTime.now(),
      errorMessage: null,
    );
  }

  /// Set loading state
  ShoppingCartData setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  /// Set error message
  ShoppingCartData setError(String? error) {
    return copyWith(
      errorMessage: error,
      isLoading: false,
    );
  }

  /// Business logic: Get total number of items
  int get totalItems => items.length;

  /// Business logic: Get total quantity
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Business logic: Get total price
  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Business logic: Get total original price
  double get totalOriginalPrice => items.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);

  /// Business logic: Get total discount amount
  double get totalDiscountAmount => totalOriginalPrice - totalPrice;

  /// Business logic: Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Business logic: Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Business logic: Get formatted total price
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Business logic: Get formatted discount amount
  String get formattedDiscountAmount => '\$${totalDiscountAmount.toStringAsFixed(2)}';

  /// Business logic: Check if cart has discounts
  bool get hasDiscounts => totalDiscountAmount > 0;

  /// Business logic: Find item by ID
  CartItem? findItem(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Business logic: Check if product is in cart
  bool containsProduct(String productId) {
    return items.any((item) => item.product.id == productId);
  }

  /// Business logic: Get quantity of product in cart
  int getProductQuantity(String productId) {
    return items
        .where((item) => item.product.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingCartData &&
        listEquals(other.items, items) &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(items),
      isLoading,
      errorMessage,
      lastUpdated,
    );
  }

  @override
  String toString() {
    return 'ShoppingCartData('
        'items: ${items.length}, '
        'totalQuantity: $totalQuantity, '
        'totalPrice: $formattedTotalPrice, '
        'isLoading: $isLoading'
        ')';
  }
}

/// StatefulWidget wrapper for managing shopping cart state with InheritedWidget
/// 
/// Demonstrates how to combine StatefulWidget with InheritedWidget to create
/// a state management solution before Provider was available.
class ShoppingCartManager extends StatefulWidget {
  /// Creates a shopping cart manager
  const ShoppingCartManager({
    super.key,
    required this.child,
    this.onCartChanged,
  });

  /// Child widget that will have access to cart state
  final Widget child;

  /// Callback when cart changes
  final void Function(ShoppingCartData cartData)? onCartChanged;

  @override
  State<ShoppingCartManager> createState() => ShoppingCartManagerState();
}

/// State class for shopping cart manager
/// 
/// Manages the actual cart state and provides methods for cart operations.
class ShoppingCartManagerState extends State<ShoppingCartManager> {
  /// Current cart data
  ShoppingCartData _cartData = const ShoppingCartData();

  /// Get current cart data
  ShoppingCartData get cartData => _cartData;

  /// Update cart data and notify listeners
  void _updateCartData(ShoppingCartData newCartData) {
    if (_cartData != newCartData) {
      setState(() {
        _cartData = newCartData;
      });
      widget.onCartChanged?.call(_cartData);
    }
  }

  /// Add product to cart
  Future<void> addToCart(Product product, {
    int quantity = 1,
    Map<String, String>? selectedOptions,
    String? note,
  }) async {
    // Set loading state
    _updateCartData(_cartData.setLoading(true));

    try {
      // Simulate async operation (e.g., API call)
      await Future.delayed(const Duration(milliseconds: 300));

      // Create cart item
      final cartItem = CartItem.fromProduct(
        product,
        quantity: quantity,
        selectedOptions: selectedOptions,
        note: note,
      );

      // Validate cart item
      final validation = cartItem.validate();
      if (!validation.isValid) {
        _updateCartData(_cartData.setError(validation.errorMessage));
        return;
      }

      // Add item to cart
      _updateCartData(_cartData.addItem(cartItem).setLoading(false));

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to cart'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

    } catch (error) {
      _updateCartData(_cartData.setError('Failed to add item to cart: $error'));
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    // Set loading state
    _updateCartData(_cartData.setLoading(true));

    try {
      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 200));

      // Remove item
      _updateCartData(_cartData.removeItem(itemId).setLoading(false));

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart'),
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (error) {
      _updateCartData(_cartData.setError('Failed to remove item: $error'));
    }
  }

  /// Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    // Set loading state
    _updateCartData(_cartData.setLoading(true));

    try {
      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 200));

      // Update quantity
      _updateCartData(_cartData.updateItemQuantity(itemId, newQuantity).setLoading(false));

    } catch (error) {
      _updateCartData(_cartData.setError('Failed to update quantity: $error'));
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Set loading state
    _updateCartData(_cartData.setLoading(true));

    try {
      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 300));

      // Clear cart
      _updateCartData(_cartData.clear().setLoading(false));

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cart cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (error) {
      _updateCartData(_cartData.setError('Failed to clear cart: $error'));
    }
  }

  /// Clear error state
  void clearError() {
    _updateCartData(_cartData.setError(null));
  }

  @override
  Widget build(BuildContext context) {
    return ShoppingCartInheritedWidget(
      cartData: _cartData,
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ShoppingCartData>('cartData', _cartData));
  }
}

/// Static helper methods for accessing cart operations
/// 
/// Provides convenient static methods for accessing cart operations
/// from anywhere in the widget tree.
class ShoppingCartInheritedHelper {
  /// Private constructor
  ShoppingCartInheritedHelper._();

  /// Get cart data from context
  static ShoppingCartData? getCartData(BuildContext context) {
    return ShoppingCartInheritedWidget.of(context);
  }

  /// Get cart manager state from context
  static ShoppingCartManagerState? getCartManager(BuildContext context) {
    return context.findAncestorStateOfType<ShoppingCartManagerState>();
  }

  /// Add product to cart
  static Future<void> addToCart(
    BuildContext context,
    Product product, {
    int quantity = 1,
    Map<String, String>? selectedOptions,
    String? note,
  }) async {
    final manager = getCartManager(context);
    if (manager != null) {
      await manager.addToCart(
        product,
        quantity: quantity,
        selectedOptions: selectedOptions,
        note: note,
      );
    }
  }

  /// Remove item from cart
  static Future<void> removeFromCart(BuildContext context, String itemId) async {
    final manager = getCartManager(context);
    if (manager != null) {
      await manager.removeFromCart(itemId);
    }
  }

  /// Update item quantity
  static Future<void> updateQuantity(BuildContext context, String itemId, int newQuantity) async {
    final manager = getCartManager(context);
    if (manager != null) {
      await manager.updateQuantity(itemId, newQuantity);
    }
  }

  /// Clear cart
  static Future<void> clearCart(BuildContext context) async {
    final manager = getCartManager(context);
    if (manager != null) {
      await manager.clearCart();
    }
  }

  /// Clear error state
  static void clearError(BuildContext context) {
    final manager = getCartManager(context);
    manager?.clearError();
  }
}

/// Widget that rebuilds when cart data changes
/// 
/// Provides a convenient way to rebuild widgets when cart state changes,
/// similar to Consumer in Provider but for InheritedWidget.
class ShoppingCartBuilder extends StatelessWidget {
  /// Creates a shopping cart builder
  const ShoppingCartBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  /// Builder function that receives cart data
  final Widget Function(BuildContext context, ShoppingCartData? cartData, Widget? child) builder;

  /// Optional child widget that doesn't need to rebuild
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final cartData = ShoppingCartInheritedWidget.of(context);
    return builder(context, cartData, child);
  }
}