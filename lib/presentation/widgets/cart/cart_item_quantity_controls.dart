import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

import '../../../core/theme/app_theme.dart';

class CartItemQuantityControls extends StatelessWidget {
  final CartItem item;

  const CartItemQuantityControls({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: IconButton(
            icon: Icon(Icons.add,
                color: Theme.of(context).colorScheme.onPrimary, size: 18),
            onPressed: () {
              context.read<CartCubit>().incrementItem(item.item.id);
            },
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${item.quantity}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
          child: IconButton(
            icon: Icon(Icons.remove,
                color: Theme.of(context).colorScheme.onSurface, size: 18),
            onPressed: () {
              context.read<CartCubit>().decrementItem(item.item.id);
            },
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
