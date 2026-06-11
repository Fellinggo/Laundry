import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Pastikan ini diimport
import 'package:wushlaundry/controllers/notification_controller.dart';
import '../widgets/login_modal_sheet.dart';
import '../widgets/offer_image_slider.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/section_header_row.dart';
import '../widgets/service_card_compact.dart';
import '../widgets/active_order_card.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../../data/service_dummy.dart';
import '../../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
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
  final Function(Map<String, dynamic>)? onOpenServiceDetail;
  final VoidCallback? onOpenDisc;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeController>().refreshData();
      }
    });
  }

  final homeServices = serviceDummy.where((e) => !e.isWide).take(3).toList();

  // Method pembantu jika MainShellController butuh pemicu refresh data user
  Future<void> refreshUserData() async {
    if (mounted) {
      await context.read<HomeController>().refreshUserData();
    }
  }

  Widget _buildEmptyOrderBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            color: Colors.grey.shade400,
            size: 40,
          ),
          const SizedBox(height: 8),
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

  void _handleServiceTap(
    BuildContext context,
    HomeController homeProvider,
    Map<String, dynamic> service,
  ) {
    if (!homeProvider.isLoggedIn) {
      showLoginModal(context);
      return;
    }
    widget.onOpenServiceDetail?.call(service);
  }

  void _handleNotificationTap(
    BuildContext context,
    HomeController homeProvider,
  ) {
    if (!homeProvider.isLoggedIn) {
      showLoginModal(context);
      return;
    }
    widget.onOpenNotifications?.call();
  }

  Future<void> _handleOfferTap(
    BuildContext context,
    HomeController homeProvider,
    int index,
  ) async {
    if (!homeProvider.isLoggedIn) {
      showLoginModal(context);
      return;
    }

    List<String?> promoCodes = ['SSSd789', 'PAYDAYWUSH', 'BERSIHSPREI'];
    String? code = promoCodes[index];

    if (code != null) {
      await homeProvider.copyPromoCodeToClipboard(context, code);
    }

    await Future.delayed(const Duration(milliseconds: 500));
    widget.onOpenServices?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan state secara reaktif via context.watch
    final homeProvider = context.watch<HomeController>();

    return ColoredBox(
      color: AppColors.headerNavy,
      child: Column(
        children: [
          HomeNavyHeaderBlock(
            onNotification: () => _handleNotificationTap(context, homeProvider),
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
                child: RefreshIndicator(
                  // Fitur tarik ke bawah untuk refresh data otomatis
                  onRefresh: () => homeProvider.refreshData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (homeProvider.isLoggedIn &&
                            homeProvider.userFirstName != null) ...[
                          Text(
                            'Hi ${homeProvider.userFirstName} 👋',
                            style: AppTextStyles.screenTitleNavy.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        const SectionHeaderRow(title: 'Layanan Laundry Kami'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ServiceCardCompact(
                                      title: homeServices[0].title,
                                      priceLabel: homeServices[0].price,
                                      etaLabel: homeServices[0].eta,
                                      etaType: homeServices[0].etaType,
                                      onTap: () => _handleServiceTap(
                                        context,
                                        homeProvider,
                                        {
                                          'title': homeServices[0].title,
                                          'price': homeServices[0].price,
                                          'eta': homeServices[0].eta,
                                          'type': homeServices[0].etaType,
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ServiceCardCompact(
                                      title: homeServices[1].title,
                                      priceLabel: homeServices[1].price,
                                      etaLabel: homeServices[1].eta,
                                      etaType: homeServices[1].etaType,
                                      onTap: () => _handleServiceTap(
                                        context,
                                        homeProvider,
                                        {
                                          'title': homeServices[1].title,
                                          'price': homeServices[1].price,
                                          'eta': homeServices[1].eta,
                                          'type': homeServices[1].etaType,
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => widget.onOpenServices?.call(),
                              child: Container(
                                height: 100,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: AppColors.headerNavy,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const SectionHeaderRow(title: 'Pesanan Aktif'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: homeProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : homeProvider.activeOrders.isEmpty
                              ? _buildEmptyOrderBox()
                              : PageView.builder(
                                  controller: PageController(
                                    viewportFraction: 0.9,
                                    initialPage: 0,
                                  ),
                                  itemCount: homeProvider.activeOrders.length,
                                  padEnds: false,
                                  itemBuilder: (context, index) {
                                    final order =
                                        homeProvider.activeOrders[index];
                                    final displayTotal = homeProvider
                                        .getDisplayTotal(order);
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/order-detail',
                                          arguments: {
                                            ...order.toJson(),
                                            'fromActiveOrder': true,
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: ActiveOrderCard(
                                          statusTitle:
                                              'Pesanan ${order.orderId}',
                                          subtitle:
                                              'Pickup: ${order.pickupTime}\nDelivery: ${order.deliveryTime}',
                                          totalPrice: displayTotal,
                                          currentStep: order.currentStep,
                                          badgeLabel: order.badgeLabel,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SectionHeaderRow(
                          title: 'Penawaran Khusus',
                          actionLabel: 'Lainnya',
                          onAction: () => widget.onOpenDisc?.call(),
                        ),
                        OfferImageAutoSlider(
                          onTap: (index) =>
                              _handleOfferTap(context, homeProvider, index),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
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

class HomeNavyHeaderBlock extends StatelessWidget {
  const HomeNavyHeaderBlock({super.key, this.onNotification});

  final VoidCallback? onNotification;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      color: AppColors.headerNavy,
      padding: EdgeInsets.fromLTRB(20, top + 15, 20, 20),
      child: Row(
        children: [
          Image.asset('assets/images/logo_white.png', height: 75),
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
