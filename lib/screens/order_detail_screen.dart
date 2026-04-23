import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/step_progress_bar.dart';  // ✅ PERBAIKAN 1: Import yang benar
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';
import '../screens/main_shell_screen.dart';

class OrderDetailScreen
    extends
        StatelessWidget {
  const OrderDetailScreen({
    super.key,
  });

  // ✅ FUNGSI GENERATE ORDER ID 6 DIGIT ACAK
  String _generateOrderId() {
    final random = Random();
    final int orderNumber =
        100000 +
        random.nextInt(
          900000,
        );
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
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final String orderString =
        'orderId=$orderId&'
        'service=$service&'
        'qty=$qty&'
        'pickupTime=$pickupTime&'
        'deliveryTime=$deliveryTime&'
        'totalPrice=$totalPrice&'
        'address=$address';

    final List<String> existingOrders =
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

    print(
      '✅ Pesanan baru disimpan: $orderId',
    );
    print(
      '📦 Total pesanan aktif: ${existingOrders.length}',
    );
  }

  int _calculateDurationMinutes(
    String pickup,
    String delivery,
  ) {
    try {
      final p = DateTime.parse(
        pickup,
      );
      final d = DateTime.parse(
        delivery,
      );
      return d
          .difference(
            p,
          )
          .inMinutes;
    } catch (
      e
    ) {
      return 120;
    }
  }

  String _formatRupiah(
    int value,
  ) {
    final s = value.toString();
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

    return buffer
        .toString()
        .split(
          '',
        )
        .reversed
        .join();
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

    // ✅ GENERATE ORDER ID SAAT BUILD (BUKAN HARDCODE)
    final String orderId = _generateOrderId();

    final List<Map<String, dynamic>> orderItems = 
        (args['orderItems'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? 
        [
          {
            'name': args['service'] ?? 'Cuci Regular',
            'qty': args['qty'] ?? 1,
            'price': args['serviceFee'] ?? 20000,
          }
        ];

    // Hitung total quantity dan total harga
    final int totalQty = orderItems.fold(0, (sum, item) => sum + (item['qty'] as int));
    final int totalPrice = orderItems.fold(0, (sum, item) => sum + ((item['price'] as int) * (item['qty'] as int)));

    final int plasticCount =
        args['qty'] ??
            1;

    final String pickupTimeText =
        args['pickupTime'] ??
            '-';
    final String deliveryTimeText =
        args['deliveryTime'] ??
            '-';

    final String pickupAddress =
        args['address'] ??
            'Alamat belum diisi';
    final String deliveryAddress =
        args['deliveryAddress'] ??
            pickupAddress;

    final String serviceName =
        args['service'] ??
            'Cuci Regular';

    final int deliveryFee =
        args['deliveryFee'] ??
            0;
    final int total =
        args['total'] ??
            0;

    final int grandTotal = totalPrice + deliveryFee;

    final int durationMinutes = _calculateDurationMinutes(
      pickupTimeText,
      deliveryTimeText,
    );

    final String durationText =
        durationMinutes >=
                60
            ? '${(durationMinutes / 60).round()} jam'
            : '$durationMinutes menit';

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Detail Pesanan',
        onBack: () async {
          // ✅ SIMPAN DATA SEBELUM BACK
          await _saveOrderToSharedPreferences(
            orderId: orderId,
            service: orderItems.map((item) => '${item['name']} (${item['qty']})').join(' + '),
            qty: totalQty.toString(),
            pickupTime: pickupTimeText,
            deliveryTime: deliveryTimeText,
            totalPrice: 'Rp ${_formatRupiah(total)}',
            address: pickupAddress,
          );

          if (!context.mounted) return;

          // Tampilkan snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pesanan $orderId berhasil dibuat!'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );

          // Kembali ke Home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainShellScreen()),
            (route) => false,
          );
        },
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: RoundedWhitePanel(
              topRadius: 40,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                8,
              ),
              child: NotificationListener<
                  OverscrollIndicatorNotification>(
                onNotification:
                    (
                      overscroll,
                    ) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _box(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pesanan kamu akan segera diambil',
                                    style: AppTextStyles
                                        .sectionTitle
                                        .copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.successBg,
                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  child: Text(
                                    'Diproses',
                                    style: AppTextStyles
                                        .caption
                                        .copyWith(
                                      color: AppColors.success,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Center(
                              child: Text(
                                'Pesanan $orderId • $totalQty item • selesai dalam $durationText',
                                textAlign: TextAlign.center,
                                style: AppTextStyles
                                    .caption
                                    .copyWith(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const OrderStepProgressBar(
                              activeIndex: 0,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                              child: AspectRatio(
                                aspectRatio:
                                    16 /
                                        9,
                                child: Image.asset(
                                  'assets/images/map_dummy.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Titik Penjemputan',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              pickupAddress,
                              style: AppTextStyles.body,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: List.generate(
                                3,
                                (
                                  index,
                                ) =>
                                    const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  child: Text(
                                    '•',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      height: 0.7,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Titik Pengantaran',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              deliveryAddress,
                              style:
                                  AppTextStyles.bodyMuted,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // ✅ BOX DAFTAR PESANAN (TANPA GAMBAR)
                      _box(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar Pesanan',
                              style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            ...orderItems.map((item) => _buildOrderItemText(
                              name: item['name'] as String,
                              qty: item['qty'] as int,
                              price: item['price'] as int,
                            )),
                            const Divider(),
                            _row('Subtotal Pesanan', 'Rp ${_formatRupiah(totalPrice)}'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ BOX DETAIL (WAKTU, ALAMAT, PEMBAYARAN)
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
                            Text(
                              'Detail Pembayaran',
                              style: AppTextStyles.sectionTitle,
                            ),
                            const SizedBox(height: 10),
                            _row('Biaya Pengiriman', 'Rp ${_formatRupiah(deliveryFee)}'),
                            _row('Kode Promo', '-'),
                            const Divider(),
                            _row(
                              'Total Pembayaran',
                              'Rp ${_formatRupiah(grandTotal)}',
                              bold: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // ✅ TOMBOL KONFIRMASI PESANAN (SUDAH DIPERBAIKI)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              () async {
                            await _saveOrderToSharedPreferences(
                              orderId: orderId,
                              service: serviceName,
                              qty: plasticCount.toString(),
                              pickupTime: pickupTimeText,
                              deliveryTime:
                                  deliveryTimeText,
                              totalPrice:
                                  'Rp ${_formatRupiah(total)}',
                              address: pickupAddress,
                            );

                            // ✅ PERBAIKAN 2: Cek mounted dengan cara yang aman
                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Pesanan $orderId berhasil dibuat!',
                                ),
                                backgroundColor:
                                    AppColors.success,
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
                                if (!context.mounted) {
                                  return;
                                }
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (
                                          _,
                                        ) =>
                                            const MainShellScreen(),
                                  ),
                                  (
                                    route,
                                  ) =>
                                      false,
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.headerNavy,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                          child: Text(
                            'Konfirmasi Pesanan',
                            // ✅ PERBAIKAN 3: Gunakan TextStyle langsung
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
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

  Widget _box({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: child,
    );
  }

  Widget _row(
    String title,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: bold
                  ? AppTextStyles.sectionTitle
                  : AppTextStyles.body,
            ),
          ),
          Text(
            value,
            style: bold
                ? AppTextStyles.sectionTitle
                : AppTextStyles.body,
          ),
        ],
      ),
    );
  }
  // ✅ WIDGET ITEM PESANAN TANPA GAMBAR
Widget _buildOrderItemText({
  required String name,
  required int qty,
  required int price,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '$qty x Rp ${_formatRupiah(price)}',
                style: AppTextStyles.bodyMuted,
              ),
            ],
          ),
        ),
        Text(
          'Rp ${_formatRupiah(price * qty)}',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

}  // ✅ Penutup class OrderDetailScreen (SUDAH ADA)
