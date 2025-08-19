import 'package:flutter/material.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

import 'cart_item_card.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItem> items;

  const CartItemsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemCard(item: item);
      },
    );
  }
}