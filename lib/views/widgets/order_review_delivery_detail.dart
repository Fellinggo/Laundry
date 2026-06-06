import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'info_kv_row.dart';

class OrderReviewDeliveryDetail
    extends
        StatelessWidget {
  final String pickupTime;
  final String deliveryTime;
  final String address;
  final VoidCallback onEdit;

  const OrderReviewDeliveryDetail({
    super.key,
    required this.pickupTime,
    required this.deliveryTime,
    required this.address,
    required this.onEdit,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Detail Pengiriman',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 16,
              ),
              label: Text(
                'Edit',
                style: AppTextStyles.bodyMuted.copyWith(
                  color: AppColors.actionBlue,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.all(
            16,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Column(
            children: [
              InfoKvRow(
                label: 'Waktu Pengambilan',
                value: pickupTime,
                valueBold: true,
              ),
              InfoKvRow(
                label: 'Waktu Pengiriman',
                value: deliveryTime,
                valueBold: true,
              ),
              InfoKvRow(
                label: 'Alamat Pengiriman',
                value: address,
                valueBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
