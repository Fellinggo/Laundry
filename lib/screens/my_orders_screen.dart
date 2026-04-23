import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/order_status_segmented_bar.dart';
import '../widgets/pesanan_order_card.dart';
import '../widgets/rounded_white_panel.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({
    super.key,
    this.loggedIn = false,
  });

  final bool loggedIn;

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _tab = 0;
  List<Map<String, dynamic>> activeOrders = [];      // Tab 0: Pesanan
  List<Map<String, dynamic>> processOrders = [];     // Tab 1: Proses
  List<Map<String, dynamic>> completedOrders = [];   // Tab 2: Selesai
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
  void didUpdateWidget(MyOrdersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loggedIn != widget.loggedIn) {
      _loadOrders();
    }
  }

  // ============================================
  // LOAD ORDERS - DIPISAH PER TAB
  // ============================================
  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (!isLoggedIn && !widget.loggedIn) {
      setState(() {
        activeOrders = [];
        processOrders = [];
        completedOrders = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    // Load dari 3 sumber berbeda
    final List<String> activeRaw = prefs.getStringList('active_orders') ?? [];
    final List<String> processRaw = prefs.getStringList('process_orders') ?? [];
    final List<String> completedRaw = prefs.getStringList('completed_orders') ?? [];

    setState(() {
      activeOrders = _parseOrdersList(activeRaw);
      processOrders = _parseOrdersList(processRaw);
      completedOrders = _parseOrdersList(completedRaw);
      _isLoading = false;
    });
  }

  // ============================================
  // PARSE LIST OF ORDER STRINGS
  // ============================================
  List<Map<String, dynamic>> _parseOrdersList(List<String> ordersRaw) {
    final List<Map<String, dynamic>> orders = [];
    
    for (String orderString in ordersRaw) {
      final data = Uri.splitQueryString(orderString);
      
      // Decode itemsJson
      List<Map<String, dynamic>> orderItems = [];
      if (data['itemsJson'] != null && data['itemsJson']!.isNotEmpty) {
        try {
          final decoded = jsonDecode(data['itemsJson']!);
          if (decoded is List) {
            orderItems = decoded.cast<Map<String, dynamic>>();
          }
        } catch (e) {
          debugPrint('Error decoding itemsJson: $e');
        }
      }
      
      orders.add({
        'orderId': data['orderId'] ?? '000000',
        'service': data['service'] ?? 'Laundry',
        'qty': data['qty'] ?? '1',
        'pickupTime': data['pickupTime'] ?? '-',
        'deliveryTime': data['deliveryTime'] ?? '-',
        'totalPrice': data['totalPrice'] ?? 'Rp 0',
        'address': data['address'] ?? 'Alamat tidak tersedia',
        'itemsJson': data['itemsJson'],
        'orderItems': orderItems,
      });
    }
    
    return orders;
  }

  // ============================================
  // FORMAT RUPIAH
  // ============================================
  String _formatRupiah(dynamic value) {
    int number = 0;
    if (value is int) {
      number = value;
    } else if (value is String) {
      number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    } else {
      number = 0;
    }
    
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

  // ============================================
  // SAFE TO INT
  // ============================================
  int _safeToInt(dynamic value) {
    if (value == null) return 1;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 1;
    }
    if (value is double) return value.toInt();
    return 1;
  }

  // ============================================
  // GET SERVICE TITLE
  // ============================================
  String _getServiceTitle(Map<String, dynamic> order) {
    final orderItems = order['orderItems'] as List<Map<String, dynamic>>?;
    if (orderItems != null && orderItems.isNotEmpty) {
      final titles = orderItems.map((item) => item['title'] ?? item['name'] ?? 'Layanan').toList();
      return titles.join(', ');
    }
    return order['service'] ?? 'Laundry';
  }

  // ============================================
  // GET TOTAL PRICE
  // ============================================
  int _getTotalPrice(Map<String, dynamic> order) {
    final orderItems = order['orderItems'] as List<Map<String, dynamic>>?;
    if (orderItems != null && orderItems.isNotEmpty) {
      int total = 0;
      for (var item in orderItems) {
        final qty = _safeToInt(item['qty']);
        final price = _safeToInt(item['price']);
        total += (qty * price);
      }
      return total;
    }
    final totalPriceStr = order['totalPrice'].toString();
    final number = int.tryParse(totalPriceStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return number;
  }

  // ============================================
  // GET DATE LABEL
  // ============================================
  String _getDateLabel(String pickupTime) {
    try {
      final pickup = DateTime.parse(pickupTime);
      return '${pickup.day} ${_getMonthName(pickup.month)} ${pickup.year}';
    } catch (e) {
      return pickupTime;
    }
  }

  // ============================================
  // GET MONTH NAME
  // ============================================
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.ordersNavy,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              'Pesanan Saya',
              style: AppTextStyles.screenTitleWhite,
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20), 
                child: RoundedWhitePanel(
                  topRadius: 40,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      OrderStatusSegmentedBar(
                        selectedIndex: _tab,
                        onChanged: (i) => setState(() => _tab = i),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Expanded(child: _buildContent()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // BUILD CONTENT BERDASARKAN TAB
  // ============================================
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Tab 0: Pesanan (Active Orders)
    if (_tab == 0) {
      if (activeOrders.isEmpty) {
        return const _EmptyOrdersState(
          message: 'Belum ada pesanan aktif',
          subtitle: 'Pesanan kamu akan tampil di sini setelah melakukan order.',
        );
      }
      return _buildOrderList(activeOrders, 'active');
    } 
    // Tab 1: Proses
    else if (_tab == 1) {
      if (processOrders.isEmpty) {
        return const _EmptyOrdersState(
          message: 'Belum ada pesanan dalam proses',
          subtitle: 'Pesanan yang sedang dijemput atau diproses akan tampil di sini.',
        );
      }
      return _buildOrderList(processOrders, 'process');
    } 
    // Tab 2: Selesai
    else {
      if (completedOrders.isEmpty) {
        return const _EmptyOrdersState(
          message: 'Belum ada riwayat pesanan',
          subtitle: 'Pesanan yang sudah selesai akan tampil di sini.',
        );
      }
      return _buildOrderList(completedOrders, 'completed');
    }
  }

  // ============================================
  // BUILD ORDER LIST - TANPA GAMBAR & SUBTOTAL
  // ============================================
  Widget _buildOrderList(List<Map<String, dynamic>> orders, String status) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final orderId = order['orderId'];
        final serviceTitle = _getServiceTitle(order);
        final totalPrice = _getTotalPrice(order);
        final shippingFee = 5000;
        final grandTotal = totalPrice + shippingFee;
        final dateLabel = _getDateLabel(order['pickupTime']);
        
        // Hanya kirim data yang diperlukan ke card
        return PesananOrderCard(
          orderId: 'No. Pesanan $orderId',
          dateLabel: dateLabel,
          serviceTitle: serviceTitle,
          totalLabel: _formatRupiah(grandTotal),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/order-detail',
              arguments: {
                ...order,
                'fromActiveOrder': status == 'active',
                'fromProcessOrder': status == 'process',
                'deliveryFee': shippingFee,
              },
            );
          },
        );
      },
    );
  }
}

/// ================= EMPTY STATE =================
class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState({
    this.message = 'Belum ada pesanan',
    this.subtitle = 'Pesanan kamu akan tampil di sini setelah melakukan order.',
  });

  final String message;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
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