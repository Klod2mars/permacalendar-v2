// lib/core/data/hive/garden_boxes.dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/garden.dart';
import '../../models/garden_bed.dart';
import '../../models/planting.dart';

class GardenBoxes {
  /// Activer pour debug ponctuel. Par défaut false pour éviter le flood de logs.
  // TEMPORARY: Enabled for QA of Refactoring Option B1
  static bool verboseLogging = true;

  static const String _gardensBoxName = 'gardens';
  static const String _gardenBedsBoxName = 'garden_beds';
  static const String _plantingsBoxName = 'plantings';
  static const String _harvestsBoxName = 'harvests';
  static const String _activitiesBoxName = 'activities';
  static const String _plantsBoxName = 'plants';
  static const String _exportPreferencesBoxName = 'export_preferences';

  static Box<Garden>? _gardensBox;
  static Box<GardenBed>? _gardenBedsBox;
  static Box<Planting>? _plantingsBox;
  static Box? _harvestsBox; // Stores Maps (JSON)
  static Box? _activitiesBox; // Stores Activities
  static Box? _plantsBox; // Stores Plants
  static Box? _exportPreferencesBox; // Stores Export Config (Maps)

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

  static Box get harvests {
    if (_harvestsBox == null || !_harvestsBox!.isOpen) {
      throw Exception('Harvests box n\'est pas initialisée');
    }
    return _harvestsBox!;
  }

  static Box get activities {
    if (_activitiesBox == null || !_activitiesBox!.isOpen) {
      throw Exception('Activities box n\'est pas initialisée');
    }
    return _activitiesBox!;
  }

  static Box get plants {
    if (_plantsBox == null || !_plantsBox!.isOpen) {
      throw Exception('Plants box n\'est pas initialisée');
    }
    return _plantsBox!;
  }

  static Box get exportPreferences {
    if (_exportPreferencesBox == null || !_exportPreferencesBox!.isOpen) {
      throw Exception('Export preferences box n\'est pas initialisée');
    }
    return _exportPreferencesBox!;
  }

  static Future<void> initialize() async {
    try {
      // Ouvrir les boxes
      _gardensBox = await Hive.openBox<Garden>(_gardensBoxName);
      _gardenBedsBox = await Hive.openBox<GardenBed>(_gardenBedsBoxName);
      _plantingsBox = await Hive.openBox<Planting>(_plantingsBoxName);
      _harvestsBox = await Hive.openBox(_harvestsBoxName);
      _activitiesBox = await Hive.openBox(_activitiesBoxName);
      _plantsBox = await Hive.openBox(_plantsBoxName);
      _exportPreferencesBox = await Hive.openBox(_exportPreferencesBoxName);
      debugPrint('[GardenBoxes] harvests box opened: ${_harvestsBox!.name}');

      if (verboseLogging)
        developer.log('[GardenBoxes] Boxes initialisées avec succès');
    } catch (e) {
      if (verboseLogging)
        developer.log('[GardenBoxes] Erreur lors de l\'initialisation: $e');
      rethrow;
    }
  }

  static Future<void> close() async {
    await _gardensBox?.close();
    await _gardenBedsBox?.close();
    await _plantingsBox?.close();
    await _harvestsBox?.close();
    await _activitiesBox?.close();
    await _plantsBox?.close();
    await _exportPreferencesBox?.close();

    _gardensBox = null;
    _gardenBedsBox = null;
    _plantingsBox = null;
    _harvestsBox = null;
    _activitiesBox = null;
    _plantsBox = null;
    _exportPreferencesBox = null;
  }

  // Méthodes utilitaires pour les jardins
  static Future<void> clearAllGardens() async {
    await gardens.clear();
    await gardenBeds.clear();
    await plantings.clear();
    await harvests.clear();
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

    if (verboseLogging) {
      developer.log(
          '[GardenBoxes] getGardenBeds($gardenId): ${allBeds.length} parcelles totales, ${filteredBeds.length} pour ce jardin');
      for (final bed in filteredBeds) {
        developer.log(
            '[GardenBoxes]   - Parcelle: ${bed.name} (ID: ${bed.id}, Jardin: ${bed.gardenId})');
      }
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
      if (verboseLogging)
        developer.log(
            '[GardenBoxes] Erreur lors de la récupération des plantations actives: $e');
      return [];
    }
  }

  /// Retourne la plantation active (la plus récente) pour une parcelle (bedId).
  /// Renvoie `null` si aucune plantation active trouvée.
  static Planting? getActivePlantingForBed(String bedId) {
    try {
      final bedPlantings = plantings.values
          .where((p) => p.gardenBedId == bedId && p.isActive)
          .toList();
      if (bedPlantings.isEmpty) return null;
      // Retourner la plus récente (par plantedDate)
      bedPlantings.sort((a, b) => b.plantedDate.compareTo(a.plantedDate));
      return bedPlantings.first;
    } catch (e) {
      if (verboseLogging)
        developer.log('[GardenBoxes] getActivePlantingForBed error: $e');
      return null;
    }
  }
}
