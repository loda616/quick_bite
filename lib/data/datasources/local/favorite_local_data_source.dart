import 'dart:convert';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteLocalDataSource {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';

  FavoriteLocalDataSource(this._prefs);

  Future<List<FoodItem>> getFavorites() async {
    final favoriteStrings = _prefs.getStringList(_favoritesKey) ?? [];
    return favoriteStrings
        .map((s) => FoodItem.fromJson(jsonDecode(s)))
        .toList();
  }

  Future<void> addFavorite(FoodItem foodItem) async {
    final favorites = await getFavorites();
    if (!favorites.any((item) => item.id == foodItem.id)) {
      favorites.add(foodItem);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(int foodItemId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == foodItemId);
    await _saveFavorites(favorites);
  }

  Future<void> _saveFavorites(List<FoodItem> favorites) async {
    final favoriteStrings =
        favorites.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList(_favoritesKey, favoriteStrings);
  }
}
