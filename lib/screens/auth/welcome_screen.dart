import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const Spacer(),
                // Centered brand logo (EC + circle O2 logo)
                // Logo con altura controlada para reducir margen transparente
                Image.asset(
                  'assets/images/Variante Tipografica 2.png',
                  height: size.height * 0.25, // Ajusta el tamaño del logo según el tamaño de la pantalla
                  fit: BoxFit.contain,
                ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.15, end: 0, curve: Curves.easeOutQuad),
                
                // Desplazamiento del texto hacia arriba
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Text(
                    AppLocalizations.of(context)!.appTagline,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                      fontFamily: 'DM Sans',
                      letterSpacing: 0.5,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                
                const Spacer(),
                
                // Action Buttons at the bottom
                Column(
                  children: [
                    // Crear Cuenta Button (Dark, top position)
                    CustomButton(
                      text: AppLocalizations.of(context)!.createAccount,
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      height: 56,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Iniciar Sesión Button (Accent/Lime, bottom position)
                    CustomButton(
                      text: AppLocalizations.of(context)!.signIn,
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      height: 56,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ).animate().fadeIn(delay: 450.ms, duration: 700.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
