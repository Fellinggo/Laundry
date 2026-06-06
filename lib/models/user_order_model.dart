import 'dart:convert';

import 'package:flutter/material.dart';

class OrderProductItem {
  final String title;
  final int price;
  final int qty;
  final int subtotal;
  final String image;

  OrderProductItem({
    required this.title,
    required this.price,
    required this.qty,
    required this.subtotal,
    required this.image,
  });

  factory OrderProductItem.fromMap(
    Map<
      String,
      dynamic
    >
    map,
  ) {
    return OrderProductItem(
      title:
          map['title'] ??
          'Layanan',
      price:
          map['price']
              is int
          ? map['price']
          : (int.tryParse(
                  map['price'].toString(),
                ) ??
                0),
      qty:
          map['qty']
              is int
          ? map['qty']
          : (int.tryParse(
                  map['qty'].toString(),
                ) ??
                0),
      subtotal:
          map['subtotal']
              is int
          ? map['subtotal']
          : (int.tryParse(
                  map['subtotal'].toString(),
                ) ??
                0),
      image:
          map['image'] ??
          '',
    );
  }

  Map<
    String,
    dynamic
  >
  toMap() {
    return {
      'title': title,
      'price': price,
      'qty': qty,
      'subtotal': subtotal,
      'image': image,
    };
  }
}

class UserOrder {
  final String orderId;
  final String service;
  final String qty;
  final String pickupTime;
  final String deliveryTime;
  final String totalPrice;
  final String address;
  final String itemsJson;
  final String deliveryFee;
  final List<
    OrderProductItem
  >
  orderItems;

  UserOrder({
    required this.orderId,
    required this.service,
    required this.qty,
    required this.pickupTime,
    required this.deliveryTime,
    required this.totalPrice,
    required this.address,
    required this.itemsJson,
    required this.deliveryFee,
    required this.orderItems,
  });

  factory UserOrder.fromQueryString(
    String queryString,
  ) {
    final data = Uri.splitQueryString(
      queryString,
    );

    List<
      OrderProductItem
    >
    orderItems = [];
    if (data['itemsJson'] !=
            null &&
        data['itemsJson']!.isNotEmpty) {
      try {
        final decoded = jsonDecode(
          data['itemsJson']!,
        );
        if (decoded
            is List) {
          orderItems = decoded
              .map(
                (
                  item,
                ) => OrderProductItem.fromMap(
                  item,
                ),
              )
              .toList();
        }
      } catch (
        e
      ) {
        debugPrint(
          'Error decoding itemsJson: $e',
        );
      }
    }

    return UserOrder(
      orderId:
          data['orderId'] ??
          '000000',
      service:
          data['service'] ??
          'Laundry',
      qty:
          data['qty'] ??
          '1',
      pickupTime:
          data['pickupTime'] ??
          '-',
      deliveryTime:
          data['deliveryTime'] ??
          '-',
      totalPrice:
          data['totalPrice'] ??
          'Rp 0',
      address:
          data['address'] ??
          'Alamat tidak tersedia',
      itemsJson:
          data['itemsJson'] ??
          '',
      deliveryFee:
          data['deliveryFee'] ??
          '5000',
      orderItems: orderItems,
    );
  }

  bool get isDummyOrder =>
      orderId ==
      '100001';

  int get totalPriceValue => _parseRupiahToInt(
    totalPrice,
  );

  int get deliveryFeeValue {
    return int.tryParse(
          deliveryFee,
        ) ??
        5000;
  }

  int get grandTotal {
    return totalPriceValue +
        (isDummyOrder
            ? 5000
            : 0);
  }

  String get serviceTitle {
    if (orderItems.isNotEmpty) {
      final titles = orderItems
          .map(
            (
              item,
            ) => item.title,
          )
          .toList();
      return titles.join(
        ', ',
      );
    }
    return service;
  }

  String get dateLabel {
    try {
      final pickup = DateTime.parse(
        pickupTime,
      );
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${pickup.day} ${months[pickup.month - 1]} ${pickup.year}';
    } catch (
      e
    ) {
      return pickupTime;
    }
  }

  static int _parseRupiahToInt(
    String rupiah,
  ) {
    if (rupiah.isEmpty) return 0;
    String cleaned = rupiah
        .replaceAll(
          'Rp ',
          '',
        )
        .replaceAll(
          '.',
          '',
        );
    return int.tryParse(
          cleaned,
        ) ??
        0;
  }

  Map<
    String,
    dynamic
  >
  toMap() {
    return {
      'orderId': orderId,
      'service': service,
      'qty': qty,
      'pickupTime': pickupTime,
      'deliveryTime': deliveryTime,
      'totalPrice': totalPrice,
      'address': address,
      'itemsJson': itemsJson,
      'deliveryFee': deliveryFee,
      'orderItems': orderItems
          .map(
            (
              e,
            ) => e.toMap(),
          )
          .toList(),
    };
  }
}
