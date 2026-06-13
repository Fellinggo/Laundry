// lib/models/dummy_orders.dart
import 'dart:convert';

class DummyOrders {
  // Format yang benar: List of Map/Model
  static final List<Map<String, dynamic>> orders = [
    {
      'orderId': '100001',
      'service': 'Cuci Regular',
      'qty': 2,
      'pickupTime': '18:00',
      'deliveryTime': '20:00',
      'totalPrice': 40000,
      'address': 'Jl. Mawar No. 123',
      'items': [
        {
          'title': 'Cuci Regular',
          'qty': 2,
          'price': 20000,
        },
      ],
    },
    {
      'orderId': '100002',
      'service': 'Cuci Setrika',
      'qty': 1,
      'pickupTime': '10:00',
      'deliveryTime': '15:00',
      'totalPrice': 28000,
      'address': 'Jl. Melati No. 45',
      'items': [
        {
          'title': 'Cuci Setrika',
          'qty': 1,
          'price': 28000,
        },
      ],
    },
  ];

  // Konversi orders ke format StringList untuk SharedPreferences
  static List<String> get processOrders {
    return orders.map((order) => jsonEncode(order)).toList();
  }

  // Method untuk mengembalikan data dari StringList
  static List<Map<String, dynamic>> getOrdersFromStrings(List<String>? strings) {
    if (strings == null) return [];
    return strings.map((str) => jsonDecode(str) as Map<String, dynamic>).toList();
  }

  static const String dummyOrderId = '100001';
}