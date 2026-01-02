import 'dart:math' as math;
import '../../features/climate/domain/models/weather_view_data.dart';
import '../../features/climate/domain/entities/weather_alert.dart';

/// Service de détection d'alertes météo intelligentes
/// Analyse les prévisions météo et génère des alertes contextuelles basées sur les plantes actives
class WeatherAlertService {
  static const double FROST_THRESHOLD = 0.0; // Â°C
  static const double HEATWAVE_THRESHOLD = 35.0; // Â°C
  static const double DROUGHT_DAYS = 3.0; // Jours sans pluie
  static const double HIGH_HYDRIC_NEED_TEMP =
      28.0; // Â°C pour besoins hydriques élevés

  /// Analyser les prévisions météo et générer alertes intelligentes
  List<WeatherAlert> generateAlerts(
      WeatherViewData weather, List<PlantData> activePlants) {
    final alerts = <WeatherAlert>[];
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    // Analyser conditions météo
    final weatherConditions = _analyzeWeatherConditions(weather);

    // Vérifier prévisions J+1
    if (weather.result.dailyWeather.isNotEmpty) {
      final tomorrowWeather = weather.result.dailyWeather.first;

      // ALERTE GEL (priorité absolue)
      if (tomorrowWeather.tMinC != null &&
          tomorrowWeather.tMinC! <= FROST_THRESHOLD) {
        alerts.add(WeatherAlert(
          id: 'frost_${DateTime.now().millisecondsSinceEpoch}',
          type: WeatherAlertType.frost,
          severity: AlertSeverity.warning,
          title: "Risque de gel demain",
          description:
              "Température minimale prévue : ${tomorrowWeather.tMinC!.round()}Â°C",
          validFrom: tomorrow,
          validUntil: tomorrow.add(const Duration(hours: 12)),
          temperature: tomorrowWeather.tMinC,
          recommendations: [
            "Protéger les plantes sensibles au gel",
            "Rentrer les pots et jardinières",
            "Arroser légèrement avant le gel (protection thermique)",
          ],
          iconPath: "assets/weather_icons/frost_alert.png",
          isMeteoDependent: true,
          timestamp: DateTime.now(),
        ));
      }

      // ALERTE CANICULE (priorité élevée)
      if (tomorrowWeather.tMaxC != null &&
          tomorrowWeather.tMaxC! >= HEATWAVE_THRESHOLD) {
        alerts.add(WeatherAlert(
          id: 'heatwave_${DateTime.now().millisecondsSinceEpoch}',
          type: WeatherAlertType.heatwave,
          severity: AlertSeverity.critical,
          title: "Forte chaleur prévue",
          description:
              "Température maximale prévue : ${tomorrowWeather.tMaxC!.round()}Â°C",
          validFrom: tomorrow,
          validUntil: tomorrow.add(const Duration(hours: 24)),
          temperature: tomorrowWeather.tMaxC,
          recommendations: [
            "Arroser tôt le matin (avant 8h) ou tard le soir (après 19h)",
            "Ombrager les plants les plus sensibles",
            "Mulcher le sol pour conserver l'humidité",
          ],
          iconPath: "assets/weather_icons/heat_alert.png",
          isMeteoDependent: true,
          timestamp: DateTime.now(),
        ));
      }

      // ARROSAGE INTELLIGENT CONTEXTUEL (activation conditionnelle stricte)
      final wateringAlert = _generateSmartWateringAlert(
          weatherConditions, activePlants, tomorrow);
      if (wateringAlert != null) {
        alerts.add(wateringAlert);
      }
    }

    return alerts;
  }

