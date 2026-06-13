import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class SettingsTileWidget
    extends
        StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final bool danger;
  final VoidCallback? onTap;

  const SettingsTileWidget({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final color = danger
        ? AppColors.danger
        : AppColors.headerNavy;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing !=
              null)
            Text(
              trailing!,
              style: AppTextStyles.bodyMuted,
            ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
