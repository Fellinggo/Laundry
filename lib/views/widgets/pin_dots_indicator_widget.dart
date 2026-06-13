import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PinDotsIndicator
    extends
        StatelessWidget {
  final int length;
  final int filledCount;
  final double dotSize;
  final double spacing;

  const PinDotsIndicator({
    super.key,
    required this.length,
    required this.filledCount,
    this.dotSize = 10,
    this.spacing = 6,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (
          i,
        ) {
          final isFilled =
              i <
              filledCount;
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: spacing,
            ),
            width: 44,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10,
              ),
              border: Border.all(
                color: AppColors.actionBlue.withOpacity(
                  0.25,
                ),
              ),
            ),
            child: isFilled
                ? const Center(
                    child: Icon(
                      Icons.circle,
                      size: 10,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
