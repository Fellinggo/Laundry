import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/controllers/home_controller.dart';
import 'core/constants/app_colors.dart';

// Controllers / Providers
import 'features/auth/controllers/login_controller.dart';
import 'features/auth/controllers/onboarding_controller.dart';
import 'features/auth/controllers/register_controller.dart';
import 'features/auth/controllers/splash_controller.dart';
import 'features/help/controllers/help_controller.dart';
import 'features/home/controllers/offer_controller.dart';
import 'features/home/controllers/service_controller.dart';
import 'features/home/controllers/service_detail_controller.dart';
import 'features/main_shell/controllers/main_shell_controller.dart';
import 'features/notification/controllers/notification_controller.dart';
import 'features/order/controllers/my_order_controller.dart';
import 'features/order/controllers/payment_method_controller.dart';
import 'features/order/controllers/pickup_schedule_controller.dart';
import 'features/order/controllers/pin_entry_controller.dart';
import 'features/profile/controllers/about_controller.dart';
import 'features/profile/controllers/add_address_controller.dart';
import 'features/profile/controllers/edit_address_controller.dart';
import 'features/profile/controllers/privacy_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/profile/controllers/setting_controller.dart';
import 'features/profile/controllers/terms_controller.dart';


// Screens
import 'features/auth/views/login_screen.dart';
import 'features/auth/views/onboarding_screen.dart';
import 'features/auth/views/register_screen.dart';
import 'features/auth/views/splash_screen.dart';
import 'features/help/views/help_screen.dart';
import 'features/profile/views/about_screen.dart';
import 'features/order/views/my_orders_screen.dart';
import 'features/order/views/order_detail_screen.dart';
import 'features/order/views/order_review_screen.dart';
import 'features/order/views/payment_method_screen.dart';
import 'features/order/views/pickup_schedule_screen.dart';
import 'features/order/views/pin_entry_screen.dart';
import 'features/notification/views/notifications_screen.dart';
import 'features/profile/views/add_address_screen.dart';
import 'features/home/views/services_screen.dart';
import 'features/main_shell/views/main_shell_screen.dart';
import 'features/profile/views/edit_address_screen.dart';
import 'features/profile/views/privacy_policy_screen.dart';
import 'features/profile/views/settings_screen.dart';
import 'features/profile/views/terms_conditions_screen.dart';
import 'features/home/views/offers_screen.dart';
import 'features/home/views/service_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        // Provider tanpa parameter
        ChangeNotifierProvider(create: (_) => MainShellController()),
        ChangeNotifierProvider(create: (_) => AboutController()),
        ChangeNotifierProvider(create: (_) => AddAddressController()),
        ChangeNotifierProvider(create: (_) => EditAddressController()),
        ChangeNotifierProvider(create: (_) => HelpController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => NotificationsController()),
        ChangeNotifierProvider(create: (_) => OnboardingController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => PickupScheduleController()),
        ChangeNotifierProvider(create: (_) => PinEntryController()),
        ChangeNotifierProvider(create: (_) => PrivacyPolicyController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(create: (_) => ServiceDetailController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_) => TermsController()),

        // Provider dengan parameter - gunakan nilai dari SharedPreferences
        ChangeNotifierProvider(
          create: (_) => MyOrdersController(loggedIn: isLoggedIn),
        ),
        ChangeNotifierProvider(
          create: (_) => OffersController(loggedIn: isLoggedIn),
        ),
        ChangeNotifierProvider(
          create: (_) => ServicesController(loggedIn: isLoggedIn),
        ),
      ],
      child: const WushLaundryApp(),
    ),
  );
}

class WushLaundryApp extends StatelessWidget {
  const WushLaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
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

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case '/onboarding':
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case '/main':
        return MaterialPageRoute(
          builder: (_) => const MainShellScreen(),
          settings: settings,
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case '/services':
        return MaterialPageRoute(
          builder: (_) => const ServicesScreen(),
          settings: settings,
        );
      case '/edit-address':
        return MaterialPageRoute(
          builder: (_) => const EditAddressScreen(),
          settings: settings,
        );
      case '/add-address':
        return MaterialPageRoute(
          builder: (_) => const AddAddressScreen(),
          settings: settings,
        );
      case '/service-detail':
        return MaterialPageRoute(
          builder: (_) => const ServiceDetailScreen(),
          settings: settings,
        );
      case '/pickup-schedule':
        return MaterialPageRoute(
          builder: (_) => const PickupScheduleScreen(),
          settings: settings,
        );
      case '/order-review':
        return MaterialPageRoute(
          builder: (_) => const OrderReviewScreen(),
          settings: settings,
        );
      case '/payment':
        return MaterialPageRoute(
          builder: (_) => const PaymentMethodScreen(),
          settings: settings,
        );
      case '/pin':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final wallet = args['wallet'] ?? 'DANA';
        return MaterialPageRoute(
          builder: (_) => PinEntryScreen(walletName: wallet),
          settings: settings,
        );
      case '/order-detail':
        return MaterialPageRoute(
          builder: (_) => const OrderDetailScreen(),
          settings: settings,
        );
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case '/my-orders':
        return MaterialPageRoute(
          builder: (_) => const MyOrdersScreen(),
          settings: settings,
        );
      case '/offers-full':
        return MaterialPageRoute(
          builder: (_) => const OffersScreen(),
          settings: settings,
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      case '/privacy':
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyScreen(),
          settings: settings,
        );
      case '/terms':
        return MaterialPageRoute(
          builder: (_) => const TermsConditionsScreen(),
          settings: settings,
        );
      case '/help':
        return MaterialPageRoute(
          builder: (_) => const HelpScreen(),
          settings: settings,
        );
      case '/about':
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
          settings: settings,
        );
    }
  }
}
