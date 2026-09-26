import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/services/biometric_service.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';

/// Puerta biométrica al abrir la app cuando el bloqueo está activado.
///
/// Devuelve `true` por `Navigator.pop` si el sistema confirmó la identidad.
/// No valida credenciales: la sesión ya existe (el JWT está guardado); esto
/// solo decide si se deja ver.
class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final _biometrics = BiometricService();
  bool _checking = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prompt());
  }

  Future<void> _prompt() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _failed = false;
    });

    final reason = AppLocalizations.of(context)!.biometricPromptReason;
    final outcome = await _biometrics.authenticate(reason);
    if (!mounted) return;

    switch (outcome) {
      case BiometricOutcome.success:
        Navigator.of(context).pop(true);
      case BiometricOutcome.unavailable:
        // El sensor dejó de estar disponible (huellas borradas, por ejemplo).
        // Dejar la app inaccesible sería peor que el riesgo que cubre, así que
        // se abre igual: el bloqueo es una capa extra, no la sesión.
        Navigator.of(context).pop(true);
      case BiometricOutcome.failed:
        setState(() {
          _checking = false;
          _failed = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // Sin botón de retroceso: salir de aquí sin autenticarse dejaría la sesión
    // a la vista, que es justo lo que el bloqueo evita.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fingerprint_rounded,
                  size: 96,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  l.appLockTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _failed ? l.appLockFailed : l.appLockSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: _failed
                        ? const Color(0xFFE53935)
                        : AppColors.textSecondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: l.appLockRetry,
                    isLoading: _checking,
                    onPressed: _checking ? null : _prompt,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    l.appLockSignOut,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
