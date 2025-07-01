import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';

import '../../../core/routs/routes.dart';
import '../../widgets/cart/cart_empty_state.dart';
import '../../widgets/cart/cart_items_list.dart';
import '../../widgets/cart/cart_dialogs.dart';
import '../../widgets/cart/cart_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.items.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: TextButton.icon(
                    onPressed: () {
                      CartDialogs.showClearCartDialog(context);
                    },
                    icon: Icon(
                      Icons.clear_all_outlined,
                      size: 20,
                      color: theme.colorScheme.error,
                    ),
                    label: Text(
                      'Clear',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: theme.colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        // Add subtle shadow/border for better separation
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.dividerColor.withOpacity(0.1),
                  theme.dividerColor.withOpacity(0.3),
                  theme.dividerColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.itemCount == 0) {
            return const CartEmptyState();
          }

          return Column(
            children: [
              // Cart Header with item count
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.dividerColor.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.itemCount} ${state.itemCount == 1 ? 'Item' : 'Items'} in Cart',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Swipe to remove items',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${state.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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