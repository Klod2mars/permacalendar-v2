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
  static const String _jsonAssetPath = 'assets/data/plants.json';

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

  /// Initialise la base de données depuis le fichier JSON des assets
  Future<void> initializeFromJson() async {
    try {
      developer.log('PlantHiveRepository: Début du chargement depuis JSON',
          name: 'PlantHiveRepository');
      // Visible debug print to ensure startup is logged
      print('PlantHiveRepository: initializeFromJson START');

      // Chargement du fichier JSON depuis les assets
      final String jsonString = await rootBundle.loadString(_jsonAssetPath);
      final dynamic jsonData = json.decode(jsonString);

      // Détection automatique du format
      List<dynamic> plantsList;
      String detectedFormat;
      Map<String, dynamic>? metadata;

      if (jsonData is List) {
        // Format Legacy (array-only)
        plantsList = jsonData;
        detectedFormat = 'Legacy (array-only)';
        developer.log(
            'PlantHiveRepository: Format détecté : Legacy (array-only)',
            name: 'PlantHiveRepository');
      } else if (jsonData is Map<String, dynamic>) {
        // Format v2.1.0+ (structured avec schema_version)
        final schemaVersion = jsonData['schema_version'] as String?;

        if (schemaVersion == null) {
          throw const PlantHiveException(
              'Format JSON invalide : Object sans schema_version (attendu: array ou object avec schema_version)');
        }

        detectedFormat = 'v$schemaVersion (structured)';
        metadata = jsonData['metadata'] as Map<String, dynamic>?;

        developer.log('PlantHiveRepository: Format détecté : v$schemaVersion',
            name: 'PlantHiveRepository');

        if (metadata != null) {
          final version = metadata['version'];
          final totalPlants = metadata['total_plants'];
          final source = metadata['source'];
          final updatedAt = metadata['updated_at'];

          developer.log(
              'PlantHiveRepository: Métadonnées - version: $version, plantes: $totalPlants, source: $source, màj: $updatedAt',
              name: 'PlantHiveRepository');
        }

        plantsList = jsonData['plants'] as List? ?? [];

        if (plantsList.isEmpty) {
          developer.log(
              'PlantHiveRepository: Aucune plante dans le fichier JSON',
              name: 'PlantHiveRepository',
              level: 900);
        }
      } else {
        throw PlantHiveException(
            'Format JSON invalide : Attendu List ou Map, reçu ${jsonData.runtimeType}');
      }

      // ==================== TRAITEMENT DES PLANTES ====================
      final box = await _getBox();
      int successCount = 0;
      int errorCount = 0;

      // Traitement de chaque plante avec tolérance aux erreurs
      for (final dynamic plantJson in plantsList) {
        try {
          if (plantJson is Map<String, dynamic>) {
            final plantHive = _createPlantHiveFromJson(plantJson);
            await box.put(plantHive.id, plantHive);
            successCount++;
          } else {
            developer.log(
                'PlantHiveRepository: Format JSON invalide pour une plante',
                name: 'PlantHiveRepository',
                level: 900);
            errorCount++;
          }
        } catch (e) {
          final plantId = plantJson is Map<String, dynamic>
              ? plantJson['id'] ?? 'unknown'
              : 'unknown';
          // FORCE LOGGING FOR DEBUG: ensure visibility in flutter logs / adb logcat
          print('!!! CRITICAL ERROR LOADING PLANT $plantId: $e');
          developer.log(
              'PlantHiveRepository: Erreur lors du traitement de la plante $plantId: $e',
              name: 'PlantHiveRepository',
              level: 900);
          errorCount++;
        }
      }

      developer.log(
          'PlantHiveRepository: Chargement terminé [$detectedFormat] - $successCount succès, $errorCount erreurs',
          name: 'PlantHiveRepository');
      print(
          'PlantHiveRepository: initializeFromJson END - successCount=$successCount, errorCount=$errorCount, detectedFormat=$detectedFormat');

      _isInitialized = true;
    } catch (e) {
      developer.log(
          'PlantHiveRepository: Erreur critique lors du chargement JSON: $e',
          name: 'PlantHiveRepository',
          level: 1000);
      throw PlantHiveException(
          'Impossible de charger les plantes depuis JSON: $e');
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
  PlantHive _createPlantHiveFromJson(Map<String, dynamic> json) {
    try {
      // Récupérer l'ID d'abord (utilisé pour proposer une image par défaut si besoin)
      final id = _getStringValue(
          json, 'id', 'unknown_${DateTime.now().millisecondsSinceEpoch}');

      // Récupérer / normaliser les métadonnées
      final Map<String, dynamic> meta = _getMapValue(json, 'metadata', {});

      // === NORMALISATION LÉGÈRE POUR plants_merged_clean.json ===
      // 1) sowingMonths3 -> sowingMonths (si présent)
      if (json.containsKey('sowingMonths3') && json['sowingMonths3'] is List) {
        try {
          json['sowingMonths'] = (json['sowingMonths3'] as List)
              .map((e) => e.toString())
              .toList();
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

      // 3) companionPlanting : s'assurer que beneficial est une liste,
      //    déplacer les phrases 'éviter...' vers avoid et notes
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
      // L'écran acceptera "tomato.jpg" et préfixera "assets/images/legumes/" si nécessaire.
      final hasImage = meta.containsKey('image') ||
          meta.containsKey('imagePath') ||
          meta.containsKey('photo') ||
          meta.containsKey('image_url') ||
          meta.containsKey('imageUrl');

      if (!hasImage) {
        final candidateBase = id.toLowerCase();
        // Choix par défaut : JPG (peut être adapté)
        final defaultImage = '${candidateBase}.jpg';
        meta['image'] = defaultImage;
        developer.log(
            'PlantHiveRepository: metadata.image auto-set for $id -> $defaultImage',
            name: 'PlantHiveRepository',
            level: 800);
      }

      return PlantHive(
        // Champs obligatoires avec valeurs par défaut si manquants
        id: id,
        commonName: _getStringValue(json, 'commonName', 'Nom inconnu'),
        scientificName:
            _getStringValue(json, 'scientificName', 'Espèce inconnue'),
        family: _getStringValue(json, 'family', 'Famille inconnue'),
        plantingSeason: _getStringValue(json, 'plantingSeason', 'Toute saison'),
        harvestSeason: _getStringValue(json, 'harvestSeason', 'Variable'),
        daysToMaturity: _getIntValue(json, 'daysToMaturity', 90),
        spacing: _getIntValue(json, 'spacing', 30),
        depth: _getDoubleValue(json, 'depth', 1.0),
        sunExposure: _getStringValue(json, 'sunExposure', 'Plein soleil'),
        waterNeeds: _getStringValue(json, 'waterNeeds', 'Moyen'),
        description:
            _getStringValue(json, 'description', 'Description non disponible'),
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
      nutritionPer100g: hiveModel.nutritionPer100g,
      germination: hiveModel.germination,
      growth: hiveModel.growth,
      watering: hiveModel.watering,
      thinning: hiveModel.thinning,
      weeding: hiveModel.weeding,
      culturalTips: hiveModel.culturalTips,
      biologicalControl: hiveModel.biologicalControl,
      harvestTime: hiveModel.harvestTime,
      companionPlanting: hiveModel.companionPlanting,
      notificationSettings: hiveModel.notificationSettings,
      varieties: hiveModel.varieties,
      metadata: hiveModel.metadata ?? {},
      createdAt: hiveModel.createdAt,
      updatedAt: hiveModel.updatedAt,
      isActive: hiveModel.isActive,
    );
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
  List<String> _getStringListValue(
      Map<String, dynamic> json, String key, List<String> defaultValue) {
    try {
      final value = json[key];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Récupère une liste de String optionnelle
  List<String>? _getOptionalStringListValue(
      Map<String, dynamic> json, String key) {
    try {
      final value = json[key];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return null;
    } catch (e) {
      return null;
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
  Map<String, dynamic>? _getOptionalMapValue(
      Map<String, dynamic> json, String key) {
    try {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
      return null;
    } catch (e) {
      return null;
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
