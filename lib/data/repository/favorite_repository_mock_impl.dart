import 'package:quick_bite/data/datasources/local/favorite_local_data_source.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/domin/repository/favorite_repository.dart';
import 'package:quick_bite/domin/repository/menu_repository.dart';

class FavoriteRepositoryMockImpl implements FavoriteRepository {
  final FavoriteLocalDataSource _localDataSource;
  final MenuRepository _menuRepository;

  FavoriteRepositoryMockImpl(this._localDataSource, this._menuRepository);

  @override
  Future<List<FoodItem>> getFavorites() async {
    final favoriteIds = await _localDataSource.getFavoriteIds();
    final allItems = await _menuRepository.getAllItems();
    return allItems
        .where((item) => favoriteIds.contains(item.id.toString()))
        .toList();
  }

  @override
  Future<void> addFavorite(int foodItemId) {
    return _localDataSource.addFavorite(foodItemId);
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
