import '../data/hive/garden_boxes.dart';
import '../models/garden.dart';
import '../services/environment_service.dart';
import 'garden_rules.dart';

/// Repository pour la gestion des jardins avec validation stricte
/// Implémente le pattern Repository pour abstraire l'accès aux données Hive
class GardenRepository {
  final GardenRules _gardenRules = GardenRules();

  /// Récupère tous les jardins
  /// Retourne une liste de tous les jardins stockés
  List<Garden> getGardens() {
    try {
      return GardenBoxes.getAllGardens();
    } catch (e) {
      throw GardenValidationException(
          'Erreur lors de la récupération des jardins: $e');
    }
  }

  /// Récupère un jardin par son ID
  /// Retourne null si le jardin n'existe pas
  Garden? getGardenById(String id) {
    try {
      return GardenBoxes.getGarden(id);
    } catch (e) {
      throw GardenNotFoundException(
          'Erreur lors de la récupération du jardin $id: $e');
    }
  }

  /// Crée un nouveau jardin avec validation de la limite
  /// Retourne true si la création réussit, false sinon
  Future<bool> createGarden(Garden garden) async {
    try {
      // Validation des données du jardin
      if (!garden.isValid) {
        throw const GardenValidationException('Données du jardin invalides');
      }

      // Récupération des jardins existants
      final existingGardens = getGardens();

      // Validation de la limite de jardins
      final canCreateResult = _gardenRules.canCreateNewGarden(existingGardens);
      if (!canCreateResult) {
        throw GardenLimitException(
            'Impossible de créer un nouveau jardin. Limite de ${EnvironmentService.maxGardensPerUser} jardins atteinte.');
      }

      // Validation du nombre de jardins
      final countValidation =
          _gardenRules.validateGardenCount(existingGardens, isAdding: true);
      if (!countValidation.isValid) {
        throw GardenValidationException(countValidation.errorMessage!);
      }

      // Vérification que l'ID n'existe pas déjà
      if (getGardenById(garden.id) != null) {
        throw const GardenValidationException(
            'Un jardin avec cet ID existe déjà');
      }

      // Sauvegarde du jardin
      await GardenBoxes.saveGarden(garden);
      return true;
    } on GardenRepositoryException {
      rethrow;
    } catch (e) {
      throw GardenValidationException(
          'Erreur lors de la création du jardin: $e');
    }
  }

  /// Met à jour un jardin existant
  /// Retourne true si la mise à jour réussit, false sinon
  Future<bool> updateGarden(Garden garden) async {
    try {
      // Validation des données du jardin
      if (!garden.isValid) {
        throw const GardenValidationException('Données du jardin invalides');
      }

      // Vérification que le jardin existe
      final existingGarden = getGardenById(garden.id);
      if (existingGarden == null) {
        throw GardenNotFoundException('Jardin avec ID ${garden.id} non trouvé');
      }

      // Mise à jour du timestamp
      final updatedGarden = garden.copyWith();
      updatedGarden.markAsUpdated();

      // Sauvegarde des modifications
      await GardenBoxes.saveGarden(updatedGarden);
      return true;
    } on GardenRepositoryException {
      rethrow;
    } catch (e) {
      throw GardenValidationException('Erreur lors de la mise à jour: $e');
    }
  }

  /// Supprime un jardin par son ID
  /// Retourne true si la suppression réussit, false sinon
  Future<bool> deleteGarden(String id) async {
    try {
      // Vérification que le jardin existe
      final existingGarden = getGardenById(id);
      if (existingGarden == null) {
        throw GardenNotFoundException('Jardin avec ID $id non trouvé');
      }

      // Récupération des jardins restants après suppression
      final remainingGardens = getGardens().where((g) => g.id != id).toList();

      // Validation du nombre minimum de jardins
      if (remainingGardens.length < EnvironmentService.minGardensPerUser) {
        throw GardenValidationException(
            'Impossible de supprimer ce jardin. Minimum ${EnvironmentService.minGardensPerUser} jardin(s) requis.');
      }

      // Suppression du jardin (et des données associées via GardenBoxes)
      await GardenBoxes.deleteGarden(id);
      return true;
    } on GardenRepositoryException {
      rethrow;
    } catch (e) {
      throw GardenValidationException(
          'Erreur lors de la suppression du jardin: $e');
    }
  }

  /// Récupère les jardins actifs uniquement
  List<Garden> getActiveGardens() {
    return getGardens().where((garden) => garden.isActive).toList();
  }

  /// Compte le nombre total de jardins
  int getGardenCount() {
    return getGardens().length;
  }

  /// Compte le nombre de jardins actifs
  int getActiveGardenCount() {
    return getActiveGardens().length;
  }

  /// Vérifie si un utilisateur peut créer un nouveau jardin
  bool canCreateNewGarden() {
    final existingGardens = getGardens();
    return _gardenRules.canCreateNewGarden(existingGardens);
  }

  /// Recherche des jardins par nom ou description
  List<Garden> searchGardens(String query) {
    if (query.trim().isEmpty) return getGardens();

    final lowercaseQuery = query.toLowerCase().trim();
    return getGardens().where((garden) {
      return garden.name.toLowerCase().contains(lowercaseQuery) ||
          garden.description.toLowerCase().contains(lowercaseQuery) ||
          garden.location.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}

/// Exceptions spécifiques au repository des jardins
abstract class GardenRepositoryException implements Exception {
  final String message;
  final GardenRepositoryErrorType errorType;
  const GardenRepositoryException(this.message, this.errorType);

  @override
  String toString() => 'GardenRepositoryException: $message';
}

enum GardenRepositoryErrorType { notFound, validation, limit, general }

class GardenValidationException extends GardenRepositoryException {
  const GardenValidationException(String message)
      : super(message, GardenRepositoryErrorType.validation);
}

class GardenNotFoundException extends GardenRepositoryException {
  const GardenNotFoundException(String message)
      : super(message, GardenRepositoryErrorType.notFound);
}

class GardenLimitException extends GardenRepositoryException {
  const GardenLimitException(String message)
      : super(message, GardenRepositoryErrorType.limit);
}

