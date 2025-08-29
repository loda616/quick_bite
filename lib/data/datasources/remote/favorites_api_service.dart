import 'package:dio/dio.dart';
import 'package:quick_bite/data/models/food_item.dart';

class FavoritesApiService {
  final Dio _dio;

  FavoritesApiService(this._dio);

  Future<List<FoodItem>> getFavorites() async {
    try {
      final response = await _dio.get('/favorites');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final favorites = data['data']['favorites'] as List<dynamic>;
        
        return favorites
            .map((item) => FoodItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load favorites');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<void> addToFavorites(String foodItemId) async {
    try {
      final response = await _dio.post(
        '/favorites',
        data: {'foodItemId': foodItemId},
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to add item to favorites');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('This item is already in your favorites');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid food item ID provided');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String foodItemId) async {
    try {
      final response = await _dio.delete('/favorites/$foodItemId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to remove item from favorites');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Favorite item not found');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}
