import 'dart:developer' as developer;
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart'
    show GardenContext, SoilInfo, GardenLocation;
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart'
    as garden_ctx;
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/condition_enums.dart'
    show SoilType, ExposureType;
import 'package:permacalendar/core/services/models/composite_weather_data.dart';

// NOTE Prompt 4: Utilisation de modèles composites helper temporaires
// TODO Prompt futur: Remplacer par entités domain composites officielles
// Import sélectif pour éviter conflit SoilType entre condition_enums et garden_context

/// Service d'analyse des conditions biologiques des plantes
///
/// Service optimisé pour production avec:
/// - Algorithmes d'analyse affinés basés sur données réelles plants.json
/// - Système de scoring précis et pondéré
/// - Recommandations concrètes et actionnables
/// - Logging détaillé pour debugging
class PlantConditionAnalyzer {
  const PlantConditionAnalyzer();

  /// Système de logging pour debugging
  static bool _loggingEnabled = true;

  /// Analyse complète des conditions d'une plante
  ///
  /// [plant] - La plante à analyser
  /// [condition] - Les conditions composites actuelles de la plante
  /// [weather] - Les conditions météorologiques composites
  /// [garden] - Le contexte du jardin
  ///
  /// Retourne un [ConditionAnalysisResult] avec l'évaluation complète
  ///
  /// NOTE Prompt 4: Utilise modèles composites helper temporaires
  Future<ConditionAnalysisResult> analyzeConditions({
    required PlantFreezed plant,
    required CompositePlantCondition condition,
    required CompositeWeatherData weather,
    required GardenContext garden,
  }) async {
    _logDebug('🔬 Analyse complète des conditions pour ${plant.commonName}');
    final stopwatch = Stopwatch()..start();

    try {
      // Validation des paramètres
      _validateInputs(plant, condition, weather, garden);

      // Analyse des différents aspects avec algorithmes AFFINÉS (Prompt 4)
      _logDebug('📊 Analyse multi-facteurs...');
      final temperatureAnalysis =
          _analyzeTemperatureRefined(plant, condition, weather);
      final moistureAnalysis =
          _analyzeMoistureRefined(plant, condition, weather);
      final lightAnalysis = _analyzeLightRefined(plant, condition);
      final soilAnalysis = _analyzeSoilRefined(plant, condition, garden);
      final nutritionAnalysis = _analyzeNutritionRefined(plant, condition);
      final healthAnalysis = _analyzeHealthRefined(plant, condition);

      // Calcul du score global OPTIMISÉ avec pondération affinée
      final overallScore = _calculateOptimizedOverallScore([
        temperatureAnalysis,
        moistureAnalysis,
        lightAnalysis,
        soilAnalysis,
        nutritionAnalysis,
        healthAnalysis,
      ]);

      _logDebug('📈 Score global: ${overallScore.toStringAsFixed(2)}');

      // Identification des risques et opportunités AMÉLIORÉE
      final risks = _identifyRisksEnhanced(plant, condition, weather, garden);
      final opportunities =
          _identifyOpportunitiesEnhanced(plant, condition, weather, garden);

      _logDebug(
          '⚠️ ${risks.length} risques, 💡 ${opportunities.length} opportunités');

      // Détermination du statut global
      final status = _determineOverallStatus(overallScore, risks);

      // Génération de recommandations CONCRÈTES et ACTIONNABLES
      final recommendations = _generateActionableRecommendations(
        plant,
        risks,
        opportunities,
        condition,
        weather,
        garden,
      );

      stopwatch.stop();
      _logDebug(
          '✅ Analyse terminée (${stopwatch.elapsedMilliseconds}ms, confiance: ${_calculateConfidence(condition, weather).toStringAsFixed(2)})');

      return ConditionAnalysisResult(
        plantId: plant.id,
        plantName: plant.commonName,
        overallScore: overallScore,
        status: status,
        temperatureAnalysis: temperatureAnalysis,
        moistureAnalysis: moistureAnalysis,
        lightAnalysis: lightAnalysis,
        soilAnalysis: soilAnalysis,
        nutritionAnalysis: nutritionAnalysis,
        healthAnalysis: healthAnalysis,
        risks: risks,
        opportunities: opportunities,
        analyzedAt: DateTime.now(),
        confidence: _calculateConfidence(condition, weather),
        recommendations: recommendations,
      );
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logError(
          '❌ Erreur analyse conditions ${plant.commonName} (${stopwatch.elapsedMilliseconds}ms): $e');
      developer.log(
        'Erreur analyse conditions',
        error: e,
        stackTrace: stackTrace,
        name: 'PlantConditionAnalyzer',
      );
      throw PlantConditionAnalysisException(
          'Erreur lors de l\'analyse des conditions pour ${plant.commonName}: $e');
    }
  }

  // ============================================================================
  // ANALYSES RAFFINÉES (Amélioration Prompt 4)
  // ============================================================================

