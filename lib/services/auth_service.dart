import 'api_client.dart';
import 'secure_storage.dart';

/// Maneja registro, login y logout contra la ECO2 API.
class AuthService {
  final ApiClient _client;
  final SecureStorage _storage;

  AuthService(this._client, this._storage);

  /// POST /auth/login — guarda los tokens en SecureStorage.
  Future<void> login(String email, String password) async {
    final data = await _client.post(
      '/auth/login',
      body: {'email': email, 'password': password},
      requiresAuth: false,
    ) as Map<String, dynamic>;

    await _storage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  /// POST /auth/firebase — canjea un token de Firebase por los tokens de ECO2.
  ///
  /// El backend verifica el token contra Firebase y, si el correo no existe
  /// todavia, crea la cuenta. Por eso este mismo metodo sirve para registrarse
  /// y para entrar: desde fuera no hay diferencia.
  Future<void> loginWithFirebase(String idToken) async {
    final data = await _client.post(
      '/auth/firebase',
      body: {'idToken': idToken},
      requiresAuth: false,
    ) as Map<String, dynamic>;

    await _storage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  /// POST /auth/register — crea el usuario en la API.
  Future<void> register(String email, String password) async {
    await _client.post(
      '/auth/register',
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );
  }

  /// POST /auth/logout — revoca la sesión y limpia los tokens locales.
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        await _client.post(
          '/auth/logout',
          body: {'refreshToken': refreshToken},
        );
      }
    } catch (_) {
      // Ignorar errores en logout — limpiar tokens de todas formas.
    } finally {
      await _storage.clearTokens();
    }
  }

  /// POST /auth/forgot-password — solicita el correo de recuperación.
  ///
  /// El backend responde siempre 200 con un mensaje genérico ("si existe una
  /// cuenta con ese correo, se ha enviado un enlace"), sin confirmar ni negar
  /// que el correo exista. La app debe mantener esa ambigüedad: decir "ese
  /// correo no está registrado" permitiría enumerar usuarios.
  Future<void> forgotPassword(String email) async {
    await _client.post(
      '/auth/forgot-password',
      body: {'email': email},
      requiresAuth: false,
    );
  }

  /// Cambia la contraseña con el código que llegó por correo. El backend
  /// normaliza el código, así que da igual si viene con guion o en minúsculas.
  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    await _client.post(
      '/auth/reset-password',
      body: {'token': code, 'new_password': newPassword},
      requiresAuth: false,
    );
  }
}
