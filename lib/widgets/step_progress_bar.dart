import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class OrderStepProgressBar extends StatelessWidget {
  const OrderStepProgressBar({
    super.key,
    this.activeIndex = 0,
  });

  final int activeIndex;

  static const _labels = [
    'Dijemput',
    'Diambil',
    'Dicuci',
    'Diantar',
    'Sampai',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (var s = 0; s < _labels.length; s++) ...[
              _StepDot(
                active: s == activeIndex,
                done: s < activeIndex,
              ),
              if (s < _labels.length - 1)
                Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: s < activeIndex
                          ? AppColors.actionBlue
                          : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _labels.length,
            (s) {
              final active = s == activeIndex;
              return Expanded(
                child: Text(
                  _labels[s],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? AppColors.actionBlue : AppColors.textMuted,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.active,
    required this.done,
  });

  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final on = active || done;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: on ? AppColors.actionBlue : AppColors.borderLight,
          border: Border.all(
            color: AppColors.white,
            width: 2,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.actionBlue.withOpacity(0.45),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}