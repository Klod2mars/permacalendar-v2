import 'dart:developer' as developer;
import 'package:permacalendar/features/plant_intelligence/domain/entities/condition_models.dart'
    show WeatherForecast;
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/core/services/models/composite_weather_data.dart';

// NOTE Prompt 4: Utilisation de modèles composites helper temporaires
// TODO Prompt futur: Remplacer par entités domain composites officielles

/// Service d'analyse de l'impact météorologique sur les plantes
///
/// Service optimisé pour production avec:
/// - Alertes proactives personnalisées par plante
/// - Analyse des tendances météorologiques avec forecast
/// - Recommandations intelligentes basées sur données réelles
/// - Logging pour debugging et monitoring
class WeatherImpactAnalyzer {
  const WeatherImpactAnalyzer();

  /// Système d'alertes amélioré avec logging
  static bool _loggingEnabled = true;

  /// Analyse l'impact global de la météo sur les plantes
  ///
  /// [weather] - Les conditions météorologiques composites
  /// [plants] - Liste des plantes à analyser
  /// [garden] - Le contexte du jardin
  ///
  /// Retourne une analyse de l'impact météorologique
  ///
  /// NOTE Prompt 4: Utilise CompositeWeatherData helper temporaire
  Future<WeatherImpactAnalysis> analyzeImpact({
    required CompositeWeatherData weather,
    required List<PlantFreezed> plants,
    required GardenContext garden,
  }) async {
    _logDebug('🌤️ Début analyse impact météo (${plants.length} plantes)');
    final stopwatch = Stopwatch()..start();

    try {
      // Validation des paramètres d'entrée
      _validateInputs(weather, plants, garden);

      // Analyse des alertes météorologiques PROACTIVES (amélioration Prompt 4)
      final alerts = _detectWeatherAlertsProactive(weather, plants);
      _logDebug('⚠️ ${alerts.length} alertes détectées');

      // Analyse des tendances avec PRÉDICTIONS (amélioration Prompt 4)
      final trends = _analyzeWeatherTrendsWithForecast(weather);
      _logDebug(
          '📈 Tendances analysées (confiance: ${trends.confidence.toStringAsFixed(2)})');

      // Calcul du score d impact global OPTIMISE
      final impactScore = _calculateOptimizedImpactScore(weather, plants);
      _logDebug('Score d impact: ${impactScore.toStringAsFixed(2)}');

      // Génération des recommandations PERSONNALISÉES (amélioration Prompt 4)
      final recommendations =
          _generatePersonalizedRecommendations(weather, plants, alerts, garden);
      _logDebug('💡 ${recommendations.length} recommandations générées');

      stopwatch.stop();
      _logDebug(
          '✅ Analyse impact météo terminée (${stopwatch.elapsedMilliseconds}ms)');

      return WeatherImpactAnalysis(
        weatherId: weather.id,
        impactScore: impactScore,
        alerts: alerts,
        trends: trends,
        recommendations: recommendations,
        analyzedAt: DateTime.now(),
        confidence: _calculateConfidence(weather),
      );
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logError(
          '❌ Erreur analyse impact météo (${stopwatch.elapsedMilliseconds}ms): $e');
      developer.log(
        'Erreur analyse impact météorologique',
        error: e,
        stackTrace: stackTrace,
        name: 'WeatherImpactAnalyzer',
      );
      throw Exception(
          'Erreur lors de l\'analyse de l\'impact météorologique: $e');
    }
  }

  /// Valide les paramètres d'entrée
  void _validateInputs(CompositeWeatherData weather, List<PlantFreezed> plants,
      GardenContext garden) {
    if (weather.id.isEmpty) {
      throw ArgumentError('L\'ID de la condition météo ne peut pas être vide');
    }

    if (garden.gardenId.isEmpty) {
      throw ArgumentError('L\'ID du jardin ne peut pas être vide');
    }

    if (plants.isEmpty) {
      throw ArgumentError('Aucune plante fournie pour l\'analyse');
    }

    // Vérifier fraîcheur des données météo
    final weatherAge = DateTime.now().difference(weather.timestamp);
    if (weatherAge.inHours > 24) {
      _logDebug('⚠️ Données météo anciennes: ${weatherAge.inHours}h');
    }
  }

