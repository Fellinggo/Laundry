import 'package:flutter/material.dart';
import 'package:wushlaundry/controllers/splash_controller.dart';

class SplashScreen
    extends
        StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<
    SplashScreen
  >
  createState() => _SplashScreenState();
}

class _SplashScreenState
    extends
        State<
          SplashScreen
        > {
  late SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashController();
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
    // Ketika timer selesai, controller akan memanggil notifyListeners()
    // Ini akan memicu navigasi
    if (mounted &&
        !_controller.isNavigating) {
      _controller.navigateToNextScreen(
        context,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(
      context,
    ).size;
    final splashModel = _controller.splashModel;

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
