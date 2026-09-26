import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Resultado de pedir la huella/rostro, con la razón cuando no se pudo.
enum BiometricOutcome {
  /// El sistema confirmó la identidad.
  success,

  /// La persona canceló o falló la comprobación.
  failed,

  /// El dispositivo no tiene sensor, o no hay ninguna huella registrada.
  unavailable,
}

/// Envoltura de `local_auth`.
///
/// La huella nunca llega a la app: el sistema operativo la verifica y devuelve
/// solo un sí o un no. Por eso esto no reemplaza al login — la sesión sigue
/// siendo el JWT guardado; lo que hace es exigir la huella antes de dejar ver
/// esa sesión ya iniciada.
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Si el dispositivo puede pedir huella o rostro *ahora mismo*. Devuelve
  /// false tanto si no hay sensor como si no hay ninguna huella registrada:
  /// para la app son el mismo caso, no se puede ofrecer el bloqueo.
  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  /// Lanza el diálogo del sistema. [reason] es el texto que este muestra.
  Future<BiometricOutcome> authenticate(String reason) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        // Sin alternativa de PIN: el bloqueo es específicamente biométrico, y
        // el PIN del teléfono ya se pidió al desbloquearlo.
        biometricOnly: true,
        // Si la app pasa a segundo plano durante la comprobación, se reintenta
        // al volver en vez de fallar.
        persistAcrossBackgrounding: true,
      );
      return ok ? BiometricOutcome.success : BiometricOutcome.failed;
    } on PlatformException catch (e) {
      // notAvailable / notEnrolled / passcodeNotSet llegan como excepción, no
      // como false, así que se distinguen aquí para no acusar a la persona de
      // haber fallado la huella cuando el problema es del dispositivo.
      const unavailableCodes = {
        'NotAvailable',
        'NotEnrolled',
        'PasscodeNotSet',
        'BiometricOnlyNotSupported',
      };
      return unavailableCodes.contains(e.code)
          ? BiometricOutcome.unavailable
          : BiometricOutcome.failed;
    }
  }
}
