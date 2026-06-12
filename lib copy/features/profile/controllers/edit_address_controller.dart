import 'package:flutter/material.dart';

import '../../../Data1/models/profile/address_model.dart';

class EditAddressController extends ChangeNotifier {
  String _title = '';
  String _address = '';

  // Getters untuk diakses oleh UI
  String get title => _title;
  String get address => _address;

  /// Memuat data awal dari argument halaman (Route Arguments)
  void loadAddress(Map? args) {
    if (args != null) {
      _title = args['title'] ?? '';
      _address = args['address'] ?? '';
    }
  }

  /// Membuat model data alamat yang baru setelah diubah oleh pengguna
  AddressModel saveAddress({required String title, required String address}) {
    _title = title.trim();
    _address = address.trim();

    return AddressModel(title: _title, address: _address);
  }
}
