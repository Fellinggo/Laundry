import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/widgets/app_bottom_nav_bar.dart';
import '../constants/app_colors.dart';
import '../widgets/login_modal_sheet.dart';
import 'home_screen.dart';
import 'my_orders_screen.dart';
import 'services_screen.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';

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
  int _index = 0;
  bool loggedIn = false;
  String? userFirstName;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUser();
  }

  Future<
    void
  >
  loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        loggedIn =
            prefs.getBool(
              'isLoggedIn',
            ) ??
            false;
        userFirstName = prefs.getString(
          'userName',
        );
      },
    );
  }

  void _handleNotificationTap() {
    if (!loggedIn) {
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

  void _goToServicesTab() => setState(
    () => _index = 2,
  );

  void _goToServiceDetail(
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

  void _goToDisc() => setState(
    () => _index = 3,
  );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            loggedIn: loggedIn,
            userFirstName: userFirstName,
            onOpenNotifications: _handleNotificationTap,
            onOpenServices: _goToServicesTab,
            onOpenServiceDetail: _goToServiceDetail,
            onOpenDisc: _goToDisc,
          ),

          MyOrdersScreen(
            loggedIn: loggedIn,
          ),

          ServicesScreen(
            loggedIn: loggedIn,
            onOpenNotifications: _handleNotificationTap,
          ),

          OffersScreen(
            loggedIn: loggedIn,
            onOpenNotifications: _handleNotificationTap,
            onOpenServices: _goToServicesTab,
          ),

          ProfileScreen(
            key: ValueKey(
              loggedIn,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _index,
        onTap:
            (
              i,
            ) {
              setState(
                () => _index = i,
              );
              loadUser();
            },
      ),
    );
  }
}
