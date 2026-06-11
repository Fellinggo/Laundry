import 'package:flutter/material.dart';

import '../../../Data1/models/address_model.dart';


class AddAddressController extends ChangeNotifier {
  final List<String> titleOptions = [
    'Rumah',
    'Kantor',
    'Kos',
    'Apartemen',
    'Lainnya',
  ];

  String? _selectedTitle;
  String? _titleError;
  String? _addressError;

  // Getters untuk UI
  String? get selectedTitle => _selectedTitle;
  String? get titleError => _titleError;
  String? get addressError => _addressError;

  /// Update pilihan tipe alamat dan hapus error-nya jika ada
  void selectTitle(String? value) {
    _selectedTitle = value;
    _titleError = null;
    notifyListeners();
  }

  /// Validasi internal state
  bool validate(String addressText) {
    final addressValue = addressText.trim();

    // 1. Validasi Tipe Alamat
    if (_selectedTitle == null || _selectedTitle!.isEmpty) {
      _titleError = 'Pilih tipe alamat';
    } else {
      _titleError = null;
    }

    // 2. Validasi Konten Alamat
    if (addressValue.isEmpty) {
      _addressError = 'Alamat tidak boleh kosong';
    } else if (addressValue.length < 10) {
      _addressError = 'Alamat terlalu pendek (minimal 10 karakter)';
    } else {
      _addressError = null;
    }

    notifyListeners();
    return _titleError == null && _addressError == null;
  }

  /// Membuat model data alamat setelah validasi sukses
  AddressModel createAddress(String addressText) {
    return AddressModel(title: _selectedTitle!, address: addressText.trim());
  }

  /// Reset state ketika screen ditutup atau dihancurkan
  void resetState() {
    _selectedTitle = null;
    _titleError = null;
    _addressError = null;
  }
}
