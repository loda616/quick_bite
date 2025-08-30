import 'package:json_annotation/json_annotation.dart';

import 'food_item.dart';

part 'menu_item_model.g.dart';

@JsonSerializable()
class MenuItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  /// Convert to FoodItem for UI layer
  FoodItem toFoodItem() {
    return FoodItem(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl ?? _getPlaceholderImage(),
      category: _extractCategory(),
      rating: 4.0 + (id % 5) * 0.2, // Generate rating based on ID
      reviewCount: 50 + (id * 15) % 200, // Generate review count
      isAvailable: true,
      customizationOptions: _getCustomizationOptions(),
    );
  }

  /// Get placeholder image based on item name/category
  String _getPlaceholderImage() {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('pizza') || lowerName.contains('margherita')) {
      return 'https://placehold.co/300x200/E91E63/FFFFFF/png?text=Pizza';
    } else if (lowerName.contains('burger') || lowerName.contains('cheeseburger')) {
      return 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop';
    } else if (lowerName.contains('shawarma') || lowerName.contains('wrap')) {
      return 'https://images.unsplash.com/photo-1565299585323-38174c5be9b8?w=300&h=200&fit=crop';
    } else if (lowerName.contains('chicken')) {
      return 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=300&h=200&fit=crop';
    }

    return 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop';
  }

  /// Extract category from item name
  String _extractCategory() {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('pizza')) return 'Pizza';
    if (lowerName.contains('burger')) return 'Burger';
    if (lowerName.contains('shawarma') || lowerName.contains('wrap')) return 'Shawarma';

    return 'Other';
  }

  /// Generate customization options based on category
  List<String> _getCustomizationOptions() {
    final category = _extractCategory();

    switch (category) {
      case 'Pizza':
        return ['Extra Cheese', 'Thin Crust', 'Gluten Free', 'Extra Toppings'];
      case 'Burger':
        return ['Extra Patty', 'Cheese', 'Bacon', 'No Onions', 'Extra Sauce'];
      case 'Shawarma':
        return ['Spicy Sauce', 'Extra Meat', 'No Pickles', 'Extra Garlic'];
      default:
        return ['Extra Portion', 'No Sauce', 'Spicy'];
    }
  }
}
