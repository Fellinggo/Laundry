import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_styles.dart';

class OnboardingNavigationButtons extends StatelessWidget {
  final bool isFinalPage;
  final bool isLastPage;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onStart;

  const OnboardingNavigationButtons({
    super.key,
    required this.isFinalPage,
    required this.isLastPage,
    required this.onSkip,
    required this.onNext,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    if (isFinalPage) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onStart,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.wushOnboardingNavy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.onboardingButtonRadius,
              ),
            ),
          ),
          child: Text(
            'Mulai',
            style: AppTextStyles.button.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 7,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onSkip,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.onboardingSkipSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.onboardingButtonRadius,
                  ),
                ),
              ),
              child: Text(
                'Lewati',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.wushOnboardingNavy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 13,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.wushOnboardingNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.onboardingButtonRadius,
                  ),
                ),
              ),
              child: Text(
                'Lanjut',
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
