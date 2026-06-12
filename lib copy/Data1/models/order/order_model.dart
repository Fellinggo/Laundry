class OrderModel {
  final String orderId;
  final String service;
  final int qty;               // dari MockAPI: Number
  final String pickupTime;
  final String deliveryTime;
  final int totalPrice;        // dari MockAPI: Number (bukan String)
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

  /// Parsing dari JSON MockAPI ke object OrderModel
  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId']?.toString() ?? '',
      service: map['service'] ?? '',
      // qty: langsung as int karena dari Number
      qty: map['qty'] as int? ?? 0,
      pickupTime: map['pickupTime'] ?? '',
      deliveryTime: map['deliveryTime'] ?? '',
      // totalPrice: langsung as int karena dari Number
      totalPrice: map['totalPrice'] as int? ?? 0,
      address: map['address'] ?? '',
      itemsJson: map['itemsJson'] ?? '',
    );
  }

  /// Konversi object ke JSON untuk dikirim ke API (POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'service': service,
      'qty': qty,               // langsung kirim int
      'pickupTime': pickupTime,
      'deliveryTime': deliveryTime,
      'totalPrice': totalPrice, // langsung kirim int (karena API terima Number)
      'address': address,
      'itemsJson': itemsJson,
    };
  }

  // Properti tambahan (opsional)
  bool get isDummyOrder => orderId == '100001';
  int get currentStep => isDummyOrder ? 2 : 0;
  String get badgeLabel => isDummyOrder ? 'Dicuci' : 'Diproses';
}