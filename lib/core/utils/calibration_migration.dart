import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Module de migration garantissant la cohérence des profils de calibration.
///
/// - Source : anciennes structures `CalibrationState`, `GardenCalibration` et clefs
///   persistées (SharedPreferences / Hive legacy).
/// - Cible : profils `CalibrationV2Profile` stockés dans Hive (`calibration_v2`)
///   et compatibles avec les modèles organiques (`OrganicZoneConfig`).
/// - Pratiques : toujours exécuter avec sauvegarde préalable, couvrir les tests
///   unitaires décrits (`dryRun`, validation des unités/ bornes, capteurs
///   partiels, erreurs d'ouverture Hive).
/// - Références croisées : `calibration_state.dart`,
///   `position_persistence_ext.dart`, `gardenCalibrationEnabledProvider`.
final calibrationMigrationProvider = Provider<CalibrationMigration>((ref) {
  return CalibrationMigration();
});

typedef CalibrationMapBox = Box;
typedef HiveBoxOpener = Future<CalibrationMapBox> Function(String boxName);

const String _legacyBoxName = 'garden_calibration';
const String _legacyPrefsPrefix = 'legacy_calibration_profile_';
const String _legacyActivePrefsKey = 'legacy_calibration_active_device';
const String _v2BoxName = 'calibration_v2';

const Map<String, String> _unitAliases = <String, String>{
  'c': '°C',
  'celsius': '°C',
  'celcius': '°C',
  '°c': '°C',
  'temperature': '°C',
  '°celsius': '°C',
  'lux': 'lux',
  'lx': 'lux',
  'lumens': 'lux',
  'lumen': 'lux',
  '%': '%',
  'percent': '%',
  'percentage': '%',
  'humidity': '%',
};

class CalibrationMigration {
  CalibrationMigration({
    HiveInterface? hive,
    Future<SharedPreferences> Function()? sharedPreferencesProvider,
    this.legacyBoxName = _legacyBoxName,
    this.v2BoxName = _v2BoxName,
    HiveBoxOpener? legacyBoxOpenerOverride,
    HiveBoxOpener? v2BoxOpenerOverride,
  })  : _hive = hive ?? Hive,
        _sharedPreferencesProvider =
            sharedPreferencesProvider ?? SharedPreferences.getInstance,
        _legacyBoxOpenerOverride = legacyBoxOpenerOverride,
        _v2BoxOpenerOverride = v2BoxOpenerOverride;

  final HiveInterface _hive;
  final Future<SharedPreferences> Function() _sharedPreferencesProvider;
  final HiveBoxOpener? _legacyBoxOpenerOverride;
  final HiveBoxOpener? _v2BoxOpenerOverride;

  final String legacyBoxName;
  final String v2BoxName;

  /// Point d'entrée unique pour la migration des données de calibration.
  Future<CalibrationMigrationReport> migrateCalibrationData({
    bool dryRun = false,
  }) async {
    final report = CalibrationMigrationReport(
      startedAt: DateTime.now().toUtc(),
      dryRun: dryRun,
    );

    try {
      final legacyProfiles = await _loadLegacyProfiles(report);
      if (legacyProfiles.isEmpty) {
        if (report.errors.isEmpty) {
          report.info.add('Aucune donnée legacy à migrer.');
          report.success = true;
        } else {
          report.success = false;
        }
        return report.finish();
      }

      final converted =
          convertLegacyCalibration(legacyProfiles, report: report);
      if (converted.isEmpty) {
        report.warnings.add(
          'Les profils legacy ont été ignorés (valeurs invalides ou unitaires inconnues).',
        );
        report.success = true;
        return report.finish();
      }

      final existing = await _loadExistingProfiles(report);
      final mergeResult = mergeCalibrationProfiles(
        existing: existing,
        incoming: converted,
        report: report,
      );

      report.migratedProfiles = mergeResult.migratedCount;
      report.skippedProfiles = mergeResult.skippedCount;

      if (dryRun) {
        report.preview = mergeResult.merged;
        report.info.add('Dry-run activé : aucune écriture Hive réalisée.');
      } else {
        await _persistProfiles(mergeResult.merged, report);
      }

      report.success = report.errors.isEmpty;
      return report.finish();
    } catch (e, stackTrace) {
      report.errors.add('Migration interrompue: $e');
      if (kDebugMode) {
        debugPrint(
          'CalibrationMigration.migrateCalibrationData - erreur fatale: $e\n$stackTrace',
        );
      }
      report.success = false;
      report.error = e;
      return report.finish();
    }
  }

