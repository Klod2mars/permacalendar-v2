ï»¿import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

/// Use case pour analyser les conditions d'une plante spécifique
///
/// Analyse complète retournant un PlantAnalysisResult avec toutes les conditions
class AnalyzePlantConditionsUsecase {
  const AnalyzePlantConditionsUsecase();

  /// Exécute l'analyse des conditions pour une plante donnée
  ///
  /// [plant] - La plante à analyser
  /// [weather] - Les conditions météorologiques actuelles
  /// [garden] - Le contexte du jardin
  ///
  /// Retourne un [PlantAnalysisResult] avec l'analyse complète
  Future<PlantAnalysisResult> execute({
    required PlantFreezed plant,
    required WeatherCondition weather,
    required GardenContext garden,
  }) async {
    try {
      // Validation des paramètres d'entrée
      _validateInputs(plant, weather, garden);

      // Analyse de la température
      final temperatureCondition =
          _createTemperatureCondition(plant, weather, garden);

      // Analyse de l'humidité
      final humidityCondition =
          _createHumidityCondition(plant, weather, garden);

      // Analyse de la luminosité
      final lightCondition = _createLightCondition(plant, garden);

      // Analyse du sol
      final soilCondition = _createSoilCondition(plant, garden);

      // Calculer l'état de santé global
      final overallHealth = _calculateOverallHealth([
        temperatureCondition,
        humidityCondition,
        lightCondition,
        soilCondition,
      ]);

      // Calculer le score de santé
      final healthScore = _calculateHealthScore([
        temperatureCondition,
        humidityCondition,
        lightCondition,
        soilCondition,
      ]);

      // Générer warnings et strengths
      final warnings = _generateWarnings([
        temperatureCondition,
        humidityCondition,
        lightCondition,
        soilCondition,
      ]);

      final strengths = _generateStrengths([
        temperatureCondition,
        humidityCondition,
        lightCondition,
        soilCondition,
      ]);

      final priorityActions = _generatePriorityActions([
        temperatureCondition,
        humidityCondition,
        lightCondition,
        soilCondition,
      ]);

      // Créer le résultat composite
      return PlantAnalysisResult(
        id: '${plant.id}_analysis_${DateTime.now().millisecondsSinceEpoch}',
        plantId: plant.id,
        temperature: temperatureCondition,
        humidity: humidityCondition,
        light: lightCondition,
        soil: soilCondition,
        overallHealth: overallHealth,
        healthScore: healthScore,
        warnings: warnings,
        strengths: strengths,
        priorityActions: priorityActions,
        confidence: _calculateConfidence(weather, garden),
        analyzedAt: DateTime.now(),
        metadata: {
          'weatherAge': DateTime.now().difference(weather.measuredAt).inHours,
          'gardenId': garden.gardenId,
        },
      );
    } catch (e) {
      throw Exception(
          'Erreur lors de l\'analyse des conditions pour ${plant.commonName}: $e');
    }
  }

  /// Valide les paramètres d'entrée
  void _validateInputs(
      PlantFreezed plant, WeatherCondition weather, GardenContext garden) {
    if (plant.id.isEmpty) {
      throw ArgumentError('L\'ID de la plante ne peut pas être vide');
    }

    if (garden.gardenId.isEmpty) {
      throw ArgumentError('L\'ID du jardin ne peut pas être vide');
    }

    // Vérification de la fraÃ®cheur des données météo (max 24h)
    final weatherAge = DateTime.now().difference(weather.measuredAt);
    if (weatherAge.inHours > 24) {
      throw ArgumentError(
          'Les données météo sont trop anciennes (${weatherAge.inHours}h)');
    }
  }

