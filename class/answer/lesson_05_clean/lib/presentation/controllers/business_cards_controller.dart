import 'package:flutter/material.dart';
import '../../domain/entities/business_card.dart';
import '../../domain/usecases/get_business_cards_usecase.dart';

/// Controller for managing business cards state and operations
/// Follows MVVM pattern, separating business logic from UI
class BusinessCardsController extends ChangeNotifier {
  final GetBusinessCardsUseCase _getBusinessCardsUseCase;

  BusinessCardsController(this._getBusinessCardsUseCase) {
    loadBusinessCards();
  }

  // State properties
  List<BusinessCard> _businessCards = [];
  Map<BusinessCardStyle, List<BusinessCard>> _groupedCards = {};
  BusinessCardStyle? _selectedStyle;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BusinessCard> get businessCards => _businessCards;
  Map<BusinessCardStyle, List<BusinessCard>> get groupedCards => _groupedCards;
  BusinessCardStyle? get selectedStyle => _selectedStyle;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasCards => _businessCards.isNotEmpty;

  /// Get filtered cards based on current state
  List<BusinessCard> get filteredCards {
    List<BusinessCard> cards = _businessCards;

    // Filter by style if selected
    if (_selectedStyle != null) {
      cards = cards.where((card) => card.style == _selectedStyle).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      cards = cards.where((card) =>
          card.name.toLowerCase().contains(query) ||
          card.title.toLowerCase().contains(query) ||
          card.company.toLowerCase().contains(query)
      ).toList();
    }

    return cards;
  }

  /// Get cards count by style
  Map<BusinessCardStyle, int> get cardCountByStyle {
    final Map<BusinessCardStyle, int> counts = {};
    for (final style in BusinessCardStyle.values) {
      counts[style] = _businessCards
          .where((card) => card.style == style)
          .length;
    }
    return counts;
  }

  /// Load all business cards
  Future<void> loadBusinessCards() async {
    await _executeOperation(() async {
      final result = await _getBusinessCardsUseCase.getAllCards();
      
      if (result.isSuccess) {
        _businessCards = result.cards!;
        await _updateGroupedCards();
      } else {
        _errorMessage = result.errorMessage;
      }
    });
  }

  /// Load sample business cards
  Future<void> loadSampleCards() async {
    await _executeOperation(() async {
      final result = await _getBusinessCardsUseCase.getSampleCards();
      
      if (result.isSuccess) {
        _businessCards = result.cards!;
        await _updateGroupedCards();
      } else {
        _errorMessage = result.errorMessage;
      }
    });
  }

  /// Filter cards by style
  Future<void> filterByStyle(BusinessCardStyle? style) async {
    if (_selectedStyle != style) {
      _selectedStyle = style;
      notifyListeners();
    }
  }

  /// Update search query and filter cards
  Future<void> updateSearchQuery(String query) async {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Search business cards
  Future<void> searchCards(String query) async {
    await _executeOperation(() async {
      final result = await _getBusinessCardsUseCase.searchCards(query);
      
      if (result.isSuccess) {
        _businessCards = result.cards!;
        _searchQuery = query;
        await _updateGroupedCards();
      } else {
        _errorMessage = result.errorMessage;
      }
    });
  }

  /// Get cards by specific style
  Future<void> loadCardsByStyle(BusinessCardStyle style) async {
    await _executeOperation(() async {
      final result = await _getBusinessCardsUseCase.getCardsByStyle(style);
      
      if (result.isSuccess) {
        _businessCards = result.cards!;
        _selectedStyle = style;
        await _updateGroupedCards();
      } else {
        _errorMessage = result.errorMessage;
      }
    });
  }

  /// Get a specific business card by ID
  Future<BusinessCard?> getCardById(String id) async {
    try {
      final result = await _getBusinessCardsUseCase.getCardById(id);
      
      if (result.isSuccess) {
        return result.card;
      } else {
        _errorMessage = result.errorMessage;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Failed to get business card: $e';
      notifyListeners();
      return null;
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadBusinessCards();
  }

  /// Clear current filters
  void clearFilters() {
    _selectedStyle = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Sort cards by name
  void sortByName({bool ascending = true}) {
    _businessCards.sort((a, b) => ascending 
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name)
    );
    _updateGroupedCardsSync();
    notifyListeners();
  }

  /// Sort cards by company
  void sortByCompany({bool ascending = true}) {
    _businessCards.sort((a, b) => ascending 
        ? a.company.compareTo(b.company)
        : b.company.compareTo(a.company)
    );
    _updateGroupedCardsSync();
    notifyListeners();
  }

  /// Get total cards count
  int get totalCardsCount => _businessCards.length;

  /// Get filtered cards count
  int get filteredCardsCount => filteredCards.length;

  /// Check if there are any filters applied
  bool get hasFiltersApplied => _selectedStyle != null || _searchQuery.isNotEmpty;

  /// Get style distribution stats
  Map<String, dynamic> get styleStats {
    final counts = cardCountByStyle;
    final total = totalCardsCount;
    
    return {
      'total': total,
      'byStyle': counts,
      'percentages': counts.map((style, count) => 
          MapEntry(style.displayName, total > 0 ? (count / total * 100).round() : 0)
      ),
    };
  }

  // Private methods

  /// Execute an operation with loading and error handling
  Future<void> _executeOperation(Future<void> Function() operation) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await operation();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update grouped cards from current business cards
  Future<void> _updateGroupedCards() async {
    final Map<BusinessCardStyle, List<BusinessCard>> grouped = {};
    
    for (final card in _businessCards) {
      grouped.putIfAbsent(card.style, () => []).add(card);
    }
    
    _groupedCards = grouped;
  }

  /// Synchronous version of _updateGroupedCards for sorting operations
  void _updateGroupedCardsSync() {
    final Map<BusinessCardStyle, List<BusinessCard>> grouped = {};
    
    for (final card in _businessCards) {
      grouped.putIfAbsent(card.style, () => []).add(card);
    }
    
    _groupedCards = grouped;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Extension to add display names to BusinessCardStyle enum
extension BusinessCardStyleExtension on BusinessCardStyle {
  String get displayName {
    switch (this) {
      case BusinessCardStyle.modern:
        return 'Modern';
      case BusinessCardStyle.elegant:
        return 'Elegant';
      case BusinessCardStyle.creative:
        return 'Creative';
      case BusinessCardStyle.minimal:
        return 'Minimal';
    }
  }

  String get description {
    switch (this) {
      case BusinessCardStyle.modern:
        return 'Contemporary design with gradients and modern styling';
      case BusinessCardStyle.elegant:
        return 'Clean, professional design with sophisticated layout';
      case BusinessCardStyle.creative:
        return 'Artistic design with bold colors and creative elements';
      case BusinessCardStyle.minimal:
        return 'Simple, typography-focused design with clean lines';
    }
  }
}