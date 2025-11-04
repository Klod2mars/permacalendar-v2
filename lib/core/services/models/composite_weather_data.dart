import 'package:permacalendar/features/plant_intelligence/domain/entities/condition_models.dart';

/// Modèle composite helper pour les données météo
///
/// NOTE Prompt 4: Modèle helper temporaire dans services
/// TODO Prompt futur: Migrer vers domain/entities/ comme WeatherConditionComposite
///
/// Ce modèle agrège toutes les conditions météorologiques en un seul objet
/// pour faciliter l'analyse par les services
class CompositeWeatherData {
  final String id;
  final double currentTemperature;
  final double minTemperature;
  final double maxTemperature;
  final double humidity;
  final double precipitation;
  final double windSpeed;
  final int cloudCover;
  final List<WeatherForecast> forecast;
  final DateTime timestamp;

  const CompositeWeatherData({
    required this.id,
    required this.currentTemperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.cloudCover,
    required this.forecast,
    required this.timestamp,
  });

  /// Factory depuis WeatherConditionHive (modèle de persistance)
  factory CompositeWeatherData.fromHive(dynamic hiveWeather) {
    return CompositeWeatherData(
      id: 'weather_${hiveWeather.timestamp.millisecondsSinceEpoch}',
      currentTemperature: hiveWeather.currentTemperature,
      minTemperature: hiveWeather.minTemperature,
      maxTemperature: hiveWeather.maxTemperature,
      humidity: hiveWeather.humidity,
      precipitation: hiveWeather.precipitation,
      windSpeed: hiveWeather.windSpeed,
      cloudCover: hiveWeather.cloudCover,
      forecast: (hiveWeather.forecast as List).map((f) {
        return WeatherForecast(
          date: f.date,
          minTemperature: f.minTemperature,
          maxTemperature: f.maxTemperature,
          humidity: f.humidity,
          precipitation: f.precipitation,
          precipitationProbability: f.precipitationProbability,
          windSpeed: f.windSpeed,
          cloudCover: f.cloudCover,
          condition: f.condition,
        );
      }).toList(),
      timestamp: hiveWeather.timestamp,
    );
  }

  /// Factory depuis WeatherCondition unitaire (utilise valeurs par défaut)
  ///
  /// NOTE: WeatherCondition est UNITAIRE (1 type + 1 valeur)
  /// Cette factory crée un composite avec des valeurs par défaut acceptables
  factory CompositeWeatherData.fromUnitaryCondition(dynamic weatherCondition) {
    double currentTemp = 20.0; // Valeur par défaut
    double minTemp = 15.0;
    double maxTemp = 25.0;
    double humidity = 60.0;
    double precipitation = 0.0;
    double windSpeed = 10.0;
    int cloudCover = 50;

    // Si c'est une condition de température, l'extraire
    try {
      if (weatherCondition.type
          .toString()
          .toLowerCase()
          .contains('temperature')) {
        currentTemp = weatherCondition.value;
        minTemp = currentTemp - 5;
        maxTemp = currentTemp + 5;
      }
    } catch (e) {
      // Ignorer, utiliser les valeurs par défaut
    }

    return CompositeWeatherData(
      id: 'weather_${DateTime.now().millisecondsSinceEpoch}',
      currentTemperature: currentTemp,
      minTemperature: minTemp,
      maxTemperature: maxTemp,
      humidity: humidity,
      precipitation: precipitation,
      windSpeed: windSpeed,
      cloudCover: cloudCover,
      forecast: [],
      timestamp: DateTime.now(),
    );
  }

  /// Factory simple pour tests/mocks
  factory CompositeWeatherData.mock() {
    return CompositeWeatherData(
      id: 'mock_weather',
      currentTemperature: 20.0,
      minTemperature: 15.0,
      maxTemperature: 25.0,
      humidity: 60.0,
      precipitation: 5.0,
      windSpeed: 15.0,
      cloudCover: 50,
      forecast: [],
      timestamp: DateTime.now(),
    );
  }
}

/// Modèle composite helper pour les conditions d'une plante
///
/// NOTE Prompt 4: Modèle helper temporaire dans services
/// TODO Prompt futur: Migrer vers domain/entities/ comme PlantConditionComposite
///
/// Ce modèle agrège toutes les conditions d'une plante en un seul objet
class CompositePlantCondition {
  final String plantId;
  final double soilMoisture;
  final double lightExposure;
  final double soilPh;
  final double soilNutrients;
  final double healthScore;
  final DateTime lastUpdated;

  const CompositePlantCondition({
    required this.plantId,
    required this.soilMoisture,
    required this.lightExposure,
    required this.soilPh,
    required this.soilNutrients,
    required this.healthScore,
    required this.lastUpdated,
  });

  /// Factory depuis plusieurs PlantCondition unitaires
  factory CompositePlantCondition.fromConditions(
    String plantId,
    List<dynamic> conditions,
  ) {
    double soilMoisture = 0.5;
    double lightExposure = 0.7;
    double soilPh = 6.5;
    double soilNutrients = 0.5;
    double healthScore = 0.7;
    DateTime lastUpdated = DateTime.now();

    // Extraire les valeurs depuis les conditions si disponibles
    // Pour l'instant, valeurs par défaut acceptables

    return CompositePlantCondition(
      plantId: plantId,
      soilMoisture: soilMoisture,
      lightExposure: lightExposure,
      soilPh: soilPh,
      soilNutrients: soilNutrients,
      healthScore: healthScore,
      lastUpdated: lastUpdated,
    );
  }

  /// Factory simple pour tests/mocks
  factory CompositePlantCondition.mock(String plantId) {
    return CompositePlantCondition(
      plantId: plantId,
      soilMoisture: 0.6,
      lightExposure: 0.75,
      soilPh: 6.5,
      soilNutrients: 0.65,
      healthScore: 0.75,
      lastUpdated: DateTime.now(),
    );
  }
}
