/// Product entity with business logic for e-commerce operations
/// 
/// This file defines the core Product model with immutable patterns,
/// business logic, search functionality, and category management.
library;

import 'package:flutter/foundation.dart';

/// Product category enumeration
enum ProductCategory {
  electronics('Electronics', Icons.devices),
  clothing('Clothing', Icons.checkroom),
  books('Books', Icons.book),
  home('Home & Garden', Icons.home),
  sports('Sports & Outdoors', Icons.sports),
  beauty('Beauty & Personal Care', Icons.face),
  toys('Toys & Games', Icons.toys),
  automotive('Automotive', Icons.directions_car);

  const ProductCategory(this.displayName, this.icon);

  /// Display name for the category
  final String displayName;

  /// Icon representing the category
  final IconData icon;
}

/// Product availability status
enum ProductStatus {
  available('Available'),
  outOfStock('Out of Stock'),
  discontinued('Discontinued'),
  preOrder('Pre-Order');

  const ProductStatus(this.label);

  /// Display label for the status
  final String label;

  /// Whether the product can be added to cart
  bool get canAddToCart => this == ProductStatus.available || this == ProductStatus.preOrder;

  /// Get status color
  Color get color {
    switch (this) {
      case ProductStatus.available:
        return const Color(0xFF10B981); // Green
      case ProductStatus.outOfStock:
        return const Color(0xFFEF4444); // Red
      case ProductStatus.discontinued:
        return const Color(0xFF6B7280); // Gray
      case ProductStatus.preOrder:
        return const Color(0xFF3B82F6); // Blue
    }
  }
}

/// Immutable Product entity with business logic
/// 
/// Represents a product in the e-commerce system with all necessary
/// properties, business rules, and immutable update patterns.
@immutable
class Product {
  /// Creates a new Product instance
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.status,
    this.originalPrice,
    this.discount = 0.0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.stockQuantity = 0,
    this.weight,
    this.dimensions,
    this.brand,
    this.sku,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique product identifier
  final String id;

  /// Product name
  final String name;

  /// Product description
  final String description;

  /// Current price
  final double price;

  /// Product category
  final ProductCategory category;

  /// Product image URL
  final String imageUrl;

  /// Product availability status
  final ProductStatus status;

  /// Original price (before discount)
  final double? originalPrice;

  /// Discount percentage (0.0 to 1.0)
  final double discount;

  /// Average rating (0.0 to 5.0)
  final double rating;

  /// Number of reviews
  final int reviewCount;

  /// Product tags for search and filtering
  final List<String> tags;

  /// Stock quantity
  final int stockQuantity;

  /// Product weight in grams
  final double? weight;

  /// Product dimensions (width x height x depth in cm)
  final String? dimensions;

  /// Brand name
  final String? brand;

  /// Stock Keeping Unit
  final String? sku;

  /// When the product was created
  final DateTime? createdAt;

  /// When the product was last updated
  final DateTime? updatedAt;

