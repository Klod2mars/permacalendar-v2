import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:permacalendar/weather/open_meteo_service.dart'; // adjust import to your package name

void main() {
  test('OpenMeteoService parses ok response', () async {
    final mock = MockClient((req) async {
      return http.Response(
          jsonEncode({
            'current_weather': {'temperature': 20.1, 'windspeed': 5.0},
            'hourly': {},
            'daily': {}
          }),
          200);
    });
    final svc = OpenMeteoService(httpClient: mock);
    final res = await svc.fetchWeather(48.8566, 2.3522);
    expect(res['current_weather'], isNotNull);
  });
}
