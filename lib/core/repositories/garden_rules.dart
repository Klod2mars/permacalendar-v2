import '../models/garden.dart';
import '../services/environment_service.dart';
import '../utils/constants.dart';

/// Classe contenant la logique métier pour la validation des jardins
/// Gère les règles de validation pour la limite de 1-5 jardins par utilisateur
class GardenRules {
  /// Vérifie si un utilisateur peut Créer un nouveau jardin
  /// Prend en compte la limite maximale de jardins par utilisateur
  bool canCreateNewGarden(List<Garden> existingGardens) {
    final activeGardens =
        existingGardens.where((garden) => garden.isActive).toList();
    final maxGardens = EnvironmentService.maxGardensPerUser;

    return activeGardens.length < maxGardens;
  }

  /// Valide le nombre de jardins avec un résultat détaillé
  /// Retourne un ValidationResult avec le statut et le message d'erreur éventuel
  ValidationResult validateGardenCount(List<Garden> gardens,
      {bool isAdding = false}) {
    final activeGardens = gardens.where((garden) => garden.isActive).toList();
    final currentCount = activeGardens.length;
    final minGardens = EnvironmentService.minGardensPerUser;
    final maxGardens = EnvironmentService.maxGardensPerUser;

    // Validation du nombre minimum
    if (currentCount < minGardens && !isAdding) {
      return ValidationResult.invalid(
          'Vous devez avoir au moins $minGardens jardin(s). Actuellement: $currentCount');
    }

    // Validation du nombre maximum lors de l'ajout
    if (isAdding && currentCount >= maxGardens) {
      return ValidationResult.invalid(
          'Vous ne pouvez pas avoir plus de $maxGardens jardins. Actuellement: $currentCount');
    }

    // Validation du nombre maximum en général
    if (currentCount > maxGardens) {
      return ValidationResult.invalid(
          'Nombre de jardins dépassé ($currentCount/$maxGardens). Veuillez supprimer ${currentCount - maxGardens} jardin(s).');
    }

    return ValidationResult.valid();
  }

  /// Valide le nombre de parcelles dans un jardin
  ValidationResult validateGardenBedCount(int currentCount) {
    if (currentCount >= EnvironmentService.maxBedsPerGarden) {
      return ValidationResult.invalid('limit_beds_reached_message');
    }
    return ValidationResult.valid();
  }

  /// Valide le nombre de plantations sur une parcelle
  ValidationResult validatePlantingCount(int currentCount) {
    if (currentCount >= EnvironmentService.maxPlantingsPerBed) {
      return ValidationResult.invalid('limit_plantings_reached_message');
    }
    return ValidationResult.valid();
  }

  /// Valide qu'un jardin peut être supprimé sans violer la limite minimale
  ValidationResult validateGardenDeletion(
      List<Garden> gardens, String gardenIdToDelete) {
    final activeGardens = gardens
        .where((garden) => garden.isActive && garden.id != gardenIdToDelete)
        .toList();
    final remainingCount = activeGardens.length;
    final minGardens = EnvironmentService.minGardensPerUser;

    if (remainingCount < minGardens) {
      return ValidationResult.invalid(
          'Impossible de supprimer ce jardin. Minimum $minGardens jardin(s) requis. Jardins restants: $remainingCount');
    }

    return ValidationResult.valid();
  }

