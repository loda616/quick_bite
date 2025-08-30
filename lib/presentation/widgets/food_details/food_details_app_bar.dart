import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/presentation/view_models/cubit/favorite_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/favorite_state.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class FoodDetailsAppBar extends StatelessWidget {
  final FoodItem item;

  const FoodDetailsAppBar({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Food Image
            _buildFoodImage(),

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
        BlocConsumer<FavoriteCubit, FavoriteState>(
          listener: (context, state) {
            if (state is FavoriteUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is FavoriteUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          buildWhen: (previous, current) {
            return current is FavoriteLoaded || current is FavoriteInitial;
          },
          builder: (context, state) {
            bool isFavorite = false;
            if (state is FavoriteLoaded) {
              isFavorite = state.favorites.any((fav) => fav.id == item.id);
            }
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                if (isFavorite) {
                  context.read<FavoriteCubit>().removeFavorite(item);
                } else {
                  context.read<FavoriteCubit>().addFavorite(item);
                }
              },
              tooltip: 'Add to Favorites',
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            final String itemUrl = 'https://quickbite.dev/item/${item.id}';
            final String shareText =
                '${l10n.shareText(item.name)}\n\n$itemUrl';

            Share.share(shareText);
          },
          tooltip: 'Share',
        ),
      ],
    );
  }

  Widget _buildFoodImage() {
    // Check if it's a network URL
    if (item.imageUrl.startsWith('http')) {
      return Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 3,
                color: AppTheme.primaryColor,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      // Try to load as asset, fallback to placeholder if not found
      return Image.asset(
        item.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.3),
            AppTheme.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(item.category),
            size: 80,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            item.category,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return Icons.local_pizza;
      case 'burgers':
        return Icons.lunch_dining;
      case 'salads':
        return Icons.eco;
      case 'mexican':
        return Icons.food_bank;
      case 'appetizers':
        return Icons.restaurant;
      case 'desserts':
        return Icons.cake;
      case 'pasta':
        return Icons.ramen_dining;
      default:
        return Icons.restaurant_menu;
    }
  }
}