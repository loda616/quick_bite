import 'package:quick_bite/data/models/food_item.dart';

class CartState {
  final Map<String, CartItem> items;

  const CartState({this.items = const {}});

  int get itemCount => items.length;

  double get total => items.values.fold(
    0,
        (sum, item) => sum + item.total,
  );
}

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
}