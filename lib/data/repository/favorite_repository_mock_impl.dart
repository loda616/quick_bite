import 'package:quick_bite/data/datasources/local/favorite_local_data_source.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/domin/repository/favorite_repository.dart';

class FavoriteRepositoryMockImpl implements FavoriteRepository {
  final FavoriteLocalDataSource _localDataSource;

  FavoriteRepositoryMockImpl(this._localDataSource);

  @override
  Future<List<FoodItem>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(FoodItem foodItem) {
    return _localDataSource.addFavorite(foodItem);
  }

  @override
  Future<void> removeFavorite(int foodItemId) {
    return _localDataSource.removeFavorite(foodItemId);
  }

  @override
  Future<void> testClaims() async {
    // This is a mock implementation, so we do nothing here.
    return Future.value();
  }
}