  /// Analyser les conditions météorologiques pour l'arrosage intelligent
  WeatherConditions _analyzeWeatherConditions(WeatherViewData weather) {
    bool rainExpected = false;
    bool droughtRisk = false;
    int daysWithoutRain = 0;

    // Analyser prévisions 3-5 jours
    for (int i = 0; i < math.min(weather.result.dailyWeather.length, 5); i++) {
      final day = weather.result.dailyWeather[i];

      // Pluie prévue ?
      if (day.precipMm > 2.0) {
        // > 2mm considéré comme pluie significative
        rainExpected = true;
        break;
      } else {
        daysWithoutRain++;
      }
    }

    // Risque de sécheresse si > 3 jours sans pluie
    droughtRisk = daysWithoutRain >= DROUGHT_DAYS;

    return WeatherConditions(
      rainExpected: rainExpected,
      droughtRisk: droughtRisk,
      daysWithoutRain: daysWithoutRain,
      nextTemperatureMax: weather.result.dailyWeather.isNotEmpty &&
              weather.result.dailyWeather.first.tMaxC != null
          ? weather.result.dailyWeather.first.tMaxC!
          : 0,
    );
  }

  /// Générer alerte arrosage intelligent UNIQUEMENT si conditions strictes réunies
  WeatherAlert? _generateSmartWateringAlert(WeatherConditions conditions,
      List<PlantData> activePlants, DateTime tomorrow) {
    // CONDITIONS BLOQUANTES (mode dormant)
    if (conditions.rainExpected) return null; // ðŸŒ§ Pluie prévue â†’ dormant
    if (conditions.nextTemperatureMax <= 5) {
      return null; // â„ Trop froid â†’ dormant
    }

    // Identifier plantes avec besoins hydriques actifs
    final plantsNeedingWater = activePlants.where((plant) {
      return plant.isInActiveGrowth &&
          plant.hasHydricNeeds &&
          plant.isWaterSensitivePeriod;
    }).toList();

    // CONDITIONS D'ACTIVATION STRICTES
    if (plantsNeedingWater.isEmpty) {
      return null; // ðŸŒ± Aucune plante à besoin hydrique â†’ dormant
    }
    if (!conditions.droughtRisk &&
        conditions.nextTemperatureMax < HIGH_HYDRIC_NEED_TEMP) {
      return null; // Pas de risque hydrique â†’ dormant
    }

    // ACTIVATION : Conditions réunies pour arrosage intelligent
    final severity = conditions.nextTemperatureMax >= HEATWAVE_THRESHOLD
        ? AlertSeverity.critical
        : AlertSeverity.warning;

    final plantNames = plantsNeedingWater.map((p) => p.name).take(3).join(", ");
    final morePlants = plantsNeedingWater.length > 3
        ? " et ${plantsNeedingWater.length - 3} autres"
        : "";

    return WeatherAlert(
      id: 'watering_${DateTime.now().millisecondsSinceEpoch}',
      type: WeatherAlertType.watering,
      severity: severity,
      title: "Arrosage recommandé",
      description:
          "${conditions.daysWithoutRain} jours sans pluie, ${plantsNeedingWater.length} plantes sensibles",
      validFrom: tomorrow,
      validUntil: tomorrow.add(const Duration(hours: 18)),
      temperature: conditions.nextTemperatureMax,
      affectedPlants: plantsNeedingWater.map((p) => p.name).toList(),
      recommendations: [
        "Arroser prioritairement : $plantNames$morePlants",
        conditions.nextTemperatureMax > HIGH_HYDRIC_NEED_TEMP
            ? "Arroser tôt le matin avant la chaleur"
            : "Arroser de préférence le soir",
        "Vérifier l'humidité du sol avant arrosage",
      ],
      iconPath: "assets/weather_icons/water_alert.png",
      isMeteoDependent: true,
      timestamp: DateTime.now(),
    );
  }
}

/// Classe helper pour conditions météo
class WeatherConditions {
  final bool rainExpected;
  final bool droughtRisk;
  final int daysWithoutRain;
  final double nextTemperatureMax;

  const WeatherConditions({
    required this.rainExpected,
    required this.droughtRisk,
    required this.daysWithoutRain,
    required this.nextTemperatureMax,
  });
}

/// Classe helper pour données plantes (à adapter selon votre JSON)
class PlantData {
  final String name;
  final bool isInActiveGrowth; // En croissance active ?
  final bool hasHydricNeeds; // A des besoins hydriques ?
  final bool isWaterSensitivePeriod; // Période sensible à l'eau ?

  const PlantData({
    required this.name,
    required this.isInActiveGrowth,
    required this.hasHydricNeeds,
    required this.isWaterSensitivePeriod,
  });
}
