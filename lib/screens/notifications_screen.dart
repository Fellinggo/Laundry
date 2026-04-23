import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBgCool,
      appBar: AppBar(
        backgroundColor: AppColors.pageBgCool,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: AppColors.primaryNavy, size: 28),
        ),
        title: Text('Notifikasi', style: AppTextStyles.screenTitleNavy.copyWith(fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 8),
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

  List<Widget> _buildAll() {
    return [
      _dateHeader('Hari Ini'),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.chat_bubble_outline, color: AppColors.actionBlue, badge: true),
        title: 'Konfirmasi Order',
        subtitle: 'Pesanan #001156 sudah diproses',
        dateLabel: '18 juli 2025',
      ),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.chat_bubble_outline, color: AppColors.actionBlue, badge: true),
        title: 'Konfirmasi Order',
        subtitle: 'Pesanan #001156 telah dikonfirmasi',
        dateLabel: '18 juli 2025',
      ),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.settings_outlined, color: AppColors.skyTab),
        title: 'Sistem',
        subtitle: 'Laundry sudah buka! kami siap melayani anda!',
        dateLabel: '18 juli 2025',
      ),
      _dateHeader('Kemarin'),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.settings_outlined, color: AppColors.skyTab),
        title: 'Sistem',
        subtitle: 'Laundry sudah tutup! kami beroperasi kembali besok, terimakasih!',
        dateLabel: '17 juli 2025',
      ),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.chat_bubble_outline, color: AppColors.actionBlue),
        title: 'Konfirmasi Order',
        subtitle: 'Pesanan #001188 sudah selesai',
        dateLabel: '17 juli 2025',
      ),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.campaign_outlined, color: AppColors.textDark),
        title: 'Reminder',
        subtitle: 'Jangan lupa pilih pewangi favorit anda!',
        dateLabel: '17 juli 2025',
      ),
    ];
  }

  List<Widget> _buildOrdersOnly() {
    return [
      _dateHeader('Hari Ini'),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.chat_bubble_outline, color: AppColors.actionBlue, badge: true),
        title: 'Konfirmasi Order',
        subtitle: 'Pesanan #001156 sudah diproses',
        dateLabel: '18 juli 2025',
      ),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.chat_bubble_outline, color: AppColors.actionBlue, badge: true),
        title: 'Konfirmasi Order',
        subtitle: 'Pesanan #001156 telah dikonfirmasi',
        dateLabel: '18 juli 2025',
      ),
      _dateHeader('Kemarin'),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.chat_bubble_outline, color: AppColors.actionBlue),
        title: 'Konfirmasi Order',
        subtitle: 'Pesanan #001188 sudah selesai',
        dateLabel: '17 juli 2025',
      ),
      NotificationListTile(
        leading: const NotificationIconBubble(icon: Icons.chat_bubble_outline, color: AppColors.actionBlue),
        title: 'Konfirmasi Order',
        subtitle: 'Pesanan #001188 sedang di proses',
        dateLabel: '16 juli 2025',
      ),
    ];
  }

  Widget _dateHeader(String t) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(t, style: AppTextStyles.sectionTitle.copyWith(fontSize: 15)),
    );
  }
}
