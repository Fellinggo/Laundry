import 'package:flutter/material.dart';

import '../../../Data1/models/onboardinng_model.dart';
import '../../../core/constants/app_text_styles.dart';


class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(page.image, height: 350, fit: BoxFit.contain),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: AppTextStyles.displayOnboardingTitle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 19),
          Text(
            page.description,
            style: AppTextStyles.onboardingBody(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
