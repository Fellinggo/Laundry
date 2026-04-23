import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'primary_button.dart';

void
showLoginModal(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder:
        (
          _,
        ) => const _LoginModalCard(),
  );
}

class _LoginModalCard
    extends
        StatelessWidget {
  const _LoginModalCard();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom:
            MediaQuery.paddingOf(
              context,
            ).bottom +
            AppSpacing.xl,
      ),
      child: Center(
        child: Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            20,
          ),
          child: Stack(
            children: [
              // ====== TOMBOL CLOSE ======
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  color: AppColors.textMuted,
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),

              // ====== CONTENT ======
              Padding(
                padding: const EdgeInsets.all(
                  AppSpacing.xxl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      'Masuk ke Akun Anda',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      'Anda harus masuk terlebih dahulu untuk melanjutkan tindakan ini.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMuted,
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    // ====== LOGIN EMAIL ======
                    PrimaryButton(
                      label: 'Masuk dengan Email',
                      leading: const Icon(
                        Icons.email_outlined,
                        color: AppColors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                        Navigator.pushNamed(
                          context,
                          '/login',
                        );
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // ====== SIGN UP ======
                    PrimaryButton(
                      label: 'Sign Up',
                      backgroundColor: AppColors.accentBlue,
                      leading: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: AppColors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                        Navigator.pushNamed(
                          context,
                          '/register',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
