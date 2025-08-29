import 'package:quick_bite/data/models/food_item.dart';

abstract class FavoritesRepository {
  Future<List<FoodItem>> getFavorites();
  Future<void> addToFavorites(String foodItemId);
  Future<void> removeFromFavorites(String foodItemId);
  Future<bool> isFavorite(String foodItemId);
  Future<List<String>> getFavoriteIds();
}
