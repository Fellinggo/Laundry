import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/models/static/setting_model.dart';
import 'package:wushlaundry/views/widgets/confirmation_dialog_widget.dart';
import 'package:wushlaundry/views/widgets/language_sheet_widget.dart';
import 'package:wushlaundry/controllers/home/home_controller.dart';
import 'package:wushlaundry/controllers/main/main_shell_controller.dart';

class SettingsController extends ChangeNotifier {
  SettingsModel _settings = SettingsModel.initial();
  bool _isLoading = false;

  SettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _settings.isLoggedIn;
  int get selectedLanguage => _settings.selectedLanguageIndex;
  List<LanguageOption> get languageOptions => _settings.languageOptions;

  SettingsController() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    _settings = _settings.copyWith(
      isLoggedIn: isLoggedIn,
    );
    _isLoading = false;
    notifyListeners();
  }

  void changeLanguage(int index) {
    if (_settings.languageOptions[index].isAvailable) {
      _settings = _settings.copyWith(
        selectedLanguageIndex: index,
      );
      notifyListeners();
    }
  }

  // ✅ METHOD LOGOUT DENGAN BANNER KONFIRMASI
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Update SharedPreferences
    await prefs.setBool('isLoggedIn', false);

    // 2. Reset HomeController state langsung
    if (context.mounted) {
      final homeController = context.read<HomeController>();
      await homeController.logout();
      
      // Kembali ke Home Tab setelah logout berhasil
      final mainController = context.read<MainShellController>();
      mainController.goToHomeTab();
    }

    // 3. Update state SettingsController
    _settings = _settings.copyWith(isLoggedIn: false);
    notifyListeners();

    // 4. Navigate ke main
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (route) => false,
      );

      // ✅ TAMBAHKAN BANNER MERAH UNTUK KELUAR
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil keluar dari akun'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // ✅ METHOD DELETE ACCOUNT DENGAN BANNER KONFIRMASI
  Future<void> deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Clear semua SharedPreferences
    await prefs.clear();

    // 2. Reset HomeController state langsung
    if (context.mounted) {
      final homeController = context.read<HomeController>();
      await homeController.logout();
      
      // Kembali ke Home Tab
      final mainController = context.read<MainShellController>();
      mainController.goToHomeTab();
    }

    // 3. Update state SettingsController
    _settings = _settings.copyWith(isLoggedIn: false);
    notifyListeners();

    // 4. Navigate ke main
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (route) => false,
      );

      // Banner merah untuk hapus akun
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun berhasil dihapus'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void navigateToPrivacy(BuildContext context) {
    Navigator.pushNamed(context, '/privacy');
  }

  void navigateToHelp(BuildContext context) {
    Navigator.pushNamed(context, '/help');
  }

  void navigateToTerms(BuildContext context) {
    Navigator.pushNamed(context, '/terms');
  }

  void navigateToAbout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void showLanguageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return LanguageSheetWidget(
          selectedIndex: _settings.selectedLanguageIndex,
          languageOptions: _settings.languageOptions,
          onLanguageSelected: (index) {
            changeLanguage(index);
          },
        );
      },
    );
  }

  void showDeleteConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => ConfirmationDialogWidget(
        title: 'Hapus Akun',
        content: 'Apakah kamu yakin ingin menghapus akun ini? Semua data akan hilang dan tidak bisa dikembalikan.',
        confirmText: 'Hapus Akun',
        isDangerous: true,
        onConfirm: () => deleteAccount(context),
      ),
    );
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => ConfirmationDialogWidget(
        title: 'Keluar',
        content: 'Apakah kamu yakin ingin keluar? Data kamu akan tetap tersimpan.',
        confirmText: 'Keluar',
        isDangerous: false,
        onConfirm: () => logout(context),
      ),
    );
  }
}