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

// KOREKSI: Ubah dari StatelessWidget menjadi StatefulWidget
class MainShellScreen extends StatefulWidget {
  final bool refreshMyOrders;
  final int initialTabIndex;

  const MainShellScreen({
    super.key,
    this.refreshMyOrders = false,
    this.initialTabIndex = 0,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  bool _hasInitialized = false; // KOREKSI: Flag untuk mencegah reset berulang

  @override
  void initState() {
    super.initState();
    // KOREKSI: Inisialisasi hanya sekali di initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasInitialized) {
        final shellProvider = context.read<MainShellController>();
        
        // Set tab awal hanya sekali
        if (shellProvider.currentIndex != widget.initialTabIndex) {
          shellProvider.changeTab(widget.initialTabIndex);
        }
        
        // Refresh data jika diperlukan
        if (widget.refreshMyOrders) {
          shellProvider.refreshMyOrdersData();
        }
        
        _hasInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shellProvider = context.watch<MainShellController>();

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
            onOpenServiceDetail: (service) => shellProvider.handleServiceDetail(
              context,
              service,
            ),
            onOpenDisc: () => shellProvider.goToOffersTab(),
          ),
          MyOrdersScreen(
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
            key: ValueKey(isLoggedIn),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          shellProvider.changeTab(index);
          shellProvider.refreshUser();
        },
      ),
    );
  }
}