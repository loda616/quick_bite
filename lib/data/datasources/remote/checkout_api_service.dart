import 'package:dio/dio.dart';
import 'package:quick_bite/data/datasources/local/secure_storage_service.dart';
import 'package:quick_bite/data/models/request/checkout_request_model.dart';

class CheckoutApiService {
  final Dio _dio;
  final SecureStorageService _secureStorageService;
  final String _baseUrl;

  CheckoutApiService(this._dio, this._secureStorageService, {String? baseUrl})
      : _baseUrl = baseUrl ?? "http://hydra.runasp.net/";

  Future<void> checkout(CheckoutRequestModel checkoutRequest) async {
    try {
      print('=== API SERVICE: CHECKOUT REQUEST ===');
      print('URL: ${_baseUrl}api/Checkout/checkout');
      print('Data: ${checkoutRequest.toJson()}');

      final token = await _secureStorageService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      await _dio.post(
        '${_baseUrl}api/Checkout/checkout',
        data: checkoutRequest.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('✓ Checkout API call successful');
    } on DioError catch (e) {
      print('❌ Checkout API call failed: $e');
      if (e.response != null) {
        print('Error response: ${e.response!.data}');
        throw Exception('Server error: ${e.response!.statusCode}');
      } else {
        print('Error sending request: $e');
        throw Exception('Network error');
      }
    } catch (e) {
      print('❌ Unexpected error during checkout: $e');
      rethrow;
    }
  }
}
