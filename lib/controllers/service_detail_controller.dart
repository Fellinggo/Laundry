import 'package:flutter/material.dart';
import '../models/order_item_model.dart';
import '../models/service_detail_model.dart';
import '../../data/service_dummy.dart';

class ServiceDetailController
    extends
        ChangeNotifier {
  ServiceDetailModel _model;
  bool _isInit = true;

  ServiceDetailModel get model => _model;
  bool get hasSelectedServices => _model.hasSelectedServices;
  int get totalServiceFee => _model.totalServiceFee;
  int get grandTotal => _model.grandTotal;
  int get deliveryFee => _model.deliveryFee;

  ServiceDetailController()
    : _model = ServiceDetailModel(
        services: [],
        selectedServices: {},
      ) {
    _loadServices();
  }

  void _loadServices() {
    final services = serviceDummy.map(
      (
        e,
      ) {
        return OrderItemModel(
          title: e.title,
          displayTitle:
              e.title ==
                  'Cuci Bedcover / Selimut / Sprei'
              ? 'Cuci Bedcover /\nSelimut / Sprei'
              : e.title,
          price: e.price,
          image: e.imagePath,
          icon: _getIcon(
            e.title,
          ),
        );
      },
    ).toList();

    _model = ServiceDetailModel(
      services: services,
      selectedServices: {},
    );
    notifyListeners();
  }

  IconData _getIcon(
    String title,
  ) {
    switch (title) {
      case 'Cuci Regular':
        return Icons.local_laundry_service;
      case 'Cuci Setrika':
        return Icons.iron;
      case 'Cuci Kering':
        return Icons.dry_cleaning_outlined;
      case 'Paket Service':
        return Icons.inventory_2_outlined;
      case 'Cuci Jas / Gaun':
        return Icons.checkroom;
      case 'Setrika Saja':
        return Icons.iron_outlined;
      case 'Cuci Bedcover / Selimut / Sprei':
        return Icons.bed;
      case 'Cuci Sepatu':
        return Icons.hiking;
      default:
        return Icons.local_laundry_service;
    }
  }

  void initializeWithArgument(
    Map<
      String,
      dynamic
    >?
    args,
  ) {
    if (!_isInit) return;

    if (args !=
            null &&
        args['title'] !=
            null) {
      final index = _model.services.indexWhere(
        (
          s,
        ) =>
            s.title ==
            args['title'],
      );

      if (index !=
          -1) {
        final newSelected =
            Map<
              int,
              int
            >.from(
              _model.selectedServices,
            );
        newSelected[index] = 1;
        _model = _model.copyWith(
          selectedServices: newSelected,
        );
        notifyListeners();
      }
    }

    _isInit = false;
  }

  void toggleServiceSelection(
    int index,
    bool isSelected,
  ) {
    final newSelected =
        Map<
          int,
          int
        >.from(
          _model.selectedServices,
        );

    if (isSelected) {
      newSelected[index] = 1;
    } else {
      newSelected.remove(
        index,
      );
    }

    _model = _model.copyWith(
      selectedServices: newSelected,
    );
    notifyListeners();
  }

  void updateQuantity(
    int index,
    int newQuantity,
  ) {
    if (newQuantity <=
        0) {
      toggleServiceSelection(
        index,
        false,
      );
    } else {
      final newSelected =
          Map<
            int,
            int
          >.from(
            _model.selectedServices,
          );
      newSelected[index] = newQuantity;
      _model = _model.copyWith(
        selectedServices: newSelected,
      );
      notifyListeners();
    }
  }

  void navigateToPickupSchedule(
    BuildContext context,
  ) {
    if (!_model.hasSelectedServices) return;

    Navigator.pushNamed(
      context,
      '/pickup-schedule',
      arguments: {
        'items': _model.orderItems,
        'serviceFee': _model.totalServiceFee,
        'deliveryFee': _model.deliveryFee,
        'total': _model.grandTotal,
      },
    );
  }

  void goBack(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }

  String formatPrice(
    int value,
  ) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }
}
