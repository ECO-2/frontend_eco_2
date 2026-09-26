import 'package:flutter/material.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';

/// Navegación desde la barra inferior de las pantallas que **no** son el
/// dashboard (detalle de planta, tienda, O2+).
///
/// Cada una lo resolvía a su manera y dos de ellas simplemente hacían `pop()`
/// ignorando qué pestaña se había tocado, así que siempre se acababa en la
/// pantalla anterior — normalmente el dashboard — sin importar el botón
/// pulsado. Centralizarlo evita que vuelva a divergir.
void openDashboardTab(BuildContext context, int index) {
  // El escáner no es una pestaña sino una pantalla propia con la cámara.
  if (index == _kScannerIndex) {
    Navigator.pushNamed(context, AppRoutes.scan);
    return;
  }

  // El índice viaja como argumento; DashboardScreen lo lee al construirse.
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.dashboard,
    (route) => false,
    arguments: index,
  );
}

const int _kScannerIndex = 3;
