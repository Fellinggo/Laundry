import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class RoundedWhitePanel
    extends
        StatelessWidget {
  const RoundedWhitePanel({
    super.key,
    required this.child,
    this.topRadius = 30,
    this.padding,
  });

  final Widget child;
  final double topRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            topRadius,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 20,
            offset: const Offset(
              0,
              -4,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            topRadius,
          ),
        ),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.all(
                AppSpacing.xl,
              ),
          child: child,
        ),
      ),
    );
  }
}
