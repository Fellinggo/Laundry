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

  int _calculateTotalServiceFee(List<dynamic> orderItems) {
    if (orderItems.isEmpty) return 0;
    
    int total = 0;
    for (var item in orderItems) {
      if (item.containsKey('subtotal')) {
        total += (item['subtotal'] as int?) ?? 0;
      } else {
        final qty = (item['qty'] as int?) ?? 1;
        final price = (item['price'] as int?) ?? 0;
        total += (qty * price);
      }
    }
    return total;
  }

  String _encodeItemsToJson(List<dynamic> items) {
    String jsonStr = '[';
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      jsonStr += '{';
      jsonStr += '"title":"${item['title'] ?? item['name']}",';
      jsonStr += '"price":${item['price']},';
      jsonStr += '"qty":${item['qty']},';
      jsonStr += '"subtotal":${item['subtotal'] ?? (item['qty'] * item['price'])},';
      jsonStr += '"image":"${item['image'] ?? ''}"';
      jsonStr += '}';
      if (i < items.length - 1) jsonStr += ',';
    }
    jsonStr += ']';
    return jsonStr;
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final name = item['title'] ?? item['name'] ?? 'Layanan';
    final qty = (item['qty'] as int?) ?? 1;
    final price = (item['price'] as int?) ?? 0;
    final subtotal = item['subtotal'] ?? (qty * price);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item['image'] != null && item['image'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['image'],
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
          if (item['image'] != null && item['image'].toString().isNotEmpty) 
            const SizedBox(width: 12),
          
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
                  '${_formatRp(price)} x $qty',
                  style: AppTextStyles.bodyMuted.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          Text(
            _formatRp(subtotal),
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummary(Map args) {
    final List<dynamic> orderItems = args['orderItems'] ?? args['items'] ?? [];
    
    if (orderItems.isEmpty) {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
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
          ),
          
          ...orderItems.map((item) => _buildOrderItem(item as Map<String, dynamic>)),
          
          const Divider(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pesanan',
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

    final List<dynamic> orderItems = args['orderItems'] ?? args['items'] ?? [];
    
    String serviceSummary = '';
    int totalQty = 0;
    
    if (orderItems.isNotEmpty) {
      for (var item in orderItems) {
        final name = item['title'] ?? item['name'] ?? 'Layanan';
        final qty = (item['qty'] as int?) ?? 1;
        serviceSummary += '$name ($qty) + ';
        totalQty += qty;
      }
      if (serviceSummary.endsWith(' + ')) {
        serviceSummary = serviceSummary.substring(0, serviceSummary.length - 3);
      }
      
      final itemsJson = _encodeItemsToJson(orderItems);
      
      String newOrderRaw = 
          "$serviceSummary|"
          "${args['total'] ?? 0}|"
          "${args['pickupTime'] ?? '-'}|"
          "${args['deliveryTime'] ?? '-'}|"
          "${args['address'] ?? '-'}|"
          "$itemsJson";

      currentOrders.add(newOrderRaw);
    } else {
      serviceSummary = args['service'] ?? 'Laundry';
      totalQty = args['qty'] ?? 1;
      
      String newOrderRaw = 
          "service=$serviceSummary&"
          "qty=$totalQty&"
          "pickupTime=${args['pickupTime'] ?? '-'}&"
          "deliveryTime=${args['deliveryTime'] ?? '-'}&"
          "totalPrice=${args['total'] ?? 0}&"
          "address=${args['address'] ?? '-'}";

      currentOrders.add(newOrderRaw);
    }
    
    await prefs.setStringList('active_orders', currentOrders);

    if (!mounted) return;
    setState(() => _payLoading = false);

    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        ...args,
        'orderItems': orderItems,
        'serviceSummary': serviceSummary,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    
    final List<dynamic> orderItems = args['orderItems'] ?? args['items'] ?? [];
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
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                0,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: const _NoOverscrollBehavior(),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ringkasan Pesanan',
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            _buildServiceSummary(args),
                            
                            const SizedBox(height: 24),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Detail Pengiriman',
                                  style: AppTextStyles.sectionTitle.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _buildEditButton(() => Navigator.pop(context)),
                              ],
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
                            
                            Text(
                              'Detail Pembayaran',
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
                                    label: 'Total Pesanan',
                                    value: _formatRp(calculatedServiceFee),
                                  ),
                                  InfoKvRow(
                                    label: 'Biaya Pengiriman',
                                    value: _formatRp(deliveryFee),
                                  ),
                                  const Divider(height: 16),
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
                            
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(
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
                          'serviceFee': calculatedServiceFee,
                          'total': totalPayment,
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

class _NoOverscrollBehavior extends ScrollBehavior {
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
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}