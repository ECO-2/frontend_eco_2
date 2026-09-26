import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_client.dart';

/// Gestiona permisos de notificaciones push y el registro del device token
/// contra la ECO2 API.
class NotificationService {
  final ApiClient _client;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  NotificationService(this._client);

  /// Pide permiso al usuario para recibir notificaciones push.
  /// Devuelve true si el usuario lo concedió.
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Obtiene el token FCM del dispositivo y lo registra en el backend
  /// (POST /user/device-token). Si el usuario no dio permiso, no hace nada.
  Future<void> registerDeviceToken() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    await _sendTokenToBackend(token);
  }

  /// Escucha cuando Firebase rota el token del dispositivo (reinstalación,
  /// cambio de dispositivo, etc.) y lo reenvía al backend automáticamente.
  void listenForTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      _sendTokenToBackend(newToken);
    });
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      await _client.post('/user/device-token', body: {'token': token});
    } catch (_) {
      // Falla silenciosa: si no se pudo registrar ahora, se reintentará
      // la próxima vez que se llame a registerDeviceToken() (ej. próximo
      // login) o cuando Firebase dispare un refresh de token.
    }
  }

  /// Configura los handlers para cuando llega una notificación con la
  /// app en primer plano (el SO no la muestra automáticamente en ese caso).
  void setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Por ahora solo lo registramos; se puede mostrar un toast/snackbar
      // aquí más adelante si se quiere.
      // ignore: avoid_print
      print('Notificación recibida en primer plano: ${message.notification?.title}');
    });
  }
}