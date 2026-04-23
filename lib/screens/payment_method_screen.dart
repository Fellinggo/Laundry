import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/payment_method_tile.dart';

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
    final args =
        ModalRoute.of(
              context,
            )?.settings.arguments
            as Map? ??
        {};

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pilih Metode Pembayaran',
          style: AppTextStyles.screenTitleNavy,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.headerNavy,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        children: [
          PaymentMethodTile(
            title: 'DANA',
            connected: true,
            leading: const WalletLogoBox(
              label: 'D',
              color: Color(
                0xFF118EEA,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/pin',
                arguments: {
                  'wallet': 'DANA',
                  'order': args, // 🔥 PASS ORDER
                },
              );
            },
          ),

          const SizedBox(
            height: 12,
          ),

          PaymentMethodTile(
            title: 'OVO',
            connected: true,
            leading: const WalletLogoBox(
              label: 'O',
              color: Color(
                0xFF6B2C91,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/pin',
                arguments: {
                  'wallet': 'OVO',
                  'order': args,
                },
              );
            },
          ),

          const SizedBox(
            height: 12,
          ),

          const PaymentMethodTile(
            title: 'BCA',
            leading: WalletLogoBox(
              label: 'B',
              color: AppColors.headerNavy,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          const PaymentMethodTile(
            title: 'BNI',
            leading: WalletLogoBox(
              label: 'N',
              color: Color(
                0xFF00529C,
              ),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          const PaymentMethodTile(
            title: 'Mandiri',
            leading: WalletLogoBox(
              label: 'M',
              color: Color(
                0xFFFF6B00,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
