import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/plant_localized.dart';
import '../../core/hive/type_ids.dart';

class PlantsRepository {
  // Cache open boxes
  final Map<String, Box<PlantLocalized>> _openBoxes = {};

  Future<Box<PlantLocalized>> _getBox(String locale) async {
    if (_openBoxes.containsKey(locale)) {
      return _openBoxes[locale]!;
    }
    final boxName = 'plants_$locale';
    final box = await Hive.openBox<PlantLocalized>(boxName);
    _openBoxes[locale] = box;
    return box;
  }

  /// Import a pack into the appropriate Hive box.
  /// This expects the pack to be already unpacked or handled by a service.
  /// Actually, the prompt says "importPack(File zip, String locale)".
  /// But the logic to unzip might be in PackManager. 
  /// The Repository should probably take a list of PlantLocalized objects or a JSON file path?
  /// The prompt says: "Implement store in Hive box plants_{locale}".
  /// I will assume this method takes the parsed data or a list for now, 
  /// OR keeps the signature and does the logic if manageable.
  /// Let's stick to the prompt: "Future<void> importPack(File zip, String locale)".
  /// Wait, unzip in repo? Maybe separate concerns. 
  /// "Client logic in lib/services/pack_manager.dart... unzip, run importPack".
  /// So importPack probably takes the UNZIPPED directory or JSON file. 
  /// I'll make it take a list of objects to be clean, or the directory.
  /// Let's make it `importData(List<PlantLocalized> plants, String locale)`.
  /// And `PackManager` will handle the ZIP/JSON parsing.
  
  Future<void> importData(List<PlantLocalized> plants, String locale) async {
    final box = await _getBox(locale);
    
    // Batch write
    final Map<dynamic, PlantLocalized> entries = {};
    for (var p in plants) {
      entries[p.id] = p;
    }
    await box.putAll(entries);
  }

  Future<PlantLocalized?> findById(String id, String locale) async {
    final box = await _getBox(locale);
    return box.get(id);
  }

  Future<List<PlantLocalized>> search(String query, String locale) async {
    final box = await _getBox(locale);
    if (query.isEmpty) return box.values.toList();
    
    final q = query.toLowerCase();
    return box.values.where((p) {
      final local = p.localized[locale];
      if (local != null) {
        if (local.commonName.toLowerCase().contains(q)) return true;
      }
      return p.scientificName.toLowerCase().contains(q);
    }).toList();
  }
}

final plantsRepositoryProvider = Provider<PlantsRepository>((ref) {
  return PlantsRepository();
});
