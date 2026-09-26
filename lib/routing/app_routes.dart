import 'package:flutter/material.dart';
import 'package:frontend_eco_2/screens/auth/welcome_screen.dart';
import 'package:frontend_eco_2/screens/auth/login_screen.dart';
import 'package:frontend_eco_2/screens/auth/register_screen.dart';
import 'package:frontend_eco_2/screens/auth/onboarding_screen.dart';
import 'package:frontend_eco_2/screens/dashboard/dashboard_screen.dart';
import 'package:frontend_eco_2/screens/notifications/notifications_screen.dart';
import 'package:frontend_eco_2/screens/profile/edit_profile_screen.dart';
import 'package:frontend_eco_2/screens/settings/settings_screen.dart';
import 'package:frontend_eco_2/screens/premium/premium_upgrade_screen.dart';
import 'package:frontend_eco_2/screens/premium/checkout_screen.dart';
import 'package:frontend_eco_2/screens/store/store_screen.dart';
import 'package:frontend_eco_2/screens/help/help_screen.dart';
import 'package:frontend_eco_2/screens/premium/success_screen.dart';
import 'package:frontend_eco_2/screens/profile/trophies_screen.dart';
import 'package:frontend_eco_2/screens/profile/green_footprint_screen.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/missions_tab.dart';
import 'package:frontend_eco_2/screens/garden/plant_detail_screen.dart';
import 'package:frontend_eco_2/screens/garden/care_history_screen.dart';
import 'package:frontend_eco_2/screens/garden/species_detail_screen.dart';
import 'package:frontend_eco_2/screens/scanner_screen.dart';
import 'package:frontend_eco_2/screens/auth/splash_screen.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

class AppRoutes {
  /// Pantalla de arranque: se muestra mientras se comprueba si hay sesion.
  static const String splash = '/splash';
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String myGarden = '/my-garden';
  static const String plantDetail = '/plant-detail';
  static const String speciesDetail = '/species-detail';
  static const String addPlant = '/add-plant';
  static const String careHistory = '/care-history';
  static const String scan = '/scan';
  static const String recordCare = '/record-care';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String greenFootprint = '/green-footprint';
  static const String missions = '/missions';
  static const String trophies = '/trophies';
  static const String premiumUpgrade = '/premium-upgrade';
  static const String store = '/store';
  static const String checkout = '/checkout';
  static const String success = '/success';
  static const String notifications = '/notifications';
  static const String onboarding = '/onboarding';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: routeSettings,
        );
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      // Rutas para pantallas secundarias (inicialmente placeholders sencillos)
      case myGarden:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Mi Jardín'));
      case plantDetail:
        return MaterialPageRoute(
          builder: (_) => const PlantDetailScreen(),
          settings: routeSettings,
        );
      case speciesDetail:
        return MaterialPageRoute(
          builder: (_) => const SpeciesDetailScreen(),
          settings: routeSettings,
        );
      case addPlant:
        // addPlant is shown as a bottom sheet from GardenTab;
        // if navigated directly (e.g. from HomeTab empty state) just go to dashboard.
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case careHistory:
        return MaterialPageRoute(
          builder: (_) => const CareHistoryScreen(),
          settings: routeSettings,
        );
      case scan:
        return MaterialPageRoute(builder: (_) => const ScannerScreen());
      case recordCare:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Registrar Cuidado'));
      case profile:
        return MaterialPageRoute(builder: (_) => _placeholderScreen('Perfil'));
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case greenFootprint:
        return MaterialPageRoute(builder: (_) => const GreenFootprintScreen());
      case missions:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: CustomAppBar(title: AppLocalizations.of(context)!.missions) as PreferredSizeWidget,
            body: const MissionsTab(),
          ),
        );
      case trophies:
        return MaterialPageRoute(builder: (_) => const TrophiesScreen());
      case premiumUpgrade:
        return MaterialPageRoute(builder: (_) => const PremiumUpgradeScreen());
      case store:
        return MaterialPageRoute(builder: (_) => const StoreScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case success:
        return MaterialPageRoute(builder: (_) => const SuccessScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Builder(
                builder: (context) => Text(
                    AppLocalizations.of(context)!.routeNotFound(routeSettings.name ?? '')),
              ),
            ),
          ),
        );
    }
  }

  static Widget _placeholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Pantalla: $title\n(Próximamente en desarrollo)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
