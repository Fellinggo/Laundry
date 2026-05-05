import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/data/dataDummy.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/order_status_segmented_bar.dart';
import '../widgets/pesanan_order_card.dart';
import '../widgets/rounded_white_panel.dart';

class MyOrdersScreen
    extends
        StatefulWidget {
  const MyOrdersScreen({
    super.key,
    this.loggedIn = false,
  });

  final bool loggedIn;

  @override
  State<
    MyOrdersScreen
  >
  createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState
    extends
        State<
          MyOrdersScreen
        > {
  int _tab = 0;
  List<
    Map<
      String,
      dynamic
    >
  >
  activeOrders = [];
  List<
    Map<
      String,
      dynamic
    >
  >
  processOrders = [];
  List<
    Map<
      String,
      dynamic
    >
  >
  completedOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadOrders();
  }

  @override
  void didUpdateWidget(
    MyOrdersScreen oldWidget,
  ) {
    super.didUpdateWidget(
      oldWidget,
    );
    if (oldWidget.loggedIn !=
        widget.loggedIn) {
      _loadOrders();
    }
  }

  int _parseRupiahToInt(
    String rupiah,
  ) {
    if (rupiah.isEmpty) return 0;
    String cleaned = rupiah
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

  String _formatRupiah(
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
  _cleanInvalidOrders() async {
    final prefs = await SharedPreferences.getInstance();
    bool cleaned = false;

    List<
      String
    >
    activeRaw =
        prefs.getStringList(
          'active_orders',
        ) ??
        [];
    List<
      String
    >
    validActive = activeRaw.where(
      (
        order,
      ) {
        final data = Uri.splitQueryString(
          order,
        );
        final orderId =
            data['orderId'] ??
            '';
        final totalPrice =
            data['totalPrice'] ??
            'Rp 0';
        int nominal = _parseRupiahToInt(
          totalPrice,
        );
        if (orderId ==
            '100001')
          return true;
        return nominal >
            5000;
      },
    ).toList();

    if (validActive.length !=
        activeRaw.length) {
      await prefs.setStringList(
        'active_orders',
        validActive,
      );
      cleaned = true;
    }

    List<
      String
    >
    processRaw =
        prefs.getStringList(
          'process_orders',
        ) ??
        [];
    List<
      String
    >
    validProcess = processRaw.where(
      (
        order,
      ) {
        final data = Uri.splitQueryString(
          order,
        );
        final orderId =
            data['orderId'] ??
            '';
        final totalPrice =
            data['totalPrice'] ??
            'Rp 0';
        int nominal = _parseRupiahToInt(
          totalPrice,
        );
        if (orderId ==
            DummyOrders.dummyOrderId)
          return true;
        return nominal >
            5000;
      },
    ).toList();

    if (validProcess.length !=
        processRaw.length) {
      await prefs.setStringList(
        'process_orders',
        validProcess,
      );
      cleaned = true;
    }

    List<
      String
    >
    completedRaw =
        prefs.getStringList(
          'completed_orders',
        ) ??
        [];
    List<
      String
    >
    validCompleted = completedRaw.where(
      (
        order,
      ) {
        final data = Uri.splitQueryString(
          order,
        );
        final totalPrice =
            data['totalPrice'] ??
            'Rp 0';
        int nominal = _parseRupiahToInt(
          totalPrice,
        );
        return nominal >
            5000;
      },
    ).toList();

    if (validCompleted.length !=
        completedRaw.length) {
      await prefs.setStringList(
        'completed_orders',
        validCompleted,
      );
      cleaned = true;
    }

    if (cleaned) {
      print(
        'Data invalid telah dibersihkan',
      );
    }
  }

  Future<
    void
  >
  _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = widget.loggedIn;

    print(
      '========== MY ORDERS SCREEN ==========',
    );
    print(
      'isLoggedIn: $isLoggedIn',
    );

    if (!isLoggedIn) {
      setState(
        () {
          activeOrders = [];
          processOrders = [];
          completedOrders = [];
          _isLoading = false;
        },
      );
      return;
    }

    await _cleanInvalidOrders();

    final loginMethod =
        prefs.getString(
          'login_method',
        ) ??
        '';
    final isSignIn =
        loginMethod ==
        'signin';

    if (isSignIn) {
      final existingProcess =
          prefs.getStringList(
            'process_orders',
          ) ??
          [];
      final hasDummy = existingProcess.any(
        (
          order,
        ) => order.contains(
          DummyOrders.dummyOrderId,
        ),
      );

      if (!hasDummy) {
        await prefs.setStringList(
          'process_orders',
          DummyOrders.processOrders,
        );
        print(
          'Dummy data injected for Sign In user',
        );
      }
    }

    final List<
      String
    >
    activeRaw =
        prefs.getStringList(
          'active_orders',
        ) ??
        [];
    List<
      String
    >
    processRaw =
        prefs.getStringList(
          'process_orders',
        ) ??
        [];
    final List<
      String
    >
    completedRaw =
        prefs.getStringList(
          'completed_orders',
        ) ??
        [];

    if (!isSignIn) {
      processRaw = processRaw
          .where(
            (
              order,
            ) => !order.contains(
              DummyOrders.dummyOrderId,
            ),
          )
          .toList();
    }

    setState(
      () {
        activeOrders = _parseOrdersList(
          activeRaw,
        );
        processOrders = _parseOrdersList(
          processRaw,
        );
        completedOrders = _parseOrdersList(
          completedRaw,
        );
        _isLoading = false;
      },
    );
  }

  List<
    Map<
      String,
      dynamic
    >
  >
  _parseOrdersList(
    List<
      String
    >
    ordersRaw,
  ) {
    final List<
      Map<
        String,
        dynamic
      >
    >
    orders = [];

    for (String orderString in ordersRaw) {
      final data = Uri.splitQueryString(
        orderString,
      );

      List<
        Map<
          String,
          dynamic
        >
      >
      orderItems = [];
      if (data['itemsJson'] !=
              null &&
          data['itemsJson']!.isNotEmpty) {
        try {
          final decoded = jsonDecode(
            data['itemsJson']!,
          );
          if (decoded
              is List) {
            orderItems = decoded
                .cast<
                  Map<
                    String,
                    dynamic
                  >
                >();
          }
        } catch (
          e
        ) {
          debugPrint(
            'Error decoding itemsJson: $e',
          );
        }
      }

      orders.add(
        {
          'orderId':
              data['orderId'] ??
              '000000',
          'service':
              data['service'] ??
              'Laundry',
          'qty':
              data['qty'] ??
              '1',
          'pickupTime':
              data['pickupTime'] ??
              '-',
          'deliveryTime':
              data['deliveryTime'] ??
              '-',
          'totalPrice':
              data['totalPrice'] ??
              'Rp 0',
          'address':
              data['address'] ??
              'Alamat tidak tersedia',
          'itemsJson': data['itemsJson'],
          'orderItems': orderItems,
          'deliveryFee':
              data['deliveryFee'] ??
              '5000',
        },
      );
    }

    return orders;
  }

  int _safeToInt(
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
      return int.tryParse(
            value,
          ) ??
          0;
    }
    return 0;
  }

  String _getServiceTitle(
    Map<
      String,
      dynamic
    >
    order,
  ) {
    final orderItems =
        order['orderItems']
            as List<
              Map<
                String,
                dynamic
              >
            >?;
    if (orderItems !=
            null &&
        orderItems.isNotEmpty) {
      final titles = orderItems
          .map(
            (
              item,
            ) =>
                item['title'] ??
                item['name'] ??
                'Layanan',
          )
          .toList();
      return titles.join(
        ', ',
      );
    }
    return order['service'] ??
        'Laundry';
  }

  int _getTotalPrice(
    Map<
      String,
      dynamic
    >
    order,
  ) {
    final totalPriceStr = order['totalPrice'].toString();
    final number = _parseRupiahToInt(
      totalPriceStr,
    );
    return number;
  }

  String _getDateLabel(
    String pickupTime,
  ) {
    try {
      final pickup = DateTime.parse(
        pickupTime,
      );
      return '${pickup.day} ${_getMonthName(pickup.month)} ${pickup.year}';
    } catch (
      e
    ) {
      return pickupTime;
    }
  }

  String _getMonthName(
    int month,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month -
        1];
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: ColoredBox(
        color: AppColors.ordersNavy,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Text(
                'Pesanan Saya',
                style: AppTextStyles.screenTitleWhite,
              ),
              const SizedBox(
                height: 12,
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: RoundedWhitePanel(
                    topRadius: 40,
                    padding: const EdgeInsets.all(
                      AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        OrderStatusSegmentedBar(
                          selectedIndex: _tab,
                          onChanged:
                              (
                                i,
                              ) => setState(
                                () => _tab = i,
                              ),
                        ),
                        const SizedBox(
                          height: AppSpacing.lg,
                        ),
                        Expanded(
                          child: _buildContent(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_tab ==
        0) {
      if (activeOrders.isEmpty) {
        return const _EmptyOrdersState(
          message: 'Belum ada pesanan aktif',
          subtitle: 'Pesanan kamu akan tampil di sini setelah melakukan order.',
        );
      }
      return _buildOrderList(
        activeOrders,
        'active',
      );
    } else if (_tab ==
        1) {
      if (processOrders.isEmpty) {
        return const _EmptyOrdersState(
          message: 'Belum ada pesanan dalam proses',
          subtitle: 'Pesanan yang sedang dijemput atau diproses akan tampil di sini.',
        );
      }
      return _buildOrderList(
        processOrders,
        'process',
      );
    } else {
      if (completedOrders.isEmpty) {
        return const _EmptyOrdersState(
          message: 'Belum ada riwayat pesanan',
          subtitle: 'Pesanan yang sudah selesai akan tampil di sini.',
        );
      }
      return _buildOrderList(
        completedOrders,
        'completed',
      );
    }
  }

  Widget _buildOrderList(
    List<
      Map<
        String,
        dynamic
      >
    >
    orders,
    String status,
  ) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder:
          (
            context,
            index,
          ) {
            final order = orders[index];
            final orderId = order['orderId'];
            final serviceTitle = _getServiceTitle(
              order,
            );

            final int totalPrice = _getTotalPrice(
              order,
            );

            final bool isDummyOrder =
                orderId ==
                '100001';

            final int shippingFeeForDisplay = isDummyOrder
                ? 5000
                : 0;
            final int grandTotal =
                totalPrice +
                shippingFeeForDisplay;

            final int deliveryFee = _safeToInt(
              order['deliveryFee'] ??
                  '5000',
            );
            final dateLabel = _getDateLabel(
              order['pickupTime'],
            );

            return PesananOrderCard(
              orderId: 'No. Pesanan $orderId',
              dateLabel: dateLabel,
              serviceTitle: serviceTitle,
              totalLabel: _formatRupiah(
                grandTotal,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/order-detail',
                  arguments: {
                    ...order,
                    'fromActiveOrder':
                        status ==
                        'active',
                    'fromProcessOrder':
                        status ==
                        'process',
                    'deliveryFee': deliveryFee,
                  },
                );
              },
            );
          },
    );
  }
}

class _EmptyOrdersState
    extends
        StatelessWidget {
  const _EmptyOrdersState({
    this.message = 'Belum ada pesanan',
    this.subtitle = 'Pesanan kamu akan tampil di sini setelah melakukan order.',
  });

  final String message;
  final String subtitle;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: AppColors.textMuted,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              message,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
