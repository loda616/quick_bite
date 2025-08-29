import 'package:quick_bite/data/datasources/local/secure_storage_service.dart';
import 'package:quick_bite/data/datasources/remote/favorites_api_service.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/domin/repository/favorites_repository.dart';
import 'dart:convert';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesApiService _apiService;
  final SecureStorageService _storageService;
  
  static const String _favoritesKey = 'cached_favorites';
  static const String _favoriteIdsKey = 'favorite_ids';

  FavoritesRepositoryImpl(this._apiService, this._storageService);

  @override
  Future<List<FoodItem>> getFavorites() async {
    try {
      final favorites = await _apiService.getFavorites();
      await _cacheFavorites(favorites);
      await _cacheFavoriteIds(favorites.map((item) => item.id).toList());
      return favorites;
    } catch (e) {
      final cachedFavorites = await _getCachedFavorites();
      if (cachedFavorites.isNotEmpty) {
        return cachedFavorites;
      }
      rethrow;
    }
  }

  @override
  Future<void> addToFavorites(String foodItemId) async {
    try {
      await _apiService.addToFavorites(foodItemId);
      await _addToLocalFavorites(foodItemId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(String foodItemId) async {
    try {
      await _apiService.removeFromFavorites(foodItemId);
      await _removeFromLocalFavorites(foodItemId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(String foodItemId) async {
    final favoriteIds = await getFavoriteIds();
    return favoriteIds.contains(foodItemId);
  }

  @override
  Future<List<String>> getFavoriteIds() async {
    try {
      final cachedIds = await _storageService.read(_favoriteIdsKey);
      if (cachedIds != null) {
        final List<dynamic> ids = json.decode(cachedIds);
        return ids.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> _cacheFavorites(List<FoodItem> favorites) async {
    try {
      final favoritesJson = favorites.map((item) => item.toJson()).toList();
      await _storageService.write(_favoritesKey, json.encode(favoritesJson));
    } catch (e) {
      print('Failed to cache favorites: $e');
    }
  }

  Future<void> _cacheFavoriteIds(List<String> ids) async {
    try {
      await _storageService.write(_favoriteIdsKey, json.encode(ids));
    } catch (e) {
      print('Failed to cache favorite IDs: $e');
    }
  }

  Future<List<FoodItem>> _getCachedFavorites() async {
    try {
      final cachedData = await _storageService.read(_favoritesKey);
      if (cachedData != null) {
        final List<dynamic> favoritesJson = json.decode(cachedData);
        return favoritesJson
            .map((item) => FoodItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> _addToLocalFavorites(String foodItemId) async {
    try {
      final currentIds = await getFavoriteIds();
      if (!currentIds.contains(foodItemId)) {
        currentIds.add(foodItemId);
        await _cacheFavoriteIds(currentIds);
      }
    } catch (e) {
      print('Failed to add to local favorites: $e');
    }
  }

  Future<void> _removeFromLocalFavorites(String foodItemId) async {
    try {
      final currentIds = await getFavoriteIds();
      currentIds.remove(foodItemId);
      await _cacheFavoriteIds(currentIds);
      
      final cachedFavorites = await _getCachedFavorites();
      final updatedFavorites = cachedFavorites
          .where((item) => item.id != foodItemId)
          .toList();
      await _cacheFavorites(updatedFavorites);
    } catch (e) {
      print('Failed to remove from local favorites: $e');
    }
  }
}
