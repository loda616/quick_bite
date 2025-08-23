import 'package:quick_bite/data/datasources/remote/checkout_api_service.dart';
import 'package:quick_bite/data/models/request/checkout_request_model.dart';
import 'package:quick_bite/domin/repository/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutApiService _checkoutApiService;

  CheckoutRepositoryImpl(this._checkoutApiService);

  @override
  Future<void> checkout(CheckoutRequestModel checkoutRequest) async {
    await _checkoutApiService.checkout(checkoutRequest);
  }
}