  /// Détecte les alertes météorologiques PROACTIVES basées sur les données réelles
  ///
  /// Amélioration Prompt 4 : Alertes personnalisées par plante avec données plants.json
  List<WeatherAlert> _detectWeatherAlertsProactive(
      CompositeWeatherData weather, List<PlantFreezed> plants) {
    final alerts = <WeatherAlert>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // ALERTE GEL - Personnalisée par plante
    if (weather.currentTemperature < 5) {
      final frostSensitivePlants = _getFrostSensitivePlantsFromData(plants);

      if (frostSensitivePlants.isNotEmpty) {
        final severity = weather.currentTemperature < 0
            ? WeatherAlertSeverity.critical
            : WeatherAlertSeverity.high;

        alerts.add(WeatherAlert(
          id: 'frost_$timestamp',
          type: WeatherAlertType.frost,
          severity: severity,
          title:
              'Risque de gel ${weather.currentTemperature < 0 ? "CRITIQUE" : "imminent"}',
          description:
              'Température: ${weather.currentTemperature.toStringAsFixed(1)}°C. '
              '${frostSensitivePlants.length} plante(s) sensible(s) au gel à protéger.',
          affectedPlants:
              frostSensitivePlants.map((p) => p.commonName).toList(),
          recommendedActions: _getGelProtectionActions(
              frostSensitivePlants, weather.currentTemperature),
          validUntil: DateTime.now().add(const Duration(hours: 12)),
          createdAt: DateTime.now(),
        ));
      }
    }

    // ALERTE SÉCHERESSE - Basée sur besoins en eau réels
    if (weather.humidity < 30 ||
        (weather.precipitation == 0 && weather.currentTemperature > 25)) {
      final waterSensitivePlants = _getWaterSensitivePlantsFromData(plants);

      if (waterSensitivePlants.isNotEmpty) {
        alerts.add(WeatherAlert(
          id: 'drought_$timestamp',
          type: WeatherAlertType.drought,
          severity: WeatherAlertSeverity.medium,
          title: 'Risque de sécheresse',
          description: 'Humidité: ${weather.humidity.toStringAsFixed(0)}%, '
              'Temp: ${weather.currentTemperature.toStringAsFixed(1)}°C. '
              '${waterSensitivePlants.length} plante(s) nécessite(nt) arrosage.',
          affectedPlants:
              waterSensitivePlants.map((p) => p.commonName).toList(),
          recommendedActions: _getWateringActions(waterSensitivePlants),
          validUntil: DateTime.now().add(const Duration(days: 2)),
          createdAt: DateTime.now(),
        ));
      }
    }

    // ALERTE TEMPÊTE - Plantes hautes et fragiles
    if (weather.windSpeed > 40) {
      final windSensitivePlants = _getWindSensitivePlantsFromData(plants);

      if (windSensitivePlants.isNotEmpty) {
        final severity = weather.windSpeed > 60
            ? WeatherAlertSeverity.critical
            : WeatherAlertSeverity.high;

        alerts.add(WeatherAlert(
          id: 'storm_$timestamp',
          type: WeatherAlertType.storm,
          severity: severity,
          title: 'Vents ${weather.windSpeed > 60 ? "violents" : "forts"}',
          description:
              'Vitesse du vent: ${weather.windSpeed.toStringAsFixed(0)} km/h. '
              '${windSensitivePlants.length} plante(s) à protéger.',
          affectedPlants: windSensitivePlants.map((p) => p.commonName).toList(),
          recommendedActions:
              _getWindProtectionActions(windSensitivePlants, weather.windSpeed),
          validUntil: DateTime.now().add(const Duration(hours: 8)),
          createdAt: DateTime.now(),
        ));
      }
    }

    // ALERTE CANICULE - Protection contre stress thermique
    if (weather.currentTemperature > 32) {
      alerts.add(WeatherAlert(
        id: 'heat_$timestamp',
        type: WeatherAlertType.heat,
        severity: weather.currentTemperature > 38
            ? WeatherAlertSeverity.critical
            : WeatherAlertSeverity.high,
        title: 'Canicule',
        description:
            'Température extrême: ${weather.currentTemperature.toStringAsFixed(1)}°C. '
            'Risque de stress thermique pour toutes les plantes.',
        affectedPlants: plants.map((p) => p.commonName).toList(),
        recommendedActions: [
          'Arroser abondamment tôt le matin',
          'Installer des ombrages temporaires',
          'Pailler généreusement pour conserver l\'humidité',
          'Éviter toute fertilisation ou taille',
        ],
        validUntil: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ));
    }

    return alerts;
  }

