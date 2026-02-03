import 'dart:developer' as developer;
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/garden_hive.dart';
import '../models/garden_bed_hive.dart';
import '../models/garden_freezed.dart';
import '../services/environment_service.dart';

/// Repository pour la gestion des jardins avec Hive
/// Implémente les opérations CRUD avec validation métier
class GardenHiveRepository {
  static const String _boxName = 'gardens_hive';
  static Box<GardenHive>? _box;

  /// Getter pour la box Hive
  static Box<GardenHive> get _gardenBox {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Garden Hive box n\'est pas initialisée');
    }
    return _box!;
  }

  /// Initialise la box Hive
  static Future<void> initialize() async {
    try {
      _box = await _openBoxWithRetry<GardenHive>(_boxName);
      print('[GardenHiveRepository] Box initialisée avec succès');
    } catch (e) {
      print('[GardenHiveRepository] Erreur lors de l\'initialisation: $e');
      rethrow;
    }
  }

  /// Tente d'ouvrir une box. En cas d'erreur de lock, supprime le fichier .lock et réessaie.
  static Future<Box<T>> _openBoxWithRetry<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      if (e.toString().toLowerCase().contains('lock')) {
         print('[GardenHiveRepository] Lock détecté sur $boxName. Tentative de suppression du lock...');
         try {
           final appDir = await getApplicationDocumentsDirectory();
           final lockFile = File(p.join(appDir.path, '$boxName.lock'));
           if (await lockFile.exists()) {
             await lockFile.delete();
             print('[GardenHiveRepository] Lock supprimé. Nouvelle tentative ouverture...');
             return await Hive.openBox<T>(boxName);
           }
         } catch (recoveryError) {
           print('[GardenHiveRepository] Echec récupération lock: $recoveryError');
         }
      }
      rethrow;
    }
  }

  /// Ferme la box Hive
  static Future<void> close() async {
    await _box?.close();
    _box = null;
  }

  /// Récupère tous les jardins
  /// Retourne une liste de GardenFreezed
  Future<List<GardenFreezed>> getAllGardens() async {
    try {
      final gardens = <GardenFreezed>[];
      for (final key in _gardenBox.keys) {
        final hiveGarden = _gardenBox.get(key);
        if (hiveGarden != null) {
          gardens.add(_convertToGardenFreezed(hiveGarden));
        }
      }
      return gardens;
    } catch (e) {
      throw GardenHiveException(
          'Erreur lors de la récupération des jardins: $e');
    }
  }

  /// Crée un nouveau jardin avec validation de la limite
  /// Retourne true si la Création réussit
  Future<bool> createGarden(GardenFreezed garden) async {
    try {
      // Validation des données du jardin
      if (!garden.isValid) {
        throw GardenHiveException('Données du jardin invalides');
      }

      // Vérification de la limite de jardins
      final existingGardens = await getAllGardens();
      if (existingGardens.length >= EnvironmentService.maxGardensPerUser) {
        throw GardenHiveException(
            'Impossible de Créer un nouveau jardin. Limite de ${EnvironmentService.maxGardensPerUser} jardins atteinte.');
      }

      // Conversion vers GardenHive
      final hiveGarden = _convertToGardenHive(garden);

      // Sauvegarde dans Hive
      await _gardenBox.put(hiveGarden.id, hiveGarden);

      return true;
    } catch (e) {
      print('[GardenHiveRepository] Erreur lors de la Création: $e');
      if (e is GardenHiveException) {
        rethrow;
      }
      throw GardenHiveException('Erreur lors de la Création du jardin: $e');
    }
  }

  /// Met à jour un jardin existant
  /// Retourne true si la mise à jour réussit
  Future<bool> updateGarden(GardenFreezed garden) async {
    try {
      // Validation des données du jardin
      if (!garden.isValid) {
        throw GardenHiveException('Données du jardin invalides');
      }

      // Vérification que le jardin existe
      final existingHiveGarden = _gardenBox.get(garden.id);
      if (existingHiveGarden == null) {
        throw GardenHiveException('Jardin avec ID ${garden.id} non trouvé');
      }

      // Marquer comme mis à jour
      final updatedGarden = garden.markAsUpdated();

      // Mise à jour NON-DESTRUCTIVE
      // On conserve les gardenBeds existants en utilisant copyWith sur l'objet Hive existant
      // au lieu de recréer un objet vierge.
      final hiveGarden = existingHiveGarden.copyWith(
        name: updatedGarden.name,
        description: updatedGarden.description ?? '',
        // Pas de mise à jour de createdDate
      );

      // Sauvegarde dans Hive
      // Note: Comme c'est un HiveObject, on pourrait aussi faire hiveGarden.save() 
      // si on modifiait les champs en place, mais put() est explicite.
      await _gardenBox.put(hiveGarden.id, hiveGarden);

      return true;
    } catch (e) {
      print('[GardenHiveRepository] Erreur lors de la mise à jour: $e');
      if (e is GardenHiveException) {
        rethrow;
      }
      throw GardenHiveException('Erreur lors de la mise à jour du jardin: $e');
    }
  }

  /// Supprime un jardin par son ID
  /// Retourne true si la suppression réussit
  Future<bool> deleteGarden(String id) async {
    try {
      // Vérification que le jardin existe
      if (!_gardenBox.containsKey(id)) {
        // CHANGED: Throw explicit GardenNotFoundException
        throw GardenNotFoundException('Jardin avec ID $id non trouvé');
      }

      // Suppression du jardin
      await _gardenBox.delete(id);

      return true;
    } catch (e) {
      print('[GardenHiveRepository] Erreur lors de la suppression: $e');
      // CHANGED: Rethrow GardenNotFoundException
      if (e is GardenNotFoundException) {
        rethrow;
      }
      if (e is GardenHiveException) {
        rethrow;
      }
      throw GardenHiveException('Erreur lors de la suppression du jardin: $e');
    }
  }

  /// Récupère un jardin par son ID
  /// Retourne null si le jardin n'existe pas
  Future<GardenFreezed?> getGardenById(String id) async {
    try {
      final hiveGarden = _gardenBox.get(id);
      if (hiveGarden == null) {
        return null;
      }
      return _convertToGardenFreezed(hiveGarden);
    } catch (e) {
      throw GardenHiveException(
          'Erreur lors de la récupération du jardin $id: $e');
    }
  }

  /// Vide tous les jardins (utile pour les tests)
  Future<void> clearAllGardens() async {
    try {
      await _gardenBox.clear();
    } catch (e) {
      throw GardenHiveException(
          'Erreur lors de la suppression de tous les jardins: $e');
    }
  }

  /// Conversion GardenHive -> GardenFreezed
  GardenFreezed _convertToGardenFreezed(GardenHive hiveGarden) {
    // Calculer la surface totale à partir des parcelles
    final totalArea = hiveGarden.gardenBeds
        .fold<double>(0.0, (sum, bed) => sum + bed.sizeInSquareMeters);

    return GardenFreezed(
      id: hiveGarden.id,
      name: hiveGarden.name,
      description: hiveGarden.description,
      totalAreaInSquareMeters: totalArea > 0
          ? totalArea
          : 10.0, // Surface par défaut si aucune parcelle
      location: 'Jardin ${hiveGarden.name}', // Location générée
      createdAt: hiveGarden.createdDate,
      updatedAt: hiveGarden.createdDate, // Utilise createdDate comme updatedAt
      metadata: {
        'gardenBedsCount': hiveGarden.gardenBeds.length,
        'lastSync': DateTime.now().toIso8601String(),
      },
      isActive: true,
    );
  }

  /// Conversion GardenFreezed -> GardenHive
  /// ✅ CORRECTION COMPLÈTE DU BUG DE PERSISTANCE FANTÔME
  /// Garantit l'isolation stricte entre jardins et l'initialisation propre
  GardenHive _convertToGardenHive(GardenFreezed freezedGarden) {
    // ✅ CORRECTION MAJEURE: Toujours Créer un jardin avec des parcelles vides
    // Aucune récupération de données existantes pour éviter la contamination
    final List<GardenBedHive> cleanGardenBeds = <GardenBedHive>[];

    return GardenHive(
      id: freezedGarden.id,
      name: freezedGarden.name,
      description: freezedGarden.description ?? '',
      createdDate: freezedGarden.createdAt,
      gardenBeds: cleanGardenBeds,
    );
  }
}

/// Exception personnalisée pour les erreurs du repository Hive
class GardenHiveException implements Exception {
  final String message;

  GardenHiveException(this.message);

  @override
  String toString() => 'GardenHiveException: $message';
}

/// Exception spécifique pour signaler qu'un jardin n'existe pas
class GardenNotFoundException implements Exception {
  final String message;
  GardenNotFoundException([this.message = 'Garden not found']);
  @override
  String toString() => 'GardenNotFoundException: $message';
}