  /// Convertit des profils legacy vers la structure V2.
  @visibleForTesting
  List<CalibrationV2Profile> convertLegacyCalibration(
    List<LegacyCalibrationProfile> legacyProfiles, {
    CalibrationMigrationReport? report,
  }) {
    final converted = <CalibrationV2Profile>[];
    for (final legacy in legacyProfiles) {
      final metrics = <String, CalibrationMetricV2>{};
      for (final entry in legacy.metrics.entries) {
        final metric = entry.value;
        final normalizedUnit = normalizeUnit(metric.unit);
        if (normalizedUnit == null) {
          report?.warnings.add(
            'Profil ${legacy.profileId} (${legacy.deviceId}) - capteur ${metric.sensorId} ignoré (unité inconnue: ${metric.unit}).',
          );
          continue;
        }

        final value = _toDouble(metric.value);
        if (value == null) {
          report?.warnings.add(
            'Profil ${legacy.profileId} (${legacy.deviceId}) - capteur ${metric.sensorId} sans valeur numérique. Ignoré.',
          );
          continue;
        }

        final timestamp = metric.updatedAt ?? legacy.updatedAt;
        metrics[entry.key] = CalibrationMetricV2(
          sensorId: metric.sensorId,
          value: value,
          unit: normalizedUnit,
          updatedAt: timestamp ?? DateTime.now().toUtc(),
        );
      }

      if (metrics.isEmpty) {
        report?.warnings.add(
          'Profil ${legacy.profileId} (${legacy.deviceId}) ignoré (aucun capteur valide).',
        );
        continue;
      }

      converted.add(
        CalibrationV2Profile(
          profileId: legacy.profileId,
          deviceId: legacy.deviceId,
          metrics: metrics,
          updatedAt: legacy.updatedAt ?? DateTime.now().toUtc(),
          isActive: legacy.isActive,
          origin: legacy.origin,
        ),
      );
    }

    return converted;
  }

  /// Fusionne les profils existants avec les nouveaux en conservant le sanctuaire.
  @visibleForTesting
  CalibrationMergeResult mergeCalibrationProfiles({
    required List<CalibrationV2Profile> existing,
    required List<CalibrationV2Profile> incoming,
    CalibrationMigrationReport? report,
  }) {
    final merged = <String, CalibrationV2Profile>{
      for (final profile in existing) profile.profileId: profile,
    };

    final migrated = <CalibrationV2Profile>[];
    var skipped = 0;

    for (final candidate in incoming) {
      final existingProfile = merged[candidate.profileId];
      if (existingProfile == null) {
        merged[candidate.profileId] = candidate;
        migrated.add(candidate);
        continue;
      }

      if (existingProfile.updatedAt.isAfter(candidate.updatedAt)) {
        skipped++;
        report?.info.add(
          'Profil ${candidate.profileId} conservé version existante (plus récente).',
        );
        continue;
      }

      final mergedMetrics = Map<String, CalibrationMetricV2>.from(
        existingProfile.metrics,
      );
      for (final entry in candidate.metrics.entries) {
        final existingMetric = mergedMetrics[entry.key];
        if (existingMetric == null ||
            existingMetric.updatedAt.isBefore(entry.value.updatedAt)) {
          mergedMetrics[entry.key] = entry.value;
        }
      }

      final resolvedActive = _resolveActiveFlag(
        existingProfile.isActive,
        candidate.isActive,
        existingProfile.updatedAt,
        candidate.updatedAt,
      );

      final newProfile = existingProfile.copyWith(
        metrics: mergedMetrics,
        updatedAt: candidate.updatedAt,
        isActive: resolvedActive,
        origin: '${existingProfile.origin ?? 'existing'}+${candidate.origin}',
      );

      merged[candidate.profileId] = newProfile;
      migrated.add(newProfile);
    }

    _enforceSingleActivePerDevice(
      merged.values.toList(),
      report: report,
    );

    return CalibrationMergeResult(
      merged: merged.values.toList(),
      migratedCount: migrated.length,
      skippedCount: skipped,
    );
  }

