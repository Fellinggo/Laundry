import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/login_modal_sheet.dart';
import '../models/service_model.dart';
import '../../data/service_dummy.dart';

class ServicesController
    extends
        ChangeNotifier {
  bool _loggedIn;
  VoidCallback? _onOpenNotifications;

  List<
    ServiceModel
  >
  _allServices = [];
  List<
    ServiceModel
  >
  _gridServices = [];
  List<
    ServiceModel
  >
  _wideServices = [];

  List<
    ServiceModel
  >
  get gridServices => _gridServices;
  List<
    ServiceModel
  >
  get wideServices => _wideServices;
  bool get isLoggedIn => _loggedIn;

  ServicesController({
    required bool loggedIn,
    VoidCallback? onOpenNotifications,
  }) : _loggedIn = loggedIn,
       _onOpenNotifications = onOpenNotifications {
    _loadServices();
  }

  /// Memperbarui dependensi eksternal dari Screen tanpa membuat ulang instansiasi controller
  void updateDependencies({
    required bool loggedIn,
    VoidCallback? onOpenNotifications,
  }) {
    bool hasChanged = false;
    if (_loggedIn !=
        loggedIn) {
      _loggedIn = loggedIn;
      hasChanged = true;
    }
    if (_onOpenNotifications !=
        onOpenNotifications) {
      _onOpenNotifications = onOpenNotifications;
      hasChanged = true;
    }

    if (hasChanged) {
      notifyListeners();
    }
  }

  void _loadServices() {
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
    if (!_loggedIn) {
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
    if (!_loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }

    _onOpenNotifications?.call();
  }

  void handleProtectedAction(
    BuildContext context,
    VoidCallback action,
  ) {
    if (!_loggedIn) {
      showLoginModal(
        context,
      );
      return;
    }
    action();
  }
}
