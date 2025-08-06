/// Product catalog state management with Provider pattern
/// 
/// This file demonstrates product browsing, searching, and filtering
/// using Provider and ChangeNotifier for catalog management.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/models/product.dart';

/// Product catalog state management using Provider and ChangeNotifier
/// 
/// Manages product data, search, filtering, and catalog operations
/// with automatic dependency injection and optimized rebuilds.
class ProductProvider with ChangeNotifier {
  /// Creates a product provider
  ProductProvider() {
    _loadProducts();
    if (kDebugMode) {
      debugPrint('📦 ProductProvider initialized');
    }
  }

  /// All available products
  List<Product> _allProducts = [];

  /// Filtered products based on current filters
  List<Product> _filteredProducts = [];

  /// Whether product operations are in progress
  bool _isLoading = false;

  /// Error message if any operation failed
  String? _errorMessage;

  /// Current search query
  String _searchQuery = '';

  /// Current category filter
  ProductCategory? _categoryFilter;

  /// Current price range filter
  PriceRange? _priceRangeFilter;

  /// Current availability filter
  ProductStatus? _statusFilter;

  /// Current rating filter (minimum rating)
  double? _minimumRating;

  /// Current sort option
  ProductSortOption _sortOption = ProductSortOption.relevance;

  /// Whether to show only products with discounts
  bool _showDiscountsOnly = false;

  /// Whether to show only new products
  bool _showNewOnly = false;

  /// Get all products (immutable)
  List<Product> get allProducts => List.unmodifiable(_allProducts);

  /// Get filtered products (immutable)
  List<Product> get filteredProducts => List.unmodifiable(_filteredProducts);

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Get current search query
  String get searchQuery => _searchQuery;

  /// Get current category filter
  ProductCategory? get categoryFilter => _categoryFilter;

  /// Get current price range filter
  PriceRange? get priceRangeFilter => _priceRangeFilter;

  /// Get current status filter
  ProductStatus? get statusFilter => _statusFilter;

  /// Get minimum rating filter
  double? get minimumRating => _minimumRating;

  /// Get current sort option
  ProductSortOption get sortOption => _sortOption;

  /// Get show discounts only flag
  bool get showDiscountsOnly => _showDiscountsOnly;

  /// Get show new only flag
  bool get showNewOnly => _showNewOnly;

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

