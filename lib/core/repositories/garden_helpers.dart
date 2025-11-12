import '../models/garden.dart';
import '../data/hive/garden_boxes.dart';

/// Classe utilitaire pour les calculs et opérations sur les jardins
/// Fournit des méthodes d'aide pour les statistiques et analyses de jardins
class GardenHelpers {
  /// Calcule la superficie totale de tous les jardins
  /// Prend en compte uniquement les jardins actifs par défaut
  static double calculateTotalGardenArea(List<Garden> gardens,
      {bool activeOnly = true}) {
    final filteredGardens = activeOnly
        ? gardens.where((garden) => garden.isActive).toList()
        : gardens;

    return filteredGardens.fold<double>(
        0.0, (total, garden) => total + garden.totalAreaInSquareMeters);
  }

  /// Trouve le jardin avec le plus de zones de culture
  /// Retourne null si aucun jardin n'est trouvé
  static Garden? getGardenWithMostBeds(List<Garden> gardens) {
    if (gardens.isEmpty) return null;

    Garden? gardenWithMostBeds;
    int maxBedCount = 0;

    for (final garden in gardens.where((g) => g.isActive)) {
      final bedCount = GardenBoxes.getGardenBeds(garden.id).length;
      if (bedCount > maxBedCount) {
        maxBedCount = bedCount;
        gardenWithMostBeds = garden;
      }
    }

    return gardenWithMostBeds;
  }

  /// Trouve le jardin avec la plus grande superficie
  /// Retourne null si aucun jardin n'est trouvé
  static Garden? getLargestGarden(List<Garden> gardens) {
    if (gardens.isEmpty) return null;

    final activeGardens = gardens.where((garden) => garden.isActive).toList();
    if (activeGardens.isEmpty) return null;

    return activeGardens.reduce((current, next) =>
        current.totalAreaInSquareMeters > next.totalAreaInSquareMeters
            ? current
            : next);
  }

  /// Trouve le jardin avec la plus petite superficie
  /// Retourne null si aucun jardin n'est trouvé
  static Garden? getSmallestGarden(List<Garden> gardens) {
    if (gardens.isEmpty) return null;

    final activeGardens = gardens.where((garden) => garden.isActive).toList();
    if (activeGardens.isEmpty) return null;

    return activeGardens.reduce((current, next) =>
        current.totalAreaInSquareMeters < next.totalAreaInSquareMeters
            ? current
            : next);
  }

  /// Calcule la superficie moyenne des jardins
  static double calculateAverageGardenArea(List<Garden> gardens,
      {bool activeOnly = true}) {
    final filteredGardens = activeOnly
        ? gardens.where((garden) => garden.isActive).toList()
        : gardens;

    if (filteredGardens.isEmpty) return 0.0;

    final totalArea =
        calculateTotalGardenArea(filteredGardens, activeOnly: false);
    return totalArea / filteredGardens.length;
  }

  /// Trouve les jardins créés dans une période donnée
  static List<Garden> getGardensCreatedInPeriod(
      List<Garden> gardens, DateTime startDate, DateTime endDate) {
    return gardens
        .where((garden) =>
            garden.createdAt.isAfter(startDate) &&
            garden.createdAt.isBefore(endDate))
        .toList();
  }

