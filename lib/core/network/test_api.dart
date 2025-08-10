import 'package:dio/dio.dart';

import 'dio_client.dart';

class ManualApiTest {
  static Future<void> testLogin() async {
    final dio = DioClient.getDio();

    try {
      print('=== MANUAL API TEST ===');

      final response = await dio.post(
        'http://hydra.runasp.net/api/Account/Login',
        data: {
          "email": "mohamed@gmail.com",
          "password": "Fouad@2463187"
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✅ Manual API test successful!');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('Data type: ${response.data.runtimeType}');

    } catch (e) {
      print('❌ Manual API test failed: $e');
      if (e is DioException) {
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
        print('Request URL: ${e.requestOptions.uri}');
        print('Request Data: ${e.requestOptions.data}');
        print('Request Headers: ${e.requestOptions.headers}');
      }
    }
  }
}
