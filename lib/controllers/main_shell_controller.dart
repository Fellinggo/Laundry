import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/views/widgets/login_modal_sheet.dart';
import '../models/main_shell_model.dart';
import '../views/screens/home_screen.dart';

class MainShellController
    extends
        ChangeNotifier {
  MainShellState _state = MainShellState(
    selectedIndex: NavigationTarget.home,
    isLoggedIn: false,
    userFirstName: null,
  );

  final GlobalKey<
    HomeScreenState
  >
  homeScreenKey =
      GlobalKey<
        HomeScreenState
      >();

  // Trigger unik untuk memaksa refresh widget bertipe IndexedStack via key
  int _tabUpdateTrigger = DateTime.now().millisecondsSinceEpoch;

  MainShellState get state => _state;
  int get currentIndex => _state.selectedIndex;
  bool get isLoggedIn => _state.isLoggedIn;
  String? get userFirstName => _state.userFirstName;
  int get tabUpdateTrigger => _tabUpdateTrigger;

  MainShellController() {
    _loadUser();
  }

  Future<
    void
  >
  _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;
    final firstName = loggedIn
        ? prefs.getString(
            'userName',
          )
        : null;

    _state = _state.copyWith(
      isLoggedIn: loggedIn,
      userFirstName: firstName,
    );
    notifyListeners();
  }

  Future<
    void
  >
  refreshUser() async {
    await _loadUser();
    homeScreenKey.currentState?.refreshUserData();
  }

  void changeTab(
    int index,
  ) {
    if (_state.selectedIndex !=
        index) {
      _state = _state.copyWith(
        selectedIndex: index,
      );

      // SETIAP KALI PINDAH TAB, kita update nilai pemicu agar widget dengan key ini di-rebuild ulang datanya
      _tabUpdateTrigger = DateTime.now().millisecondsSinceEpoch;

      notifyListeners();
    }
  }

  void goToServicesTab() => changeTab(
    NavigationTarget.services,
  );
  void goToOffersTab() => changeTab(
    NavigationTarget.offers,
  );
  void goToHomeTab() => changeTab(
    NavigationTarget.home,
  );
  void goToMyOrdersTab() => changeTab(
    NavigationTarget.myOrders,
  );
  void goToProfileTab() => changeTab(
    NavigationTarget.profile,
  );

  void handleNotificationTap(
    BuildContext context,
  ) {
    if (!_state.isLoggedIn) {
      showLoginModal(
        context,
      );
      return;
    }
    Navigator.pushNamed(
      context,
      '/notifications',
    );
  }

  void handleServiceDetail(
    BuildContext context,
    Map<
      String,
      dynamic
    >
    service,
  ) {
    Navigator.pushNamed(
      context,
      '/service-detail',
      arguments: service,
    );
  }

  bool canNavigateToAuthenticatedOnly() {
    return _state.isLoggedIn;
  }
}
