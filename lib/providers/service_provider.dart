import 'package:flutter/material.dart';

class Service {
  final String name;
  final int price;

  Service({required this.name, required this.price});
}

class ServiceProvider with ChangeNotifier {
  List<Service> _services = [];

  List<Service> get services => _services;

  void loadServices() {
    _services = [
      Service(name: "Cuci Kering", price: 5000),
      Service(name: "Setrika", price: 3000),
    ];
    notifyListeners();
  }
}
