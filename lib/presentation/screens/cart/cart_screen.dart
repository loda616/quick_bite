import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/cart/cart_empty_state.dart';
import '../../widgets/cart/cart_items_list.dart';
import '../../widgets/cart/cart_dialogs.dart';
import '../../widgets/cart/cart_summary.dart';
import '../../widgets/common/standard_app_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: StandardAppBar(
        title: l10n.shoppingCart,
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
                      l10n.clear,
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
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.itemCount == 0) {
            return const CartEmptyState();
          }

          return Column(
            mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
            children: [
              // Cart Header with item count
              Container(
                padding: const EdgeInsets.all(12), // Reduced padding
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
                      size: 20, // Reduced size
                    ),
                    const SizedBox(width: 8), // Reduced spacing
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Add this
                        children: [
                          Text(
                            l10n.itemsInCart(state.itemCount),
                            style: theme.textTheme.titleSmall?.copyWith( // Changed from titleMedium
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            l10n.swipeToRemove,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 11, // Reduced font size
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, // Reduced padding
                        vertical: 4,   // Reduced padding
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16), // Reduced radius
                      ),
                      child: Text(
                        '\$${state.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Reduced font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cart Items List - Use Flexible instead of Expanded
              Flexible(
                child: CartItemsList(items: state.items.values.toList()),
              ),

              // Cart Summary and Checkout - Keep at bottom
              CartSummary(state: state),
            ],
          );
        },
      ),
    );
  }
}
