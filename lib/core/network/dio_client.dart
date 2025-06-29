import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class DioClient {
  static Dio getDio() {
    final dio = Dio();

    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Add this to help with debugging
      validateStatus: (status) {
        // Allow all status codes so we can see the actual response
        return status! < 600;
      },
    );

    // Enhanced logging interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        developer.log('🚀 REQUEST [${options.method}] => PATH: ${options.path}');
        developer.log('🌐 FULL URL: ${options.uri}');
        developer.log('📝 Headers: ${options.headers}');
        developer.log('📦 Data: ${options.data}');
        developer.log('🔗 Query Parameters: ${options.queryParameters}');
        developer.log('⚙️ Content-Type: ${options.contentType}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        developer.log('✅ RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
        developer.log('📦 Response Data: ${response.data}');
        developer.log('📝 Response Headers: ${response.headers}');
        developer.log('🔍 Response Type: ${response.data.runtimeType}');
        handler.next(response);
      },
      onError: (error, handler) {
        developer.log('❌ ERROR [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
        developer.log('💥 Error Message: ${error.message}');
        developer.log('🔍 Error Type: ${error.type}');
        developer.log('📦 Error Response Data: ${error.response?.data}');
        developer.log('📝 Error Response Headers: ${error.response?.headers}');
        developer.log('📄 Request Data: ${error.requestOptions.data}');
        developer.log('📝 Request Headers: ${error.requestOptions.headers}');

        // Log different types of errors
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            developer.log('⏰ Connection Timeout Error');
            break;
          case DioExceptionType.sendTimeout:
            developer.log('📤 Send Timeout Error');
            break;
          case DioExceptionType.receiveTimeout:
            developer.log('📥 Receive Timeout Error');
            break;
          case DioExceptionType.badResponse:
            developer.log('🚫 Bad Response Error - Status: ${error.response?.statusCode}');
            developer.log('🚫 Response body: ${error.response?.data}');
            break;
          case DioExceptionType.cancel:
            developer.log('🛑 Request Cancelled');
            break;
          case DioExceptionType.connectionError:
            developer.log('🌐 Connection Error - Check your internet connection');
            break;
          case DioExceptionType.unknown:
            developer.log('❓ Unknown Error');
            break;
          default:
            developer.log('🔄 Other Error Type: ${error.type}');
        }

        handler.next(error);
      },
    ));

    return dio;
  }
}