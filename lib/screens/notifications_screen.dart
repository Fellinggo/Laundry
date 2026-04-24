import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/notification_filter_tab.dart';
import '../widgets/notification_list_tile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _filter = 0;

  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotif();
  }

  Future<void> _loadNotif() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBgCool,
      appBar: AppBar(
        backgroundColor: AppColors.pageBgCool,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.primaryNavy,
            size: 28,
          ),
        ),
        title: Text(
          'Notifikasi',
          style: AppTextStyles.screenTitleNavy.copyWith(fontSize: 20),
        ),
        centerTitle: true,
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
                  selected: _filter == 0,
                  activeColor: AppColors.accentBlue,
                  onTap: () => setState(() => _filter = 0),
                ),
                NotificationFilterTab(
                  icon: Icons.assignment_outlined,
                  label: 'Pesanan',
                  selected: _filter == 1,
                  activeColor: AppColors.skyTab,
                  onTap: () => setState(() => _filter = 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: _filter == 0 ? _buildAll() : _buildOrdersOnly(),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SEMUA NOTIF
  // =========================
  List<Widget> _buildAll() {
    return [
      _dateHeader('Hari Ini'),

      // notif sistem
      NotificationListTile(
        leading: const NotificationIconBubble(
          icon: Icons.settings_outlined,
          color: AppColors.skyTab,
        ),
        title: 'Sistem',
        subtitle: 'Laundry sudah buka! kami siap melayani anda!',
        dateLabel: 'Hari ini',
      ),

      const SizedBox(height: 10),

      // notif pesanan
      if (notifications.isEmpty)
        const Text("")
      else
        ...notifications.map((n) {
          return NotificationListTile(
            leading: const NotificationIconBubble(
              icon: Icons.local_laundry_service,
              color: AppColors.skyTab,
            ),
            title: 'Pesanan',
            subtitle: n,
            dateLabel: 'Baru saja',
          );
        }).toList(),
    ];
  }

  // =========================
  // KHUSUS PESANAN
  // =========================
  List<Widget> _buildOrdersOnly() {
    if (notifications.isEmpty) {
      return [
        _dateHeader('Hari Ini'),
        const Text("Belum ada pesanan"),
      ];
    }

    return [
      _dateHeader('Hari Ini'),
      ...notifications.map((n) {
        return NotificationListTile(
          leading: const NotificationIconBubble(
            icon: Icons.local_laundry_service,
            color: AppColors.skyTab,
          ),
          title: 'Pesanan',
          subtitle: n,
          dateLabel: 'Baru saja',
        );
      }).toList(),
    ];
  }

  Widget _dateHeader(String t) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        t,
        style: AppTextStyles.sectionTitle.copyWith(fontSize: 15),
      ),
    );
  }
}