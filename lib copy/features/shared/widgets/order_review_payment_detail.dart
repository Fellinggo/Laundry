import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'info_kv_row.dart';

class OrderReviewPaymentDetail extends StatelessWidget {
  final int serviceFee;
  final int deliveryFee;
  final int totalPayment;
  final String Function(int) formatRupiah;

  const OrderReviewPaymentDetail({
    super.key,
    required this.serviceFee,
    required this.deliveryFee,
    required this.totalPayment,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Pembayaran',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              InfoKvRow(
                label: 'Total Pesanan',
                value: formatRupiah(serviceFee),
              ),
              InfoKvRow(
                label: 'Biaya Pengiriman',
                value: formatRupiah(deliveryFee),
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: AppTextStyles.bodyMuted.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    formatRupiah(totalPayment),
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
