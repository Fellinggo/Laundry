import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class InfoKvRow extends StatelessWidget {
  const InfoKvRow({
    super.key,
    required this.label,
    required this.value,
    this.valueBold = false,
  });

  final String label;
  final String value;
  final bool valueBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(label, style: AppTextStyles.bodyMuted),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueBold
                  ? AppTextStyles.sectionTitle.copyWith(fontSize: 14)
                  : AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentDividerLabel extends StatelessWidget {
  const PaymentDividerLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderLight)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        ),
        const Expanded(child: Divider(color: AppColors.borderLight)),
      ],
    );
  }
}
