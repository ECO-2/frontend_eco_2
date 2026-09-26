import '../models/models.dart';
import 'api_client.dart';

/// Gestiona el perfil del usuario autenticado.
class UserService {
  final ApiClient _client;

  UserService(this._client);

  /// GET /user/me — retorna el usuario autenticado.
  Future<User> getMe() async {
    final data = await _client.get('/user/me') as Map<String, dynamic>;
    return User.fromJson(data);
  }

  /// GET /user/green-footprint — CO₂ real del jardín del usuario, calculado
  /// por el backend con los valores por especie del catálogo.
  Future<GreenFootprint> getGreenFootprint() async {
    final data = await _client.get('/user/green-footprint') as Map<String, dynamic>;
    return GreenFootprint.fromJson(data);
  }

  /// PATCH /user/profile — actualiza nombre, notificaciones y horarios de recordatorio.
  Future<User> updateProfile({
    String? username,
    String? avatarId,
    bool? notificationsEnabled,
    int? reminderStartHour,
    int? reminderEndHour,
  }) async {
    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    // Se manda el id del avatar, no una URL: ver avatar_catalog.dart.
    if (avatarId != null) body['avatar_url'] = avatarId;
    if (notificationsEnabled != null) {
      body['notifications_enabled'] = notificationsEnabled;
    }
    if (reminderStartHour != null) body['reminder_start_hour'] = reminderStartHour;
    if (reminderEndHour != null) body['reminder_end_hour'] = reminderEndHour;

    final data = await _client.patch('/user/profile', body: body) as Map<String, dynamic>;
    return User.fromJson(data);
  }

  /// GET /user/plan — plan actual y consumo (plantas y escaneos de hoy).
  Future<PlanStatus> getPlan() async {
    final data = await _client.get('/user/plan') as Map<String, dynamic>;
    return PlanStatus.fromJson(data);
  }

  /// POST /user/plan/activate — activa O2+.
  ///
  /// El cobro es SIMULADO: la pasarela de la app es una maqueta para la
  /// presentación, y el backend lo devuelve marcado como tal.
  Future<PlanStatus> activatePlus({int months = 12}) async {
    final data = await _client.post('/user/plan/activate',
        body: {'months': months}) as Map<String, dynamic>;
    return PlanStatus.fromJson(data);
  }

  /// POST /user/plan/cancel — vuelve al plan gratuito.
  Future<PlanStatus> cancelPlus() async {
    final data = await _client.post('/user/plan/cancel') as Map<String, dynamic>;
    return PlanStatus.fromJson(data);
  }

  /// GET /user/avatars — ids de los avatares que el usuario puede usar
  /// (gratuitos + comprados).
  Future<List<String>> getOwnedAvatars() async {
    final data = await _client.get('/user/avatars') as Map<String, dynamic>;
    return (data['owned'] as List<dynamic>? ?? const [])
        .map((e) => e as String)
        .toList();
  }

  /// POST /user/avatars/purchase — compra un avatar con semillas.
  /// Devuelve el saldo de semillas restante.
  Future<int> purchaseAvatar(String avatarId) async {
    final data = await _client.post('/user/avatars/purchase',
        body: {'avatar_id': avatarId}) as Map<String, dynamic>;
    return data['seeds'] as int? ?? 0;
  }

  /// POST /user/store/redeem — canjea un artículo con semillas.
  ///
  /// El backend descuenta Y entrega en la misma transacción. Devuelve el saldo
  /// de semillas restante.
  Future<int> redeemStoreItem(String itemId) async {
    final data = await _client.post('/user/store/redeem',
        body: {'item_id': itemId}) as Map<String, dynamic>;
    return data['seeds'] as int? ?? 0;
  }

  /// PATCH /user/password — cambia la contraseña verificando la actual.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.patch('/user/password', body: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  /// DELETE /user/me — borra la cuenta y todos sus datos asociados.
  Future<void> deleteAccount() async {
    await _client.delete('/user/me');
  }

  /// PATCH /user/onboarding — completa el perfil inicial del usuario tras el registro.
  /// Todos los campos son opcionales y pueden enviarse de forma progresiva.
  Future<User> completeOnboarding({
    String? username,
    String? gender,
    DateTime? birthDay,
  }) async {
    final body = <String, dynamic>{};
    if (username != null && username.isNotEmpty) body['username'] = username;
    if (gender != null) body['gender'] = gender;
    if (birthDay != null) {
      // La API espera formato date (YYYY-MM-DD)
      body['birth_day'] =
          '${birthDay.year.toString().padLeft(4, '0')}-${birthDay.month.toString().padLeft(2, '0')}-${birthDay.day.toString().padLeft(2, '0')}';
    }
    final data =
        await _client.patch('/user/onboarding', body: body) as Map<String, dynamic>;
    return User.fromJson(data);
  }
}
