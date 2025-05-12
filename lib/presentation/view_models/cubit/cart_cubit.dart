import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(
      FoodItem foodItem, {
        int quantity = 1,
        List<String> customizations = const [],
      }) {
    final items = Map<String, CartItem>.from(state.items);

    if (items.containsKey(foodItem.id)) {
      final existingItem = items[foodItem.id]!;
      items[foodItem.id] = CartItem(
        item: existingItem.item,
        quantity: existingItem.quantity + quantity,
        customizations: customizations.isEmpty
            ? existingItem.customizations
            : customizations,
      );
    } else {
      items[foodItem.id] = CartItem(
        item: foodItem,
        quantity: quantity,
        customizations: customizations,
      );
    }

    emit(CartState(items: items));
  }

  void removeItem(String foodItemId) {
    final items = Map<String, CartItem>.from(state.items);
    items.remove(foodItemId);
    emit(CartState(items: items));
  }

}