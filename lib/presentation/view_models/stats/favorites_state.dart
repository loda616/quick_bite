import 'package:equatable/equatable.dart';
import 'package:quick_bite/data/models/food_item.dart';

class FavoritesState extends Equatable {
  final List<FoodItem> favorites;
  final Set<String> favoriteIds;
  final bool isLoading;
  final bool isLoadingToggle;
  final String? errorMessage;

  const FavoritesState({
    this.favorites = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
    this.isLoadingToggle = false,
    this.errorMessage,
  });

  FavoritesState copyWith({
    List<FoodItem>? favorites,
    Set<String>? favoriteIds,
    bool? isLoading,
    bool? isLoadingToggle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      isLoadingToggle: isLoadingToggle ?? this.isLoadingToggle,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool isFavorite(String foodItemId) {
    return favoriteIds.contains(foodItemId);
  }

  @override
  List<Object?> get props => [
        favorites,
        favoriteIds,
        isLoading,
        isLoadingToggle,
        errorMessage,
      ];
}
