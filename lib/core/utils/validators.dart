import 'package:permacalendar/core/services/environment_service.dart';

/// Utilitaires de validation pour l'application
class Validators {
  /// Validation du nom (général)
  static String? validateName(String? value, {String fieldName = 'Nom'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName requis';
    }

    if (value.trim().length < 2) {
      return '$fieldName doit contenir au moins 2 caractères';
    }

    if (value.trim().length > 100) {
      return '$fieldName ne peut pas dépasser 100 caractères';
    }

    return null;
  }

  /// Validation de la description
  static String? validateDescription(String? value, {bool required = false}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Description requise';
    }

    if (value != null && value.trim().length > 500) {
      return 'Description ne peut pas dépasser 500 caractères';
    }

    return null;
  }

  /// Validation de l'email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email requis';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format d\'email invalide';
    }

    return null;
  }

  /// Validation du mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe requis';
    }

    if (value.length < 8) {
      return 'Mot de passe doit contenir au moins 8 caractères';
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Mot de passe doit contenir au moins une minuscule, une majuscule et un chiffre';
    }

    return null;
  }

  /// Validation de la surface d'un jardin
  static String? validateGardenArea(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Surface requise';
    }

    final area = double.tryParse(value.trim());
    if (area == null) {
      return 'Surface doit être un nombre valide';
    }

    if (area <= 0) {
      return 'Surface doit être positive';
    }

    if (area > 10000) {
      return 'Surface ne peut pas dépasser 10 000 m²';
    }

    return null;
  }

  /// Validation du nombre de jardins
  static String? validateGardenCount(int currentCount,
      {bool isAdding = false}) {
    if (currentCount < 0) {
      return 'Le nombre de jardins est invalide';
    }

    final maxGardens = EnvironmentService.maxGardensPerUser;

    if (isAdding && currentCount >= maxGardens) {
      return 'Vous ne pouvez pas avoir plus de $maxGardens jardins';
    }

    return null;
  }

  /// Validation de la quantité de plantation
  static String? validatePlantingQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantité requise';
    }

    final quantity = int.tryParse(value.trim());
    if (quantity == null) {
      return 'Quantité doit être un nombre entier';
    }

    if (quantity <= 0) {
      return 'Quantité doit être positive';
    }

    if (quantity > 1000) {
      return 'Quantité ne peut pas dépasser 1000';
    }

    return null;
  }

  /// Validation des jours jusqu'à maturité
  static String? validateDaysToMaturity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Jours jusqu\'à maturité requis';
    }

    final days = int.tryParse(value.trim());
    if (days == null) {
      return 'Doit être un nombre entier';
    }

    if (days <= 0) {
      return 'Doit être un nombre positif';
    }

    if (days > 365) {
      return 'Ne peut pas dépasser 365 jours';
    }

    return null;
  }

  /// Validation de l'espacement entre plants
  static String? validatePlantSpacing(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }

    final spacing = double.tryParse(value.trim());
    if (spacing == null) {
      return 'Espacement doit être un nombre valide';
    }

    if (spacing <= 0) {
      return 'Espacement doit être positif';
    }

    if (spacing > 500) {
      return 'Espacement ne peut pas dépasser 500 cm';
    }

    return null;
  }

  /// Validation de l'URL d'image
  static String? validateImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }

    final urlRegex = RegExp(
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$');

    if (!urlRegex.hasMatch(value.trim())) {
      return 'URL d\'image invalide';
    }

    return null;
  }

  /// Validation de la date
  static String? validateDate(DateTime? value, {bool required = true}) {
    if (required && value == null) {
      return 'Date requise';
    }

    if (value != null) {
      final now = DateTime.now();
      final minDate = DateTime(now.year - 10);
      final maxDate = DateTime(now.year + 10);

      if (value.isBefore(minDate) || value.isAfter(maxDate)) {
        return 'Date doit être entre ${minDate.year} et ${maxDate.year}';
      }
    }

    return null;
  }

  /// Validation de la date de plantation
  static String? validatePlantingDate(DateTime? value) {
    if (value == null) {
      return 'Date de plantation requise';
    }

    final now = DateTime.now();
    final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    final oneYearFromNow = DateTime(now.year + 1, now.month, now.day);

    if (value.isBefore(oneYearAgo) || value.isAfter(oneYearFromNow)) {
      return 'Date de plantation doit être dans une plage d\'un an';
    }

    return null;
  }

  /// Validation de la date de récolte
  static String? validateHarvestDate(
      DateTime? plantingDate, DateTime? harvestDate) {
    if (harvestDate == null) {
      return null; // Optionnel
    }

    if (plantingDate != null && harvestDate.isBefore(plantingDate)) {
      return 'Date de récolte doit être après la plantation';
    }

    final now = DateTime.now();
    final twoYearsFromNow = DateTime(now.year + 2, now.month, now.day);

    if (harvestDate.isAfter(twoYearsFromNow)) {
      return 'Date de récolte trop éloignée';
    }

    return null;
  }

  /// Validation du nom scientifique
  static String? validateScientificName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }

    // Format basique: Genus species
    final scientificNameRegex = RegExp(r'^[A-Z][a-z]+ [a-z]+( [a-z]+)*$');
    if (!scientificNameRegex.hasMatch(value.trim())) {
      return 'Format de nom scientifique invalide (ex: Solanum lycopersicum)';
    }

    return null;
  }

  /// Validation de la température
  static String? validateTemperature(String? value, {String unit = '°C'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }

    final temp = double.tryParse(value.trim());
    if (temp == null) {
      return 'Température doit être un nombre valide';
    }

    // Plage raisonnable pour les températures de jardinage
    if (temp < -50 || temp > 60) {
      return 'Température doit être entre -50$unit et 60$unit';
    }

    return null;
  }

  /// Validation du pH du sol
  static String? validateSoilPH(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }

    final ph = double.tryParse(value.trim());
    if (ph == null) {
      return 'pH doit être un nombre valide';
    }

    if (ph < 0 || ph > 14) {
      return 'pH doit être entre 0 et 14';
    }

    return null;
  }
}
