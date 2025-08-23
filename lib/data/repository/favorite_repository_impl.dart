import 'package:quick_bite/data/datasources/remote/favorite_api_service.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/domin/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteApiService _favoriteApiService;

  FavoriteRepositoryImpl(this._favoriteApiService);

  @override
  Future<List<FoodItem>> getFavorites() {
    return _favoriteApiService.getFavorites();
  }

  @override
  Future<void> addFavorite(int foodItemId) {
    return _favoriteApiService.addFavorite(foodItemId);
  }

  @override
  Future<void> removeFavorite(int foodItemId) {
    return _favoriteApiService.removeFavorite(foodItemId);
  }

  @override
  Future<void> testClaims() {
    return _favoriteApiService.testClaims();
  }
}
