import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._(); // prevent instantiation

  static TextStyle _poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.35,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // =====================
  // ONBOARDING
  // =====================

  static TextStyle displayOnboardingTitle({Color? color}) => _poppins(
    fontSize: 25,
    fontWeight: FontWeight.w800,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle onboardingBody({Color? color}) => _poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textSecondary,
  );

  // =====================
  // SCREENS
  // =====================

  static final TextStyle screenTitleWhite = _poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnNavy,
  );

  static final TextStyle screenTitleNavy = _poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.headerNavy,
  );

  static final TextStyle sectionTitle = _poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.headerNavy,
  );

  // =====================
  // BODY & UI
  // =====================

  static final TextStyle body =
  _poppins(fontSize: 14, color: AppColors.textDark);

  static final TextStyle bodyMuted =
  _poppins(fontSize: 13, color: AppColors.textSecondary);

  static final TextStyle caption =
  _poppins(fontSize: 12, color: AppColors.textMuted);

  static final TextStyle button =
  _poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.white);

  static final TextStyle link =
  _poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.linkBlue);

  static final TextStyle price =
  _poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark);
}
