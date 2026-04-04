import '../../data/models/food_item.dart';
import '../../data/models/category_model.dart';

abstract class MenuRepository {
  Future<List<FoodItem>> getAllItems();
  Future<List<CategoryModel>> getAllCategories();
  Future<List<FoodItem>> getItemsByCategory(int categoryId);
  Future<FoodItem?> getItemById(String id);
  Future<List<FoodItem>> searchMenuItems(String query);
}