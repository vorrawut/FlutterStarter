import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState()) {
    _loadFavorites();
  }

  static const String _favoritesKey = 'favorite_cities';

  Future<void> _loadFavorites() async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey);
      
      if (favoritesJson != null) {
        final favorites = favoritesJson.toList();
        emit(state.copyWith(
          favorites: favorites,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load favorites: $error',
      ));
    }
  }

  Future<void> _saveFavorites(List<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, favorites);
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to save favorites: $error',
      ));
    }
  }

  void addFavorite(String cityName) {
    if (state.favorites.contains(cityName)) {
      emit(state.copyWith(
        errorMessage: '$cityName is already in favorites',
      ));
      return;
    }

    final updatedFavorites = [...state.favorites, cityName];
    emit(state.copyWith(
      favorites: updatedFavorites,
      clearError: true,
    ));
    
    _saveFavorites(updatedFavorites);
  }

  void removeFavorite(String cityName) {
    final updatedFavorites = state.favorites.where((city) => city != cityName).toList();
    emit(state.copyWith(
      favorites: updatedFavorites,
      clearError: true,
    ));
    
    _saveFavorites(updatedFavorites);
  }

  void toggleFavorite(String cityName) {
    if (state.favorites.contains(cityName)) {
      removeFavorite(cityName);
    } else {
      addFavorite(cityName);
    }
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final updatedFavorites = [...state.favorites];
    final item = updatedFavorites.removeAt(oldIndex);
    updatedFavorites.insert(newIndex, item);

    emit(state.copyWith(favorites: updatedFavorites));
    _saveFavorites(updatedFavorites);
  }

  void clearFavorites() {
    emit(state.copyWith(favorites: []));
    _saveFavorites([]);
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  bool isFavorite(String cityName) {
    return state.favorites.contains(cityName);
  }

  List<String> searchFavorites(String query) {
    if (query.isEmpty) return state.favorites;
    
    return state.favorites
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addRecentSearch(String cityName) {
    final updatedRecent = [cityName, ...state.recentSearches];
    // Remove duplicates and keep only last 5
    final uniqueRecent = updatedRecent.toSet().take(5).toList();
    
    emit(state.copyWith(recentSearches: uniqueRecent));
  }

  void clearRecentSearches() {
    emit(state.copyWith(recentSearches: []));
  }
}