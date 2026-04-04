import 'package:dio/dio.dart';
import 'lib/core/network/dio_client.dart';
import 'lib/data/datasources/remote/api_service.dart';
import 'lib/core/network/test_api.dart';

void main() async {
  await ManualApiTest.testLogin();
}
