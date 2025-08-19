import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_bite/data/models/food_item.dart';

class FoodService {
  final String _baseUrl = 'https://api.quickbite.com/v1';

  Future<List<FoodItem>> _fetchItems(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> itemList = data['data']['results'];
      return itemList.map((json) => FoodItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load food items');
    }
  }

  Future<List<FoodItem>> getAllItems() async {
    return _fetchItems('$_baseUrl/search');
  }

  Future<List<FoodItem>> getItemsByCategory(String category) async {
    return _fetchItems('$_baseUrl/search?category=$category');
  }

  Future<List<FoodItem>> getPopularItems() async {
    return _fetchItems('$_baseUrl/search?sortBy=rating&order=desc');
  }

  Future<List<FoodItem>> searchItems(String query) async {
    return _fetchItems('$_baseUrl/search?q=$query');
  }

  Future<FoodItem?> getItemById(String id) async {
    final items = await getAllItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getAllCategories() async {
    final items = await getAllItems();
    return items.map((item) => item.category).toSet().toList()..sort();
  }
}