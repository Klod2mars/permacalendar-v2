import 'dart:math' as math;
import '../../../../../core/models/hourly_weather_point.dart';

/// Utilitaire pour interpoler les données météo entre deux points horaires.
class WeatherInterpolation {
  /// Retourne un point météo interpolé pour un temps cible donné.
  /// Si la cible est hors range, retourne le point le plus proche (first ou last).
  static HourlyWeatherPoint? getInterpolatedWeather(
      List<HourlyWeatherPoint> points, DateTime target) {
    if (points.isEmpty) return null;

    // Assurons-nous que la liste est triée (sécurité)
    // Note: l'API renvoie généralement une liste triée, mais on ne sait jamais.
    // Pour la performance, on pourrait trier une seule fois ailleurs, mais ici c'est OK.
    // points.sort((a, b) => a.time.compareTo(b.time));

    // 1. Trouver le point suivant (Index)
    int nextIdx = points.indexWhere((p) => p.time.isAfter(target));

    // Cas A : Cible avant le premier point (Passé lointain)
    if (nextIdx == 0) return points.first;

    // Cas B : Cible après le dernier point (Futur lointain)
    if (nextIdx == -1) return points.last;

    // Cas C : Interpolation standard
    final prev = points[nextIdx - 1];
    final next = points[nextIdx];

    // Calcul du facteur d'interpolation (0.0 à 1.0)
    final totalDuration = next.time.difference(prev.time).inMicroseconds;
    final currentDuration = target.difference(prev.time).inMicroseconds;

    // Éviter division par zéro
    double t = 0.0;
    if (totalDuration != 0) {
      t = currentDuration / totalDuration;
    }

    // Création du point interpolé virtuel
    return HourlyWeatherPoint(
      time: target,
      temperatureC: _lerpDouble(prev.temperatureC, next.temperatureC, t),
      precipitationMm:
          _lerpDouble(prev.precipitationMm, next.precipitationMm, t),
      precipitationProbability: _lerpInt(
          prev.precipitationProbability, next.precipitationProbability, t),
      windSpeedkmh: _lerpDouble(prev.windSpeedkmh, next.windSpeedkmh, t),
      windDirection: _lerpInt(prev.windDirection, next.windDirection, t),
      windGustsKmh: _lerpDouble(prev.windGustsKmh, next.windGustsKmh, t),
      pressureMsl: _lerpDouble(prev.pressureMsl, next.pressureMsl, t),
      cloudCover: _lerpInt(prev.cloudCover ?? 0, next.cloudCover ?? 0,
          t), // Gestion des nulls si modèle non mis à jour
      visibility:
          _lerpDouble(prev.visibility ?? 10000, next.visibility ?? 10000, t),
      // Weather Code : on "snap" au code le plus proche plutôt que d'interpoler un nombre entier
      weatherCode: t < 0.5 ? prev.weatherCode : next.weatherCode,
      // Apparent temp est calculable, mais on l'interpole aussi pour fluidité
      apparentTemperatureC:
          _lerpDouble(prev.apparentTemperatureC, next.apparentTemperatureC, t),
    );
  }

  static double _lerpDouble(double? a, double? b, double t) {
    // Si l'une des valeurs est nulle, on prend l'autre ou 0.0 par défaut
    if (a == null && b == null) return 0.0;
    if (a == null) return b!;
    if (b == null) return a;
    return a + (b - a) * t;
  }

  static int _lerpInt(int? a, int? b, double t) {
    if (a == null && b == null) return 0;
    if (a == null) return b!;
    if (b == null) return a;
    return (a + (b - a) * t).round();
  }
}
