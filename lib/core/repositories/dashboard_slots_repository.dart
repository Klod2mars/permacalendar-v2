import 'package:hive_flutter/hive_flutter.dart';

/// Repository léger pour lier un "dashboard_slot" à un gardenId
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
    return box.get(slot.toString());
  }

  /// Lecture asynchrone (sécurisée)
  static Future<String?> getGardenIdForSlot(int slot) async {
    final box = await _ensureBox();
    return box.get(slot.toString());
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

