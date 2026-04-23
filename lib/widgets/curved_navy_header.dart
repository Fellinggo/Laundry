import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CurvedNavyHeader extends StatelessWidget {
  const CurvedNavyHeader({
    super.key,
    required this.subtitle,
    this.heightFraction = 0.35,
  });

  final String subtitle;
  final double heightFraction;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * heightFraction;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // ✅ BIRU (LURUS, FULL)
          Container(
            width: double.infinity,
            height: height,
            color: AppColors.headerNavy,
          ),

          // ✅ PUTIH MELENGKUNG
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 75,
              decoration: const BoxDecoration(
                color: AppColors.pageBg,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
            ),
          ),

          // ✅ CONTENT (LOGO + TEXT)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo_white.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}