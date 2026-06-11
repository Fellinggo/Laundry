import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationsController extends ChangeNotifier {
  int _currentFilter = NotificationFilter.all;
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  int get currentFilter => _currentFilter;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  static const String systemMessage =
      'Laundry sudah buka! kami siap melayani anda!';

  NotificationsController() {
    loadNotifications();
  }

  void changeFilter(int filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      notifyListeners();
    }
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final savedNotifications = prefs.getStringList('notifications') ?? [];

    debugPrint('🔔 Loading notifications: ${savedNotifications.length} items');

    _notifications = savedNotifications.map((message) {
      return NotificationModel.order(subtitle: message);
    }).toList();

    debugPrint('🔔 Notifications loaded: ${_notifications.length} items');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrderNotification(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList('notifications') ?? [];
    final newList = [message, ...currentList];

    if (newList.length > 50) {
      newList.removeRange(50, newList.length);
    }

    await prefs.setStringList('notifications', newList);
    await loadNotifications();
  }

  Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    await loadNotifications();
  }

  List<NotificationModel> getFilteredNotifications() {
    if (_currentFilter == NotificationFilter.all) {
      return _notifications;
    } else {
      return _notifications
          .where((n) => n.type == NotificationType.order)
          .toList();
    }
  }

  bool get hasOrderNotifications {
    return _notifications.any((n) => n.type == NotificationType.order);
  }

  int get orderNotificationsCount {
    return _notifications.where((n) => n.type == NotificationType.order).length;
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
