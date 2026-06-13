import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/order/order_review_model.dart';

class OrderReviewController
    extends
        ChangeNotifier {
  final OrderReviewData data;
  bool _isProcessing = false;

  OrderReviewData get orderData => data;
  bool get isProcessing => _isProcessing;

  OrderReviewController({
    required this.data,
  });

  String formatRupiah(
    int number,
  ) {
    final s = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (
      int i =
          s.length -
          1;
      i >=
          0;
      i--
    ) {
      buffer.write(
        s[i],
      );
      count++;
      if (count %
                  3 ==
              0 &&
          i !=
              0) {
        buffer.write(
          '.',
        );
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  String _encodeOrderToRawString() {
    if (data.hasOrderItems) {
      return "${data.serviceSummary}|"
          "${data.totalPayment}|"
          "${data.pickupTime}|"
          "${data.deliveryTime}|"
          "${data.address}|"
          "${data.encodeItemsToJson()}";
    } else {
      return "service=${data.serviceSummary}&"
          "qty=${data.totalQty}&"
          "pickupTime=${data.pickupTime}&"
          "deliveryTime=${data.deliveryTime}&"
          "totalPrice=${data.totalPayment}&"
          "address=${data.address}";
    }
  }

  Future<
    void
  >
  processPayment(
    BuildContext context,
  ) async {
    _isProcessing = true;
    notifyListeners();

    await Future.delayed(
      const Duration(
        milliseconds: 800,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    final currentOrders =
        prefs.getStringList(
          'active_orders',
        ) ??
        [];

    final newOrderRaw = _encodeOrderToRawString();
    currentOrders.add(
      newOrderRaw,
    );

    await prefs.setStringList(
      'active_orders',
      currentOrders,
    );

    _isProcessing = false;
    notifyListeners();

    if (context.mounted) {
      Navigator.pushNamed(
        context,
        '/payment',
        arguments: data.toPaymentArguments(),
      );
    }
  }

  void goBack(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }

  void editDelivery(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }
}
