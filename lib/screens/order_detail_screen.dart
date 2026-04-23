import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/step_progress_bar.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';
import '../screens/main_shell_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  String _generateOrderId() {
    final random = Random();
    final int orderNumber = 100000 + random.nextInt(900000);
    return orderNumber.toString();
  }

  // ✅ FUNGSI SIMPAN PESANAN KE SHARED PREFERENCES
  Future<void> _saveOrderToSharedPreferences({
    required String orderId,
    required String service,
    required String qty,
    required String pickupTime,
    required String deliveryTime,
    required String totalPrice,
    required String address,
    required String itemsJson, // ← Tambahkan itemsJson
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Format: serviceSummary|totalPrice|pickupTime|deliveryTime|address|itemsJson
    final String orderString = 
        "$service|"
        "$totalPrice|"
        "$pickupTime|"
        "$deliveryTime|"
        "$address|"
        "$itemsJson";

    final List<String> existingOrders = prefs.getStringList('active_orders') ?? [];
    existingOrders.add(orderString);
    await prefs.setStringList('active_orders', existingOrders);

    debugPrint('✅ Pesanan baru disimpan: $orderId');
    debugPrint('📦 Total pesanan aktif: ${existingOrders.length}');
  }

  // ✅ ENCODE ITEMS KE JSON STRING
  String _encodeItemsToJson(List<Map<String, dynamic>> items) {
    String jsonStr = '[';
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      jsonStr += '{';
      jsonStr += '"title":"${item['title'] ?? item['name'] ?? ''}",';
      jsonStr += '"price":${item['price'] ?? 0},';
      jsonStr += '"qty":${item['qty'] ?? 1},';
      jsonStr += '"subtotal":${item['subtotal'] ?? 0},';
      jsonStr += '"image":"${item['image'] ?? ''}"';
      jsonStr += '}';
      if (i < items.length - 1) jsonStr += ',';
    }
    jsonStr += ']';
    return jsonStr;
  }

  int _calculateDurationMinutes(String pickup, String delivery) {
    try {
      final p = DateTime.parse(pickup);
      final d = DateTime.parse(delivery);
      return d.difference(p).inMinutes;
    } catch (e) {
      return 120;
    }
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  // ✅ WIDGET ITEM PESANAN DENGAN GAMBAR
  Widget _buildOrderItemRow(Map<String, dynamic> item) {
    final name = item['title'] ?? item['name'] ?? 'Layanan';
    final qty = (item['qty'] as int?) ?? 1;
    final price = (item['price'] as int?) ?? 0;
    final subtotal = item['subtotal'] ?? (qty * price);
    final image = item['image'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (image != null && image.toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 45,
                    height: 45,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.local_laundry_service, size: 20),
                  );
                },
              ),
            ),
          if (image != null && image.toString().isNotEmpty) const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '$qty x Rp ${_formatRupiah(price)}',
                  style: AppTextStyles.bodyMuted.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          
          Text(
            'Rp ${_formatRupiah(subtotal is int ? subtotal : subtotal.toInt())}',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ BUILD ORDER ITEMS WIDGET
  Widget _buildOrderItems(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Tidak ada layanan'),
      );
    }
    
    // Hitung total
    final totalQty = items.fold(0, (sum, item) => sum + ((item['qty'] as int?) ?? 1));
    final totalPrice = items.fold(0, (sum, item) {
      final qty = (item['qty'] as int?) ?? 1;
      final price = (item['price'] as int?) ?? 0;
      return sum + (qty * price);
    });
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Pesanan',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildOrderItemRow(item)),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal ($totalQty item)',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              'Rp ${_formatRupiah(totalPrice)}',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};

    final String orderId = _generateOrderId();

    // Ambil items dari args
    final List<Map<String, dynamic>> orderItems = 
        (args['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? 
        (args['orderItems'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? 
        [];

    final int totalQty = orderItems.fold(0, (sum, item) => sum + ((item['qty'] as int?) ?? 1));
    final int totalPrice = orderItems.fold(0, (sum, item) {
      final qty = (item['qty'] as int?) ?? 1;
      final price = (item['price'] as int?) ?? 0;
      return sum + (qty * price);
    });

    final String pickupTimeText = args['pickupTime'] ?? '-';
    final String deliveryTimeText = args['deliveryTime'] ?? '-';
    final String pickupAddress = args['address'] ?? 'Alamat belum diisi';
    final String deliveryAddress = args['deliveryAddress'] ?? pickupAddress;
    final int deliveryFee = args['deliveryFee'] ?? 5000;
    final int grandTotal = totalPrice + deliveryFee;

    final int durationMinutes = _calculateDurationMinutes(pickupTimeText, deliveryTimeText);
    final String durationText = durationMinutes >= 60
        ? '${(durationMinutes / 60).round()} jam'
        : '$durationMinutes menit';

    // Service summary untuk display
    final String serviceSummary = orderItems.isEmpty 
        ? 'Laundry'
        : orderItems.map((item) => '${item['title'] ?? item['name']} (${item['qty']})').join(' + ');

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Detail Pesanan',
        onBack: () async {
          // Encode items ke JSON
          final itemsJson = _encodeItemsToJson(orderItems);
          
          await _saveOrderToSharedPreferences(
            orderId: orderId,
            service: serviceSummary,
            qty: totalQty.toString(),
            pickupTime: pickupTimeText,
            deliveryTime: deliveryTimeText,
            totalPrice: 'Rp ${_formatRupiah(grandTotal)}',
            address: pickupAddress,
            itemsJson: itemsJson,
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pesanan $orderId berhasil dibuat!'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainShellScreen()),
            (route) => false,
          );
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: RoundedWhitePanel(
              topRadius: 40,
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 8),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pesanan kamu akan segera diambil',
                                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.successBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Diproses',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                'Pesanan $orderId • $totalQty item • selesai dalam $durationText',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const OrderStepProgressBar(activeIndex: 0),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.asset(
                                  'assets/images/map_dummy.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.red, size: 18),
                                SizedBox(width: 6),
                                Text('Titik Penjemputan', style: TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(pickupAddress, style: AppTextStyles.body),
                            const SizedBox(height: 10),
                            Column(
                              children: List.generate(3, (index) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 1),
                                child: Text('•', style: TextStyle(color: Colors.grey, fontSize: 14, height: 0.7)),
                              )),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.green, size: 18),
                                SizedBox(width: 6),
                                Text('Titik Pengantaran', style: TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(deliveryAddress, style: AppTextStyles.bodyMuted),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // ✅ BOX DAFTAR PESANAN
                      if (orderItems.isNotEmpty)
                        _box(
                          child: _buildOrderItems(orderItems),
                        ),

                      const SizedBox(height: 20),

                      _box(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _row('Waktu Pengambilan', pickupTimeText),
                            const Divider(),
                            _row('Waktu Pengiriman', deliveryTimeText),
                            const Divider(),
                            _row('Alamat Pengiriman', deliveryAddress),
                            const Divider(),
                            const SizedBox(height: 10),
                            Text('Detail Pembayaran', style: AppTextStyles.sectionTitle),
                            const SizedBox(height: 10),
                            _row('Biaya Pengiriman', 'Rp ${_formatRupiah(deliveryFee)}'),
                            _row('Kode Promo', '-'),
                            const Divider(),
                            _row('Total Pembayaran', 'Rp ${_formatRupiah(grandTotal)}', bold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final itemsJson = _encodeItemsToJson(orderItems);
                            
                            await _saveOrderToSharedPreferences(
                              orderId: orderId,
                              service: serviceSummary,
                              qty: totalQty.toString(),
                              pickupTime: pickupTimeText,
                              deliveryTime: deliveryTimeText,
                              totalPrice: 'Rp ${_formatRupiah(grandTotal)}',
                              address: pickupAddress,
                              itemsJson: itemsJson,
                            );

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pesanan $orderId berhasil dibuat!'),
                                backgroundColor: AppColors.success,
                                duration: const Duration(seconds: 2),
                              ),
                            );

                            Future.delayed(const Duration(seconds: 1), () {
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const MainShellScreen()),
                                (route) => false,
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.headerNavy,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Konfirmasi Pesanan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }

  Widget _row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: bold ? AppTextStyles.sectionTitle : AppTextStyles.body,
            ),
          ),
          Text(
            value,
            style: bold ? AppTextStyles.sectionTitle : AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}