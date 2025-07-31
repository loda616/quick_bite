import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/menu_item_model.dart';
import '../../models/category_model.dart';

part 'menu_api_service.g.dart';

@RestApi(baseUrl: "http://hydra.runasp.net/")
abstract class MenuApiService {
  factory MenuApiService(Dio dio, {String? baseUrl}) = _MenuApiService;

  /// Get all menu items
  @GET("api/Menu/Items")
  Future<List<MenuItemModel>> getAllItems();

  /// Get all categories
  @GET("api/Menu/Category")
  Future<List<CategoryModel>> getAllCategories();

  /// Get items by category ID
  @GET("api/Menu/{categoryId}")
  Future<List<MenuItemModel>> getItemsByCategory(@Path("categoryId") int categoryId);
}