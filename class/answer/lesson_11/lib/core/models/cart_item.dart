/// Cart item entity with quantity management and pricing calculations
/// 
/// This file defines the CartItem model that represents products in the
/// shopping cart with quantity tracking and total price calculations.
library;

import 'package:flutter/foundation.dart';
import 'product.dart';

/// Immutable CartItem entity for shopping cart management
/// 
/// Represents a product in the shopping cart with quantity tracking,
/// pricing calculations, and immutable update patterns.
@immutable
class CartItem {
  /// Creates a new CartItem instance
  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
    this.selectedOptions = const {},
    this.note,
  });

  /// Unique cart item identifier
  final String id;

  /// The product in the cart
  final Product product;

  /// Quantity of the product
  final int quantity;

  /// When the item was added to cart
  final DateTime addedAt;

  /// Selected product options (size, color, etc.)
  final Map<String, String> selectedOptions;

  /// Optional note for the item
  final String? note;

  /// Create a cart item from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
      selectedOptions: Map<String, String>.from(json['selectedOptions'] as Map? ?? {}),
      note: json['note'] as String?,
    );
  }

  /// Convert cart item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'selectedOptions': selectedOptions,
      'note': note,
    };
  }

  /// Create a copy with modified fields (immutable update pattern)
  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    DateTime? addedAt,
    Map<String, String>? selectedOptions,
    String? note,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      note: note ?? this.note,
    );
  }

  /// Create a new cart item from a product
  factory CartItem.fromProduct(
    Product product, {
    int quantity = 1,
    Map<String, String>? selectedOptions,
    String? note,
  }) {
    return CartItem(
      id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
      product: product,
      quantity: quantity,
      addedAt: DateTime.now(),
      selectedOptions: selectedOptions ?? {},
      note: note,
    );
  }

  /// Increment quantity
  CartItem incrementQuantity([int amount = 1]) {
    return copyWith(quantity: quantity + amount);
  }

  /// Decrement quantity
  CartItem decrementQuantity([int amount = 1]) {
    final newQuantity = quantity - amount;
    return copyWith(quantity: newQuantity > 0 ? newQuantity : 1);
  }

  /// Update quantity to specific value
  CartItem updateQuantity(int newQuantity) {
    return copyWith(quantity: newQuantity > 0 ? newQuantity : 1);
  }

  /// Add or update selected option
  CartItem updateOption(String key, String value) {
    final updatedOptions = Map<String, String>.from(selectedOptions);
    updatedOptions[key] = value;
    return copyWith(selectedOptions: updatedOptions);
  }

  /// Remove selected option
  CartItem removeOption(String key) {
    final updatedOptions = Map<String, String>.from(selectedOptions);
    updatedOptions.remove(key);
    return copyWith(selectedOptions: updatedOptions);
  }

  /// Update note
  CartItem updateNote(String? newNote) {
    return copyWith(note: newNote?.isEmpty == true ? null : newNote);
  }

  /// Business logic: Calculate total price for this cart item
  double get totalPrice => product.price * quantity;

  /// Business logic: Calculate total original price (before discounts)
  double get totalOriginalPrice => (product.originalPrice ?? product.price) * quantity;

  /// Business logic: Calculate total discount amount
  double get totalDiscountAmount => totalOriginalPrice - totalPrice;

  /// Business logic: Check if item has discount
  bool get hasDiscount => product.hasDiscount;

  /// Business logic: Get discount percentage
  double get discountPercentage => product.discount;

  /// Business logic: Get formatted total price
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Business logic: Get formatted original price
  String get formattedTotalOriginalPrice => '\$${totalOriginalPrice.toStringAsFixed(2)}';

  /// Business logic: Get formatted discount amount
  String get formattedDiscountAmount => '\$${totalDiscountAmount.toStringAsFixed(2)}';

  /// Business logic: Check if quantity exceeds stock
  bool get exceedsStock => quantity > product.stockQuantity;

  /// Business logic: Get maximum available quantity
  int get maxAvailableQuantity => product.stockQuantity;

  /// Business logic: Check if product is still available
  bool get isProductAvailable => product.status.canAddToCart;

  /// Business logic: Get weight for this cart item
  double? get totalWeight => product.weight != null ? product.weight! * quantity : null;

  /// Business logic: Get formatted weight
  String get formattedTotalWeight => totalWeight != null ? '${totalWeight!.toStringAsFixed(1)}g' : 'N/A';

  /// Business logic: Get item summary for display
  String get itemSummary {
    final buffer = StringBuffer();
    buffer.write('${product.name} x$quantity');
    
    if (selectedOptions.isNotEmpty) {
      final optionsText = selectedOptions.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
      buffer.write(' ($optionsText)');
    }
    
    return buffer.toString();
  }

  /// Business logic: Get options display text
  String get optionsDisplayText {
    if (selectedOptions.isEmpty) return '';
    
    return selectedOptions.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(' • ');
  }

  /// Validation: Check if cart item data is valid
  CartItemValidationResult validate() {
    final errors = <String>[];

    // Quantity validation
    if (quantity <= 0) {
      errors.add('Quantity must be greater than 0');
    }

    if (quantity > product.stockQuantity && product.status == ProductStatus.available) {
      errors.add('Quantity exceeds available stock (${product.stockQuantity} available)');
    }

    // Product availability validation
    if (!product.status.canAddToCart) {
      errors.add('Product is not available for purchase');
    }

    // Product validation
    final productValidation = product.validate();
    if (!productValidation.isValid) {
      errors.addAll(productValidation.errors.map((error) => 'Product: $error'));
    }

    return CartItemValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Check if this cart item matches another product (for merging)
  bool matchesProduct(Product otherProduct, [Map<String, String>? otherOptions]) {
    return product.id == otherProduct.id && 
           mapEquals(selectedOptions, otherOptions ?? <String, String>{});
  }

  /// Merge with another cart item (combine quantities)
  CartItem mergeWith(CartItem other) {
    if (!matchesProduct(other.product, other.selectedOptions)) {
      throw ArgumentError('Cannot merge cart items with different products or options');
    }

    return copyWith(
      quantity: quantity + other.quantity,
      addedAt: addedAt.isBefore(other.addedAt) ? addedAt : other.addedAt,
      note: note ?? other.note, // Keep existing note or use other's note
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.id == id &&
        other.product == product &&
        other.quantity == quantity &&
        other.addedAt == addedAt &&
        mapEquals(other.selectedOptions, selectedOptions) &&
        other.note == note;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      product,
      quantity,
      addedAt,
      Object.hashAll(selectedOptions.entries),
      note,
    );
  }

  @override
  String toString() {
    return 'CartItem('
        'id: $id, '
        'product: ${product.name}, '
        'quantity: $quantity, '
        'totalPrice: $formattedTotalPrice, '
        'options: $selectedOptions'
        ')';
  }
}