  /// Normalise les unités legacy vers une forme canonique.
  @visibleForTesting
  String? normalizeUnit(String? unit) {
    if (unit == null) return null;
    final normalized = _unitAliases[unit.trim().toLowerCase()];
    return normalized;
  }

  Future<List<LegacyCalibrationProfile>> _loadLegacyProfiles(
    CalibrationMigrationReport report,
  ) async {
    final profiles = <LegacyCalibrationProfile>[];

    final handle = await _openLegacyBox();
    if (handle.error != null) {
      report.errors.add(
        'Ouverture box legacy échouée: ${handle.error}',
      );
      return profiles;
    }
    try {
      final box = handle.box;
      if (box != null) {
        for (final entry in box.toMap().entries) {
          final map = entry.value;
          if (map is! Map) {
            report.warnings.add(
              'Entrée legacy ${entry.key} ignorée (format inattendu).',
            );
            continue;
          }
          final profile = LegacyCalibrationProfile.fromMap(
            entry.key.toString(),
            Map<String, dynamic>.from(map as Map),
          );
          if (profile != null) {
            profiles.add(profile);
          } else {
            report.warnings.add(
              'Profil legacy ${entry.key} ignoré (données incomplètes).',
            );
          }
        }
      }
    } catch (e, stackTrace) {
      report.errors.add('Lecture Hive legacy échouée: $e');
      if (kDebugMode) {
        debugPrint(
          'CalibrationMigration._loadLegacyProfiles - erreur Hive: $e\n$stackTrace',
        );
      }
    } finally {
      await handle.closeIfNeeded();
    }

    try {
      final prefs = await _sharedPreferencesProvider();
      final activeDevice = prefs.getString(_legacyActivePrefsKey);
      for (final key in prefs.getKeys()) {
        if (!key.startsWith(_legacyPrefsPrefix)) continue;
        final raw = prefs.getString(key);
        if (raw == null) continue;
        try {
          final decoded = jsonDecode(raw);
          if (decoded is! Map<String, dynamic>) {
            report.warnings.add(
              'Clef $key ignorée (JSON inattendu).',
            );
            continue;
          }
          final profileKey = key.substring(_legacyPrefsPrefix.length);
          final profile = LegacyCalibrationProfile.fromMap(
            profileKey,
            decoded,
            overrideActiveDevice: activeDevice,
          );
          if (profile != null) {
            profiles.add(profile);
          } else {
            report.warnings.add(
              'Profil SharedPreferences $key ignoré (données incomplètes).',
            );
          }
        } catch (e) {
          report.warnings.add('Clef $key ignorée: $e');
        }
      }
    } catch (e, stackTrace) {
      report.errors.add('Lecture SharedPreferences échouée: $e');
      if (kDebugMode) {
        debugPrint(
          'CalibrationMigration._loadLegacyProfiles - erreur prefs: $e\n$stackTrace',
        );
      }
    }

    return profiles;
  }

  Future<List<CalibrationV2Profile>> _loadExistingProfiles(
    CalibrationMigrationReport report,
  ) async {
    final profiles = <CalibrationV2Profile>[];
    final handle = await _openV2Box();
    if (handle.error != null) {
      report.errors.add(
        'Ouverture box V2 échouée: ${handle.error}',
      );
      return profiles;
    }
    try {
      final box = handle.box;
      if (box == null) return profiles;
      for (final entry in box.toMap().entries) {
        final map = entry.value;
        if (map case final Map<String, dynamic> json) {
          final profile = CalibrationV2Profile.fromJson(
            entry.key.toString(),
            json,
          );
          profiles.add(profile);
        } else if (map is Map) {
          final profile = CalibrationV2Profile.fromJson(
            entry.key.toString(),
            Map<String, dynamic>.from(map),
          );
          profiles.add(profile);
        } else {
          report.warnings.add(
            'Profil V2 ${entry.key} ignoré (format inattendu).',
          );
        }
      }
    } catch (e, stackTrace) {
      report.errors.add('Lecture Hive V2 échouée: $e');
      if (kDebugMode) {
        debugPrint(
          'CalibrationMigration._loadExistingProfiles - erreur Hive: $e\n$stackTrace',
        );
      }
    } finally {
      await handle.closeIfNeeded();
    }
    return profiles;
  }

