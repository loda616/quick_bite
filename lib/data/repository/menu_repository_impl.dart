import 'package:dio/dio.dart';
import 'package:quick_bite/data/models/food_item.dart';
import '../datasources/remote/menu_api_service.dart';
import '../models/menu_item_model.dart';
import '../models/category_model.dart';
import '../../domin/repository/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuApiService _menuApiService;

  // Cache for better performance
  List<MenuItemModel>? _allItemsCache;
  List<CategoryModel>? _categoriesCache;
  final Map<int, List<MenuItemModel>> _categoryItemsCache = {};

  MenuRepositoryImpl(this._menuApiService);

  @override
  Future<List<FoodItem>> getAllItems() async {
    try {
      print('=== FETCHING ALL MENU ITEMS ===');

      // Use cache if available
      if (_allItemsCache != null) {
        print('✓ Using cached items (${_allItemsCache!.length} items)');
        return _allItemsCache!.map((item) => item.toFoodItem()).toList();
      }

      final items = await _menuApiService.getAllItems();
      _allItemsCache = items; // Cache the results

      print('✓ Fetched ${items.length} items from API');
      return items.map((item) => item.toFoodItem()).toList();

    } on DioException catch (dioError) {
      print('=== MENU API ERROR ===');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');

      switch (dioError.response?.statusCode) {
        case 404:
          throw Exception('Menu items not found');
        case 500:
          throw Exception('Server error while fetching menu items');
        default:
          throw Exception('Failed to fetch menu items: ${dioError.message}');
      }
    } catch (e) {
      print('=== GENERAL ERROR ===');
      print('Error: $e');
      throw Exception('Failed to fetch menu items: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      print('=== FETCHING ALL CATEGORIES ===');

      // Use cache if available
      if (_categoriesCache != null) {
        print('✓ Using cached categories (${_categoriesCache!.length} categories)');
        return _categoriesCache!;
      }

      final categories = await _menuApiService.getAllCategories();
      _categoriesCache = categories; // Cache the results

      print('✓ Fetched ${categories.length} categories from API');
      return categories;

    } on DioException catch (dioError) {
      print('=== CATEGORY API ERROR ===');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');

      switch (dioError.response?.statusCode) {
        case 404:
          throw Exception('Categories not found');
        case 500:
          throw Exception('Server error while fetching categories');
        default:
          throw Exception('Failed to fetch categories: ${dioError.message}');
      }
    } catch (e) {
      print('=== GENERAL ERROR ===');
      print('Error: $e');
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<List<FoodItem>> getItemsByCategory(int categoryId) async {
    try {
      print('=== FETCHING ITEMS FOR CATEGORY $categoryId ===');

      // Use cache if available
      if (_categoryItemsCache.containsKey(categoryId)) {
        print('✓ Using cached items for category $categoryId');
        return _categoryItemsCache[categoryId]!.map((item) => item.toFoodItem()).toList();
      }

      final items = await _menuApiService.getItemsByCategory(categoryId);
      _categoryItemsCache[categoryId] = items; // Cache the results

      print('✓ Fetched ${items.length} items for category $categoryId from API');
      return items.map((item) => item.toFoodItem()).toList();

    } on DioException catch (dioError) {
      print('=== CATEGORY ITEMS API ERROR ===');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');

      switch (dioError.response?.statusCode) {
        case 404:
          throw Exception('No items found for this category');
        case 500:
          throw Exception('Server error while fetching category items');
        default:
          throw Exception('Failed to fetch category items: ${dioError.message}');
      }
    } catch (e) {
      print('=== GENERAL ERROR ===');
      print('Error: $e');
      throw Exception('Failed to fetch category items: ${e.toString()}');
    }
  }

  @override
  Future<FoodItem?> getItemById(String id) async {
    try {
      print('=== FETCHING ITEM BY ID: $id ===');

      // First try to find in cache
      if (_allItemsCache != null) {
        final cachedItem = _allItemsCache!
            .where((item) => item.id.toString() == id)
            .firstOrNull;
        if (cachedItem != null) {
          print('✓ Found item in cache');
          return cachedItem.toFoodItem();
        }
      }

      // If not in cache, fetch all items and search
      final allItems = await getAllItems();
      final item = allItems.where((item) => item.id == id).firstOrNull;

      if (item != null) {
        print('✓ Found item by ID: ${item.name}');
      } else {
        print('❌ Item not found with ID: $id');
      }

      return item;

    } catch (e) {
      print('=== ERROR FETCHING ITEM BY ID ===');
      print('Error: $e');
      return null;
    }
  }

  @override
  Future<List<FoodItem>> searchMenuItems(String query) async {
    try {
      print('=== SEARCHING FOR: $query ===');
      final items = await _menuApiService.search(query);
      print('✓ Found ${items.length} items from search');
      return items.map((item) => item.toFoodItem()).toList();
    } on DioException catch (dioError) {
      print('=== SEARCH API ERROR ===');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Response Data: ${dioError.response?.data}');
      throw Exception('Failed to search for items: ${dioError.message}');
    } catch (e) {
      print('=== GENERAL SEARCH ERROR ===');
      print('Error: $e');
      throw Exception('Failed to search for items: ${e.toString()}');
    }
  }

  /// Clear all caches (useful for refresh)
  void clearCache() {
    print('=== CLEARING MENU CACHE ===');
    _allItemsCache = null;
    _categoriesCache = null;
    _categoryItemsCache.clear();
  }

  /// Refresh all data (clear cache and fetch fresh)
  Future<void> refreshData() async {
    clearCache();
    await Future.wait([
      getAllItems(),
      getAllCategories(),
    ]);
  }
}