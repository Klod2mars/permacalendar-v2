/// Exceptions liées aux plantes
///
/// Fichier créé pour centraliser les exceptions métier liées
/// à la gestion des plantes dans l'application.
library;

/// Exception levée lorsqu'une plante n'est pas trouvée dans le catalogue
///
/// Cette exception est utilisée pour signaler qu'un plantId donné
/// n'existe pas dans le catalogue des plantes disponibles.
///
/// **Usage :**
/// ```dart
/// throw PlantNotFoundException(
///   plantId: 'spinach',
///   catalogSize: 50,
///   searchedIds: ['tomato', 'carrot', 'lettuce', ...],
/// );
/// ```
class PlantNotFoundException implements Exception {
  /// ID de la plante recherchée
  final String plantId;

  /// Nombre total de plantes dans le catalogue (optionnel)
  final int? catalogSize;

  /// Liste des IDs recherchés/disponibles (optionnel, pour debug)
  final List<String>? searchedIds;

  /// Message d'erreur additionnel (optionnel)
  final String? message;

  const PlantNotFoundException({
    required this.plantId,
    this.catalogSize,
    this.searchedIds,
    this.message,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('PlantNotFoundException: ');
    buffer.write('No plant found for ID "$plantId"');

    if (catalogSize != null) {
      buffer.write(' (catalog contains $catalogSize plants)');
    }

    if (searchedIds != null && searchedIds!.isNotEmpty) {
      buffer.write(
          '\n  Available IDs (first 10): ${searchedIds!.take(10).join(', ')}');
      if (searchedIds!.length > 10) {
        buffer.write(', ... (${searchedIds!.length - 10} more)');
      }
    }

    if (message != null) {
      buffer.write('\n  Additional info: $message');
    }

    return buffer.toString();
  }
}

/// Exception levée lorsque le catalogue de plantes est vide
///
/// Indique un problème de chargement ou d'initialisation du catalogue.
class EmptyPlantCatalogException implements Exception {
  final String message;

  const EmptyPlantCatalogException([
    this.message =
        'Plant catalog is empty. Ensure plants.json is loaded correctly.',
  ]);

  @override
  String toString() => 'EmptyPlantCatalogException: $message';
}

/// Exception levée lorsqu'une plante est invalide ou incomplète
///
/// Utilisée lors de la validation des données d'une plante.
class InvalidPlantDataException implements Exception {
  final String plantId;
  final String reason;

  const InvalidPlantDataException({
    required this.plantId,
    required this.reason,
  });

  @override
  String toString() =>
      'InvalidPlantDataException: Plant "$plantId" has invalid data: $reason';
}