  /// Analyse spécifique de la température RAFFINÉE
  ///
  /// Amélioration Prompt 4 : Utilise données réelles plants.json
  ConditionFactor _analyzeTemperatureRefined(PlantFreezed plant,
      CompositePlantCondition condition, CompositeWeatherData weather) {
    final currentTemp = weather.currentTemperature;
    final optimalRange = _getOptimalTemperatureRangeFromData(plant);

    double score;
    String status;
    String description;
    List<String> issues = [];

    if (currentTemp >= optimalRange['min']! &&
        currentTemp <= optimalRange['max']!) {
      score = 1.0;
      status = 'optimal';
      description = 'Température idéale pour ${plant.commonName}';
    } else if (currentTemp < optimalRange['min']!) {
      final deviation = optimalRange['min']! - currentTemp;
      score = (1.0 - (deviation / 20.0)).clamp(0.0, 1.0);
      status = deviation > 10 ? 'critical' : 'suboptimal';
      description = 'Température trop basse (${currentTemp.toInt()}°C)';
      issues.add('Risque de ralentissement de croissance');
      if (deviation > 15) issues.add('Risque de dommages par le froid');
    } else {
      final deviation = currentTemp - optimalRange['max']!;
      score = (1.0 - (deviation / 25.0)).clamp(0.0, 1.0);
      status = deviation > 15 ? 'critical' : 'suboptimal';
      description = 'Température trop élevée (${currentTemp.toInt()}°C)';
      issues.add('Risque de stress thermique');
      if (deviation > 20) issues.add('Risque de flétrissement');
    }

    return ConditionFactor(
      name: 'Température',
      score: score,
      status: status,
      description: description,
      currentValue: currentTemp,
      optimalRange:
          '${optimalRange['min']!.toInt()}-${optimalRange['max']!.toInt()}°C',
      issues: issues,
      recommendations:
          _getTemperatureRecommendations(currentTemp, optimalRange, issues),
    );
  }

  /// Analyse spécifique de l'humidité/arrosage RAFFINÉE
  ///
  /// Amélioration Prompt 4 : Utilise données d'arrosage réelles depuis plants.json
  ConditionFactor _analyzeMoistureRefined(PlantFreezed plant,
      CompositePlantCondition condition, CompositeWeatherData weather) {
    final soilMoisture = condition.soilMoisture;
    final waterNeeds = _getWaterNeedsLevel(plant);
    final recentRain = weather.precipitation;

    double score;
    String status;
    String description;
    List<String> issues = [];

    if (soilMoisture >= waterNeeds * 0.8 && soilMoisture <= waterNeeds * 1.2) {
      score = 1.0;
      status = 'optimal';
      description = 'Niveau d\'humidité parfait';
    } else if (soilMoisture < waterNeeds * 0.6) {
      score = soilMoisture / waterNeeds;
      status = soilMoisture < waterNeeds * 0.3 ? 'critical' : 'suboptimal';
      description = 'Sol trop sec (${(soilMoisture * 100).toInt()}%)';
      issues.add('Risque de stress hydrique');
      if (soilMoisture < waterNeeds * 0.2)
        issues.add('Risque de flétrissement permanent');
    } else {
      score = 1.0 - ((soilMoisture - waterNeeds) / waterNeeds).clamp(0.0, 0.5);
      status = soilMoisture > waterNeeds * 1.5 ? 'critical' : 'suboptimal';
      description = 'Sol trop humide (${(soilMoisture * 100).toInt()}%)';
      issues.add('Risque de pourriture des racines');
      if (soilMoisture > waterNeeds * 1.8)
        issues.add('Risque de maladies fongiques');
    }

    return ConditionFactor(
      name: 'Humidité du sol',
      score: score,
      status: status,
      description: description,
      currentValue: soilMoisture * 100,
      optimalRange:
          '${(waterNeeds * 0.8 * 100).toInt()}-${(waterNeeds * 1.2 * 100).toInt()}%',
      issues: issues,
      recommendations: _getMoistureRecommendations(
          soilMoisture, waterNeeds, recentRain, issues),
    );
  }

