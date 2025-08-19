import 'package:equatable/equatable.dart';
import 'package:quick_bite/data/models/food_item.dart';
import '../../../data/models/category_model.dart';

class MenuState extends Equatable {
  final List<CategoryModel> categories;
  final List<FoodItem> allItems;
  final List<FoodItem> filteredItems;
  final int? selectedCategoryId;
  final bool isLoading;
  final bool isLoadingCategory;
  final String? errorMessage;

  const MenuState({
    this.categories = const [],
    this.allItems = const [],
    this.filteredItems = const [],
    this.selectedCategoryId,
    this.isLoading = false,
    this.isLoadingCategory = false,
    this.errorMessage,
  });

  MenuState copyWith({
    List<CategoryModel>? categories,
    List<FoodItem>? allItems,
    List<FoodItem>? filteredItems,
    int? selectedCategoryId,
    bool? isLoading,
    bool? isLoadingCategory,
    String? errorMessage,
    bool clearSelectedCategory = false,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategoryId: clearSelectedCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      isLoading: isLoading ?? this.isLoading,
      isLoadingCategory: isLoadingCategory ?? this.isLoadingCategory,
      errorMessage: errorMessage,
    );
  }

  /// Check if any data is loading
  bool get isAnyLoading => isLoading || isLoadingCategory;

  /// Check if we have categories loaded
  bool get hasCategories => categories.isNotEmpty;

  /// Check if we have items loaded
  bool get hasItems => allItems.isNotEmpty;

  /// Check if we have filtered items to show
  bool get hasFilteredItems => filteredItems.isNotEmpty;

  /// Check if we have any error
  bool get hasError => errorMessage != null;

  /// Get display items count
  int get displayItemsCount => filteredItems.length;

  /// Get categories count
  int get categoriesCount => categories.length;

  /// Check if showing all items (no category filter)
  bool get isShowingAllItems => selectedCategoryId == null;

  /// Get current category name (null if showing all)
  String? get selectedCategoryName {
    if (selectedCategoryId == null) return null;

    try {
      return categories
          .firstWhere((cat) => cat.id == selectedCategoryId)
          .name;
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    categories,
    allItems,
    filteredItems,
    selectedCategoryId,
    isLoading,
    isLoadingCategory,
    errorMessage,
  ];

  @override
  String toString() {
    return '''MenuState(
  categories: ${categories.length},
  allItems: ${allItems.length},
  filteredItems: ${filteredItems.length},
  selectedCategoryId: $selectedCategoryId,
  isLoading: $isLoading,
  isLoadingCategory: $isLoadingCategory,
  hasError: $hasError,
)''';
  }
}