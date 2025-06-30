import 'package:flutter/material.dart';
import 'package:quick_bite/data/models/food_item.dart';

import '../../../core/theme/app_theme.dart';

class FoodDetailsAppBar extends StatelessWidget {
  final FoodItem item;

  const FoodDetailsAppBar({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // TODO: Implement favorite functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Favorites feature coming soon!'),
              ),
            );
          },
          tooltip: 'Add to Favorites',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Implement share functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Share feature coming soon!'),
              ),
            );
          },
          tooltip: 'Share',
        ),
      ],
    );
  }
}