  /// Analyse les tendances météorologiques avec PRÉDICTIONS
  ///
  /// Amélioration Prompt 4 : Utilise le forecast pour prédire les tendances
  WeatherTrends _analyzeWeatherTrendsWithForecast(
      CompositeWeatherData weather) {
    _logDebug(
        '📈 Analyse des tendances météo (forecast: ${weather.forecast.length} jours)');

    // Analyse des tendances de température
    final tempTrend = _analyzeTrend(
      weather.currentTemperature,
      weather.minTemperature,
      weather.maxTemperature,
      weather.forecast
          .map((f) => (f.minTemperature + f.maxTemperature) / 2.0)
          .toList(),
    );

    // Analyse des tendances d'humidité
    final humidityTrend = _analyzeTrend(
      weather.humidity,
      weather.humidity * 0.8,
      weather.humidity * 1.2,
      weather.forecast.map((f) => f.humidity).toList(),
    );

    // Analyse des tendances de précipitations
    final precipTrend = _analyzePrecipitationTrend(
      weather.precipitation,
      weather.forecast,
    );

    // Analyse des tendances de vent
    final windTrend = _analyzeTrend(
      weather.windSpeed,
      weather.windSpeed * 0.8,
      weather.windSpeed * 1.2,
      weather.forecast.map((f) => f.windSpeed).toList(),
    );

    // Calcul de confiance basé sur la qualité du forecast
    final confidence = _calculateForecastConfidence(weather.forecast);

    _logDebug(
        '📊 Tendances: temp=${tempTrend.name}, hum=${humidityTrend.name}, '
        'precip=${precipTrend.name}, vent=${windTrend.name}');

    return WeatherTrends(
      temperatureTrend: tempTrend,
      humidityTrend: humidityTrend,
      precipitationTrend: precipTrend,
      windTrend: windTrend,
      confidence: confidence,
      analyzedAt: DateTime.now(),
    );
  }

  /// Analyse une tendance générique basée sur forecast
  WeatherTrend _analyzeTrend(
    double currentValue,
    double minThreshold,
    double maxThreshold,
    List<double> forecastValues,
  ) {
    if (forecastValues.isEmpty) return WeatherTrend.stable;

    // Calculer la tendance sur les prochains jours
    final futureAvg = forecastValues.take(3).reduce((a, b) => a + b) / 3;
    final diff = futureAvg - currentValue;

    if (diff > (maxThreshold - currentValue) * 0.3) {
      return WeatherTrend.increasing;
    } else if (diff < (minThreshold - currentValue) * 0.3) {
      return WeatherTrend.decreasing;
    } else if (diff.abs() > currentValue * 0.1) {
      return WeatherTrend.variable;
    }

    return WeatherTrend.stable;
  }

  /// Analyse spécifique des précipitations
  WeatherTrend _analyzePrecipitationTrend(
    double currentPrecip,
    List<WeatherForecast> forecast,
  ) {
    if (forecast.isEmpty) return WeatherTrend.stable;

    final futurePrecip =
        forecast.take(3).map((f) => f.precipitation).reduce((a, b) => a + b);

    if (futurePrecip > 20) {
      return WeatherTrend.increasing;
    } else if (futurePrecip < 5 && currentPrecip < 2) {
      return WeatherTrend.decreasing;
    }

    return WeatherTrend.stable;
  }

  /// Calcule la confiance du forecast
  double _calculateForecastConfidence(List<WeatherForecast> forecast) {
    if (forecast.isEmpty) return 0.5;
    if (forecast.length >= 7) return 0.9;
    if (forecast.length >= 3) return 0.8;
    return 0.6;
  }

