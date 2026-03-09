import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/user_session_service.dart';

// Import all screens
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/train_search_screen.dart';
import 'screens/train_list_screen.dart';
import 'screens/train_details_screen.dart';
import 'screens/berth_selection_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/security_settings_screen.dart';
import 'screens/profile/notifications_screen.dart';
import 'screens/profile/help_support_screen.dart';
import 'screens/profile/about_screen.dart';
import 'screens/profile/terms_screen.dart';
import 'screens/profile/privacy_screen.dart';
import 'screens/passenger_details_screen.dart';
import 'screens/booking_summary_screen.dart';
import 'screens/booking_confirmation_screen.dart';
import 'screens/order_food_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/pnr_enquiry_screen.dart';
import 'screens/my_account_screen.dart';
import 'screens/more_screen.dart';
import 'screens/train_tracking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize user session service
  await UserSessionService.initialize();
  
  runApp(const TrainBookingApp());
}

class TrainBookingApp extends StatelessWidget {
  const TrainBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Transit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/train_search': (context) => const TrainSearchScreen(),
        '/train_list': (context) => TrainListScreen(
          searchArgs: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
        ),
        '/train_details': (context) => const TrainDetailsScreen(),
        '/berth-selection': (context) => BerthSelectionScreen(
          train: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
        ),
        '/passenger-details': (context) => PassengerDetailsScreen(
          arguments: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
        ),
        '/booking-summary': (context) => BookingSummaryScreen(
          arguments: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
        ),
        '/booking-confirmation': (context) => BookingConfirmationScreen(
          arguments: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
        ),
        '/order-food': (context) => OrderFoodScreen(
          arguments: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
        ),
        '/food': (context) => OrderFoodScreen(
          arguments: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?,
        ),
        '/transactions': (context) => const TransactionScreen(),
        '/pnr': (context) => const PNREnquiryScreen(),
        '/track-train': (context) => const TrainTrackingScreen(),
        '/account': (context) => const MyAccountScreen(),
        '/more': (context) => const MoreScreen(),
        // Profile related
        '/profile/edit': (context) => const EditProfileScreen(),
        '/profile/security': (context) => const SecuritySettingsScreen(),
        '/profile/notifications': (context) => const NotificationsScreen(),
        '/profile/help': (context) => const HelpSupportScreen(),
        '/profile/about': (context) => const AboutScreen(),
        '/profile/terms': (context) => const TermsScreen(),
        '/profile/privacy': (context) => const PrivacyScreen(),
      },
    );
  }
}
