import 'package:frontend_eco_2/services/api_client.dart';

class AppConfigService {
  final ApiClient _client;
  AppConfigService(this._client);

  Future<Map<String, dynamic>> getConfig() async {
    return await _client.get('/app-config') as Map<String, dynamic>;
  }
}