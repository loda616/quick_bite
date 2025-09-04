import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/l10n/generated/app_localizations.dart';
import 'package:quick_bite/presentation/view_models/cubit/favorite_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/favorite_state.dart';
import 'package:quick_bite/presentation/widgets/food_item_card.dart';
import '../../../core/routs/app_routs.dart';
import '../../../core/routs/routes.dart';
import '../../widgets/common/standard_app_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteLoaded) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Scaffold(
        appBar: StandardAppBar(
          title: l10n.favorites,
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FavoriteLoaded) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Text(l10n.noFavoritesYet),
                );
              }
              return ListView.builder(
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final foodItem = state.favorites[index];
                  return FoodItemCard(
                    item: foodItem,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.foodDetails,
                        arguments: foodItem,
                      );
                    },
                  );
                },
              );
            } else if (state is FavoriteError) {
              return Center(
                child: Text(state.message),
              );
            }
            return Center(
              child: Text(l10n.favoritesError),
            );
          },
        ),
      ),
    );
  }
}