  Future<void> _persistProfiles(
    List<CalibrationV2Profile> profiles,
    CalibrationMigrationReport report,
  ) async {
    final handle = await _openV2Box(createIfMissing: true);
    if (handle.error != null) {
      report.errors.add(
        'Persistance impossible: ${handle.error}',
      );
      return;
    }
    try {
      final box = handle.box;
      if (box == null) {
        report.errors.add('Impossible d\'ouvrir la box V2 pour persistance.');
        return;
      }

      for (final profile in profiles) {
        try {
          await box.put(profile.profileId, profile.toJson());
        } catch (e, stackTrace) {
          report.errors.add(
            'Écriture du profil ${profile.profileId} échouée: $e',
          );
          if (kDebugMode) {
            debugPrint(
              'CalibrationMigration._persistProfiles - erreur: $e\n$stackTrace',
            );
          }
        }
      }

      await box.flush();
    } catch (e, stackTrace) {
      report.errors.add('Persistence Hive V2 échouée: $e');
      if (kDebugMode) {
        debugPrint(
          'CalibrationMigration._persistProfiles - erreur fatale: $e\n$stackTrace',
        );
      }
    } finally {
      await handle.closeIfNeeded();
    }
  }

  Future<_BoxHandle> _openLegacyBox() async {
    if (_legacyBoxOpenerOverride != null) {
      try {
        final box = await _legacyBoxOpenerOverride!(legacyBoxName);
        return _BoxHandle(box: box, wasOpen: false);
      } catch (e) {
        return _BoxHandle(box: null, wasOpen: false, error: e.toString());
      }
    }
    return _openBoxForMigration(legacyBoxName);
  }

  Future<_BoxHandle> _openV2Box({bool createIfMissing = false}) async {
    if (_v2BoxOpenerOverride != null) {
      try {
        final box = await _v2BoxOpenerOverride!(v2BoxName);
        return _BoxHandle(box: box, wasOpen: false);
      } catch (e) {
        return _BoxHandle(box: null, wasOpen: false, error: e.toString());
      }
    }
    return _openBoxForMigration(
      v2BoxName,
      createIfMissing: createIfMissing,
    );
  }

  Future<_BoxHandle> _openBoxForMigration(
    String boxName, {
    bool createIfMissing = false,
  }) async {
    CalibrationMapBox? box;
    var wasOpen = false;

    try {
      final exists = await _hive.boxExists(boxName);
      if (!exists && !createIfMissing) {
        return _BoxHandle(box: null, wasOpen: false);
      }

      if (_hive.isBoxOpen(boxName)) {
        final openedBox = _hive.box(boxName);
        if (openedBox is Box) {
          box = openedBox;
          wasOpen = true;
        } else {
          return _BoxHandle(
            box: null,
            wasOpen: true,
            error: 'Type de box inattendu pour $boxName',
          );
        }
      } else {
        box = await _hive.openBox(boxName);
      }
    } catch (e) {
      return _BoxHandle(box: null, wasOpen: false, error: e.toString());
    }

    return _BoxHandle(box: box, wasOpen: wasOpen);
  }

  static bool _resolveActiveFlag(
    bool existingActive,
    bool candidateActive,
    DateTime existingUpdatedAt,
    DateTime candidateUpdatedAt,
  ) {
    if (existingActive == candidateActive) {
      return existingActive;
    }
    if (candidateActive && !existingActive) {
      return true;
    }
    if (existingActive && !candidateActive) {
      // Conserver actif si plus récent.
      return existingUpdatedAt.isAfter(candidateUpdatedAt);
    }
    return candidateActive;
  }

  static void _enforceSingleActivePerDevice(
    List<CalibrationV2Profile> profiles, {
    CalibrationMigrationReport? report,
  }) {
    final grouped = <String, List<CalibrationV2Profile>>{};
    for (final profile in profiles) {
      grouped.putIfAbsent(profile.deviceId, () => <CalibrationV2Profile>[]);
      grouped[profile.deviceId]!.add(profile);
    }

    for (final entry in grouped.entries) {
      final deviceProfiles = entry.value;
      deviceProfiles.sort(
        (a, b) => b.updatedAt.compareTo(a.updatedAt),
      );

      var activeFound = false;
      for (final profile in deviceProfiles) {
        if (!activeFound && profile.isActive) {
          activeFound = true;
          continue;
        }
        if (profile.isActive) {
          report?.warnings.add(
            'Device ${entry.key}: profil ${profile.profileId} désactivé pour éviter duplicata actif.',
          );
          final index = profiles.indexWhere(
            (element) => element.profileId == profile.profileId,
          );
          if (index != -1) {
            profiles[index] = profile.copyWith(isActive: false);
          }
        }
      }
    }
  }
}

