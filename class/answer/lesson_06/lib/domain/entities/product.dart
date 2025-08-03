import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';

/// Product entity representing a product in the e-commerce system
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final double price;
  final double? originalPrice;
  final String currency;
  final List<String> imageUrls;
  final ProductCategory category;
  final String brand;
  final String sku;
  final int stockQuantity;
  final bool isInStock;
  final bool isActive;
  final bool isFeatured;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final Map<String, dynamic> attributes; // e.g., size, color, material
  final ProductDimensions? dimensions;
  final double? weight;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.price,
    this.originalPrice,
    this.currency = 'USD',
    required this.imageUrls,
    required this.category,
    required this.brand,
    required this.sku,
    this.stockQuantity = 0,
    this.isInStock = true,
    this.isActive = true,
    this.isFeatured = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.attributes = const {},
    this.dimensions,
    this.weight,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with updated properties
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? shortDescription,
    double? price,
    double? originalPrice,
    String? currency,
    List<String>? imageUrls,
    ProductCategory? category,
    String? brand,
    String? sku,
    int? stockQuantity,
    bool? isInStock,
    bool? isActive,
    bool? isFeatured,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    Map<String, dynamic>? attributes,
    ProductDimensions? dimensions,
    double? weight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      currency: currency ?? this.currency,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isInStock: isInStock ?? this.isInStock,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      attributes: attributes ?? this.attributes,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get primary image URL
  String get primaryImageUrl {
    return imageUrls.isNotEmpty ? imageUrls.first : '';
  }

  /// Check if product has images
  bool get hasImages => imageUrls.isNotEmpty;

  /// Check if product is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;

  /// Get discount percentage
  double get discountPercentage {
    if (!isOnSale) return 0.0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  /// Get formatted price
  String get formattedPrice {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Get formatted original price
  String get formattedOriginalPrice {
    if (originalPrice == null) return '';
    return '\$${originalPrice!.toStringAsFixed(2)}';
  }

  /// Get formatted discount
  String get formattedDiscount {
    if (!isOnSale) return '';
    return '${discountPercentage.toStringAsFixed(0)}% OFF';
  }

  /// Get stock status
  ProductStockStatus get stockStatus {
    if (!isInStock || stockQuantity <= 0) {
      return ProductStockStatus.outOfStock;
    } else if (stockQuantity <= 5) {
      return ProductStockStatus.lowStock;
    } else {
      return ProductStockStatus.inStock;
    }
  }

  /// Get stock status display text
  String get stockStatusText {
    switch (stockStatus) {
      case ProductStockStatus.inStock:
        return 'In Stock';
      case ProductStockStatus.lowStock:
        return 'Only $stockQuantity left';
      case ProductStockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  /// Get rating display text
  String get ratingText {
    if (reviewCount == 0) return 'No reviews';
    return '${rating.toStringAsFixed(1)} (${reviewCount} reviews)';
  }

  /// Check if product can be ordered
  bool get canOrder => isActive && isInStock && stockQuantity > 0;

  /// Get product attribute value
  T? getAttribute<T>(String key) {
    final value = attributes[key];
    if (value is T) return value;
    return null;
  }

  /// Check if product has attribute
  bool hasAttribute(String key) {
    return attributes.containsKey(key);
  }

  /// Get available sizes (if product has size attribute)
  List<String> get availableSizes {
    final sizes = getAttribute<List<dynamic>>('sizes');
    return sizes?.cast<String>() ?? [];
  }

  /// Get available colors (if product has color attribute)
  List<String> get availableColors {
    final colors = getAttribute<List<dynamic>>('colors');
    return colors?.cast<String>() ?? [];
  }

  /// Search relevance score (for search functionality)
  double calculateRelevanceScore(String query) {
    final lowerQuery = query.toLowerCase();
    double score = 0.0;

    // Name match (highest weight)
    if (name.toLowerCase().contains(lowerQuery)) {
      score += 10.0;
    }

    // Brand match
    if (brand.toLowerCase().contains(lowerQuery)) {
      score += 5.0;
    }

    // Category match
    if (category.displayName.toLowerCase().contains(lowerQuery)) {
      score += 3.0;
    }

    // Description match
    if (description.toLowerCase().contains(lowerQuery) ||
        shortDescription.toLowerCase().contains(lowerQuery)) {
      score += 2.0;
    }

    // Tag match
    for (final tag in tags) {
      if (tag.toLowerCase().contains(lowerQuery)) {
        score += 1.0;
      }
    }

    // Boost score for featured products
    if (isFeatured) {
      score *= 1.2;
    }

    // Boost score for highly rated products
    if (rating > 4.0) {
      score *= 1.1;
    }

    return score;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        shortDescription,
        price,
        originalPrice,
        currency,
        imageUrls,
        category,
        brand,
        sku,
        stockQuantity,
        isInStock,
        isActive,
        isFeatured,
        rating,
        reviewCount,
        tags,
        attributes,
        dimensions,
        weight,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $formattedPrice, category: ${category.displayName})';
  }
}

/// Product stock status enumeration
enum ProductStockStatus {
  inStock('In Stock'),
  lowStock('Low Stock'),
  outOfStock('Out of Stock');

  const ProductStockStatus(this.displayName);
  final String displayName;
}

/// Product dimensions
class ProductDimensions extends Equatable {
  final double length;
  final double width;
  final double height;
  final String unit; // e.g., "cm", "in"

  const ProductDimensions({
    required this.length,
    required this.width,
    required this.height,
    this.unit = 'cm',
  });

  /// Get formatted dimensions string
  String get formatted {
    return '${length} x ${width} x ${height} $unit';
  }

  /// Calculate volume
  double get volume {
    return length * width * height;
  }

  @override
  List<Object?> get props => [length, width, height, unit];

  @override
  String toString() {
    return 'ProductDimensions($formatted)';
  }
}

/// Product review entity
class ProductReview extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String title;
  final String comment;
  final List<String> images;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.title,
    required this.comment,
    this.images = const [],
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  /// Get formatted rating text
  String get ratingText {
    return '${rating.toStringAsFixed(1)} stars';
  }

  /// Get time ago text
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years} year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months} month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        userId,
        userName,
        userAvatarUrl,
        rating,
        title,
        comment,
        images,
        isVerifiedPurchase,
        helpfulCount,
        createdAt,
        updatedAt,
      ];
}

