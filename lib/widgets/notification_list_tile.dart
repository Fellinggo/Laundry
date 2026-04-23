import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(dateLabel, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class NotificationIconBubble extends StatelessWidget {
  const NotificationIconBubble({
    super.key,
    required this.icon,
    required this.color,
    this.badge = false,
  });

  final IconData icon;
  final Color color;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        if (badge)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }
}