  /// Analyse spécifique de la lumière RAFFINÉE
  ///
  /// Amélioration Prompt 4 : Utilise sunExposure réel depuis plants.json
  ConditionFactor _analyzeLightRefined(
      PlantFreezed plant, CompositePlantCondition condition) {
    final currentLight = condition.lightExposure;
    final requiredLight = _getLightRequirement(plant);

    double score;
    String status;
    String description;
    List<String> issues = [];

    if (currentLight >= requiredLight * 0.8 &&
        currentLight <= requiredLight * 1.2) {
      score = 1.0;
      status = 'optimal';
      description = 'Exposition lumineuse idéale';
    } else if (currentLight < requiredLight * 0.6) {
      score = currentLight / requiredLight;
      status = currentLight < requiredLight * 0.4 ? 'critical' : 'suboptimal';
      description = 'Manque de lumière (${(currentLight * 100).toInt()}%)';
      issues.add('Croissance ralentie');
      if (currentLight < requiredLight * 0.3)
        issues.add('Risque d\'étiolement');
    } else {
      score = 1.0 - ((currentLight - requiredLight) / requiredLight * 0.3);
      status = currentLight > requiredLight * 1.5 ? 'suboptimal' : 'good';
      description = 'Lumière excessive (${(currentLight * 100).toInt()}%)';
      if (currentLight > requiredLight * 1.4)
        issues.add('Risque de brûlures foliaires');
    }

    return ConditionFactor(
      name: 'Exposition lumineuse',
      score: score,
      status: status,
      description: description,
      currentValue: currentLight * 100,
      optimalRange:
          '${(requiredLight * 0.8 * 100).toInt()}-${(requiredLight * 1.2 * 100).toInt()}%',
      issues: issues,
      recommendations:
          _getLightRecommendations(currentLight, requiredLight, issues),
    );
  }

  /// Analyse spécifique du sol RAFFINÉE
  ///
  /// Amélioration Prompt 4 : Utilise culturalTips et données réelles
  ConditionFactor _analyzeSoilRefined(PlantFreezed plant,
      CompositePlantCondition condition, GardenContext garden) {
    final soilPh = condition.soilPh;
    final optimalPh = _getOptimalPhRange(plant);
    final soilType = garden.soil.type; // Accès via garden.soil.type

    double score;
    String status;
    String description;
    List<String> issues = [];

    if (soilPh >= optimalPh['min']! && soilPh <= optimalPh['max']!) {
      score = 0.8; // Base score pour pH optimal
      status = 'good';
      description = 'pH du sol approprié (${soilPh.toStringAsFixed(1)})';
    } else {
      final deviation = (soilPh < optimalPh['min']!)
          ? optimalPh['min']! - soilPh
          : soilPh - optimalPh['max']!;
      score = (0.8 - (deviation * 0.2)).clamp(0.0, 0.8);
      status = deviation > 1.5 ? 'critical' : 'suboptimal';
      description = soilPh < optimalPh['min']!
          ? 'Sol trop acide (pH ${soilPh.toStringAsFixed(1)})'
          : 'Sol trop alcalin (pH ${soilPh.toStringAsFixed(1)})';
      issues.add('Absorption des nutriments réduite');
    }

    // Ajustement selon le type de sol
    // Convert SoilType from garden_context to condition_enums
    final mappedSoilType = _mapSoilType(soilType);
    final soilTypeScore = _evaluateSoilType(plant, mappedSoilType);
    score = (score + soilTypeScore) / 2;

    return ConditionFactor(
      name: 'Qualité du sol',
      score: score,
      status: status,
      description: description,
      currentValue: soilPh,
      optimalRange:
          'pH ${optimalPh['min']!.toStringAsFixed(1)}-${optimalPh['max']!.toStringAsFixed(1)}',
      issues: issues,
      recommendations:
          _getSoilRecommendations(soilPh, optimalPh, mappedSoilType, issues),
    );
  }

  /// Analyse spécifique de la nutrition RAFFINÉE
  ///
  /// Amélioration Prompt 4 : Scoring précis basé sur besoins réels
  ConditionFactor _analyzeNutritionRefined(
      PlantFreezed plant, CompositePlantCondition condition) {
    final soilNutrients = condition.soilNutrients;
    final nutritionNeeds = _getNutritionNeedsLevel(plant);

    double score;
    String status;
    String description;
    List<String> issues = [];

    if (soilNutrients >= nutritionNeeds * 0.7) {
      score = (soilNutrients / nutritionNeeds).clamp(0.7, 1.0);
      status = soilNutrients >= nutritionNeeds ? 'optimal' : 'good';
      description = 'Niveau nutritionnel satisfaisant';
    } else if (soilNutrients >= nutritionNeeds * 0.4) {
      score = soilNutrients / nutritionNeeds;
      status = 'suboptimal';
      description = 'Niveau nutritionnel faible';
      issues.add('Croissance potentiellement ralentie');
    } else {
      score = soilNutrients / nutritionNeeds;
      status = 'critical';
      description = 'Carence nutritionnelle sévère';
      issues.add('Risque de déficiences visibles');
      issues.add('Croissance fortement impactée');
    }

    return ConditionFactor(
      name: 'Nutrition',
      score: score,
      status: status,
      description: description,
      currentValue: soilNutrients * 100,
      optimalRange: '${(nutritionNeeds * 0.7 * 100).toInt()}-100%',
      issues: issues,
      recommendations:
          _getNutritionRecommendations(soilNutrients, nutritionNeeds, issues),
    );
  }

