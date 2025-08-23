import 'package:quick_bite/data/models/food_item.dart';

abstract class FavoriteRepository {
  Future<List<FoodItem>> getFavorites();
  Future<void> addFavorite(int foodItemId);
  Future<void> removeFavorite(int foodItemId);
  Future<void> testClaims();
}
