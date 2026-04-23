import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Pengaturan',
        onBack: () => Navigator.pop(context),
      ),
      body: RoundedWhitePanel(
        topRadius: 28,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              'Umum',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            _tile(
              Icons.language,
              'Bahasa',
              trailing: 'Indonesia',
              onTap: () => _languageSheet(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Lainnya',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            _tile(
              Icons.privacy_tip_outlined,
              'Kebijakan Privasi',
              onTap: () => Navigator.pushNamed(context, '/privacy'),
            ),
            _tile(
              Icons.help_outline,
              'Bantuan',
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            _tile(
              Icons.article_outlined,
              'Syarat dan Ketentuan',
              onTap: () => Navigator.pushNamed(context, '/terms'),
            ),
            _tile(
              Icons.info_outline,
              'Tentang',
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),

            // Bagian ini hanya muncul jika isLoggedIn == true
            if (isLoggedIn) ...[
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Tindakan Berbahaya',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _tile(
                Icons.person_off_outlined,
                'Hapus Akun',
                danger: true,
                onTap: () => _confirmDelete(context),
              ),
              _tile(
                Icons.logout,
                'Keluar',
                danger: true,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tile(
    IconData icon,
    String title, {
    String? trailing,
    bool danger = false,
    VoidCallback? onTap,
  }) {
    final c = danger ? AppColors.danger : AppColors.headerNavy;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: c),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: c,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: AppTextStyles.bodyMuted,
            ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Future<void> _languageSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _LanguageSheetBody(),
    );
  }

  // ============================================
  // LOGOUT - HANYA HAPUS STATUS LOGIN
  // DATA USER (EMAIL, ALAMAT) TETAP DISIMPAN
  // ============================================
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    
    // HANYA hapus status login
    await prefs.setBool('isLoggedIn', false);
    
    // DATA INI TETAP DISIMPAN (TIDAK DIHAPUS):
    // - userEmail
    // - userName
    // - isSignup
    // - userAddresses_$email
    // - userAddressTitles_$email

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main',
      (route) => false,
    );
  }

  // ============================================
  // HAPUS AKUN - HAPUS SEMUA DATA PERMANEN
  // ============================================
  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Hapus SEMUA data
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main',
      (route) => false,
    );
    
    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Akun berhasil dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Akun', style: AppTextStyles.sectionTitle),
        content: const Text(
          'Apakah kamu yakin ingin menghapus akun ini? Semua data akan hilang dan tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: AppTextStyles.bodyMuted),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteAccount(context);
            },
            child: Text(
              'Hapus Akun',
              style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Keluar', style: AppTextStyles.sectionTitle),
        content: const Text('Apakah kamu yakin ingin keluar? Data kamu akan tetap tersimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: AppTextStyles.bodyMuted),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _logout(context);
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= LANGUAGE SHEET =================
class _LanguageSheetBody extends StatefulWidget {
  const _LanguageSheetBody();

  @override
  State<_LanguageSheetBody> createState() => _LanguageSheetBodyState();
}

class _LanguageSheetBodyState extends State<_LanguageSheetBody> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Indonesia'),
            trailing: _selected == 0
                ? const Icon(Icons.check_circle, color: AppColors.primaryNavy)
                : null,
            onTap: () => setState(() => _selected = 0),
          ),
          ListTile(
            title: Text(
              'English',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            subtitle: Text(
              'Segera hadir',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.danger,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}