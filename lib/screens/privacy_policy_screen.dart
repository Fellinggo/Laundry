import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Kebijakan Privasi',
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
                  'Kebijakan Privasi',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  'Kami menghormati privasi Anda. Data pribadi digunakan untuk memproses pesanan, komunikasi layanan, dan peningkatan pengalaman aplikasi.',
                  style: AppTextStyles.bodyMuted,
                  textAlign: TextAlign.justify, 
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Pedoman Pengguna',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 8),
                _bullet('Gunakan layanan sesuai ketentuan yang berlaku.'),
                _bullet('Pastikan informasi alamat dan kontak akurat.'),
                _bullet('Segala bentuk penyalahgunaan dapat mengakibatkan penangguhan akun.'),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Penggunaan Data',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 8),
                _bullet('Data lokasi dipakai untuk penjemputan dan pengantaran.'),
                _bullet('Riwayat pesanan disimpan untuk keperluan garansi layanan.'),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'Pelajari lebih lanjut tentang cookie',
                    style: AppTextStyles.link.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: AppTextStyles.bodyMuted),
          Expanded(
            child: Text(
              t,
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}