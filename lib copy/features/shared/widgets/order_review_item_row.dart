import 'package:flutter/material.dart';

import '../../../Data1/models/order_review_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';


class OrderReviewItemRow extends StatelessWidget {
  final OrderItem item;
  final String Function(int) formatRupiah;

  const OrderReviewItemRow({
    super.key,
    required this.item,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item.image != null && item.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.image!,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 45,
                    height: 45,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.local_laundry_service, size: 20),
                  );
                },
              ),
            ),
          if (item.image != null && item.image!.isNotEmpty)
            const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${formatRupiah(item.price)} x ${item.qty}',
                  style: AppTextStyles.bodyMuted.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            formatRupiah(item.subtotal),
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }
}
