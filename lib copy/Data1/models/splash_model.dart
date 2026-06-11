import 'dart:ui';

class SplashModel {
  final int splashDurationInSeconds;
  final String logoAssetPath;
  final Color backgroundColor;
  final String redirectRoute;

  SplashModel({
    required this.splashDurationInSeconds,
    required this.logoAssetPath,
    required this.backgroundColor,
    required this.redirectRoute,
  });

  // Factory untuk default splash screen
  factory SplashModel.defaultSplash() {
    return SplashModel(
      splashDurationInSeconds: 2,
      logoAssetPath: 'assets/images/logo.png',
      backgroundColor: const Color(0xFFF6F7FF),
      redirectRoute: '/onboarding',
    );
  }

  // Untuk kemudahan jika nanti ingin konfigurasi dari file/config
  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      splashDurationInSeconds: json['splashDurationInSeconds'] ?? 2,
      logoAssetPath: json['logoAssetPath'] ?? 'assets/images/logo.png',
      backgroundColor: Color(json['backgroundColor'] ?? 0xFFF6F7FF),
      redirectRoute: json['redirectRoute'] ?? '/onboarding',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'splashDurationInSeconds': splashDurationInSeconds,
      'logoAssetPath': logoAssetPath,
      'backgroundColor': backgroundColor.value,
      'redirectRoute': redirectRoute,
    };
  }
}
