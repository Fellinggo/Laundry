import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/onboarding_navigation_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/onboarding_dots_indicator.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingScreen
    extends
        StatefulWidget {
  const OnboardingScreen({
    super.key,
  });

  @override
  State<
    OnboardingScreen
  >
  createState() => _OnboardingScreenState();
}

class _OnboardingScreenState
    extends
        State<
          OnboardingScreen
        > {
  late OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
    _controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(
        () {},
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final pages = _controller.pages;
    final currentIndex = _controller.currentIndex;
    final currentPage = _controller.currentPage;

    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller.pageController,
                itemCount: pages.length,
                onPageChanged:
                    (
                      index,
                    ) => _controller.onPageChanged(
                      index,
                    ),
                itemBuilder:
                    (
                      context,
                      index,
                    ) {
                      return OnboardingPageWidget(
                        page: pages[index],
                      );
                    },
              ),
            ),
            if (!currentPage.isFinalPage)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: OnboardingDotsIndicator(
                  currentIndex: currentIndex,
                  totalPages: pages.length,
                ),
              )
            else
              const SizedBox(
                height: 20,
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: OnboardingNavigationButtons(
                isFinalPage: currentPage.isFinalPage,
                isLastPage: _controller.isLastPage,
                onSkip: () => _controller.skipToLastPage(),
                onNext: () => _controller.nextPage(
                  context,
                ),
                onStart: () => _controller.goToMain(
                  context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
