import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  // ======================
  // GETTER
  // ======================
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ======================
  // ADD ORDER
  // ======================
  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  // ======================
  // DELETE ORDER
  // ======================
  void deleteOrder(String id) {
    _orders.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  // ======================
  // UPDATE ORDER
  // ======================
  void updateOrder(Order updated) {
    final index = _orders.indexWhere((o) => o.id == updated.id);
    if (index != -1) {
      _orders[index] = updated;
      notifyListeners();
    }
  }

  // ======================
  // LOAD ORDERS (DUMMY / API READY)
  // ======================
  Future<void> loadOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // simulasi API call
      await Future.delayed(const Duration(seconds: 1));

      _orders = [
        Order(
          id: "1",
          customerName: "Aury",
          serviceName: "Cuci",
          quantity: 2,
          status: "pending",
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      _error = "Gagal memuat data order";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}