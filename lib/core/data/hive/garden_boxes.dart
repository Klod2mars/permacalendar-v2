import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'hive_service.dart';

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
      // Ouvrir les boxes avec mécanisme de retry (récupération de lock)
      _gardensBox = await _openBoxWithRetry<Garden>(_gardensBoxName);
      _gardenBedsBox = await _openBoxWithRetry<GardenBed>(_gardenBedsBoxName);
      _plantingsBox = await _openBoxWithRetry<Planting>(_plantingsBoxName);
      _harvestsBox = await _openBoxWithRetry(_harvestsBoxName);
      _activitiesBox = await _openBoxWithRetry(_activitiesBoxName);
      _plantsBox = await _openBoxWithRetry(_plantsBoxName);
      _exportPreferencesBox = await _openBoxWithRetry(_exportPreferencesBoxName);
      
      debugPrint('[GardenBoxes] harvests box opened: ${_harvestsBox!.name}');

      if (verboseLogging)
        developer.log('[GardenBoxes] Boxes initialisées avec succès');
    } catch (e) {
      if (verboseLogging)
        developer.log('[GardenBoxes] Erreur lors de l\'initialisation: $e');
      rethrow;
    }
  }

  /// Tente d'ouvrir une box. En cas d'erreur de lock, supprime le fichier .lock et réessaie.
  static Future<Box<T>> _openBoxWithRetry<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      if (e.toString().toLowerCase().contains('lock')) {
         developer.log('[GardenBoxes] Lock détecté sur $boxName. Tentative de suppression du lock...', level: 900);
         try {
           final appDir = await getApplicationDocumentsDirectory();
           final lockFile = File(p.join(appDir.path, '$boxName.lock'));
           if (await lockFile.exists()) {
             await lockFile.delete();
             developer.log('[GardenBoxes] Lock supprimé. Nouvelle tentative ouverture...', level: 500);
             return await Hive.openBox<T>(boxName);
           }
         } catch (recoveryError) {
           developer.log('[GardenBoxes] Echec récupération lock: $recoveryError', level: 1000);
         }
      }
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
    return HiveService.collectByFilterSync<Garden>(
      gardens,
      (Garden g) => true, // renvoie tout mais en streaming par clés
      maxScan: 5000,
      maxResults: 2000,
    );
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
    // Remplacement safe : itère par clés et récupère uniquement les objets nécessaires,
    // avec des limites pour se protéger des cas extrêmes.
    final filteredBeds = HiveService.collectByFilterSync<GardenBed>(
      gardenBeds,
      (GardenBed bed) => bed.gardenId == gardenId,
      maxScan: 2000, // ajuster selon besoin
      maxResults: 1000, // mais typiquement on s'attend à beaucoup moins
    );

    if (verboseLogging) {
      developer.log(
          '[GardenBoxes] getGardenBeds($gardenId): scanned limit etc -> ${filteredBeds.length}');
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
      // Use Set for faster lookups
      final gardenBedIds = gardenBeds.map((bed) => bed.id).toSet();

      // Récupérer toutes les plantations actives pour ces lits via collectByFilterSync
      return HiveService.collectByFilterSync<Planting>(
        plantings,
        (planting) =>
            gardenBedIds.contains(planting.gardenBedId) && planting.isActive,
        maxScan: 5000,
        maxResults: 2000,
      );
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
      final bedPlantings = HiveService.collectByFilterSync<Planting>(
        plantings,
        (p) => p.gardenBedId == bedId && p.isActive,
        maxScan: 5000,
        maxResults: 500,
      );

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
