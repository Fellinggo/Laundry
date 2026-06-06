import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_styles.dart';
import '../widgets/step_progress_bar.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/order_detail_box.dart';
import '../widgets/order_detail_item_row.dart';
import '../../../controllers/order_detail_controller.dart';
import '../../../models/order_detail_model.dart';

class OrderDetailScreen
    extends
        StatelessWidget {
  const OrderDetailScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final args =
        ModalRoute.of(
              context,
            )?.settings.arguments
            as Map<
              String,
              dynamic
            >? ??
        {};
    final orderData = OrderDetailData.fromArguments(
      args,
    );
    final controller = OrderDetailController(
      data: orderData,
    );

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Detail Pesanan',
        onBack: () => controller.onBackPressed(
          context,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: RoundedWhitePanel(
              topRadius: 40,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                8,
              ),
              child:
                  NotificationListener<
                    OverscrollIndicatorNotification
                  >(
                    onNotification:
                        (
                          overscroll,
                        ) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OrderDetailBox(
                            child: _buildStatusHeader(
                              orderData,
                              controller,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          if (orderData.orderItems.isNotEmpty)
                            OrderDetailBox(
                              child: _buildOrderItems(
                                orderData,
                                controller,
                              ),
                            ),
                          if (orderData.orderItems.isEmpty)
                            OrderDetailBox(
                              child: _buildSimpleOrderItems(
                                orderData,
                                controller,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),

                          OrderDetailBox(
                            child: _buildPaymentDetails(
                              orderData,
                              controller,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          if (!orderData.isFromActiveOrder &&
                              !orderData.isFromProcessOrder)
                            _buildConfirmButton(
                              context,
                              controller,
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(
    OrderDetailData data,
    OrderDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.isDummyOrder
                    ? 'Pesanan sedang dicuci'
                    : 'Pesanan kamu akan segera diambil',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Text(
                data.statusText,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: Text(
            'Pesanan ${data.orderId} • ${data.totalQty} item • selesai dalam ${data.durationText}',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        OrderStepProgressBar(
          activeIndex: data.activeStepIndex,
        ),
        const SizedBox(
          height: 16,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            16,
          ),
          child: AspectRatio(
            aspectRatio:
                16 /
                9,
            child: Image.asset(
              'assets/images/map_dummy.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        const Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.red,
              size: 18,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Titik Penjemputan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          data.pickupAddress,
          style: AppTextStyles.body,
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: List.generate(
            3,
            (
              index,
            ) => const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1,
              ),
              child: Text(
                '•',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 0.7,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.green,
              size: 18,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Titik Pengantaran',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          data.deliveryAddress,
          style: AppTextStyles.bodyMuted,
        ),
      ],
    );
  }

  Widget _buildOrderItems(
    OrderDetailData data,
    OrderDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Pesanan',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        ...data.orderItems.map(
          (
            item,
          ) => OrderDetailItemRow(
            item: item,
          ),
        ),
        const Divider(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal (${data.totalQty} item)',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              controller.formatRupiah(
                data.totalProductPrice,
              ),
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimpleOrderItems(
    OrderDetailData data,
    OrderDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Pesanan',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        _row(
          data.serviceSummary,
          '${data.totalQty} x ${controller.formatRupiah(data.totalProductPrice)}',
        ),
        const Divider(),
        _row(
          'Subtotal Pesanan',
          controller.formatRupiah(
            data.totalProductPrice,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails(
    OrderDetailData data,
    OrderDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(
          'Waktu Pengambilan',
          data.pickupTimeText,
        ),
        const Divider(),
        _row(
          'Waktu Pengiriman',
          data.deliveryTimeText,
        ),
        const Divider(),
        _row(
          'Alamat Pengiriman',
          data.deliveryAddress,
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Detail Pembayaran',
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(
          height: 10,
        ),
        _row(
          'Biaya Pengiriman',
          controller.formatRupiah(
            data.deliveryFee,
          ),
        ),
        _row(
          'Kode Promo',
          '-',
        ),
        const Divider(),
        _row(
          'Total Pembayaran',
          controller.formatRupiah(
            data.grandTotal,
          ),
          bold: true,
        ),
      ],
    );
  }

  Widget _buildConfirmButton(
    BuildContext context,
    OrderDetailController controller,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isSaving
            ? null
            : () => controller.onConfirmPressed(
                context,
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.headerNavy,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
        child: Text(
          controller.isSaving
              ? 'Menyimpan...'
              : 'Konfirmasi Pesanan',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: bold
                  ? AppTextStyles.sectionTitle
                  : AppTextStyles.body,
            ),
          ),
          Text(
            value,
            style: bold
                ? AppTextStyles.sectionTitle
                : AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
