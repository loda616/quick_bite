import 'package:quick_bite/data/datasources/remote/api_service.dart';
import 'package:quick_bite/data/models/food_item.dart';

class MenuRepository {
  final ApiService _apiService;

  MenuRepository(this._apiService);

  Future<List<String>> getCategories() async {
    try {
      return await _apiService.getCategories();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<FoodItem>> getItemsByCategory(String category) async {
    try {
      return await _apiService.getItemsByCategory(category);
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }
}