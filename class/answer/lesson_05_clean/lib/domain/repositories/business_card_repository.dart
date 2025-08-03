import '../entities/business_card.dart';

/// Repository interface for business card operations
/// Following clean architecture principles, this defines the contract
/// without implementing the actual data operations
abstract class BusinessCardRepository {
  /// Get all business cards
  Future<List<BusinessCard>> getAllBusinessCards();

  /// Get business cards by style
  Future<List<BusinessCard>> getBusinessCardsByStyle(BusinessCardStyle style);

  /// Get a business card by ID
  Future<BusinessCard?> getBusinessCardById(String id);

  /// Create a new business card
  Future<BusinessCard> createBusinessCard(BusinessCard businessCard);

  /// Update an existing business card
  Future<BusinessCard> updateBusinessCard(BusinessCard businessCard);

  /// Delete a business card by ID
  Future<void> deleteBusinessCard(String id);

  /// Search business cards by name or company
  Future<List<BusinessCard>> searchBusinessCards(String query);

  /// Get business cards grouped by style
  Future<Map<BusinessCardStyle, List<BusinessCard>>> getBusinessCardsGroupedByStyle();

  /// Validate business card data
  Future<bool> validateBusinessCard(BusinessCard businessCard);

  /// Get sample business cards for demo/testing
  Future<List<BusinessCard>> getSampleBusinessCards();
}