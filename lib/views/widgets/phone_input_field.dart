import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class PhoneInputField
    extends
        StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(
    String,
  )?
  onChanged; // ← TAMBAHKAN INI

  const PhoneInputField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged, // ← TAMBAHKAN INI
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No. HP',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          style: AppTextStyles.body,
          onChanged: onChanged, // ← TAMBAHKAN INI
          decoration: InputDecoration(
            hintText: '08XX XXXX XXXX',
            filled: true,
            fillColor: AppColors.white,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.primaryNavy,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.4,
              ),
            ),
            prefixIcon: const Icon(
              Icons.phone,
            ),
          ),
        ),
      ],
    );
  }
}
