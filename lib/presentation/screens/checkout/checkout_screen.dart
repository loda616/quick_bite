import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/request/checkout_request_model.dart';
import 'package:quick_bite/domin/repository/checkout_repository.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import '../../../core/routs/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'card';
  String _selectedDeliveryOption = 'standard';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkout),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
            tooltip: l10n.cart,
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.itemCount == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    child: Text('Browse Menu'),
                  ),
                ],
              ),
            );
          }

          final deliveryFee = state.total > 25 ? 0.0 : 5.0;
          final totalWithDelivery = state.total + deliveryFee;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          '${l10n.cart} (${state.itemCount} items)',
                          '\$${state.total.toStringAsFixed(2)}',
                          theme,
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          l10n.deliveryFee,
                          deliveryFee == 0 ? l10n.free : '\$${deliveryFee.toStringAsFixed(2)}',
                          theme,
                          valueColor: deliveryFee == 0 ? theme.colorScheme.primary : null,
                        ),
                        const Divider(height: 24),
                        _buildSummaryRow(
                          l10n.total,
                          '\$${totalWithDelivery.toStringAsFixed(2)}',
                          theme,
                          titleStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          valueStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Delivery Options
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Options',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RadioListTile<String>(
                          title: const Text('Standard Delivery'),
                          subtitle: const Text('30-45 minutes'),
                          value: 'standard',
                          groupValue: _selectedDeliveryOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Express Delivery'),
                          subtitle: const Text('15-20 minutes (+\$3.00)'),
                          value: 'express',
                          groupValue: _selectedDeliveryOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Payment Methods
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RadioListTile<String>(
                          title: const Text('Credit/Debit Card'),
                          subtitle: const Text('Visa, Mastercard, etc.'),
                          value: 'card',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Cash on Delivery'),
                          subtitle: const Text('Pay when your order arrives'),
                          value: 'cash',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _placeOrder(context, state);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Place Order - \$${totalWithDelivery.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value,
    ThemeData theme, {
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: titleStyle ?? theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  void _placeOrder(BuildContext context, CartState state) async {
    final checkoutRepository = context.read<CheckoutRepository>();

    final items = state.items.entries.map((entry) {
      return CartItem(
        menuItemId: int.parse(entry.key.id),
        quantity: entry.value,
      );
    }).toList();

    final checkoutRequest = CheckoutRequestModel(
      items: items,
      deliveryOption: _selectedDeliveryOption,
      paymentMethod: _selectedPaymentMethod,
    );

    try {
      await checkoutRepository.checkout(checkoutRequest);
      context.read<CartCubit>().clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order placed successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
        (route) => false,
        arguments: {'initialIndex': 2},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
