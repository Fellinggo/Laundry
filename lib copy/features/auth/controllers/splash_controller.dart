import 'dart:async';
import 'package:flutter/material.dart';
import '../../../Data1/models/splash_model.dart';

class SplashController extends ChangeNotifier {
  SplashModel _splashModel = SplashModel.defaultSplash();
  Timer? _splashTimer;
  bool _isNavigating = false;
  bool _timerFinished = false;

  SplashModel get splashModel => _splashModel;
  bool get isNavigating => _isNavigating;
  bool get timerFinished => _timerFinished;

  SplashController() {
    _startSplashTimer();
  }

  void _startSplashTimer() {
    _splashTimer = Timer(
      Duration(seconds: _splashModel.splashDurationInSeconds),
      () {
        if (!_isNavigating) {
          _timerFinished = true;
          notifyListeners();
        }
      },
    );
  }

  void navigateToNextScreen(BuildContext context) {
    if (_isNavigating) return;

    _isNavigating = true;
    _splashTimer?.cancel();

    Navigator.pushReplacementNamed(context, _splashModel.redirectRoute);
  }

  void updateSplashModel(SplashModel newModel) {
    _splashModel = newModel;
    notifyListeners();
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }
}
