class CheckoutRequestModel {
  final List<CartItem> items;
  final String deliveryOption;
  final String paymentMethod;

  CheckoutRequestModel({
    required this.items,
    required this.deliveryOption,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryOption': deliveryOption,
      'paymentMethod': paymentMethod,
    };
  }
}

class CartItem {
  final int menuItemId;
  final int quantity;

  CartItem({
    required this.menuItemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'quantity': quantity,
    };
  }
}