  /// Trouve les jardins modifiés récemment
  static List<Garden> getRecentlyModifiedGardens(List<Garden> gardens,
      {int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return gardens
        .where((garden) => garden.updatedAt.isAfter(cutoffDate))
        .toList();
  }

  /// Groupe les jardins par tranche de superficie
  static Map<String, List<Garden>> groupGardensByAreaRange(
      List<Garden> gardens) {
    final Map<String, List<Garden>> grouped = {
      'Petit (< 50m²)': [],
      'Moyen (50-200m²)': [],
      'Grand (200-500m²)': [],
      'Très grand (> 500m²)': [],
    };

    for (final garden in gardens.where((g) => g.isActive)) {
      final area = garden.totalAreaInSquareMeters;
      if (area < 50) {
        grouped['Petit (< 50m²)']!.add(garden);
      } else if (area < 200) {
        grouped['Moyen (50-200m²)']!.add(garden);
      } else if (area < 500) {
        grouped['Grand (200-500m²)']!.add(garden);
      } else {
        grouped['Très grand (> 500m²)']!.add(garden);
      }
    }

    return grouped;
  }

  /// Calcule les statistiques détaillées des jardins
  static GardenStatistics calculateGardenStatistics(List<Garden> gardens) {
    final activeGardens = gardens.where((garden) => garden.isActive).toList();
    final inactiveGardens =
        gardens.where((garden) => !garden.isActive).toList();

    final totalArea = calculateTotalGardenArea(gardens, activeOnly: false);
    final activeArea =
        calculateTotalGardenArea(activeGardens, activeOnly: false);
    final averageArea =
        calculateAverageGardenArea(activeGardens, activeOnly: false);

    final largestGarden = getLargestGarden(activeGardens);
    final smallestGarden = getSmallestGarden(activeGardens);
    final gardenWithMostBeds = getGardenWithMostBeds(activeGardens);

    // Calcul du nombre total de zones de culture
    int totalBeds = 0;
    for (final garden in activeGardens) {
      totalBeds += GardenBoxes.getGardenBeds(garden.id).length;
    }

    return GardenStatistics(
      totalGardens: gardens.length,
      activeGardens: activeGardens.length,
      inactiveGardens: inactiveGardens.length,
      totalArea: totalArea,
      activeArea: activeArea,
      averageArea: averageArea,
      largestGarden: largestGarden,
      smallestGarden: smallestGarden,
      gardenWithMostBeds: gardenWithMostBeds,
      totalBeds: totalBeds,
    );
  }

  /// Trouve les jardins par localisation
  static List<Garden> getGardensByLocation(
      List<Garden> gardens, String location) {
    final normalizedLocation = location.toLowerCase().trim();
    return gardens
        .where((garden) =>
            garden.isActive &&
            garden.location.toLowerCase().contains(normalizedLocation))
        .toList();
  }

  /// Trouve les jardins avec des métadonnées spécifiques
  static List<Garden> getGardensWithMetadata(List<Garden> gardens, String key,
      [dynamic value]) {
    return gardens.where((garden) {
      if (!garden.metadata.containsKey(key)) return false;
      if (value != null) {
        return garden.metadata[key] == value;
      }
      return true;
    }).toList();
  }

  /// Calcule la densité de plantation (nombre de zones par m²)
  static double calculatePlantingDensity(Garden garden) {
    final beds = GardenBoxes.getGardenBeds(garden.id);
    if (garden.totalAreaInSquareMeters == 0) return 0.0;

    return beds.length / garden.totalAreaInSquareMeters;
  }

  /// Trouve les jardins les plus productifs (avec le plus de zones de culture par m²)
  static List<Garden> getMostProductiveGardens(List<Garden> gardens,
      {int limit = 5}) {
    final activeGardens = gardens.where((garden) => garden.isActive).toList();

    // Calcul de la densité pour chaque jardin
    final gardensWithDensity = activeGardens
        .map((garden) => {
              'garden': garden,
              'density': calculatePlantingDensity(garden),
            })
        .toList();

    // Tri par densité décroissante
    gardensWithDensity.sort(
        (a, b) => (b['density'] as double).compareTo(a['density'] as double));

    // Retour des jardins les plus productifs
    return gardensWithDensity
        .take(limit)
        .map((item) => item['garden'] as Garden)
        .toList();
  }

  /// Valide la cohérence des données entre jardins et zones de culture
  static List<String> validateGardenDataConsistency(List<Garden> gardens) {
    final issues = <String>[];

    for (final garden in gardens) {
      try {
        final beds = GardenBoxes.getGardenBeds(garden.id);

        // Vérification de la superficie des zones vs jardin
        final totalBedArea =
            beds.fold<double>(0.0, (sum, bed) => sum + bed.sizeInSquareMeters);

        if (totalBedArea > garden.totalAreaInSquareMeters * 1.1) {
          // Tolérance de 10%
          issues.add(
              'Jardin "${garden.name}": superficie des zones (${totalBedArea.toStringAsFixed(1)}m²) '
              'dépasse celle du jardin (${garden.totalAreaInSquareMeters.toStringAsFixed(1)}m²)');
        }

        // Vérification des zones orphelines
        for (final bed in beds) {
          if (bed.gardenId != garden.id) {
            issues.add(
                'Zone "${bed.name}" référence un jardin incorrect (${bed.gardenId} vs ${garden.id})');
          }
        }
      } catch (e) {
        issues
            .add('Erreur lors de la validation du jardin "${garden.name}": $e');
      }
    }

    return issues;
  }
}

/// Classe contenant les statistiques détaillées des jardins
class GardenStatistics {
  final int totalGardens;
  final int activeGardens;
  final int inactiveGardens;
  final double totalArea;
  final double activeArea;
  final double averageArea;
  final Garden? largestGarden;
  final Garden? smallestGarden;
  final Garden? gardenWithMostBeds;
  final int totalBeds;

  const GardenStatistics({
    required this.totalGardens,
    required this.activeGardens,
    required this.inactiveGardens,
    required this.totalArea,
    required this.activeArea,
    required this.averageArea,
    this.largestGarden,
    this.smallestGarden,
    this.gardenWithMostBeds,
    required this.totalBeds,
  });

  @override
  String toString() {
    return 'GardenStatistics('
        'total: $totalGardens, '
        'active: $activeGardens, '
        'totalArea: ${totalArea.toStringAsFixed(1)}m², '
        'averageArea: ${averageArea.toStringAsFixed(1)}m², '
        'totalBeds: $totalBeds'
        ')';
  }

  /// Convertit les statistiques en Map pour l'export
  Map<String, dynamic> toJson() {
    return {
      'totalGardens': totalGardens,
      'activeGardens': activeGardens,
      'inactiveGardens': inactiveGardens,
      'totalArea': totalArea,
      'activeArea': activeArea,
      'averageArea': averageArea,
      'largestGarden': largestGarden?.toJson(),
      'smallestGarden': smallestGarden?.toJson(),
      'gardenWithMostBeds': gardenWithMostBeds?.toJson(),
      'totalBeds': totalBeds,
    };
  }
}

