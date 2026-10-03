import 'package:frontend_eco_2/services/api_client.dart';

class AppConfigService {
  final ApiClient _client;
  AppConfigService(this._client);

  Future<bool> getUseCustomModel() async {
    final data = await _client.get('/app-config') as Map<String, dynamic>;
    return data['use_custom_model'] as bool? ?? true;
  }
}