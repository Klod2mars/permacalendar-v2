import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utilitaire pour gérer la persistance des positions normalisées
class PositionPersistence {
  /// Charge les positions sauvegardées depuis SharedPreferences
  ///
  /// [prefix] : préfixe pour les clés (ex: 'tap', 'gardens')
  /// [defaults] : positions par défaut si aucune sauvegarde trouvée
  ///
  /// Retourne une Map<String, Offset> avec les positions chargées
  static Future<Map<String, Offset>> load(
      String prefix, Map<String, Offset> defaults) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loadedPositions = <String, Offset>{};

      // Charger chaque position depuis SharedPreferences
      for (final entry in defaults.entries) {
        final key = entry.key;
        final defaultPosition = entry.value;

        final xKey = '${prefix}_${key}_x';
        final yKey = '${prefix}_${key}_y';

        final x = prefs.getDouble(xKey);
        final y = prefs.getDouble(yKey);

        if (x != null && y != null) {
          loadedPositions[key] = Offset(x, y);
        } else {
          // Utiliser la position par défaut si pas de sauvegarde
          loadedPositions[key] = defaultPosition;
        }
      }

      if (kDebugMode) {
        debugPrint(
            'âœ… PositionPersistence.load($prefix) - ${loadedPositions.length} positions chargées');
      }