  /// Calcule le score d'impact global OPTIMISÉ
  ///
  /// Amélioration Prompt 4 : Score pondéré selon plusieurs facteurs météo
  double _calculateOptimizedImpactScore(
      CompositeWeatherData weather, List<PlantFreezed> plants) {
    double score = 0.5; // Score de base

    // Analyse multi-facteurs
    double tempScore = _evaluateTemperatureImpact(weather.currentTemperature);
    double humidityScore = _evaluateHumidityImpact(weather.humidity);
    double windScore = _evaluateWindImpact(weather.windSpeed);
    double precipScore = _evaluatePrecipitationImpact(weather.precipitation);

    // Pondération (température et humidité sont les plus critiques)
    score = (tempScore * 0.35) +
        (humidityScore * 0.30) +
        (precipScore * 0.20) +
        (windScore * 0.15);

    // Ajustement selon le nombre de plantes affectées
    final affectedCount = _countAffectedPlants(weather, plants);
    final affectedRatio =
        plants.isNotEmpty ? affectedCount / plants.length : 0.0;
    score *= (1.0 -
        (affectedRatio * 0.2)); // Réduction si beaucoup de plantes affectées

    return score.clamp(0.0, 1.0);
  }

  /// Évalue l'impact de la température
  double _evaluateTemperatureImpact(double temp) {
    if (temp >= 15 && temp <= 25) return 1.0; // Optimal
    if (temp >= 10 && temp <= 30) return 0.8; // Bon
    if (temp >= 5 && temp <= 35) return 0.5; // Acceptable
    if (temp < 0 || temp > 38) return 0.1; // Critique
    return 0.3; // Mauvais
  }

  /// Évalue l'impact de l'humidité
  double _evaluateHumidityImpact(double humidity) {
    if (humidity >= 50 && humidity <= 70) return 1.0; // Optimal
    if (humidity >= 40 && humidity <= 80) return 0.8; // Bon
    if (humidity >= 30 && humidity <= 90) return 0.5; // Acceptable
    if (humidity < 20 || humidity > 95) return 0.2; // Critique
    return 0.4; // Mauvais
  }

  /// Évalue l'impact du vent
  double _evaluateWindImpact(double windSpeed) {
    if (windSpeed <= 15) return 1.0; // Calme
    if (windSpeed <= 30) return 0.8; // Léger
    if (windSpeed <= 45) return 0.5; // Modéré
    if (windSpeed > 60) return 0.2; // Critique
    return 0.4; // Fort
  }

  /// Évalue l'impact des précipitations
  double _evaluatePrecipitationImpact(double precip) {
    if (precip >= 5 && precip <= 15) return 1.0; // Optimal
    if (precip >= 2 && precip <= 25) return 0.8; // Bon
    if (precip < 1) return 0.6; // Sec
    if (precip > 40) return 0.3; // Pluie excessive
    return 0.7; // Acceptable
  }

  /// Compte les plantes affectées négativement
  int _countAffectedPlants(
      CompositeWeatherData weather, List<PlantFreezed> plants) {
    int count = 0;

    for (final plant in plants) {
      if (_isPlantAffected(plant, weather)) {
        count++;
      }
    }

    return count;
  }

  /// Détermine si une plante est affectée négativement
  bool _isPlantAffected(PlantFreezed plant, CompositeWeatherData weather) {
    // Vérifier sensibilité au froid
    if (weather.currentTemperature < 10 &&
        (plant.minGerminationTemperature ?? 10) > 10) {
      return true;
    }

    // Vérifier besoins en eau vs humidité
    if (weather.humidity < 40 &&
        plant.waterNeeds.toLowerCase().contains('élevé')) {
      return true;
    }

    return false;
  }

