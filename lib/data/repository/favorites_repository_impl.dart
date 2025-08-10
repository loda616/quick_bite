import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/domin/repository/favorites_repository.dart';
import 'package:quick_bite/domin/repository/menu_repository.dart';
import '../datasources/local/favorites_database_service.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesDatabaseService _databaseService;
  final MenuRepository _menuRepository;

  FavoritesRepositoryImpl(this._databaseService, this._menuRepository);

  @override
  Future<void> addFavorite(String foodId) async {
    try {
      await _databaseService.addFavorite(foodId);
    } catch (e) {
      throw Exception('Failed to add favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(String foodId) async {
    try {
      await _databaseService.removeFavorite(foodId);
    } catch (e) {
      throw Exception('Failed to remove favorite: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String foodId) async {
    try {
      return await _databaseService.isFavorite(foodId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<FoodItem>> getAllFavorites() async {
    try {
      final favoriteIds = await _databaseService.getAllFavoriteIds();
      final favorites = <FoodItem>[];
      
      for (final id in favoriteIds) {
        final item = await _menuRepository.getItemById(id);
        if (item != null) {
          favorites.add(item);
        }
      }
      
      return favorites;
    } catch (e) {
      throw Exception('Failed to get favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAllFavorites() async {
    try {
      await _databaseService.clearAllFavorites();
    } catch (e) {
      throw Exception('Failed to clear favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavorite(String foodId) async {
    try {
      final isFav = await isFavorite(foodId);
      if (isFav) {
        await removeFavorite(foodId);
      } else {
        await addFavorite(foodId);
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: ${e.toString()}');
    }
  }
}
