import 'package:flutter/material.dart';
import 'package:wushlaundry/constants/app_colors.dart';
import 'package:wushlaundry/constants/app_spacing.dart';
import 'package:wushlaundry/constants/app_text_styles.dart';
import 'package:wushlaundry/data/service_dummy.dart';
import 'package:wushlaundry/views/widgets/eta_badge.dart';
import 'package:wushlaundry/views/widgets/login_modal_sheet.dart';
import 'package:wushlaundry/views/widgets/navy_app_bar.dart';

class ServicesScreen
    extends
        StatelessWidget {
  const ServicesScreen({
    super.key,
    this.onOpenNotifications,
    this.loggedIn = false,
  });

  final VoidCallback? onOpenNotifications;
  final bool loggedIn;

  void _handleTap(
    BuildContext context,
    VoidCallback action,
  ) {
    if (!loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }
    action();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      appBar: NavyCenterTitleAppBar(
        title: 'Layanan',
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              onTap: () => _handleTap(
                context,
                () => onOpenNotifications?.call(),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          top: 12,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              28,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(
              28,
            ),
          ),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              overscroll: false,
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layanan Lainnya',
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: serviceDummy
                        .where(
                          (
                            e,
                          ) => !e.isWide,
                        )
                        .map(
                          (
                            service,
                          ) => _gridCard(
                            context,
                            title: service.title,
                            price: service.price,
                            eta: service.eta,
                            etaType: service.etaType,
                            imagePath: service.imagePath,
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ...serviceDummy
                      .where(
                        (
                          e,
                        ) => e.isWide,
                      )
                      .map(
                        (
                          service,
                        ) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: _wideCard(
                            context,
                            title: service.title,
                            price: service.price,
                            eta: service.eta,
                            imagePath: service.imagePath,
                          ),
                        ),
                      )
                      .toList(),

                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridCard(
    BuildContext context, {
    required String title,
    required String price,
    required String eta,
    required EtaType etaType,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          255,
          255,
          255,
        ),
        borderRadius: BorderRadius.circular(
          16,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.36,
            ),
            blurRadius: 10,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          16,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleTap(
              context,
              () => Navigator.pushNamed(
                context,
                '/service-detail',
                arguments: {
                  'title': title,
                },
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Image.asset(
                        imagePath,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: EtaBadge(
                          label: eta,
                          type: etaType,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.headerNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _wideCard(
    BuildContext context, {
    required String title,
    required String price,
    required String eta,
    required String imagePath,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.36,
            ),
            blurRadius: 10,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          16,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleTap(
              context,
              () => Navigator.pushNamed(
                context,
                '/service-detail',
                arguments: {
                  'title': title,
                },
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      imagePath,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: EtaBadge(
                        label: eta,
                        type: EtaType.normal,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
