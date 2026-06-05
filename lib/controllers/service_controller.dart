import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/login_modal_sheet.dart';
import '../models/service_model.dart'; // ← Import model yang benar
import '../../data/service_dummy.dart';

class ServicesController
    extends
        ChangeNotifier {
  final bool loggedIn;
  final VoidCallback? onOpenNotifications;

  List<
    ServiceModel
  >
  _allServices = []; // ← pakai ServiceModel
  List<
    ServiceModel
  >
  _gridServices = []; // ← pakai ServiceModel
  List<
    ServiceModel
  >
  _wideServices = []; // ← pakai ServiceModel

  List<
    ServiceModel
  >
  get gridServices => _gridServices;
  List<
    ServiceModel
  >
  get wideServices => _wideServices;
  bool get isLoggedIn => loggedIn;

  ServicesController({
    required this.loggedIn,
    this.onOpenNotifications,
  }) {
    _loadServices();
  }

  void _loadServices() {
    // Konversi dari serviceDummy (data mentah) ke ServiceModel
    _allServices = serviceDummy
        .map(
          (
            service,
          ) => ServiceModel.fromDummy(
            service,
          ),
        )
        .toList();

    _gridServices = _allServices
        .where(
          (
            service,
          ) => !service.isWide,
        )
        .toList();

    _wideServices = _allServices
        .where(
          (
            service,
          ) => service.isWide,
        )
        .toList();

    notifyListeners();
  }

  void handleServiceTap(
    BuildContext context,
    String serviceTitle,
  ) {
    if (!loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/service-detail',
      arguments: {
        'title': serviceTitle,
      },
    );
  }

  void handleNotificationTap(
    BuildContext context,
  ) {
    if (!loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }

    onOpenNotifications?.call();
  }

  void handleProtectedAction(
    BuildContext context,
    VoidCallback action,
  ) {
    if (!loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }
    action();
  }
}
