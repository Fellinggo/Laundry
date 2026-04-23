import 'package:flutter/material.dart';
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
    this.hasOrders = false,
  });

  final bool loggedIn;
  final bool hasOrders;

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _tab = 0;

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

  /// ================= CONTENT =================
  Widget _buildContent() {
    if (!widget.loggedIn || !widget.hasOrders) {
      return const _EmptyOrdersState();
    }

    if (_tab == 2) {
      return const _DummyHistory();
    }

    return const _EmptyOrdersState();
  }
}

/// ================= EMPTY STATE =================
class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState();

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
              'Belum ada pesanan',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan kamu akan tampil di sini setelah melakukan order.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= RIWAYAT (DUMMY) =================
class _DummyHistory extends StatelessWidget {
  const _DummyHistory();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        PesananOrderCard(
          customerName: 'Aurora Emilia',
          orderId: 'No. Pesanan 001016',
          dateLabel: '16 Juli 2025',
          serviceTitle: 'Cuci Setrika',
          priceLabel: 'Rp28.000/plastik',
          qty: 2,
          shippingLabel: 'Biaya Pengiriman: Rp5.000',
          totalLabel: 'Rp61.000',
        ),
        SizedBox(height: 12),
        PesananOrderCard(
          customerName: 'Aurora Emilia',
          orderId: 'No. Pesanan 000998',
          dateLabel: '12 Juli 2025',
          serviceTitle: 'Cuci Regular',
          priceLabel: 'Rp20.000/plastik',
          qty: 1,
          shippingLabel: 'Biaya Pengiriman: Rp5.000',
          totalLabel: 'Rp25.000',
        ),
      ],
    );
  }
}