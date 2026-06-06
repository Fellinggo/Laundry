import 'package:flutter/material.dart';
import 'package:wushlaundry/controllers/offer_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/promo_card_widget.dart';
import '../../models/offer_model.dart';

class OffersScreen
    extends
        StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    final controller = OffersController(
      loggedIn: loggedIn,
      onOpenNotifications: onOpenNotifications,
      onOpenServices: onOpenServices,
    );

    return Scaffold(
      backgroundColor: AppColors.headerNavy,
      body: Column(
        children: [
          NavyCenterTitleAppBar(
            title: 'Tawaranku',
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: GestureDetector(
                  onTap: () => controller.handleNotificationTap(
                    context,
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
          Expanded(
            child: Container(
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
                    if (controller.getNewUserOffers().isNotEmpty) ...[
                      Text(
                        controller.getNewUserOffers().first.category.displayTitle,
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(
                        height: AppSpacing.md,
                      ),
                      ...controller.getNewUserOffers().map(
                        (
                          offer,
                        ) => PromoCardWidget(
                          imagePath: offer.imagePath,
                          onTap: () => controller.handlePromoCardTap(
                            context,
                            offer,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.xl,
                      ),
                    ],

                    // Special Offers Section
                    if (controller.getSpecialOffers().isNotEmpty) ...[
                      Text(
                        controller.getSpecialOffers().first.category.displayTitle,
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(
                        height: AppSpacing.md,
                      ),
                      ...controller.getSpecialOffers().map(
                        (
                          offer,
                        ) => PromoCardWidget(
                          imagePath: offer.imagePath,
                          onTap: () => controller.handlePromoCardTap(
                            context,
                            offer,
                          ),
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
