import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenMeteoService {
  final http.Client httpClient;
  OpenMeteoService({required this.httpClient});

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'hourly': 'temperature_2m,precipitation,windspeed_10m',
      'daily': 'temperature_2m_max,temperature_2m_min',
      'current_weather': 'true',
      'timezone': 'Europe/Paris',
    });

    int attempts = 0;
    late http.Response res;
    while (true) {
      attempts += 1;
      res = await httpClient.get(uri);
      if (res.statusCode == 200) break;
      if (attempts >= 3) {
        throw Exception('OpenMeteo error: ${res.statusCode}');
      }
      await Future.delayed(
          Duration(milliseconds: 300 * attempts * attempts)); // simple backoff
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
