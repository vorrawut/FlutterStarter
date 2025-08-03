import '../models/business_card_model.dart';
import '../../domain/entities/business_card.dart';

/// Abstract data source interface for business card operations
/// Defines the contract for data access without implementation details
abstract class BusinessCardDataSource {
  /// Get all business cards from data source
  Future<List<BusinessCardModel>> getAllBusinessCards();

  /// Get business cards by style from data source
  Future<List<BusinessCardModel>> getBusinessCardsByStyle(BusinessCardStyle style);

  /// Get a business card by ID from data source
  Future<BusinessCardModel?> getBusinessCardById(String id);

  /// Create a new business card in data source
  Future<BusinessCardModel> createBusinessCard(BusinessCardModel businessCard);

  /// Update an existing business card in data source
  Future<BusinessCardModel> updateBusinessCard(BusinessCardModel businessCard);

  /// Delete a business card from data source
  Future<void> deleteBusinessCard(String id);

  /// Search business cards in data source
  Future<List<BusinessCardModel>> searchBusinessCards(String query);

  /// Get business cards grouped by style from data source
  Future<Map<BusinessCardStyle, List<BusinessCardModel>>> getBusinessCardsGroupedByStyle();

  /// Validate business card data in data source
  Future<bool> validateBusinessCard(BusinessCardModel businessCard);

  /// Get sample business cards from data source
  Future<List<BusinessCardModel>> getSampleBusinessCards();
}

/// Local data source implementation for business cards
/// Simulates local storage/database operations for demo purposes
class LocalBusinessCardDataSource implements BusinessCardDataSource {
  // Simulated local storage
  final List<BusinessCardModel> _localStorage = [];
  bool _isInitialized = false;

  /// Initialize with sample data if empty
  Future<void> _initializeIfNeeded() async {
    if (!_isInitialized) {
      _localStorage.addAll(BusinessCardSampleData.getSampleCards());
      _isInitialized = true;
    }
  }

  @override
  Future<List<BusinessCardModel>> getAllBusinessCards() async {
    await _initializeIfNeeded();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_localStorage);
  }

  @override
  Future<List<BusinessCardModel>> getBusinessCardsByStyle(BusinessCardStyle style) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    
    return _localStorage
        .where((card) => card.style == style)
        .toList();
  }

  @override
  Future<BusinessCardModel?> getBusinessCardById(String id) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      return _localStorage.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<BusinessCardModel> createBusinessCard(BusinessCardModel businessCard) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check for duplicate ID
    if (_localStorage.any((card) => card.id == businessCard.id)) {
      throw Exception('Business card with ID ${businessCard.id} already exists');
    }
    
    // Check for duplicate email
    if (_localStorage.any((card) => card.email == businessCard.email)) {
      throw Exception('Business card with email ${businessCard.email} already exists');
    }
    
    _localStorage.add(businessCard);
    return businessCard;
  }

  @override
  Future<BusinessCardModel> updateBusinessCard(BusinessCardModel businessCard) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _localStorage.indexWhere((card) => card.id == businessCard.id);
    if (index == -1) {
      throw Exception('Business card with ID ${businessCard.id} not found');
    }
    
    // Check for duplicate email (excluding current card)
    if (_localStorage.any((card) => 
        card.email == businessCard.email && card.id != businessCard.id)) {
      throw Exception('Business card with email ${businessCard.email} already exists');
    }
    
    _localStorage[index] = businessCard;
    return businessCard;
  }

  @override
  Future<void> deleteBusinessCard(String id) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _localStorage.indexWhere((card) => card.id == id);
    if (index == -1) {
      throw Exception('Business card with ID $id not found');
    }
    
    _localStorage.removeAt(index);
  }

  @override
  Future<List<BusinessCardModel>> searchBusinessCards(String query) async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 250));
    
    final lowercaseQuery = query.toLowerCase();
    
    return _localStorage.where((card) =>
        card.name.toLowerCase().contains(lowercaseQuery) ||
        card.title.toLowerCase().contains(lowercaseQuery) ||
        card.company.toLowerCase().contains(lowercaseQuery) ||
        card.email.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  @override
  Future<Map<BusinessCardStyle, List<BusinessCardModel>>> getBusinessCardsGroupedByStyle() async {
    await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 350));
    
    final Map<BusinessCardStyle, List<BusinessCardModel>> grouped = {};
    
    for (final card in _localStorage) {
      grouped.putIfAbsent(card.style, () => []).add(card);
    }
    
    return grouped;
  }

  @override
  Future<bool> validateBusinessCard(BusinessCardModel businessCard) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Basic validation
    if (!businessCard.isValid) {
      return false;
    }
    
    // Additional validation logic
    if (businessCard.name.trim().length < 2) {
      return false;
    }
    
    if (businessCard.title.trim().isEmpty) {
      return false;
    }
    
    if (businessCard.company.trim().isEmpty) {
      return false;
    }
    
    return true;
  }

  @override
  Future<List<BusinessCardModel>> getSampleBusinessCards() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return BusinessCardSampleData.getSampleCards();
  }

  /// Additional utility methods for data source

  /// Clear all business cards (for testing)
  Future<void> clearAllBusinessCards() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _localStorage.clear();
  }

  /// Get business cards count
  Future<int> getBusinessCardsCount() async {
    await _initializeIfNeeded();
    return _localStorage.length;
  }

  /// Check if data source is empty
  Future<bool> isEmpty() async {
    await _initializeIfNeeded();
    return _localStorage.isEmpty;
  }

  /// Reset data source to initial state
  Future<void> reset() async {
    _localStorage.clear();
    _isInitialized = false;
    await _initializeIfNeeded();
  }

  /// Export all data (for backup/sync purposes)
  Future<List<Map<String, dynamic>>> exportData() async {
    await _initializeIfNeeded();
    return _localStorage.map((card) => card.toJson()).toList();
  }

  /// Import data (for backup/sync purposes)
  Future<void> importData(List<Map<String, dynamic>> data) async {
    _localStorage.clear();
    
    for (final item in data) {
      try {
        final card = BusinessCardModel.fromJson(item);
        _localStorage.add(card);
      } catch (e) {
        // Skip invalid data
        continue;
      }
    }
    
    _isInitialized = true;
  }
}

/// Remote data source implementation for business cards
/// Would handle API calls in a real application
class RemoteBusinessCardDataSource implements BusinessCardDataSource {
  // In a real app, this would use http, dio, or similar for API calls
  
  @override
  Future<List<BusinessCardModel>> getAllBusinessCards() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<List<BusinessCardModel>> getBusinessCardsByStyle(BusinessCardStyle style) async {
    await Future.delayed(const Duration(milliseconds: 800));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<BusinessCardModel?> getBusinessCardById(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<BusinessCardModel> createBusinessCard(BusinessCardModel businessCard) async {
    await Future.delayed(const Duration(seconds: 1));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<BusinessCardModel> updateBusinessCard(BusinessCardModel businessCard) async {
    await Future.delayed(const Duration(milliseconds: 800));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<void> deleteBusinessCard(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<List<BusinessCardModel>> searchBusinessCards(String query) async {
    await Future.delayed(const Duration(milliseconds: 700));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<Map<BusinessCardStyle, List<BusinessCardModel>>> getBusinessCardsGroupedByStyle() async {
    await Future.delayed(const Duration(seconds: 1));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<bool> validateBusinessCard(BusinessCardModel businessCard) async {
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('Remote data source not implemented in demo');
  }

  @override
  Future<List<BusinessCardModel>> getSampleBusinessCards() async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('Remote data source not implemented in demo');
  }
}