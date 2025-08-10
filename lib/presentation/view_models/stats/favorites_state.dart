import 'package:equatable/equatable.dart';
import 'package:quick_bite/data/models/food_item.dart';

class FavoritesState extends Equatable {
  final List<FoodItem> favorites;
  final Set<String> favoriteIds;
  final bool isLoading;
  final String? errorMessage;

  const FavoritesState({
    this.favorites = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  FavoritesState copyWith({
    List<FoodItem>? favorites,
    Set<String>? favoriteIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool isFavorite(String foodId) => favoriteIds.contains(foodId);
  
  bool get hasFavorites => favorites.isNotEmpty;
  
  bool get hasError => errorMessage != null;
  
  int get favoritesCount => favorites.length;

  @override
  List<Object?> get props => [
    favorites,
    favoriteIds,
    isLoading,
    errorMessage,
  ];

  @override
  String toString() {
    return '''FavoritesState(
  favorites: ${favorites.length},
  favoriteIds: ${favoriteIds.length},
  isLoading: $isLoading,
  hasError: $hasError,
)''';
  }
}
