import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class OnboardingDotsIndicator
    extends
        StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final double dotSize;
  final double activeDotSize;
  final double spacing;

  const OnboardingDotsIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    this.dotSize = 10,
    this.activeDotSize = 10,
    this.spacing = 5,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (
          index,
        ) {
          final isActive =
              index ==
              currentIndex;
          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 200,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: spacing,
            ),
            width: isActive
                ? activeDotSize
                : dotSize,
            height: isActive
                ? activeDotSize
                : dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? AppColors.wushOnboardingNavy
                  : AppColors.onboardingDotInactive,
            ),
          );
        },
      ),
    );
  }
}
