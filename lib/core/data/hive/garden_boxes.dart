import 'package:hive_flutter/hive_flutter.dart';
import '../../models/garden.dart';
import '../../models/garden_bed.dart';
import '../../models/planting.dart';

class GardenBoxes {
  static const String _gardensBoxName = 'gardens';
  static const String _gardenBedsBoxName = 'garden_beds';
  static const String _plantingsBoxName = 'plantings';

  static Box<Garden>? _gardensBox;
  static Box<GardenBed>? _gardenBedsBox;
  static Box<Planting>? _plantingsBox;

  // Getters pour les boxes
  static Box<Garden> get gardens {
    if (_gardensBox == null || !_gardensBox!.isOpen) {
      throw Exception('Gardens box n\'est pas initialisée');
    }
    return _gardensBox!;
  }

  static Box<GardenBed> get gardenBeds {
    if (_gardenBedsBox == null || !_gardenBedsBox!.isOpen) {
      throw Exception('Garden beds box n\'est pas initialisée');
    }
    return _gardenBedsBox!;
  }

  static Box<Planting> get plantings {
    if (_plantingsBox == null || !_plantingsBox!.isOpen) {
      throw Exception('Plantings box n\'est pas initialisée');
    }
    return _plantingsBox!;
  }

  static Future<void> initialize() async {
    try {
      // Ouvrir les boxes
      _gardensBox = await Hive.openBox<Garden>(_gardensBoxName);
      _gardenBedsBox = await Hive.openBox<GardenBed>(_gardenBedsBoxName);
      _plantingsBox = await Hive.openBox<Planting>(_plantingsBoxName);

      print('[GardenBoxes] Boxes initialisées avec succès');
    } catch (e) {
      print('[GardenBoxes] Erreur lors de l\'initialisation: $e');
      rethrow;
    }
  }

  static Future<void> close() async {
    await _gardensBox?.close();
    await _gardenBedsBox?.close();
    await _plantingsBox?.close();

    _gardensBox = null;
    _gardenBedsBox = null;
    _plantingsBox = null;
  }

  // Méthodes utilitaires pour les jardins
  static Future<void> clearAllGardens() async {
    await gardens.clear();
    await gardenBeds.clear();
    await plantings.clear();
  }

  static List<Garden> getAllGardens() {
    return gardens.values.toList();
  }

  static Garden? getGarden(String id) {
    return gardens.get(id);
  }

  static Future<void> saveGarden(Garden garden) async {
    await gardens.put(garden.id, garden);
  }

  static Future<void> deleteGarden(String id) async {
    // Supprimer le jardin
    await gardens.delete(id);

    // Supprimer toutes les zones de culture associées
    final bedsToDelete = gardenBeds.values
        .where((bed) => bed.gardenId == id)
        .map((bed) => bed.id)
        .toList();

    for (final bedId in bedsToDelete) {
      await gardenBeds.delete(bedId);

      // Supprimer toutes les plantations associées à cette zone
      final plantingsToDelete = plantings.values
          .where((planting) => planting.gardenBedId == bedId)
          .map((planting) => planting.id)
          .toList();

      for (final plantingId in plantingsToDelete) {
        await plantings.delete(plantingId);
      }
    }
  }

  // Méthodes utilitaires pour les zones de culture
  static List<GardenBed> getGardenBeds(String gardenId) {
    final allBeds = gardenBeds.values.toList();
    final filteredBeds =
        allBeds.where((bed) => bed.gardenId == gardenId).toList();
    print(
        '[GardenBoxes] getGardenBeds($gardenId): ${allBeds.length} parcelles totales, ${filteredBeds.length} pour ce jardin');
    for (final bed in filteredBeds) {
      print(
          '[GardenBoxes]   - Parcelle: ${bed.name} (ID: ${bed.id}, Jardin: ${bed.gardenId})');
    }
    return filteredBeds;
  }

  static GardenBed? getGardenBedById(String bedId) {
    return gardenBeds.get(bedId);
  }

  static Future<void> saveGardenBed(GardenBed bed) async {
    await gardenBeds.put(bed.id, bed);
  }

  static Future<void> deleteGardenBed(String id) async {
    await gardenBeds.delete(id);

    // Supprimer toutes les plantations associées
    final plantingsToDelete = plantings.values
        .where((planting) => planting.gardenBedId == id)
        .map((planting) => planting.id)
        .toList();

    for (final plantingId in plantingsToDelete) {
      await plantings.delete(plantingId);
    }
  }

  // Méthodes utilitaires pour les plantations
  static List<Planting> getPlantings(String gardenBedId) {
    return plantings.values
        .where((planting) => planting.gardenBedId == gardenBedId)
        .toList();
  }

  static Future<void> savePlanting(Planting planting) async {
    await plantings.put(planting.id, planting);
  }

  static Future<void> deletePlanting(String id) async {
    await plantings.delete(id);
  }

  // Méthodes pour récupérer les plantations actives par jardin
  static List<Planting> getActivePlantingsForGarden(String gardenId) {
    try {
      // Récupérer tous les lits de jardin pour ce jardin
      final gardenBeds = getGardenBeds(gardenId);
      final gardenBedIds = gardenBeds.map((bed) => bed.id).toList();

      // Récupérer toutes les plantations actives pour ces lits
      return plantings.values
          .where((planting) =>
              gardenBedIds.contains(planting.gardenBedId) && planting.isActive)
          .toList();
    } catch (e) {
      print(
          '[GardenBoxes] Erreur lors de la récupération des plantations actives: $e');
      return [];
    }
  }
}

