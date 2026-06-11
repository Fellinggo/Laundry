import 'package:flutter/material.dart';
import 'package:wushlaundry/constants/app_colors.dart';

class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String dateLabel;
  final NotificationType type;
  final IconData icon;
  final Color iconColor;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.createdAt,
  });

  factory NotificationModel.system({required String subtitle}) {
    return NotificationModel(
      id: 'system_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Sistem',
      subtitle: subtitle,
      dateLabel: 'Hari ini',
      type: NotificationType.system,
      icon: Icons.settings_outlined,
      iconColor: AppColors.skyTab,
      createdAt: DateTime.now(),
    );
  }

  factory NotificationModel.order({required String subtitle}) {
    return NotificationModel(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Pesanan',
      subtitle: subtitle,
      dateLabel: 'Baru saja',
      type: NotificationType.order,
      icon: Icons.local_laundry_service,
      iconColor: AppColors.skyTab,
      createdAt: DateTime.now(),
    );
  }

  factory NotificationModel.fromString(String message, NotificationType type) {
    return NotificationModel(
      id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
      title: type == NotificationType.system ? 'Sistem' : 'Pesanan',
      subtitle: message,
      dateLabel: 'Baru saja',
      type: type,
      icon: type == NotificationType.system
          ? Icons.settings_outlined
          : Icons.local_laundry_service,
      iconColor: AppColors.skyTab,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'dateLabel': dateLabel,
      'type': type.name,
      'icon': icon.codePoint,
      'iconColor': iconColor.value,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum NotificationType { system, order }

class NotificationFilter {
  static const int all = 0;
  static const int orders = 1;
}
