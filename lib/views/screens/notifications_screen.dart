import 'package:flutter/material.dart';
import 'package:wushlaundry/controllers/notification_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/notification_filter_tab.dart';
import '../widgets/notification_list_tile.dart';
import '../widgets/notification_date_header.dart';
import '../../models/notification_model.dart';

class NotificationsScreen
    extends
        StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<
    NotificationsScreen
  >
  createState() => _NotificationsScreenState();
}

class _NotificationsScreenState
    extends
        State<
          NotificationsScreen
        > {
  late NotificationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotificationsController();
    _controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(
        () {},
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.pageBgCool,
      appBar: AppBar(
        backgroundColor: AppColors.pageBgCool,
        elevation: 0,
        leading: IconButton(
          onPressed: () => _controller.goBack(
            context,
          ),
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.primaryNavy,
            size: 28,
          ),
        ),
        title: Text(
          'Notifikasi',
          style: AppTextStyles.screenTitleNavy.copyWith(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_controller.notifications.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.textSecondary,
              ),
              onPressed: () => _confirmClearAll(
                context,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: 8,
            ),
            child: Row(
              children: [
                NotificationFilterTab(
                  icon: Icons.list_alt_rounded,
                  label: 'Semua',
                  selected:
                      _controller.currentFilter ==
                      NotificationFilter.all,
                  activeColor: AppColors.accentBlue,
                  onTap: () => _controller.changeFilter(
                    NotificationFilter.all,
                  ),
                ),
                NotificationFilterTab(
                  icon: Icons.assignment_outlined,
                  label: 'Pesanan',
                  selected:
                      _controller.currentFilter ==
                      NotificationFilter.orders,
                  activeColor: AppColors.skyTab,
                  onTap: () => _controller.changeFilter(
                    NotificationFilter.orders,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    children: _buildContent(),
                  ),
          ),
        ],
      ),
    );
  }

  List<
    Widget
  >
  _buildContent() {
    final filteredNotifications = _controller.getFilteredNotifications();
    final isOrdersOnly =
        _controller.currentFilter ==
        NotificationFilter.orders;

    if (isOrdersOnly &&
        filteredNotifications.isEmpty) {
      return [
        const NotificationDateHeader(
          title: 'Hari Ini',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Text(
            "Belum ada pesanan",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
            ),
          ),
        ),
      ];
    }

    final widgets =
        <
          Widget
        >[
          const NotificationDateHeader(
            title: 'Hari Ini',
          ),
        ];

    // System notification (only for "Semua" filter)
    if (!isOrdersOnly) {
      widgets.add(
        NotificationListTile(
          leading: const NotificationIconBubble(
            icon: Icons.settings_outlined,
            color: AppColors.skyTab,
          ),
          title: 'Sistem',
          subtitle: NotificationsController.systemMessage,
          dateLabel: 'Hari ini',
        ),
      );
      widgets.add(
        const SizedBox(
          height: 10,
        ),
      );
    }

    // Order notifications
    if (filteredNotifications.isNotEmpty) {
      for (var notification in filteredNotifications) {
        widgets.add(
          NotificationListTile(
            leading: NotificationIconBubble(
              icon: notification.icon,
              color: notification.iconColor,
            ),
            title: notification.title,
            subtitle: notification.subtitle,
            dateLabel: notification.dateLabel,
          ),
        );
        widgets.add(
          const SizedBox(
            height: 10,
          ),
        );
      }
    } else if (!isOrdersOnly) {
      // No order notifications for "Semua" filter
      // Just show empty state
    }

    return widgets;
  }

  void _confirmClearAll(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder:
          (
            ctx,
          ) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            title: const Text(
              'Hapus Semua Notifikasi',
            ),
            content: const Text(
              'Apakah Anda yakin ingin menghapus semua notifikasi?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(
                  ctx,
                ),
                child: const Text(
                  'Batal',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    ctx,
                  );
                  _controller.clearAllNotifications();
                },
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
