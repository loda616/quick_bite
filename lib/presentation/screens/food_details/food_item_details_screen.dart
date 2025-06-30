import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import '../../../core/routs/routes.dart';
import '../../widgets/food_details/food_details_app_bar.dart';
import '../../widgets/food_details/food_details_bottom_bar.dart';
import '../../widgets/food_details/food_details_content.dart';


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

  void _addToCart() {
    final cart = context.read<CartCubit>();
    cart.addItem(
      widget.item,
      quantity: _quantity,
      customizations: _selectedCustomizations.toList(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.item.name} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          FoodDetailsAppBar(item: widget.item),

          // Main Content
          SliverToBoxAdapter(
            child: FoodDetailsContent(
              item: widget.item,
              quantity: _quantity,
              selectedCustomizations: _selectedCustomizations,
              onQuantityIncrement: _incrementQuantity,
              onQuantityDecrement: _decrementQuantity,
              onCustomizationToggle: _toggleCustomization,
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: FoodDetailsBottomBar(
        item: widget.item,
        quantity: _quantity,
        onAddToCart: _addToCart,
      ),
    );
  }
}