/// Cart item validation result
class CartItemValidationResult {
  const CartItemValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Whether the cart item data is valid
  final bool isValid;

  /// List of validation errors
  final List<String> errors;

  /// Get formatted error message
  String get errorMessage => errors.join('\n');

  @override
  String toString() {
    return 'CartItemValidationResult(isValid: $isValid, errors: ${errors.length})';
  }
}

/// Cart item statistics for analytics
@immutable
class CartItemStatistics {
  const CartItemStatistics({
    required this.totalItems,
    required this.totalQuantity,
    required this.totalPrice,
    required this.totalOriginalPrice,
    required this.totalDiscountAmount,
    required this.totalWeight,
    required this.categoryBreakdown,
    required this.averageItemPrice,
  });

  /// Total number of unique items
  final int totalItems;

  /// Total quantity of all items
  final int totalQuantity;

  /// Total price of all items
  final double totalPrice;

  /// Total original price (before discounts)
  final double totalOriginalPrice;

  /// Total discount amount
  final double totalDiscountAmount;

  /// Total weight of all items
  final double? totalWeight;

  /// Breakdown by product category
  final Map<ProductCategory, int> categoryBreakdown;

  /// Average price per item
  final double averageItemPrice;

  /// Create statistics from a list of cart items
  factory CartItemStatistics.fromCartItems(List<CartItem> items) {
    if (items.isEmpty) {
      return const CartItemStatistics(
        totalItems: 0,
        totalQuantity: 0,
        totalPrice: 0.0,
        totalOriginalPrice: 0.0,
        totalDiscountAmount: 0.0,
        totalWeight: null,
        categoryBreakdown: {},
        averageItemPrice: 0.0,
      );
    }

    final totalItems = items.length;
    final totalQuantity = items.fold(0, (sum, item) => sum + item.quantity);
    final totalPrice = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final totalOriginalPrice = items.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);
    final totalDiscountAmount = totalOriginalPrice - totalPrice;

    // Calculate total weight
    double? totalWeight;
    final weightsAvailable = items.where((item) => item.totalWeight != null).toList();
    if (weightsAvailable.isNotEmpty) {
      totalWeight = weightsAvailable.fold(0.0, (sum, item) => sum + item.totalWeight!);
    }

    // Category breakdown
    final categoryBreakdown = <ProductCategory, int>{};
    for (final item in items) {
      categoryBreakdown[item.product.category] = 
          (categoryBreakdown[item.product.category] ?? 0) + item.quantity;
    }

    // Average item price
    final averageItemPrice = totalItems > 0 ? totalPrice / totalItems : 0.0;

    return CartItemStatistics(
      totalItems: totalItems,
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
      totalOriginalPrice: totalOriginalPrice,
      totalDiscountAmount: totalDiscountAmount,
      totalWeight: totalWeight,
      categoryBreakdown: categoryBreakdown,
      averageItemPrice: averageItemPrice,
    );
  }

  /// Get discount percentage
  double get discountPercentage => 
      totalOriginalPrice > 0 ? totalDiscountAmount / totalOriginalPrice : 0.0;

  /// Get formatted total price
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Get formatted original price
  String get formattedTotalOriginalPrice => '\$${totalOriginalPrice.toStringAsFixed(2)}';

  /// Get formatted discount amount
  String get formattedDiscountAmount => '\$${totalDiscountAmount.toStringAsFixed(2)}';

  /// Get formatted total weight
  String get formattedTotalWeight => totalWeight != null ? '${totalWeight!.toStringAsFixed(1)}g' : 'N/A';

  /// Get formatted average item price
  String get formattedAverageItemPrice => '\$${averageItemPrice.toStringAsFixed(2)}';

  @override
  String toString() {
    return 'CartItemStatistics('
        'items: $totalItems, '
        'quantity: $totalQuantity, '
        'total: $formattedTotalPrice, '
        'discount: $formattedDiscountAmount'
        ')';
  }
}