import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/order_review_service_summary.dart';
import '../widgets/order_review_delivery_detail.dart';
import '../widgets/order_review_payment_detail.dart';
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

  @override
  void initState() {
    super.initState();

    // Perbaikan: cast ke Map<String, dynamic>? terlebih dahulu
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
                            OrderReviewServiceSummary(
                              data: data,
                              formatRupiah: _controller.formatRupiah,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            OrderReviewDeliveryDetail(
                              pickupTime: data.pickupTime,
                              deliveryTime: data.deliveryTime,
                              address: data.address,
                              onEdit: () => _controller.editDelivery(
                                context,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            OrderReviewPaymentDetail(
                              serviceFee: data.serviceFee,
                              deliveryFee: data.deliveryFee,
                              totalPayment: data.totalPayment,
                              formatRupiah: _controller.formatRupiah,
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
