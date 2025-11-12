import 'package:hive_flutter/hive_flutter.dart';
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
      _box = await Hive.openBox<GardenHive>(_boxName);
      print('[GardenHiveRepository] Box initialisée avec succès');
    } catch (e) {
      print('[GardenHiveRepository] Erreur lors de l\'initialisation: $e');
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
      final hiveGardens = _gardenBox.values.toList();
      return hiveGardens
          .map((hiveGarden) => _convertToGardenFreezed(hiveGarden))
          .toList();
    } catch (e) {
      throw GardenHiveException(
          'Erreur lors de la récupération des jardins: $e');
    }
  }

  /// Crée un nouveau jardin avec validation de la limite
  /// Retourne true si la création réussit
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
            'Impossible de créer un nouveau jardin. Limite de ${EnvironmentService.maxGardensPerUser} jardins atteinte.');
      }

      // Conversion vers GardenHive
      final hiveGarden = _convertToGardenHive(garden);

      // Sauvegarde dans Hive
      await _gardenBox.put(hiveGarden.id, hiveGarden);

      return true;
    } catch (e) {
      print('[GardenHiveRepository] Erreur lors de la création: $e');
      if (e is GardenHiveException) {
        rethrow;
      }
      throw GardenHiveException('Erreur lors de la création du jardin: $e');
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
      if (!_gardenBox.containsKey(garden.id)) {
        throw GardenHiveException('Jardin avec ID ${garden.id} non trouvé');
      }

      // Marquer comme mis à jour
      final updatedGarden = garden.markAsUpdated();

      // Conversion vers GardenHive
      final hiveGarden = _convertToGardenHive(updatedGarden);

      // Sauvegarde dans Hive
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
        throw GardenHiveException('Jardin avec ID $id non trouvé');
      }

      // Suppression du jardin
      await _gardenBox.delete(id);

      return true;
    } catch (e) {
      print('[GardenHiveRepository] Erreur lors de la suppression: $e');
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

  /// Conversion GardenHive → GardenFreezed
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

  /// Conversion GardenFreezed → GardenHive
  /// ✅ CORRECTION COMPLÈTE DU BUG DE PERSISTANCE FANTÔME
  /// Garantit l'isolation stricte entre jardins et l'initialisation propre
  GardenHive _convertToGardenHive(GardenFreezed freezedGarden) {
    // ✅ CORRECTION MAJEURE: Toujours créer un jardin avec des parcelles vides
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


