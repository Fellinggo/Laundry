import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Bantuan',
        onBack: () => Navigator.pop(context),
      ),
      body: SizedBox.expand(
        child: RoundedWhitePanel(
          topRadius: 28,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jika anda mengalami kendala saat menggunakan aplikasi, silahkan hubungi layanan pelanggan kami melalui kontak yang tersedia. Tim kami akan membantu menyelesaikan masalah secepat mungkin.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify, 
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Pengguna juga dapat melihat informasi status layanan dan status pesanan di riwayat transaksi melalui aplikasi. Jika terjadi kesalahan data atau pesanan, segera hubungi pihak laundry untuk mendapatkan bantuan.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify, 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}