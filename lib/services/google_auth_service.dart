import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Resultado de intentar entrar con Google.
///
/// Se distingue «el usuario cerró el diálogo» de «algo falló» porque cancelar
/// no es un error: mostrar un aviso rojo a quien simplemente cambió de idea
/// es ruido, y además tapa los fallos de verdad.
enum GoogleAuthOutcome { success, cancelled, failed }

class GoogleAuthResult {
  final GoogleAuthOutcome outcome;

  /// Token de Firebase que el backend verifica en POST /auth/firebase.
  final String? idToken;

  /// Detalle técnico del fallo, para registrar. No se enseña al usuario.
  final String? detail;

  const GoogleAuthResult(this.outcome, {this.idToken, this.detail});
}

/// Inicio de sesión con Google.
///
/// El flujo tiene dos saltos: Google devuelve sus credenciales, Firebase las
/// convierte en una identidad propia, y solo entonces se manda su token al
/// backend. La API nunca recibe credenciales de Google directamente; recibe un
/// token de Firebase que verifica contra sus propias claves.
class GoogleAuthService {
  final GoogleSignIn _google;
  final FirebaseAuth _firebase;

  GoogleAuthService({GoogleSignIn? google, FirebaseAuth? firebase})
      : _google = google ?? GoogleSignIn(scopes: const ['email']),
        _firebase = firebase ?? FirebaseAuth.instance;

  /// Tope de espera. Con el cliente OAuth mal configurado, el selector de
  /// cuenta puede no llegar a abrirse nunca y la llamada queda pendiente sin
  /// lanzar nada: sin este tope, la pantalla se queda esperando para siempre.
  static const _timeout = Duration(seconds: 60);

  Future<GoogleAuthResult> signIn() async {
    try {
      return await _signIn().timeout(_timeout);
    } on TimeoutException {
      return const GoogleAuthResult(
        GoogleAuthOutcome.failed,
        detail: 'tiempo de espera agotado',
      );
    }
  }

  Future<GoogleAuthResult> _signIn() async {
    try {
      // Se cierra cualquier sesión previa para que el selector de cuenta
      // aparezca siempre. Sin esto, quien se equivocó de cuenta la primera vez
      // queda atrapado en ella sin forma de cambiarla desde la app.
      await _google.signOut();

      final account = await _google.signIn();
      if (account == null) {
        return const GoogleAuthResult(GoogleAuthOutcome.cancelled);
      }

      final auth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCredential = await _firebase.signInWithCredential(credential);
      final token = await userCredential.user?.getIdToken();

      if (token == null || token.isEmpty) {
        return const GoogleAuthResult(
          GoogleAuthOutcome.failed,
          detail: 'Firebase no devolvió token',
        );
      }
      return GoogleAuthResult(GoogleAuthOutcome.success, idToken: token);
    } on FirebaseAuthException catch (e) {
      return GoogleAuthResult(GoogleAuthOutcome.failed, detail: e.code);
    } catch (e) {
      return GoogleAuthResult(GoogleAuthOutcome.failed, detail: e.toString());
    }
  }

  /// Cierra también la sesión de Google, no solo la de la app.
  ///
  /// Si se omite, la próxima vez Google reentra con la misma cuenta sin
  /// preguntar y parece que cerrar sesión no hizo nada.
  Future<void> signOut() async {
    try {
      await _google.signOut();
      await _firebase.signOut();
    } catch (_) {
      // Cerrar sesión nunca debe fallar hacia el usuario: los tokens locales
      // ya se han borrado y eso es lo que decide si está dentro o fuera.
    }
  }
}
