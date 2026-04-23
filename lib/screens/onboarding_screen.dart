import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = <_ObPage>[
    _ObPage(
      image: 'assets/images/onb1.png',
      title: 'Selamat Datang di WushLaundry!',
      description:
          'Layanan laundry praktis dengan antar-jemput cepat, bersih dan hemat waktu, tanpa ribet — biar kami yang urus cucian kamu.',
    ),
    _ObPage(
      image: 'assets/images/onb2.png',
      title: 'Antar-Jemput Cepat & Praktis',
      description:
          'Kami jemput cucian kamu, proses, dan antar kembali dengan rapi.',
    ),
    _ObPage(
      image: 'assets/images/onb3.png',
      title: 'Cucian Kamu di Tangan yang Tepat',
      description: 'Dicuci bersih, disetrika rapi, siap dipakai kembali.',
    ),
    _ObPage(
      image: 'assets/images/onb4.png',
      title: 'Siap jemput cucian kamu ✨✨',
      description:
          'Pilih lokasi kamu & mulai order.\nKurir kami aktif dan siap menjemput kapan saja.',
      finalPage: true,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  void _skip() {
    _controller.animateToPage(
      _pages.length - 1, // ke halaman onboarding ke-4
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_page];

    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(p.image, height: 350, fit: BoxFit.contain),
                        const SizedBox(height: 40),
                        Text(
                          p.title,
                          style: AppTextStyles.displayOnboardingTitle(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 19),
                        Text(
                          p.description,
                          style: AppTextStyles.onboardingBody(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // DOT INDICATOR
            if (!page.finalPage)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _page
                            ? AppColors.wushOnboardingNavy
                            : AppColors.onboardingDotInactive,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 20),

            // BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: page.finalPage
                  ? SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.wushOnboardingNavy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.onboardingButtonRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          'Mulai',
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _skip,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.onboardingSkipSurface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.onboardingButtonRadius,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Lewati',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.wushOnboardingNavy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 13,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton( 
                              onPressed: _next,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.wushOnboardingNavy,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.onboardingButtonRadius,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Lanjut',
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ObPage {
  const _ObPage({
    required this.image,
    required this.title,
    required this.description,
    this.finalPage = false,
  });

  final String image;
  final String title;
  final String description;
  final bool finalPage;
}
