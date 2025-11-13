import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

/// Use case pour évaluer le timing optimal de plantation
class EvaluatePlantingTimingUsecase {
  const EvaluatePlantingTimingUsecase();

  /// Évalue si c'est le bon moment pour planter une espèce donnée
  ///
  /// [plant] - La plante à évaluer
  /// [weather] - Conditions météorologiques actuelles
  /// [garden] - Contexte du jardin
  ///
  /// Retourne une [PlantingTimingEvaluation]
  Future<PlantingTimingEvaluation> execute({
    required PlantFreezed plant,
    required WeatherCondition weather,
    required GardenContext garden,
  }) async {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentMonthAbbr = _getMonthAbbreviation(currentMonth);

    // 1. Vérifier si on est dans la période de semis
    final isInSowingPeriod = plant.sowingMonths.contains(currentMonthAbbr);

    // 2. Vérifier les conditions météo
    final favorableFactors = <String>[];
    final unfavorableFactors = <String>[];
    final risks = <String>[];

    // Température
    if (plant.metadata.containsKey('germination')) {
      final germination = plant.metadata['germination'] as Map<String, dynamic>;
      final optimalTemp =
          germination['optimalTemperature'] as Map<String, dynamic>;
      final minTemp = optimalTemp['min'] as num;
      final maxTemp = optimalTemp['max'] as num;

      if (weather.value >= minTemp && weather.value <= maxTemp) {
        favorableFactors.add(
            'Température optimale pour la germination (${weather.value.toStringAsFixed(1)}Â°C)');
      } else if (weather.value < minTemp) {
        unfavorableFactors.add(
            'Température trop basse (${weather.value.toStringAsFixed(1)}Â°C < $minTempÂ°C)');
        risks.add('Risque de mauvaise germination');
      } else {
        unfavorableFactors.add(
            'Température trop élevée (${weather.value.toStringAsFixed(1)}Â°C > $maxTempÂ°C)');
        risks.add('Risque de stress thermique');
      }
    }

    // Saison
    if (isInSowingPeriod) {
      favorableFactors.add('Période de semis recommandée');
    } else {
      unfavorableFactors.add('Hors période de semis recommandée');
    }

    // Risque de gel
    if (weather.value < 5.0) {
      final isFrostSensitive = plant.metadata['frostSensitive'] == true ||
          plant.metadata['frostSensitive'] == 'true';

      if (isFrostSensitive) {
        unfavorableFactors.add('Risque de gel (température < 5Â°C)');
        risks.add('Plante sensible au gel - risque de mort');
      }
    }

    // Sol
    if (garden.soil.ph >= 6.0 && garden.soil.ph <= 7.5) {
      favorableFactors.add('pH du sol favorable');
    } else {
      unfavorableFactors
          .add('pH du sol non optimal (${garden.soil.ph.toStringAsFixed(1)})');
    }

    // 3. Calculer le score de timing
    final timingScore = _calculateTimingScore(
      isInSowingPeriod: isInSowingPeriod,
      favorableFactors: favorableFactors.length,
      unfavorableFactors: unfavorableFactors.length,
      risks: risks.length,
    );

    // 4. Déterminer si c'est le moment optimal
    final isOptimalTime = timingScore >= 70.0 && risks.isEmpty;

    // 5. Calculer la date optimale si pas maintenant
    DateTime? optimalPlantingDate;
    if (!isOptimalTime) {
      optimalPlantingDate = _calculateOptimalPlantingDate(plant, now);
    }

    // 6. Générer la raison
    final reason = _generateReason(
      isOptimalTime: isOptimalTime,
      isInSowingPeriod: isInSowingPeriod,
      timingScore: timingScore,
      risks: risks,
    );

    return PlantingTimingEvaluation(
      isOptimalTime: isOptimalTime,
      timingScore: timingScore,
      reason: reason,
      optimalPlantingDate: optimalPlantingDate,
      favorableFactors: favorableFactors,
      unfavorableFactors: unfavorableFactors,
      risks: risks,
    );
  }

  /// Calcule le score de timing (0-100)
  double _calculateTimingScore({
    required bool isInSowingPeriod,
    required int favorableFactors,
    required int unfavorableFactors,
    required int risks,
  }) {
    double score = 50.0; // Score de base

    // Bonus si période de semis
    if (isInSowingPeriod) {
      score += 30.0;
    }

    // Bonus pour chaque facteur favorable
    score += favorableFactors * 10.0;

    // Malus pour chaque facteur défavorable
    score -= unfavorableFactors * 10.0;

    // Malus important pour les risques
    score -= risks * 20.0;

    // Limiter entre 0 et 100
    return score.clamp(0.0, 100.0);
  }

  /// Calcule la date optimale de plantation
  DateTime _calculateOptimalPlantingDate(PlantFreezed plant, DateTime now) {
    // Trouver le prochain mois de semis
    final currentMonth = now.month;

    for (int i = 1; i <= 12; i++) {
      final nextMonth = (currentMonth + i - 1) % 12 + 1;
      final nextMonthAbbr = _getMonthAbbreviation(nextMonth);

      if (plant.sowingMonths.contains(nextMonthAbbr)) {
        // Calculer le nombre de mois à ajouter
        int monthsToAdd = i;
        if (nextMonth < currentMonth) {
          monthsToAdd += 12;
        }

        return DateTime(
            now.year, now.month + monthsToAdd, 15); // 15ème jour du mois
      }
    }

    // Si aucun mois trouvé, retourner dans 1 an
    return DateTime(now.year + 1, now.month, 15);
  }

  /// Génère la raison de la recommandation
  String _generateReason({
    required bool isOptimalTime,
    required bool isInSowingPeriod,
    required double timingScore,
    required List<String> risks,
  }) {
    if (isOptimalTime) {
      return 'C\'est le moment idéal pour planter ! Les conditions sont optimales.';
    }

    if (risks.isNotEmpty) {
      return 'Plantation déconseillée : ${risks.join(', ')}';
    }

    if (!isInSowingPeriod) {
      return 'Nous sommes hors de la période de semis recommandée. Attendez la prochaine saison.';
    }

    if (timingScore < 50.0) {
      return 'Les conditions actuelles ne sont pas favorables. Il est préférable d\'attendre.';
    }

    return 'Les conditions sont moyennes. Vous pouvez planter mais surveillez attentivement.';
  }

  /// Convertit un numéro de mois en abréviation
  String _getMonthAbbreviation(int month) {
    const abbr = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    return abbr[month - 1];
  }
}