  /// Analyse spécifique de la santé générale RAFFINÉE
  ///
  /// Amélioration Prompt 4 : Évaluation détaillée de la santé
  ConditionFactor _analyzeHealthRefined(
      PlantFreezed plant, CompositePlantCondition condition) {
    final healthScore = condition.healthScore;

    String status;
    String description;
    List<String> issues = [];

    if (healthScore >= 0.8) {
      status = 'optimal';
      description = 'Plante en excellente santé';
    } else if (healthScore >= 0.6) {
      status = 'good';
      description = 'Plante en bonne santé';
    } else if (healthScore >= 0.4) {
      status = 'suboptimal';
      description = 'Signes de stress visibles';
      issues.add('Surveillance accrue recommandée');
    } else {
      status = 'critical';
      description = 'Plante en détresse';
      issues.add('Intervention urgente nécessaire');
      issues.add('Risque de perte de la plante');
    }

    return ConditionFactor(
      name: 'Santé générale',
      score: healthScore,
      status: status,
      description: description,
      currentValue: healthScore * 100,
      optimalRange: '80-100%',
      issues: issues,
      recommendations: _getHealthRecommendations(healthScore, issues),
    );
  }

  /// Calcule le score global pondéré OPTIMISÉ
  ///
  /// Amélioration Prompt 4 : Pondération affinée et scoring plus précis
  double _calculateOptimizedOverallScore(List<ConditionFactor> factors) {
    // Pondération AFFINÉE selon importance agronomique (Prompt 4)
    const weights = {
      'Température': 0.25, // Augmenté (facteur critique)
      'Humidité du sol': 0.25, // Maintenu (très important)
      'Exposition lumineuse': 0.20, // Maintenu
      'Qualité du sol': 0.15, // Maintenu
      'Nutrition': 0.10, // Maintenu
      'Santé générale': 0.05, // Réduit (résultante des autres)
    };

    double weightedSum = 0.0;
    double totalWeight = 0.0;
    double penaltyFactor = 1.0;

    for (final factor in factors) {
      final weight = weights[factor.name] ?? 0.1;
      weightedSum += factor.score * weight;
      totalWeight += weight;

      // Pénalité si facteur critique (amélioration scoring)
      if (factor.status == 'critical' && weight >= 0.2) {
        penaltyFactor *= 0.8; // Réduction de 20%
      }
    }

    final baseScore = totalWeight > 0 ? weightedSum / totalWeight : 0.0;
    final finalScore = baseScore * penaltyFactor;

    _logDebug('🎯 Score calculé: base=${baseScore.toStringAsFixed(2)}, '
        'pénalité=${penaltyFactor.toStringAsFixed(2)}, '
        'final=${finalScore.toStringAsFixed(2)}');

    return finalScore.clamp(0.0, 1.0);
  }

  /// Identifie les risques actuels AMÉLIORÉS
  ///
  /// Amélioration Prompt 4 : Détection précise basée sur données réelles
  List<String> _identifyRisksEnhanced(
      PlantFreezed plant,
      CompositePlantCondition condition,
      CompositeWeatherData weather,
      GardenContext garden) {
    final risks = <String>[];

    // Risques liés à la température (basés sur données plants.json)
    final minTemp = plant.minGerminationTemperature ??
        plant.growth?['minTemperature'] ??
        10.0;
    if (weather.currentTemperature < minTemp) {
      final severity =
          weather.currentTemperature < minTemp - 5 ? 'CRITIQUE' : 'élevé';
      risks.add(
          'Risque de froid $severity (${weather.currentTemperature.toStringAsFixed(1)}°C < ${minTemp.toStringAsFixed(1)}°C)');
    }

    if (weather.currentTemperature < 2 && _isFrostSensitiveFromData(plant)) {
      risks.add('⚠️ Risque de gel imminent pour ${plant.commonName}');
    }

    // Risques liés à l'humidité (basés sur waterNeeds réels)
    final waterNeeds = _getWaterNeedsLevel(plant);
    if (condition.soilMoisture < waterNeeds * 0.3) {
      risks.add(
          'Déshydratation CRITIQUE (${(condition.soilMoisture * 100).toInt()}% < ${(waterNeeds * 30).toInt()}%)');
    } else if (condition.soilMoisture < waterNeeds * 0.6) {
      risks.add('Stress hydrique modéré - arrosage recommandé');
    }

    if (condition.soilMoisture > waterNeeds * 1.5) {
      risks.add('Excès d\'eau - risque de pourriture des racines');
    }

    // Risques liés à la santé
    if (condition.healthScore < 0.4) {
      risks.add('⚠️ État critique - intervention URGENTE requise');
    } else if (condition.healthScore < 0.6) {
      risks.add('Santé dégradée - surveillance accrue nécessaire');
    }

    // Risques météorologiques (vent)
    if (weather.windSpeed > 50) {
      final isWindSensitive =
          plant.family.toLowerCase().contains('solanaceae') ||
              plant.family.toLowerCase().contains('fabaceae');
      if (isWindSensitive) {
        risks.add('Vents violents - risque de casse pour ${plant.commonName}');
      }
    }

    _logDebug('⚠️ ${risks.length} risques identifiés pour ${plant.commonName}');
    return risks;
  }

