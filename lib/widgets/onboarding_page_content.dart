import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.description,
  });

  final Widget illustration;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Center(
              child: illustration,
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 8, AppSpacing.xl, 4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displayOnboardingTitle(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.onboardingBody(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
