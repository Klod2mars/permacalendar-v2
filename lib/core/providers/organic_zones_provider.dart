import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../models/organic_zone_config.dart';
import '../utils/position_persistence.dart';

/// État: map de zones par identifiant
class OrganicZonesNotifier extends Notifier<Map<String, OrganicZoneConfig>> {
  @override
  Map<String, OrganicZoneConfig> build() => <String, OrganicZoneConfig>{};

  /// Charge les positions, tailles et états depuis SharedPreferences
  Future<void> loadFromStorage({
    required Map<String, Offset> defaultPositions,
    required Map<String, double> defaultSizes,
    required Map<String, bool> defaultEnabled,
  }) async {
    // ✅ PHASE 4: Log de debug
    if (kDebugMode) {
      debugPrint(
          '🔧 [CALIBRATION] loadFromStorage: Chargement de ${defaultPositions.length} zones');
    }

    final positions =
        await PositionPersistence.load('organic', defaultPositions);
    final sizes = await PositionPersistence.loadSizes('organic', defaultSizes);
    final flags =
        await PositionPersistence.loadBooleans('organic', defaultEnabled);

    final entries = <String, OrganicZoneConfig>{};
    for (final key in defaultPositions.keys) {
      final pos = positions[key] ?? defaultPositions[key]!;
      final size = sizes[key] ?? defaultSizes[key]!;
      
      // FIX (Audit): Clamp values to safe ranges
      final safePos = Offset(pos.dx.clamp(0.0, 1.0), pos.dy.clamp(0.0, 1.0));
      final safeSize = size.clamp(0.05, 1.0);

      entries[key] = OrganicZoneConfig(
        id: key,
        name: key,
        position: safePos, // Use safePos
        size: safeSize,    // Use safeSize
        enabled: flags[key] ?? defaultEnabled[key]!,
      );
    }
    state = entries;

    // ✅ PHASE 4: Log de debug
    if (kDebugMode) {
      debugPrint(
          '🔧 [CALIBRATION] loadFromStorage: ${entries.length} zones chargées');
      debugPrint('🔧 [CALIBRATION] Zones chargées: ${entries.keys.toList()}');
    }
  }

  /// Sauvegarde toutes les zones
  Future<void> saveAll() async {
    // ✅ PHASE 4: Log de debug
    if (kDebugMode) {
      debugPrint(
          '🔧 [CALIBRATION] saveAll: Sauvegarde de ${state.length} zones');
    }

    final positions = <String, Offset>{};
    final sizes = <String, double>{};
    final flags = <String, bool>{};

    for (final entry in state.entries) {
      positions[entry.key] = entry.value.position;
      sizes[entry.key] = entry.value.size;
      flags[entry.key] = entry.value.enabled;
    }

    await PositionPersistence.save('organic', positions);
    await PositionPersistence.saveSizes('organic', sizes);
    await PositionPersistence.saveBooleans('organic', flags);

    // ✅ PHASE 4: Log de debug
    if (kDebugMode) {
      debugPrint('🔧 [CALIBRATION] saveAll: Sauvegarde terminée avec succès');
    }
  }

  /// Met à jour la position d'une zone
  void setPosition(String id, Offset position) {
    final current = state[id];
    if (current == null) {
      // ✅ PHASE 4: Log de debug
      if (kDebugMode) {
        debugPrint('⚠️ [CALIBRATION] setPosition: Zone $id introuvable');
      }
      return;
    }
    final updated = Map<String, OrganicZoneConfig>.from(state);
    updated[id] = current.copyWith(position: position);
    state = updated;

    // ✅ PHASE 4: Log de debug
    if (kDebugMode) {
      debugPrint(
          '🔧 [CALIBRATION] setPosition: Zone $id déplacée vers ($position)');
    }
  }

  /// Met à jour la taille d'une zone
  void setSize(String id, double size) {
    final current = state[id];
    if (current == null) return;
    final updated = Map<String, OrganicZoneConfig>.from(state);
    updated[id] = current.copyWith(size: size);
    state = updated;
  }

  /// Active/désactive une zone
  void setEnabled(String id, bool enabled) {
    final current = state[id];
    if (current == null) return;
    final updated = Map<String, OrganicZoneConfig>.from(state);
    updated[id] = current.copyWith(enabled: enabled);
    state = updated;
  }
}

/// Provider Riverpod 3.x
final organicZonesProvider =
    NotifierProvider<OrganicZonesNotifier, Map<String, OrganicZoneConfig>>(
  OrganicZonesNotifier.new,
);
