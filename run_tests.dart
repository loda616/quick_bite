import 'lib/data/datasources/test api/menu_api_test.dart';

void main() async {
  await MenuApiTest.testAllMenuApis();
  await MenuApiTest.testIndividualApis();
}
