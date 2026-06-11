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

  // ✅ Factory constructor untuk parsing JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] ?? '',
      service: json['service'] ?? '',
      qty: json['qty']?.toString() ?? '0',
      pickupTime: json['pickupTime'] ?? '',
      deliveryTime: json['deliveryTime'] ?? '',
      totalPrice: json['totalPrice']?.toString() ?? '0',
      address: json['address'] ?? '',
      itemsJson: json['itemsJson'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
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

  // Method lain tetap bisa dipertahankan
  bool get isDummyOrder => orderId == '100001';
  int get currentStep => isDummyOrder ? 2 : 0;
  String get badgeLabel => isDummyOrder ? 'Dicuci' : 'Diproses';
}