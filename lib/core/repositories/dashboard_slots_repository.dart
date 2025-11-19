import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Repository léger pour lier un "dashboard_slot" à un gardenId
///
/// Stocke la map slot -> gardenId dans une box Hive 'dashboard_slots'.
class DashboardSlotsRepository {
  static const String _boxName = 'dashboard_slots';
  static Box<String>? _box;

  static bool isOpen() => _box != null && _box!.isOpen;

  static Future<Box<String>> _ensureBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<String>(_boxName);
    }
    return _box!;
  }

  /// Lecture synchrone si la box est déjà ouverte (utilisé depuis la UI pour éviter les await dans build)
  static String? getGardenIdForSlotSync(int slot) {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final box = Hive.box<String>(_boxName);

    // 1) Primary lookup (new canonical key)
    final primary = box.get(slot.toString());
    if (primary != null && primary.isNotEmpty) return primary;

    // 2) Legacy key style: "slot_<n>"
    final legacy = box.get('slot_$slot');
    if (legacy != null && legacy.isNotEmpty) return legacy;

    // 3) Backwards-compatible fallback: some older code may have stored 0-based keys
    if (slot > 0) {
      final zeroBased = box.get((slot - 1).toString());
      if (zeroBased != null && zeroBased.isNotEmpty) return zeroBased;

      final zeroBasedLegacy = box.get('slot_${slot - 1}');
      if (zeroBasedLegacy != null && zeroBasedLegacy.isNotEmpty)
        return zeroBasedLegacy;
    }

    if (kDebugMode) {
      // debug hint for developer to inspect box content when lookup fails
      try {
        final keys = box.keys.take(20).toList();
        debugPrint('DashboardSlotsRepository: lookup miss for slot=$slot, seen keys (sample 20): $keys');
      } catch (_) {}
    }

    return null;
  }

  /// Lecture asynchrone (sécurisée)
  static Future<String?> getGardenIdForSlot(int slot) async {
    final box = await _ensureBox();

    // Primary lookup
    final primary = box.get(slot.toString());
    if (primary != null && primary.isNotEmpty) return primary;

    // Legacy key "slot_<n>"
    final legacy = box.get('slot_$slot');
    if (legacy != null && legacy.isNotEmpty) return legacy;

    // Zero-based / legacy zero-based fallbacks
    if (slot > 0) {
      final zeroBased = box.get((slot - 1).toString());
      if (zeroBased != null && zeroBased.isNotEmpty) return zeroBased;

      final zeroBasedLegacy = box.get('slot_${slot - 1}');
      if (zeroBasedLegacy != null && zeroBasedLegacy.isNotEmpty)
        return zeroBasedLegacy;
    }

    if (kDebugMode) {
      try {
        final keys = box.keys.take(20).toList();
        debugPrint('DashboardSlotsRepository.async: lookup miss for slot=$slot, seen keys (sample 20): $keys');
      } catch (_) {}
    }

    return null;
  }

  /// Ecriture asynchrone
  static Future<void> setGardenIdForSlot(int slot, String gardenId) async {
    final box = await _ensureBox();
    await box.put(slot.toString(), gardenId);
  }

  /// Supprime l'association pour un slot
  static Future<void> clearSlot(int slot) async {
    final box = await _ensureBox();
    await box.delete(slot.toString());
  }
}
