import 'package:frontend_eco_2/services/api_client.dart';

class BillingService {
  final ApiClient _client;
  BillingService(this._client);

  Future<String> createPaypalOrder() async {
    final data = await _client.post('/billing/paypal/orders') as Map<String, dynamic>;
    return data['approval_url'] as String;
  }
}