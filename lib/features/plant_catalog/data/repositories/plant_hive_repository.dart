// lib/features/plant_catalog/data/repositories/plant_hive_repository.dart

import 'dart:convert';

import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../models/plant_hive.dart';
import '../../domain/entities/plant_entity.dart';

/// Exception personnalisée pour les erreurs du PlantHiveRepository
class PlantHiveException implements Exception {
  final String message;
  const PlantHiveException(this.message);

  @override
  String toString() => 'PlantHiveException: $message';
}

/// Repository pour la gestion des plantes avec persistance Hive
///
/// Fonctionnalités :
/// - Chargement depuis assets/data/plants.json
/// - Conversion flexible PlantHive â†” PlantFreezed
/// - Tolérance aux champs manquants
/// - Journalisation discrète des erreurs
/// - Aucune validation stricte pour permettre l'ajout libre
class PlantHiveRepository {
  static const String _boxName = 'plants_box';
  // Updated source to tokenized file
  static const String _jsonAssetPath = 'assets/data/plants_tokenized.json';

  Box<PlantHive>? _box;
  bool _isInitialized = false;

  /// Initialise le repository et ouvre la box Hive
  static Future<void> initialize() async {
    try {
      await Hive.openBox<PlantHive>(_boxName);

      developer.log('PlantHiveRepository: Box initialisée avec succès',
          name: 'PlantHiveRepository');
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur lors de l\'initialisation de la box: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException(
          'Impossible d\'initialiser la box des plantes: $e');
    }
  }

  /// Obtient la box Hive, l'initialise si nécessaire
  Future<Box<PlantHive>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      try {
        _box = await Hive.openBox<PlantHive>(_boxName);

        developer.log('PlantHiveRepository: Box ouverte',
            name: 'PlantHiveRepository');
      } catch (e) {
        developer.log('PlantHiveRepository: Erreur ouverture box: $e',
            name: 'PlantHiveRepository', level: 1000);
        throw PlantHiveException('Impossible d\'ouvrir la box des plantes: $e');
      }
    }
    return _box!;
  }

  /// Récupère toutes les plantes depuis la base de données locale
  ///
  /// Retourne une liste vide si aucune plante n'est trouvée.
  /// Les erreurs de conversion sont journalisées mais n'interrompent pas le processus.
  Future<List<PlantFreezed>> getAllPlants() async {
    try {
      final box = await _getBox();
      final plants = <PlantFreezed>[];

      for (final plantHive in box.values) {
        try {
          final plantFreezed = _fromHiveModel(plantHive);
          plants.add(plantFreezed);
        } catch (e) {
          // Journalisation discrète des erreurs de conversion par plante
          developer.log(
              'PlantHiveRepository: Erreur conversion plante ${plantHive.id}: $e',
              name: 'PlantHiveRepository',
              level: 900);
          // Continue avec les autres plantes
        }
      }

      developer.log('PlantHiveRepository: ${plants.length} plantes récupérées',
          name: 'PlantHiveRepository');

      return plants;
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur lors de la récupération des plantes: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException('Impossible de récupérer les plantes: $e');
    }
  }

  /// Récupère une plante spécifique par son ID
  Future<PlantFreezed?> getPlantById(String id) async {
    try {
      final box = await _getBox();
      final plantHive = box.get(id);

      if (plantHive == null) {
        developer.log('PlantHiveRepository: Plante non trouvée: $id',
            name: 'PlantHiveRepository');
        return null;
      }

      try {
        final plantFreezed = _fromHiveModel(plantHive);
        developer.log('PlantHiveRepository: Plante récupérée: $id',
            name: 'PlantHiveRepository');
        return plantFreezed;
      } catch (e) {
        developer.log('PlantHiveRepository: Erreur conversion plante $id: $e',
            name: 'PlantHiveRepository', level: 1000);
        return null;
      }
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur lors de la récupération de la plante $id: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException('Impossible de récupérer la plante $id: $e');
    }
  }


  static bool _isSyncing = false;

  /// Retrieves the correct asset path based on the language code
  String _getAssetPath(String languageCode) {
    // Normalization: pt_BR -> pt, en_US -> en
    final normalizedCode = languageCode.toLowerCase().split('_')[0].split('-')[0];

    const Map<String, String> langPaths = {
      'fr': 'assets/data/plants.json',
      'en': 'assets/data/json_multilangue_doc/plants_en.json',
      'es': 'assets/data/json_multilangue_doc/plants_es.json',
      'it': 'assets/data/json_multilangue_doc/plants_it.json',
      'de': 'assets/data/json_multilangue_doc/plants_de.json',
      'pt': 'assets/data/json_multilangue_doc/plants_pt.json',
    };

    return langPaths[normalizedCode] ?? 'assets/data/plants.json';
  }

  /// Synchronise la base de données locale avec le fichier JSON (Smart Sync)
  ///
  /// - Charge le JSON correspondant à la langue
  /// - Ajoute les nouvelles plantes
  /// - Met à jour les plantes existantes (contenu traduit)
  /// - Préserve les préférences utilisateur (isActive, createdAt)
  Future<void> syncWithJson([String languageCode = 'fr']) async {
    if (_isSyncing) {
      print('PlantHiveRepository: Sync already in progress, skipping.');
      return;
    }
    _isSyncing = true;

    try {
      developer.log('PlantHiveRepository: Début de la synchronisation JSON (Smart Sync) - Langue: $languageCode',
          name: 'PlantHiveRepository');
      print('PlantHiveRepository: syncWithJson START - Langue: $languageCode');

      // 0. Préparer le fallback map pour les images (charger les noms FR si on est pas en FR)
      // Cela permet de retrouver les images nommées en français même si on charge un JSON allemand/anglais
      Map<String, String> frenchFallbackMap = {};
      if (languageCode.toLowerCase() != 'fr') {
        try {
          final frAssetPath = _getAssetPath('fr');
          final frJsonString = await rootBundle.loadString(frAssetPath);
          final dynamic frData = json.decode(frJsonString);
          List<dynamic> frPlants = [];
          if (frData is Map<String, dynamic>) {
             frPlants = frData['plants'] as List? ?? [];
          } else if (frData is List) {
             frPlants = frData;
          }
          
          for (final item in frPlants) {
             if (item is Map) {
                final pid = item['id']?.toString();
                final pName = item['commonName']?.toString();
                if (pid != null && pName != null) {
                   frenchFallbackMap[pid] = pName;
                }
             }
          }
           developer.log('PlantHiveRepository: Loaded ${frenchFallbackMap.length} fallback names from FR', name: 'PlantHiveRepository');
        } catch (e) {
           print('PlantHiveRepository: Warning - Failed to load FR fallback names: $e');
        }
      }

      String assetPath = _getAssetPath(languageCode);
      String jsonString;

      // 1. Charger le JSON (avec fallback sur FR si échec)
      try {
        jsonString = await rootBundle.loadString(assetPath);
      } catch (e) {
        print('PlantHiveRepository: ⚠️ Echec chargement $assetPath, fallback sur fr');
        assetPath = _getAssetPath('fr');
        jsonString = await rootBundle.loadString(assetPath);
      }

      final dynamic jsonData = json.decode(jsonString);

      List<dynamic> plantsList = [];
      // Handle "plants": [...] wrapper
      if (jsonData is Map<String, dynamic>) {
        plantsList = jsonData['plants'] as List? ?? [];
      } else if (jsonData is List) {
        plantsList = jsonData;
      }

      if (plantsList.isEmpty) {
        print('PlantHiveRepository: JSON vide, skip sync.');
        return;
      }

      // 2. Ouvrir la box
      final box = await _getBox();
      int addedCount = 0;
      int updatedCount = 0;
      int errorCount = 0;

      // 3. Itérer et merger
      for (final dynamic plantJson in plantsList) {
        try {
          if (plantJson is Map<String, dynamic>) {
            // Créer l'objet "candidat" depuis le JSON
            final candidatePlant = _createPlantHiveFromJson(plantJson, frenchFallbackMap);
            final id = candidatePlant.id;

            if (box.containsKey(id)) {
              // EXISTE DÉJÀ : Mise à jour avec préservation de l'état
              final existingPlant = box.get(id);
              if (existingPlant != null) {
                // On garde l'état utilisateur
                candidatePlant.isActive = existingPlant.isActive;
                candidatePlant.createdAt = existingPlant.createdAt;
                // On met à jour updatedAt
                candidatePlant.updatedAt = DateTime.now();
                
                // Sauvegarde
                await box.put(id, candidatePlant);
                updatedCount++;
              }
            } else {
              // NOUVEAU : Insertion directe
              await box.put(id, candidatePlant);
              print('PlantHiveRepository: ✨ Nouvelle plante ajoutée : ${candidatePlant.commonName} ($id)');
              addedCount++;
            }
          }
        } catch (e) {
          print('Error syncing plant: $e');
          errorCount++;
        }
      }

      developer.log(
          'PlantHiveRepository: Sync terminé - +$addedCount, ~$updatedCount, !$errorCount',
          name: 'PlantHiveRepository');
      print(
          'PlantHiveRepository: syncWithJson END - Added: $addedCount, Updated: $updatedCount, Errors: $errorCount');

      _isInitialized = true;
    } catch (e) {
      print('!!! EXCEPTION syncWithJson: $e');
      developer.log('PlantHiveRepository: Erreur sync JSON: $e', level: 1000);
      // On ne throw pas pour ne pas bloquer l'app, juste log
    } finally {
      _isSyncing = false;
    }
  }

  /// Initialise la base de données depuis le fichier JSON des assets
  Future<void> initializeFromJson({bool clearBefore = false}) async {
    // Si on demande un clear, on le fait, puis on utilise le sync pour remplir
    if (clearBefore) {
      await clearAllPlants();
    }
    await syncWithJson();
  }

  /// Vide complétement la box (pour rechargement propre)
  Future<void> clearAllPlants() async {
    try {
      final box = await _getBox();
      await box.clear();
      print('PlantHiveRepository: Box cleared.');
    } catch (e) {
      developer.log('PlantHiveRepository: Erreur lors du vidage de la box: $e', level: 1000);
    }
  }

  /// Ajoute une nouvelle plante au catalogue
  Future<void> addPlant(PlantHive plant) async {
    try {
      final box = await _getBox();
      await box.put(plant.id, plant);
      developer.log(
          'PlantHiveRepository: Plante ajoutée avec succès - ID: ${plant.id}',
          name: 'PlantHiveRepository');
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur lors de l\'ajout de la plante ${plant.id}: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException('Erreur lors de l\'ajout de la plante: $e');
    }
  }

  /// Met à jour une plante existante
  Future<void> updatePlant(PlantHive plant) async {
    try {
      final box = await _getBox();
      if (box.containsKey(plant.id)) {
        plant.updatedAt = DateTime.now();
        await box.put(plant.id, plant);
        developer.log(
            'PlantHiveRepository: Plante mise à jour avec succès - ID: ${plant.id}',
            name: 'PlantHiveRepository');
      } else {
        throw PlantHiveException('Plante non trouvée avec l\'ID: ${plant.id}');
      }
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur lors de la mise à jour de la plante ${plant.id}: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException(
          'Erreur lors de la mise à jour de la plante: $e');
    }
  }

  /// Supprime une plante du catalogue
  Future<void> deletePlant(String plantId) async {
    try {
      final box = await _getBox();
      if (box.containsKey(plantId)) {
        await box.delete(plantId);
        developer.log(
            'PlantHiveRepository: Plante supprimée avec succès - ID: $plantId',
            name: 'PlantHiveRepository');
      } else {
        throw PlantHiveException('Plante non trouvée avec l\'ID: $plantId');
      }
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur lors de la suppression de la plante $plantId: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException(
          'Erreur lors de la suppression de la plante: $e');
    }
  }

  /// Vérifie si une plante existe
  Future<bool> plantExists(String plantId) async {
    try {
      final box = await _getBox();
      return box.containsKey(plantId);
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur lors de la vérification de l\'existence de la plante $plantId: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException(
          'Erreur lors de la vérification de l\'existence de la plante: $e');
    }
  }

  /// Crée un PlantHive depuis un JSON avec conversion flexible
  ///
  /// Tolère les champs manquants en utilisant des valeurs par défaut.
  /// Permet l'ajout libre de nouvelles plantes par simple édition du JSON.
  PlantHive _createPlantHiveFromJson(Map<String, dynamic> json, [Map<String, String>? fallbackImageTerms]) {
    try {
      // Récupérer l'ID d'abord (utilisé pour proposer une image par défaut si besoin)
      final id = _getStringValue(
          json, 'id', 'unknown_${DateTime.now().millisecondsSinceEpoch}');

      // Récupérer / normaliser les métadonnées
      final Map<String, dynamic> meta = _getMapValue(json, 'metadata', {});

      // Injecter le fallback image si disponible (ex: nom FR pour les images nommées en FR)
      if (fallbackImageTerms != null && fallbackImageTerms.containsKey(id)) {
        meta['image_search_term'] = fallbackImageTerms[id];
      }

      // === NORMALISATION LÉGÈRE POUR plants_merged_clean.json ===
      // 1) sowingMonths3 -> sowingMonths (si présent)
      if (json.containsKey('sowingMonths3') && json['sowingMonths3'] is List) {
        try {
          json['sowingMonths'] =
              (json['sowingMonths3'] as List).map((e) => e.toString()).toList();
        } catch (_) {}
      }

      // 2) biologicalControl.companionPlants : string -> List<String>
      if (json['biologicalControl'] is Map) {
        final bc = Map<String, dynamic>.from(json['biologicalControl'] as Map);
        final cp = bc['companionPlants'];
        if (cp is String) {
          final list = cp
              .split(RegExp(r'[;,\n]'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          bc['companionPlants'] = list;
          json['biologicalControl'] = bc;
        } else if (cp is List) {
          bc['companionPlants'] = cp.map((e) => e.toString().trim()).toList();
          json['biologicalControl'] = bc;
        }

      // 2b) Normaliser les températures dans preparations si ce sont des strings ("20 °C" -> 20.0)
        if (bc['preparations'] is List) {
          final preparations = List.from(bc['preparations'] as List);
          for (var i = 0; i < preparations.length; i++) {
            if (preparations[i] is! Map) continue;
            final p = Map<String, dynamic>.from(preparations[i] as Map);
            for (final k in ['temperature', 'temp']) {
              final v = p[k];
              if (v is String) {
                final m = RegExp(r'([-+]?[0-9]*\.?[0-9]+)').firstMatch(v);
                if (m != null) p[k] = double.tryParse(m.group(0)!);
              } else if (v is int || v is double) {
                p[k] = (v as num).toDouble();
              }
            }
            preparations[i] = p;
          }
          bc['preparations'] = preparations;
          json['biologicalControl'] = bc;
        }
      }

      // 3) companionPlanting : s'assurer que beneficial est une liste
      if (json['companionPlanting'] is Map) {
        final cp = Map<String, dynamic>.from(json['companionPlanting'] as Map);
        final ben = cp['beneficial'];
        if (ben is String) {
          final parts = ben
              .split(RegExp(r'[;\n]'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          final List<String> newBen = [];
          final List<String> avoids =
              (cp['avoid'] as List? ?? []).map((e) => e.toString()).toList();
          final List<String> notesList = [];
          for (final item in parts) {
            if (item.toLowerCase().contains('éviter') ||
                item.toLowerCase().contains('eviter')) {
              // extraire les noms après 'éviter'
              final after = item
                  .replaceAll(RegExp(r'(?i)éviter'), '')
                  .replaceAll(RegExp(r'[:,-]'), ' ')
                  .split(RegExp(r'\s+'))
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              avoids.addAll(after);
              notesList.add(item);
            } else {
              newBen.add(item);
            }
          }
          cp['beneficial'] = newBen;
          cp['avoid'] = avoids;
          if (notesList.isNotEmpty)
            cp['notes'] = (cp['notes'] ?? '').toString().trim() +
                (cp['notes'] != null && cp['notes'].toString().isNotEmpty
                    ? '; '
                    : '') +
                notesList.join('; ');
          json['companionPlanting'] = cp;
        }
      }

      // 4) squelette notificationSettings si absent
      if (!json.containsKey('notificationSettings') ||
          json['notificationSettings'] == null) {
        json['notificationSettings'] = {
          'thinning': {},
          'watering': {},
          'harvest': {},
          'general': {}
        };
      }

      // FIN NORMALISATION
      // Si aucune clé d'image n'est présente, proposer automatiquement une image basée sur l'ID.
      final hasImage = meta.containsKey('image') ||
          meta.containsKey('imagePath') ||
          meta.containsKey('photo') ||
          meta.containsKey('image_url') ||
          meta.containsKey('imageUrl');

      if (!hasImage) {
        final candidateBase = id.toLowerCase();
        final defaultImage = '${candidateBase}.jpg';
        meta['image'] = defaultImage;
      }
      
      // Handle list-based seasons (tokenized) -> string for Hive model compatibility
      String normalizeSeason(dynamic val) {
        if (val is List) {
          return val.join(',');
        }
        return val?.toString() ?? 'Toute saison';
      }

      return PlantHive(
        // Champs obligatoires avec valeurs par défaut si manquants
        id: id,
        // Common Name Strategy: Use legacy_dev if commonName is missing (Tokenized has no commonName)
        commonName: _getStringValue(json, 'commonName', 
             _getStringValue(json, 'commonName_legacy_dev', 'Nom valide requis')),
        scientificName:
            _getStringValue(json, 'scientificName', 'Espèce inconnue'),
        family: _getStringValue(json, 'family', 'Famille inconnue'),
        
        // Seasons: Tokenized JSON uses Lists, Model uses String. Join them.
        plantingSeason: normalizeSeason(json['plantingSeason']),
        harvestSeason: normalizeSeason(json['harvestSeason']),
        
        daysToMaturity: _getIntValue(json, 'daysToMaturity', 90),
        spacing: _getIntValue(json, 'spacing', 30),
        depth: _getDoubleValue(json, 'depth', 1.0),
        sunExposure: _getStringValue(json, 'sunExposure', 'Plein soleil'),
        waterNeeds: _getStringValue(json, 'waterNeeds', 'Moyen'),
        description:
            _getStringValue(json, 'description', ''), // Empty by default, filled by i18n
        sowingMonths:
            _getStringListValue(json, 'sowingMonths', ['M', 'A', 'M']),
        harvestMonths:
            _getStringListValue(json, 'harvestMonths', ['J', 'J', 'A']),
        // Champs optionnels
        marketPricePerKg: _getOptionalDoubleValue(json, 'marketPricePerKg'),
        defaultUnit: _getOptionalStringValue(json, 'defaultUnit'),
        nutritionPer100g: _getOptionalMapValue(json, 'nutritionPer100g'),
        germination: _getOptionalMapValue(json, 'germination'),
        growth: _getOptionalMapValue(json, 'growth'),
        watering: _getOptionalMapValue(json, 'watering'),
        thinning: _getOptionalMapValue(json, 'thinning'),
        weeding: _getOptionalMapValue(json, 'weeding'),
        culturalTips: _getOptionalStringListValue(json, 'culturalTips'),
        biologicalControl: _getOptionalMapValue(json, 'biologicalControl'),
        harvestTime: _getOptionalStringValue(json, 'harvestTime'),
        companionPlanting: _getOptionalMapValue(json, 'companionPlanting'),
        notificationSettings:
            _getOptionalMapValue(json, 'notificationSettings'),
        varieties: _getOptionalMapValue(json, 'varieties'),
        metadata: meta,
        // Métadonnées temporelles
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );
    } catch (e) {
      throw PlantHiveException(
          'Erreur lors de la Création de PlantHive depuis JSON: $e');
    }
  }

  /// Convertit PlantHive vers PlantFreezed
  PlantFreezed _fromHiveModel(PlantHive hiveModel) {
    return PlantFreezed(
      id: hiveModel.id,
      commonName: hiveModel.commonName,
      scientificName: hiveModel.scientificName,
      family: hiveModel.family,
      plantingSeason: hiveModel.plantingSeason,
      harvestSeason: hiveModel.harvestSeason,
      daysToMaturity: hiveModel.daysToMaturity,
      spacing: hiveModel.spacing,
      depth: hiveModel.depth,
      sunExposure: hiveModel.sunExposure,
      waterNeeds: hiveModel.waterNeeds,
      description: hiveModel.description,
      sowingMonths: hiveModel.sowingMonths,
      harvestMonths: hiveModel.harvestMonths,
      marketPricePerKg: hiveModel.marketPricePerKg,
      defaultUnit: hiveModel.defaultUnit,
      nutritionPer100g: _castMap(hiveModel.nutritionPer100g),
      germination: _castMap(hiveModel.germination),
      growth: _castMap(hiveModel.growth),
      watering: _castMap(hiveModel.watering),
      thinning: _castMap(hiveModel.thinning),
      weeding: _castMap(hiveModel.weeding),
      culturalTips: hiveModel.culturalTips,
      biologicalControl: _castMap(hiveModel.biologicalControl),
      harvestTime: hiveModel.harvestTime,
      companionPlanting: _castMap(hiveModel.companionPlanting),
      notificationSettings: _castMap(hiveModel.notificationSettings),
      varieties: _castMap(hiveModel.varieties),
      metadata: _castMap(hiveModel.metadata) ?? {},
      createdAt: hiveModel.createdAt,
      updatedAt: hiveModel.updatedAt,
      isActive: hiveModel.isActive,
    );
  }

  /// Helper safe cast Hive Map<dynamic, dynamic> to Map<String, dynamic>
  /// Helper safe cast Hive Map<dynamic, dynamic> to Map<String, dynamic>
  Map<String, dynamic> _castMap(Map? map) {
    if (map == null) return {};
    return Map<String, dynamic>.from(map);
  }

  // === MÉTHODES UTILITAIRES POUR LA CONVERSION FLEXIBLE ===

  /// Récupère une valeur String avec fallback
  String _getStringValue(
      Map<String, dynamic> json, String key, String defaultValue) {
    try {
      final value = json[key];
      return value?.toString() ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Récupère une valeur String optionnelle
  String? _getOptionalStringValue(Map<String, dynamic> json, String key) {
    try {
      final value = json[key];
      return value?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Récupère une valeur int avec fallback
  int _getIntValue(Map<String, dynamic> json, String key, int defaultValue) {
    try {
      final value = json[key];
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Récupère une valeur double avec fallback
  double _getDoubleValue(
      Map<String, dynamic> json, String key, double defaultValue) {
    try {
      final value = json[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Récupère une valeur double optionnelle
  double? _getOptionalDoubleValue(Map<String, dynamic> json, String key) {
    try {
      final value = json[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Récupère une liste de String avec fallback
  /// Helper method to safely extract string lists
  /// Handles null, List, and String (CSV) inputs. Returns [] on failure.
  List<String> _getStringListValue(
      Map<String, dynamic> json, String key, List<String> defaultValue) {
    return _getOptionalStringListValue(json, key) ?? defaultValue;
  }

  /// Récupère une liste de String optionnelle (mais sûre -> [])
  List<String> _getOptionalStringListValue(
      Map<String, dynamic> json, String key) {
    try {
      final value = json[key];
      if (value == null) return <String>[];
      
      if (value is List) {
        return value
            .map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
      }
      if (value is String) {
        // Séparer sur ; , \n ou virgule
        return value
            .split(RegExp(r'[;,\n]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return <String>[];
    } catch (e) {
      return <String>[];
    }
  }

  /// Récupère une Map avec fallback
  Map<String, dynamic> _getMapValue(Map<String, dynamic> json, String key,
      Map<String, dynamic> defaultValue) {
    try {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Récupère une Map optionnelle
  /// Récupère une Map optionnelle (mais sûre -> {})
  Map<String, dynamic> _getOptionalMapValue(
      Map<String, dynamic> json, String key) {
    try {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
      // Also handle if it's a Map but not <String, dynamic> explicitly
      if (value is Map) return Map<String, dynamic>.from(value);
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Indique si le repository a été initialisé depuis JSON
  bool get isInitialized => _isInitialized;

  /// Ferme la box Hive (pour les tests ou la maintenance)
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
      _box = null;
      developer.log('PlantHiveRepository: Box fermée',
          name: 'PlantHiveRepository');
    }
  }
}
