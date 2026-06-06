import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/order_review_service_summary.dart';
import '../../../controllers/order_review_controller.dart';
import '../../../models/order_review_model.dart';

class OrderReviewScreen
    extends
        StatefulWidget {
  const OrderReviewScreen({
    super.key,
  });

  @override
  State<
    OrderReviewScreen
  >
  createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState
    extends
        State<
          OrderReviewScreen
        > {
  late OrderReviewController _controller;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final args =
          ModalRoute.of(
                context,
              )?.settings.arguments
              as Map<
                String,
                dynamic
              >? ??
          {};
      final data = OrderReviewData.fromArguments(
        args,
      );

      _controller = OrderReviewController(
        data: data,
      );
      _controller.addListener(
        _onControllerChanged,
      );
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(
        () {},
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_isInit) {
      return const Scaffold(
        backgroundColor: AppColors.headerNavy,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final data = _controller.orderData;

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Tinjau Pesanan',
        onBack: () => _controller.goBack(
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
                            const SizedBox(
                              height: 12,
                            ),

                            // Ringkasan Layanan
                            OrderReviewServiceSummary(
                              data: data,
                              formatRupiah: _controller.formatRupiah,
                            ),
                            const SizedBox(
                              height: 24,
                            ),

                            // Detail Pengiriman (rapi)
                            _buildDeliveryDetail(
                              data,
                            ),
                            const SizedBox(
                              height: 24,
                            ),

                            // Detail Pembayaran
                            _buildPaymentDetail(
                              data,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Detail Pengiriman yang RAPI
  Widget _buildDeliveryDetail(
    OrderReviewData data,
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
            _buildEditButton(
              () => _controller.editDelivery(
                context,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          width: double.infinity,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Waktu Pengambilan (kiri-kanan)
              _buildInfoRow(
                'Waktu Pengambilan',
                data.pickupTime,
              ),
              const SizedBox(
                height: 12,
              ),

              // Waktu Pengiriman (kiri-kanan)
              _buildInfoRow(
                'Waktu Pengiriman',
                data.deliveryTime,
              ),
              const SizedBox(
                height: 12,
              ),

              // Alamat Pengiriman (full width ke bawah)
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Alamat Pengiriman',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                data.address,
                style: AppTextStyles.body,
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget Detail Pembayaran yang RAPI
  Widget _buildPaymentDetail(
    OrderReviewData data,
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
        const SizedBox(
          height: 12,
        ),
        Container(
          width: double.infinity,
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
              // Total Pesanan (kiri-kanan)
              _buildInfoRow(
                'Total Pesanan',
                _controller.formatRupiah(
                  data.serviceFee,
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              // Biaya Pengiriman (kiri-kanan)
              _buildInfoRow(
                'Biaya Pengiriman',
                _controller.formatRupiah(
                  data.deliveryFee,
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              const Divider(),
              const SizedBox(
                height: 8,
              ),

              // Total Pembayaran (kiri-kanan, bold)
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
                    _controller.formatRupiah(
                      data.totalPayment,
                    ),
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

  // Helper row untuk format kiri-kanan
  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body,
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _buildEditButton(
    VoidCallback onTap,
  ) {
    return TextButton.icon(
      onPressed: onTap,
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
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset: const Offset(
              0,
              -2,
            ),
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
              borderRadius: BorderRadius.circular(
                AppSpacing.buttonRadius,
              ),
            ),
          ),
          onPressed: _controller.isProcessing
              ? null
              : () => _controller.processPayment(
                  context,
                ),
          child: _controller.isProcessing
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

class _NoOverscrollBehavior
    extends
        ScrollBehavior {
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
  ScrollPhysics getScrollPhysics(
    BuildContext context,
  ) {
    return const ClampingScrollPhysics();
  }
}
