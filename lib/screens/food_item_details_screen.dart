import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';

class FoodItemDetailsScreen extends StatefulWidget {
  final FoodItem item;

  const FoodItemDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<FoodItemDetailsScreen> createState() => _FoodItemDetailsScreenState();
}

class _FoodItemDetailsScreenState extends State<FoodItemDetailsScreen> {
  int _quantity = 1;
  final Set<String> _selectedCustomizations = {};

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _toggleCustomization(String option) {
    setState(() {
      if (_selectedCustomizations.contains(option)) {
        _selectedCustomizations.remove(option);
      } else {
        _selectedCustomizations.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.restaurant,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${widget.item.reviewCount} reviews)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.item.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  if (widget.item.customizationOptions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Customizations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.item.customizationOptions.map((option) {
                        final isSelected =
                            _selectedCustomizations.contains(option);
                        return FilterChip(
                          label: Text(option),
                          selected: isSelected,
                          onSelected: (_) => _toggleCustomization(option),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _decrementQuantity,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _incrementQuantity,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total: \$${(widget.item.price * _quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.item.isAvailable
                    ? () {
                        final cart = context.read<CartProvider>();
                        cart.addItem(
                          widget.item,
                          quantity: _quantity,
                          customizations: _selectedCustomizations.toList(),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.item.name} added to cart'),
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CartScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  widget.item.isAvailable ? 'Add to Cart' : 'Not Available',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
