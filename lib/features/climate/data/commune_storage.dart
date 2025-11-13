ï»¿import 'package:hive/hive.dart';

// âœ… Patch v1.2 — séparation du box météo
// Utilise un box distinct pour éviter tout conflit avec AppSettings.
class CommuneStorage {
  static const String _boxName = 'weather_settings';
  static const String _keyCommune = 'selected_commune';
  static const String _keyLat = 'selected_lat';
  static const String _keyLon = 'selected_lon';

  static Future<void> saveCommune(
      String commune, double lat, double lon) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_keyCommune, commune);
    await box.put(_keyLat, lat);
    await box.put(_keyLon, lon);
    await box.close();
  }

  static Future<(String?, double?, double?)> loadCommune() async {
    final box = await Hive.openBox(_boxName);
    final commune = box.get(_keyCommune) as String?;
    final lat = box.get(_keyLat) as double?;
    final lon = box.get(_keyLon) as double?;
    await box.close();
    return (commune, lat, lon);
  }

  static Future<void> clear() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
    await box.close();
  }
}


