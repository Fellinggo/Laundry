import 'package:flutter/material.dart';

class AppNotification {
  final String title;
  final String message;

  AppNotification({required this.title, required this.message});
}

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;

  void loadNotifications() {
    _notifications = [
      AppNotification(title: "Promo", message: "Diskon 20%"),
      AppNotification(title: "Order", message: "Pesanan selesai"),
    ];
    notifyListeners();
  }
}