// lib/core/utils/calibration_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CalibrationStorage {
  /// Save a profile JSON string under the given key.
  static Future<void> saveProfile(
      String key, Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(profile));
  }

  /// Load profile JSON map from key, or null if missing.
  static Future<Map<String, dynamic>?> loadProfile(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(key);
    if (s == null) return null;
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Delete a saved profile.
  static Future<void> deleteProfile(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Export profile as pretty JSON string
  static String exportProfile(Map<String, dynamic> profile) {
    return const JsonEncoder.withIndent('  ').convert(profile);
  }

  /// Import profile from JSON (string). Returns parsed map or throws FormatException.
  static Map<String, dynamic> importProfile(String jsonString) {
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}