class CalibrationMergeResult {
  CalibrationMergeResult({
    required this.merged,
    required this.migratedCount,
    required this.skippedCount,
  });

  final List<CalibrationV2Profile> merged;
  final int migratedCount;
  final int skippedCount;
}

class CalibrationMigrationReport {
  CalibrationMigrationReport({
    required this.startedAt,
    required this.dryRun,
  });

  final DateTime startedAt;
  final bool dryRun;

  bool success = false;
  Object? error;
  DateTime? endedAt;
  Duration? duration;
  int migratedProfiles = 0;
  int skippedProfiles = 0;
  List<CalibrationV2Profile> preview = const <CalibrationV2Profile>[];

  final List<String> warnings = <String>[];
  final List<String> errors = <String>[];
  final List<String> info = <String>[];

  CalibrationMigrationReport finish() {
    endedAt = DateTime.now().toUtc();
    duration = endedAt!.difference(startedAt);
    return this;
  }

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln('CalibrationMigrationReport(')
      ..writeln('  success: $success')
      ..writeln('  dryRun: $dryRun')
      ..writeln('  migrated: $migratedProfiles, skipped: $skippedProfiles')
      ..writeln('  warnings: ${warnings.length}')
      ..writeln('  errors: ${errors.length}')
      ..writeln(')');
    return buffer.toString();
  }
}

class LegacyCalibrationProfile {
  LegacyCalibrationProfile({
    required this.profileId,
    required this.deviceId,
    required this.metrics,
    required this.updatedAt,
    required this.isActive,
    required this.origin,
  });

  final String profileId;
  final String deviceId;
  final Map<String, LegacyCalibrationMetric> metrics;
  final DateTime? updatedAt;
  final bool isActive;
  final String origin;

  static LegacyCalibrationProfile? fromMap(
    String profileId,
    Map<String, dynamic> map, {
    String? overrideActiveDevice,
  }) {
    final deviceId = _stringValue(map['deviceId']) ??
        _stringValue(map['device_id']) ??
        profileId;
    final updatedAt = _parseDateTime(map['updatedAt'] ?? map['updated_at']);
    final metricsRaw = map['metrics'] ?? map['sensors'];
    if (metricsRaw is! Map) {
      return null;
    }

    final metrics = <String, LegacyCalibrationMetric>{};
    for (final entry in metricsRaw.entries) {
      final key = entry.key.toString();
      final metric = LegacyCalibrationMetric.fromMap(
        sensorId: key,
        map: Map<String, dynamic>.from(
          entry.value is Map ? entry.value as Map : <String, dynamic>{},
        ),
      );
      if (metric != null) {
        metrics[key] = metric;
      }
    }

    if (metrics.isEmpty) {
      return null;
    }

    final isActiveRaw = map['isActive'] ??
        map['active'] ??
        (overrideActiveDevice != null && overrideActiveDevice == deviceId);

    return LegacyCalibrationProfile(
      profileId: profileId,
      deviceId: deviceId,
      metrics: metrics,
      updatedAt: updatedAt,
      isActive: isActiveRaw == true,
      origin: _stringValue(map['origin']) ?? 'legacy',
    );
  }
}

class LegacyCalibrationMetric {
  LegacyCalibrationMetric({
    required this.sensorId,
    this.value,
    this.unit,
    this.updatedAt,
  });

  final String sensorId;
  final dynamic value;
  final String? unit;
  final DateTime? updatedAt;

  static LegacyCalibrationMetric? fromMap({
    required String sensorId,
    required Map<String, dynamic> map,
  }) {
    final value = map['value'] ?? map['offset'] ?? map['reading'];
    final unit = _stringValue(map['unit']);
    final updatedAt = _parseDateTime(map['updatedAt'] ?? map['timestamp']);
    if (value == null && unit == null) {
      return null;
    }
    return LegacyCalibrationMetric(
      sensorId: sensorId,
      value: value,
      unit: unit,
      updatedAt: updatedAt,
    );
  }
}

