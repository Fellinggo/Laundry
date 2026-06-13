import 'package:flutter/material.dart';

class PickupScheduleData {
  final TimeOfDay? pickupTime;
  final TimeOfDay? deliveryTime;
  final String selectedAddressType;
  final String customAddress;
  final Map<
    String,
    String
  >
  addresses;
  final bool showAddressOptions;
  final bool isLoadingAddresses;
  final bool pickupError;
  final bool deliveryError;

  PickupScheduleData({
    this.pickupTime,
    this.deliveryTime,
    this.selectedAddressType = '',
    this.customAddress = '',
    this.addresses = const {},
    this.showAddressOptions = false,
    this.isLoadingAddresses = true,
    this.pickupError = false,
    this.deliveryError = false,
  });

  String getSelectedAddress() {
    if (selectedAddressType ==
        'Custom') {
      return customAddress;
    }
    if (selectedAddressType.isNotEmpty &&
        addresses.containsKey(
          selectedAddressType,
        )) {
      return addresses[selectedAddressType]!;
    }
    return '';
  }

  bool get isPickupValid =>
      pickupTime !=
      null;
  bool get isDeliveryValid =>
      deliveryTime !=
      null;
  bool get isAddressValid => getSelectedAddress().isNotEmpty;
  bool get isFormValid =>
      isPickupValid &&
      isDeliveryValid &&
      isAddressValid;

  String getFormattedPickupTime() => _formatTime(
    pickupTime,
  );
  String getFormattedDeliveryTime() => _formatTime(
    deliveryTime,
  );

  static String _formatTime(
    TimeOfDay? time,
  ) {
    if (time ==
        null)
      return 'Pilih jam';
    final h = time.hour.toString().padLeft(
      2,
      '0',
    );
    final m = time.minute.toString().padLeft(
      2,
      '0',
    );
    return '$h:$m';
  }

  PickupScheduleData copyWith({
    TimeOfDay? pickupTime,
    TimeOfDay? deliveryTime,
    String? selectedAddressType,
    String? customAddress,
    Map<
      String,
      String
    >?
    addresses,
    bool? showAddressOptions,
    bool? isLoadingAddresses,
    bool? pickupError,
    bool? deliveryError,
  }) {
    return PickupScheduleData(
      pickupTime:
          pickupTime ??
          this.pickupTime,
      deliveryTime:
          deliveryTime ??
          this.deliveryTime,
      selectedAddressType:
          selectedAddressType ??
          this.selectedAddressType,
      customAddress:
          customAddress ??
          this.customAddress,
      addresses:
          addresses ??
          this.addresses,
      showAddressOptions:
          showAddressOptions ??
          this.showAddressOptions,
      isLoadingAddresses:
          isLoadingAddresses ??
          this.isLoadingAddresses,
      pickupError:
          pickupError ??
          this.pickupError,
      deliveryError:
          deliveryError ??
          this.deliveryError,
    );
  }
}

class OrderArgumentData {
  final List<
    dynamic
  >
  items;
  final int serviceFee;
  final int deliveryFee;
  final int total;

  OrderArgumentData({
    required this.items,
    required this.serviceFee,
    required this.deliveryFee,
    required this.total,
  });

  factory OrderArgumentData.fromMap(
    Map<
      String,
      dynamic
    >
    map,
  ) {
    return OrderArgumentData(
      items:
          map['items'] ??
          [],
      serviceFee:
          map['serviceFee'] ??
          0,
      deliveryFee:
          map['deliveryFee'] ??
          5000,
      total:
          map['total'] ??
          0,
    );
  }
}
