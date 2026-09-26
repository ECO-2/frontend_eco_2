import '../models/models.dart';
import 'api_client.dart';

/// Identificación de plantas por foto.
class IdentificationService {
  final ApiClient _client;

  IdentificationService(this._client);

  /// POST /identifications/fallback — manda la foto (base64) a la API real
  /// de identificación (Plant.id). Si el backend todavía no tiene la API
  /// key configurada, responde igual (200) con `configured: false`, no un
  /// error — el llamador debe mostrar eso como "función no disponible
  /// todavía", no como una falla de red.
  Future<IdentificationResult> identifyFromPhoto(String imageBase64) async {
    final data = await _client.post(
      '/identifications/fallback',
      body: {'image_base64': imageBase64},
    ) as Map<String, dynamic>;
    return IdentificationResult.fromJson(data);
  }

  /// GET /identifications — historial real de identificaciones del usuario.
  Future<List<PlantIdentification>> getHistory() async {
    final data = await _client.get('/identifications') as List<dynamic>;
    return data
        .map((e) => PlantIdentification.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
