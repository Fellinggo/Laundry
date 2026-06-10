import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        StatelessWidget {
  final bool refreshMyOrders; // PARAMETER BARU

  const MainShellScreen({
    super.key,
    this.refreshMyOrders = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final shellProvider = context
        .watch<
          MainShellController
        >();

    // Jika perlu refresh My Orders, panggil method refresh
    if (refreshMyOrders) {
      WidgetsBinding.instance.addPostFrameCallback(
        (
          _,
        ) {
          shellProvider.refreshMyOrdersData();
        },
      );
    }

    final isLoggedIn = shellProvider.isLoggedIn;
    final userFirstName = shellProvider.userFirstName;
    final currentIndex = shellProvider.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(
            key: shellProvider.homeScreenKey,
            loggedIn: isLoggedIn,
            userFirstName: userFirstName,
            onOpenNotifications: () => shellProvider.handleNotificationTap(
              context,
            ),
            onOpenServices: () => shellProvider.goToServicesTab(),
            onOpenServiceDetail:
                (
                  service,
                ) => shellProvider.handleServiceDetail(
                  context,
                  service,
                ),
            onOpenDisc: () => shellProvider.goToOffersTab(),
          ),
          MyOrdersScreen(
            // GANTI KEY JADI GLOBAL KEY AGAR BISA DI-REFRESH
            key: shellProvider.myOrdersKey,
            loggedIn: isLoggedIn,
          ),
          ServicesScreen(
            loggedIn: isLoggedIn,
            onOpenNotifications: () => shellProvider.handleNotificationTap(
              context,
            ),
          ),
          OffersScreen(
            loggedIn: isLoggedIn,
            onOpenNotifications: () => shellProvider.handleNotificationTap(
              context,
            ),
            onOpenServices: () => shellProvider.goToServicesTab(),
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
              shellProvider.changeTab(
                index,
              );
              shellProvider.refreshUser();
            },
      ),
    );
  }
}