  /// Identifie les opportunités d'amélioration AMÉLIORÉES
  ///
  /// Amélioration Prompt 4 : Opportunités personnalisées et actionnables
  List<String> _identifyOpportunitiesEnhanced(
      PlantFreezed plant,
      CompositePlantCondition condition,
      CompositeWeatherData weather,
      GardenContext garden) {
    final opportunities = <String>[];

    // Opportunités d'optimisation de la lumière
    final requiredLight = _getLightRequirement(plant);
    if (condition.lightExposure < requiredLight * 0.7) {
      opportunities.add(
          '💡 Améliorer l\'exposition lumineuse vers: ${plant.sunExposure}');
    }

    // Opportunités nutritionnelles
    if (condition.soilNutrients < 0.6) {
      // Utiliser biologicalControl depuis plants.json
      final bioControl = plant.biologicalControl;
      if (bioControl != null && bioControl['preparations'] != null) {
        final preps = (bioControl['preparations'] as List).take(2).join(', ');
        opportunities.add('🌿 Enrichir avec: $preps');
      } else {
        opportunities.add('🌿 Enrichir le sol en nutriments organiques');
      }
    }

    // Opportunités saisonnières PERSONNALISÉES
    final season = _getCurrentSeason();
    final now = DateTime.now();
    const monthCodes = [
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D'
    ];
    final currentMonthCode = monthCodes[now.month - 1];

    if (season == Season.spring && condition.healthScore > 0.7) {
      if (plant.sowingMonths.contains(currentMonthCode)) {
        opportunities.add('🌱 Période OPTIMALE pour semer ${plant.commonName}');
      }
      opportunities
          .add('✨ Conditions favorables pour fertilisation printanière');
    }

    // Opportunités liées aux conditions météo favorables
    if (weather.currentTemperature >= 15 &&
        weather.currentTemperature <= 25 &&
        weather.humidity >= 50 &&
        weather.humidity <= 70 &&
        plant.sowingMonths.contains(currentMonthCode)) {
      opportunities.add('⭐ Conditions IDÉALES pour plantation/semis');
    }

    _logDebug(
        '💡 ${opportunities.length} opportunités identifiées pour ${plant.commonName}');
    return opportunities;
  }

  /// Détermine le statut global
  String _determineOverallStatus(double score, List<String> risks) {
    if (risks
        .any((risk) => risk.contains('critique') || risk.contains('urgent'))) {
      return 'critical';
    }

    if (score >= 0.8) return 'optimal';
    if (score >= 0.6) return 'good';
    if (score >= 0.4) return 'suboptimal';
    return 'critical';
  }

  /// Calcule la confiance de l'analyse
  double _calculateConfidence(
      CompositePlantCondition condition, CompositeWeatherData weather) {
    double confidence = 0.8; // Base de confiance

    // Réduction si données manquantes ou anciennes
    final dataAge = DateTime.now().difference(condition.lastUpdated).inHours;
    if (dataAge > 24) confidence -= 0.2;
    if (dataAge > 48) confidence -= 0.2;

    // Réduction si forecast insuffisant
    if (weather.forecast.length < 3) confidence -= 0.1;

    return confidence.clamp(0.3, 1.0);
  }

