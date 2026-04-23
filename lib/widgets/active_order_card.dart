import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'step_progress_bar.dart';  // ✅ IMPORT SESUAI NAMA FILE ANDA

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({
    super.key,
    required this.statusTitle,
    required this.subtitle,
    this.badgeLabel = 'Diproses',
    this.currentStep = 0,
    this.totalPrice,
    this.empty = false,
    this.onTap,
  });

  final String statusTitle;
  final String subtitle;
  final String badgeLabel;
  final int currentStep;
  final String? totalPrice;
  final bool empty;
  final VoidCallback? onTap;

  static const double _cardHeight = 180;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: empty
                ? Center(
                    child: Text(
                      'Tidak ada pesanan aktif',
                      style: AppTextStyles.bodyMuted,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              statusTitle,
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildBadge(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              subtitle,
                              style: AppTextStyles.bodyMuted,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (totalPrice != null)
                            Text(
                              totalPrice!,
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 14,
                                color: AppColors.headerNavy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      OrderStepProgressBar(activeIndex: currentStep),  // ✅ NAMA CLASS OrderStepProgressBar
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badgeLabel,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}