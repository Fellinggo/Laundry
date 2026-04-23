import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ServiceSummaryTile extends StatelessWidget {
  const ServiceSummaryTile({
    super.key,
    required this.title,
    required this.priceLabel,
    this.onEdit,
  });

  final String title;
  final String priceLabel;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 56,
            height: 56,
            color: AppColors.serviceCardTint,
            child: const Icon(Icons.local_laundry_service, color: AppColors.actionBlue, size: 32),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 15)),
              const SizedBox(height: 4),
              Text(priceLabel, style: AppTextStyles.bodyMuted),
            ],
          ),
        ),
        if (onEdit != null)
          TextButton(
            onPressed: onEdit,
            child: Text('Edit', style: AppTextStyles.link),
          ),
      ],
    );
  }
}
