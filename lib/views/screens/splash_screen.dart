import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/splash_controller.dart';

class SplashScreen
    extends
        StatelessWidget {
  const SplashScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ChangeNotifierProvider<
      SplashController
    >(
      create:
          (
            _,
          ) => SplashController(),
      child: const _SplashContent(),
    );
  }
}

class _SplashContent
    extends
        StatelessWidget {
  const _SplashContent();

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(
      context,
    ).size;

    // Mengambil data model splash secara atomik
    final splashModel =
        context.select<
          SplashController,
          dynamic
        >(
          (
            c,
          ) => c.splashModel,
        );

    // Mendengarkan status perubahan timer
    final timerFinished =
        context.select<
          SplashController,
          bool
        >(
          (
            c,
          ) => c.timerFinished,
        );
    final isNavigating =
        context.select<
          SplashController,
          bool
        >(
          (
            c,
          ) => c.isNavigating,
        );

    // Memicu navigasi aman setelah frame UI selesai digambar sepenuhnya
    if (timerFinished &&
        !isNavigating) {
      WidgetsBinding.instance.addPostFrameCallback(
        (
          _,
        ) {
          if (context.mounted) {
            context
                .read<
                  SplashController
                >()
                .navigateToNextScreen(
                  context,
                );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: splashModel.backgroundColor,
      body: Center(
        child: Image.asset(
          splashModel.logoAssetPath,
          width:
              size.width *
              0.5,
        ),
      ),
    );
  }
}
