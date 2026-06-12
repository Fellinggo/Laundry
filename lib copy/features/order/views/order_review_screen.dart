import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data1/models/order/order_review_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../shared/widgets/navy_app_bar.dart';
import '../../shared/widgets/order_review_service_summary.dart';
import '../../shared/widgets/rounded_white_panel.dart';
import '../controllers/order_review_controller.dart';


class OrderReviewScreen extends StatelessWidget {
  const OrderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengekstrak arguments dari rute navigasi
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final reviewData = OrderReviewData.fromArguments(args);

    return ChangeNotifierProvider<OrderReviewController>(
      create: (_) => OrderReviewController(data: reviewData),
      child: Consumer<OrderReviewController>(
        builder: (context, controller, child) {
          final data = controller.orderData;

          return Scaffold(
            backgroundColor: AppColors.headerNavy,
            appBar: NavyBackAppBar(
              title: 'Tinjau Pesanan',
              onBack: () => controller.goBack(context),
            ),
            body: Column(
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: RoundedWhitePanel(
                    topRadius: AppSpacing.sheetTopRadius,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.xl,
                      AppSpacing.xl,
                      0,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: const _NoOverscrollBehavior(),
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ringkasan Pesanan',
                                    style: AppTextStyles.sectionTitle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Ringkasan Layanan
                                  OrderReviewServiceSummary(
                                    data: data,
                                    formatRupiah: controller.formatRupiah,
                                  ),
                                  const SizedBox(height: 24),

                                  // Detail Pengiriman
                                  _buildDeliveryDetail(
                                    context,
                                    data,
                                    controller,
                                  ),
                                  const SizedBox(height: 24),

                                  // Detail Pembayaran
                                  _buildPaymentDetail(data, controller),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildBottomButton(context, controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryDetail(
    BuildContext context,
    OrderReviewData data,
    OrderReviewController controller,
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
            _buildEditButton(() => controller.editDelivery(context)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Waktu Pengambilan', data.pickupTime),
              const SizedBox(height: 12),
              _buildInfoRow('Waktu Pengiriman', data.deliveryTime),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Alamat Pengiriman',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(data.address, style: AppTextStyles.body, softWrap: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetail(
    OrderReviewData data,
    OrderReviewController controller,
  ) {
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
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                'Total Pesanan',
                controller.formatRupiah(data.serviceFee),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                'Biaya Pengiriman',
                controller.formatRupiah(data.deliveryFee),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
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
                    controller.formatRupiah(data.totalPayment),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body),
        Text(
          value,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _buildEditButton(VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.edit_outlined, size: 16),
      label: Text(
        'Edit',
        style: AppTextStyles.bodyMuted.copyWith(color: AppColors.actionBlue),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    OrderReviewController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.headerNavy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          ),
          onPressed: controller.isProcessing
              ? null
              : () => controller.processPayment(context),
          child: controller.isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Bayar',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}

class _NoOverscrollBehavior extends ScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
