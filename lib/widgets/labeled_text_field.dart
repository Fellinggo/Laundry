import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscure = false,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.errorText,
  });

  final String label;
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscure;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= LABEL =================
        Text(
          label,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),

        // ================= TEXT FIELD =================
        TextField(
          controller: controller,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          keyboardType: keyboardType,
          style: AppTextStyles.body,

          // 🔥 GLOBAL CURSOR COLOR (SAMAKAN SEMUA FIELD)
          cursorColor: AppColors.primaryNavy,

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMuted,
            filled: true,
            fillColor: AppColors.white,

            // 🔥 ERROR TEXT (muncul di bawah border otomatis)
            errorText: errorText,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            // ================= PREFIX ICON =================
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.textSecondary,
                    size: 22,
                  )
                : null,

            // ================= SUFFIX =================
            suffixIcon: suffix,

            // ================= BORDER NORMAL =================
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
              ),
            ),

            // ================= ENABLED BORDER =================
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 1.2,
              ),
            ),

            // ================= FOCUSED BORDER =================
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.primaryNavy,
                width: 1.4,
              ),
            ),

            // ================= ERROR BORDER =================
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.2,
              ),
            ),

            // ================= FOCUSED ERROR =================
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSpacing.inputRadius,
              ),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}