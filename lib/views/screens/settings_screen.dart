import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/setting_controller.dart';
import 'package:wushlaundry/controllers/main_shell_controller.dart';
import 'package:wushlaundry/views/widgets/setting_tile_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class SettingsScreen
    extends
        StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ChangeNotifierProvider<
      SettingsController
    >(
      create:
          (
            _,
          ) => SettingsController(),
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent
    extends
        StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = context
        .read<
          SettingsController
        >();

    // Menyeleksi variabel secara atomik menggunakan context.select untuk efisiensi render tingkat tinggi
    final isLoggedIn =
        context.select<
          SettingsController,
          bool
        >(
          (
            c,
          ) => c.isLoggedIn,
        );
    final currentLanguageName =
        context.select<
          SettingsController,
          String
        >(
          (
            c,
          ) => c.languageOptions[c.selectedLanguage].name,
        );

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Pengaturan',
        onBack: () => controller.goBack(
          context,
        ),
      ),
      body: RoundedWhitePanel(
        topRadius: 28,
        child: ListView(
          padding: const EdgeInsets.all(
            AppSpacing.xl,
          ),
          children: [
            Text(
              'Umum',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SettingsTileWidget(
              icon: Icons.language,
              title: 'Bahasa',
              trailing: currentLanguageName,
              onTap: () => controller.showLanguageSheet(
                context,
              ),
            ),
            const SizedBox(
              height: AppSpacing.xl,
            ),
            Text(
              'Lainnya',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SettingsTileWidget(
              icon: Icons.privacy_tip_outlined,
              title: 'Kebijakan Privasi',
              onTap: () => controller.navigateToPrivacy(
                context,
              ),
            ),
            SettingsTileWidget(
              icon: Icons.help_outline,
              title: 'Bantuan',
              onTap: () => controller.navigateToHelp(
                context,
              ),
            ),
            SettingsTileWidget(
              icon: Icons.article_outlined,
              title: 'Syarat dan Ketentuan',
              onTap: () => controller.navigateToTerms(
                context,
              ),
            ),
            SettingsTileWidget(
              icon: Icons.info_outline,
              title: 'Tentang',
              onTap: () => controller.navigateToAbout(
                context,
              ),
            ),
            if (isLoggedIn) ...[
              const SizedBox(
                height: AppSpacing.xl,
              ),
              Text(
                'Tindakan Berbahaya',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SettingsTileWidget(
                icon: Icons.person_off_outlined,
                title: 'Hapus Akun',
                danger: true,
                onTap: () {
                  controller.showDeleteConfirmation(context);
                  context.read<MainShellController>().goToHomeTab();
                },
              ),
              SettingsTileWidget(
                icon: Icons.logout,
                title: 'Keluar',
                danger: true,
                onTap: () {
                  controller.showLogoutConfirmation(context);
                  context.read<MainShellController>().goToHomeTab();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}