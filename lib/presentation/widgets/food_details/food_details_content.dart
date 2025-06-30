import 'package:flutter/material.dart';
import 'package:quick_bite/data/models/food_item.dart';

import 'food_customizations.dart';
import 'food_description.dart';
import 'food_header_info.dart';
import 'food_quantity_selector.dart';


class FoodDetailsContent extends StatelessWidget {
  final FoodItem item;
  final int quantity;
  final Set<String> selectedCustomizations;
  final VoidCallback onQuantityIncrement;
  final VoidCallback onQuantityDecrement;
  final Function(String) onCustomizationToggle;

  const FoodDetailsContent({
    super.key,
    required this.item,
    required this.quantity,
    required this.selectedCustomizations,
    required this.onQuantityIncrement,
    required this.onQuantityDecrement,
    required this.onCustomizationToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Name, Price, and Rating
          FoodHeaderInfo(item: item),
          const SizedBox(height: 20),

          // Description
          FoodDescription(description: item.description),

          // Customizations
          if (item.customizationOptions.isNotEmpty) ...[
            const SizedBox(height: 24),
            FoodCustomizations(
              options: item.customizationOptions,
              selectedCustomizations: selectedCustomizations,
              onToggle: onCustomizationToggle,
            ),
          ],

          const SizedBox(height: 32),

          // Quantity Selector
          FoodQuantitySelector(
            quantity: quantity,
            onIncrement: onQuantityIncrement,
            onDecrement: onQuantityDecrement,
          ),

          // Add some bottom padding for the floating action button
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}