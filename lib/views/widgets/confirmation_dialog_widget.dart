import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ConfirmationDialogWidget
    extends
        StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final bool isDangerous;
  final VoidCallback onConfirm;

  const ConfirmationDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.isDangerous,
    required this.onConfirm,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.sectionTitle,
      ),
      content: Text(
        content,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
          ),
          child: Text(
            'Batal',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
            onConfirm();
          },
          child: Text(
            confirmText,
            style: TextStyle(
              color: isDangerous
                  ? AppColors.danger
                  : AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