  /// Create a product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: ProductCategory.values.firstWhere(
        (cat) => cat.name == json['category'],
        orElse: () => ProductCategory.electronics,
      ),
      imageUrl: json['imageUrl'] as String,
      status: ProductStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ProductStatus.available,
      ),
      originalPrice: json['originalPrice']?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      tags: List<String>.from(json['tags'] as List? ?? []),
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      weight: json['weight']?.toDouble(),
      dimensions: json['dimensions'] as String?,
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  /// Convert product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category.name,
      'imageUrl': imageUrl,
      'status': status.name,
      'originalPrice': originalPrice,
      'discount': discount,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'stockQuantity': stockQuantity,
      'weight': weight,
      'dimensions': dimensions,
      'brand': brand,
      'sku': sku,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with modified fields (immutable update pattern)
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    ProductCategory? category,
    String? imageUrl,
    ProductStatus? status,
    double? originalPrice,
    double? discount,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    int? stockQuantity,
    double? weight,
    String? dimensions,
    String? brand,
    String? sku,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create a factory constructor for new products
  factory Product.create({
    required String name,
    required String description,
    required double price,
    required ProductCategory category,
    required String imageUrl,
    ProductStatus status = ProductStatus.available,
    double? originalPrice,
    double discount = 0.0,
    List<String>? tags,
    int stockQuantity = 0,
    double? weight,
    String? dimensions,
    String? brand,
    String? sku,
  }) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      price: price,
      category: category,
      imageUrl: imageUrl,
      status: status,
      originalPrice: originalPrice,
      discount: discount,
      tags: tags ?? [],
      stockQuantity: stockQuantity,
      weight: weight,
      dimensions: dimensions,
      brand: brand,
      sku: sku,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Update product rating with new review
  Product updateRating(double newRating) {
    final totalRating = (rating * reviewCount) + newRating;
    final newReviewCount = reviewCount + 1;
    final newAverageRating = totalRating / newReviewCount;

    return copyWith(
      rating: newAverageRating,
      reviewCount: newReviewCount,
      updatedAt: DateTime.now(),
    );
  }

  /// Apply discount to product
  Product applyDiscount(double discountPercentage) {
    final newOriginalPrice = originalPrice ?? price;
    final discountAmount = newOriginalPrice * discountPercentage;
    final newPrice = newOriginalPrice - discountAmount;

    return copyWith(
      price: newPrice,
      originalPrice: newOriginalPrice,
      discount: discountPercentage,
      updatedAt: DateTime.now(),
    );
  }

  /// Remove discount from product
  Product removeDiscount() {
    return copyWith(
      price: originalPrice ?? price,
      originalPrice: null,
      discount: 0.0,
      updatedAt: DateTime.now(),
    );
  }

  /// Update stock quantity
  Product updateStock(int newQuantity) {
    ProductStatus newStatus = status;
    
    if (newQuantity <= 0 && status == ProductStatus.available) {
      newStatus = ProductStatus.outOfStock;
    } else if (newQuantity > 0 && status == ProductStatus.outOfStock) {
      newStatus = ProductStatus.available;
    }

    return copyWith(
      stockQuantity: newQuantity,
      status: newStatus,
      updatedAt: DateTime.now(),
    );
  }

  /// Add tags to product
  Product addTags(List<String> newTags) {
    final updatedTags = [...tags];
    for (final tag in newTags) {
      if (!updatedTags.contains(tag)) {
        updatedTags.add(tag);
      }
    }

    return copyWith(
      tags: updatedTags,
      updatedAt: DateTime.now(),
    );
  }

  /// Remove tags from product
  Product removeTags(List<String> tagsToRemove) {
    final updatedTags = tags.where((tag) => !tagsToRemove.contains(tag)).toList();

    return copyWith(
      tags: updatedTags,
      updatedAt: DateTime.now(),
    );
  }

  /// Business logic: Check if product has discount
  bool get hasDiscount => discount > 0 && originalPrice != null;

  /// Business logic: Get discount amount
  double get discountAmount => hasDiscount ? (originalPrice! - price) : 0.0;

  /// Business logic: Get discount percentage for display
  String get discountPercentageDisplay => hasDiscount ? '${(discount * 100).round()}% OFF' : '';

  /// Business logic: Check if product is in stock
  bool get isInStock => status.canAddToCart && stockQuantity > 0;

  /// Business logic: Check if product is low stock
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 5;

  /// Business logic: Check if product is highly rated
  bool get isHighlyRated => rating >= 4.0 && reviewCount >= 10;

  /// Business logic: Check if product is new (created within last 30 days)
  bool get isNew {
    if (createdAt == null) return false;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return createdAt!.isAfter(thirtyDaysAgo);
  }

  /// Business logic: Get stock status message
  String get stockStatusMessage {
    switch (status) {
      case ProductStatus.available:
        if (stockQuantity <= 0) return 'Out of Stock';
        if (isLowStock) return 'Only $stockQuantity left';
        return 'In Stock';
      case ProductStatus.outOfStock:
        return 'Out of Stock';
      case ProductStatus.discontinued:
        return 'Discontinued';
      case ProductStatus.preOrder:
        return 'Available for Pre-Order';
    }
  }

  /// Business logic: Get formatted price
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Business logic: Get formatted original price
  String get formattedOriginalPrice => originalPrice != null ? '\$${originalPrice!.toStringAsFixed(2)}' : '';

  /// Business logic: Get rating display
  String get ratingDisplay => reviewCount > 0 ? '${rating.toStringAsFixed(1)} (${reviewCount})' : 'No reviews';

  /// Search functionality: Check if product matches search query
  bool matchesSearchQuery(String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    
    return name.toLowerCase().contains(lowerQuery) ||
           description.toLowerCase().contains(lowerQuery) ||
           category.displayName.toLowerCase().contains(lowerQuery) ||
           (brand?.toLowerCase().contains(lowerQuery) ?? false) ||
           tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  /// Validation: Check if product data is valid
  ProductValidationResult validate() {
    final errors = <String>[];

    // Name validation
    if (name.trim().isEmpty) {
      errors.add('Product name is required');
    } else if (name.length > 100) {
      errors.add('Product name must be less than 100 characters');
    }

    // Description validation
    if (description.trim().isEmpty) {
      errors.add('Product description is required');
    } else if (description.length > 1000) {
      errors.add('Product description must be less than 1000 characters');
    }

    // Price validation
    if (price <= 0) {
      errors.add('Product price must be greater than 0');
    }

    if (originalPrice != null && originalPrice! <= price) {
      errors.add('Original price must be greater than current price');
    }

    // Discount validation
    if (discount < 0 || discount > 1) {
      errors.add('Discount must be between 0 and 1');
    }

    // Rating validation
    if (rating < 0 || rating > 5) {
      errors.add('Rating must be between 0 and 5');
    }

    // Stock validation
    if (stockQuantity < 0) {
      errors.add('Stock quantity cannot be negative');
    }

    // URL validation
    if (imageUrl.isEmpty) {
      errors.add('Product image URL is required');
    }

    return ProductValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.category == category &&
        other.imageUrl == imageUrl &&
        other.status == status &&
        other.originalPrice == originalPrice &&
        other.discount == discount &&
        other.rating == rating &&
        other.reviewCount == reviewCount &&
        listEquals(other.tags, tags) &&
        other.stockQuantity == stockQuantity &&
        other.weight == weight &&
        other.dimensions == dimensions &&
        other.brand == brand &&
        other.sku == sku;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      price,
      category,
      imageUrl,
      status,
      originalPrice,
      discount,
      rating,
      reviewCount,
      Object.hashAll(tags),
      stockQuantity,
      weight,
      dimensions,
      brand,
      sku,
    );
  }

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'name: $name, '
        'price: $formattedPrice, '
        'category: ${category.displayName}, '
        'status: ${status.label}, '
        'inStock: $isInStock'
        ')';
  }
}

