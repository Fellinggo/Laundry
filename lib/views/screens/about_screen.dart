import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Pastikan import ini ada

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/about_controller.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari Provider
    final aboutController = context.read<AboutController>();
    final aboutData = aboutController.aboutData;

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Tentang',
        onBack: () => Navigator.pop(context),
      ),
      body: SizedBox.expand(
        child: RoundedWhitePanel(
          topRadius: 28,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < aboutData.paragraphs.length; i++) ...[
                    Text(
                      aboutData.paragraphs[i],
                      style: AppTextStyles.body,
                      textAlign: TextAlign.justify,
                    ),
                    if (i != aboutData.paragraphs.length - 1)
                      const SizedBox(height: AppSpacing.lg),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
