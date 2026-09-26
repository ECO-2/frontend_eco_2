import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

/// Marca que la sesión caducó. Es un centinela y no un mensaje: el texto
/// visible se resuelve en la pantalla, que sí sabe en qué idioma está la app.
const String kSessionExpired = '__session_expired__';

/// Excepción tipada para errores de la API.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  bool get isUnauthorized => statusCode == 401;
  bool get isConflict => statusCode == 409;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Cliente HTTP central para la ECO2 API.
/// Maneja autenticación JWT e intenta refrescar el token automáticamente
/// ante respuestas 401 antes de reintentar la petición original.
class ApiClient {
  static const String baseUrl =
      'https://eco2-api-c9e4hfh7h3cfesg3.eastus-01.azurewebsites.net';

  final SecureStorage _storage;
  final http.Client _client;

  ApiClient(this._storage) : _client = http.Client();

  // ---------------------------------------------------------------------------
  // Cabeceras
  // ---------------------------------------------------------------------------

  Map<String, String> _headers({String? accessToken}) {
    return {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  // ---------------------------------------------------------------------------
  // Refresh de token
  // ---------------------------------------------------------------------------

  /// Refresh en vuelo, compartido por todas las peticiones que reciban un 401
  /// al mismo tiempo. Sin esto, dos peticiones concurrentes (p. ej. dashboard
  /// y jardín cargando a la vez) disparaban cada una su propio refresh: el
  /// backend rota el refresh token en cada llamada, así que la segunda
  /// invalidaba el token que acababa de guardar la primera y la sesión se
  /// cerraba sola a los pocos minutos.
  Future<void>? _refreshInFlight;

  Future<void> _refreshAccessToken() {
    // Si ya hay un refresh corriendo, esperamos ese en vez de lanzar otro.
    return _refreshInFlight ??= _performRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<void> _performRefresh() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      await _storage.clearTokens();
      throw const ApiException(401, kSessionExpired);
    }

    final response = await _client.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      await _storage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
    } else {
      await _storage.clearTokens();
      throw const ApiException(401, kSessionExpired);
    }
  }

  // ---------------------------------------------------------------------------
  // Ejecución de peticiones
  // ---------------------------------------------------------------------------

  Future<http.Response> _execute(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
    bool isRetry = false,
  }) async {
    final token = requiresAuth ? await _storage.getAccessToken() : null;
    final uri = Uri.parse('$baseUrl$path');
    final headers = _headers(accessToken: token);
    final encodedBody = body != null ? jsonEncode(body) : null;

    http.Response response;
    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _client.post(uri, headers: headers, body: encodedBody);
        break;
      case 'PATCH':
        response = await _client.patch(uri, headers: headers, body: encodedBody);
        break;
      case 'DELETE':
        response = await _client.delete(uri, headers: headers);
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }

    // Auto-refresh en 401 (solo un intento)
    if (response.statusCode == 401 && requiresAuth && !isRetry) {
      await _refreshAccessToken();
      return _execute(method, path,
          body: body, requiresAuth: requiresAuth, isRetry: true);
    }

    return response;
  }

  // ---------------------------------------------------------------------------
  // Manejo de respuesta
  // ---------------------------------------------------------------------------

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty || response.statusCode == 204) return null;
      return jsonDecode(response.body);
    }

    String message;
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      message = data['message'] as String? ??
          data['error'] as String? ??
          'Error desconocido';
    } catch (_) {
      message = 'Error del servidor (${response.statusCode})';
    }
    throw ApiException(response.statusCode, message);
  }

  // ---------------------------------------------------------------------------
  // Métodos públicos
  // ---------------------------------------------------------------------------

  Future<dynamic> get(String path, {bool requiresAuth = true}) async {
    final res = await _execute('GET', path, requiresAuth: requiresAuth);
    return _handleResponse(res);
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final res =
        await _execute('POST', path, body: body, requiresAuth: requiresAuth);
    return _handleResponse(res);
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final res =
        await _execute('PATCH', path, body: body, requiresAuth: requiresAuth);
    return _handleResponse(res);
  }

  Future<dynamic> delete(String path, {bool requiresAuth = true}) async {
    final res = await _execute('DELETE', path, requiresAuth: requiresAuth);
    return _handleResponse(res);
  }

  void dispose() => _client.close();
}
