import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/domin/repository/favorites_repository.dart';
import '../stats/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesState());

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final favorites = await _favoritesRepository.getAllFavorites();
      final favoriteIds = favorites.map((item) => item.id).toSet();

      emit(state.copyWith(
        favorites: favorites,
        favoriteIds: favoriteIds,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleFavorite(String foodId) async {
    try {
      await _favoritesRepository.toggleFavorite(foodId);
      
      final updatedFavoriteIds = Set<String>.from(state.favoriteIds);
      final updatedFavorites = List.from(state.favorites);
      
      if (updatedFavoriteIds.contains(foodId)) {
        updatedFavoriteIds.remove(foodId);
        updatedFavorites.removeWhere((item) => item.id == foodId);
      } else {
        updatedFavoriteIds.add(foodId);
      }

      emit(state.copyWith(
        favoriteIds: updatedFavoriteIds,
        favorites: updatedFavorites,
        errorMessage: null,
      ));
      
      if (!updatedFavoriteIds.contains(foodId)) {
        await loadFavorites();
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> addFavorite(String foodId) async {
    try {
      await _favoritesRepository.addFavorite(foodId);
      final updatedFavoriteIds = Set<String>.from(state.favoriteIds)..add(foodId);
      
      emit(state.copyWith(
        favoriteIds: updatedFavoriteIds,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> removeFavorite(String foodId) async {
    try {
      await _favoritesRepository.removeFavorite(foodId);
      final updatedFavoriteIds = Set<String>.from(state.favoriteIds)..remove(foodId);
      final updatedFavorites = state.favorites.where((item) => item.id != foodId).toList();
      
      emit(state.copyWith(
        favoriteIds: updatedFavoriteIds,
        favorites: updatedFavorites,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await _favoritesRepository.clearAllFavorites();
      emit(state.copyWith(
        favorites: [],
        favoriteIds: {},
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
