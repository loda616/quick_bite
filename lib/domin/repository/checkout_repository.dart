import '../../data/models/request/checkout_request_model.dart';

abstract class CheckoutRepository {
  Future<void> checkout(CheckoutRequestModel checkoutRequest);
}
