import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/order_model.dart';

class MockOrderService {
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final String jsonString = await rootBundle.loadString('mock/order.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      // Konversi dengan aman
      List<OrderModel> orders = [];
      for (var item in jsonList) {
        if (item is Map<String, dynamic>) {
          orders.add(OrderModel.fromJson(item));
        } else {
          throw Exception('Item is not a Map: $item');
        }
      }
      return orders;
    } catch (e) {
      print('Error parsing JSON: $e');
      rethrow;
    }
  }
}