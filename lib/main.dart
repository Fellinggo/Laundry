import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/controllers/auth/onboarding_controller.dart';

import 'package:wushlaundry/core/constants/app_colors.dart';

// Controllers / Providers
import 'package:wushlaundry/controllers/setting/about_controller.dart';
import 'package:wushlaundry/controllers/profile/add_address_controller.dart';
import 'package:wushlaundry/controllers/profile/edit_address_controller.dart';
import 'package:wushlaundry/controllers/setting/help_controller.dart';
import 'package:wushlaundry/controllers/home/home_controller.dart';
import 'package:wushlaundry/controllers/auth/login_controller.dart';
import 'package:wushlaundry/controllers/main/main_shell_controller.dart';
import 'package:wushlaundry/controllers/order/my_order_controller.dart';
import 'package:wushlaundry/controllers/home/notification_controller.dart';
import 'package:wushlaundry/controllers/home/offer_controller.dart';
import 'package:wushlaundry/controllers/order/payment_method_controller.dart';
import 'package:wushlaundry/controllers/order/pickup_schedule_controller.dart';
import 'package:wushlaundry/controllers/order/pin_entry_controller.dart';
import 'package:wushlaundry/controllers/setting/privacy_controller.dart';
import 'package:wushlaundry/controllers/profile/profile_controller.dart';
import 'package:wushlaundry/controllers/auth/register_controller.dart';
import 'package:wushlaundry/controllers/home/service_controller.dart';
import 'package:wushlaundry/controllers/home/service_detail_controller.dart';
import 'package:wushlaundry/controllers/setting/setting_controller.dart';
import 'package:wushlaundry/controllers/auth/splash_controller.dart';
import 'package:wushlaundry/controllers/setting/terms_controller.dart';

// Screens
import 'package:wushlaundry/views/screens/setting/about_screen.dart';
import 'package:wushlaundry/views/screens/profile/add_address_screen.dart';
import 'package:wushlaundry/views/screens/profile/edit_address_screen.dart';
import 'package:wushlaundry/views/screens/setting/help_screen.dart';
import 'package:wushlaundry/views/screens/auth/login_screen.dart';
import 'package:wushlaundry/views/screens/main/main_shell_screen.dart';
import 'package:wushlaundry/views/screens/order/my_orders_screen.dart';
import 'package:wushlaundry/views/screens/home/notifications_screen.dart';
import 'package:wushlaundry/views/screens/home/offers_screen.dart';
import 'package:wushlaundry/views/screens/auth/onboarding_screen.dart';
import 'package:wushlaundry/views/screens/order/order_detail_screen.dart';
import 'package:wushlaundry/views/screens/order/order_review_screen.dart';
import 'package:wushlaundry/views/screens/order/payment_method_screen.dart';
import 'package:wushlaundry/views/screens/order/pickup_schedule_screen.dart';
import 'package:wushlaundry/views/screens/order/pin_entry_screen.dart';
import 'package:wushlaundry/views/screens/setting/privacy_policy_screen.dart';
import 'package:wushlaundry/views/screens/auth/register_screen.dart';
import 'package:wushlaundry/views/screens/home/service_detail_screen.dart';
import 'package:wushlaundry/views/screens/home/services_screen.dart';
import 'package:wushlaundry/views/screens/setting/settings_screen.dart';
import 'package:wushlaundry/views/screens/auth/splash_screen.dart';
import 'package:wushlaundry/views/screens/setting/terms_conditions_screen.dart';

void
main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn =
      prefs.getBool(
        'isLoggedIn',
      ) ??
      false;

  runApp(
    MultiProvider(
      providers: [
        // Provider tanpa parameter
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => MainShellController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => AboutController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => AddAddressController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => EditAddressController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => HelpController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => HomeController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => LoginController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => NotificationsController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => OnboardingController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => PaymentController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => PickupScheduleController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => PinEntryController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => PrivacyPolicyController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => ProfileController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => RegisterController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => ServiceDetailController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => SettingsController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => SplashController(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => TermsController(),
        ),

        // Provider dengan parameter - gunakan nilai dari SharedPreferences
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => MyOrdersController(
                loggedIn: isLoggedIn,
              ),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => OffersController(
                loggedIn: isLoggedIn,
              ),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => ServicesController(
                loggedIn: isLoggedIn,
              ),
        ),
      ],
      child: const WushLaundryApp(),
    ),
  );
}

class WushLaundryApp
    extends
        StatelessWidget {
  const WushLaundryApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      title: 'Wush Laundry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNavy,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.pageBg,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<
    dynamic
  >?
  _onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const SplashScreen(),
          settings: settings,
        );
      case '/onboarding':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const OnboardingScreen(),
          settings: settings,
        );
      case '/main':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const MainShellScreen(),
          settings: settings,
        );
      case '/login':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const LoginScreen(),
          settings: settings,
        );
      case '/register':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const RegisterScreen(),
          settings: settings,
        );
      case '/services':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const ServicesScreen(),
          settings: settings,
        );
      case '/edit-address':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const EditAddressScreen(),
          settings: settings,
        );
      case '/add-address':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const AddAddressScreen(),
          settings: settings,
        );
      case '/service-detail':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const ServiceDetailScreen(),
          settings: settings,
        );
      case '/pickup-schedule':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const PickupScheduleScreen(),
          settings: settings,
        );
      case '/order-review':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const OrderReviewScreen(),
          settings: settings,
        );
      case '/payment':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const PaymentMethodScreen(),
          settings: settings,
        );
      case '/pin':
        final args =
            settings.arguments
                as Map<
                  String,
                  dynamic
                >? ??
            {};
        final wallet =
            args['wallet'] ??
            'DANA';
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => PinEntryScreen(
                walletName: wallet,
              ),
          settings: settings,
        );
      case '/order-detail':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const OrderDetailScreen(),
          settings: settings,
        );
      case '/notifications':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const NotificationsScreen(),
          settings: settings,
        );
      case '/my-orders':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const MyOrdersScreen(),
          settings: settings,
        );
      case '/offers-full':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const OffersScreen(),
          settings: settings,
        );
      case '/settings':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const SettingsScreen(),
          settings: settings,
        );
      case '/privacy':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const PrivacyPolicyScreen(),
          settings: settings,
        );
      case '/terms':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const TermsConditionsScreen(),
          settings: settings,
        );
      case '/help':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const HelpScreen(),
          settings: settings,
        );
      case '/about':
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const AboutScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const Scaffold(
                body: Center(
                  child: Text(
                    'Route not found',
                  ),
                ),
              ),
          settings: settings,
        );
    }
  }
}
