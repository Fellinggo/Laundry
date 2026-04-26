import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/login_modal_sheet.dart';
import 'package:flutter/services.dart';

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

  void _handleTap(BuildContext context) {
    if (!loggedIn) {
      showLoginModal(context);
      return;
    }
    onOpenNotifications?.call();
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => _handleTap(context),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
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
                    Text(
                      'Tawaran Pengguna Baru',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _promoCard(
                      context: context,
                      imagePath: 'assets/images/promos.png',
                      promoCode: 'SSSd789',
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    Text(
                      'Penawaran Khusus',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _promoCard(
                      context: context,
                      imagePath: 'assets/images/pays.png',
                      promoCode: 'PAYDAYWUSH',
                    ),

                    _promoCard(
                      context: context,
                      imagePath: 'assets/images/bedcovers.png',
                      promoCode: 'BERSIHSPREI',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _promoCard({
    required BuildContext context,
    required String imagePath,
    String? promoCode,
  }) {
    return GestureDetector(
      onTap: () async {
        if (!loggedIn) {
          showLoginModal(context);
          return; 
        }

        if (promoCode != null) {
          await Clipboard.setData(
            ClipboardData(text: promoCode),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kode $promoCode berhasil disalin'),
              duration: const Duration(milliseconds: 800),
            ),
          );
        }
        
        await Future.delayed(const Duration(milliseconds: 500));

        onOpenServices?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}