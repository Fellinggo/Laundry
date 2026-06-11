import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/views/widgets/onboarding_navigation_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/onboarding_dots_indicator.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau state OnboardingController secara reaktif
    final controller = context.watch<OnboardingController>();
    final pages = controller.pages;
    final currentIndex = controller.currentIndex;
    final currentPage = controller.currentPage;

    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: pages.length,
                onPageChanged: (index) => controller.onPageChanged(index),
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(page: pages[index]);
                },
              ),
            ),
            if (!currentPage.isFinalPage)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OnboardingDotsIndicator(
                  currentIndex: currentIndex,
                  totalPages: pages.length,
                ),
              )
            else
              const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: OnboardingNavigationButtons(
                isFinalPage: currentPage.isFinalPage,
                isLastPage: controller.isLastPage,
                onSkip: () => controller.skipToLastPage(),
                onNext: () => controller.nextPage(context),
                onStart: () => controller.goToMain(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
