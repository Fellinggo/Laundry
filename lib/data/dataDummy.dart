import 'dart:convert';

class DummyOrders {
  static List<String> processOrders = [
    Uri(
      queryParameters: {
        'orderId': '100001',
        'service': 'Cuci Regular',
        'qty': '2',
        'pickupTime': '18:00',
        'deliveryTime': '20:00',
        'totalPrice': 'Rp 40.000',
        'address': 'Jl. Mawar No. 123',
        'itemsJson': jsonEncode([
          {'title': 'Cuci Regular', 'qty': 2, 'price': 20000},
        ]),
      },
    ).query,
  ];

  static const String dummyOrderId = '100001';
}
