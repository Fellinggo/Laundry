import 'package:flutter/material.dart';
import 'package:wushlaundry/controllers/setting_controller.dart';
import 'package:wushlaundry/views/widgets/setting_tile_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class SettingsScreen
    extends
        StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<
    SettingsScreen
  >
  createState() => _SettingsScreenState();
}

class _SettingsScreenState
    extends
        State<
          SettingsScreen
        > {
  late SettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SettingsController();
    _controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(
        () {},
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final isLoggedIn = _controller.isLoggedIn;

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Pengaturan',
        onBack: () => _controller.goBack(
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
              trailing: _controller.languageOptions[_controller.selectedLanguage].name,
              onTap: () => _controller.showLanguageSheet(
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
              onTap: () => _controller.navigateToPrivacy(
                context,
              ),
            ),
            SettingsTileWidget(
              icon: Icons.help_outline,
              title: 'Bantuan',
              onTap: () => _controller.navigateToHelp(
                context,
              ),
            ),
            SettingsTileWidget(
              icon: Icons.article_outlined,
              title: 'Syarat dan Ketentuan',
              onTap: () => _controller.navigateToTerms(
                context,
              ),
            ),
            SettingsTileWidget(
              icon: Icons.info_outline,
              title: 'Tentang',
              onTap: () => _controller.navigateToAbout(
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
                onTap: () => _controller.showDeleteConfirmation(
                  context,
                ),
              ),
              SettingsTileWidget(
                icon: Icons.logout,
                title: 'Keluar',
                danger: true,
                onTap: () => _controller.showLogoutConfirmation(
                  context,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
