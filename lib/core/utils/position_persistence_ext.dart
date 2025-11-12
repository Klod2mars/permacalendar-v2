// lib/core/utils/position_persistence_ext.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Extension/helper for safe write of normalized positions.
/// Matches the read pattern used by PositionPersistence.readPosition:
/// - xKey: '${prefix}_${key}_x'
/// - yKey: '${prefix}_${key}_y'
/// - sizeKey: '${prefix}_${key}_size'
/// - boolKey: '${prefix}_${key}_bool' (for enabled flag)
class PositionPersistenceExt {
  /// Writes a position for prefix/key
  /// prefix: e.g. 'organic'
  /// key: e.g. 'METEO'
  /// x,y,size : normalized 0..1
  /// enabled: whether the zone is enabled (defaults to true)
  static Future<void> writePosition(
    String prefix,
    String key,
    double x,
    double y, {
    double? size,
    bool enabled = true,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final xKey = '${prefix}_${key}_x';
      final yKey = '${prefix}_${key}_y';
      final sizeKey = '${prefix}_${key}_size';
      final boolKey = '${prefix}_${key}_bool';

      await prefs.setDouble(xKey, x.clamp(0.0, 1.0));
      await prefs.setDouble(yKey, y.clamp(0.0, 1.0));
      if (size != null) {
        await prefs.setDouble(sizeKey, size.clamp(0.01, 1.0));
      }
      await prefs.setBool(boolKey, enabled);

      if (kDebugMode) {
        debugPrint(
            '✅ PositionPersistenceExt.writePosition($prefix, $key) - Position sauvegardée');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PositionPersistenceExt.writePosition - Erreur: $e');
      }
      rethrow;
    }
  }

  /// Convenience readPosition for compatibility with PositionPersistence.readPosition
  /// Returns the same format: {'x': x, 'y': y, 'size': size, 'enabled': enabled}
  static Future<Map<String, dynamic>?> readPosition(
      String prefix, String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final xKey = '${prefix}_${key}_x';
      final yKey = '${prefix}_${key}_y';
      final sizeKey = '${prefix}_${key}_size';
      final boolKey = '${prefix}_${key}_bool';

      final x = prefs.getDouble(xKey);
      final y = prefs.getDouble(yKey);
      if (x == null || y == null) return null;

      final size = prefs.getDouble(sizeKey) ?? 0.22;
      final enabled = prefs.getBool(boolKey) ?? true;

      return {'x': x, 'y': y, 'size': size, 'enabled': enabled};
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PositionPersistenceExt.readPosition - Erreur: $e');
      }
      return null;
    }
  }
}

