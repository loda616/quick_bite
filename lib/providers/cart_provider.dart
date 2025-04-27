import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

class CartItem {
  final FoodItem item;
  final int quantity;
  final List<String> customizations;

  CartItem({
    required this.item,
    required this.quantity,
    this.customizations = const [],
  });

  double get total => item.price * quantity;

  CartItem copyWith({
    FoodItem? item,
    int? quantity,
    List<String>? customizations,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
    );
  }
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get total => _items.values.fold(
        0,
        (sum, item) => sum + item.total,
      );

  void addItem(
    FoodItem foodItem, {
    int quantity = 1,
    List<String> customizations = const [],
  }) {
    if (_items.containsKey(foodItem.id)) {
      _items.update(
        foodItem.id,
        (existingItem) => CartItem(
          item: existingItem.item,
          quantity: existingItem.quantity + quantity,
          customizations: customizations.isEmpty
              ? existingItem.customizations
              : customizations,
        ),
      );
    } else {
      _items.putIfAbsent(
        foodItem.id,
        () => CartItem(
          item: foodItem,
          quantity: quantity,
          customizations: customizations,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String foodItemId) {
    _items.remove(foodItemId);
    notifyListeners();
  }

  void updateQuantity(String foodItemId, int quantity) {
    if (!_items.containsKey(foodItemId)) return;

    if (quantity <= 0) {
      removeItem(foodItemId);
    } else {
      _items.update(
        foodItemId,
        (existingItem) => existingItem.copyWith(quantity: quantity),
      );
      notifyListeners();
    }
  }

  void updateCustomizations(String foodItemId, List<String> customizations) {
    if (!_items.containsKey(foodItemId)) return;

    _items.update(
      foodItemId,
      (existingItem) => existingItem.copyWith(customizations: customizations),
    );
    notifyListeners();
  }

  void incrementItem(FoodItem foodItem) {
    if (_items.containsKey(foodItem.id)) {
      _items.update(
        foodItem.id,
        (existingItem) => CartItem(
          item: existingItem.item,
          quantity: existingItem.quantity + 1,
          customizations: existingItem.customizations,
        ),
      );
      notifyListeners();
    } else {
      addItem(foodItem);
    }
  }

  void decrementItem(FoodItem foodItem) {
    if (_items.containsKey(foodItem.id)) {
      final existingItem = _items[foodItem.id]!;
      if (existingItem.quantity > 1) {
        _items.update(
          foodItem.id,
          (item) => CartItem(
            item: item.item,
            quantity: item.quantity - 1,
            customizations: item.customizations,
          ),
        );
      } else {
        removeItem(foodItem.id);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool contains(String foodItemId) {
    return _items.containsKey(foodItemId);
  }

  CartItem? getItem(String foodItemId) {
    return _items[foodItemId];
  }
}
