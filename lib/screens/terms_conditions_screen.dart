import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Syarat dan Ketentuan',
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
                  'Syarat Layanan',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                _bullet(
                  'Layanan laundry mencakup cuci, kering, setrika, dan pengantaran sesuai paket yang dipilih.',
                ),
                _bullet(
                  'Estimasi waktu dapat berubah sewaktu-waktu tergantung pada antrean dan cuaca.',
                ),
                _bullet(
                  'Pelanggan wajib memastikan tidak ada barang berharga di dalam kantong cucian.',
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Kerusakan & Kehilangan',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 8),
                _bullet(
                  'Klaim kerusakan dilaporkan maksimal 24 jam setelah pengantaran.',
                ),
                _bullet(
                  'Kompensasi mengikuti kebijakan internal dan bukti yang valid.',
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Pembayaran', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                _bullet(
                  'Pembayaran dilakukan melalui metode yang tersedia di aplikasi.',
                ),
                _bullet(
                  'Promo dan kode diskon tidak dapat digabungkan kecuali diatur lain.',
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
