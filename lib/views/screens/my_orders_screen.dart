import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/my_order_controller.dart';
import 'package:wushlaundry/models/user_order_model.dart';
import 'package:wushlaundry/views/widgets/empty_order_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/order_status_segmented_bar.dart';
import '../widgets/pesanan_order_card.dart';
import '../widgets/rounded_white_panel.dart';


class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key, this.loggedIn = false});

  final bool loggedIn;

  @override
  State<MyOrdersScreen> createState() => MyOrdersScreenState();
}

class MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Inisialisasi controller setelah widget terpasang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<MyOrdersController>();
      controller.updateLoginStatus(widget.loggedIn);
    });
  }

  @override
  void didUpdateWidget(MyOrdersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loggedIn != widget.loggedIn) {
      final controller = context.read<MyOrdersController>();
      controller.updateLoginStatus(widget.loggedIn);
    }
  }

  // METHOD UNTUK REFRESH DARI LUAR
  Future<void> refreshOrders() async {
    final controller = context.read<MyOrdersController>();
    await controller.loadOrders();
    setState(() {});
    debugPrint('DEBUG - MyOrdersScreen.refreshOrders() dipanggil');
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyOrdersController>();

    return Scaffold(
      body: ColoredBox(
        color: AppColors.ordersNavy,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text('Pesanan Saya', style: AppTextStyles.screenTitleWhite),
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
                          selectedIndex: controller.currentTab,
                          onChanged: (index) => controller.changeTab(index),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Expanded(child: _buildContent(controller)),
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

  Widget _buildContent(MyOrdersController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentTab = controller.currentTab;

    if (currentTab == 0) {
      if (controller.activeOrders.isEmpty) {
        return const EmptyOrdersWidget(
          message: 'Belum ada pesanan aktif',
          subtitle: 'Pesanan kamu akan tampil di sini setelah melakukan order.',
        );
      }
      return _buildOrderList(controller, controller.activeOrders, 'active');
    } else if (currentTab == 1) {
      if (controller.processOrders.isEmpty) {
        return const EmptyOrdersWidget(
          message: 'Belum ada pesanan dalam proses',
          subtitle:
              'Pesanan yang sedang dijemput atau diproses akan tampil di sini.',
        );
      }
      return _buildOrderList(controller, controller.processOrders, 'process');
    } else {
      if (controller.completedOrders.isEmpty) {
        return const EmptyOrdersWidget(
          message: 'Belum ada riwayat pesanan',
          subtitle: 'Pesanan yang sudah selesai akan tampil di sini.',
        );
      }
      return _buildOrderList(
        controller,
        controller.completedOrders,
        'completed',
      );
    }
  }

  Widget _buildOrderList(
    MyOrdersController controller,
    List<UserOrder> orders,
    String status,
  ) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return PesananOrderCard(
          orderId: 'No. Pesanan ${order.orderId}',
          dateLabel: order.dateLabel,
          serviceTitle: order.serviceTitle,
          totalLabel: controller.formatRupiah(order.grandTotal),
          onTap: () => controller.navigateToOrderDetail(context, order, status),
        );
      },
    );
  }
}