  /// Génère des recommandations PERSONNALISÉES basées sur données réelles
  ///
  /// Amélioration Prompt 4 : Recommandations adaptées à chaque plante
  List<WeatherRecommendation> _generatePersonalizedRecommendations(
    CompositeWeatherData weather,
    List<PlantFreezed> plants,
    List<WeatherAlert> alerts,
    GardenContext garden,
  ) {
    _logDebug('💡 Génération recommandations personnalisées');
    final recommendations = <WeatherRecommendation>[];

    // Recommandations basées sur les alertes
    for (final alert in alerts) {
      recommendations.add(WeatherRecommendation(
        id: 'rec_${alert.id}',
        alertId: alert.id,
        title: 'Action recommandée: ${alert.title}',
        description: alert.description,
        priority: _mapSeverityToPriority(alert.severity),
        actions: alert.recommendedActions,
        estimatedEffort: _estimateEffort(alert.type),
        expectedBenefit: _getExpectedBenefit(alert.type),
        validUntil: alert.validUntil,
        createdAt: DateTime.now(),
      ));
    }

    // Recommandations personnalisées par type de plante
    final highWaterNeedsPlants = plants
        .where((p) => p.waterNeeds.toLowerCase().contains('élevé'))
        .toList();

    if (highWaterNeedsPlants.isNotEmpty &&
        weather.precipitation < 5 &&
        weather.currentTemperature > 20) {
      final plantNames =
          highWaterNeedsPlants.map((p) => p.commonName).take(3).join(', ');
      recommendations.add(WeatherRecommendation(
        id: 'water_high_needs_${DateTime.now().millisecondsSinceEpoch}',
        alertId: null,
        title: 'Arrosage recommandé pour plantes gourmandes',
        description:
            'Conditions sèches et chaudes. ${highWaterNeedsPlants.length} plante(s) '
            'à besoins élevés en eau: $plantNames${highWaterNeedsPlants.length > 3 ? "..." : ""}',
        priority: RecommendationPriority.high,
        actions: _getPersonalizedWateringActions(highWaterNeedsPlants),
        estimatedEffort: 'Moyen',
        expectedBenefit: 'Prévention du stress hydrique',
        validUntil: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ));
    }

    // Opportunités de plantation (conditions optimales)
    if (weather.currentTemperature >= 15 &&
        weather.currentTemperature <= 25 &&
        weather.humidity >= 50 &&
        weather.humidity <= 70) {
      final plantableNow = plants.where((p) => _isPlantableNow(p)).toList();

      if (plantableNow.isNotEmpty) {
        recommendations.add(WeatherRecommendation(
          id: 'optimal_planting_${DateTime.now().millisecondsSinceEpoch}',
          alertId: null,
          title: 'Conditions optimales de plantation',
          description:
              'Température et humidité idéales. ${plantableNow.length} plante(s) peuvent être plantées maintenant.',
          priority: RecommendationPriority.medium,
          actions: [
            'Profiter de ces conditions pour planter: ${plantableNow.take(3).map((p) => p.commonName).join(", ")}',
            'Préparer le sol avant les semis',
            'Arroser légèrement après plantation',
          ],
          estimatedEffort: 'Élevé',
          expectedBenefit: 'Germination optimale',
          validUntil: DateTime.now().add(const Duration(days: 2)),
          createdAt: DateTime.now(),
        ));
      }
    }

    return recommendations;
  }

  /// Calcule la confiance de l'analyse
  double _calculateConfidence(CompositeWeatherData weather) {
    double confidence = 0.8; // Confiance de base

    // Ajustement basé sur l'âge des données
    final dataAge = DateTime.now().difference(weather.timestamp);
    if (dataAge.inHours > 6) {
      confidence -= 0.2;
    }

    // Réduction si forecast insuffisant
    if (weather.forecast.length < 3) {
      confidence -= 0.1;
    }

    return confidence.clamp(0.0, 1.0);
  }

  // ============================================================================
  // MÉTHODES D'IDENTIFICATION BASÉES SUR DONNÉES RÉELLES (Amélioration Prompt 4)
  // ============================================================================

