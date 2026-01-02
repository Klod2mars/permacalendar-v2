import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/weather_alert_service.dart';
import '../providers/weather_providers.dart';
import '../../../../core/services/open_meteo_service.dart';
import '../../../../core/services/environment_service.dart';
import '../../domain/models/weather_view_data.dart' as domain_weather;

/// Provider pour alertes météo en temps réel avec plantes actives
final weatherAlertsProvider =
    FutureProvider.family<List<WeatherAlert>, String>((ref, commune) async {
  final weatherService = WeatherAlertService();

  try {
    // Fetch domain weather directly (remove legacy provider)
    final svc = OpenMeteoService.instance;
    final resolved = await svc.resolveCoordinates(commune);
    final coords = resolved ??
        Coordinates(
          latitude: EnvironmentService.defaultLatitude,
          longitude: EnvironmentService.defaultLongitude,
          resolvedName: EnvironmentService.defaultCommuneName,
        );
    final result = await svc.fetchPrecipitation(
      latitude: coords.latitude,
      longitude: coords.longitude,
      pastDays: 1,
      forecastDays: 5,
    );
    final weather = domain_weather.WeatherViewData(
      locationLabel: coords.resolvedName ?? commune,
      coordinates: coords,
      result: result,
    );
    // Récupérer les plantes actives du jardin
    final activePlants = ref.watch(activePlantsProvider);
    return weatherService.generateAlerts(weather, activePlants);
  } catch (e) {
    return [];
  }
});

/// Provider pour plantes actives (à connecter avec votre système de jardins)
final activePlantsProvider = Provider<List<PlantData>>((ref) {
  // TODO: Connecter avec le système de jardins existant
  // Pour l'instant, retourner des données mock pour le développement
  return [
    // Exemple de plantes avec besoins hydriques
    const PlantData(
      name: "Radis",
      isInActiveGrowth: true,
      hasHydricNeeds: true,
      isWaterSensitivePeriod: true,
    ),
    const PlantData(
      name: "Laitue",
      isInActiveGrowth: true,
      hasHydricNeeds: true,
      isWaterSensitivePeriod: true,
    ),
    const PlantData(
      name: "Tomate",
      isInActiveGrowth: true,
      hasHydricNeeds: true,
      isWaterSensitivePeriod: false, // Pas en période critique
    ),
    const PlantData(
      name: "Carotte",
      isInActiveGrowth: false, // Pas en croissance active
      hasHydricNeeds: true,
      isWaterSensitivePeriod: true,
    ),
  ];
});

/// Provider pour compteur alertes actives (météo-dépendantes uniquement)
final activeAlertsCountProvider = Provider.family<int, String>((ref, commune) {
  final alertsAsync = ref.watch(weatherAlertsProvider(commune));
  return alertsAsync.maybeWhen(
    data: (alerts) {
      // Compter seulement les alertes qui ne sont pas en mode dormant
      final activeAlerts = alerts
          .where((alert) =>
              DateTime.now().isBefore(alert.validUntil) &&
              alert.isMeteoDependent)
          .toList();
      return activeAlerts.length;
    },
    orElse: () => 0,
  );
});

/// Provider pour alertes critiques uniquement (gel, canicule)
final criticalAlertsProvider =
    Provider.family<List<WeatherAlert>, String>((ref, commune) {
  final alertsAsync = ref.watch(weatherAlertsProvider(commune));
  return alertsAsync.maybeWhen(
    data: (alerts) => alerts
        .where((alert) =>
            alert.severity == AlertSeverity.critical &&
            DateTime.now().isBefore(alert.validUntil))
        .toList(),
    orElse: () => [],
  );
});

/// Provider pour alertes arrosage intelligent seulement
final smartWateringAlertsProvider =
    Provider.family<List<WeatherAlert>, String>((ref, commune) {
  final alertsAsync = ref.watch(weatherAlertsProvider(commune));
  return alertsAsync.maybeWhen(
    data: (alerts) => alerts
        .where((alert) =>
            alert.type == WeatherAlertType.watering &&
            DateTime.now().isBefore(alert.validUntil))
        .toList(),
    orElse: () => [],
  );
});

/// Provider pour déterminer si l'animation pulse doit être active
final shouldPulseAlertProvider = Provider.family<bool, String>((ref, commune) {
  final alertsAsync = ref.watch(weatherAlertsProvider(commune));
  return alertsAsync.maybeWhen(
    data: (alerts) {
      final activeAlerts = alerts
          .where((alert) =>
              DateTime.now().isBefore(alert.validUntil) &&
              alert.isMeteoDependent)
          .toList();
      return activeAlerts.isNotEmpty;
    },
    orElse: () => false,
  );
});

/// Provider pour résumé des alertes actives
final alertsSummaryProvider = Provider.family<String, String>((ref, commune) {
  final alertsAsync = ref.watch(weatherAlertsProvider(commune));
  return alertsAsync.maybeWhen(
    data: (alerts) {
      final activeAlerts = alerts
          .where((alert) => DateTime.now().isBefore(alert.validUntil))
          .toList();

      if (activeAlerts.isEmpty) {
        return "Aucune alerte";
      }

      final criticalCount = activeAlerts
          .where((a) => a.severity == AlertSeverity.critical)
          .length;
      final warningCount =
          activeAlerts.where((a) => a.severity == AlertSeverity.warning).length;

      if (criticalCount > 0) {
        return "$criticalCount alerte${criticalCount > 1 ? 's' : ''} critique${criticalCount > 1 ? 's' : ''}";
      } else if (warningCount > 0) {
        return "$warningCount alerte${warningCount > 1 ? 's' : ''}";
      } else {
        return "${activeAlerts.length} alerte${activeAlerts.length > 1 ? 's' : ''}";
      }
    },
    orElse: () => "Chargement...",
  );
});
