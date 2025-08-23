import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> addFavorite(int foodItemId) async {
    try {
      await _favoriteRepository.addFavorite(foodItemId);
      getFavorites();
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> removeFavorite(int foodItemId) async {
    try {
      await _favoriteRepository.removeFavorite(foodItemId);
      getFavorites();
    } catch (e) {
      emit(FavoriteError(e.toString()));
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
