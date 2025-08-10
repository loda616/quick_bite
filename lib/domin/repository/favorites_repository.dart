import 'package:quick_bite/data/models/food_item.dart';

abstract class FavoritesRepository {
  Future<void> addFavorite(String foodId);
  Future<void> removeFavorite(String foodId);
  Future<bool> isFavorite(String foodId);
  Future<List<FoodItem>> getAllFavorites();
  Future<void> clearAllFavorites();
  Future<void> toggleFavorite(String foodId);
}
