import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final List<String> favorites;
  final List<String> recentSearches;
  final bool isLoading;
  final String? errorMessage;

  const FavoritesState({
    this.favorites = const [],
    this.recentSearches = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FavoritesState copyWith({
    List<String>? favorites,
    List<String>? recentSearches,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasFavorites => favorites.isNotEmpty;
  bool get hasRecentSearches => recentSearches.isNotEmpty;
  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [
        favorites,
        recentSearches,
        isLoading,
        errorMessage,
      ];

  @override
  String toString() {
    return 'FavoritesState(favorites: ${favorites.length}, recent: ${recentSearches.length})';
  }
}