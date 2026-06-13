import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth/pin_entry_model.dart';

class PinEntryController
    extends
        ChangeNotifier {
  PinEntryModel _model = PinEntryModel.initial();
  bool _isProcessing = false;

  PinEntryModel get model => _model;
  bool get isProcessing => _isProcessing;
  List<
    int
  >
  get digits => _model.digits;
  bool get isPinComplete => _model.isFull;
  String get pinString => _model.pinString;

  void addDigit(
    int digit,
  ) {
    if (_isProcessing) return;
    _model = _model.addDigit(
      digit,
    );
    notifyListeners();
  }

  void removeLastDigit() {
    if (_isProcessing) return;
    _model = _model.removeLastDigit();
    notifyListeners();
  }

  void resetPin() {
    if (_isProcessing) return;
    _model = _model.reset();
    notifyListeners();
  }

  Future<
    void
  >
  saveOrder(
    Map<
      String,
      dynamic
    >
    orderData,
  ) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(
        'active_order_exists',
        true,
      );
      await prefs.setString(
        'active_order_service',
        orderData['service'] ??
            '',
      );
      await prefs.setInt(
        'active_order_qty',
        orderData['qty'] ??
            1,
      );
      await prefs.setString(
        'active_order_pickup',
        orderData['pickupTime'] ??
            '',
      );
      await prefs.setString(
        'active_order_delivery',
        orderData['deliveryTime'] ??
            '',
      );

      _isProcessing = false;
      notifyListeners();
    } catch (
      e
    ) {
      _isProcessing = false;
      notifyListeners();
      rethrow;
    }
  }

  void confirmAndNavigate(
    BuildContext context,
    Map<
      String,
      dynamic
    >
    orderData,
  ) async {
    if (!_model.isFull) return;

    try {
      await saveOrder(
        orderData,
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/order-detail',
          arguments: orderData,
        );
      }
    } catch (
      e
    ) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyimpan pesanan: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void goBack(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }
}
