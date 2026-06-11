class OrderModel {
  final String orderId;
  final String service;
  final int qty;               // int
  final String pickupTime;
  final String deliveryTime;
  final String totalPrice;        // int
  final String address;
  final String itemsJson;      // jika backend mengirim string JSON

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

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId']?.toString() ?? '',
      service: map['service'] ?? '',
      // parsing qty: pastikan menjadi int
      qty: map['qty'] is int ? map['qty'] : int.tryParse(map['qty']?.toString() ?? '0') ?? 0,
      pickupTime: map['pickupTime'] ?? '',
      deliveryTime: map['deliveryTime'] ?? '',
      // parsing totalPrice: pastikan menjadi int (tanpa 'Rp')
      totalPrice: map['totalPrice'] is int 
          ? map['totalPrice'] 
          : int.tryParse(map['totalPrice']?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0,
      address: map['address'] ?? '',
      itemsJson: map['itemsJson'] ?? '',
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

  bool get isDummyOrder => orderId == '100001';
  int get currentStep => isDummyOrder ? 2 : 0;
  String get badgeLabel => isDummyOrder ? 'Dicuci' : 'Diproses';
  
  // HAPUS baris static Object? fromJson(json) {} yang tidak berguna
}