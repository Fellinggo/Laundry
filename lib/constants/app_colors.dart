import 'package:flutter/material.dart';

/// Unified palette aligned with Figma exports (Wush / Wash Laundry flows).
abstract final class AppColors {
  // Core
  static const Color primaryNavy = Color(0xFF00175E);

  /// Onboarding / primary actions
  static const Color wushOnboardingNavy = Color(0xFF012D6C);
  static const Color onboardingSkipMint = Color(0xFFECF1E8);
  /// Skip button (pale green-beige, navy label).
  static const Color onboardingSkipSurface = Color(0xFFF0F4E8);
  static const Color onboardingDotInactive = Color.fromARGB(255, 175, 175, 175);
  static const Color headerNavy = Color(0xFF041E42);
  static const Color headerNavyAlt = Color(0xFF0D2141);
  static const Color deepNavy = Color(0xFF00104B);
  static const Color profileNavy = Color(0xFF0D1B3E);
  static const Color ordersNavy = Color(0xFF001B3D);

  // Surfaces
  static const Color onboardingBg = Color(0xFFF8F9FF);
  static const Color pageBg = Color(0xFFF5F7FA);
  static const Color pageBgCool = Color(0xFFF8F9FE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFF5F7FA);
  static const Color keypadBg = Color(0xFFF5F5F5);

  // Accents
  static const Color accentBlue = Color(0xFF3E54AC);
  static const Color actionBlue = Color(0xFF005696);
  static const Color linkBlue = Color(0xFF3E54AC);
  static const Color skyTab = Color(0xFF2196F3);
  static const Color mintSkip = Color(0xFFE9F2EF);
  static const Color serviceCardTint = Color(0xFFE8F1FF);

  // Text
  static const Color textPrimary = Color(0xFF00175E);
  static const Color textDark = Color(0xFF00175E);
  static const Color textSecondary = Color(0xFF00175E);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color textOnNavy = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color expressRed = Color(0xFFE53935);
  static const Color etaGreen = Color(0xFF2E7D32);
  static const Color gold = Color(0xFFC9A227);
  static const Color danger = Color(0xFFE53935);

  // Lines
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color iconCircle = Color(0xFFE8E8E8);

  // Offers / Pro gradient
  static const Color tealGradientStart = Color(0xFF4FD1C5);
  static const Color tealGradientEnd = Color(0xFF63B3ED);
}
