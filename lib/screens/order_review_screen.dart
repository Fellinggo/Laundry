import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/info_kv_row.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class OrderReviewScreen extends StatefulWidget {
  const OrderReviewScreen({super.key});

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  bool _payLoading = false;

  String _formatRp(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
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
    final result = buffer.toString().split('').reversed.join();
    return 'Rp $result';
  }

  // ============================================
  // HITUNG TOTAL SERVICE FEE DARI ORDER ITEMS
  // ============================================
  // ============================================
// HITUNG TOTAL SERVICE FEE DARI ORDER ITEMS
// ============================================
int _calculateTotalServiceFee(List<dynamic> orderItems) {
  if (orderItems.isEmpty) return 0;
  
  int total = 0;
  for (var item in orderItems) {
    final qty = (item['qty'] as int?) ?? 1;
    final price = (item['price'] as int?) ?? 0;
    total = total + (qty * price);
  }
  return total;
}

  // Widget untuk menampilkan item pesanan
  Widget _buildOrderItem(String name, int qty, int pricePerItem) {
    final totalPrice = qty * pricePerItem;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama layanan dan quantity
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  'x$qty',
                  style: AppTextStyles.bodyMuted.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Harga satuan dan total
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatRp(pricePerItem),
                  style: AppTextStyles.bodyMuted.copyWith(
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatRp(totalPrice),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan semua layanan yang dipesan
  Widget _buildServiceSummary(Map args) {
    final List<dynamic> orderItems = args['orderItems'] ?? [];
    
    if (orderItems.isEmpty) {
      // Fallback jika tidak ada orderItems (format lama)
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args['service'] ?? 'Layanan',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${args['qty'] ?? 1} x ${_formatRp(args['serviceFee'] ?? 0)}',
                    style: AppTextStyles.bodyMuted,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Layanan',
                  style: AppTextStyles.caption,
                ),
                Text(
                  _formatRp(args['serviceFee'] ?? 0),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Format baru dengan multiple items
    final totalServiceFee = _calculateTotalServiceFee(orderItems);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Layanan',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Harga',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // List layanan
          ...orderItems.map((item) {
            final name = item['name'] ?? 'Layanan';
            final qty = item['qty'] ?? 1;
            final price = item['price'] ?? 0;
            
            return _buildOrderItem(name, qty, price);
          }),
          
          const Divider(height: 24),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Layanan',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatRp(totalServiceFee),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(VoidCallback onEdit) {
    return TextButton.icon(
      onPressed: onEdit,
      icon: const Icon(Icons.edit_outlined, size: 16),
      label: Text(
        'Edit',
        style: AppTextStyles.bodyMuted.copyWith(
          color: AppColors.actionBlue,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Future<void> _processPayment(Map args) async {
    setState(() => _payLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    List<String> currentOrders = prefs.getStringList('active_orders') ?? [];

    final List<dynamic> orderItems = args['orderItems'] ?? [];
    
    String serviceNames;
    int totalQty;
    
    if (orderItems.isNotEmpty) {
      serviceNames = orderItems.map((item) => '${item['name']} (${item['qty']})').join(' + ');
      totalQty = orderItems.fold(0, (sum, item) => sum + (item['qty'] as int));
    } else {
      serviceNames = args['service'] ?? 'Laundry';
      totalQty = args['qty'] ?? 1;
    }

    String newOrderRaw = 
        "service=$serviceNames&"
        "qty=$totalQty&"
        "pickupTime=${args['pickupTime'] ?? '-'}&"
        "deliveryTime=${args['deliveryTime'] ?? '-'}&"
        "totalPrice=${args['total'] ?? 0}&"
        "address=${args['address'] ?? '-'}";

    currentOrders.add(newOrderRaw);
    await prefs.setStringList('active_orders', currentOrders);

    if (!mounted) return;
    setState(() => _payLoading = false);

    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        ...args,
        'orderItems': orderItems,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    
    // ============================================
    // HITUNG ULANG TOTAL JIKA PERLU
    // ============================================
    final List<dynamic> orderItems = args['orderItems'] ?? [];
    final calculatedServiceFee = orderItems.isNotEmpty 
        ? _calculateTotalServiceFee(orderItems) 
        : (args['serviceFee'] ?? 0);
    
    final deliveryFee = args['deliveryFee'] ?? 5000;
    final totalPayment = calculatedServiceFee + deliveryFee;

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyBackAppBar(
        title: 'Tinjau Pesanan',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: RoundedWhitePanel(
              topRadius: AppSpacing.sheetTopRadius,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER LAYANAN + EDIT =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ringkasan Layanan',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _buildEditButton(() => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // ================= SERVICE SUMMARY =================
                  _buildServiceSummary(args),
                  
                  const SizedBox(height: 24),
                  
                  // ================= INFO PICKUP & DELIVERY =================
                  Text(
                    'Detail Pengiriman',
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        InfoKvRow(
                          label: 'Waktu Pengambilan',
                          value: args['pickupTime'] ?? '-',
                          valueBold: true,
                        ),
                        InfoKvRow(
                          label: 'Waktu Pengiriman',
                          value: args['deliveryTime'] ?? '-',
                          valueBold: true,
                        ),
                        InfoKvRow(
                          label: 'Alamat Pengiriman',
                          value: args['address'] ?? '-',
                          valueBold: true,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // ================= DETAIL PEMBAYARAN =================
                  Text(
                    'Detail Pembayaran',
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                 // Container Detail Pembayaran
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      InfoKvRow(
                        label: 'Biaya Layanan',
                        value: _formatRp(calculatedServiceFee),
                      ),
                      InfoKvRow(
                        label: 'Biaya Pengiriman',
                        value: _formatRp(deliveryFee),
                      ),
                      const Divider(height: 16),
                      // Ganti InfoKvRow dengan Row custom untuk total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: AppTextStyles.bodyMuted.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatRp(totalPayment),
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                  
                  const Spacer(),
                  
                  // ================= BUTTON BAYAR =================
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.headerNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                        ),
                      ),
                      onPressed: _payLoading ? null : () => _processPayment({
                        ...args,
                        'serviceFee': calculatedServiceFee, // Update serviceFee
                        'total': totalPayment, // Update total
                      }),
                      child: _payLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Bayar',
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}