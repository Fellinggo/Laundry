import 'dart:async';
import 'package:flutter/material.dart';
import '../models/splash_model.dart';

class SplashController
    extends
        ChangeNotifier {
  SplashModel _splashModel = SplashModel.defaultSplash();
  Timer? _splashTimer;
  bool _isNavigating = false;

  SplashModel get splashModel => _splashModel;
  bool get isNavigating => _isNavigating;

  SplashController() {
    _startSplashTimer();
  }

  void _startSplashTimer() {
    _splashTimer = Timer(
      Duration(
        seconds: _splashModel.splashDurationInSeconds,
      ),
      () {
        if (!_isNavigating) {
          // Timer akan dieksekusi melalui navigator di view
          // Controller hanya memberi tahu bahwa waktunya sudah habis
          notifyListeners();
        }
      },
    );
  }

  void navigateToNextScreen(
    BuildContext context,
  ) {
    if (_isNavigating) return;

    _isNavigating = true;
    notifyListeners();

    // Batalkan timer jika masih berjalan
    _splashTimer?.cancel();

    // Navigasi ke halaman berikutnya
    Navigator.pushReplacementNamed(
      context,
      _splashModel.redirectRoute,
    );
  }

  // Untuk mengupdate model jika diperlukan (misal dari API/config)
  void updateSplashModel(
    SplashModel newModel,
  ) {
    _splashModel = newModel;
    notifyListeners();
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }
}
