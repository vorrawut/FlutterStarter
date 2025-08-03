import '../entities/business_card.dart';
import '../repositories/business_card_repository.dart';

/// Use case for getting business cards with various filtering options
/// Encapsulates business logic for retrieving business card data
class GetBusinessCardsUseCase {
  final BusinessCardRepository _repository;

  const GetBusinessCardsUseCase(this._repository);

  /// Get all business cards
  Future<GetBusinessCardsResult> getAllCards() async {
    try {
      final cards = await _repository.getAllBusinessCards();
      return GetBusinessCardsResult.success(cards);
    } catch (e) {
      return GetBusinessCardsResult.failure(e.toString());
    }
  }

  /// Get business cards by specific style
  Future<GetBusinessCardsResult> getCardsByStyle(BusinessCardStyle style) async {
    try {
      final cards = await _repository.getBusinessCardsByStyle(style);
      return GetBusinessCardsResult.success(cards);
    } catch (e) {
      return GetBusinessCardsResult.failure(e.toString());
    }
  }

  /// Get a single business card by ID
  Future<GetSingleBusinessCardResult> getCardById(String id) async {
    try {
      final card = await _repository.getBusinessCardById(id);
      if (card != null) {
        return GetSingleBusinessCardResult.success(card);
      } else {
        return GetSingleBusinessCardResult.notFound();
      }
    } catch (e) {
      return GetSingleBusinessCardResult.failure(e.toString());
    }
  }

  /// Search business cards by query
  Future<GetBusinessCardsResult> searchCards(String query) async {
    try {
      if (query.trim().isEmpty) {
        return GetBusinessCardsResult.success([]);
      }
      
      final cards = await _repository.searchBusinessCards(query);
      return GetBusinessCardsResult.success(cards);
    } catch (e) {
      return GetBusinessCardsResult.failure(e.toString());
    }
  }

  /// Get business cards grouped by style for UI organization
  Future<GetGroupedBusinessCardsResult> getCardsGroupedByStyle() async {
    try {
      final groupedCards = await _repository.getBusinessCardsGroupedByStyle();
      return GetGroupedBusinessCardsResult.success(groupedCards);
    } catch (e) {
      return GetGroupedBusinessCardsResult.failure(e.toString());
    }
  }

  /// Get sample business cards for demo purposes
  Future<GetBusinessCardsResult> getSampleCards() async {
    try {
      final cards = await _repository.getSampleBusinessCards();
      return GetBusinessCardsResult.success(cards);
    } catch (e) {
      return GetBusinessCardsResult.failure(e.toString());
    }
  }

  /// Get filtered business cards based on criteria
  Future<GetBusinessCardsResult> getFilteredCards({
    BusinessCardStyle? style,
    String? company,
    String? searchQuery,
  }) async {
    try {
      List<BusinessCard> cards;
      
      if (style != null) {
        cards = await _repository.getBusinessCardsByStyle(style);
      } else {
        cards = await _repository.getAllBusinessCards();
      }

      // Apply additional filters
      if (company != null && company.isNotEmpty) {
        cards = cards.where((card) => 
          card.company.toLowerCase().contains(company.toLowerCase())
        ).toList();
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        cards = cards.where((card) => 
          card.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          card.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          card.company.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }

      return GetBusinessCardsResult.success(cards);
    } catch (e) {
      return GetBusinessCardsResult.failure(e.toString());
    }
  }

  /// Validate a business card's data
  Future<ValidationResult> validateCard(BusinessCard card) async {
    try {
      final isValid = await _repository.validateBusinessCard(card);
      if (isValid) {
        return ValidationResult.success();
      } else {
        return ValidationResult.failure('Business card data is invalid');
      }
    } catch (e) {
      return ValidationResult.failure(e.toString());
    }
  }
}

/// Result classes for use case operations
class GetBusinessCardsResult {
  final List<BusinessCard>? cards;
  final String? errorMessage;
  final bool isSuccess;

  const GetBusinessCardsResult._(
    this.cards,
    this.errorMessage,
    this.isSuccess,
  );

  factory GetBusinessCardsResult.success(List<BusinessCard> cards) {
    return GetBusinessCardsResult._(cards, null, true);
  }

  factory GetBusinessCardsResult.failure(String errorMessage) {
    return GetBusinessCardsResult._(null, errorMessage, false);
  }

  bool get isFailure => !isSuccess;
  bool get hasCards => cards?.isNotEmpty == true;
}

class GetSingleBusinessCardResult {
  final BusinessCard? card;
  final String? errorMessage;
  final bool isSuccess;
  final bool isNotFound;

  const GetSingleBusinessCardResult._(
    this.card,
    this.errorMessage,
    this.isSuccess,
    this.isNotFound,
  );

  factory GetSingleBusinessCardResult.success(BusinessCard card) {
    return GetSingleBusinessCardResult._(card, null, true, false);
  }

  factory GetSingleBusinessCardResult.failure(String errorMessage) {
    return GetSingleBusinessCardResult._(null, errorMessage, false, false);
  }

  factory GetSingleBusinessCardResult.notFound() {
    return GetSingleBusinessCardResult._(null, 'Business card not found', false, true);
  }

  bool get isFailure => !isSuccess;
}

class GetGroupedBusinessCardsResult {
  final Map<BusinessCardStyle, List<BusinessCard>>? groupedCards;
  final String? errorMessage;
  final bool isSuccess;

  const GetGroupedBusinessCardsResult._(
    this.groupedCards,
    this.errorMessage,
    this.isSuccess,
  );

  factory GetGroupedBusinessCardsResult.success(
    Map<BusinessCardStyle, List<BusinessCard>> groupedCards,
  ) {
    return GetGroupedBusinessCardsResult._(groupedCards, null, true);
  }

  factory GetGroupedBusinessCardsResult.failure(String errorMessage) {
    return GetGroupedBusinessCardsResult._(null, errorMessage, false);
  }

  bool get isFailure => !isSuccess;
  bool get hasCards => groupedCards?.isNotEmpty == true;
}

class ValidationResult {
  final String? errorMessage;
  final bool isSuccess;

  const ValidationResult._(this.errorMessage, this.isSuccess);

  factory ValidationResult.success() {
    return const ValidationResult._(null, true);
  }

  factory ValidationResult.failure(String errorMessage) {
    return ValidationResult._(errorMessage, false);
  }

  bool get isFailure => !isSuccess;
}