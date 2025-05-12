import 'food_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  readyForPickup,
  outForDelivery,
  delivered,
  cancelled
}

class OrderItem {
  final FoodItem item;
  final int quantity;
  final List<String> customizations;
  final double itemTotal;

  OrderItem({
    required this.item,
    required this.quantity,
    this.customizations = const [],
  }) : itemTotal = item.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'quantity': quantity,
      'customizations': customizations,
      'itemTotal': itemTotal,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      item: FoodItem.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      customizations: (json['customizations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final DateTime orderTime;
  final OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String? deliveryAddress;
  final String? notes;
  final DateTime? estimatedDeliveryTime;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.orderTime,
    this.status = OrderStatus.pending,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    this.deliveryAddress,
    this.notes,
    this.estimatedDeliveryTime,
  });

  factory Order.create({
    required String userId,
    required List<OrderItem> items,
    String? deliveryAddress,
    String? notes,
  }) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.itemTotal,
    );
    const deliveryFee = 5.0; // Example fixed delivery fee
    final tax = subtotal * 0.1; // Example 10% tax rate

    return Order(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Example ID generation
      userId: userId,
      items: items,
      orderTime: DateTime.now(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: subtotal + deliveryFee + tax,
      deliveryAddress: deliveryAddress,
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'orderTime': orderTime.toIso8601String(),
      'status': status.toString(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      orderTime: DateTime.parse(json['orderTime'] as String),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String?,
      notes: json['notes'] as String?,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'] as String)
          : null,
    );
  }

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    DateTime? orderTime,
    OrderStatus? status,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    String? deliveryAddress,
    String? notes,
    DateTime? estimatedDeliveryTime,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      orderTime: orderTime ?? this.orderTime,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }
}
