import 'dart:convert';
import 'package:hive/hive.dart';

class WeatherCache {
  static const String boxName = 'weatherBox';
  final Duration ttl;

  WeatherCache({this.ttl = const Duration(minutes: 30)});

  Future<void> store(
      double lat, double lon, Map<String, dynamic> payload) async {
    final box = await Hive.openBox<String>(boxName);
    final key = _key(lat, lon);
    final envelope = jsonEncode({
      'ts': DateTime.now().toIso8601String(),
      'data': payload,
    });
    await box.put(key, envelope);
    await box.close();
  }

  Future<Map<String, dynamic>?> load(double lat, double lon) async {
    final box = await Hive.openBox<String>(boxName);
    final key = _key(lat, lon);
    final raw = box.get(key);
    await box.close();
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final ts = DateTime.parse(decoded['ts'] as String);
    if (DateTime.now().difference(ts) > ttl) return null;
    return decoded['data'] as Map<String, dynamic>;
  }

  String _key(double lat, double lon) =>
      'lat_${lat.toStringAsFixed(4)}_lon_${lon.toStringAsFixed(4)}';
}
