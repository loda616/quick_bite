import 'package:shared_preferences/shared_preferences.dart';

class FavoriteLocalDataSource {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';

  FavoriteLocalDataSource(this._prefs);

  Future<List<String>> getFavoriteIds() async {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addFavorite(int foodItemId) async {
    final favorites = await getFavoriteIds();
    if (!favorites.contains(foodItemId.toString())) {
      favorites.add(foodItemId.toString());
      await _prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(int foodItemId) async {
    final favorites = await getFavoriteIds();
    if (favorites.contains(foodItemId.toString())) {
      favorites.remove(foodItemId.toString());
      await _prefs.setStringList(_favoritesKey, favorites);
    }
  }
}
