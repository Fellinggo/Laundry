import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Tentang',
        onBack: () => Navigator.pop(
          context,
        ),
      ),
      body: SizedBox.expand(
        child: RoundedWhitePanel(
          topRadius: 28,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(
                28,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WushLaundry adalah aplikasi layanan laundry online yang dirancang untuk memudahkan Anda dalam mencuci pakaian tanpa harus keluar rumah. Dengan fitur pemesanan yang praktis dan layanan antar jemput oleh kurir, kami membantu Anda menghemat waktu dan tenaga dalam memenuhi kebutuhan laundry sehari-hari.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.justify, // Tambahkan ini
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Text(
                    'Melalui aplikasi ini, Anda dapat memilih berbagai jenis layanan seperti cuci kering, cuci bedcover, dan layanan lainnya dengan harga yang transparan. Selain itu, tersedia juga berbagai promo menarik serta fitur membership yang memberikan keuntungan lebih bagi pengguna.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.justify, // Tambahkan ini
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Text(
                    'Kami berkomitmen untuk memberikan pelayanan yang cepat, aman, dan terpercaya dengan kualitas terbaik. WushLaundry hadir sebagai solusi modern untuk gaya hidup yang lebih praktis dan efisien.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.justify, // Tambahkan ini
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Text(
                    'Terima kasih telah menggunakan WushLaundry!',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.justify, // Tambahkan ini
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}