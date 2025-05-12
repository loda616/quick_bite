class OrderState {
  final List<Order> orders;

  const OrderState({required this.orders});
}

class Order {
  final String id;
  final String date;
  final List<OrderItem> items;
  final String status;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.status,
    required this.total,
  });
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}