@immutable
class CalibrationMetricV2 {
  const CalibrationMetricV2({
    required this.sensorId,
    required this.value,
    required this.unit,
    required this.updatedAt,
  });

  final String sensorId;
  final double value;
  final String unit;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sensorId': sensorId,
        'value': value,
        'unit': unit,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CalibrationMetricV2.fromJson(Map<String, dynamic> json) {
    return CalibrationMetricV2(
      sensorId: _stringValue(json['sensorId']) ?? 'unknown',
      value: _toDouble(json['value']) ?? 0.0,
      unit: _stringValue(json['unit']) ?? '',
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now().toUtc(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CalibrationMetricV2) return false;
    return sensorId == other.sensorId &&
        value == other.value &&
        unit == other.unit &&
        updatedAt.toIso8601String() == other.updatedAt.toIso8601String();
  }

  @override
  int get hashCode =>
      sensorId.hashCode ^ value.hashCode ^ unit.hashCode ^ updatedAt.hashCode;
}

@immutable
class CalibrationV2Profile {
  const CalibrationV2Profile({
    required this.profileId,
    required this.deviceId,
    required this.metrics,
    required this.updatedAt,
    required this.isActive,
    this.origin,
  });

  final String profileId;
  final String deviceId;
  final Map<String, CalibrationMetricV2> metrics;
  final DateTime updatedAt;
  final bool isActive;
  final String? origin;

  CalibrationV2Profile copyWith({
    Map<String, CalibrationMetricV2>? metrics,
    DateTime? updatedAt,
    bool? isActive,
    String? origin,
  }) {
    return CalibrationV2Profile(
      profileId: profileId,
      deviceId: deviceId,
      metrics: metrics ?? this.metrics,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      origin: origin ?? this.origin,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'profileId': profileId,
        'deviceId': deviceId,
        'metrics': metrics.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
        'updatedAt': updatedAt.toIso8601String(),
        'isActive': isActive,
        'origin': origin,
      };

  factory CalibrationV2Profile.fromJson(
    String key,
    Map<String, dynamic> json,
  ) {
    final metricsJson = json['metrics'];
    final metrics = <String, CalibrationMetricV2>{};
    if (metricsJson is Map<String, dynamic>) {
      for (final entry in metricsJson.entries) {
        if (entry.value is Map<String, dynamic>) {
          metrics[entry.key] =
              CalibrationMetricV2.fromJson(entry.value as Map<String, dynamic>);
        } else if (entry.value is Map) {
          metrics[entry.key] = CalibrationMetricV2.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
        }
      }
    }

    return CalibrationV2Profile(
      profileId: _stringValue(json['profileId']) ?? key,
      deviceId: _stringValue(json['deviceId']) ?? key,
      metrics: metrics,
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now().toUtc(),
      isActive: json['isActive'] == true,
      origin: _stringValue(json['origin']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CalibrationV2Profile) return false;
    return profileId == other.profileId &&
        deviceId == other.deviceId &&
        isActive == other.isActive &&
        origin == other.origin &&
        updatedAt.toIso8601String() == other.updatedAt.toIso8601String() &&
        mapEquals(metrics, other.metrics);
  }

  @override
  int get hashCode =>
      profileId.hashCode ^
      deviceId.hashCode ^
      metrics.hashCode ^
      updatedAt.hashCode ^
      isActive.hashCode ^
      origin.hashCode;
}

class _BoxHandle {
  _BoxHandle({
    this.box,
    required this.wasOpen,
    this.error,
  });

  final CalibrationMapBox? box;
  final bool wasOpen;
  final String? error;

  Future<void> closeIfNeeded() async {
    if (box != null && !wasOpen) {
      await box!.close();
    }
  }
}

String? _stringValue(Object? value) {
  if (value == null) return null;
  if (value is String && value.trim().isEmpty) return null;
  if (value is String) return value;
  return value.toString();
}

double? _toDouble(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

DateTime? _parseDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value.toUtc();
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  if (value is double) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
  }
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.toUtc();
    final numeric = int.tryParse(value);
    if (numeric != null) {
      return DateTime.fromMillisecondsSinceEpoch(numeric, isUtc: true);
    }
  }
  return null;
}
