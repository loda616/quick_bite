import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/domin/repository/favorites_repository.dart';
import '../stats/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesState());

  Future<void> loadFavorites() async {
    print('=== LOADING FAVORITES ===');
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final favorites = await _favoritesRepository.getFavorites();
      final favoriteIds = favorites.map((item) => item.id).toSet();

      print('✓ Loaded ${favorites.length} favorites');

      emit(state.copyWith(
        favorites: favorites,
        favoriteIds: favoriteIds,
        isLoading: false,
      ));
    } catch (e) {
      print('❌ Failed to load favorites: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleFavorite(String foodItemId) async {
    print('=== TOGGLING FAVORITE: $foodItemId ===');
    
    if (state.isLoadingToggle) {
      print('Already toggling, ignoring request');
      return;
    }

    emit(state.copyWith(isLoadingToggle: true, clearError: true));

    try {
      final isFavorite = state.isFavorite(foodItemId);

      if (isFavorite) {
        await _favoritesRepository.removeFromFavorites(foodItemId);
        print('✓ Removed from favorites');
        
        final updatedFavorites = state.favorites
            .where((item) => item.id != foodItemId)
            .toList();
        final updatedIds = Set<String>.from(state.favoriteIds)
          ..remove(foodItemId);

        emit(state.copyWith(
          favorites: updatedFavorites,
          favoriteIds: updatedIds,
          isLoadingToggle: false,
        ));
      } else {
        await _favoritesRepository.addToFavorites(foodItemId);
        print('✓ Added to favorites');
        
        final updatedIds = Set<String>.from(state.favoriteIds)
          ..add(foodItemId);

        emit(state.copyWith(
          favoriteIds: updatedIds,
          isLoadingToggle: false,
        ));
        
        await loadFavorites();
      }
    } catch (e) {
      print('❌ Failed to toggle favorite: $e');
      emit(state.copyWith(
        isLoadingToggle: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> refreshFavorites() async {
    print('=== REFRESHING FAVORITES ===');
    await loadFavorites();
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  Future<void> initializeFavorites() async {
    try {
      final favoriteIds = await _favoritesRepository.getFavoriteIds();
      emit(state.copyWith(favoriteIds: favoriteIds.toSet()));
    } catch (e) {
      print('Failed to initialize favorites: $e');
    }
  }

  bool isFavorite(String foodItemId) {
    return state.isFavorite(foodItemId);
  }

  int get favoritesCount => state.favorites.length;
}