  /// Génère des recommandations CONCRÈTES et ACTIONNABLES
  ///
  /// Amélioration Prompt 4 : Actions spécifiques basées sur données plants.json
  List<String> _generateActionableRecommendations(
    PlantFreezed plant,
    List<String> risks,
    List<String> opportunities,
    CompositePlantCondition condition,
    CompositeWeatherData weather,
    GardenContext garden,
  ) {
    final recommendations = <String>[];

    // Recommandations URGENTES basées sur les risques critiques
    for (final risk in risks) {
      if (risk.contains('gel') || risk.contains('CRITIQUE')) {
        if (risk.contains('gel')) {
          recommendations.add(
              '🚨 URGENT: Protéger du gel (voile P17/P30, rentrer en pot, pailler 15cm)');
        }
        if (risk.contains('Déshydratation')) {
          final wateringData = plant.watering;
          if (wateringData != null) {
            final amount = wateringData['amount'] ?? '3-5 litres';
            final method = wateringData['method'] ?? 'au pied';
            recommendations.add('🚨 URGENT: Arroser $amount $method');
          } else {
            recommendations.add('🚨 URGENT: Arroser abondamment immédiatement');
          }
        }
        if (risk.contains('pourriture')) {
          recommendations.add(
              '⚠️ Suspendre arrosage, vérifier drainage, enlever feuilles malades');
        }
      }
    }

    // Recommandations PRÉVENTIVES basées sur risques modérés
    for (final risk in risks.where((r) => !r.contains('CRITIQUE'))) {
      if (risk.contains('Stress hydrique')) {
        final wateringData = plant.watering;
        final frequency = wateringData?['frequency'] ?? '2-3 fois/semaine';
        recommendations
            .add('💧 Arroser: $frequency (besoins: ${plant.waterNeeds})');
      }

      if (risk.contains('Santé dégradée')) {
        recommendations
            .add('🔍 Inspecter feuilles/tiges, rechercher parasites/maladies');
      }

      if (risk.contains('vent') || risk.contains('casse')) {
        recommendations
            .add('🌿 Tuteurer solidement, renforcer supports existants');
      }
    }

    // Recommandations D'OPTIMISATION basées sur opportunités
    for (final opportunity in opportunities.take(3)) {
      if (opportunity.contains('lumière')) {
        final sunExposure = plant.sunExposure;
        recommendations
            .add('☀️ Optimiser exposition ($sunExposure recommandé)');
      }

      if (opportunity.contains('Enrichir avec:')) {
        // Déjà détaillé dans opportunity
        recommendations.add('✅ ${opportunity.replaceAll('🌿 ', '')}');
      }

      if (opportunity.contains('OPTIMALE pour semer')) {
        final sowingTips = plant.culturalTips
            ?.where((tip) =>
                tip.toLowerCase().contains('semis') ||
                tip.toLowerCase().contains('sow'))
            .firstOrNull;

        if (sowingTips != null) {
          recommendations.add('🌱 Conseil semis: $sowingTips');
        } else {
          recommendations.add('🌱 ${opportunity.replaceAll('🌱 ', '')}');
        }
      }

      if (opportunity.contains('fertilisation')) {
        recommendations
            .add('🌿 Apporter compost mûr ou engrais organique équilibré NPK');
      }
    }

    _logDebug('✅ ${recommendations.length} recommandations générées');
    return recommendations.take(5).toList(); // Limiter à 5 recommandations max
  }

  // Méthodes utilitaires et de validation

  void _validateInputs(PlantFreezed plant, CompositePlantCondition condition,
      CompositeWeatherData weather, GardenContext garden) {
    if (plant.id.isEmpty) {
      throw ArgumentError('L\'ID de la plante ne peut pas être vide');
    }

    if (condition.plantId != plant.id) {
      throw ArgumentError('Les conditions ne correspondent pas à la plante');
    }

    if (garden.gardenId.isEmpty) {
      throw ArgumentError('L\'ID du jardin ne peut pas être vide');
    }

    // Vérifier fraîcheur des données météo
    final weatherAge = DateTime.now().difference(weather.timestamp);
    if (weatherAge.inHours > 24) {
      _logDebug('⚠️ Données météo anciennes: ${weatherAge.inHours}h');
    }
  }

  /// Obtient la plage de température optimale DEPUIS DONNÉES RÉELLES
  ///
  /// Amélioration Prompt 4 : Extraction depuis germination.optimalTemperature
  Map<String, double> _getOptimalTemperatureRangeFromData(PlantFreezed plant) {
    // Priorité 1: Données de germination depuis plants.json
    if (plant.germination != null) {
      final optimalTemp = plant.germination!['optimalTemperature'];

      if (optimalTemp != null && optimalTemp is Map) {
        final min = (optimalTemp['min'] as num?)?.toDouble();
        final max = (optimalTemp['max'] as num?)?.toDouble();

        if (min != null && max != null) {
          return {'min': min, 'max': max};
        }
      }

      // Fallback sur temperature simple
      final baseTemp = plant.germination!['temperature'] as num?;
      if (baseTemp != null) {
        return {
          'min': baseTemp.toDouble() - 5,
          'max': baseTemp.toDouble() + 10
        };
      }
    }

    // Priorité 2: Données de croissance
    if (plant.growth != null) {
      final idealTemp = plant.growth!['idealTemperature'];
      if (idealTemp != null && idealTemp is Map) {
        final min = (idealTemp['min'] as num?)?.toDouble();
        final max = (idealTemp['max'] as num?)?.toDouble();

        if (min != null && max != null) {
          return {'min': min, 'max': max};
        }
      }
    }

    // Fallback selon la famille (si pas de données spécifiques)
    if (plant.family.toLowerCase().contains('solanaceae')) {
      return {'min': 15.0, 'max': 30.0}; // Tomates, poivrons
    } else if (plant.family.toLowerCase().contains('brassicaceae')) {
      return {'min': 10.0, 'max': 25.0}; // Choux, radis
    } else if (plant.family.toLowerCase().contains('cucurbitaceae')) {
      return {'min': 18.0, 'max': 30.0}; // Courges, concombres
    }

    return {'min': 12.0, 'max': 28.0}; // Par défaut
  }

  /// Legacy (conservée pour compatibilité)
  Map<String, double> _getOptimalTemperatureRange(PlantFreezed plant) {
    return _getOptimalTemperatureRangeFromData(plant);
  }

  double _getWaterNeedsLevel(PlantFreezed plant) {
    final waterNeeds = plant.waterNeeds.toLowerCase();
    if (waterNeeds.contains('faible')) return 0.3;
    if (waterNeeds.contains('élevé')) return 0.8;
    return 0.5; // Moyen
  }

