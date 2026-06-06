import 'package:flutter/material.dart';
import 'package:wushlaundry/controllers/payment_method_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_styles.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/wallet_logo_box.dart';

class PaymentMethodScreen
    extends
        StatelessWidget {
  const PaymentMethodScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = PaymentController();
    final orderData = controller.getOrderData(
      context,
    );
    final methods = controller.getPaymentMethods();

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.headerNavy,
          ),
          onPressed: () => controller.goBack(
            context,
          ),
        ),
        title: Text(
          'Pilih Metode Pembayaran',
          style: AppTextStyles.screenTitleNavy,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        children: methods.map(
          (
            method,
          ) {
            return Column(
              children: [
                PaymentMethodTile(
                  title: method.name,
                  connected: method.isConnected,
                  leading: WalletLogoBox(
                    label: method.logoLabel,
                    color: method.color,
                  ),
                  onTap: () => controller.onMethodTap(
                    context,
                    method,
                    orderData,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
