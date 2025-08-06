/// Shopping cart state management with Provider pattern
/// 
/// This file demonstrates the modern approach to state sharing using
/// Provider and ChangeNotifier for simplified state management.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/models/product.dart';
import '../core/models/cart_item.dart';

/// Shopping cart state management using Provider and ChangeNotifier
/// 
/// Demonstrates the modern approach to shared state management with
/// automatic dependency injection and optimized rebuilds.
class ShoppingCartProvider with ChangeNotifier {
  /// Creates a shopping cart provider
  ShoppingCartProvider() {
    if (kDebugMode) {
      debugPrint('🛒 ShoppingCartProvider initialized');
    }
  }

  /// List of cart items
  List<CartItem> _items = [];

  /// Whether cart operations are in progress
  bool _isLoading = false;

  /// Error message if any operation failed
  String? _errorMessage;

  /// When the cart was last updated
  DateTime? _lastUpdated;

  /// Get list of cart items (immutable)
  List<CartItem> get items => List.unmodifiable(_items);

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Get last updated time
  DateTime? get lastUpdated => _lastUpdated;

  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error message
  void _setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update last updated time
  void _updateTimestamp() {
    _lastUpdated = DateTime.now();
  }

  /// Clear error state
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Add product to cart
  Future<void> addToCart(Product product, {
    int quantity = 1,
    Map<String, String>? selectedOptions,
    String? note,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

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
        _setError(validation.errorMessage);
        return;
      }

      // Check if item with same product and options already exists
      final existingIndex = _items.indexWhere(
        (item) => item.matchesProduct(cartItem.product, cartItem.selectedOptions),
      );

      if (existingIndex != -1) {
        // Merge with existing item
        _items[existingIndex] = _items[existingIndex].mergeWith(cartItem);
      } else {
        // Add as new item
        _items.add(cartItem);
      }

      _updateTimestamp();
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('🛒 Added ${product.name} to cart (quantity: $quantity)');
      }

    } catch (error) {
      _setError('Failed to add item to cart: $error');
      if (kDebugMode) {
        debugPrint('❌ Error adding to cart: $error');
      }
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 200));

      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final removedItem = _items.removeAt(itemIndex);
        _updateTimestamp();
        
        if (kDebugMode) {
          debugPrint('🛒 Removed ${removedItem.product.name} from cart');
        }
      }

      _setLoading(false);

    } catch (error) {
      _setError('Failed to remove item: $error');
      if (kDebugMode) {
        debugPrint('❌ Error removing from cart: $error');
      }
    }
  }

  /// Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 200));

      if (newQuantity <= 0) {
        await removeFromCart(itemId);
        return;
      }

      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _items[itemIndex] = _items[itemIndex].updateQuantity(newQuantity);
        _updateTimestamp();
        
        if (kDebugMode) {
          debugPrint('🛒 Updated quantity for ${_items[itemIndex].product.name}: $newQuantity');
        }
      }

      _setLoading(false);

    } catch (error) {
      _setError('Failed to update quantity: $error');
      if (kDebugMode) {
        debugPrint('❌ Error updating quantity: $error');
      }
    }
  }

  /// Increment item quantity
  Future<void> incrementQuantity(String itemId) async {
    final item = findItem(itemId);
    if (item != null) {
      await updateQuantity(itemId, item.quantity + 1);
    }
  }

  /// Decrement item quantity
  Future<void> decrementQuantity(String itemId) async {
    final item = findItem(itemId);
    if (item != null) {
      await updateQuantity(itemId, item.quantity - 1);
    }
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 300));

      _items.clear();
      _updateTimestamp();
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('🛒 Cart cleared');
      }

    } catch (error) {
      _setError('Failed to clear cart: $error');
      if (kDebugMode) {
        debugPrint('❌ Error clearing cart: $error');
      }
    }
  }

  /// Update item note
  Future<void> updateItemNote(String itemId, String? note) async {
    try {
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _items[itemIndex] = _items[itemIndex].updateNote(note);
        _updateTimestamp();
        notifyListeners();
        
        if (kDebugMode) {
          debugPrint('🛒 Updated note for ${_items[itemIndex].product.name}');
        }
      }
    } catch (error) {
      _setError('Failed to update note: $error');
    }
  }

  /// Update item options
  Future<void> updateItemOptions(String itemId, Map<String, String> options) async {
    try {
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        var updatedItem = _items[itemIndex];
        for (final entry in options.entries) {
          updatedItem = updatedItem.updateOption(entry.key, entry.value);
        }
        _items[itemIndex] = updatedItem;
        _updateTimestamp();
        notifyListeners();
        
        if (kDebugMode) {
          debugPrint('🛒 Updated options for ${_items[itemIndex].product.name}');
        }
      }
    } catch (error) {
      _setError('Failed to update options: $error');
    }
  }

  /// Business logic: Get total number of items
  int get totalItems => _items.length;

  /// Business logic: Get total quantity
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Business logic: Get total price
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Business logic: Get total original price
  double get totalOriginalPrice => _items.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);

  /// Business logic: Get total discount amount
  double get totalDiscountAmount => totalOriginalPrice - totalPrice;

  /// Business logic: Get subtotal (same as total for now, but could include taxes later)
  double get subtotal => totalPrice;

  /// Business logic: Calculate estimated tax (8.5% for demo)
  double get estimatedTax => totalPrice * 0.085;

  /// Business logic: Calculate shipping cost
  double get shippingCost {
    if (isEmpty) return 0.0;
    if (totalPrice >= 50.0) return 0.0; // Free shipping over $50
    return 5.99;
  }

  /// Business logic: Get grand total including tax and shipping
  double get grandTotal => totalPrice + estimatedTax + shippingCost;

  /// Business logic: Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Business logic: Check if cart has items
  bool get isNotEmpty => _items.isNotEmpty;

  /// Business logic: Check if cart has discounts
  bool get hasDiscounts => totalDiscountAmount > 0;

  /// Business logic: Check if eligible for free shipping
  bool get isEligibleForFreeShipping => totalPrice >= 50.0;

  /// Business logic: Get amount needed for free shipping
  double get amountNeededForFreeShipping {
    if (isEligibleForFreeShipping) return 0.0;
    return 50.0 - totalPrice;
  }

  /// Business logic: Get formatted total price
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Business logic: Get formatted discount amount
  String get formattedDiscountAmount => '\$${totalDiscountAmount.toStringAsFixed(2)}';

  /// Business logic: Get formatted grand total
  String get formattedGrandTotal => '\$${grandTotal.toStringAsFixed(2)}';

  /// Business logic: Get formatted estimated tax
  String get formattedEstimatedTax => '\$${estimatedTax.toStringAsFixed(2)}';

  /// Business logic: Get formatted shipping cost
  String get formattedShippingCost => shippingCost == 0.0 ? 'FREE' : '\$${shippingCost.toStringAsFixed(2)}';

  /// Find item by ID
  CartItem? findItem(String itemId) {
    try {
      return _items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Check if product is in cart
  bool containsProduct(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Get quantity of product in cart
  int getProductQuantity(String productId) {
    return _items
        .where((item) => item.product.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get items by category
  List<CartItem> getItemsByCategory(ProductCategory category) {
    return _items.where((item) => item.product.category == category).toList();
  }

  /// Get cart statistics
  CartItemStatistics get statistics {
    return CartItemStatistics.fromCartItems(_items);
  }

  /// Validate entire cart
  List<String> validateCart() {
    final errors = <String>[];
    
    for (final item in _items) {
      final validation = item.validate();
      if (!validation.isValid) {
        errors.addAll(validation.errors.map((error) => '${item.product.name}: $error'));
      }
    }
    
    return errors;
  }

  /// Get items that exceed stock
  List<CartItem> get itemsExceedingStock {
    return _items.where((item) => item.exceedsStock).toList();
  }

  /// Get unavailable items
  List<CartItem> get unavailableItems {
    return _items.where((item) => !item.isProductAvailable).toList();
  }

  /// Remove unavailable items
  Future<void> removeUnavailableItems() async {
    final unavailable = unavailableItems;
    if (unavailable.isEmpty) return;

    for (final item in unavailable) {
      await removeFromCart(item.id);
    }

    if (kDebugMode) {
      debugPrint('🛒 Removed ${unavailable.length} unavailable items');
    }
  }

  /// Optimize cart (remove unavailable items, fix quantities)
  Future<void> optimizeCart() async {
    try {
      _setLoading(true);

      // Remove unavailable items
      await removeUnavailableItems();

      // Fix quantities that exceed stock
      for (final item in itemsExceedingStock) {
        final maxQuantity = item.maxAvailableQuantity;
        if (maxQuantity > 0) {
          await updateQuantity(item.id, maxQuantity);
        } else {
          await removeFromCart(item.id);
        }
      }

      _setLoading(false);

      if (kDebugMode) {
        debugPrint('🛒 Cart optimized');
      }

    } catch (error) {
      _setError('Failed to optimize cart: $error');
    }
  }

  /// Save cart to local storage (placeholder for real implementation)
  Future<void> saveToStorage() async {
    try {
      // In a real app, this would save to SharedPreferences, Hive, etc.
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (kDebugMode) {
        debugPrint('🛒 Cart saved to storage');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('❌ Failed to save cart: $error');
      }
    }
  }

  /// Load cart from local storage (placeholder for real implementation)
  Future<void> loadFromStorage() async {
    try {
      // In a real app, this would load from SharedPreferences, Hive, etc.
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (kDebugMode) {
        debugPrint('🛒 Cart loaded from storage');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load cart: $error');
      }
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('🛒 ShoppingCartProvider disposed');
    }
    super.dispose();
  }

  @override
  String toString() {
    return 'ShoppingCartProvider('
        'items: ${_items.length}, '
        'totalQuantity: $totalQuantity, '
        'totalPrice: $formattedTotalPrice, '
        'isLoading: $_isLoading'
        ')';
  }
}