import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/view_models/cubit/favorite_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/favorite_state.dart';
import 'package:quick_bite/presentation/widgets/food_item_card.dart';
import '../../widgets/common/standard_app_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StandardAppBar(
        title: 'Favorites',
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(
                child: Text('You have no favorites yet.'),
              );
            }
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final foodItem = state.favorites[index];
                return FoodItemCard(
                  item: foodItem,
                );
              },
            );
          } else if (state is FavoriteError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const Center(
            child: Text('Something went wrong. Please try again.'),
          );
        },
      ),
    );
  }
}
