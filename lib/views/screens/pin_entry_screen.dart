import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/pin_dots_indicator_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/pin_keypad.dart';
import '../widgets/primary_button.dart';
import '../../controllers/pin_entry_controller.dart';

class PinEntryScreen
    extends
        StatefulWidget {
  const PinEntryScreen({
    super.key,
    required this.walletName,
  });

  final String walletName;

  @override
  State<
    PinEntryScreen
  >
  createState() => _PinEntryScreenState();
}

class _PinEntryScreenState
    extends
        State<
          PinEntryScreen
        > {
  late PinEntryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PinEntryController();
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
    final args =
        ModalRoute.of(
              context,
            )?.settings.arguments
            as Map? ??
        {};
    final orderData =
        args['order'] ??
        {};

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Masukkan PIN ${widget.walletName}',
          style: AppTextStyles.screenTitleNavy,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => _controller.goBack(
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
            filledCount: _controller.digits.length,
          ),
          const SizedBox(
            height: 28,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
            ),
            child: PrimaryButton(
              label: _controller.isProcessing
                  ? 'Memproses...'
                  : 'Konfirmasi',
              backgroundColor: AppColors.actionBlue,
              onPressed:
                  _controller.isPinComplete &&
                      !_controller.isProcessing
                  ? () => _controller.confirmAndNavigate(
                      context,
                      orderData,
                    )
                  : null,
            ),
          ),
          const Spacer(),
          PinKeypad(
            onDigit: _controller.addDigit,
            onBackspace: _controller.removeLastDigit,
          ),
        ],
      ),
    );
  }
}
