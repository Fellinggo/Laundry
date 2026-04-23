import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class OrderStatusSegmentedBar extends StatelessWidget {
  const OrderStatusSegmentedBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const labels = ['Pesan', 'Proses', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.ordersNavy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final sel = i == selectedIndex;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: sel ? AppColors.ordersNavy : AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
