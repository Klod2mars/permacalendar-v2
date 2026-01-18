// lib/core/services/plant_lifecycle_service.dart
import '../../features/plant_catalog/domain/entities/plant_entity.dart';

class PlantLifecycleService {
  static Future<Map<String, dynamic>> calculateLifecycle(
    PlantFreezed plant,
    DateTime plantingDate, {
    double? initialProgressFromPlanting,
    String? plantingStatus,
  }) async {
    final germinationDays = _getSafeGerminationDays(plant);

    // Sécuriser daysToMaturity
    int maturityDays = plant.daysToMaturity;
    if (maturityDays <= 0) maturityDays = 60;

    // --- Déterminer initialProgress (0.0 .. 1.0)
    double initialProgress = 0.0;

    if (initialProgressFromPlanting != null) {
      // clamp renvoie num : forcer en double via toDouble()
      initialProgress = initialProgressFromPlanting.clamp(0.0, 1.0).toDouble();
    } else {
      if (plantingStatus != null && plantingStatus == 'Planté') {
        double? plantSpecific;
        try {
          if (plant.growth != null && plant.growth is Map) {
            final raw = (plant.growth! as Map<String, dynamic>)['transplantInitialPercent'];
            if (raw is num) {
              plantSpecific = raw.toDouble();
            } else if (raw is String) {
              plantSpecific = double.tryParse(raw);
            }
          }
        } catch (_) {
          plantSpecific = null;
        }
        // forcer en double
        initialProgress = ( (plantSpecific ?? 0.3).clamp(0.0, 1.0) ).toDouble();
      } else {
        initialProgress = 0.0;
      }
    }

    // --- Calculer progression et dates
    final now = DateTime.now();
    int elapsedDays = now.difference(plantingDate).inDays;
    if (elapsedDays < 0) elapsedDays = 0;

    final double initialDoneDays = initialProgress * maturityDays;
    final double totalDoneDays = initialDoneDays + elapsedDays;

    double rawProgress =
        maturityDays > 0 ? (totalDoneDays / maturityDays) : 0.0;
    final double progress = rawProgress.clamp(0.0, 1.0);

    final int effectiveMaturityDays =
        (maturityDays * (1.0 - initialProgress)).ceil().clamp(1, maturityDays);

    final DateTime expectedHarvestDate =
        plantingDate.add(Duration(days: effectiveMaturityDays));

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
    try {
      // 1) si la map de germination existe -> parser minDays/maxDays proprement
      if (plant.germination != null && plant.germination is Map) {
        final germinationMap =
            Map<String, dynamic>.from(plant.germination! as Map);
        final dynamic minRaw = germinationMap['minDays'];
        final dynamic maxRaw = germinationMap['maxDays'];

        int? tryParseInt(dynamic v) {
          if (v == null) return null;
          if (v is num) return v.toInt();
          if (v is String) return int.tryParse(v);
          return null;
        }

        final minDays = tryParseInt(minRaw);
        if (minDays != null && minDays > 0) return minDays;

        final maxDays = tryParseInt(maxRaw);
        if (maxDays != null && maxDays > 0) return maxDays;
        // sinon fallback vers la suite
      }

      // 2) fallback : utiliser daysToMaturity s'il est présent / sain
      final int maturity =
          (plant.daysToMaturity is int && plant.daysToMaturity > 0)
              ? plant.daysToMaturity
              : 60;

      // calcul robuste et forçage en int
      final int computed = (maturity * 0.1).ceil();
      final int bounded = computed.clamp(5, 21).toInt();
      return bounded;
    } catch (e) {
      // En cas d'erreur, retourner valeur par défaut sûre
      return 7;
    }
  }
}
