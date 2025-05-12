import 'package:quick_bite/data/models/food_item.dart';


class FoodService {
  // Simulated food data - in a real app, this would come from an API
  static final List<FoodItem> _items = [
    FoodItem(
      id: '1',
      name: 'Margherita Pizza',
      description: 'Classic pizza with tomato sauce, mozzarella, and basil',
      price: 12.99,
      imageUrl: 'assets/images/pizza.jpg',
      category: 'Pizza',
      rating: 4.5,
      reviewCount: 128,
      customizationOptions: ['Extra Cheese', 'Thin Crust', 'Gluten Free'],
    ),
    FoodItem(
      id: '2',
      name: 'Classic Burger',
      description: 'Juicy beef patty with lettuce, tomato, and special sauce',
      price: 9.99,
      imageUrl: 'assets/images/burger.jpg',
      category: 'Burgers',
      rating: 4.3,
      reviewCount: 95,
      customizationOptions: ['Extra Patty', 'Cheese', 'Bacon', 'No Onions'],
    ),
    // Add more items as needed
  ];

  // Get all food items
  Future<List<FoodItem>> getAllItems() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _items;
  }

  // Get items by category
  Future<List<FoodItem>> getItemsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _items.where((item) => item.category == category).toList();
  }

  // Get popular items
  Future<List<FoodItem>> getPopularItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _items.where((item) => item.rating >= 4.0).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  // Search items
  Future<List<FoodItem>> searchItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowercaseQuery = query.toLowerCase();
    return _items
        .where((item) =>
    item.name.toLowerCase().contains(lowercaseQuery) ||
        item.description.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  // Get item by ID
  Future<FoodItem?> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all categories
  Future<List<String>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _items.map((item) => item.category).toSet().toList()..sort();
  }
}
