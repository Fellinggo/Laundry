import 'package:flutter/material.dart';

class OrderItemModel {
  final String title;
  final String displayTitle;
  final String price;
  final String image;
  final IconData icon;
  int quantity;

  OrderItemModel({
    required this.title,
    required this.displayTitle,
    required this.price,
    required this.image,
    required this.icon,
    this.quantity = 0,
  });

  int get priceValue {
    return int.parse(price.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  int get subtotal => priceValue * quantity;

  Map<String, dynamic> toOrderMap() {
    return {
      'title': title,
      'price': priceValue,
      'qty': quantity,
      'subtotal': subtotal,
      'image': image,
    };
  }

  factory OrderItemModel.fromService(Map<String, dynamic> service) {
    return OrderItemModel(
      title: service['title'],
      displayTitle: service['displayTitle'] ?? service['title'],
      price: service['price'],
      image: service['image'],
      icon: service['icon'],
    );
  }
}
