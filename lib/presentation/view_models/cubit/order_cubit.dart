import 'package:flutter_bloc/flutter_bloc.dart';
import '../stats/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState(orders: []));

  void addOrder(Order order) {
    final orders = List<Order>.from(state.orders);
    orders.insert(0, order);
    emit(OrderState(orders: orders));
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final orders = List<Order>.from(state.orders);
    final orderIndex = orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      final updatedOrder = Order(
        id: orders[orderIndex].id,
        date: orders[orderIndex].date,
        items: orders[orderIndex].items,
        status: newStatus,
        total: orders[orderIndex].total,
      );
      orders[orderIndex] = updatedOrder;
      emit(OrderState(orders: orders));
    }
  }
}