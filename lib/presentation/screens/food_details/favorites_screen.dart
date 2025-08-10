import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/favorites_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/favorites_state.dart';
import 'package:quick_bite/presentation/widgets/food_item_card.dart';
import 'package:quick_bite/core/routs/routes.dart';
import '../../widgets/common/standard_app_bar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Favorites',
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              if (state.hasFavorites) {
                return IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () => _showClearAllDialog(context),
                  tooltip: 'Clear All Favorites',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading favorites',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? 'Unknown error',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesCubit>().loadFavorites();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!state.hasFavorites) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items to favorites by tapping the heart icon',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final item = state.favorites[index];
                return FoodItemCard(
                  item: item,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.foodDetails,
                      arguments: item,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesCubit>().clearAllFavorites();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
