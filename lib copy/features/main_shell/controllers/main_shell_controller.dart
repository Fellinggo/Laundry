import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Data1/models/main_shell_model.dart';
import '../../home/views/home_screen.dart';
import '../../order/views/my_orders_screen.dart';
import '../../shared/widgets/login_modal_sheet.dart';


class MainShellController extends ChangeNotifier {
  MainShellState _state = MainShellState(
    selectedIndex: NavigationTarget.home,
    isLoggedIn: false,
    userFirstName: null,
  );

  final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

  // GLOBAL KEY UNTUK MY ORDERS SCREEN
  final GlobalKey<MyOrdersScreenState> myOrdersKey =
      GlobalKey<MyOrdersScreenState>();

  int _tabUpdateTrigger = DateTime.now().millisecondsSinceEpoch;

  MainShellState get state => _state;
  int get currentIndex => _state.selectedIndex;
  bool get isLoggedIn => _state.isLoggedIn;
  String? get userFirstName => _state.userFirstName;
  int get tabUpdateTrigger => _tabUpdateTrigger;

  MainShellController() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final firstName = loggedIn ? prefs.getString('userName') : null;

    _state = _state.copyWith(isLoggedIn: loggedIn, userFirstName: firstName);
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await _loadUser();
    homeScreenKey.currentState?.refreshUserData();
  }

  // METHOD BARU: Refresh My Orders Data
  Future<void> refreshMyOrdersData() async {
    // Panggil method refresh dari MyOrdersScreen jika ada
    await myOrdersKey.currentState?.refreshOrders();
    debugPrint('DEBUG - My Orders data refreshed');
  }

  void changeTab(int index) {
    if (_state.selectedIndex != index) {
      _state = _state.copyWith(selectedIndex: index);
      _tabUpdateTrigger = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    }
  }

  void goToServicesTab() => changeTab(NavigationTarget.services);
  void goToOffersTab() => changeTab(NavigationTarget.offers);
  void goToHomeTab() => changeTab(NavigationTarget.home);
  void goToMyOrdersTab() => changeTab(NavigationTarget.myOrders);
  void goToProfileTab() => changeTab(NavigationTarget.profile);

  void handleNotificationTap(BuildContext context) {
    if (!_state.isLoggedIn) {
      showLoginModal(context);
      return;
    }
    Navigator.pushNamed(context, '/notifications');
  }

  void handleServiceDetail(BuildContext context, Map<String, dynamic> service) {
    Navigator.pushNamed(context, '/service-detail', arguments: service);
  }

  bool canNavigateToAuthenticatedOnly() {
    return _state.isLoggedIn;
  }
}
