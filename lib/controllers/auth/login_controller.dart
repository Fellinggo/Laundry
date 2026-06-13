import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth/login_model.dart';
import '../../data/dataDummy.dart';

class LoginController
    extends
        ChangeNotifier {
  bool _obscure = true;
  bool _staySignedIn = false;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  bool get obscure => _obscure;
  bool get staySignedIn => _staySignedIn;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get isLoading => _isLoading;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  void toggleStaySignedIn() {
    _staySignedIn = !_staySignedIn;
    notifyListeners();
  }

  void clearErrors() {
    _emailError = null;
    _passwordError = null;
    notifyListeners();
  }

  Future<
    bool
  >
  isAutoLoginAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    final staySignedIn =
        prefs.getBool(
          'staySignedIn',
        ) ??
        false;
    final isLoggedIn =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;
    return staySignedIn &&
        isLoggedIn;
  }

  Future<
    void
  >
  _injectDummyData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'process_orders',
      DummyOrders.processOrders,
    );

    print(
      '========== INJECT DUMMY ==========',
    );
    print(
      'Dummy injected to process_orders',
    );
    print(
      'Data: ${DummyOrders.processOrders}',
    );
    final check = prefs.getStringList(
      'process_orders',
    );
    print(
      'Verification - process_orders length: ${check?.length}',
    );
    print(
      '==================================',
    );
  }

  Future<
    bool
  >
  validateAndLogin({
    required String email,
    required String password,
  }) async {
    clearErrors();
    bool hasError = false;

    // Validasi email
    if (email.isEmpty) {
      _emailError = "Email tidak boleh kosong";
      hasError = true;
    } else {
      final credentials = LoginCredentials(
        email: email,
        password: password,
        staySignedIn: _staySignedIn,
      );
      if (!credentials.isEmailValid) {
        _emailError = "Email tidak valid";
        hasError = true;
      }
    }

    // Validasi password
    if (password.isEmpty) {
      _passwordError = "Password tidak boleh kosong";
      hasError = true;
    } else {
      final credentials = LoginCredentials(
        email: email,
        password: password,
        staySignedIn: _staySignedIn,
      );
      if (!credentials.isPasswordValid) {
        _passwordError = "Min 6 karakter, huruf besar, kecil, dan angka wajib ada";
        hasError = true;
      }
    }

    if (hasError) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final namaUser = email.split(
        '@',
      )[0];

      await prefs.setBool(
        'isLoggedIn',
        true,
      );
      await prefs.setBool(
        'isSignup',
        false,
      );
      await prefs.setString(
        'userName',
        namaUser,
      );
      await prefs.setString(
        'userEmail',
        email,
      );
      await prefs.setBool(
        'staySignedIn',
        _staySignedIn,
      );
      await prefs.setString(
        'login_method',
        'signin',
      );

      await _injectDummyData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (
      e
    ) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void showForgotPasswordMessage(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Fitur lupa password akan segera hadir',
        ),
      ),
    );
  }
}
