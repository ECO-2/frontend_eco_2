import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend_eco_2/services/plant_classifier_service.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_eco_2/screens/auth/app_lock_screen.dart';
import 'firebase_options.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar servicios compartidos
  final storage = SecureStorage();
  final apiClient = ApiClient(storage);

  final authService = AuthService(apiClient, storage);
  final userService = UserService(apiClient);
  final plantsService = PlantsService(apiClient);
  final gamificationService = GamificationService(apiClient);
  final careService = CareService(apiClient);
  final identificationService = IdentificationService(apiClient);
  final notificationService = NotificationService(apiClient);
  final plantClassifierService = PlantClassifierService();
  plantClassifierService.loadModelAndLabels(); // fire-and-forget, carga en paralelo al arranque

  runApp(MyApp(
    storage: storage,
    authService: authService,
    userService: userService,
    plantsService: plantsService,
    gamificationService: gamificationService,
    careService: careService,
    identificationService: identificationService,
    notificationService: notificationService,
    plantClassifierService: plantClassifierService,
  ));
}

class MyApp extends StatelessWidget {
  final SecureStorage storage;
  final AuthService authService;
  final UserService userService;
  final PlantsService plantsService;
  final GamificationService gamificationService;
  final CareService careService;
  final IdentificationService identificationService;
  final NotificationService notificationService;
  final PlantClassifierService plantClassifierService;

  const MyApp({
    super.key,
    required this.storage,
    required this.authService,
    required this.userService,
    required this.plantsService,
    required this.gamificationService,
    required this.careService,
    required this.identificationService,
    required this.notificationService,
    required this.plantClassifierService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CareService>.value(value: careService),
        Provider<IdentificationService>.value(value: identificationService),
        Provider<SecureStorage>.value(value: storage),
        Provider<NotificationService>.value(value: notificationService),
        Provider<PlantClassifierService>.value(value: plantClassifierService),
        // Lo consume GreenFootprintScreen para pedir el CO2 real del jardín.
        Provider<UserService>.value(value: userService),
        // Idioma elegido por el usuario, recordado entre sesiones.
        ChangeNotifierProvider(create: (_) => LocaleProvider(storage)..load()),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            authService: authService,
            userService: userService,
            storage: storage,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PlantsProvider(plantsService: plantsService),
        ),
        ChangeNotifierProvider(
          create: (_) => MissionsProvider(
            gamificationService: gamificationService,
            careService: careService,
          ),
        ),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(
          create: (_) => PlanProvider(userService: userService),
        ),
        ChangeNotifierProvider(
          create: (_) => AvatarsProvider(userService: userService),
        ),
      ],
      // ECO2 no ofrece modo oscuro: la app siempre usa el tema claro,
      // sin importar el ajuste de tema del sistema del teléfono.
      // Consumer y no context.watch: el `context` de este build está por
      // encima del MultiProvider y no vería el LocaleProvider.
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => _AppLoader(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'ECO2',
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          // `locale` null = seguir el idioma del sistema.
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', ''),
            Locale('en', ''),
          ],
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.background,
              elevation: 0,
              foregroundColor: AppColors.textPrimary,
            ),
          ),
          // Arranca en la pantalla de carga, no en la de bienvenida: si hay
          // sesion guardada nunca llega a verse el "Crear cuenta".
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
        ),
      ),
    );
  }
}

/// Widget que intenta restaurar la sesión existente al arrancar la app.
/// Si hay tokens guardados, carga el usuario y redirige al onboarding o dashboard.
class _AppLoader extends StatefulWidget {
  final Widget child;

  const _AppLoader({required this.child});

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.loadCurrentUser();

    if (!mounted) return;

    if (userProvider.isAuthenticated) {
      // Bloqueo biométrico: la sesión ya está restaurada, así que la huella no
      // autentica contra el servidor — solo decide si se deja ver lo que ya
      // hay. Si no pasa, se cierra la sesión y se vuelve al inicio.
      if (!await _passesBiometricGate()) {
        await userProvider.logout();
        if (!mounted) return;
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.welcome,
          (route) => false,
        );
        return;
      }
      if (!mounted) return;

      final user = userProvider.currentUser!;

      if (!user.onboardingCompleted) {
        // Onboarding pendiente — no cargar datos del dashboard todavía.
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.onboarding,
          (route) => false,
        );
        return;
      }

      // Carga paralela de datos del dashboard.
      final plantsProvider = context.read<PlantsProvider>();
      final missionsProvider = context.read<MissionsProvider>();
      final planProvider = context.read<PlanProvider>();
      await Future.wait([
        plantsProvider.init(),
        missionsProvider.init(),
        planProvider.refresh(),
        context.read<AvatarsProvider>().refresh(),
      ]);
      missionsProvider.syncUserPlantsCount(plantsProvider.userPlants.length);

      if (!mounted) return;
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.dashboard,
        (route) => false,
      );
      return;
    }

    // Sin sesion valida: recien aqui se muestra la bienvenida.
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.welcome,
      (route) => false,
    );
  }

  /// Muestra la pantalla de bloqueo si la preferencia está activada.
  /// Devuelve true cuando no hay bloqueo o cuando el sistema confirmó la
  /// identidad.
  Future<bool> _passesBiometricGate() async {
    final storage = context.read<SecureStorage>();
    if (!await storage.isBiometricLockEnabled()) return true;

    final unlocked = await navigatorKey.currentState?.push<bool>(
      MaterialPageRoute(
        builder: (_) => const AppLockScreen(),
        fullscreenDialog: true,
      ),
    );
    return unlocked == true;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
