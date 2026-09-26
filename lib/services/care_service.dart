import '../models/models.dart';
import 'api_client.dart';

/// Gestiona tareas de cuidado y el historial de cuidados de las plantas.
class CareService {
  final ApiClient _client;

  CareService(this._client);

  /// GET /care/plants/{plantId}/tasks
  Future<List<UserPlantTask>> getPlantTasks(String plantId) async {
    final data =
        await _client.get('/care/plants/$plantId/tasks') as List<dynamic>;
    return data
        .map((e) => UserPlantTask.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /care/tasks — crea una tarea de cuidado para una planta.
  Future<void> createTask({
    required String userPlantId,
    required String taskType,
    required int frequencyDays,
    required DateTime nextDueAt,
  }) async {
    await _client.post('/care/tasks', body: {
      'user_plant_id': userPlantId,
      'task_type': taskType,
      'frequency_days': frequencyDays,
      'next_due_at': nextDueAt.toUtc().toIso8601String(),
    });
  }

  /// PATCH /care/tasks/{taskId}/complete — marca una tarea como completada
  /// y genera automáticamente un CareLog en el backend.
  Future<void> completeTask(String taskId) async {
    await _client.patch('/care/tasks/$taskId/complete');
  }

  /// POST /care/logs — registra un cuidado manual.
  Future<void> createCareLog({
    required String userPlantId,
    required String taskType,
    DateTime? performedAt,
  }) async {
    final body = <String, dynamic>{
      'user_plant_id': userPlantId,
      'task_type': taskType,
    };
    if (performedAt != null) {
      body['performed_at'] = performedAt.toUtc().toIso8601String();
    }
    await _client.post('/care/logs', body: body);
  }

  /// GET /care/plants/{plantId}/logs — historial de cuidados de una planta.
  Future<List<CareLog>> getCareLogs(String plantId) async {
    final data =
        await _client.get('/care/plants/$plantId/logs') as List<dynamic>;
    return data
        .map((e) => CareLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
