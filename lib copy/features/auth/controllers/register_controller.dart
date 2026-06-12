import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data1/models/auth/registration_model.dart';

class RegisterController extends ChangeNotifier {
  RegistrationData _data = RegistrationData(
    name: '',
    email: '',
    phone: '',
    password: '',
    confirmPassword: '',
  );

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  RegistrationData get data => _data;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isLoading => _isLoading;

  // Membaca pesan error dari model pendaftaran
  String? get emailError => _data.emailErrorMessage;
  String? get phoneError => _data.phoneErrorMessage;
  String? get passwordError => _data.passwordErrorMessage;
  String? get confirmPasswordError => _data.confirmPasswordErrorMessage;

  void updateName(String value) {
    _data = _data.copyWith(name: value);
    notifyListeners();
  }

  void updateEmail(String value) {
    _data = _data.copyWith(email: value);
    notifyListeners();
  }

  void updatePhone(String value) {
    _data = _data.copyWith(phone: value);
    notifyListeners();
  }

  void updatePassword(String value) {
    _data = _data.copyWith(password: value);
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _data = _data.copyWith(confirmPassword: value);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<bool> register(BuildContext context) async {
    if (!_data.isValid) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', true);
      await prefs.setBool('isSignup', true);
      await prefs.setString('userName', _data.name);
      await prefs.setString('userEmail', _data.email);
      await prefs.setString('login_method', 'signup');

      // Membersihkan data penyimpanan alamat lama
      await prefs.remove('userAddresses');
      await prefs.remove('userAddressTitles');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void navigateToMain(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  void clearErrors() {
    notifyListeners();
  }
}
