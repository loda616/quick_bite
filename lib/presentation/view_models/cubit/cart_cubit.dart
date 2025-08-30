import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

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

    if (items.containsKey(foodItem.id.toString())) {
      final existingItem = items[foodItem.id.toString()]!;
      items[foodItem.id.toString()] = CartItem(
        item: existingItem.item,
        quantity: existingItem.quantity + quantity,
        customizations: customizations.isEmpty
            ? existingItem.customizations
            : customizations,
      );
    } else {
      items[foodItem.id.toString()] = CartItem(
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

  void updateItemQuantity(String foodItemId, int newQuantity) {
    final items = Map<String, CartItem>.from(state.items);

    if (newQuantity <= 0) {
      // If quantity is 0 or less, remove the item completely
      items.remove(foodItemId);
    } else if (items.containsKey(foodItemId)) {
      // Update the quantity
      final existingItem = items[foodItemId]!;
      items[foodItemId] = CartItem(
        item: existingItem.item,
        quantity: newQuantity,
        customizations: existingItem.customizations,
      );
    }

    emit(CartState(items: items));
  }

  void incrementItem(String foodItemId) {
    final items = Map<String, CartItem>.from(state.items);

    if (items.containsKey(foodItemId)) {
      final existingItem = items[foodItemId]!;
      items[foodItemId] = CartItem(
        item: existingItem.item,
        quantity: existingItem.quantity + 1,
        customizations: existingItem.customizations,
      );
      emit(CartState(items: items));
    }
  }

  void decrementItem(String foodItemId) {
    final items = Map<String, CartItem>.from(state.items);

    if (items.containsKey(foodItemId)) {
      final existingItem = items[foodItemId]!;

      if (existingItem.quantity > 1) {
        // Reduce quantity by 1
        items[foodItemId] = CartItem(
          item: existingItem.item,
          quantity: existingItem.quantity - 1,
          customizations: existingItem.customizations,
        );
      } else {
        // Remove item if quantity would become 0
        items.remove(foodItemId);
      }

      emit(CartState(items: items));
    }
  }

  void clearCart() {
    emit(const CartState());
  }
}