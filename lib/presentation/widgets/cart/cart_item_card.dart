import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

import 'cart_item_details.dart';
import 'cart_item_image.dart';
import 'cart_item_quantity_controls.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Item Image
            CartItemImage(imageUrl: item.item.imageUrl),
            const SizedBox(width: 16),

            // Item Details
            Expanded(
              child: CartItemDetails(item: item),
            ),

            // Quantity Controls
            CartItemQuantityControls(
              item: item,
              onIncrement: () {
                context.read<CartCubit>().addItem(item.item);
              },
              onDecrement: () {
                context.read<CartCubit>().removeItem(item.item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}