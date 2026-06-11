class OrderModel {
  final String orderId;
  final String service;
  final String qty;
  final String pickupTime;
  final String deliveryTime;
  final String totalPrice;
  final String address;
  final String itemsJson;

  OrderModel({
    required this.orderId,
    required this.service,
    required this.qty,
    required this.pickupTime,
    required this.deliveryTime,
    required this.totalPrice,
    required this.address,
    required this.itemsJson,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '000000',
      service: map['service'] ?? 'Cuci Regular',
      qty: map['qty'] ?? '1',
      pickupTime: map['pickupTime'] ?? '-',
      deliveryTime: map['deliveryTime'] ?? '-',
      totalPrice: map['totalPrice'] ?? 'Rp 0',
      address: map['address'] ?? '-',
      itemsJson: map['itemsJson'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'service': service,
      'qty': qty,
      'pickupTime': pickupTime,
      'deliveryTime': deliveryTime,
      'totalPrice': totalPrice,
      'address': address,
      'itemsJson': itemsJson,
    };
  }

  bool get isDummyOrder => orderId == '100001';

  int get currentStep => isDummyOrder ? 2 : 0;

  String get badgeLabel => isDummyOrder ? 'Dicuci' : 'Diproses';
}
