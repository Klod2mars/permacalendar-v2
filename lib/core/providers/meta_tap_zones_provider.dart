import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meta_tap_zone_config.dart';
import '../utils/position_persistence.dart';

/// Provider for the collection of Meta Tap Zones.
final metaTapZonesProvider =
    NotifierProvider<MetaTapZonesNotifier, Map<String, MetaTapZoneConfig>>(
        MetaTapZonesNotifier.new);

class MetaTapZonesNotifier extends Notifier<Map<String, MetaTapZoneConfig>> {
  static const String _persistencePrefix = 'meta_tap';

  @override
  Map<String, MetaTapZoneConfig> build() {
    return {};
  }

  /// Loads meta zones from storage (SharedPreferences via PositionPersistence).
  ///
  /// This mirrors the logic of [OrganicZonesNotifier.loadFromStorage] to ensure
  /// consistency in how positions, sizes, and enabled flags are restored.
  Future<void> loadFromStorage({
    required Map<String, Offset> defaultPositions,
    required Map<String, double> defaultSizes,
    required Map<String, bool> defaultEnabled,
  }) async {
    // 1. Load normalized positions
    final loadedPositions = await PositionPersistence.load(
      _persistencePrefix,
      defaultPositions,
    );

    // 2. Load normalized sizes
    final loadedSizes = await PositionPersistence.loadSizes(
      _persistencePrefix,
      defaultSizes,
    );

    // 3. Load enabled flags
    final loadedEnabled = await PositionPersistence.loadBooleans(
      _persistencePrefix,
      defaultEnabled,
    );

    // 4. Construct the configuration map
    final newMap = <String, MetaTapZoneConfig>{};

    // Iterate over the union of keys to ensure we capture everything
    final allKeys = <String>{
      ...loadedPositions.keys,
      ...defaultPositions.keys,
    };

    for (final key in allKeys) {
      if (loadedPositions.containsKey(key)) {
        newMap[key] = MetaTapZoneConfig(
          id: key,
          bubbleId: null, // Can be refined if we store this linkage later
          position: loadedPositions[key]!,
          size: loadedSizes[key] ?? 0.1,
          enabled: loadedEnabled[key] ?? true,
          layoutVersion: 1,
          updatedAt: DateTime.now(),
        );
      }
    }

    state = newMap;
  }

  /// Saves all current meta zones to storage.
  ///
  /// Must be called explicitly (e.g., when exiting calibration mode).
  Future<void> saveAll() async {
    final positions = <String, Offset>{};
    final sizes = <String, double>{};
    final enabledMap = <String, bool>{};

    for (final entry in state.entries) {
      positions[entry.key] = entry.value.position;
      sizes[entry.key] = entry.value.size;
      enabledMap[entry.key] = entry.value.enabled;
    }

    await PositionPersistence.save(_persistencePrefix, positions);
    await PositionPersistence.saveSizes(_persistencePrefix, sizes);
    await PositionPersistence.saveBooleans(_persistencePrefix, enabledMap);
  }

  void setPosition(String id, Offset newPos) {
    if (!state.containsKey(id)) return;
    
    // Clamp to 0..1 to ensure validity
    final clamped = Offset(
      newPos.dx.clamp(0.0, 1.0),
      newPos.dy.clamp(0.0, 1.0),
    );

    final old = state[id]!;
    state = {
      ...state,
      id: old.copyWith(position: clamped, updatedAt: DateTime.now()),
    };
  }

  void setSize(String id, double newSize) {
    if (!state.containsKey(id)) return;

    // Clamp size (e.g. 0.05 to 1.0)
    final clamped = newSize.clamp(0.05, 1.0);

    final old = state[id]!;
    state = {
      ...state,
      id: old.copyWith(size: clamped, updatedAt: DateTime.now()),
    };
  }

  void setEnabled(String id, bool enabled) {
    if (!state.containsKey(id)) return;

    final old = state[id]!;
    state = {
      ...state,
      id: old.copyWith(enabled: enabled, updatedAt: DateTime.now()),
    };
  }
}