      return loadedPositions;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('âŒ PositionPersistence.load($prefix) - Erreur: $e');
      }
      // En cas d'erreur, retourner les positions par défaut
      return defaults;
    }
  }

  /// Sauvegarde les positions dans SharedPreferences
  ///
  /// [prefix] : préfixe pour les clés (ex: 'tap', 'gardens')
  /// [positions] : Map des positions à sauvegarder
  static Future<void> save(String prefix, Map<String, Offset> positions) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Sauvegarder chaque position avec 2 décimales de précision
      for (final entry in positions.entries) {
        final key = entry.key;
        final position = entry.value;

        final xKey = '${prefix}_${key}_x';
        final yKey = '${prefix}_${key}_y';

        // Arrondir à 2 décimales pour éviter les erreurs de précision
        final x = double.parse(position.dx.toStringAsFixed(2));
        final y = double.parse(position.dy.toStringAsFixed(2));

        await prefs.setDouble(xKey, x);
        await prefs.setDouble(yKey, y);
      }

      if (kDebugMode) {
        debugPrint(
            'âœ… PositionPersistence.save($prefix) - ${positions.length} positions sauvegardées');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('âŒ PositionPersistence.save($prefix) - Erreur: $e');
      }
      rethrow; // Propager l'erreur pour gestion par l'appelant
    }
  }

  /// Efface toutes les positions sauvegardées pour un préfixe donné
  ///
  /// [prefix] : préfixe des clés à effacer
  static Future<void> clear(String prefix) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Trouver toutes les clés qui commencent par le préfixe
      final keysToRemove =
          keys.where((key) => key.startsWith('${prefix}_')).toList();

      // Supprimer chaque clé
      for (final key in keysToRemove) {
        await prefs.remove(key);
      }

      if (kDebugMode) {
        debugPrint(
            'âœ… PositionPersistence.clear($prefix) - ${keysToRemove.length} clés supprimées');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('âŒ PositionPersistence.clear($prefix) - Erreur: $e');
      }
      rethrow;
    }
  }

  /// Charge des tailles (double) sauvegardées depuis SharedPreferences
  ///
  /// [prefix] : préfixe pour les clés (ex: 'tap', 'gardens')
  /// [defaults] : tailles par défaut si aucune sauvegarde trouvée
  ///
  /// Retourne une Map<String, double> avec les tailles chargées
  static Future<Map<String, double>> loadSizes(
      String prefix, Map<String, double> defaults) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loadedSizes = <String, double>{};

      for (final entry in defaults.entries) {
        final key = entry.key;
        final defaultSize = entry.value;

        final sizeKey = '${prefix}_${key}_size';
        final sizeValue = prefs.getDouble(sizeKey);

        if (sizeValue != null) {
          loadedSizes[key] = sizeValue;
        } else {
          loadedSizes[key] = defaultSize;
        }
      }

      if (kDebugMode) {
        debugPrint(
            'âœ… PositionPersistence.loadSizes($prefix) - ${loadedSizes.length} tailles chargées');
      }

      return loadedSizes;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('âŒ PositionPersistence.loadSizes($prefix) - Erreur: $e');
      }
      return defaults;
    }
  }

  /// Sauvegarde des tailles (double) dans SharedPreferences
  ///
  /// [prefix] : préfixe pour les clés (ex: 'tap', 'gardens')
  /// [sizes] : Map des tailles à sauvegarder
  static Future<void> saveSizes(
      String prefix, Map<String, double> sizes) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      for (final entry in sizes.entries) {
        final key = entry.key;
        final size = double.parse(entry.value.toStringAsFixed(2));

        final sizeKey = '${prefix}_${key}_size';
        await prefs.setDouble(sizeKey, size);
      }

      if (kDebugMode) {
        debugPrint(
            'âœ… PositionPersistence.saveSizes($prefix) - ${sizes.length} tailles sauvegardées');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('âŒ PositionPersistence.saveSizes($prefix) - Erreur: $e');
      }
      rethrow;
    }
  }

  /// Charge des états booléens sauvegardés depuis SharedPreferences
  ///
  /// [prefix] : préfixe pour les clés (ex: 'tap', 'gardens')
  /// [defaults] : états par défaut si aucune sauvegarde trouvée
  ///
  /// Retourne une Map<String, bool> avec les états chargés
  static Future<Map<String, bool>> loadBooleans(
      String prefix, Map<String, bool> defaults) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loadedFlags = <String, bool>{};

      for (final entry in defaults.entries) {
        final key = entry.key;
        final defaultValue = entry.value;

        final flagKey = '${prefix}_${key}_bool';
        final value = prefs.getBool(flagKey);

        if (value != null) {
          loadedFlags[key] = value;
        } else {
          loadedFlags[key] = defaultValue;
        }
      }

      if (kDebugMode) {
        debugPrint(
            'âœ… PositionPersistence.loadBooleans($prefix) - ${loadedFlags.length} états chargés');
      }

      return loadedFlags;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            'âŒ PositionPersistence.loadBooleans($prefix) - Erreur: $e');
      }
      return defaults;
    }
  }

  /// Sauvegarde des états booléens dans SharedPreferences
  ///
  /// [prefix] : préfixe pour les clés (ex: 'tap', 'gardens')
  /// [flags] : Map des états à sauvegarder
  static Future<void> saveBooleans(
      String prefix, Map<String, bool> flags) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      for (final entry in flags.entries) {
        final key = entry.key;
        final flagKey = '${prefix}_${key}_bool';
        await prefs.setBool(flagKey, entry.value);
      }

      if (kDebugMode) {
        debugPrint(
            'âœ… PositionPersistence.saveBooleans($prefix) - ${flags.length} états sauvegardés');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            'âŒ PositionPersistence.saveBooleans($prefix) - Erreur: $e');
      }
      rethrow;
    }
  }

  /// Lit une position complète (position + size + enabled) pour une zone donnée
  ///
  /// [prefix] : préfixe pour les clés (ex: 'organic', 'tap')
  /// [key] : identifiant de la zone (ex: 'METEO', 'PH')
  ///
  /// Retourne une Map avec 'x', 'y', 'size', 'enabled' ou null si non trouvé
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
      final size = prefs.getDouble(sizeKey);
      final enabled = prefs.getBool(boolKey);

      if (x == null || y == null) {
        return null;
      }

      return {
        'x': x,
        'y': y,
        'size': size ?? 0.25,
        'enabled': enabled ?? true,
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('âŒ PositionPersistence.readPosition - Erreur: $e');
      }
      return null;
    }
  }
}