  /// Valide les données d'un jardin selon les règles métier
  ValidationResult validateGardenData(Garden garden) {
    final errors = <String>[];

    // Validation du nom
    if (garden.name.trim().isEmpty) {
      errors.add('Le nom du jardin est requis');
    } else if (garden.name.length < 2) {
      errors.add('Le nom du jardin doit contenir au moins 2 caractères');
    } else if (garden.name.length > AppConstants.maxNameLength) {
      errors.add(
          'Le nom du jardin ne peut pas dépasser ${AppConstants.maxNameLength} caractères');
    }

    // Validation de la description
    if (garden.description.length > AppConstants.maxDescriptionLength) {
      errors.add(
          'La description ne peut pas dépasser ${AppConstants.maxDescriptionLength} caractères');
    }

    // Validation de la superficie
    if (garden.totalAreaInSquareMeters <= 0) {
      errors.add('La superficie doit être positive');
    } else if (garden.totalAreaInSquareMeters > 10000) {
      errors.add('La superficie ne peut pas dépasser 10 000 mÂ²');
    }

    // Validation de la localisation
    if (garden.location.trim().isEmpty) {
      errors.add('La localisation est requise');
    } else if (garden.location.length > AppConstants.maxNameLength) {
      errors.add(
          'La localisation ne peut pas dépasser ${AppConstants.maxNameLength} caractères');
    }

    // Validation des dates
    if (garden.createdAt.isAfter(DateTime.now())) {
      errors.add('La date de Création ne peut pas être dans le futur');
    }

    if (garden.updatedAt.isBefore(garden.createdAt)) {
      errors.add(
          'La date de mise à jour ne peut pas être antérieure à la date de Création');
    }

    if (errors.isEmpty) {
      return ValidationResult.valid();
    } else {
      return ValidationResult.invalid(errors.join(', '));
    }
  }

  /// Valide l'unicité du nom d'un jardin
  static ValidationResult validateGardenNameUniqueness(
      String name, List<Garden> existingGardens,
      [String? excludeId]) {
    final duplicateGarden = existingGardens.where((garden) {
      return garden.id != excludeId &&
          garden.name.toLowerCase() == name.toLowerCase();
    }).firstOrNull;

    if (duplicateGarden != null) {
      return ValidationResult.invalid(
          'Un jardin avec le nom "$name" existe déjà');
    }

    return ValidationResult.valid();
  }

  /// Valide les métadonnées d'un jardin
  static ValidationResult validateGardenMetadata(
      Map<String, dynamic>? metadata) {
    if (metadata == null || metadata.isEmpty) {
      return ValidationResult.valid();
    }

    // Vérifier que les clés et valeurs ne sont pas trop longues
    for (final entry in metadata.entries) {
      if (entry.key.length > 50) {
        return ValidationResult.invalid(
            'La clé de métadonnée "${entry.key}" est trop longue (max 50 caractères)');
      }

      if (entry.value.toString().length > 500) {
        return ValidationResult.invalid(
            'La valeur de métadonnée pour "${entry.key}" est trop longue (max 500 caractères)');
      }
    }

    return ValidationResult.valid();
  }

  /// Calcule les statistiques de validation pour un ensemble de jardins
  GardenValidationStats calculateValidationStats(List<Garden> gardens) {
    final activeGardens = gardens.where((garden) => garden.isActive).toList();
    final inactiveGardens =
        gardens.where((garden) => !garden.isActive).toList();

    final minGardens = EnvironmentService.minGardensPerUser;
    final maxGardens = EnvironmentService.maxGardensPerUser;

    final canAddMore = activeGardens.length < maxGardens;
    final canRemove = activeGardens.length > minGardens;
    final remainingSlots = maxGardens - activeGardens.length;

    return GardenValidationStats(
      totalGardens: gardens.length,
      activeGardens: activeGardens.length,
      inactiveGardens: inactiveGardens.length,
      minRequired: minGardens,
      maxAllowed: maxGardens,
      canAddMore: canAddMore,
      canRemove: canRemove,
      remainingSlots: remainingSlots,
    );
  }
}

/// Résultat de validation avec statut et message d'erreur
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.valid() => const ValidationResult._(true, null);

  factory ValidationResult.invalid(String message) =>
      ValidationResult._(false, message);

  @override
  String toString() {
    return isValid
        ? 'ValidationResult: Valid'
        : 'ValidationResult: Invalid - $errorMessage';
  }
}

/// Statistiques de validation pour les jardins
class GardenValidationStats {
  final int totalGardens;
  final int activeGardens;
  final int inactiveGardens;
  final int minRequired;
  final int maxAllowed;
  final bool canAddMore;
  final bool canRemove;
  final int remainingSlots;

  const GardenValidationStats({
    required this.totalGardens,
    required this.activeGardens,
    required this.inactiveGardens,
    required this.minRequired,
    required this.maxAllowed,
    required this.canAddMore,
    required this.canRemove,
    required this.remainingSlots,
  });

  @override
  String toString() {
    return 'GardenValidationStats(active: $activeGardens/$maxAllowed, canAdd: $canAddMore, canRemove: $canRemove)';
  }
}
