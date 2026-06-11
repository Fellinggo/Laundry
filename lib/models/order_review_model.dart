import 'dart:convert';

class OrderItem {
  final String title;
  final int qty;
  final int price;
  final int subtotal;
  final String? image;

  OrderItem({
    required this.title,
    required this.qty,
    required this.price,
    required this.subtotal,
    this.image,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    final qty = _toInt(map['qty']);
    final price = _toInt(map['price']);
    return OrderItem(
      title: map['title'] ?? map['name'] ?? 'Layanan',
      qty: qty,
      price: price,
      subtotal: _toInt(map['subtotal']) != 0
          ? _toInt(map['subtotal'])
          : (qty * price),
      image: map['image'],
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'qty': qty,
      'price': price,
      'subtotal': subtotal,
      'image': image ?? '',
    };
  }
}

class OrderReviewData {
  final List<OrderItem> orderItems;
  final int serviceFee;
  final int deliveryFee;
  final int totalPayment;
  final String pickupTime;
  final String deliveryTime;
  final String address;
  final String? serviceName;
  final int? qty;

  OrderReviewData({
    required this.orderItems,
    required this.serviceFee,
    required this.deliveryFee,
    required this.totalPayment,
    required this.pickupTime,
    required this.deliveryTime,
    required this.address,
    this.serviceName,
    this.qty,
  });

  bool get hasOrderItems => orderItems.isNotEmpty;

  int get totalQty {
    if (orderItems.isNotEmpty) {
      return orderItems.fold(0, (sum, item) => sum + item.qty);
    }
    return qty ?? 1;
  }

  String get serviceSummary {
    if (orderItems.isNotEmpty) {
      return orderItems
          .map((item) => '${item.title} (${item.qty})')
          .join(' + ');
    }
    return serviceName ?? 'Laundry';
  }

  factory OrderReviewData.fromArguments(Map<String, dynamic> args) {
    final List<OrderItem> orderItems = [];

    final items = args['orderItems'] ?? args['items'] ?? [];
    if (items.isNotEmpty) {
      for (var item in items) {
        if (item is Map<String, dynamic>) {
          orderItems.add(OrderItem.fromMap(item));
        }
      }
    }

    final calculatedServiceFee = orderItems.isNotEmpty
        ? orderItems.fold(0, (sum, item) => sum + item.subtotal)
        : _toInt(args['serviceFee']);

    final deliveryFee = _toInt(args['deliveryFee'] ?? 5000);
    final totalPayment = calculatedServiceFee + deliveryFee;

    return OrderReviewData(
      orderItems: orderItems,
      serviceFee: calculatedServiceFee,
      deliveryFee: deliveryFee,
      totalPayment: totalPayment,
      pickupTime: args['pickupTime']?.toString() ?? '-',
      deliveryTime: args['deliveryTime']?.toString() ?? '-',
      address: args['address']?.toString() ?? '-',
      serviceName: args['service']?.toString(),
      qty: _toInt(args['qty']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String encodeItemsToJson() {
    return jsonEncode(orderItems.map((item) => item.toMap()).toList());
  }

  Map<String, dynamic> toPaymentArguments() {
    return {
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
      'serviceFee': serviceFee,
      'deliveryFee': deliveryFee,
      'total': totalPayment,
      'pickupTime': pickupTime,
      'deliveryTime': deliveryTime,
      'address': address,
      'serviceSummary': serviceSummary,
    };
  }
}
