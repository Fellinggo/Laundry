import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wushlaundry/constants/app_colors.dart';

// Screens
import 'package:wushlaundry/views/screens/about_screen.dart';
import 'package:wushlaundry/views/screens/add_address_screen.dart';
import 'package:wushlaundry/views/screens/edit_address_screen.dart';
import 'package:wushlaundry/views/screens/help_screen.dart';
import 'package:wushlaundry/views/screens/login_screen.dart';
import 'package:wushlaundry/views/screens/main_shell_screen.dart';
import 'package:wushlaundry/views/screens/my_orders_screen.dart';
import 'package:wushlaundry/views/screens/notifications_screen.dart';
import 'package:wushlaundry/views/screens/offers_screen.dart';
import 'package:wushlaundry/views/screens/onboarding_screen.dart';
import 'package:wushlaundry/views/screens/order_detail_screen.dart';
import 'package:wushlaundry/views/screens/order_review_screen.dart';
import 'package:wushlaundry/views/screens/payment_method_screen.dart';
import 'package:wushlaundry/views/screens/pickup_schedule_screen.dart';
import 'package:wushlaundry/views/screens/pin_entry_screen.dart';
import 'package:wushlaundry/views/screens/privacy_policy_screen.dart';
import 'package:wushlaundry/views/screens/register_screen.dart';
import 'package:wushlaundry/views/screens/service_detail_screen.dart';
import 'package:wushlaundry/views/screens/services_screen.dart';
import 'package:wushlaundry/views/screens/settings_screen.dart';
import 'package:wushlaundry/views/screens/splash_screen.dart';
import 'package:wushlaundry/views/screens/terms_conditions_screen.dart';

void
main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  // Hapus semua data SharedPreferences untuk testing (opsional)
  // await prefs.clear();

  runApp(
    const WushLaundryApp(),
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
