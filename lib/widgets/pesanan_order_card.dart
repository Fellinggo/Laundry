import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class PesananOrderCard extends StatelessWidget {
  const PesananOrderCard({
    super.key,
    required this.customerName,
    required this.orderId,
    required this.dateLabel,
    required this.serviceTitle,
    required this.priceLabel,
    required this.qty,
    required this.shippingLabel,
    required this.totalLabel,
    this.highlightBorder = false,
  });

  final String customerName;
  final String orderId;
  final String dateLabel;
  final String serviceTitle;
  final String priceLabel;
  final int qty;
  final String shippingLabel;
  final String totalLabel;
  final bool highlightBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: highlightBorder ? AppColors.actionBlue : AppColors.borderLight,
          width: highlightBorder ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.iconCircle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_none, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('Pesanan', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Spacer(),
              Text(dateLabel, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 12),
          Text(customerName, style: AppTextStyles.sectionTitle.copyWith(color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(orderId, style: AppTextStyles.body),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: AppColors.serviceCardTint,
                    child: const Icon(Icons.local_laundry_service, color: AppColors.actionBlue),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceTitle, style: AppTextStyles.sectionTitle.copyWith(fontSize: 14)),
                      Text(priceLabel, style: AppTextStyles.bodyMuted),
                    ],
                  ),
                ),
                Text('$qty', style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(shippingLabel, style: AppTextStyles.caption),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Text('Total:', style: AppTextStyles.sectionTitle.copyWith(fontSize: 15)),
              const Spacer(),
              Text(totalLabel, style: AppTextStyles.sectionTitle.copyWith(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accentBlue),
              label: Text('Lihat lebih banyak', style: AppTextStyles.link),
            ),
          ),
        ],
      ),
    );
  }
}
