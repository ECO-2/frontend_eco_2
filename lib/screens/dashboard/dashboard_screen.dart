import 'package:flutter/material.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/garden/rental_expired_dialog.dart';
import 'package:frontend_eco_2/utils/app_tour.dart';
import 'package:frontend_eco_2/widgets/common/custom_bottom_nav_bar.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/home_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/garden_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/scanner_tab.dart';
import 'package:frontend_eco_2/screens/dashboard/tabs/profile_tab.dart';
import 'package:frontend_eco_2/screens/store/store_screen.dart';
import 'package:frontend_eco_2/widgets/dashboard/dashboard_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2; // Default to Dashboard (center tab)
  bool _readInitialTab = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_readInitialTab) return;
    _readInitialTab = true;

    // Pantallas como el detalle de planta vuelven aquí pidiendo una pestaña
    // concreta con `arguments: index`. Nadie leía ese argumento, así que la
    // barra inferior de esas pantallas siempre acababa en el Dashboard.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && args >= 0 && args < 5) {
      _currentIndex = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Sin sesion se vuelve a la bienvenida, pero SOLO si esta pantalla es la
    // que se esta viendo. Un dashboard que quedo debajo en la pila sigue
    // reconstruyendose con cada aviso del proveedor, y sin esta condicion
    // llamaba a pushReplacement desde el fondo: lo que sustituia no era el
    // dashboard sino la pantalla de encima. Al iniciar sesion de nuevo, el
    // simple cambio a "cargando" bastaba para que reemplazara el login por la
    // bienvenida, en bucle, sin llegar nunca a entrar.
    if (!userProvider.isAuthenticated) {
      final route = ModalRoute.of(context);
      if (route?.isCurrent ?? false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.welcome,
            (r) => false,
          );
        });
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ShowCaseWidget(
      enableAutoScroll: true,
      scrollDuration: const Duration(milliseconds: 400),
      onFinish: () {
        Provider.of<SecureStorage>(context, listen: false).markAppTourSeen();
      },
      builder: (context) => _DashboardBody(
        currentIndex: _currentIndex,
        onTabChange: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _DashboardBody extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const _DashboardBody({required this.currentIndex, required this.onTabChange});

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

/// Índice de la pestaña Dashboard, que hace de raíz de la navegación por tabs.
const int _kDashboardTabIndex = 2;

class _DashboardBodyState extends State<_DashboardBody> {
  /// Abre la pestaña Jardín ya posicionada en "Mi Jardín".
  void _openMyGarden() {
    Provider.of<PlantsProvider>(context, listen: false)
        .setShowCatalogTab(false);
    widget.onTabChange(1);
  }

  /// Abre la pestaña Jardín en el catálogo. Es lo que anuncia el ítem
  /// "Jardín" de la barra inferior, así que no debe depender de dónde se haya
  /// dejado el interruptor la última vez.
  void _openCatalog() {
    Provider.of<PlantsProvider>(context, listen: false)
        .setShowCatalogTab(true);
    widget.onTabChange(1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeStartTour();
      // El plan puede haber caducado desde el ultimo arranque, o haberse
      // activado en otro dispositivo: se refresca al entrar para que la
      // insignia no mienta.
      context.read<PlanProvider>().refresh().then((_) {
        // Un alquiler vencido no deberia descubrirse al chocar con el tope:
        // se avisa aqui, una sola vez, en cuanto el plan llega actualizado.
        if (mounted) maybeShowRentalExpired(context);
      });
    });
  }

  Future<void> _maybeStartTour() async {
    if (!mounted) return;
    final storage = Provider.of<SecureStorage>(context, listen: false);
    final seen = await storage.hasSeenAppTour();
    if (seen || !mounted) return;
    ShowCaseWidget.of(context).startShowCase(AppTourKeys.orderedSteps);
  }

  /// Relanza el recorrido manualmente (botón en Perfil) — vuelve primero al
  /// tab de Dashboard, porque ahí es donde viven los widgets señalados
  /// (header con semillas/trofeos/campana, barra inferior).
  void _restartTour() {
    widget.onTabChange(2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ShowCaseWidget.of(context).startShowCase(AppTourKeys.orderedSteps);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const StoreScreen(isTab: true), // Tienda -> Index 0
      const GardenTab(), // Jardin -> Index 1
      HomeTab(
        // "ver todas" sale de la sección "Mi Jardín" del dashboard, así que
        // debe llevar siempre a Mi Jardín. Antes solo cambiaba de pestaña y
        // la vista dependía de dónde se hubiera dejado el interruptor, de
        // modo que normalmente aterrizabas en el catálogo.
        onViewAll: () => _openMyGarden(),
      ), // Dashboard -> Index 2
      const ScannerTab(), // Escaner -> Index 3
      ProfileTab(
        onNavigateToCatalog: () => _openCatalog(),
        onStartTour: _restartTour,
      ), // Perfil -> Index 4
    ];

    PreferredSizeWidget? appBar;
    if (widget.currentIndex == 2) {
      appBar = DashboardHeader(
        seedsKey: AppTourKeys.seedsPill,
        trophyKey: AppTourKeys.trophyIcon,
        bellKey: AppTourKeys.notifBell,
      );
    }

    final showStatusBarInBody = appBar == null;

    final atRoot = widget.currentIndex == _kDashboardTabIndex;

    // El gesto de "atrás" de Android llegaba al Navigator, que no tiene nada
    // que desapilar aquí (Dashboard es la ruta raíz), así que la app se iba a
    // segundo plano desde cualquier pestaña. Ahora solo se permite ese
    // comportamiento estando ya en el Dashboard; desde Perfil, Jardín, Tienda
    // o Escáner el gesto vuelve al Dashboard, como se espera de una barra de
    // pestañas.
    return PopScope(
      canPop: atRoot,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        widget.onTabChange(_kDashboardTabIndex);
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.background,
        appBar: appBar,
        body: Column(
          children: [
            if (showStatusBarInBody) const CustomStatusBar(),
            Expanded(child: tabs[widget.currentIndex]),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: widget.currentIndex,
          onTap: (index) {
            if (index == 3) {
              // Ir directamente a la pantalla de la cámara
              Navigator.pushNamed(context, AppRoutes.scan);
            } else if (index == 1) {
              _openCatalog();
            } else {
              widget.onTabChange(index);
            }
          },
          jardinKey: AppTourKeys.navJardin,
          escanerKey: AppTourKeys.navEscaner,
          tiendaKey: AppTourKeys.navTienda,
          perfilKey: AppTourKeys.navPerfil,
        ),
      ),
    );
  }
}
