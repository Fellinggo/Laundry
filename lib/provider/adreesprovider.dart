import 'package:flutter/material.dart';

class Address {
  final String id;
  final String address;

  Address({required this.id, required this.address});
}

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  void addAddress(Address address) {
    _addresses.add(address);
    notifyListeners();
  }

  void updateAddress(Address updated) {
    int index = _addresses.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _addresses[index] = updated;
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}