  /// Crée une condition de température
  PlantCondition _createTemperatureCondition(
      PlantFreezed plant, WeatherCondition weather, GardenContext garden) {
    final currentTemp = weather.value; // Utiliser la valeur de weather
    final optimalTemp = _getOptimalTemperature(plant);
    final minTemp = optimalTemp - 10;
    final maxTemp = optimalTemp + 10;

    final status =
        _determineTemperatureStatus(currentTemp, minTemp, maxTemp, optimalTemp);

    return PlantCondition(
      id: '${plant.id}_temp_${DateTime.now().millisecondsSinceEpoch}',
      plantId: plant.id,
      gardenId: garden.gardenId,
      type: ConditionType.temperature,
      status: status,
      value: currentTemp,
      optimalValue: optimalTemp,
      minValue: minTemp,
      maxValue: maxTemp,
      unit: 'Â°C',
      description: 'Température actuelle: ${currentTemp.toStringAsFixed(1)}Â°C',
      recommendations: _getTemperatureRecommendations(currentTemp, optimalTemp),
      measuredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  /// Crée une condition d'humidité
  PlantCondition _createHumidityCondition(
      PlantFreezed plant, WeatherCondition weather, GardenContext garden) {
    // Extraction des besoins réels en eau de la plante depuis plants.json
    final waterNeeds = plant.waterNeeds.toLowerCase();
    double optimalHumidity;
    double minHumidity;
    double maxHumidity;

    // Définir les plages d'humidité selon les besoins en eau de la plante
    if (waterNeeds.contains('élevé') || waterNeeds.contains('high')) {
      optimalHumidity = 80.0;
      minHumidity = 60.0;
      maxHumidity = 95.0;
    } else if (waterNeeds.contains('faible') || waterNeeds.contains('low')) {
      optimalHumidity = 50.0;
      minHumidity = 30.0;
      maxHumidity = 70.0;
    } else {
      // Moyen/Modéré
      optimalHumidity = 70.0;
      minHumidity = 50.0;
      maxHumidity = 85.0;
    }

    // Estimation de l'humidité actuelle basée sur les données météo réelles
    // Dans une implémentation complète, utiliser des capteurs ou API d'humidité
    final humidity = weather.value; // Utiliser la valeur météo disponible

    final status = _determineHumidityStatus(
        humidity, minHumidity, maxHumidity, optimalHumidity);

    return PlantCondition(
      id: '${plant.id}_humidity_${DateTime.now().millisecondsSinceEpoch}',
      plantId: plant.id,
      gardenId: garden.gardenId,
      type: ConditionType.humidity,
      status: status,
      value: humidity,
      optimalValue: optimalHumidity,
      minValue: minHumidity,
      maxValue: maxHumidity,
      unit: '%',
      description: 'Humidité actuelle: ${humidity.toStringAsFixed(1)}%',
      recommendations: _getHumidityRecommendations(humidity, optimalHumidity),
      measuredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  /// Crée une condition de luminosité
  PlantCondition _createLightCondition(
      PlantFreezed plant, GardenContext garden) {
    // Extraction des besoins réels en lumière de la plante depuis plants.json
    final sunExposure = plant.sunExposure.toLowerCase();
    double optimalLight;
    double minLight;
    double maxLight;

    // Définir les plages de luminosité selon l'exposition requise
    if (sunExposure.contains('plein soleil') ||
        sunExposure.contains('full sun')) {
      optimalLight = 90.0;
      minLight = 70.0;
      maxLight = 100.0;
    } else if (sunExposure.contains('mi-ombre') ||
        sunExposure.contains('partial')) {
      optimalLight = 60.0;
      minLight = 40.0;
      maxLight = 80.0;
    } else if (sunExposure.contains('ombre') || sunExposure.contains('shade')) {
      optimalLight = 40.0;
      minLight = 20.0;
      maxLight = 60.0;
    } else {
      // Mi-soleil par défaut
      optimalLight = 70.0;
      minLight = 50.0;
      maxLight = 90.0;
    }

    // Estimation de la luminosité basée sur l'exposition du jardin
    // Utiliser les métadonnées du jardin pour une estimation
    final gardenExposure =
        garden.metadata['exposition'] as String? ?? 'plein soleil';
    final light = _estimateLightFromExposure(gardenExposure);

    final status =
        _determineLightStatus(light, minLight, maxLight, optimalLight);

    return PlantCondition(
      id: '${plant.id}_light_${DateTime.now().millisecondsSinceEpoch}',
      plantId: plant.id,
      gardenId: garden.gardenId,
      type: ConditionType.light,
      status: status,
      value: light,
      optimalValue: optimalLight,
      minValue: minLight,
      maxValue: maxLight,
      unit: '%',
      description: 'Luminosité actuelle: ${light.toStringAsFixed(1)}%',
      recommendations: _getLightRecommendations(light, optimalLight),
      measuredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  /// Crée une condition du sol
  PlantCondition _createSoilCondition(
      PlantFreezed plant, GardenContext garden) {
    // Extraction du type de sol du jardin (métadonnées)
    final soilType = garden.metadata['soilType'] as String? ?? 'loamy';

    // Estimation de la qualité du sol basée sur le type
    final soilQuality = _estimateSoilQualityFromType(soilType);
    const optimalQuality = 90.0;
    const minQuality = 60.0;
    const maxQuality = 100.0;

    final status = _determineSoilStatus(
        soilQuality, minQuality, maxQuality, optimalQuality);

    return PlantCondition(
      id: '${plant.id}_soil_${DateTime.now().millisecondsSinceEpoch}',
      plantId: plant.id,
      gardenId: garden.gardenId,
      type: ConditionType.soil,
      status: status,
      value: soilQuality,
      optimalValue: optimalQuality,
      minValue: minQuality,
      maxValue: maxQuality,
      unit: '%',
      description: 'Qualité du sol: ${soilQuality.toStringAsFixed(1)}%',
      recommendations: _getSoilRecommendations(soilQuality, optimalQuality),
      measuredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  /// Détermine la température optimale pour une plante depuis les données réelles
  double _getOptimalTemperature(PlantFreezed plant) {
    // Utilisation de l'extension PlantFreezedExtension pour extraire les données réelles
    if (plant.optimalGerminationTemperature != null) {
      return plant.optimalGerminationTemperature!;
    }

    // Si pas de données de germination, essayer les données de croissance
    if (plant.growth != null) {
      final idealTemp =
          plant.growth!['idealTemperature'] as Map<String, dynamic>?;
      if (idealTemp != null) {
        final min = idealTemp['min'] as num?;
        final max = idealTemp['max'] as num?;
        if (min != null && max != null) {
          return (min.toDouble() + max.toDouble()) / 2.0;
        }
      }
    }

    // Fallback : température par défaut
    return 20.0;
  }

  /// Estime la luminosité basée sur l'exposition du jardin
  double _estimateLightFromExposure(String exposure) {
    final lowerExposure = exposure.toLowerCase();

    if (lowerExposure.contains('plein soleil') ||
        lowerExposure.contains('full sun')) {
      return 95.0;
    } else if (lowerExposure.contains('mi-soleil') ||
        lowerExposure.contains('partial sun')) {
      return 75.0;
    } else if (lowerExposure.contains('mi-ombre') ||
        lowerExposure.contains('partial shade')) {
      return 55.0;
    } else if (lowerExposure.contains('ombre') ||
        lowerExposure.contains('shade')) {
      return 35.0;
    } else {
      return 70.0; // Par défaut
    }
  }

  /// Estime la qualité du sol basée sur son type
  double _estimateSoilQualityFromType(String soilType) {
    final lowerType = soilType.toLowerCase();

    // Limoneux (loamy) : meilleur type de sol
    if (lowerType.contains('loamy') || lowerType.contains('limoneux')) {
      return 95.0;
    }
    // Argileux (clay) : bon mais lourd
    else if (lowerType.contains('clay') || lowerType.contains('argileux')) {
      return 75.0;
    }
    // Sableux (sandy) : drainant mais moins nutritif
    else if (lowerType.contains('sandy') || lowerType.contains('sableux')) {
      return 70.0;
    }
    // Calcaire (chalky)
    else if (lowerType.contains('chalky') || lowerType.contains('calcaire')) {
      return 65.0;
    }
    // Tourbeux (peaty)
    else if (lowerType.contains('peaty') || lowerType.contains('tourbeux')) {
      return 80.0;
    }
    // Par défaut
    else {
      return 75.0;
    }
  }

  /// Détermine le statut de température
  ConditionStatus _determineTemperatureStatus(
      double current, double min, double max, double optimal) {
    if (current >= min && current <= max) {
      final distanceFromOptimal = (current - optimal).abs();
      if (distanceFromOptimal <= 2) {
        return ConditionStatus.excellent;
      } else if (distanceFromOptimal <= 5) {
        return ConditionStatus.good;
      } else {
        return ConditionStatus.fair;
      }
    } else {
      return current < min ? ConditionStatus.poor : ConditionStatus.critical;
    }
  }

  /// Détermine le statut d'humidité
  ConditionStatus _determineHumidityStatus(
      double current, double min, double max, double optimal) {
    if (current >= min && current <= max) {
      final distanceFromOptimal = (current - optimal).abs();
      if (distanceFromOptimal <= 5) {
        return ConditionStatus.excellent;
      } else if (distanceFromOptimal <= 10) {
        return ConditionStatus.good;
      } else {
        return ConditionStatus.fair;
      }
    } else {
      return current < min ? ConditionStatus.poor : ConditionStatus.critical;
    }
  }

  /// Détermine le statut de luminosité
  ConditionStatus _determineLightStatus(
      double current, double min, double max, double optimal) {
    if (current >= min && current <= max) {
      final distanceFromOptimal = (current - optimal).abs();
      if (distanceFromOptimal <= 5) {
        return ConditionStatus.excellent;
      } else if (distanceFromOptimal <= 10) {
        return ConditionStatus.good;
      } else {
        return ConditionStatus.fair;
      }
    } else {
      return current < min ? ConditionStatus.poor : ConditionStatus.critical;
    }
  }

  /// Détermine le statut du sol
  ConditionStatus _determineSoilStatus(
      double current, double min, double max, double optimal) {
    if (current >= min && current <= max) {
      final distanceFromOptimal = (current - optimal).abs();
      if (distanceFromOptimal <= 5) {
        return ConditionStatus.excellent;
      } else if (distanceFromOptimal <= 10) {
        return ConditionStatus.good;
      } else {
        return ConditionStatus.fair;
      }
    } else {
      return current < min ? ConditionStatus.poor : ConditionStatus.critical;
    }
  }

  /// Génère des recommandations pour la température
  List<String> _getTemperatureRecommendations(double current, double optimal) {
    final recommendations = <String>[];

    if (current < optimal - 5) {
      recommendations
          .add('Température trop basse. Protéger la plante du froid.');
    } else if (current > optimal + 5) {
      recommendations
          .add('Température trop élevée. Ombrer la plante si possible.');
    } else {
      recommendations.add('Température dans la plage optimale.');
    }

    return recommendations;
  }

  /// Génère des recommandations pour l'humidité
  List<String> _getHumidityRecommendations(double current, double optimal) {
    final recommendations = <String>[];

    if (current < optimal - 10) {
      recommendations.add('Humidité trop faible. Arroser plus fréquemment.');
    } else if (current > optimal + 10) {
      recommendations.add('Humidité trop élevée. Améliorer le drainage.');
    } else {
      recommendations.add('Humidité dans la plage optimale.');
    }

    return recommendations;
  }

  /// Génère des recommandations pour la luminosité
  List<String> _getLightRecommendations(double current, double optimal) {
    final recommendations = <String>[];

    if (current < optimal - 10) {
      recommendations.add(
          'Luminosité insuffisante. Déplacer vers un endroit plus ensoleillé.');
    } else if (current > optimal + 10) {
      recommendations.add('Luminosité excessive. Ombrer légèrement la plante.');
    } else {
      recommendations.add('Luminosité dans la plage optimale.');
    }

    return recommendations;
  }

  /// Génère des recommandations pour le sol
  List<String> _getSoilRecommendations(double current, double optimal) {
    final recommendations = <String>[];

    if (current < optimal - 10) {
      recommendations.add('Qualité du sol à améliorer. Ajouter du compost.');
    } else if (current > optimal + 5) {
      recommendations
          .add('Sol très fertile. Surveiller les excès de nutriments.');
    } else {
      recommendations.add('Qualité du sol excellente.');
    }

    return recommendations;
  }

  // ==================== NOUVELLES MÉTHODES POUR PLANTANALYSISRESULT ====================

  /// Calcule l'état de santé global basé sur toutes les conditions
  ConditionStatus _calculateOverallHealth(List<PlantCondition> conditions) {
    // Si une condition est critique, l'état global est critique
    if (conditions.any((c) => c.status == ConditionStatus.critical)) {
      return ConditionStatus.critical;
    }

    // Si plus de la moitié sont poor ou critical, l'état est poor
    final poorOrCritical = conditions
        .where((c) =>
            c.status == ConditionStatus.poor ||
            c.status == ConditionStatus.critical)
        .length;
    if (poorOrCritical >= conditions.length / 2) {
      return ConditionStatus.poor;
    }

    // Si toutes sont excellent, l'état est excellent
    if (conditions.every((c) => c.status == ConditionStatus.excellent)) {
      return ConditionStatus.excellent;
    }

    // Si la majorité est good ou excellent, l'état est good
    final goodOrExcellent = conditions
        .where((c) =>
            c.status == ConditionStatus.good ||
            c.status == ConditionStatus.excellent)
        .length;
    if (goodOrExcellent >= conditions.length * 0.7) {
      return ConditionStatus.good;
    }

    // Sinon, l'état est fair
    return ConditionStatus.fair;
  }

  /// Calcule le score de santé (0-100) basé sur toutes les conditions
  double _calculateHealthScore(List<PlantCondition> conditions) {
    final scores = conditions.map((condition) {
      switch (condition.status) {
        case ConditionStatus.optimal:
          return 100.0;
        case ConditionStatus.excellent:
          return 95.0;
        case ConditionStatus.good:
          return 80.0;
        case ConditionStatus.suboptimal:
          return 70.0;
        case ConditionStatus.fair:
          return 60.0;
        case ConditionStatus.poor:
          return 40.0;
        case ConditionStatus.critical:
          return 20.0;
      }
    });

    return scores.reduce((a, b) => a + b) / conditions.length;
  }

  /// Génère la liste des avertissements basés sur les conditions critiques/poor
  List<String> _generateWarnings(List<PlantCondition> conditions) {
    final warnings = <String>[];

    for (final condition in conditions) {
      if (condition.status == ConditionStatus.critical ||
          condition.status == ConditionStatus.poor) {
        warnings.add(
            '${_getConditionTypeName(condition.type)} : ${condition.description}');
      }
    }

    return warnings;
  }

  /// Génère la liste des points forts basés sur les conditions excellent/good
  List<String> _generateStrengths(List<PlantCondition> conditions) {
    final strengths = <String>[];

    for (final condition in conditions) {
      if (condition.status == ConditionStatus.excellent ||
          condition.status == ConditionStatus.good) {
        strengths.add('${_getConditionTypeName(condition.type)} optimale');
      }
    }

    return strengths;
  }

  /// Génère les actions prioritaires basées sur les conditions critiques
  List<String> _generatePriorityActions(List<PlantCondition> conditions) {
    final actions = <String>[];

    for (final condition in conditions) {
      if (condition.status == ConditionStatus.critical) {
        // Extraire la première recommandation comme action prioritaire
        if (condition.recommendations?.isNotEmpty ?? false) {
          actions.add(condition.recommendations!.first);
        }
      }
    }

    return actions;
  }

  /// Calcule la confiance de l'analyse basée sur la fraÃ®cheur des données
  double _calculateConfidence(WeatherCondition weather, GardenContext garden) {
    final weatherAge = DateTime.now().difference(weather.measuredAt).inHours;

    // Confiance diminue avec l'âge des données météo
    if (weatherAge < 1) return 0.95;
    if (weatherAge < 6) return 0.85;
    if (weatherAge < 12) return 0.75;
    if (weatherAge < 24) return 0.65;
    return 0.50;
  }

  /// Retourne le nom lisible d'un type de condition
  String _getConditionTypeName(ConditionType type) {
    switch (type) {
      case ConditionType.temperature:
        return 'Température';
      case ConditionType.humidity:
        return 'Humidité';
      case ConditionType.light:
        return 'Luminosité';
      case ConditionType.soil:
        return 'Sol';
      case ConditionType.wind:
        return 'Vent';
      case ConditionType.water:
        return 'Eau';
    }
  }
}


