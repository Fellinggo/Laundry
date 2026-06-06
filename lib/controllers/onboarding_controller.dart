import 'package:flutter/material.dart';
import 'package:wushlaundry/models/onboardinng_model.dart';

class OnboardingController
    extends
        ChangeNotifier {
  final PageController pageController = PageController();
  OnboardingState _state = OnboardingState.initial();

  OnboardingState get state => _state;
  int get currentIndex => _state.currentPageIndex;
  OnboardingPage get currentPage => _state.currentPage;
  List<
    OnboardingPage
  >
  get pages => _state.pages;
  bool get isFinalPage => _state.isFinalPage;
  bool get isLastPage => _state.isLastPage;

  void onPageChanged(
    int index,
  ) {
    if (_state.currentPageIndex !=
        index) {
      _state = _state.copyWith(
        currentPageIndex: index,
      );
      notifyListeners();
    }
  }

  Future<
    void
  >
  nextPage(
    BuildContext context,
  ) async {
    if (!_state.isLastPage) {
      await pageController.nextPage(
        duration: const Duration(
          milliseconds: 320,
        ),
        curve: Curves.easeOutCubic,
      );
    } else {
      _navigateToMain(
        context,
      );
    }
  }

  Future<
    void
  >
  skipToLastPage() async {
    await pageController.animateToPage(
      _state.pages.length -
          1,
      duration: const Duration(
        milliseconds: 350,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  void _navigateToMain(
    BuildContext context,
  ) {
    Navigator.pushReplacementNamed(
      context,
      '/main',
    );
  }

  void goToMain(
    BuildContext context,
  ) {
    _navigateToMain(
      context,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
