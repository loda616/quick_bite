import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/food_item.dart';
import '../../../data/models/category_model.dart';
import '../../../domin/repository/menu_repository.dart';
import '../stats/menu_stat.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _menuRepository;

  MenuCubit(this._menuRepository) : super(const MenuState());

  /// Load all initial data (categories and all items)
  Future<void> loadInitialData() async {
    print('=== LOADING INITIAL MENU DATA ===');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Load categories and all items in parallel
      final results = await Future.wait([
        _menuRepository.getAllCategories(),
        _menuRepository.getAllItems(),
      ]);

      final categories = results[0] as List<CategoryModel>;
      final allItems = results[1] as List<FoodItem>;

      print('✓ Loaded ${categories.length} categories and ${allItems.length} items');

      emit(state.copyWith(
        categories: categories,
        allItems: allItems,
        filteredItems: allItems, // Show all items initially
        selectedCategoryId: null,
        isLoading: false,
      ));

    } catch (e) {
      print('❌ Failed to load initial data: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Select a category and filter items
  Future<void> selectCategory(CategoryModel? category) async {
    // Clear any search when selecting category
    if (category == null) {
      // Show all items
      print('=== SHOWING ALL ITEMS ===');
      emit(state.copyWith(
        filteredItems: state.allItems,
        isLoadingCategory: false,
        errorMessage: null,
        clearSelectedCategory: true,
      ));
      return;
    }

    // Check if this category is already selected
    if (state.selectedCategoryId == category.id && !state.isLoadingCategory) {
      print('=== CATEGORY ${category.name} ALREADY SELECTED ===');
      return;
    }

    print('=== SELECTING CATEGORY: ${category.name} (ID: ${category.id}) ===');
    emit(state.copyWith(
      selectedCategoryId: category.id,
      isLoadingCategory: true,
      errorMessage: null,
    ));

    try {
      final items = await _menuRepository.getItemsByCategory(category.id);

      print('✓ Loaded ${items.length} items for category ${category.name}');

      emit(state.copyWith(
        filteredItems: items,
        isLoadingCategory: false,
      ));

    } catch (e) {
      print('❌ Failed to load category items: $e');
      emit(state.copyWith(
        isLoadingCategory: false,
        errorMessage: e.toString(),
        // Fallback to showing all items if category load fails
        filteredItems: state.allItems,
        clearSelectedCategory: true,
      ));
    }
  }

  /// Search items by name
  Future<void> searchItems(String query) async {
    print('=== SEARCHING ITEMS: "$query" ===');

    if (query.trim().isEmpty) {
      // Reset to current category filter or all items
      final currentCategory = selectedCategory;
      if (currentCategory != null) {
        selectCategory(currentCategory);
      } else {
        emit(state.copyWith(
          filteredItems: state.allItems,
          errorMessage: null,
        ));
      }
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final searchResults = await _menuRepository.searchMenuItems(query);
      print('✓ Found ${searchResults.length} items matching "$query"');
      emit(state.copyWith(
        filteredItems: searchResults,
        isLoading: false,
      ));
    } catch (e) {
      print('❌ Failed to search for items: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Get item by ID
  Future<FoodItem?> getItemById(String id) async {
    try {
      return await _menuRepository.getItemById(id);
    } catch (e) {
      print('❌ Failed to get item by ID: $e');
      return null;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    print('=== REFRESHING MENU DATA ===');
    await loadInitialData();
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  /// Get currently selected category
  CategoryModel? get selectedCategory {
    if (state.selectedCategoryId == null) return null;

    return state.categories
        .where((cat) => cat.id == state.selectedCategoryId)
        .firstOrNull;
  }

  /// Check if a category is selected
  bool isCategorySelected(CategoryModel category) {
    return state.selectedCategoryId == category.id;
  }

  /// Get filtered items count
  int get filteredItemsCount => state.filteredItems.length;

  /// Get categories count
  int get categoriesCount => state.categories.length;

  /// Check if currently showing all items
  bool get isShowingAllItems => state.selectedCategoryId == null;
}