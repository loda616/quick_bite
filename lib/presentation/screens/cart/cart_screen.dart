import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

import '../../../core/routs/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/cart/cart_empty_state.dart';
import '../../widgets/cart/cart_items_list.dart';
import '../../widgets/cart/cart_dialogs.dart';
import '../../widgets/cart/cart_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: const Color(0xFFf8f1df),
        foregroundColor: AppTheme.accentColor,
        elevation: 0,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.items.isNotEmpty) {
                return TextButton.icon(
                  onPressed: () {
                    CartDialogs.showClearCartDialog(context);
                  },
                  icon: const Icon(Icons.clear_all, size: 20),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.itemCount == 0) {
            return const CartEmptyState();
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: CartItemsList(items: state.items.values.toList()),
              ),

              // Cart Summary and Checkout
              CartSummary(state: state),
            ],
          );
        },
      ),
    );
  }
}