  /// Obtient les plantes sensibles au gel DEPUIS DONNÉES RÉELLES
  List<PlantFreezed> _getFrostSensitivePlantsFromData(
      List<PlantFreezed> plants) {
    return plants.where((plant) {
      // Sensible si température min de germination > 10°C
      if (plant.minGerminationTemperature != null &&
          plant.minGerminationTemperature! > 10) {
        return true;
      }

      // Ou si température min de croissance > 10°C
      if (plant.growth != null) {
        final minTemp = plant.growth!['minTemperature'] as num?;
        if (minTemp != null && minTemp.toDouble() > 10) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  /// Obtient les plantes sensibles au manque d'eau DEPUIS DONNÉES RÉELLES
  List<PlantFreezed> _getWaterSensitivePlantsFromData(
      List<PlantFreezed> plants) {
    return plants.where((plant) {
      final waterNeeds = plant.waterNeeds.toLowerCase();
      return waterNeeds.contains('élevé') || waterNeeds.contains('high');
    }).toList();
  }

  /// Obtient les plantes sensibles au vent DEPUIS DONNÉES RÉELLES
  List<PlantFreezed> _getWindSensitivePlantsFromData(
      List<PlantFreezed> plants) {
    return plants.where((plant) {
      // Plantes hautes et à tiges fragiles
      final commonName = plant.commonName.toLowerCase();
      final family = plant.family.toLowerCase();

      // Solanacées (tomates, etc.) et légumineuses (haricots, pois)
      if (family.contains('solanaceae') || family.contains('fabaceae')) {
        return true;
      }

      // Plantes hautes connues
      if (commonName.contains('tournesol') || commonName.contains('maïs')) {
        return true;
      }

      return false;
    }).toList();
  }

  /// Actions de protection contre le gel PERSONNALISÉES
  List<String> _getGelProtectionActions(
      List<PlantFreezed> plants, double temperature) {
    final actions = <String>[];

    if (temperature < 0) {
      actions.add('URGENT: Protection antigel immédiate requise');
    }

    actions.addAll([
      'Couvrir avec voile d hivernage (P17 ou P30 selon température)',
      'Rentrer les plantes en pot à l intérieur',
      'Pailler généreusement le sol (10-15cm d épaisseur)',
      'Arroser légèrement le sol avant le gel (effet isolant)',
    ]);

    // Actions spécifiques selon les plantes
    if (plants.any((p) => p.family.toLowerCase().contains('solanaceae'))) {
      actions.add('Solanacées: protection renforcée (très sensibles)');
    }

    return actions;
  }

  /// Actions d'arrosage pour plantes sensibles (appelée depuis _detectWeatherAlertsProactive)
  List<String> _getWateringActions(List<PlantFreezed> plants) {
    final actions = <String>[];

    for (final plant in plants.take(3)) {
      final wateringData = plant.watering;
      if (wateringData != null) {
        final frequency = wateringData['frequency'] as String? ?? 'régulier';
        final amount = wateringData['amount'] as String? ?? 'modéré';
        actions.add('${plant.commonName}: $frequency - $amount');
      } else {
        actions.add('${plant.commonName}: arrosage régulier recommandé');
      }
    }

    if (plants.length > 3) {
      actions.add('... et ${plants.length - 3} autre(s) plante(s)');
    }

    return actions;
  }

  /// Actions d'arrosage PERSONNALISÉES selon les plantes
  List<String> _getPersonalizedWateringActions(List<PlantFreezed> plants) {
    final actions = <String>[];

    for (final plant in plants.take(5)) {
      final wateringData = plant.watering;
      if (wateringData != null) {
        final frequency = wateringData['frequency'] as String? ?? 'régulier';
        final amount = wateringData['amount'] as String? ?? 'modéré';
        final method = wateringData['method'] as String? ?? 'au pied';

        actions.add('${plant.commonName}: $frequency - $amount ($method)');
      } else {
        actions.add('${plant.commonName}: arrosage régulier recommandé');
      }
    }

    if (plants.length > 5) {
      actions.add('... et ${plants.length - 5} autre(s) plante(s)');
    }

    return actions;
  }

  /// Actions de protection contre le vent
  List<String> _getWindProtectionActions(
      List<PlantFreezed> plants, double windSpeed) {
    final actions = <String>[];

    if (windSpeed > 60) {
      actions.add('🚨 Vents violents: protection urgente');
    }

    actions.addAll([
      'Tuteurer solidement les plantes hautes',
      'Rentrer les plantes en pot vulnérables',
      'Protéger les jeunes plants avec des cloches',
      'Renforcer les tuteurs existants',
    ]);

    final plantNames = plants.take(3).map((p) => p.commonName).join(', ');
    actions.add('Plantes prioritaires: $plantNames');

    return actions;
  }

  /// Vérifie si une plante peut être plantée maintenant
  bool _isPlantableNow(PlantFreezed plant) {
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

    return plant.sowingMonths.contains(currentMonthCode);
  }

  /// Méthodes helper LEGACY (conservées pour compatibilité)
  List<String> _getFrostSensitivePlants() {
    return ['Tomate', 'Basilic', 'Courgette', 'Concombre', 'Aubergine'];
  }

  List<String> _getWaterSensitivePlants() {
    return ['Salade', 'Épinard', 'Radis', 'Carotte'];
  }

  List<String> _getWindSensitivePlants() {
    return ['Tomate', 'Haricot', 'Pois', 'Tournesol'];
  }

  /// Mappe la sévérité vers la priorité
  RecommendationPriority _mapSeverityToPriority(WeatherAlertSeverity severity) {
    switch (severity) {
      case WeatherAlertSeverity.low:
        return RecommendationPriority.low;
      case WeatherAlertSeverity.medium:
        return RecommendationPriority.medium;
      case WeatherAlertSeverity.high:
        return RecommendationPriority.high;
      case WeatherAlertSeverity.critical:
        return RecommendationPriority.urgent;
    }
  }

  /// Estime l'effort requis
  String _estimateEffort(WeatherAlertType type) {
    switch (type) {
      case WeatherAlertType.frost:
        return 'Moyen';
      case WeatherAlertType.drought:
        return 'Faible';
      case WeatherAlertType.storm:
        return 'Élevé';
      case WeatherAlertType.heat:
        return 'Moyen';
    }
  }

  /// Obtient le bénéfice attendu
  String _getExpectedBenefit(WeatherAlertType type) {
    switch (type) {
      case WeatherAlertType.frost:
        return 'Protection contre le gel';
      case WeatherAlertType.drought:
        return 'Amélioration de l\'hydratation';
      case WeatherAlertType.storm:
        return 'Protection contre les dommages';
      case WeatherAlertType.heat:
        return 'Réduction du stress thermique';
    }
  }

  // ============================================================================
  // MÉTHODES DE LOGGING (Amélioration Prompt 4)
  // ============================================================================

  /// Log de debugging (peut être désactivé en production)
  void _logDebug(String message) {
    if (_loggingEnabled) {
      developer.log(message, name: 'WeatherImpactAnalyzer', level: 500);
    }
  }

  /// Log d'erreur (toujours actif)
  void _logError(String message) {
    developer.log(message, name: 'WeatherImpactAnalyzer', level: 1000);
    print('[WeatherImpactAnalyzer] $message');
  }

  /// Active ou désactive le logging
  static void setLogging(bool enabled) {
    _loggingEnabled = enabled;
  }
}

/// Analyse de l'impact météorologique
class WeatherImpactAnalysis {
  final String weatherId;
  final double impactScore;
  final List<WeatherAlert> alerts;
  final WeatherTrends trends;
  final List<WeatherRecommendation> recommendations;
  final DateTime analyzedAt;
  final double confidence;

  const WeatherImpactAnalysis({
    required this.weatherId,
    required this.impactScore,
    required this.alerts,
    required this.trends,
    required this.recommendations,
    required this.analyzedAt,
    required this.confidence,
  });
}

/// Alerte météorologique
class WeatherAlert {
  final String id;
  final WeatherAlertType type;
  final WeatherAlertSeverity severity;
  final String title;
  final String description;
  final List<String> affectedPlants;
  final List<String> recommendedActions;
  final DateTime validUntil;
  final DateTime createdAt;

  const WeatherAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    required this.affectedPlants,
    required this.recommendedActions,
    required this.validUntil,
    required this.createdAt,
  });
}

/// Types d'alertes météorologiques
enum WeatherAlertType {
  frost,
  drought,
  storm,
  heat,
}

/// Sévérité des alertes
enum WeatherAlertSeverity {
  low,
  medium,
  high,
  critical,
}

/// Tendances météorologiques
class WeatherTrends {
  final WeatherTrend temperatureTrend;
  final WeatherTrend humidityTrend;
  final WeatherTrend precipitationTrend;
  final WeatherTrend windTrend;
  final double confidence;
  final DateTime analyzedAt;

  const WeatherTrends({
    required this.temperatureTrend,
    required this.humidityTrend,
    required this.precipitationTrend,
    required this.windTrend,
    required this.confidence,
    required this.analyzedAt,
  });
}

/// Types de tendances
enum WeatherTrend {
  increasing,
  decreasing,
  stable,
  variable,
}

/// Recommandation météorologique
class WeatherRecommendation {
  final String id;
  final String? alertId;
  final String title;
  final String description;
  final RecommendationPriority priority;
  final List<String> actions;
  final String estimatedEffort;
  final String expectedBenefit;
  final DateTime validUntil;
  final DateTime createdAt;

  const WeatherRecommendation({
    required this.id,
    this.alertId,
    required this.title,
    required this.description,
    required this.priority,
    required this.actions,
    required this.estimatedEffort,
    required this.expectedBenefit,
    required this.validUntil,
    required this.createdAt,
  });
}

/// Priorités des recommandations (réutilisé)
enum RecommendationPriority {
  low,
  medium,
  high,
  urgent,
}

