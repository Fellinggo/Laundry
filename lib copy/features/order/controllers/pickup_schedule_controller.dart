import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Data1/models/pickup_schedule_model.dart';
import '../../profile/controllers/address_selector_controller.dart';


class PickupScheduleController extends ChangeNotifier {
  PickupScheduleData _data = PickupScheduleData();
  final TextEditingController customAddressController = TextEditingController();

  PickupScheduleData get data => _data;
  bool get isLoadingAddresses => _data.isLoadingAddresses;
  bool get isFormValid => _data.isFormValid;

  PickupScheduleController() {
    loadAddressesFromPrefs();
  }

  Future<void> loadAddressesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final email = prefs.getString('userEmail') ?? '';

    if (!isLoggedIn) {
      _data = _data.copyWith(
        addresses: {},
        selectedAddressType: '',
        isLoadingAddresses: false,
      );
      notifyListeners();
      return;
    }

    final addressKey = 'userAddresses_$email';
    final titlesKey = 'userAddressTitles_$email';

    final savedAddresses = prefs.getStringList(addressKey) ?? [];
    final savedTitles = prefs.getStringList(titlesKey) ?? [];

    if (savedAddresses.isNotEmpty) {
      final Map<String, String> addresses = {};
      for (int i = 0; i < savedAddresses.length; i++) {
        final title = i < savedTitles.length
            ? savedTitles[i]
            : 'Alamat ${i + 1}';
        addresses[title] = savedAddresses[i];
      }
      _data = _data.copyWith(
        addresses: addresses,
        selectedAddressType: savedTitles.isNotEmpty
            ? savedTitles[0]
            : 'Alamat 1',
        isLoadingAddresses: false,
      );
    } else {
      _data = _data.copyWith(
        addresses: {},
        selectedAddressType: '',
        isLoadingAddresses: false,
      );
    }
    notifyListeners();
  }

  void setPickupTime(TimeOfDay? time) {
    _data = _data.copyWith(pickupTime: time, pickupError: false);
    notifyListeners();
  }

  void setDeliveryTime(TimeOfDay? time) {
    _data = _data.copyWith(deliveryTime: time, deliveryError: false);
    notifyListeners();
  }

  Future<void> pickTime(BuildContext context, bool isPickup) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (isPickup) {
        setPickupTime(picked);
      } else {
        setDeliveryTime(picked);
      }
    }
  }

  void validateAndNavigate(BuildContext context, Map<String, dynamic> args) {
    bool hasError = false;

    if (!_data.isPickupValid) {
      _data = _data.copyWith(pickupError: true);
      hasError = true;
    }
    if (!_data.isDeliveryValid) {
      _data = _data.copyWith(deliveryError: true);
      hasError = true;
    }
    notifyListeners();

    if (hasError) return;

    final addressController = context.read<AddressSelectorController>();

    addressController.useCustomAddress();
    addressController.saveAddressIfNeeded();

    final selectedAddress = addressController.getSelectedAddress();
    final selectedAddressType = addressController.selectedAddressType;

    if (!addressController.isAddressValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih alamat terlebih dahulu')),
      );
      return;
    }

    final orderArgs = OrderArgumentData.fromMap(args);

    Navigator.pushNamed(
      context,
      '/order-review',
      arguments: {
        'items': orderArgs.items,
        'serviceFee': orderArgs.serviceFee,
        'deliveryFee': orderArgs.deliveryFee,
        'total': orderArgs.total,
        'pickupTime': _data.getFormattedPickupTime(),
        'deliveryTime': _data.getFormattedDeliveryTime(),
        'address': selectedAddress,
        'addressType': selectedAddressType,
      },
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    customAddressController.dispose();
    super.dispose();
  }
}
