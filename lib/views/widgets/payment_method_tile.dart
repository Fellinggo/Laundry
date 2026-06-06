import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_styles.dart';

class PaymentMethodTile
    extends
        StatelessWidget {
  final String title;
  final bool connected;
  final Widget? leading;
  final VoidCallback? onTap;

  const PaymentMethodTile({
    super.key,
    required this.title,
    this.connected = false,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppSpacing.cardRadius,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              AppSpacing.cardRadius,
            ),
            border: Border.all(
              color: AppColors.borderLight,
            ),
          ),
          child: Row(
            children: [
              if (leading !=
                  null) ...[
                leading!,
                const SizedBox(
                  width: 12,
                ),
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
              if (connected)
                Row(
                  children: [
                    Text(
                      'Terhubung',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
