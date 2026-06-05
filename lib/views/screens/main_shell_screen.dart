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
            loggedIn: isLoggedIn,
            userFirstName: userFirstName,
            onOpenNotifications: _handleNotificationTap,
            onOpenServices: _goToServicesTab,
            onOpenServiceDetail: _goToServiceDetail,
            onOpenDisc: _goToDisc,
          ),
          MyOrdersScreen(
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
