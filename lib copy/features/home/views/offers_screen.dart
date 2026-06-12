import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data1/models/static/offer_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../shared/widgets/navy_app_bar.dart';
import '../../shared/widgets/promo_card_widget.dart';
import '../controllers/offer_controller.dart';


class OffersScreen extends StatelessWidget {
  const OffersScreen({
    super.key,
    this.onOpenNotifications,
    this.loggedIn = false,
    this.onOpenServices,
  });

  final VoidCallback? onOpenNotifications;
  final bool loggedIn;
  final VoidCallback? onOpenServices;

  @override
  Widget build(BuildContext context) {
    // Mengakses OffersController secara reaktif melalui Provider
    final controller = context.watch<OffersController>();

    // Menjaga sinkronisasi state login jika terjadi pembaruan dari MainShell
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateLoginStatus(loggedIn);
    });

    final newUserOffers = controller.getNewUserOffers();
    final specialOffers = controller.getSpecialOffers();

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      body: Column(
        children: [
          NavyCenterTitleAppBar(
            title: 'Tawaranku',
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => controller.handleNotificationTap(context),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // New User Offers Section
                    if (newUserOffers.isNotEmpty) ...[
                      Text(
                        newUserOffers.first.category.displayTitle,
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...newUserOffers.map(
                        (offer) => PromoCardWidget(
                          imagePath: offer.imagePath,
                          onTap: () =>
                              controller.handlePromoCardTap(context, offer),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // Special Offers Section
                    if (specialOffers.isNotEmpty) ...[
                      Text(
                        specialOffers.first.category.displayTitle,
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...specialOffers.map(
                        (offer) => PromoCardWidget(
                          imagePath: offer.imagePath,
                          onTap: () =>
                              controller.handlePromoCardTap(context, offer),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
