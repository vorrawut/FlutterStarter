import '../../domain/entities/business_card.dart';
import '../../domain/repositories/business_card_repository.dart';
import '../datasources/business_card_datasource.dart';
import '../models/business_card_model.dart';

/// Implementation of BusinessCardRepository
/// Handles data operations and coordinates between domain and data layers
class BusinessCardRepositoryImpl implements BusinessCardRepository {
  final BusinessCardDataSource _dataSource;

  const BusinessCardRepositoryImpl(this._dataSource);

  @override
  Future<List<BusinessCard>> getAllBusinessCards() async {
    try {
      final models = await _dataSource.getAllBusinessCards();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get business cards: $e');
    }
  }

  @override
  Future<List<BusinessCard>> getBusinessCardsByStyle(BusinessCardStyle style) async {
    try {
      final models = await _dataSource.getBusinessCardsByStyle(style);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get business cards by style: $e');
    }
  }

  @override
  Future<BusinessCard?> getBusinessCardById(String id) async {
    try {
      final model = await _dataSource.getBusinessCardById(id);
      return model?.toEntity();
    } catch (e) {
      throw Exception('Failed to get business card by ID: $e');
    }
  }

  @override
  Future<BusinessCard> createBusinessCard(BusinessCard businessCard) async {
    try {
      // Validate before creating
      if (!businessCard.isValid) {
        throw Exception('Invalid business card data');
      }

      final model = BusinessCardModel.fromEntity(businessCard);
      final createdModel = await _dataSource.createBusinessCard(model);
      return createdModel.toEntity();
    } catch (e) {
      throw Exception('Failed to create business card: $e');
    }
  }

  @override
  Future<BusinessCard> updateBusinessCard(BusinessCard businessCard) async {
    try {
      // Validate before updating
      if (!businessCard.isValid) {
        throw Exception('Invalid business card data');
      }

      final model = BusinessCardModel.fromEntity(businessCard);
      final updatedModel = await _dataSource.updateBusinessCard(model);
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update business card: $e');
    }
  }

  @override
  Future<void> deleteBusinessCard(String id) async {
    try {
      await _dataSource.deleteBusinessCard(id);
    } catch (e) {
      throw Exception('Failed to delete business card: $e');
    }
  }

  @override
  Future<List<BusinessCard>> searchBusinessCards(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final models = await _dataSource.searchBusinessCards(query);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search business cards: $e');
    }
  }

  @override
  Future<Map<BusinessCardStyle, List<BusinessCard>>> getBusinessCardsGroupedByStyle() async {
    try {
      final groupedModels = await _dataSource.getBusinessCardsGroupedByStyle();
      final Map<BusinessCardStyle, List<BusinessCard>> result = {};

      groupedModels.forEach((style, models) {
        result[style] = models.map((model) => model.toEntity()).toList();
      });

      return result;
    } catch (e) {
      throw Exception('Failed to get grouped business cards: $e');
    }
  }

  @override
  Future<bool> validateBusinessCard(BusinessCard businessCard) async {
    try {
      // Basic validation
      if (!businessCard.isValid) {
        return false;
      }

      // Additional validation logic can be added here
      // For example, checking for duplicate emails, validating company exists, etc.
      
      return await _dataSource.validateBusinessCard(
        BusinessCardModel.fromEntity(businessCard),
      );
    } catch (e) {
      throw Exception('Failed to validate business card: $e');
    }
  }

  @override
  Future<List<BusinessCard>> getSampleBusinessCards() async {
    try {
      final models = await _dataSource.getSampleBusinessCards();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get sample business cards: $e');
    }
  }

  /// Additional utility methods for repository implementation

  /// Get business cards by company
  Future<List<BusinessCard>> getBusinessCardsByCompany(String company) async {
    try {
      final allCards = await getAllBusinessCards();
      return allCards.where((card) => 
        card.company.toLowerCase().contains(company.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Failed to get business cards by company: $e');
    }
  }

  /// Get business cards count by style
  Future<Map<BusinessCardStyle, int>> getBusinessCardCountByStyle() async {
    try {
      final groupedCards = await getBusinessCardsGroupedByStyle();
      final Map<BusinessCardStyle, int> counts = {};

      groupedCards.forEach((style, cards) {
        counts[style] = cards.length;
      });

      return counts;
    } catch (e) {
      throw Exception('Failed to get business card counts: $e');
    }
  }

  /// Check if business card with email already exists
  Future<bool> isEmailAlreadyUsed(String email, {String? excludeId}) async {
    try {
      final allCards = await getAllBusinessCards();
      return allCards.any((card) => 
        card.email.toLowerCase() == email.toLowerCase() && 
        (excludeId == null || card.id != excludeId)
      );
    } catch (e) {
      throw Exception('Failed to check email usage: $e');
    }
  }

  /// Get business cards by title/role
  Future<List<BusinessCard>> getBusinessCardsByTitle(String title) async {
    try {
      final allCards = await getAllBusinessCards();
      return allCards.where((card) => 
        card.title.toLowerCase().contains(title.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Failed to get business cards by title: $e');
    }
  }

  /// Get business cards sorted by name
  Future<List<BusinessCard>> getBusinessCardsSortedByName({bool ascending = true}) async {
    try {
      final allCards = await getAllBusinessCards();
      allCards.sort((a, b) => ascending 
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name)
      );
      return allCards;
    } catch (e) {
      throw Exception('Failed to get sorted business cards: $e');
    }
  }

  /// Get business cards sorted by company
  Future<List<BusinessCard>> getBusinessCardsSortedByCompany({bool ascending = true}) async {
    try {
      final allCards = await getAllBusinessCards();
      allCards.sort((a, b) => ascending 
        ? a.company.compareTo(b.company)
        : b.company.compareTo(a.company)
      );
      return allCards;
    } catch (e) {
      throw Exception('Failed to get sorted business cards by company: $e');
    }
  }
}