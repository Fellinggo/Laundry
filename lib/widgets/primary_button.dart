import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = AppColors.primaryNavy,
    this.foregroundColor = AppColors.white,
    this.expanded = true,
    this.height = 52,
    this.borderRadius = AppSpacing.buttonRadius,
    this.leading,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool expanded;
  final double height;
  final double borderRadius;
  final Widget? leading;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTextStyles.button.copyWith(color: foregroundColor),
              ),
            ],
          );

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: onPressed == null && !loading
                ? backgroundColor.withValues(alpha: 0.5)
                : backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(child: child),
        ),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
