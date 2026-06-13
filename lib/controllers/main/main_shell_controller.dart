import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/views/widgets/login_modal_sheet.dart';
import '../../models/main/main_shell_model.dart';
import '../../views/screens/home/home_screen.dart';
import '../../views/screens/order/my_orders_screen.dart';
import '../home/home_controller.dart';
import '../order/my_order_controller.dart';

class MainShellController extends ChangeNotifier {
  MainShellState _state = MainShellState(
    selectedIndex: NavigationTarget.home,
    isLoggedIn: false,
    userFirstName: null,
  );

  final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();
  final GlobalKey<MyOrdersScreenState> myOrdersKey = GlobalKey<MyOrdersScreenState>();

  int _tabUpdateTrigger = DateTime.now().millisecondsSinceEpoch;

  // 🔥 TAMBAHKAN REFERENCE KE CONTROLLER
  HomeController? _homeController;
  MyOrdersController? _myOrdersController;

  MainShellState get state => _state;
  int get currentIndex => _state.selectedIndex;
  bool get isLoggedIn => _state.isLoggedIn;
  String? get userFirstName => _state.userFirstName;
  int get tabUpdateTrigger => _tabUpdateTrigger;

  // 🔥 METHOD UNTUK REGISTER CONTROLLER
  void registerControllers(HomeController homeController, MyOrdersController myOrdersController) {
    _homeController = homeController;
    _myOrdersController = myOrdersController;
  }

  MainShellController() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final firstName = loggedIn ? prefs.getString('userName') : null;

    _state = _state.copyWith(
      isLoggedIn: loggedIn,
      userFirstName: firstName,
    );
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await _loadUser();
    
    if (!_state.isLoggedIn) {
      await _homeController?.updateLoginStatus(false);
      _myOrdersController?.clearAllData();
    }
    
    homeScreenKey.currentState?.refreshUserData();
  }

  // 🔥 PERBAIKI METHOD LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');
    await prefs.remove('login_method');
    
    // Clear semua data orders
    await prefs.remove('active_orders');
    await prefs.remove('process_orders');
    await prefs.remove('completed_orders');
    
    // Update state
    _state = _state.copyWith(
      isLoggedIn: false,
      userFirstName: null,
    );
    
    // 🔥 CLEAR CONTROLLER LANGSUNG (tanpa context)
    await _homeController?.updateLoginStatus(false);
    _myOrdersController?.clearAllData();
    
    // Refresh home screen via key
    homeScreenKey.currentState?.refreshUserData();
    
    // Pindah ke tab home
    changeTab(NavigationTarget.home);
    
    notifyListeners();
    debugPrint('✅ Logout berhasil, semua data telah dibersihkan');
  }

  Future<void> refreshMyOrdersData() async {
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