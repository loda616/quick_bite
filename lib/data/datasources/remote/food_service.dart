import 'package:dio/dio.dart';
import 'package:quick_bite/data/datasources/remote/api_service.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/data/repository/menu_repository.dart';

class FoodService {
  final MenuRepository _menuRepository;

  FoodService() : _menuRepository = MenuRepository(ApiService(Dio()));

  Future<List<String>> getAllCategories() async {
    return await _menuRepository.getCategories();
  }

  Future<List<FoodItem>> getItemsByCategory(String category) async {
    return await _menuRepository.getItemsByCategory(category);
  }

  // Keep your existing "getPopularItems" if needed
  Future<List<FoodItem>> getPopularItems() async {
    // Implement logic for popular items (or fetch from API if available)
    return [];
  }
}