/// Factory class for creating product entities
class ProductFactory {
  /// Create a new product
  static Product create({
    required String id,
    required String name,
    required String description,
    required double price,
    required ProductCategory category,
    required String brand,
    List<String> imageUrls = const [],
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      shortDescription: description.length > 100 
          ? '${description.substring(0, 100)}...' 
          : description,
      price: price,
      imageUrls: imageUrls,
      category: category,
      brand: brand,
      sku: 'SKU-${id.toUpperCase()}',
      stockQuantity: 10,
      isInStock: true,
      createdAt: DateTime.now(),
    );
  }

  /// Create sample products for testing/demo
  static List<Product> createSampleProducts() {
    return [
      Product(
        id: 'prod_001',
        name: 'Wireless Bluetooth Headphones',
        description: 'Premium wireless headphones with active noise cancellation and 30-hour battery life. Perfect for music lovers and professionals.',
        shortDescription: 'Premium wireless headphones with noise cancellation',
        price: 199.99,
        originalPrice: 249.99,
        imageUrls: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
          'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
        ],
        category: ProductCategory.electronics,
        brand: 'AudioTech',
        sku: 'AT-WBH-001',
        stockQuantity: 15,
        isInStock: true,
        isFeatured: true,
        rating: 4.5,
        reviewCount: 128,
        tags: ['wireless', 'bluetooth', 'noise-cancellation', 'premium'],
        attributes: {
          'colors': ['Black', 'White', 'Blue'],
          'battery_life': '30 hours',
          'wireless': true,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Product(
        id: 'prod_002',
        name: 'Organic Cotton T-Shirt',
        description: 'Comfortable organic cotton t-shirt made from sustainable materials. Soft, breathable, and perfect for everyday wear.',
        shortDescription: 'Comfortable organic cotton t-shirt',
        price: 29.99,
        imageUrls: [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
        ],
        category: ProductCategory.clothing,
        brand: 'EcoWear',
        sku: 'EW-OCT-002',
        stockQuantity: 50,
        isInStock: true,
        rating: 4.2,
        reviewCount: 45,
        tags: ['organic', 'cotton', 'sustainable', 'casual'],
        attributes: {
          'sizes': ['XS', 'S', 'M', 'L', 'XL'],
          'colors': ['White', 'Black', 'Navy', 'Gray'],
          'material': 'Organic Cotton',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Product(
        id: 'prod_003',
        name: 'Smart Home Security Camera',
        description: 'WiFi-enabled security camera with 1080p HD video, night vision, and mobile app control. Monitor your home from anywhere.',
        shortDescription: 'WiFi security camera with 1080p HD video',
        price: 89.99,
        originalPrice: 119.99,
        imageUrls: [
          'https://images.unsplash.com/photo-1558002038-1055907df827?w=400',
        ],
        category: ProductCategory.electronics,
        brand: 'SecureHome',
        sku: 'SH-SC-003',
        stockQuantity: 8,
        isInStock: true,
        rating: 4.7,
        reviewCount: 92,
        tags: ['smart-home', 'security', 'wifi', 'hd-video'],
        attributes: {
          'resolution': '1080p',
          'night_vision': true,
          'wifi_enabled': true,
          'mobile_app': true,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Product(
        id: 'prod_004',
        name: 'Bestselling Novel - "The Digital Age"',
        description: 'A gripping tale about technology and human connection in the modern world. Winner of the Literary Excellence Award.',
        shortDescription: 'Award-winning novel about technology and humanity',
        price: 14.99,
        imageUrls: [
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400',
        ],
        category: ProductCategory.books,
        brand: 'Modern Press',
        sku: 'MP-TDA-004',
        stockQuantity: 25,
        isInStock: true,
        isFeatured: true,
        rating: 4.8,
        reviewCount: 156,
        tags: ['fiction', 'bestseller', 'award-winner', 'modern'],
        attributes: {
          'pages': 342,
          'language': 'English',
          'format': 'Paperback',
          'isbn': '978-1234567890',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Product(
        id: 'prod_005',
        name: 'Stainless Steel Water Bottle',
        description: 'Insulated stainless steel water bottle that keeps drinks cold for 24 hours or hot for 12 hours. BPA-free and eco-friendly.',
        shortDescription: 'Insulated stainless steel water bottle',
        price: 24.99,
        imageUrls: [
          'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400',
        ],
        category: ProductCategory.sports,
        brand: 'HydroLife',
        sku: 'HL-SWB-005',
        stockQuantity: 3,
        isInStock: true,
        rating: 4.3,
        reviewCount: 67,
        tags: ['eco-friendly', 'insulated', 'bpa-free', 'durable'],
        attributes: {
          'capacity': '500ml',
          'material': 'Stainless Steel',
          'insulated': true,
          'colors': ['Silver', 'Black', 'Blue', 'Pink'],
        },
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }

  /// Create out of stock product
  static Product createOutOfStockProduct() {
    return Product(
      id: 'prod_oos',
      name: 'Out of Stock Item',
      description: 'This item is currently out of stock',
      shortDescription: 'Currently unavailable',
      price: 99.99,
      imageUrls: const [],
      category: ProductCategory.electronics,
      brand: 'Test Brand',
      sku: 'TEST-OOS',
      stockQuantity: 0,
      isInStock: false,
      createdAt: DateTime.now(),
    );
  }
}