import 'package:dio/dio.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio();

    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ));

    return dio;
  }
}
