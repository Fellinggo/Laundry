import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../shared/widgets/payment_method_tile.dart';
import '../../shared/widgets/wallet_logo_box.dart';
import '../controllers/payment_method_controller.dart';


class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentController>(
      create: (_) => PaymentController(),
      child: Builder(
        builder: (context) {
          // Menggunakan context dari Builder untuk mengakses Provider yang baru dibuat
          final controller = context.read<PaymentController>();
          final orderData = controller.getOrderData(context);
          final methods = controller.getPaymentMethods();

          return Scaffold(
            backgroundColor: AppColors.pageBg,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.headerNavy),
                onPressed: () => controller.goBack(context),
              ),
              title: Text(
                'Pilih Metode Pembayaran',
                style: AppTextStyles.screenTitleNavy,
              ),
            ),
            body: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: methods.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final method = methods[index];

                return PaymentMethodTile(
                  title: method.name,
                  connected: method.isConnected,
                  leading: WalletLogoBox(
                    label: method.logoLabel,
                    color: method.color,
                  ),
                  onTap: () =>
                      controller.onMethodTap(context, method, orderData),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
