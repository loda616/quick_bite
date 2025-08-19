import 'package:quick_bite/data/models/food_item.dart';

class FoodService {
  // Simulated food data - using network images or proper asset paths
  static final List<FoodItem> _items = [
    FoodItem(
      id: '1',
      name: 'Margherita Pizza',
      description: 'Classic pizza with tomato sauce, mozzarella, and basil',
      price: 12.99,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop',
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
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop',
      category: 'Burgers',
      rating: 4.3,
      reviewCount: 95,
      customizationOptions: ['Extra Patty', 'Cheese', 'Bacon', 'No Onions'],
    ),
    FoodItem(
      id: '3',
      name: 'Chicken Caesar Salad',
      description: 'Fresh romaine lettuce with grilled chicken, parmesan, and caesar dressing',
      price: 8.99,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop',
      category: 'Salads',
      rating: 4.2,
      reviewCount: 67,
      customizationOptions: ['Extra Chicken', 'No Croutons', 'Extra Dressing'],
    ),
    FoodItem(
      id: '4',
      name: 'Pepperoni Pizza',
      description: 'Classic pepperoni pizza with mozzarella cheese',
      price: 14.99,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=300&h=200&fit=crop',
      category: 'Pizza',
      rating: 4.6,
      reviewCount: 152,
      customizationOptions: ['Extra Pepperoni', 'Thick Crust', 'Extra Cheese'],
    ),
    FoodItem(
      id: '5',
      name: 'Fish Tacos',
      description: 'Grilled fish with fresh salsa and avocado in soft tortillas',
      price: 11.99,
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38174c5be9b8?w=300&h=200&fit=crop',
      category: 'Mexican',
      rating: 4.4,
      reviewCount: 89,
      customizationOptions: ['Spicy Sauce', 'Extra Avocado', 'Corn Tortillas'],
    ),
    FoodItem(
      id: '6',
      name: 'Chicken Wings',
      description: 'Crispy chicken wings with your choice of sauce',
      price: 10.99,
      imageUrl: 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=300&h=200&fit=crop',
      category: 'Appetizers',
      rating: 4.1,
      reviewCount: 76,
      customizationOptions: ['Buffalo Sauce', 'BBQ Sauce', 'Honey Mustard'],
    ),
    FoodItem(
      id: '7',
      name: 'Chocolate Brownie',
      description: 'Rich chocolate brownie with vanilla ice cream',
      price: 6.99,
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=300&h=200&fit=crop',
      category: 'Desserts',
      rating: 4.7,
      reviewCount: 134,
      customizationOptions: ['Extra Ice Cream', 'Nuts', 'Caramel Sauce'],
    ),
    FoodItem(
      id: '8',
      name: 'Greek Salad',
      description: 'Fresh vegetables with feta cheese and olive oil dressing',
      price: 7.99,
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&h=200&fit=crop',
      category: 'Salads',
      rating: 4.0,
      reviewCount: 45,
      customizationOptions: ['Extra Feta', 'No Olives', 'Extra Dressing'],
    ),
    FoodItem(
      id: '9',
      name: 'Beef Burger Deluxe',
      description: 'Premium beef burger with cheese, bacon, and gourmet toppings',
      price: 13.99,
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=300&h=200&fit=crop',
      category: 'Burgers',
      rating: 4.8,
      reviewCount: 203,
      customizationOptions: ['Double Patty', 'Extra Bacon', 'Onion Rings'],
    ),
    FoodItem(
      id: '10',
      name: 'Spaghetti Carbonara',
      description: 'Classic Italian pasta with eggs, cheese, and pancetta',
      price: 12.99,
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=300&h=200&fit=crop',
      category: 'Pasta',
      rating: 4.5,
      reviewCount: 112,
      customizationOptions: ['Extra Cheese', 'Garlic Bread', 'Extra Pancetta'],
    ),
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