import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NotificationFilterTab extends StatelessWidget {
  const NotificationFilterTab({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.activeColor,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final c = selected ? (activeColor ?? AppColors.skyTab) : AppColors.textMuted;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: c),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: c,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
