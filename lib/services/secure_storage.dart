import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Gestiona el almacenamiento seguro de tokens JWT (accessToken y refreshToken).
class SecureStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _appTourSeenKey = 'app_tour_seen';
  static const _plantCareTourSeenKey = 'plant_care_tour_seen';
  static const _languageCodeKey = 'language_code';
  static const _biometricLockKey = 'biometric_lock_enabled';
  static const _rentalNoticeKey = 'rental_expiry_notice_shown';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

  Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Recorrido guiado de la app — se muestra automáticamente una sola vez.
  Future<bool> hasSeenAppTour() async {
    return (await _storage.read(key: _appTourSeenKey)) == 'true';
  }

  Future<void> markAppTourSeen() => _storage.write(key: _appTourSeenKey, value: 'true');

  /// Recorrido de "cómo cuidar esta planta" (PlantDetailScreen) — también
  /// se muestra automáticamente una sola vez, independiente del anterior.
  Future<bool> hasSeenPlantCareTour() async {
    return (await _storage.read(key: _plantCareTourSeenKey)) == 'true';
  }

  Future<void> markPlantCareTourSeen() =>
      _storage.write(key: _plantCareTourSeenKey, value: 'true');

  // ── Idioma elegido por el usuario ─────────────────────────────────────
  // Null significa "seguir el idioma del sistema".
  Future<String?> getLanguageCode() => _storage.read(key: _languageCodeKey);

  Future<void> saveLanguageCode(String code) =>
      _storage.write(key: _languageCodeKey, value: code);

  Future<void> clearLanguageCode() => _storage.delete(key: _languageCodeKey);

  // ── Bloqueo biométrico ────────────────────────────────────────────────
  // Solo guarda la preferencia; la huella nunca sale del sistema operativo,
  // que es quien la verifica y devuelve un sí o un no.
  Future<bool> isBiometricLockEnabled() async {
    return (await _storage.read(key: _biometricLockKey)) == 'true';
  }

  Future<void> setBiometricLockEnabled(bool enabled) => enabled
      ? _storage.write(key: _biometricLockKey, value: 'true')
      : _storage.delete(key: _biometricLockKey);

  // ── Aviso de alquiler vencido ─────────────────────────────────────────
  // Se guarda la fecha del alquiler ya avisado, no un simple "true": asi el
  // aviso sale una vez por alquiler y vuelve a salir si el usuario alquila
  // otra maceta mas adelante.
  Future<String?> getRentalNoticeShownFor() =>
      _storage.read(key: _rentalNoticeKey);

  Future<void> markRentalNoticeShown(String expiresAtIso) =>
      _storage.write(key: _rentalNoticeKey, value: expiresAtIso);
}
