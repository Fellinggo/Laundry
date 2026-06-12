class OnboardingPage {
  final String image;
  final String title;
  final String description;
  final bool isFinalPage;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    this.isFinalPage = false,
  });

  factory OnboardingPage.defaultPage1() {
    return const OnboardingPage(
      image: 'assets/images/onb1.png',
      title: 'Selamat Datang di WushLaundry!',
      description:
          'Layanan laundry praktis dengan antar-jemput cepat, bersih dan hemat waktu, tanpa ribet — biar kami yang urus cucian kamu.',
    );
  }

  factory OnboardingPage.defaultPage2() {
    return const OnboardingPage(
      image: 'assets/images/onb2.png',
      title: 'Antar-Jemput Cepat & Praktis',
      description:
          'Kami jemput cucian kamu, proses, dan antar kembali dengan rapi.',
    );
  }

  factory OnboardingPage.defaultPage3() {
    return const OnboardingPage(
      image: 'assets/images/onb3.png',
      title: 'Cucian Kamu di Tangan yang Tepat',
      description: 'Dicuci bersih, disetrika rapi, siap dipakai kembali.',
    );
  }

  factory OnboardingPage.defaultPage4() {
    return const OnboardingPage(
      image: 'assets/images/onb4.png',
      title: 'Siap jemput cucian kamu ✨✨',
      description:
          'Pilih lokasi kamu & mulai order.\nKurir kami aktif dan siap menjemput kapan saja.',
      isFinalPage: true,
    );
  }

  static List<OnboardingPage> getDefaultPages() {
    return [
      OnboardingPage.defaultPage1(),
      OnboardingPage.defaultPage2(),
      OnboardingPage.defaultPage3(),
      OnboardingPage.defaultPage4(),
    ];
  }
}

class OnboardingState {
  final int currentPageIndex;
  final List<OnboardingPage> pages;

  OnboardingState({required this.currentPageIndex, required this.pages});

  factory OnboardingState.initial() {
    return OnboardingState(
      currentPageIndex: 0,
      pages: OnboardingPage.getDefaultPages(),
    );
  }

  OnboardingPage get currentPage => pages[currentPageIndex];

  bool get isFirstPage => currentPageIndex == 0;

  bool get isLastPage => currentPageIndex == pages.length - 1;

  bool get isFinalPage => currentPage.isFinalPage;

  OnboardingState copyWith({
    int? currentPageIndex,
    List<OnboardingPage>? pages,
  }) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      pages: pages ?? this.pages,
    );
  }
}
