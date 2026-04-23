import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/widgets/eta_badge.dart';
import 'package:wushlaundry/widgets/login_modal_sheet.dart';
import 'package:wushlaundry/widgets/offer_image_slider.dart';
import 'package:wushlaundry/widgets/rounded_white_panel.dart';
import 'package:wushlaundry/widgets/section_header_row.dart';
import 'package:wushlaundry/widgets/service_card_compact.dart';
import 'package:wushlaundry/widgets/active_order_card.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class HomeScreen
    extends
        StatefulWidget {
  const HomeScreen({
    super.key,
    this.loggedIn = false,
    this.userFirstName,
    this.onOpenNotifications,
    this.onOpenServices,
    this.onOpenServiceDetail,
    this.onOpenDisc,
  });

  final bool loggedIn;
  final String? userFirstName;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenServices;
  final Function(
    Map<String, dynamic>,
  )? onOpenServiceDetail;
  final VoidCallback? onOpenDisc;
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState
    extends
        State<HomeScreen> {
  Widget _buildEmptyOrderBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(
          AppSpacing.cardRadius,
        ),
        border: Border.all(
          color: AppColors.borderLight,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            color: Colors.grey.shade400,
            size: 40,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Belum ada pesanan aktif",
            style: AppTextStyles.bodyMuted.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> activeOrders = [];

  final List<Map<String, dynamic>> items = [
    {
      'title': 'Cuci Regular',
      'price': 'Rp 20.000/plastik',
      'eta': 'ETA 10 jam',
      'type': EtaType.normal,
    },
    {
      'title': 'Cuci Setrika',
      'price': 'Rp 28.000/plastik',
      'eta': 'ETA 11 jam',
      'type': EtaType.fast,
    },
    {
      'title': 'Cuci Kering',
      'price': 'Rp 23.000/plastik',
      'eta': 'ETA 12 jam',
      'type': EtaType.long,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadActiveOrder();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadActiveOrder();
  }

  // ✅ FUNGSI LOAD ORDER - SUDAH DIPERBAIKI
  Future<void> loadActiveOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;

    if (!isLogin) {
      setState(
        () => activeOrders = [],
      );
      return;
    }

    final List<String> ordersRaw =
        prefs.getStringList(
              'active_orders',
            ) ??
            [];

    print(
      'Jumlah pesanan di SharedPreferences: ${ordersRaw.length}',
    );

    // ✅ FILTER: Hanya ambil yang valid
    final List<String> validOrders = ordersRaw.where((orderString) {
      final data = Uri.splitQueryString(orderString);
      final String orderId = data['orderId'] ?? '';
      return orderId.isNotEmpty && orderId != '000000';
    }).toList();

    // Simpan ulang jika ada data tidak valid
    if (validOrders.length != ordersRaw.length) {
      await prefs.setStringList('active_orders', validOrders);
      print('🧹 Data tidak valid dibersihkan. Sebelum: ${ordersRaw.length}, Sesudah: ${validOrders.length}');
    }

    setState(
      () {
        activeOrders = validOrders.map(
          (e) {
            final data = Uri.splitQueryString(e);  // ✅ MEMBACA DATA
            return {
              'orderId': data['orderId'] ?? '000000',  // ✅ AMBIL ORDER ID
              'service': data['service'] ?? 'Cuci Regular',
              'qty': data['qty'] ?? '1',
              'pickupTime': data['pickupTime'] ?? '-',
              'deliveryTime': data['deliveryTime'] ?? '-',
              'totalPrice': data['totalPrice'] ?? 'Rp 0',
            };
          },
        ).toList();
      },
    );

    print(
      'Active orders loaded: ${activeOrders.length}',
    );
    for (
      var order in activeOrders
    ) {
      print(
        '   - Order ID: ${order['orderId']}',
      );
    }
  }

  void _handleServiceTap(
    BuildContext context,
    Map<String, dynamic> service,
  ) {
    if (!widget.loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }
    widget.onOpenServiceDetail?.call(
      service,
    );
  }

  void _handleNotificationTap(
    BuildContext context,
  ) {
    if (!widget.loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }
    widget.onOpenNotifications?.call();
  }

  void _handleOfferTap(
    BuildContext context,
    int index,
  ) async {
    if (!widget.loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }

    List<String?> promoCodes = [
      'SSSd789',
      'PAYDAYWUSH',
      'BERSIHSPREI'
    ];
    String? code = promoCodes[index];

    if (code != null) {
      await Clipboard.setData(
        ClipboardData(
          text: code,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Kode $code berhasil disalin',
            ),
            duration: const Duration(
              milliseconds: 800,
            ),
          ),
        );
      }
    }

    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );
    widget.onOpenServices?.call();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return ColoredBox(
      color: AppColors.headerNavy,
      child: Column(
        children: [
          HomeNavyHeaderBlock(
            onNotification: () =>
                _handleNotificationTap(
                  context,
                ),
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
              child: ScrollConfiguration(
                behavior: const _NoOverscrollBehavior(),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      if (widget.loggedIn &&
                          widget.userFirstName !=
                              null) ...[
                        Text(
                          'Hi ${widget.userFirstName} 👋',
                          style: AppTextStyles
                              .screenTitleNavy
                              .copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],

                      const SectionHeaderRow(
                        title:
                            'Layanan Laundry Kami',
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      // BARIS LAYANAN
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ServiceCardCompact(
                                    title: items[0]
                                        ['title'],
                                    priceLabel: items[0]
                                        ['price'],
                                    etaLabel: items[0]
                                        ['eta'],
                                    etaType: items[0]
                                        ['type'],
                                    selected: false,
                                    onTap: () =>
                                        _handleServiceTap(
                                      context,
                                      items[0],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: ServiceCardCompact(
                                    title: items[1]
                                        ['title'],
                                    priceLabel: items[1]
                                        ['price'],
                                    etaLabel: items[1]
                                        ['eta'],
                                    etaType: items[1]
                                        ['type'],
                                    selected: false,
                                    onTap: () =>
                                        _handleServiceTap(
                                      context,
                                      items[1],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () => widget
                                .onOpenServices
                                ?.call(),
                            child: Container(
                              height: 100,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors
                                    .grey
                                    .shade100,
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                                border: Border.all(
                                  color: Colors
                                      .grey
                                      .shade300,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,
                                  size: 18,
                                  color: AppColors
                                      .headerNavy,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: AppSpacing.xl,
                      ),
                      const SectionHeaderRow(
                        title: 'Pesanan Aktif',
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      // Bagian Box Pesanan Aktif
                      SizedBox(
                        height: 180,
                        child: activeOrders.isEmpty
                            ? _buildEmptyOrderBox()
                            : PageView.builder(
                                controller: PageController(
                                  viewportFraction:
                                      0.9,
                                  initialPage: 0,
                                ),
                                itemCount:
                                    activeOrders.length,
                                padEnds: false,
                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {
                                  final order =
                                      activeOrders[
                                          index];
                                  return GestureDetector(
                                    behavior: HitTestBehavior
                                        .opaque,
                                    onTap: () {
                                      // Parse itemsJson jika ada untuk menampilkan detail lengkap
                                      final itemsJson = order['itemsJson'];
                                      
                                      if (itemsJson != null && itemsJson.isNotEmpty) {
                                        try {
                                          // Decode itemsJson jika ada (format JSON string)
                                          // Asumsikan itemsJson sudah dalam bentuk List atau Map
                                          if (itemsJson is String) {
                                            // Jika masih string JSON, parse dulu
                                            // orderItems = jsonDecode(itemsJson);
                                            // Untuk sementara, gunakan pendekatan sederhana
                                          } else if (itemsJson is List) {
                                          }
                                        } catch (e) {
                                          print('Error parsing itemsJson: $e');
                                        }
                                      }
                                      
                                      Navigator.pushNamed(
                                        context,
                                        '/order-detail',
                                        arguments: {
                                          ...order,
                                          'fromActiveOrder': true, // Tambahkan orderItems untuk detail lengkap
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12,
                                      ),
                                      child: ActiveOrderCard(
                                        statusTitle:
                                            'Pesanan ${order['orderId']}',
                                        subtitle:
                                            'Pickup: ${order['pickupTime']}\nDelivery: ${order['deliveryTime']}',
                                        totalPrice:
                                            order['totalPrice'],
                                        currentStep:
                                            0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(
                        height: AppSpacing.xl,
                      ),
                      SectionHeaderRow(
                        title: 'Penawaran Khusus',
                        actionLabel: 'Lainnya',
                        onAction: () =>
                            widget.onOpenDisc
                                ?.call(),
                      ),

                      OfferImageAutoSlider(
                        onTap: (
                          index,
                        ) =>
                            _handleOfferTap(
                          context,
                          index,
                        ),
                      ),

                      const SizedBox(
                        height: 24,
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

// ================= HEADER =================
class HomeNavyHeaderBlock
    extends
        StatelessWidget {
  const HomeNavyHeaderBlock({
    super.key,
    this.onNotification,
  });

  final VoidCallback? onNotification;

  @override
  Widget build(
    BuildContext context,
  ) {
    final top =
        MediaQuery.of(
          context,
        ).padding.top;

    return Container(
      color: AppColors.headerNavy,
      padding: EdgeInsets.fromLTRB(
        20,
        top + 15,
        20,
        20,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo_white.png',
            height: 75,
          ),
          const Spacer(),
          IconButton(
            onPressed: onNotification,
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= NO OVERSCROLL BEHAVIOR =================
class _NoOverscrollBehavior
    extends
        ScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(
    BuildContext context,
  ) {
    return const ClampingScrollPhysics();
  }
}