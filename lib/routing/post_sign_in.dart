import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/services/services.dart';

/// Lo que hay que hacer después de iniciar sesión, sea como sea que se entró.
///
/// Estaba escrito dentro de la pantalla de login. Al añadir la entrada con
/// Google habría quedado duplicado en tres sitios —login, registro y Google—
/// y basta con que uno se quede atrás para que, por ejemplo, el catálogo
/// aparezca vacío tras entrar por una vía y no por la otra.
Future<void> completeSignIn(BuildContext context) async {
  final userProvider = context.read<UserProvider>();

  // El token de notificaciones se registra en segundo plano: no debe bloquear
  // la navegación, y falla en silencio si el usuario no dio permiso.
  context.read<NotificationService>().registerDeviceToken();

  final user = userProvider.currentUser;

  if (user == null || !user.onboardingCompleted) {
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.onboarding,
      (route) => false,
    );
    return;
  }

  // Se cargan catálogo y progreso ANTES de entrar al dashboard. Sin esto, el
  // catálogo de especies se queda vacío tras un inicio de sesión normal.
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

  if (!context.mounted) return;
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.dashboard,
    (route) => false,
  );
}
