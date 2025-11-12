import 'package:riverpod/riverpod.dart';
import 'package:permacalendar/core/services/environment_service.dart';
import 'package:permacalendar/core/services/open_meteo_service.dart';

class WeatherViewData {
  final String locationLabel;
  final Coordinates coordinates;
  final OpenMeteoResult result;
  WeatherViewData({
    required this.locationLabel,
    required this.coordinates,
    required this.result,
  });
}

/// Provider principal pour charger la météo par nom de commune.
/// Si la commune n'est pas fournie ou non résolue, utilise les coordonnées par défaut.
final weatherByCommuneProvider =
    FutureProvider.family<WeatherViewData, String?>((ref, communeName) async {
  try {
    final svc = OpenMeteoService.instance;
    // ✅ CORRECTION : Désactiver temporairement le tracking météo pour éviter les boucles
    // final activityService = ref.read(activityServiceProvider);

    // Résoudre coordonnées de la commune si possible
    Coordinates? coords = await svc.resolveCoordinates(communeName);
    coords ??= Coordinates(
      latitude: EnvironmentService.defaultLatitude,
      longitude: EnvironmentService.defaultLongitude,
      resolvedName: EnvironmentService.defaultCommuneName,
    );

    final result = await svc.fetchPrecipitation(
      latitude: coords.latitude,
      longitude: coords.longitude,
    );

    final label = coords.resolvedName ??
        (communeName ?? EnvironmentService.defaultCommuneName);

    // ✅ CORRECTION : Désactiver temporairement le tracking météo pour éviter les boucles
    // TODO: Réactiver le tracking météo une fois les boucles résolues
    /*
    try {
      await activityService.trackWeatherDataFetched(
        location: label,
        weatherData: {
          'latitude': coords.latitude,
          'longitude': coords.longitude,
          'precipitationData': result.hourlyPrecipitation.map((p) => {
            'time': p.time.toIso8601String(),
            'precipitation': p.millimeters,
          }).toList(),
          'fetchedAt': DateTime.now().toIso8601String(),
        },
        metadata: {
          'communeName': communeName,
          'resolvedName': coords.resolvedName,
          'dataSource': 'OpenMeteo',
        },
      );

      // Vérifier s'il y a des alertes météo à déclencher
      final hasHighPrecipitation = result.hourlyPrecipitation.any((p) => p.millimeters > 10.0);
      if (hasHighPrecipitation) {
        await activityService.trackWeatherAlertTriggered(
          location: label,
          alertType: 'precipitation',
          alertMessage: 'Fortes précipitations prévues (>10mm)',
          metadata: {
            'maxPrecipitation': result.hourlyPrecipitation.map((p) => p.millimeters).reduce((a, b) => a > b ? a : b),
            'alertThreshold': 10.0,
          },
        );
      }
    } catch (e) {
      // En cas d'erreur de tracking, on continue sans bloquer l'affichage météo
    }
    */

    return WeatherViewData(
        locationLabel: label, coordinates: coords, result: result);
  } catch (e) {
    // En cas d'erreur réseau, retourner des données par défaut
    return WeatherViewData(
      locationLabel: communeName ?? EnvironmentService.defaultCommuneName,
      coordinates: Coordinates(
        latitude: EnvironmentService.defaultLatitude,
        longitude: EnvironmentService.defaultLongitude,
        resolvedName: EnvironmentService.defaultCommuneName,
      ),
      result: OpenMeteoResult(
        latitude: EnvironmentService.defaultLatitude,
        longitude: EnvironmentService.defaultLongitude,
        hourlyPrecipitation: [],
        dailyWeather: [],
      ),
    );
  }
});

