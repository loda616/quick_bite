import 'package:equatable/equatable.dart';
import 'package:quick_bite/data/models/food_item.dart';

class MenuState extends Equatable {
  final bool isLoading;
  final List<String> categories;
  final List<FoodItem> items;
  final String? selectedCategory;
  final String? error;

  const MenuState({
    this.isLoading = false,
    this.categories = const [],
    this.items = const [],
    this.selectedCategory,
    this.error,
  });

  MenuState copyWith({
    bool? isLoading,
    List<String>? categories,
    List<FoodItem>? items,
    String? selectedCategory,
    String? error,
  }) {
    return MenuState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, categories, items, selectedCategory, error];
}
