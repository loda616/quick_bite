
import '../../../core/network/dio_client.dart';
import '../../repository/menu_repository_impl.dart';
import '../remote/menu_api_service.dart';

class MenuApiTest {
  static Future<void> testAllMenuApis() async {
    print('=== TESTING MENU APIS ===');

    try {
      final dio = DioClient.getDio();
      final menuApiService = MenuApiService(dio);
      final menuRepository = MenuRepositoryImpl(menuApiService);

      // Test 1: Get all categories
      print('\n1. Testing getAllCategories...');
      final categories = await menuRepository.getAllCategories();
      print('✅ Categories loaded: ${categories.length}');
      for (final category in categories) {
        print('   - ${category.name} (ID: ${category.id})');
      }

      // Test 2: Get all items
      print('\n2. Testing getAllItems...');
      final allItems = await menuRepository.getAllItems();
      print('✅ All items loaded: ${allItems.length}');
      for (final item in allItems.take(3)) { // Show first 3 items
        print('   - ${item.name} - \$${item.price} (${item.category})');
      }

      // Test 3: Get items by category
      if (categories.isNotEmpty) {
        final firstCategory = categories.first;
        print('\n3. Testing getItemsByCategory for "${firstCategory.name}"...');
        final categoryItems = await menuRepository.getItemsByCategory(firstCategory.id);
        print('✅ Items in ${firstCategory.name}: ${categoryItems.length}');
        for (final item in categoryItems) {
          print('   - ${item.name} - \${item.price}');
        }
      }

      // Test 4: Get item by ID
      if (allItems.isNotEmpty) {
        final firstItem = allItems.first;
        print('\n4. Testing getItemById for "${firstItem.name}"...');
        final foundItem = await menuRepository.getItemById(firstItem.id.toString());
        if (foundItem != null) {
          print('✅ Item found: ${foundItem.name}');
          print('   Description: ${foundItem.description}');
          print('   Price: \${foundItem.price}');
          print('   Category: ${foundItem.category}');
          print('   Rating: ${foundItem.rating}');
          print('   Customizations: ${foundItem.customizationOptions}');
        } else {
          print('❌ Item not found');
        }
      }

      print('\n🎉 All Menu API tests completed successfully!');

    } catch (e, stackTrace) {
      print('\n❌ Menu API test failed: $e');
      print('Stack trace: $stackTrace');
    }
  }

  static Future<void> testIndividualApis() async {
    print('=== TESTING INDIVIDUAL MENU APIS ===');

    final dio = DioClient.getDio();
    final menuApiService = MenuApiService(dio);

    try {
      // Test direct API calls
      print('\n1. Direct API: Get all items...');
      final items = await menuApiService.getAllItems();
      print('✅ Raw API items: ${items.length}');

      print('\n2. Direct API: Get categories...');
      final categories = await menuApiService.getAllCategories();
      print('✅ Raw API categories: ${categories.length}');

      if (categories.isNotEmpty) {
        print('\n3. Direct API: Get items by category...');
        final categoryItems = await menuApiService.getItemsByCategory(categories.first.id);
        print('✅ Raw API category items: ${categoryItems.length}');
      }

    } catch (e) {
      print('❌ Direct API test failed: $e');
    }
  }
}