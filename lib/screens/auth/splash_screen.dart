import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Pantalla de arranque mientras se restaura la sesión guardada.
///
/// Antes la app arrancaba directamente en la pantalla de bienvenida y solo
/// después consultaba si había sesión, así que quien ya había iniciado sesión
/// veía igualmente el "Crear cuenta / Iniciar sesión" un instante antes de que
/// la app saltara al dashboard. Ahora se espera aquí y se va a un sitio o al
/// otro sin ese parpadeo.
///
/// Usa el mismo degradado que la bienvenida para que la transición, cuando sí
/// toca mostrarla, no se note como un cambio de pantalla.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.welcomeGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Variante Tipografica 2.png',
                height: size.height * 0.25,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