  double _getLightRequirement(PlantFreezed plant) {
    // PlantFreezed a sunExposure, pas lightNeeds
    final sunExposure = plant.sunExposure.toLowerCase();
    if (sunExposure.contains('plein soleil')) return 1.0;
    if (sunExposure.contains('mi-ombre')) return 0.6;
    if (sunExposure.contains('ombre')) return 0.3;
    return 0.7; // Par défaut
  }

  Map<String, double> _getOptimalPhRange(PlantFreezed plant) {
    // pH optimal selon la famille de plante
    if (plant.family.toLowerCase().contains('ericaceae')) {
      return {'min': 4.5, 'max': 6.0}; // Plantes acidophiles
    } else if (plant.family.toLowerCase().contains('brassicaceae')) {
      return {'min': 6.0, 'max': 7.5}; // Choux
    }

    return {'min': 6.0, 'max': 7.0}; // Neutre par défaut
  }

  double _evaluateSoilType(PlantFreezed plant, SoilType soilType) {
    // Évaluation selon les préférences de la plante
    switch (soilType) {
      case SoilType.sandy:
        return plant.waterNeeds.toLowerCase().contains('faible') ? 0.9 : 0.6;
      case SoilType.clay:
        return plant.waterNeeds.toLowerCase().contains('élevé') ? 0.8 : 0.5;
      case SoilType.loamy:
        return 0.9; // Idéal pour la plupart des plantes
      default:
        return 0.7;
    }
  }

  double _getNutritionNeedsLevel(PlantFreezed plant) {
    // PlantFreezed n'a pas nutritionNeeds, on utilise waterNeeds comme proxy
    // Les plantes gourmandes en eau sont souvent gourmandes en nutriments
    final waterNeeds = plant.waterNeeds.toLowerCase();
    if (waterNeeds.contains('faible')) return 0.4;
    if (waterNeeds.contains('élevé')) return 0.7;
    return 0.5; // Moyen par défaut
  }

  /// Détermine si une plante est sensible au gel DEPUIS DONNÉES RÉELLES
  ///
  /// Amélioration Prompt 4 : Basé sur températures minimales plants.json
  bool _isFrostSensitiveFromData(PlantFreezed plant) {
    // Vérifier température minimale de germination
    if (plant.minGerminationTemperature != null &&
        plant.minGerminationTemperature! > 10.0) {
      return true;
    }

    // Vérifier température minimale de croissance
    if (plant.growth != null) {
      final minTemp = plant.growth!['minTemperature'] as num?;
      if (minTemp != null && minTemp.toDouble() > 10.0) {
        return true;
      }
    }

    // Vérifier les alertes de température dans notificationSettings
    final tempAlert = plant.notificationSettings?['temperature_alert']
        as Map<String, dynamic>?;
    final coldAlert = tempAlert?['cold_alert'] as Map<String, dynamic>?;
    if (coldAlert != null) {
      final threshold = (coldAlert['threshold'] as num?)?.toDouble();
      if (threshold != null && threshold > 8.0) {
        return true;
      }
    }

    return false;
  }

  /// Legacy (conservée pour compatibilité)
  bool _isFrostSensitive(PlantFreezed plant) {
    return _isFrostSensitiveFromData(plant);
  }

  Season _getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  // Méthodes de génération de recommandations spécifiques

  List<String> _getTemperatureRecommendations(double currentTemp,
      Map<String, double> optimalRange, List<String> issues) {
    final recommendations = <String>[];

    if (currentTemp < optimalRange['min']!) {
      recommendations.add('Protéger du froid (voile, serre, paillis)');
      if (currentTemp < 0) recommendations.add('Protection antigel urgente');
    } else if (currentTemp > optimalRange['max']!) {
      recommendations.add('Ombrager pendant les heures chaudes');
      recommendations.add('Augmenter la fréquence d\'arrosage');
    }

    return recommendations;
  }

  List<String> _getMoistureRecommendations(double soilMoisture,
      double waterNeeds, double recentRain, List<String> issues) {
    final recommendations = <String>[];

    if (soilMoisture < waterNeeds * 0.6) {
      recommendations.add('Arroser abondamment');
      if (recentRain < 5)
        recommendations.add('Installer un système d\'arrosage automatique');
    } else if (soilMoisture > waterNeeds * 1.3) {
      recommendations.add('Suspendre l\'arrosage temporairement');
      recommendations.add('Améliorer le drainage du sol');
    }

    return recommendations;
  }

  List<String> _getLightRecommendations(
      double currentLight, double requiredLight, List<String> issues) {
    final recommendations = <String>[];

    if (currentLight < requiredLight * 0.7) {
      recommendations.add('Déplacer vers un endroit plus lumineux');
      recommendations.add('Tailler la végétation environnante');
    } else if (currentLight > requiredLight * 1.4) {
      recommendations.add('Installer un ombrage partiel');
    }

    return recommendations;
  }

