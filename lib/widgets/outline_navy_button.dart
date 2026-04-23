import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class OutlineNavyButton extends StatelessWidget {
  const OutlineNavyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
    this.expanded = true,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final bool expanded;
  final double height;

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: AppColors.white,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            border: Border.all(color: AppColors.primaryNavy, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: AppTextStyles.button.copyWith(color: AppColors.primaryNavy),
              ),
            ],
          ),
        ),
      ),
    );
    if (expanded) return SizedBox(width: double.infinity, child: child);
    return child;
  }
}
