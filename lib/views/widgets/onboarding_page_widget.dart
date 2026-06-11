import 'package:flutter/material.dart';
import 'package:wushlaundry/models/onboardinng_model.dart';
import '../../../constants/app_text_styles.dart';

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
