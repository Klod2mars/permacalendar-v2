import 'package:hive/hive.dart';
import 'condition_models.dart';

part 'weather_condition_hive.g.dart';

/// Adaptateur Hive pour la persistance de WeatherCondition
/// TypeId: 37 - Utilisé pour stocker les conditions météorologiques
@HiveType(typeId: 37)
class WeatherConditionHive extends HiveObject {
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  double currentTemperature;

  @HiveField(2)
  double minTemperature;

  @HiveField(3)
  double maxTemperature;

  @HiveField(4)
  double humidity;

  @HiveField(5)
  double precipitation;

  @HiveField(6)
  double windSpeed;

  @HiveField(7)
  int cloudCover;

  @HiveField(8)
  List<WeatherForecastHive> forecast;

  @HiveField(9)
  int trendIndex; // Index de WeatherTrend

  @HiveField(10)
  Map<String, dynamic>? metadata;

  WeatherConditionHive({
    required this.timestamp,
    required this.currentTemperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.cloudCover,
    required this.forecast,
    required this.trendIndex,
    this.metadata,
  });

  /// NOTE PROMPT 8.5: Factory fromDomain IMPOSSIBLE avec WeatherCondition UNITAIRE
  ///
  /// WeatherCondition est une entité UNITAIRE (1 type + 1 valeur) tandis que
  /// WeatherConditionHive est COMPOSITE (température, humidité, précipitations, etc.)
  ///
  /// TODO: Utiliser CompositeWeatherData à la place pour la persistance
  ///
  /// Factory depuis CompositeWeatherData (modèle composite helper)
  factory WeatherConditionHive.fromComposite(dynamic compositeWeather) {
    // Accepte CompositeWeatherData ou Map<String, dynamic>
    if (compositeWeather is Map<String, dynamic>) {
      return WeatherConditionHive(
        timestamp: compositeWeather['timestamp'] ?? DateTime.now(),
        currentTemperature: compositeWeather['currentTemperature'] ?? 0.0,
        minTemperature: compositeWeather['minTemperature'] ?? 0.0,
        maxTemperature: compositeWeather['maxTemperature'] ?? 0.0,
        humidity: compositeWeather['humidity'] ?? 0.0,
        precipitation: compositeWeather['precipitation'] ?? 0.0,
        windSpeed: compositeWeather['windSpeed'] ?? 0.0,
        cloudCover: compositeWeather['cloudCover'] ?? 0,
        forecast: (compositeWeather['forecast'] as List?)?.map((f) {
              if (f is WeatherForecastHive) return f;
              return WeatherForecastHive(
                date: f['date'],
                minTemperature: f['minTemperature'],
                maxTemperature: f['maxTemperature'],
                humidity: f['humidity'],
                precipitation: f['precipitation'],
                precipitationProbability: f['precipitationProbability'],
                windSpeed: f['windSpeed'],
                cloudCover: f['cloudCover'],
                condition: f['condition'],
              );
            }).toList() ??
            [],
        trendIndex: 2, // WeatherTrend.stable par défaut
        metadata: compositeWeather['metadata'] ?? {},
      );
    } else {
      // Pour les objets avec des propriétés (CompositeWeatherData)
      return WeatherConditionHive(
        timestamp: compositeWeather.timestamp ?? DateTime.now(),
        currentTemperature: compositeWeather.currentTemperature ?? 0.0,
        minTemperature: compositeWeather.minTemperature ?? 0.0,
        maxTemperature: compositeWeather.maxTemperature ?? 0.0,
        humidity: compositeWeather.humidity ?? 0.0,
        precipitation: compositeWeather.precipitation ?? 0.0,
        windSpeed: compositeWeather.windSpeed ?? 0.0,
        cloudCover: compositeWeather.cloudCover ?? 0,
        forecast: (compositeWeather.forecast as List?)?.map((f) {
              if (f is WeatherForecastHive) return f;
              return WeatherForecastHive(
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
            }).toList() ??
            [],
        trendIndex: 2, // WeatherTrend.stable par défaut
        metadata: compositeWeather.metadata ?? {},
      );
    }
  }

  /// Convertir vers Map pour compatibilité avec CompositeWeatherData
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'currentTemperature': currentTemperature,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'humidity': humidity,
      'precipitation': precipitation,
      'windSpeed': windSpeed,
      'cloudCover': cloudCover,
      'forecast': forecast
          .map((f) => {
                'date': f.date,
                'minTemperature': f.minTemperature,
                'maxTemperature': f.maxTemperature,
                'humidity': f.humidity,
                'precipitation': f.precipitation,
                'precipitationProbability': f.precipitationProbability,
                'windSpeed': f.windSpeed,
                'cloudCover': f.cloudCover,
                'condition': f.condition,
              })
          .toList(),
      'metadata': metadata,
    };
  }
}

/// Adaptateur Hive pour WeatherForecast
@HiveType(typeId: 38)
class WeatherForecastHive extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double minTemperature;

  @HiveField(2)
  double maxTemperature;

  @HiveField(3)
  double humidity;

  @HiveField(4)
  double precipitation;

  @HiveField(5)
  double precipitationProbability;

  @HiveField(6)
  double windSpeed;

  @HiveField(7)
  int cloudCover;

  @HiveField(8)
  String condition;

  WeatherForecastHive({
    required this.date,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.precipitation,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.cloudCover,
    required this.condition,
  });

  factory WeatherForecastHive.fromDomain(WeatherForecast forecast) {
    return WeatherForecastHive(
      date: forecast.date,
      minTemperature: forecast.minTemperature,
      maxTemperature: forecast.maxTemperature,
      humidity: forecast.humidity,
      precipitation: forecast.precipitation,
      precipitationProbability: forecast.precipitationProbability,
      windSpeed: forecast.windSpeed,
      cloudCover: forecast.cloudCover,
      condition: forecast.condition,
    );
  }

  WeatherForecast toDomain() {
    return WeatherForecast(
      date: date,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      humidity: humidity,
      precipitation: precipitation,
      precipitationProbability: precipitationProbability,
      windSpeed: windSpeed,
      cloudCover: cloudCover,
      condition: condition,
    );
  }
}
