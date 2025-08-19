import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../stats/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  static const String _pushNotificationsKey = 'push_notifications';
  static const String _emailNotificationsKey = 'email_notifications';
  static const String _orderUpdatesKey = 'order_updates';
  static const String _promotionsKey = 'promotions';
  static const String _newItemsKey = 'new_items';

  final SharedPreferences _prefs;

  NotificationCubit(this._prefs) : super(const NotificationState()) {
    _loadNotificationSettings();
  }

  /// Load notification settings from SharedPreferences
  void _loadNotificationSettings() {
    try {
      final pushNotifications = _prefs.getBool(_pushNotificationsKey) ?? true;
      final emailNotifications = _prefs.getBool(_emailNotificationsKey) ?? true;
      final orderUpdates = _prefs.getBool(_orderUpdatesKey) ?? true;
      final promotions = _prefs.getBool(_promotionsKey) ?? false;
      final newItems = _prefs.getBool(_newItemsKey) ?? true;

      emit(NotificationState(
        pushNotifications: pushNotifications,
        emailNotifications: emailNotifications,
        orderUpdates: orderUpdates,
        promotions: promotions,
        newItems: newItems,
      ));
    } catch (e) {
      print('Error loading notification settings: $e');
      // Use default state
      emit(const NotificationState());
    }
  }

  /// Save a specific notification setting
  Future<void> _saveSetting(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      print('Error saving notification setting $key: $e');
    }
  }

  /// Toggle push notifications
  Future<void> togglePushNotifications(bool enabled) async {
    emit(state.copyWith(pushNotifications: enabled));
    await _saveSetting(_pushNotificationsKey, enabled);

    // TODO: Update push notification registration with Firebase/OneSignal
    print('Push notifications ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Toggle email notifications
  Future<void> toggleEmailNotifications(bool enabled) async {
    emit(state.copyWith(emailNotifications: enabled));
    await _saveSetting(_emailNotificationsKey, enabled);

    // TODO: Update email preferences on server
    print('Email notifications ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Toggle order update notifications
  Future<void> toggleOrderUpdates(bool enabled) async {
    emit(state.copyWith(orderUpdates: enabled));
    await _saveSetting(_orderUpdatesKey, enabled);
  }

  /// Toggle promotion notifications
  Future<void> togglePromotions(bool enabled) async {
    emit(state.copyWith(promotions: enabled));
    await _saveSetting(_promotionsKey, enabled);
  }

  /// Toggle new items notifications
  Future<void> toggleNewItems(bool enabled) async {
    emit(state.copyWith(newItems: enabled));
    await _saveSetting(_newItemsKey, enabled);
  }

  /// Enable all notifications
  Future<void> enableAll() async {
    const newState = NotificationState(
      pushNotifications: true,
      emailNotifications: true,
      orderUpdates: true,
      promotions: true,
      newItems: true,
    );

    emit(newState);

    // Save all settings
    await Future.wait([
      _saveSetting(_pushNotificationsKey, true),
      _saveSetting(_emailNotificationsKey, true),
      _saveSetting(_orderUpdatesKey, true),
      _saveSetting(_promotionsKey, true),
      _saveSetting(_newItemsKey, true),
    ]);
  }

  /// Disable all notifications
  Future<void> disableAll() async {
    const newState = NotificationState(
      pushNotifications: false,
      emailNotifications: false,
      orderUpdates: false,
      promotions: false,
      newItems: false,
    );

    emit(newState);

    // Save all settings
    await Future.wait([
      _saveSetting(_pushNotificationsKey, false),
      _saveSetting(_emailNotificationsKey, false),
      _saveSetting(_orderUpdatesKey, false),
      _saveSetting(_promotionsKey, false),
      _saveSetting(_newItemsKey, false),
    ]);
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    const defaultState = NotificationState();
    emit(defaultState);

    await Future.wait([
      _saveSetting(_pushNotificationsKey, defaultState.pushNotifications),
      _saveSetting(_emailNotificationsKey, defaultState.emailNotifications),
      _saveSetting(_orderUpdatesKey, defaultState.orderUpdates),
      _saveSetting(_promotionsKey, defaultState.promotions),
      _saveSetting(_newItemsKey, defaultState.newItems),
    ]);
  }

  /// Get notification summary for debugging
  Map<String, dynamic> getNotificationSummary() {
    return {
      'pushNotifications': state.pushNotifications,
      'emailNotifications': state.emailNotifications,
      'orderUpdates': state.orderUpdates,
      'promotions': state.promotions,
      'newItems': state.newItems,
      'hasAnyEnabled': state.hasAnyEnabled,
      'enabledCount': state.enabledCount,
    };
  }
}