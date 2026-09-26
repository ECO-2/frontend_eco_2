import '../models/models.dart';
import 'api_client.dart';

/// Gestiona el catálogo de especies y la colección de plantas del usuario.
class PlantsService {
  final ApiClient _client;

  PlantsService(this._client);

  /// GET /plants/species — catálogo completo (endpoint público).
  Future<List<PlantSpecies>> getSpecies() async {
    final data =
        await _client.get('/plants/species', requiresAuth: false) as List<dynamic>;
    return data
        .map((e) => PlantSpecies.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /plants/species/{id}
  Future<PlantSpecies> getSpeciesById(String id) async {
    final data =
        await _client.get('/plants/species/$id', requiresAuth: false) as Map<String, dynamic>;
    return PlantSpecies.fromJson(data);
  }

  /// GET /plants — lista de plantas del usuario con info de especie embebida.
  Future<List<UserPlant>> getUserPlants() async {
    final data = await _client.get('/plants') as List<dynamic>;
    return data
        .map((e) => UserPlant.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /plants — agrega una planta a la colección del usuario.
  Future<UserPlant> addPlant({
    required String speciesId,
    String? nickname,
    String? healthStatus,
    DateTime? lastWateredAt,
    bool? remindersMuted,
  }) async {
    final body = <String, dynamic>{'species_id': speciesId};
    if (nickname != null && nickname.isNotEmpty) body['nickname'] = nickname;
    if (healthStatus != null) body['health_status'] = healthStatus;
    // Último riego anterior a registrarla en la app: el backend lo usa para
    // programar el primer recordatorio desde esa fecha y no desde hoy.
    if (lastWateredAt != null) {
      body['last_watered_at'] = lastWateredAt.toIso8601String();
    }

    final data = await _client.post('/plants', body: body) as Map<String, dynamic>;
    return UserPlant.fromJson(data);
  }

  /// PATCH /plants/{id} — actualiza nickname, estado o última vez regada.
  Future<UserPlant> updatePlant(
    String id, {
    String? nickname,
    String? healthStatus,
    DateTime? lastWateredAt,
    bool? remindersMuted,
  }) async {
    final body = <String, dynamic>{};
    if (nickname != null) body['nickname'] = nickname;
    if (healthStatus != null) body['health_status'] = healthStatus;
    if (lastWateredAt != null) {
      body['last_watered_at'] = lastWateredAt.toUtc().toIso8601String();
    }
    if (remindersMuted != null) body['reminders_muted'] = remindersMuted;

    final data =
        await _client.patch('/plants/$id', body: body) as Map<String, dynamic>;
    return UserPlant.fromJson(data);
  }

  /// DELETE /plants/{id} — soft delete de una planta.
  Future<void> deletePlant(String id) async {
    await _client.delete('/plants/$id');
  }
}
