import 'dart:convert';
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

class OrderDetailScreen
    extends
        StatelessWidget {
  const OrderDetailScreen({
    super.key,
  });

  String _generateOrderId() {
    final random = Random();
    final int orderNumber =
        100000 +
        random.nextInt(
          900000,
        );
    return orderNumber.toString();
  }

  Future<
    void
  >
  _saveOrderToSharedPreferences({
    required String orderId,
    required String service,
    required String qty,
    required String pickupTime,
    required String deliveryTime,
    required String totalPrice,
    required String address,
    required String itemsJson,
    required int deliveryFee,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final notif = "Pesanan $orderId berhasil dibuat - ${DateTime.now()}";

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

    final String orderString = Uri(
      queryParameters: {
        'orderId': orderId,
        'service': service,
        'qty': qty,
        'pickupTime': pickupTime,
        'deliveryTime': deliveryTime,
        'totalPrice': totalPrice,
        'address': address,
        'itemsJson': itemsJson,
        'deliveryFee': deliveryFee.toString(),
      },
    ).query;

    final List<
      String
    >
    existingOrders =
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
      'Pesanan baru disimpan: $orderId dengan total: $totalPrice',
    );
    debugPrint(
      'Total pesanan aktif: ${existingOrders.length}',
    );
  }

  String _encodeItemsToJson(
    List<
      Map<
        String,
        dynamic
      >
    >
    items,
  ) {
    try {
      return jsonEncode(
        items,
      );
    } catch (
      e
    ) {
      debugPrint(
        'Error encoding items to JSON: $e',
      );
      return '[]';
    }
  }

  List<
    Map<
      String,
      dynamic
    >
  >
  _decodeItemsFromJson(
    String? itemsJson,
  ) {
    if (itemsJson ==
            null ||
        itemsJson.isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(
        itemsJson,
      );
      if (decoded
          is List) {
        return decoded
            .cast<
              Map<
                String,
                dynamic
              >
            >();
      }
      return [];
    } catch (
      e
    ) {
      debugPrint(
        'Error decoding items JSON: $e',
      );
      return [];
    }
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
    dynamic value,
  ) {
    int number = 0;
    if (value
        is int) {
      number = value;
    } else if (value
        is String) {
      String cleaned = value
          .replaceAll(
            'Rp ',
            '',
          )
          .replaceAll(
            '.',
            '',
          );
      number =
          int.tryParse(
            cleaned,
          ) ??
          0;
    } else {
      number = 0;
    }

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

  int _toInt(
    dynamic value,
  ) {
    if (value ==
        null)
      return 0;
    if (value
        is int)
      return value;
    if (value
        is String) {
      String cleaned = value
          .replaceAll(
            'Rp ',
            '',
          )
          .replaceAll(
            '.',
            '',
          );
      return int.tryParse(
            cleaned,
          ) ??
          0;
    }
    if (value
        is double)
      return value.toInt();
    return 0;
  }

  Widget _buildOrderItemRow(
    Map<
      String,
      dynamic
    >
    item,
  ) {
    final name =
        item['title'] ??
        item['name'] ??
        'Layanan';
    final qty = _toInt(
      item['qty'],
    );
    final price = _toInt(
      item['price'],
    );
    final subtotal =
        _toInt(
              item['subtotal'],
            ) !=
            0
        ? _toInt(
            item['subtotal'],
          )
        : (qty *
              price);
    final image = item['image'];

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (image !=
                  null &&
              image.toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ),
              child: Image.asset(
                image,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder:
                    (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        width: 45,
                        height: 45,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.local_laundry_service,
                          size: 20,
                        ),
                      );
                    },
              ),
            ),
          if (image !=
                  null &&
              image.toString().isNotEmpty)
            const SizedBox(
              width: 12,
            ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_formatRupiah(price)} x $qty',
                  style: AppTextStyles.bodyMuted.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            _formatRupiah(
              subtotal,
            ),
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(
    List<
      Map<
        String,
        dynamic
      >
    >
    items,
  ) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada layanan',
        ),
      );
    }

    final totalQty = items.fold(
      0,
      (
        sum,
        item,
      ) =>
          sum +
          _toInt(
            item['qty'],
          ),
    );
    final totalPrice = items.fold(
      0,
      (
        sum,
        item,
      ) {
        final qty = _toInt(
          item['qty'],
        );
        final price = _toInt(
          item['price'],
        );
        return sum +
            (qty *
                price);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Pesanan',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        ...items.map(
          (
            item,
          ) => _buildOrderItemRow(
            item,
          ),
        ),
        const Divider(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal ($totalQty item)',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatRupiah(
                totalPrice,
              ),
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

    final bool isFromActiveOrder =
        args['fromActiveOrder'] ==
        true;
    final bool isFromProcessOrder =
        args['fromProcessOrder'] ==
        true;

    final String orderIdTemp =
        args['orderId']?.toString() ??
        '';
    final bool isDummyOrder =
        orderIdTemp ==
        '100001';

    final int activeStepIndex = isDummyOrder
        ? 2
        : 0;

    List<
      Map<
        String,
        dynamic
      >
    >
    orderItems = [];

    if (args['itemsJson'] !=
            null &&
        args['itemsJson'].toString().isNotEmpty) {
      orderItems = _decodeItemsFromJson(
        args['itemsJson'].toString(),
      );
    }

    if (orderItems.isEmpty &&
        args['orderItems'] !=
            null) {
      if (args['orderItems']
          is List) {
        orderItems =
            (args['orderItems']
                    as List)
                .cast<
                  Map<
                    String,
                    dynamic
                  >
                >();
      }
    }

    if (orderItems.isEmpty &&
        args['items'] !=
            null) {
      if (args['items']
          is List) {
        orderItems =
            (args['items']
                    as List)
                .cast<
                  Map<
                    String,
                    dynamic
                  >
                >();
      }
    }

    final String orderId =
        (isFromActiveOrder ||
            isFromProcessOrder)
        ? (args['orderId']?.toString() ??
              '000000')
        : (args['orderId'] ??
              _generateOrderId());

    int totalQty = 0;
    int totalProductPrice = 0;

    if (orderItems.isNotEmpty) {
      totalQty = orderItems.fold(
        0,
        (
          sum,
          item,
        ) =>
            sum +
            _toInt(
              item['qty'],
            ),
      );
      totalProductPrice = orderItems.fold(
        0,
        (
          sum,
          item,
        ) {
          final qty = _toInt(
            item['qty'],
          );
          final price = _toInt(
            item['price'],
          );
          return sum +
              (qty *
                  price);
        },
      );
    } else {
      totalQty = _toInt(
        args['qty'] !=
                null
            ? args['qty']
            : 1,
      );
      totalProductPrice = _toInt(
        args['serviceFee'] !=
                null
            ? args['serviceFee']
            : 0,
      );
    }

    final String pickupTimeText =
        args['pickupTime']?.toString() ??
        '-';
    final String deliveryTimeText =
        args['deliveryTime']?.toString() ??
        '-';
    final String pickupAddress =
        args['address']?.toString() ??
        'Alamat belum diisi';
    final String deliveryAddress =
        args['deliveryAddress']?.toString() ??
        pickupAddress;

    final int deliveryFee = _toInt(
      args['deliveryFee'] !=
              null
          ? args['deliveryFee']
          : 5000,
    );

    // 🔥 PERBAIKAN: Hitung grandTotal dengan benar untuk semua kasus
    final int grandTotal;
    if (isFromActiveOrder ||
        isFromProcessOrder) {
      final String savedTotalPrice =
          args['totalPrice']?.toString() ??
          'Rp 0';
      int savedTotal = _toInt(
        savedTotalPrice,
      );

      // Untuk dummy, tambahkan ongkir karena dummy disimpan tanpa ongkir
      if (isDummyOrder) {
        grandTotal =
            savedTotal +
            deliveryFee;
      } else {
        grandTotal = savedTotal;
      }
    } else {
      // Pesanan baru: produk + ongkir
      grandTotal =
          totalProductPrice +
          deliveryFee;
    }

    final String serviceSummary = orderItems.isEmpty
        ? (args['service']?.toString() ??
              'Laundry')
        : orderItems
              .map(
                (
                  item,
                ) => '${item['title'] ?? item['name']} (${item['qty']})',
              )
              .join(
                ' + ',
              );

    final int durationMinutes = _calculateDurationMinutes(
      pickupTimeText,
      deliveryTimeText,
    );
    final String durationText =
        durationMinutes >=
            60
        ? '${(durationMinutes / 60).round()} jam'
        : '$durationMinutes menit';

    final itemsJson = _encodeItemsToJson(
      orderItems,
    );

    final String statusText = isDummyOrder
        ? 'Dicuci'
        : 'Diproses';

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Detail Pesanan',
        onBack: () async {
          if (!isFromActiveOrder &&
              !isFromProcessOrder) {
            await _saveOrderToSharedPreferences(
              orderId: orderId,
              service: serviceSummary,
              qty: totalQty.toString(),
              pickupTime: pickupTimeText,
              deliveryTime: deliveryTimeText,
              totalPrice: _formatRupiah(
                grandTotal,
              ),
              address: pickupAddress,
              itemsJson: itemsJson,
              deliveryFee: deliveryFee,
            );

            if (!context.mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              SnackBar(
                content: Text(
                  'Pesanan $orderId berhasil dibuat!',
                ),
                backgroundColor: AppColors.success,
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
              child:
                  NotificationListener<
                    OverscrollIndicatorNotification
                  >(
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
                                        isDummyOrder
                                            ? 'Pesanan sedang dicuci'
                                            : 'Pesanan kamu akan segera diambil',
                                        style: AppTextStyles.sectionTitle.copyWith(
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
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w700,
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
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                OrderStepProgressBar(
                                  activeIndex: activeStepIndex,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
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
                                        fontWeight: FontWeight.w600,
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
                                    ) => const Padding(
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
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  deliveryAddress,
                                  style: AppTextStyles.bodyMuted,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          if (orderItems.isNotEmpty)
                            _box(
                              child: _buildOrderItems(
                                orderItems,
                              ),
                            ),

                          if (orderItems.isEmpty)
                            _box(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daftar Pesanan',
                                    style: AppTextStyles.sectionTitle.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  _row(
                                    args['service']?.toString() ??
                                        'Laundry',
                                    '${args['qty'] ?? 1} x ${_formatRupiah(args['serviceFee'] ?? 0)}',
                                  ),
                                  const Divider(),
                                  _row(
                                    'Subtotal Pesanan',
                                    _formatRupiah(
                                      totalProductPrice,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(
                            height: 20,
                          ),

                          _box(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _row(
                                  'Waktu Pengambilan',
                                  pickupTimeText,
                                ),
                                const Divider(),
                                _row(
                                  'Waktu Pengiriman',
                                  deliveryTimeText,
                                ),
                                const Divider(),
                                _row(
                                  'Alamat Pengiriman',
                                  deliveryAddress,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Detail Pembayaran',
                                  style: AppTextStyles.sectionTitle,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                _row(
                                  'Biaya Pengiriman',
                                  _formatRupiah(
                                    deliveryFee,
                                  ),
                                ),
                                _row(
                                  'Kode Promo',
                                  '-',
                                ),
                                const Divider(),
                                _row(
                                  'Total Pembayaran',
                                  _formatRupiah(
                                    grandTotal,
                                  ),
                                  bold: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          if (!isFromActiveOrder &&
                              !isFromProcessOrder)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _saveOrderToSharedPreferences(
                                    orderId: orderId,
                                    service: serviceSummary,
                                    qty: totalQty.toString(),
                                    pickupTime: pickupTimeText,
                                    deliveryTime: deliveryTimeText,
                                    totalPrice: _formatRupiah(
                                      grandTotal,
                                    ),
                                    address: pickupAddress,
                                    itemsJson: itemsJson,
                                    deliveryFee: deliveryFee,
                                  );

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Pesanan $orderId berhasil dibuat!',
                                      ),
                                      backgroundColor: AppColors.success,
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.headerNavy,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Konfirmasi Pesanan',
                                  style: TextStyle(
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
}
