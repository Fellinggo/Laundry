import 'package:flutter/material.dart';
import 'package:wushlaundry/models/profile/payment_method_model.dart';

class PaymentController
    extends
        ChangeNotifier {
  List<
    PaymentMethodData
  >
  getPaymentMethods() {
    return PaymentMethodData.list;
  }

  Map<
    String,
    dynamic
  >
  getOrderData(
    BuildContext context,
  ) {
    final args = ModalRoute.of(
      context,
    )?.settings.arguments;
    if (args
        is Map<
          String,
          dynamic
        >) {
      return args;
    }
    return {};
  }

  void onMethodTap(
    BuildContext context,
    PaymentMethodData method,
    Map<
      String,
      dynamic
    >
    orderData,
  ) {
    if (!method.isConnected) {
      _showNotAvailableDialog(
        context,
        method.name,
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/pin',
      arguments: {
        'wallet': method.name,
        'order': orderData,
      },
    );
  }

  void _showNotAvailableDialog(
    BuildContext context,
    String methodName,
  ) {
    showDialog(
      context: context,
      builder:
          (
            ctx,
          ) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            title: Text(
              '$methodName Tidak Tersedia',
            ),
            content: Text(
              'Metode pembayaran $methodName akan segera hadir.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(
                  ctx,
                ),
                child: const Text(
                  'OK',
                ),
              ),
            ],
          ),
    );
  }

  void goBack(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }
}
