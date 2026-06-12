import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class OrderItemDetail {
  final String title;
  final int qty;
  final int price;
  final int subtotal;
  final String? image;

  OrderItemDetail({
    required this.title,
    required this.qty,
    required this.price,
    required this.subtotal,
    this.image,
  });

  factory OrderItemDetail.fromMap(Map<String, dynamic> map) {
    return OrderItemDetail(
      title: map['title'] ?? map['name'] ?? 'Layanan',
      qty: _toInt(map['qty']),
      price: _toInt(map['price']),
      subtotal: _toInt(map['subtotal']) != 0
          ? _toInt(map['subtotal'])
          : (_toInt(map['qty']) * _toInt(map['price'])),
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
      'image': image,
    };
  }
}

class OrderDetailData {
  final String orderId;
  final bool isFromActiveOrder;
  final bool isFromProcessOrder;
  final bool isDummyOrder;
  final int activeStepIndex;
  final List<OrderItemDetail> orderItems;
  final int totalQty;
  final int totalProductPrice;
  final String pickupTimeText;
  final String deliveryTimeText;
  final String pickupAddress;
  final String deliveryAddress;
  final int deliveryFee;
  final int grandTotal;
  final String serviceSummary;
  final String durationText;
  final String itemsJson;
  final String statusText;

  OrderDetailData({
    required this.orderId,
    required this.isFromActiveOrder,
    required this.isFromProcessOrder,
    required this.isDummyOrder,
    required this.activeStepIndex,
    required this.orderItems,
    required this.totalQty,
    required this.totalProductPrice,
    required this.pickupTimeText,
    required this.deliveryTimeText,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.deliveryFee,
    required this.grandTotal,
    required this.serviceSummary,
    required this.durationText,
    required this.itemsJson,
    required this.statusText,
  });

  static String _generateOrderId() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      String cleaned = value.replaceAll('Rp ', '').replaceAll('.', '');
      return int.tryParse(cleaned) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }

  static List<OrderItemDetail> _decodeItemsFromJson(String? itemsJson) {
    if (itemsJson == null || itemsJson.isEmpty) return [];
    try {
      final decoded = jsonDecode(itemsJson);
      if (decoded is List) {
        return decoded.map((item) => OrderItemDetail.fromMap(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error decoding items JSON: $e');
      return [];
    }
  }

  static int _calculateDurationMinutes(String pickup, String delivery) {
    try {
      final p = DateTime.parse(pickup);
      final d = DateTime.parse(delivery);
      return d.difference(p).inMinutes;
    } catch (e) {
      return 120;
    }
  }

  factory OrderDetailData.fromArguments(Map<String, dynamic> args) {
    final isFromActiveOrder = args['fromActiveOrder'] == true;
    final isFromProcessOrder = args['fromProcessOrder'] == true;
    final orderIdTemp = args['orderId']?.toString() ?? '';
    final isDummyOrder = orderIdTemp == '100001';
    final activeStepIndex = isDummyOrder ? 2 : 0;

    List<OrderItemDetail> orderItems = [];

    if (args['itemsJson'] != null && args['itemsJson'].toString().isNotEmpty) {
      orderItems = _decodeItemsFromJson(args['itemsJson'].toString());
    }

    if (orderItems.isEmpty &&
        args['orderItems'] != null &&
        args['orderItems'] is List) {
      orderItems = (args['orderItems'] as List)
          .map((item) => OrderItemDetail.fromMap(item))
          .toList();
    }

    if (orderItems.isEmpty && args['items'] != null && args['items'] is List) {
      orderItems = (args['items'] as List)
          .map((item) => OrderItemDetail.fromMap(item))
          .toList();
    }

    final orderId = (isFromActiveOrder || isFromProcessOrder)
        ? (args['orderId']?.toString() ?? '000000')
        : (args['orderId'] ?? _generateOrderId());

    int totalQty = 0;
    int totalProductPrice = 0;

    if (orderItems.isNotEmpty) {
      totalQty = orderItems.fold(0, (sum, item) => sum + item.qty);
      totalProductPrice = orderItems.fold(
        0,
        (sum, item) => sum + item.subtotal,
      );
    } else {
      totalQty = _toInt(args['qty'] ?? 1);
      totalProductPrice = _toInt(args['serviceFee'] ?? 0);
    }

    final pickupTimeText = args['pickupTime']?.toString() ?? '-';
    final deliveryTimeText = args['deliveryTime']?.toString() ?? '-';
    final pickupAddress = args['address']?.toString() ?? 'Alamat belum diisi';
    final deliveryAddress =
        args['deliveryAddress']?.toString() ?? pickupAddress;
    final deliveryFee = _toInt(args['deliveryFee'] ?? 5000);

    final int grandTotal;
    if (isFromActiveOrder || isFromProcessOrder) {
      final savedTotalPrice = args['totalPrice']?.toString() ?? 'Rp 0';
      int savedTotal = _toInt(savedTotalPrice);
      if (isDummyOrder) {
        grandTotal = savedTotal + deliveryFee;
      } else {
        grandTotal = savedTotal;
      }
    } else {
      grandTotal = totalProductPrice + deliveryFee;
    }

    final String serviceSummary = orderItems.isEmpty
        ? (args['service']?.toString() ?? 'Laundry')
        : orderItems.map((item) => '${item.title} (${item.qty})').join(' + ');

    final durationMinutes = _calculateDurationMinutes(
      pickupTimeText,
      deliveryTimeText,
    );
    final durationText = durationMinutes >= 60
        ? '${(durationMinutes / 60).round()} jam'
        : '$durationMinutes menit';

    final itemsJson = jsonEncode(
      orderItems.map((item) => item.toMap()).toList(),
    );
    final statusText = isDummyOrder ? 'Dicuci' : 'Diproses';

    return OrderDetailData(
      orderId: orderId,
      isFromActiveOrder: isFromActiveOrder,
      isFromProcessOrder: isFromProcessOrder,
      isDummyOrder: isDummyOrder,
      activeStepIndex: activeStepIndex,
      orderItems: orderItems,
      totalQty: totalQty,
      totalProductPrice: totalProductPrice,
      pickupTimeText: pickupTimeText,
      deliveryTimeText: deliveryTimeText,
      pickupAddress: pickupAddress,
      deliveryAddress: deliveryAddress,
      deliveryFee: deliveryFee,
      grandTotal: grandTotal,
      serviceSummary: serviceSummary,
      durationText: durationText,
      itemsJson: itemsJson,
      statusText: statusText,
    );
  }
}
