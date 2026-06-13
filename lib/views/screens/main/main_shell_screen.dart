import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../home/home_screen.dart';
import '../order/my_orders_screen.dart';
import '../home/offers_screen.dart';
import '../profile/profile_screen.dart';
import '../home/services_screen.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../../controllers/main/main_shell_controller.dart';
import '../../../controllers/home/notification_controller.dart';
import '../../../controllers/home/home_controller.dart';
import '../../../controllers/order/my_order_controller.dart';

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

class _MainShellScreenState extends State<MainShellScreen> with WidgetsBindingObserver {
  bool _hasInitialized = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasInitialized) {
        final shellProvider = context.read<MainShellController>();
        
        if (shellProvider.currentIndex != widget.initialTabIndex) {
          shellProvider.changeTab(widget.initialTabIndex);
        }
        
        if (widget.refreshMyOrders) {
          _refreshAllData();
        }
        
        _hasInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAllData();
    }
  }

  Future<void> _refreshAllData() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    
    try {
      final shellProvider = context.read<MainShellController>();
      final homeController = context.read<HomeController>();
      final myOrdersController = context.read<MyOrdersController>();
      
      await shellProvider.refreshUser();
      await homeController.updateLoginStatus(shellProvider.isLoggedIn);
      await myOrdersController.loadOrders();
      
      shellProvider.homeScreenKey.currentState?.refreshUserData();
      await shellProvider.refreshMyOrdersData();
      
      debugPrint('🔄 All data refreshed successfully');
    } catch (e) {
      debugPrint('⚠️ Error refreshing data: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shellProvider = context.watch<MainShellController>();
    final homeController = context.watch<HomeController>();

    final isLoggedIn = shellProvider.isLoggedIn;
    final userFirstName = shellProvider.userFirstName;
    final currentIndex = shellProvider.currentIndex;

    // Sinkronkan status login
    if (homeController.isLoggedIn != isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          homeController.updateLoginStatus(isLoggedIn);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(
            key: shellProvider.homeScreenKey,
            loggedIn: isLoggedIn,
            userFirstName: userFirstName,
            onOpenNotifications: () => shellProvider.handleNotificationTap(context),
            onOpenServices: () => shellProvider.goToServicesTab(),
            onOpenServiceDetail: (service) => shellProvider.handleServiceDetail(context, service),
            onOpenDisc: () => shellProvider.goToOffersTab(),
          ),
          MyOrdersScreen(
            key: shellProvider.myOrdersKey,
            loggedIn: isLoggedIn,
          ),
          ServicesScreen(
            loggedIn: isLoggedIn,
            onOpenNotifications: () => shellProvider.handleNotificationTap(context),
          ),
          OffersScreen(
            loggedIn: isLoggedIn,
            onOpenNotifications: () => shellProvider.handleNotificationTap(context),
            onOpenServices: () => shellProvider.goToServicesTab(),
          ),
          ProfileScreen(
            key: ValueKey(isLoggedIn),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) async {
          shellProvider.changeTab(index);
          
          if (index == 0) {
            await homeController.refreshData();
            shellProvider.homeScreenKey.currentState?.refreshUserData();
          } else if (index == 1) {
            await shellProvider.refreshMyOrdersData();
          }
          
          await shellProvider.refreshUser();
        },
      ),
    );
  }
}