import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/order_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/order_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
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
              Icons.filter_list_outlined,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              _showFilterDialog(context);
            },
            tooltip: 'Filter Orders',
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
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Orders Yet',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your order history will appear here',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to menu/home
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Browse Menu'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // TODO: Refresh orders
            },
            color: theme.colorScheme.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status, theme),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(order.status),
                                style: TextStyle(
                                  color: _getStatusTextColor(order.status, isDarkMode),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Order Date
                        Text(
                          order.date,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Order Items
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x ${item.name}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        )),

                        // Divider
                        Divider(
                          color: theme.dividerColor.withOpacity(0.3),
                          height: 24,
                        ),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '\$${order.total.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.withOpacity(0.2);
      case 'preparing':
        return Colors.blue.withOpacity(0.2);
      case 'ready':
        return Colors.green.withOpacity(0.2);
      case 'delivered':
        return theme.colorScheme.outline.withOpacity(0.2);
      case 'cancelled':
        return Colors.red.withOpacity(0.2);
      default:
        return theme.colorScheme.outline.withOpacity(0.2);
    }
  }

  Color _getStatusTextColor(String status, bool isDarkMode) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade700;
      case 'preparing':
        return Colors.blue.shade700;
      case 'ready':
        return Colors.green.shade700;
      case 'delivered':
        return isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Orders'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Orders'),
              leading: Radio(
                value: 'all',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Recent Orders'),
              leading: Radio(
                value: 'recent',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Completed'),
              leading: Radio(
                value: 'completed',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}