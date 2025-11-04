import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/thermal_color_schemes.dart';
import '../services/thermal_theme_service.dart';
import '../services/open_meteo_service.dart';
import '../../features/climate/domain/models/weather_view_data.dart'
    as domain_weather;
import '../services/environment_service.dart';

/// Provider pour mode debug thermal (développement)
final debugThermalModeProvider = Provider<DebugThermalMode?>((ref) => null);

/// Provider pour thème thermique dynamique avec support debug
final thermalThemeProvider =
    FutureProvider.family<ThermalPaletteData, String>((ref, commune) async {
  final thermalService = ThermalThemeService();
  final debugMode = ref.read(debugThermalModeProvider);

  // Mode debug : retourner palette forcée
  if (debugMode != null) {
    return thermalService.getDebugPalette(debugMode);
  }

  // Mode normal : analyse météo temps réel (via OpenMeteoService)
  try {
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
      forecastDays: 3,
    );
    final weather = domain_weather.WeatherViewData(
      locationLabel: coords.resolvedName ?? commune,
      coordinates: coords,
      result: result,
    );
    final averageTemp =
        thermalService.calculateAverageTemperature(weather, days: 1);
    return thermalService.getThermalPaletteData(
      averageTemp,
      DateTime.now(),
      weather.locationLabel,
    );
  } catch (_) {
    // fall through to fallback
  }

  // Fallback : palette tempérée
  return thermalService.getThermalPaletteData(22.0, DateTime.now(), commune);
});

/// Provider pour ColorScheme thermique actuel
final currentThermalColorSchemeProvider =
    Provider.family<ColorScheme?, String>((ref, commune) {
  final thermalAsync = ref.watch(thermalThemeProvider(commune));
  return thermalAsync.maybeWhen(
    data: (thermalData) => thermalData.colorScheme,
    orElse: () => ThermalColorSchemes.moderatePalette, // Fallback tempéré
  );
});

/// Provider pour couleur glow bulles
final currentGlowColorProvider = Provider.family<Color, String>((ref, commune) {
  final thermalAsync = ref.watch(thermalThemeProvider(commune));
  return thermalAsync.maybeWhen(
    data: (thermalData) => thermalData.glowColor,
    orElse: () => const Color(0xFF81C784), // Fallback vert
  );
});

/// Provider pour overlay halo global
final currentOverlayColorProvider =
    Provider.family<Color, String>((ref, commune) {
  final thermalAsync = ref.watch(thermalThemeProvider(commune));
  return thermalAsync.maybeWhen(
    data: (thermalData) => thermalData.overlayColor,
    orElse: () => Colors.transparent, // Fallback transparent
  );
});

/// Provider pour nom palette actuelle (debug/UI)
final currentPaletteNameProvider =
    Provider.family<String, String>((ref, commune) {
  final thermalAsync = ref.watch(thermalThemeProvider(commune));
  return thermalAsync.maybeWhen(
    data: (thermalData) => thermalData.paletteName,
    orElse: () => "Tempéré", // Défaut
  );
});

/// Provider pour intensité thermique actuelle
final currentThermalIntensityProvider =
    Provider.family<double, String>((ref, commune) {
  final thermalAsync = ref.watch(thermalThemeProvider(commune));
  return thermalAsync.maybeWhen(
    data: (thermalData) => thermalData.intensity,
    orElse: () => 0.0, // Défaut neutre
  );
});

/// Helper pour activer mode debug
class ThermalDebugController {
  static void setDebugMode(WidgetRef ref, DebugThermalMode? mode) {
    // TODO: Implement debug mode setting when StateNotifier is available
    // For now, this is a placeholder
  }

  static void clearDebugMode(WidgetRef ref) {
    // TODO: Implement debug mode clearing when StateNotifier is available
    // For now, this is a placeholder
  }

  /// Méthodes de convenance pour tests rapides
  static void forceFreeze(WidgetRef ref) {
    setDebugMode(ref, DebugThermalMode.freeze);
  }

  static void forceHeatwave(WidgetRef ref) {
    setDebugMode(ref, DebugThermalMode.heatwave);
  }

  static void forceModerate(WidgetRef ref) {
    setDebugMode(ref, DebugThermalMode.moderate);
  }

  static void resetToNormal(WidgetRef ref) {
    clearDebugMode(ref);
  }
}
