import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/domin/repository/favorite_repository.dart';
import 'package:quick_bite/presentation/view_models/stats/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteCubit(this._favoriteRepository) : super(FavoriteInitial());

  Future<void> getFavorites() async {
    try {
      emit(FavoriteLoading());
      final favorites = await _favoriteRepository.getFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> addFavorite(FoodItem foodItem) async {
    final currentState = state;
    if (currentState is FavoriteLoaded) {
      final updatedFavorites = List<FoodItem>.from(currentState.favorites)
        ..add(foodItem);
      emit(FavoriteLoaded(updatedFavorites));
      try {
        await _favoriteRepository.addFavorite(foodItem);
        emit(const FavoriteUpdateSuccess('Added to favorites!'));
      } catch (e) {
        final restoredFavorites = List<FoodItem>.from(currentState.favorites);
        emit(FavoriteLoaded(restoredFavorites));
        emit(FavoriteUpdateFailure(e.toString()));
      }
    }
  }

  Future<void> removeFavorite(FoodItem foodItem) async {
    final currentState = state;
    if (currentState is FavoriteLoaded) {
      final updatedFavorites = List<FoodItem>.from(currentState.favorites)
        ..removeWhere((item) => item.id == foodItem.id);
      emit(FavoriteLoaded(updatedFavorites));
      try {
        await _favoriteRepository.removeFavorite(foodItem.id);
        emit(const FavoriteUpdateSuccess('Removed from favorites!'));
      } catch (e) {
        final restoredFavorites = List<FoodItem>.from(currentState.favorites);
        emit(FavoriteLoaded(restoredFavorites));
        emit(FavoriteUpdateFailure(e.toString()));
      }
    }
  }

  Future<void> testClaims() async {
    try {
      await _favoriteRepository.testClaims();
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
