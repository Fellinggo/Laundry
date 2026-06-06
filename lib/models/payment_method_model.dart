import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class PaymentMethodData {
  final String id;
  final String name;
  final String logoLabel;
  final Color color;
  final bool isConnected;

  const PaymentMethodData({
    required this.id,
    required this.name,
    required this.logoLabel,
    required this.color,
    this.isConnected = true,
  });

  static const List<
    PaymentMethodData
  >
  list = [
    PaymentMethodData(
      id: 'dana',
      name: 'DANA',
      logoLabel: 'D',
      color: Color(
        0xFF118EEA,
      ),
      isConnected: true,
    ),
    PaymentMethodData(
      id: 'ovo',
      name: 'OVO',
      logoLabel: 'O',
      color: Color(
        0xFF6B2C91,
      ),
      isConnected: true,
    ),
    PaymentMethodData(
      id: 'bca',
      name: 'BCA',
      logoLabel: 'B',
      color: AppColors.headerNavy,
      isConnected: false,
    ),
    PaymentMethodData(
      id: 'bni',
      name: 'BNI',
      logoLabel: 'N',
      color: Color(
        0xFF00529C,
      ),
      isConnected: false,
    ),
    PaymentMethodData(
      id: 'mandiri',
      name: 'Mandiri',
      logoLabel: 'M',
      color: Color(
        0xFFFF6B00,
      ),
      isConnected: false,
    ),
  ];
}
