import '../../features/plant_catalog/domain/entities/plant_entity.dart';

class PlantLifecycleService {
  static Future<Map<String, dynamic>> calculateLifecycle(
    PlantFreezed plant,
    DateTime plantingDate, {
    double? initialProgressFromPlanting,
    String? plantingStatus,
  }) async {
    // Algorithme robuste prenant en compte :
    // - un avancement initial transmis par la planting (metadata)
    // - une valeur spécifique dans plant.growth['transplantInitialPercent']
    // - des valeurs par défaut (0.0 pour Semé, 0.3 pour Planté)
    //
    // On calcule ensuite :
    // - la progression (progress) normalisée entre 0.0 et 1.0
    // - une date de germination (adaptée si initialProgress > 0)
    // - une date de récolte attendue tenant compte de l'avancement initial

    final germinationDays = _getSafeGerminationDays(plant);

    // Sécuriser daysToMaturity
    int maturityDays = (plant.daysToMaturity ?? 60);
    if (maturityDays <= 0) maturityDays = 60;

    // --- Déterminer initialProgress (0.0 .. 1.0)
    double initialProgress = 0.0;

    if (initialProgressFromPlanting != null) {
      initialProgress = initialProgressFromPlanting.clamp(0.0, 1.0) as double;
    } else {
      // Si la plantation est marquée "Planté", tenter la valeur spécifique
      if (plantingStatus != null && plantingStatus == 'Planté') {
        double? plantSpecific;
        try {
          if (plant.growth != null) {
            final raw = plant.growth!['transplantInitialPercent'];
            if (raw is num) {
              plantSpecific = raw.toDouble();
            } else if (raw is String) {
              plantSpecific = double.tryParse(raw);
            }
          }
        } catch (_) {
          plantSpecific = null;
        }
        initialProgress = ((plantSpecific ?? 0.3).clamp(0.0, 1.0)) as double;
      } else {
        // Par défaut Semée => 0%
        initialProgress = 0.0;
      }
    }

    // --- Calculer progression et dates
    final now = DateTime.now();
    int elapsedDays = now.difference(plantingDate).inDays;
    if (elapsedDays < 0) elapsedDays = 0;

    // Jours équivalents déjà "faits" avant la plantation
    final double initialDoneDays = initialProgress * maturityDays;

    // Total de jours "réalisés" depuis le début du cycle (en équivalent)
    final double totalDoneDays = initialDoneDays + elapsedDays;

    double rawProgress =
        maturityDays > 0 ? (totalDoneDays / maturityDays) : 0.0;
    final double progress = rawProgress.clamp(0.0, 1.0);

    // Jours restants pour arriver à maturité en tenant compte de l'avancement initial
    final int effectiveMaturityDays =
        (maturityDays * (1.0 - initialProgress)).ceil().clamp(1, maturityDays);

    final DateTime expectedHarvestDate =
        plantingDate.add(Duration(days: effectiveMaturityDays));

    // Germination : si la plantation a un avancement initial, on considère que
    // la germination est passée / immédiate ; sinon on la calcule normalement.
    final DateTime germinationDate = initialProgress > 0.0
        ? plantingDate
        : plantingDate.add(Duration(days: germinationDays));

    // --- Déterminer le stade courant et la prochaine action
    String currentStage;
    String nextAction;

    if (now.isBefore(germinationDate)) {
      currentStage = 'germination';
      nextAction = 'Surveiller la levée';
    } else if (now.isAfter(expectedHarvestDate) || progress >= 1.0) {
      currentStage = 'récolte';
      nextAction = 'Commencer la récolte';
    } else {
      // Entre germination et récolte : distinguer croissance / fructification
      if (progress < 0.6) {
        currentStage = 'croissance';
        nextAction = 'Soins: surveiller croissance, arroser selon besoin';
      } else {
        currentStage = 'fructification';
        nextAction = 'Surveiller floraison / formation des fruits';
      }
    }

    return {
      'germinationDate': germinationDate,
      'expectedHarvestDate': expectedHarvestDate,
      'germinationDays': germinationDays,
      'maturityDays': maturityDays,
      'currentStage': currentStage,
      'nextAction': nextAction,
      'progress': progress,
      'initialProgress': initialProgress,
    };
  }

  static int _getSafeGerminationDays(PlantFreezed plant) {
    // Méthode ultra-sécurisée pour éviter tout crash

    try {
      // Si germination existe et est une Map

      if (plant.germination != null && plant.germination is Map) {
        final germinationMap = plant.germination as Map<String, dynamic>;

        return germinationMap['minDays'] ?? germinationMap['maxDays'] ?? 7;
      }

      // Si daysToMaturity existe, on calcule un ratio

      return (plant.daysToMaturity * 0.1).ceil().clamp(5, 21);
    } catch (e) {
      // Erreur silencieuse dans _getSafeGerminationDays
    }

    // Valeur par défaut ultime

    return 7;
  }
}
