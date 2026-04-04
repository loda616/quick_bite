import 'package:dio/dio.dart';
import 'package:quick_bite/data/models/food_item.dart';

class FavoriteApiService {
  final Dio _dio;
  final String _baseUrl;

  FavoriteApiService(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? "http://hydra.runasp.net/";

  Future<List<FoodItem>> getFavorites() async {
    try {
      final response = await _dio.get(
        '${_baseUrl}api/Favourite',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FoodItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load favorites: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> addFavorite(int foodItemId) async {
    try {
      final response = await _dio.post(
        '${_baseUrl}api/Favourite/$foodItemId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add favorite: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add favorite: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> removeFavorite(int foodItemId) async {
    try {
      final response = await _dio.delete(
        '${_baseUrl}api/Favourite/$foodItemId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove favorite: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to remove favorite: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> testClaims() async {
    try {
      await _dio.get(
        '${_baseUrl}api/Favourite/TestClaims',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