  /// Clear error state
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Load products from data source
  Future<void> _loadProducts() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Load sample products
      _allProducts = MockProducts.generateSampleProducts();
      _applyFilters();
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('📦 Loaded ${_allProducts.length} products');
      }

    } catch (error) {
      _setError('Failed to load products: $error');
      if (kDebugMode) {
        debugPrint('❌ Error loading products: $error');
      }
    }
  }

  /// Refresh products from data source
  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  /// Search products by query
  void searchProducts(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _applyFilters();
      
      if (kDebugMode) {
        debugPrint('📦 Searching products: "$query" (${_filteredProducts.length} results)');
      }
    }
  }

  /// Clear search query
  void clearSearch() {
    searchProducts('');
  }

  /// Filter by category
  void filterByCategory(ProductCategory? category) {
    if (_categoryFilter != category) {
      _categoryFilter = category;
      _applyFilters();
      
      if (kDebugMode) {
        debugPrint('📦 Filtered by category: ${category?.displayName ?? 'All'} (${_filteredProducts.length} results)');
      }
    }
  }

  /// Filter by price range
  void filterByPriceRange(PriceRange? priceRange) {
    if (_priceRangeFilter != priceRange) {
      _priceRangeFilter = priceRange;
      _applyFilters();
      
      if (kDebugMode) {
        debugPrint('📦 Filtered by price range: ${priceRange?.label ?? 'All'} (${_filteredProducts.length} results)');
      }
    }
  }

  /// Filter by product status
  void filterByStatus(ProductStatus? status) {
    if (_statusFilter != status) {
      _statusFilter = status;
      _applyFilters();
      
      if (kDebugMode) {
        debugPrint('📦 Filtered by status: ${status?.label ?? 'All'} (${_filteredProducts.length} results)');
      }
    }
  }

  /// Filter by minimum rating
  void filterByRating(double? rating) {
    if (_minimumRating != rating) {
      _minimumRating = rating;
      _applyFilters();
      
      if (kDebugMode) {
        debugPrint('📦 Filtered by rating: ${rating?.toString() ?? 'All'} (${_filteredProducts.length} results)');
      }
    }
  }

  /// Toggle show discounts only
  void toggleShowDiscountsOnly() {
    _showDiscountsOnly = !_showDiscountsOnly;
    _applyFilters();
    
    if (kDebugMode) {
      debugPrint('📦 Show discounts only: $_showDiscountsOnly (${_filteredProducts.length} results)');
    }
  }

  /// Toggle show new products only
  void toggleShowNewOnly() {
    _showNewOnly = !_showNewOnly;
    _applyFilters();
    
    if (kDebugMode) {
      debugPrint('📦 Show new only: $_showNewOnly (${_filteredProducts.length} results)');
    }
  }

  /// Set sort option
  void setSortOption(ProductSortOption sortOption) {
    if (_sortOption != sortOption) {
      _sortOption = sortOption;
      _applyFilters();
      
      if (kDebugMode) {
        debugPrint('📦 Sorted by: ${sortOption.label} (${_filteredProducts.length} results)');
      }
    }
  }

  /// Clear all filters
  void clearAllFilters() {
    bool hasChanges = false;
    
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      hasChanges = true;
    }
    
    if (_categoryFilter != null) {
      _categoryFilter = null;
      hasChanges = true;
    }
    
    if (_priceRangeFilter != null) {
      _priceRangeFilter = null;
      hasChanges = true;
    }
    
    if (_statusFilter != null) {
      _statusFilter = null;
      hasChanges = true;
    }
    
    if (_minimumRating != null) {
      _minimumRating = null;
      hasChanges = true;
    }
    
    if (_showDiscountsOnly) {
      _showDiscountsOnly = false;
      hasChanges = true;
    }
    
    if (_showNewOnly) {
      _showNewOnly = false;
      hasChanges = true;
    }
    
    if (_sortOption != ProductSortOption.relevance) {
      _sortOption = ProductSortOption.relevance;
      hasChanges = true;
    }
    
    if (hasChanges) {
      _applyFilters();
      
      if (kDebugMode) {
        debugPrint('📦 All filters cleared (${_filteredProducts.length} results)');
      }
    }
  }

  /// Apply current filters to products
  void _applyFilters() {
    List<Product> filtered = List.from(_allProducts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) => product.matchesSearchQuery(_searchQuery)).toList();
    }

    // Apply category filter
    if (_categoryFilter != null) {
      filtered = filtered.where((product) => product.category == _categoryFilter).toList();
    }

    // Apply price range filter
    if (_priceRangeFilter != null) {
      filtered = filtered.where((product) => _priceRangeFilter!.contains(product.price)).toList();
    }

    // Apply status filter
    if (_statusFilter != null) {
      filtered = filtered.where((product) => product.status == _statusFilter).toList();
    }

    // Apply rating filter
    if (_minimumRating != null) {
      filtered = filtered.where((product) => product.rating >= _minimumRating!).toList();
    }

    // Apply discounts filter
    if (_showDiscountsOnly) {
      filtered = filtered.where((product) => product.hasDiscount).toList();
    }

    // Apply new products filter
    if (_showNewOnly) {
      filtered = filtered.where((product) => product.isNew).toList();
    }

    // Apply sorting
    _sortProducts(filtered);

    _filteredProducts = filtered;
    notifyListeners();
  }

  /// Sort products based on current sort option
  void _sortProducts(List<Product> products) {
    switch (_sortOption) {
      case ProductSortOption.relevance:
        // Keep original order for relevance
        break;
      case ProductSortOption.priceAscending:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceDescending:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.nameAscending:
        products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case ProductSortOption.nameDescending:
        products.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case ProductSortOption.ratingDescending:
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.newest:
        products.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
        break;
      case ProductSortOption.popularity:
        products.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get products by category
  List<Product> getProductsByCategory(ProductCategory category) {
    return _allProducts.where((product) => product.category == category).toList();
  }

  /// Get featured products (highly rated with many reviews)
  List<Product> getFeaturedProducts({int limit = 10}) {
    final featured = _allProducts
        .where((product) => product.isHighlyRated)
        .toList()
      ..sort((a, b) => (b.rating * b.reviewCount).compareTo(a.rating * a.reviewCount));
    
    return featured.take(limit).toList();
  }

  /// Get new products
  List<Product> getNewProducts({int limit = 10}) {
    final newProducts = _allProducts
        .where((product) => product.isNew)
        .toList()
      ..sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
    
    return newProducts.take(limit).toList();
  }

  /// Get discounted products
  List<Product> getDiscountedProducts({int limit = 10}) {
    final discounted = _allProducts
        .where((product) => product.hasDiscount)
        .toList()
      ..sort((a, b) => b.discount.compareTo(a.discount));
    
    return discounted.take(limit).toList();
  }

  /// Get related products (same category, excluding given product)
  List<Product> getRelatedProducts(Product product, {int limit = 6}) {
    final related = _allProducts
        .where((p) => p.id != product.id && p.category == product.category)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    
    return related.take(limit).toList();
  }

  /// Get recommended products based on user preferences
  List<Product> getRecommendedProducts(List<ProductCategory> favoriteCategories, {int limit = 10}) {
    final recommended = _allProducts
        .where((product) => favoriteCategories.contains(product.category))
        .toList()
      ..sort((a, b) => (b.rating * b.reviewCount).compareTo(a.rating * a.reviewCount));
    
    return recommended.take(limit).toList();
  }

  /// Business logic: Check if any filters are active
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
           _categoryFilter != null ||
           _priceRangeFilter != null ||
           _statusFilter != null ||
           _minimumRating != null ||
           _showDiscountsOnly ||
           _showNewOnly;
  }

  /// Business logic: Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (_searchQuery.isNotEmpty) count++;
    if (_categoryFilter != null) count++;
    if (_priceRangeFilter != null) count++;
    if (_statusFilter != null) count++;
    if (_minimumRating != null) count++;
    if (_showDiscountsOnly) count++;
    if (_showNewOnly) count++;
    return count;
  }

  /// Business logic: Get filter summary
  Map<String, String> get filterSummary {
    final summary = <String, String>{};
    
    if (_searchQuery.isNotEmpty) {
      summary['Search'] = '"$_searchQuery"';
    }
    
    if (_categoryFilter != null) {
      summary['Category'] = _categoryFilter!.displayName;
    }
    
    if (_priceRangeFilter != null) {
      summary['Price'] = _priceRangeFilter!.label;
    }
    
    if (_statusFilter != null) {
      summary['Status'] = _statusFilter!.label;
    }
    
    if (_minimumRating != null) {
      summary['Rating'] = '${_minimumRating!}+ stars';
    }
    
    if (_showDiscountsOnly) {
      summary['Special'] = 'Discounts Only';
    }
    
    if (_showNewOnly) {
      summary['Special'] = 'New Products Only';
    }
    
    return summary;
  }

  /// Business logic: Get category statistics
  Map<ProductCategory, int> get categoryStatistics {
    final stats = <ProductCategory, int>{};
    
    for (final category in ProductCategory.values) {
      stats[category] = _allProducts.where((p) => p.category == category).length;
    }
    
    return stats;
  }

  /// Business logic: Get price range statistics
  Map<PriceRange, int> get priceRangeStatistics {
    final stats = <PriceRange, int>{};
    
    for (final range in PriceRange.values) {
      stats[range] = _allProducts.where((p) => range.contains(p.price)).length;
    }
    
    return stats;
  }

  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('📦 ProductProvider disposed');
    }
    super.dispose();
  }

  @override
  String toString() {
    return 'ProductProvider('
        'allProducts: ${_allProducts.length}, '
        'filteredProducts: ${_filteredProducts.length}, '
        'activeFilters: $activeFilterCount, '
        'isLoading: $_isLoading'
        ')';
  }
}

/// Product sorting options
enum ProductSortOption {
  relevance('Relevance'),
  priceAscending('Price: Low to High'),
  priceDescending('Price: High to Low'),
  nameAscending('Name: A to Z'),
  nameDescending('Name: Z to A'),
  ratingDescending('Highest Rated'),
  newest('Newest First'),
  popularity('Most Popular');

  const ProductSortOption(this.label);

  /// Display label for the sort option
  final String label;
}

/// Price range filters
enum PriceRange {
  under25('Under \$25', 0, 25),
  range25to50('\$25 - \$50', 25, 50),
  range50to100('\$50 - \$100', 50, 100),
  range100to200('\$100 - \$200', 100, 200),
  over200('Over \$200', 200, double.infinity);

  const PriceRange(this.label, this.min, this.max);

  /// Display label for the price range
  final String label;

  /// Minimum price
  final double min;

  /// Maximum price
  final double max;

  /// Check if price is within this range
  bool contains(double price) {
    return price >= min && price < max;
  }
}