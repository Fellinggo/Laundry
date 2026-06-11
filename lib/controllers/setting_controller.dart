import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/models/setting_model.dart';
import 'package:wushlaundry/views/widgets/confirmation_dialog_widget.dart';
import 'package:wushlaundry/views/widgets/language_sheet_widget.dart';
import 'package:wushlaundry/controllers/home_controller.dart';

class SettingsController
    extends
        ChangeNotifier {
  SettingsModel _settings = SettingsModel.initial();
  bool _isLoading = false;

  SettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _settings.isLoggedIn;
  int get selectedLanguage => _settings.selectedLanguageIndex;
  List<
    LanguageOption
  >
  get languageOptions => _settings.languageOptions;

  SettingsController() {
    checkLoginStatus();
  }

  Future<
    void
  >
  checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;

    _settings = _settings.copyWith(
      isLoggedIn: isLoggedIn,
    );
    _isLoading = false;
    notifyListeners();
  }

  void changeLanguage(
    int index,
  ) {
    if (_settings.languageOptions[index].isAvailable) {
      _settings = _settings.copyWith(
        selectedLanguageIndex: index,
      );
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isLoggedIn',
      false,
    );

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (route) => false,
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun berhasil dihapus'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void navigateToPrivacy(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      '/privacy',
    );
  }

  void navigateToHelp(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      '/help',
    );
  }

  void navigateToTerms(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      '/terms',
    );
  }

  void navigateToAbout(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      '/about',
    );
  }

  void goBack(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }

  void showLanguageSheet(
    BuildContext context,
  ) {
    showModalBottomSheet<
      void
    >(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (
            ctx,
          ) {
            // Menggunakan context dari Screen utama agar perubahan bahasa langsung merender ulang UI
            return LanguageSheetWidget(
              selectedIndex: _settings.selectedLanguageIndex,
              languageOptions: _settings.languageOptions,
              onLanguageSelected:
                  (
                    index,
                  ) {
                    changeLanguage(
                      index,
                    );
                  },
            );
          },
    );
  }

  void showDeleteConfirmation(
    BuildContext context,
  ) {
    showDialog<
      void
    >(
      context: context,
      builder:
          (
            ctx,
          ) => ConfirmationDialogWidget(
            title: 'Hapus Akun',
            content: 'Apakah kamu yakin ingin menghapus akun ini? Semua data akan hilang dan tidak bisa dikembalikan.',
            confirmText: 'Hapus Akun',
            isDangerous: true,
            onConfirm: () => deleteAccount(
              context,
            ),
          ),
    );
  }

  void showLogoutConfirmation(
    BuildContext context,
  ) {
    showDialog<
      void
    >(
      context: context,
      builder:
          (
            ctx,
          ) => ConfirmationDialogWidget(
            title: 'Keluar',
            content: 'Apakah kamu yakin ingin keluar? Data kamu akan tetap tersimpan.',
            confirmText: 'Keluar',
            isDangerous: false,
            onConfirm: () => logout(
              context,
            ),
          ),
    );
  }
}
