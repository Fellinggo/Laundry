import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_detail_model.dart';
import '../views/screens/main_shell_screen.dart';

class OrderDetailController extends ChangeNotifier {
  final OrderDetailData data;
  bool _isSaving = false;

  OrderDetailData get orderData => data;
  bool get isSaving => _isSaving;

  OrderDetailController({required this.data});

  String formatRupiah(int number) {
    final s = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  Future<void> saveOrderToPreferences() async {
    _isSaving = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // 1. Simpan notifikasi
    final notif = "Pesanan ${data.orderId} berhasil dibuat - ${DateTime.now()}";
    final list = prefs.getStringList('notifications') ?? [];
    list.insert(0, notif);
    await prefs.setStringList('notifications', list);

    // 2. Format total harga
    final totalHargaFormatted = formatRupiah(data.grandTotal).trim();

    // 3. BuAT ORDER STRING dengan format yang KONSISTEN
    //    PERHATIAN: Jangan gunakan Uri().query karena menambahkan '?' di awal
    //    Gunakan format manual agar sesuai dengan UserOrder.fromQueryString
    final orderString = _buildOrderString(totalHargaFormatted);

    debugPrint('DEBUG - Order string yang disimpan: $orderString');

    // 4. Simpan ke active_orders
    final existingOrders = prefs.getStringList('active_orders') ?? [];
    existingOrders.add(orderString);
    await prefs.setStringList('active_orders', existingOrders);

    debugPrint(
      'Pesanan baru disimpan: ${data.orderId} dengan total: $totalHargaFormatted',
    );
    debugPrint('Total pesanan aktif saat ini: ${existingOrders.length}');

    _isSaving = false;
    notifyListeners();
  }

  // METHOD BARU: Membuat order string dengan format yang benar
  String _buildOrderString(String totalHargaFormatted) {
    // Format: orderId=XXX&service=XXX&qty=XXX&pickupTime=XXX&deliveryTime=XXX&totalPrice=XXX&address=XXX&itemsJson=XXX&deliveryFee=XXX
    // TANPA tanda '?' di awal!
    return 'orderId=${data.orderId}'
        '&service=${Uri.encodeComponent(data.serviceSummary)}'
        '&qty=${data.totalQty}'
        '&pickupTime=${Uri.encodeComponent(data.pickupTimeText)}'
        '&deliveryTime=${Uri.encodeComponent(data.deliveryTimeText)}'
        '&totalPrice=$totalHargaFormatted'
        '&address=${Uri.encodeComponent(data.pickupAddress)}'
        '&itemsJson=${Uri.encodeComponent(data.itemsJson)}'
        '&deliveryFee=${data.deliveryFee}';
  }

  // KOREKSI: Navigasi ke Home (tab index 0) dengan initialTabIndex
  void _navigateToHome(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        // SET FLAG UNTUK REFRESH MY ORDERS
        // Kirim notifikasi bahwa data pesanan berubah
        // KOREKSI: Tambahkan initialTabIndex: 0 untuk navigasi ke Home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const MainShellScreen(
              initialTabIndex: 0, // KOREKSI: Arahkan ke tab Home (index 0)
              refreshMyOrders: true,
            ),
          ),
          (route) => false,
        );
      }
    });
  }

  Future<void> onBackPressed(BuildContext context) async {
    if (!data.isFromActiveOrder && !data.isFromProcessOrder) {
      await saveOrderToPreferences();
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pesanan ${data.orderId} berhasil dibuat!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      _navigateToHome(context);
    } else {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> onConfirmPressed(BuildContext context) async {
    await saveOrderToPreferences();
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan ${data.orderId} berhasil dibuat!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    _navigateToHome(context);
  }

  void goBack(BuildContext context) {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
