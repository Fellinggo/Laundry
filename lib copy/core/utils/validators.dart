import 'package:flutter/material.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }

    final email = value.trim();
    final isValid = RegExp(
      r'^[a-zA-Z0-9._%+-]+@('
      r'gmail\.com|'
      r'yahoo\.com|'
      r'yahoo\.co\.id|'
      r'hotmail\.com|'
      r'outlook\.com|'
      r'icloud\.com|'
      r'[a-zA-Z0-9-.]+\.ac\.id|'
      r'[a-zA-Z0-9-.]+\.edu'
      r')$',
    ).hasMatch(email);

    if (!isValid) {
      return "Email tidak valid";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }

    final password = value;
    bool hasMinLength = password.length >= 6;
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));

    if (!(hasMinLength && hasUppercase && hasLowercase && hasNumber)) {
      return "Min 6 karakter, huruf besar, kecil, dan angka wajib ada";
    }
    return null;
  }
}