/// Product validation result
class ProductValidationResult {
  const ProductValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Whether the product data is valid
  final bool isValid;

  /// List of validation errors
  final List<String> errors;

  /// Get formatted error message
  String get errorMessage => errors.join('\n');

  @override
  String toString() {
    return 'ProductValidationResult(isValid: $isValid, errors: ${errors.length})';
  }
}

/// Mock product data for demonstration
class MockProducts {
  /// Private constructor
  const MockProducts._();

  /// Generate sample products for testing
  static List<Product> generateSampleProducts() {
    return [
      // Electronics
      Product.create(
        name: 'Wireless Bluetooth Headphones',
        description: 'Premium noise-cancelling wireless headphones with 30-hour battery life and superior sound quality.',
        price: 199.99,
        originalPrice: 249.99,
        discount: 0.2,
        category: ProductCategory.electronics,
        imageUrl: 'https://example.com/headphones.jpg',
        stockQuantity: 25,
        rating: 4.5,
        reviewCount: 127,
        tags: ['wireless', 'bluetooth', 'noise-cancelling', 'music'],
        brand: 'AudioTech',
        sku: 'AT-WH-001',
      ),

      Product.create(
        name: 'Smart Fitness Watch',
        description: 'Advanced fitness tracker with heart rate monitoring, GPS, and week-long battery life.',
        price: 299.99,
        category: ProductCategory.electronics,
        imageUrl: 'https://example.com/smartwatch.jpg',
        stockQuantity: 15,
        rating: 4.2,
        reviewCount: 89,
        tags: ['fitness', 'smartwatch', 'gps', 'health'],
        brand: 'FitTech',
        sku: 'FT-SW-002',
      ),

      // Clothing
      Product.create(
        name: 'Premium Cotton T-Shirt',
        description: 'Soft, comfortable 100% organic cotton t-shirt available in multiple colors and sizes.',
        price: 29.99,
        category: ProductCategory.clothing,
        imageUrl: 'https://example.com/tshirt.jpg',
        stockQuantity: 50,
        rating: 4.3,
        reviewCount: 234,
        tags: ['cotton', 'casual', 'comfortable', 'organic'],
        brand: 'EcoWear',
        sku: 'EW-TS-003',
      ),

      Product.create(
        name: 'Designer Denim Jeans',
        description: 'Stylish slim-fit denim jeans with premium finishing and comfortable stretch fabric.',
        price: 89.99,
        originalPrice: 120.00,
        discount: 0.25,
        category: ProductCategory.clothing,
        imageUrl: 'https://example.com/jeans.jpg',
        stockQuantity: 3, // Low stock
        rating: 4.6,
        reviewCount: 156,
        tags: ['denim', 'jeans', 'slim-fit', 'designer'],
        brand: 'UrbanStyle',
        sku: 'US-DJ-004',
      ),

      // Books
      Product.create(
        name: 'The Complete Guide to Flutter Development',
        description: 'Comprehensive guide to building cross-platform mobile applications with Flutter and Dart.',
        price: 49.99,
        category: ProductCategory.books,
        imageUrl: 'https://example.com/flutter-book.jpg',
        stockQuantity: 100,
        rating: 4.8,
        reviewCount: 312,
        tags: ['programming', 'flutter', 'mobile', 'development'],
        brand: 'TechBooks',
        sku: 'TB-FL-005',
      ),

      // Home & Garden
      Product.create(
        name: 'Smart LED Light Bulbs (4-Pack)',
        description: 'WiFi-enabled color-changing LED bulbs compatible with Alexa and Google Home.',
        price: 39.99,
        category: ProductCategory.home,
        imageUrl: 'https://example.com/smart-bulbs.jpg',
        stockQuantity: 0, // Out of stock
        status: ProductStatus.outOfStock,
        rating: 4.1,
        reviewCount: 78,
        tags: ['smart-home', 'led', 'wifi', 'color-changing'],
        brand: 'SmartLite',
        sku: 'SL-LED-006',
      ),

      // Sports
      Product.create(
        name: 'Professional Yoga Mat',
        description: 'Non-slip, eco-friendly yoga mat with excellent cushioning and durability for all yoga practices.',
        price: 34.99,
        category: ProductCategory.sports,
        imageUrl: 'https://example.com/yoga-mat.jpg',
        stockQuantity: 30,
        rating: 4.4,
        reviewCount: 167,
        tags: ['yoga', 'fitness', 'exercise', 'eco-friendly'],
        brand: 'ZenFit',
        sku: 'ZF-YM-007',
      ),

      // Beauty
      Product.create(
        name: 'Organic Face Moisturizer',
        description: 'Hydrating daily moisturizer with natural ingredients suitable for all skin types.',
        price: 24.99,
        category: ProductCategory.beauty,
        imageUrl: 'https://example.com/moisturizer.jpg',
        stockQuantity: 45,
        rating: 4.7,
        reviewCount: 203,
        tags: ['skincare', 'organic', 'moisturizer', 'natural'],
        brand: 'PureBeauty',
        sku: 'PB-FM-008',
      ),
    ];
  }
}