  List<String> _getSoilRecommendations(double soilPh,
      Map<String, double> optimalPh, SoilType soilType, List<String> issues) {
    final recommendations = <String>[];

    if (soilPh < optimalPh['min']!) {
      recommendations.add('Amender avec de la chaux pour augmenter le pH');
    } else if (soilPh > optimalPh['max']!) {
      recommendations.add('Amender avec du soufre ou compost acide');
    }

    if (soilType == SoilType.clay) {
      recommendations.add('Améliorer le drainage avec du sable ou compost');
    } else if (soilType == SoilType.sandy) {
      recommendations.add('Enrichir avec du compost pour retenir l\'eau');
    }

    return recommendations;
  }

  List<String> _getNutritionRecommendations(
      double soilNutrients, double nutritionNeeds, List<String> issues) {
    final recommendations = <String>[];

    if (soilNutrients < nutritionNeeds * 0.6) {
      recommendations.add('Apporter un engrais équilibré');
      recommendations.add('Enrichir avec du compost mûr');
    }

    return recommendations;
  }

  List<String> _getHealthRecommendations(
      double healthScore, List<String> issues) {
    final recommendations = <String>[];

    if (healthScore < 0.5) {
      recommendations.add('Inspection détaillée pour identifier les problèmes');
      recommendations.add('Consulter un expert en jardinage si nécessaire');
    }

    return recommendations;
  }

  // ============================================================================
  // MÉTHODES DE LOGGING (Amélioration Prompt 4)
  // ============================================================================

  /// Log de debugging (peut être désactivé en production)
  void _logDebug(String message) {
    if (_loggingEnabled) {
      developer.log(message, name: 'PlantConditionAnalyzer', level: 500);
    }
  }

  /// Log d'erreur (toujours actif)
  void _logError(String message) {
    developer.log(message, name: 'PlantConditionAnalyzer', level: 1000);
    print('[PlantConditionAnalyzer] $message');
  }

  /// Map SoilType from garden_context to condition_enums
  ///
  /// NOTE Prompt 4: Mapper temporaire pour résoudre l'ambiguïté entre deux SoilType
  SoilType _mapSoilType(garden_ctx.SoilType gardenSoilType) {
    switch (gardenSoilType) {
      case garden_ctx.SoilType.sandy:
        return SoilType.sandy;
      case garden_ctx.SoilType.clay:
        return SoilType.clay;
      case garden_ctx.SoilType.loamy:
        return SoilType.loamy;
      case garden_ctx.SoilType.silty:
        return SoilType.loamy; // Silty mapped to loamy (similar properties)
      case garden_ctx.SoilType.peaty:
        return SoilType.peaty;
      case garden_ctx.SoilType.chalky:
        return SoilType.chalky;
      case garden_ctx.SoilType.rocky:
        return SoilType.sandy; // Rocky mapped to sandy (drainage)
    }
  }

  /// Active ou désactive le logging
  static void setLogging(bool enabled) {
    _loggingEnabled = enabled;
  }
}

/// Résultat de l'analyse des conditions
class ConditionAnalysisResult {
  final String plantId;
  final String plantName;
  final double overallScore;
  final String status;
  final ConditionFactor temperatureAnalysis;
  final ConditionFactor moistureAnalysis;
  final ConditionFactor lightAnalysis;
  final ConditionFactor soilAnalysis;
  final ConditionFactor nutritionAnalysis;
  final ConditionFactor healthAnalysis;
  final List<String> risks;
  final List<String> opportunities;
  final DateTime analyzedAt;
  final double confidence;
  final List<String> recommendations;

  const ConditionAnalysisResult({
    required this.plantId,
    required this.plantName,
    required this.overallScore,
    required this.status,
    required this.temperatureAnalysis,
    required this.moistureAnalysis,
    required this.lightAnalysis,
    required this.soilAnalysis,
    required this.nutritionAnalysis,
    required this.healthAnalysis,
    required this.risks,
    required this.opportunities,
    required this.analyzedAt,
    required this.confidence,
    required this.recommendations,
  });
}

/// Facteur de condition individuel
class ConditionFactor {
  final String name;
  final double score;
  final String status;
  final String description;
  final double currentValue;
  final String optimalRange;
  final List<String> issues;
  final List<String> recommendations;

  const ConditionFactor({
    required this.name,
    required this.score,
    required this.status,
    required this.description,
    required this.currentValue,
    required this.optimalRange,
    required this.issues,
    required this.recommendations,
  });
}

/// Énumération des saisons
enum Season { spring, summer, autumn, winter }

/// Exception spécifique pour les erreurs d'analyse des conditions
class PlantConditionAnalysisException implements Exception {
  final String message;
  const PlantConditionAnalysisException(this.message);

  @override
  String toString() => 'PlantConditionAnalysisException: $message';
}
