import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class ScheduleIconField
    extends
        StatelessWidget {
  final String text;
  final IconData icon;

  const ScheduleIconField({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(
          14,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }
}
