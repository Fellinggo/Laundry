import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, () => onChanged(value > 1 ? value - 1 : 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('$value', style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
          ),
          _btn(Icons.add, () => onChanged(value + 1)),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.amber.shade400,
      borderRadius: icon == Icons.remove
          ? const BorderRadius.horizontal(left: Radius.circular(11))
          : const BorderRadius.horizontal(right: Radius.circular(11)),
      child: InkWell(
        onTap: onTap,
        borderRadius: icon == Icons.remove
            ? const BorderRadius.horizontal(left: Radius.circular(11))
            : const BorderRadius.horizontal(right: Radius.circular(11)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: AppColors.textDark),
        ),
      ),
    );
  }
}
