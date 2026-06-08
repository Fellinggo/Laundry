import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../screens/home_screen.dart';
import '../screens/my_orders_screen.dart';
import '../screens/offers_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/services_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../../controllers/main_shell_controller.dart';

class MainShellScreen
    extends
        StatefulWidget {
  const MainShellScreen({
    super.key,
  });

  @override
  State<
    MainShellScreen
  >
  createState() => _MainShellScreenState();
}

class _MainShellScreenState
    extends
        State<
          MainShellScreen
        > {
  late MainShellController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MainShellController();
    _controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(
        () {},
      );
    }
  }

  void _handleNotificationTap() {
    _controller.handleNotificationTap(
      context,
    );
  }

  void _goToServicesTab() => _controller.goToServicesTab();

  void _goToServiceDetail(
    Map<
      String,
      dynamic
    >
    service,
  ) {
    _controller.handleServiceDetail(
      context,
      service,
    );
  }

  void _goToDisc() => _controller.goToOffersTab();

  @override
  Widget build(
    BuildContext context,
  ) {
    final isLoggedIn = _controller.isLoggedIn;
    final userFirstName = _controller.userFirstName;
    final currentIndex = _controller.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(
            key: _controller.homeScreenKey,
            loggedIn: isLoggedIn,
            userFirstName: userFirstName,
            onOpenNotifications: _handleNotificationTap,
            onOpenServices: _goToServicesTab,
            onOpenServiceDetail: _goToServiceDetail,
            onOpenDisc: _goToDisc,
          ),
          // Tambahkan ValueKey berbasis tabUpdateTrigger agar halaman MyOrdersScreen tahu
          // kapan harus memuat ulang dirinya sendiri saat berpindah tab.
          MyOrdersScreen(
            key: ValueKey(
              'my_orders_tab_${_controller.tabUpdateTrigger}',
            ),
            loggedIn: isLoggedIn,
          ),
          ServicesScreen(
            loggedIn: isLoggedIn,
            onOpenNotifications: _handleNotificationTap,
          ),
          OffersScreen(
            loggedIn: isLoggedIn,
            onOpenNotifications: _handleNotificationTap,
            onOpenServices: _goToServicesTab,
          ),
          ProfileScreen(
            key: ValueKey(
              isLoggedIn,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap:
            (
              index,
            ) {
              _controller.changeTab(
                index,
              );
              _controller.refreshUser();
            },
      ),
    );
  }
}

// Model State & Config tetap sama di bawahnya...
class MainShellState {
  final int selectedIndex;
  final bool isLoggedIn;
  final String? userFirstName;

  MainShellState({
    required this.selectedIndex,
    required this.isLoggedIn,
    this.userFirstName,
  });

  MainShellState copyWith({
    int? selectedIndex,
    bool? isLoggedIn,
    String? userFirstName,
  }) {
    return MainShellState(
      selectedIndex:
          selectedIndex ??
          this.selectedIndex,
      isLoggedIn:
          isLoggedIn ??
          this.isLoggedIn,
      userFirstName:
          userFirstName ??
          this.userFirstName,
    );
  }
}

class NavigationTarget {
  static const int home = 0;
  static const int myOrders = 1;
  static const int services = 2;
  static const int offers = 3;
  static const int profile = 4;
}

class ScreenConfig {
  final int index;
  final String routeName;
  final String title;

  const ScreenConfig({
    required this.index,
    required this.routeName,
    required this.title,
  });

  static const List<
    ScreenConfig
  >
  screens = [
    ScreenConfig(
      index: NavigationTarget.home,
      routeName: '/home',
      title: 'Beranda',
    ),
    ScreenConfig(
      index: NavigationTarget.myOrders,
      routeName: '/my-orders',
      title: 'Pesanan Saya',
    ),
    ScreenConfig(
      index: NavigationTarget.services,
      routeName: '/services',
      title: 'Layanan',
    ),
    ScreenConfig(
      index: NavigationTarget.offers,
      routeName: '/offers',
      title: 'Penawaran',
    ),
    ScreenConfig(
      index: NavigationTarget.profile,
      routeName: '/profile',
      title: 'Profil',
    ),
  ];

  static ScreenConfig? fromIndex(
    int index,
  ) {
    try {
      return screens.firstWhere(
        (
          screen,
        ) =>
            screen.index ==
            index,
      );
    } catch (
      e
    ) {
      return null;
    }
  }
}
