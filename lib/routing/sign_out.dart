import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';

/// Cierra la sesión y deja la pila de navegación vacía.
///
/// Vaciar la pila no es cosmético, es la parte que arregla el fallo: el
/// dashboard vigila `isAuthenticated` en su `build` y, si no hay sesión,
/// navega a la bienvenida. Mientras siguiera vivo debajo de la pila —cosa que
/// pasaba al cerrar sesión con `pushReplacement`, que solo sustituye la
/// pantalla de encima— se reconstruía con cada aviso del proveedor y volvía a
/// navegar, sustituyendo la pantalla que hubiera arriba en ese momento.
///
/// El efecto era este: al pulsar «Iniciar sesión», el proveedor avisaba del
/// cambio a «cargando», el dashboard fantasma despertaba y reemplazaba la
/// pantalla de login por la de bienvenida. Una y otra vez, sin llegar nunca a
/// entrar, hasta reiniciar la aplicación.
///
/// Se usa desde todos los sitios que cierren sesión, para que no vuelva a
/// divergir: antes Perfil no navegaba a ningún sitio y Ajustes usaba
/// `pushReplacement`.
Future<void> signOutAndGoToWelcome(BuildContext context) async {
  final navigator = Navigator.of(context);
  await context.read<UserProvider>().logout();
  if (!context.mounted) return;
  navigator.pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
}
