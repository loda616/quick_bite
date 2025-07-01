import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool orderUpdates;
  final bool promotions;
  final bool newItems;

  const NotificationState({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.orderUpdates = true,
    this.promotions = false,
    this.newItems = true,
  });

  NotificationState copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? orderUpdates,
    bool? promotions,
    bool? newItems,
  }) {
    return NotificationState(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotions: promotions ?? this.promotions,
      newItems: newItems ?? this.newItems,
    );
  }

  /// Check if any notifications are enabled
  bool get hasAnyEnabled =>
      pushNotifications || emailNotifications || orderUpdates || promotions || newItems;

  /// Get count of enabled notifications
  int get enabledCount {
    int count = 0;
    if (pushNotifications) count++;
    if (emailNotifications) count++;
    if (orderUpdates) count++;
    if (promotions) count++;
    if (newItems) count++;
    return count;
  }

  @override
  List<Object?> get props => [
    pushNotifications,
    emailNotifications,
    orderUpdates,
    promotions,
    newItems,
  ];

  @override
  String toString() {
    return 'NotificationState(pushNotifications: $pushNotifications, emailNotifications: $emailNotifications, orderUpdates: $orderUpdates, promotions: $promotions, newItems: $newItems)';
  }
}