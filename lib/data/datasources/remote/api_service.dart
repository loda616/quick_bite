import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:quick_bite/core/constants/api_constants.dart';
import 'package:quick_bite/data/models/food_item.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.categories)
  Future<List<String>> getCategories();

  @GET(ApiConstants.items)
  Future<List<FoodItem>> getItemsByCategory(@Query('category') String category);
}