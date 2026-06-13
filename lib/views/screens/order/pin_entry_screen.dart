import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/views/widgets/pin_dots_indicator_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/pin_keypad.dart';
import '../../widgets/primary_button.dart';
import '../../../controllers/order/pin_entry_controller.dart';

class PinEntryScreen
    extends
        StatelessWidget {
  final String walletName;

  const PinEntryScreen({
    super.key,
    required this.walletName,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Pengambilan argumen route diletakkan di atas level Provider
    final args =
        ModalRoute.of(
              context,
            )?.settings.arguments
            as Map? ??
        {};
    final orderData =
        args['order']
            as Map<
              String,
              dynamic
            >? ??
        {};

    return ChangeNotifierProvider<
      PinEntryController
    >(
      create:
          (
            _,
          ) => PinEntryController(),
      child:
          Consumer<
            PinEntryController
          >(
            builder:
                (
                  context,
                  controller,
                  child,
                ) {
                  return Scaffold(
                    backgroundColor: AppColors.white,
                    appBar: AppBar(
                      backgroundColor: AppColors.white,
                      elevation: 0,
                      title: Text(
                        'Masukkan PIN $walletName',
                        style: AppTextStyles.screenTitleNavy,
                      ),
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        onPressed: () => controller.goBack(
                          context,
                        ),
                      ),
                    ),
                    body: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        PinDotsIndicator(
                          length: 6,
                          filledCount: controller.digits.length,
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          child: PrimaryButton(
                            label: controller.isProcessing
                                ? 'Memproses...'
                                : 'Konfirmasi',
                            backgroundColor: AppColors.actionBlue,
                            onPressed:
                                controller.isPinComplete &&
                                    !controller.isProcessing
                                ? () => controller.confirmAndNavigate(
                                    context,
                                    orderData,
                                  )
                                : null,
                          ),
                        ),
                        const Spacer(),
                        PinKeypad(
                          onDigit: controller.addDigit,
                          onBackspace: controller.removeLastDigit,
                        ),
                      ],
                    ),
                  );
                },
          ),
    );
  }
}
