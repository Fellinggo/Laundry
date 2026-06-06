import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_detail_model.dart';
import '../views/screens/main_shell_screen.dart';

class OrderDetailController
    extends
        ChangeNotifier {
  final OrderDetailData data;
  bool _isSaving = false;

  OrderDetailData get orderData => data;
  bool get isSaving => _isSaving;

  OrderDetailController({
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

  Future<
    void
  >
  saveOrderToPreferences() async {
    _isSaving = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final notif = "Pesanan ${data.orderId} berhasil dibuat - ${DateTime.now()}";
    final list =
        prefs.getStringList(
          'notifications',
        ) ??
        [];
    list.insert(
      0,
      notif,
    );
    await prefs.setStringList(
      'notifications',
      list,
    );

    final orderString = Uri(
      queryParameters: {
        'orderId': data.orderId,
        'service': data.serviceSummary,
        'qty': data.totalQty.toString(),
        'pickupTime': data.pickupTimeText,
        'deliveryTime': data.deliveryTimeText,
        'totalPrice': formatRupiah(
          data.grandTotal,
        ),
        'address': data.pickupAddress,
        'itemsJson': data.itemsJson,
        'deliveryFee': data.deliveryFee.toString(),
      },
    ).query;

    final existingOrders =
        prefs.getStringList(
          'active_orders',
        ) ??
        [];
    existingOrders.add(
      orderString,
    );
    await prefs.setStringList(
      'active_orders',
      existingOrders,
    );

    debugPrint(
      'Pesanan baru disimpan: ${data.orderId} dengan total: ${data.grandTotal}',
    );
    debugPrint(
      'Total pesanan aktif: ${existingOrders.length}',
    );

    _isSaving = false;
    notifyListeners();
  }

  Future<
    void
  >
  onBackPressed(
    BuildContext context,
  ) async {
    if (!data.isFromActiveOrder &&
        !data.isFromProcessOrder) {
      await saveOrderToPreferences();
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Pesanan ${data.orderId} berhasil dibuat!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(
            seconds: 2,
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (
                _,
              ) => const MainShellScreen(),
        ),
        (
          route,
        ) => false,
      );
    } else {
      Navigator.pop(
        context,
      );
    }
  }

  Future<
    void
  >
  onConfirmPressed(
    BuildContext context,
  ) async {
    await saveOrderToPreferences();
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          'Pesanan ${data.orderId} berhasil dibuat!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );

    Future.delayed(
      const Duration(
        seconds: 1,
      ),
      () {
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder:
                (
                  _,
                ) => const MainShellScreen(),
          ),
          (
            route,
          ) => false,
        );
      },
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
