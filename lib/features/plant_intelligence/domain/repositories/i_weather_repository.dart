import '../entities/weather_condition.dart';

/// Interface spécialisée pour la gestion des conditions météorologiques
///
/// Respecte le principe ISP (Interface Segregation Principle) en ne définissant
/// que les méthodes liées à la gestion de la météo.
///
/// **Responsabilités :**
/// - Sauvegarde des WeatherCondition
/// - Historique météorologique
abstract class IWeatherRepository {
  /// Sauvegarde les conditions météorologiques
  ///
  /// [gardenId] - Identifiant du jardin
  /// [weather] - Conditions météorologiques
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> saveWeatherCondition({
    required String gardenId,
    required WeatherCondition weather,
  });

  /// Récupère les conditions météorologiques actuelles
  ///
  /// [gardenId] - Identifiant du jardin
  ///
  /// Retourne les conditions météorologiques actuelles
  Future<WeatherCondition?> getCurrentWeatherCondition(String gardenId);

  /// Récupère l'historique météorologique
  ///
  /// [gardenId] - Identifiant du jardin
  /// [startDate] - Date de début de la période (optionnel)
  /// [endDate] - Date de fin de la période (optionnel)
  /// [limit] - Nombre maximum d'enregistrements à retourner
  ///
  /// Retourne la liste des conditions météorologiques historiques
  Future<List<WeatherCondition>> getWeatherHistory({
    required String gardenId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  });
}


