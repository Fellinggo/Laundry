import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../../controllers/help_controller.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';

class HelpScreen
    extends
        StatelessWidget {
  const HelpScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = HelpController();
    final helpData = controller.getHelpData();

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Bantuan',
        onBack: () => Navigator.pop(
          context,
        ),
      ),
      body: SizedBox.expand(
        child: RoundedWhitePanel(
          topRadius: 28,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (
                  int i = 0;
                  i <
                      helpData.paragraphs.length;
                  i++
                ) ...[
                  Text(
                    helpData.paragraphs[i],
                    style: AppTextStyles.body,
                    textAlign: TextAlign.justify,
                  ),
                  if (i !=
                      helpData.paragraphs.length -
                          1)
                    const SizedBox(
                      height: AppSpacing.lg,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
