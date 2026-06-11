import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../shared/widgets/navy_app_bar.dart';
import '../../shared/widgets/rounded_white_panel.dart';
import '../controllers/about_controller.dart'; // <-- Pastikan import ini ada


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
