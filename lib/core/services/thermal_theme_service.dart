import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/thermal_color_schemes.dart';
import '../../features/climate/domain/models/weather_view_data.dart';

/// Service de gestion intelligente du thème thermique météo-conscient
/// Intelligence saisonnière : 27Â°C juillet â‰  27Â°C février
class ThermalThemeService {
  /// Calculer température moyenne sur période avec contexte saisonnier
  double calculateAverageTemperature(WeatherViewData weather, {int days = 1}) {
    if (weather.dailyWeather.isEmpty) {
      return weather.currentTemperatureC ?? 15.0; // Fallback default temp
    }

    double totalTemp = 0;
    int validDays = 0;

    for (int i = 0; i < math.min(days, weather.dailyWeather.length); i++) {
      final day = weather.dailyWeather[i];
      if (day.tMinC != null && day.tMaxC != null) {
        totalTemp += (day.tMinC! + day.tMaxC!) / 2;
        validDays++;
      }
    }

    return validDays > 0
        ? totalTemp / validDays
        : (weather.currentTemperatureC ?? 15.0);
  }

  /// Obtenir seuils météo-conscients selon saison et géographie
  /// Adaptation saisonnière intelligente : 27Â°C juillet â‰  27Â°C février
  ThermalThresholds getSeasonalThresholds(DateTime date, String? location) {
    final month = date.month;

    if (_isWinterPeriod(month)) {
      // Hiver : seuils plus bas (sensibilité au froid réduite)
      return const ThermalThresholds(
        freeze: 0.0, // Gel reste absolu
        cold: 5.0, // 5Â°C = froid en hiver
        moderate: 15.0, // 15Â°C = agréable en hiver
        hot: 20.0, // 20Â°C = chaud en hiver !
      );
    } else if (_isSummerPeriod(month)) {
      // Été : seuils plus hauts (habitude chaleur)
      return const ThermalThresholds(
        freeze: 0.0, // Gel reste absolu
        cold: 15.0, // 15Â°C = frais en été
        moderate: 28.0, // 28Â°C = normal en été
        hot: 35.0, // 35Â°C = vraiment chaud en été
      );
    } else {
      // Intersaison : seuils standards
      return const ThermalThresholds(
        freeze: 0.0,
        cold: 10.0,
        moderate: 22.0,
        hot: 30.0,
      );
    }
  }

  /// Calculer intensité thermique (écart à la normale saisonnière)
  double calculateThermalIntensity(double temp, ThermalThresholds thresholds) {
    if (temp <= thresholds.freeze) {
      return 1.0; // Gel = intensité maximum
    } else if (temp <= thresholds.cold) {
      return 0.7; // Froid modéré
    } else if (temp <= thresholds.moderate) {
      return 0.0; // Neutre/tempéré
    } else if (temp <= thresholds.hot) {
      return 0.5; // Chaud modéré
    } else {
      return 1.0; // Canicule = intensité maximum
    }
  }

  /// Obtenir palette thermique avec intensité adaptée
  ThermalPaletteData getThermalPaletteData(
      double averageTemp, DateTime date, String? location) {
    final thresholds = getSeasonalThresholds(date, location);
    final intensity = calculateThermalIntensity(averageTemp, thresholds);
    final baseScheme = _getBaseThermalPalette(averageTemp, thresholds);

    return ThermalPaletteData(
      colorScheme: baseScheme,
      intensity: intensity,
      overlayColor: _getOverlayColor(averageTemp, thresholds, intensity),
      glowColor: _getGlowColor(averageTemp, thresholds),
      paletteName: _getPaletteName(averageTemp, thresholds),
      isSeasonallyAdjusted: true,
    );
  }

  /// Obtenir palette de base selon seuils contextuels
  ColorScheme _getBaseThermalPalette(
      double temp, ThermalThresholds thresholds) {
    if (temp <= thresholds.freeze) {
      return ThermalColorSchemes.freezePalette;
    } else if (temp <= thresholds.cold) {
      return ThermalColorSchemes.coldPalette;
    } else if (temp <= thresholds.moderate) {
      return ThermalColorSchemes.moderatePalette;
    } else if (temp <= thresholds.hot) {
      return ThermalColorSchemes.hotPalette;
    } else {
      return ThermalColorSchemes.heatwavePalette;
    }
  }

  /// Obtenir couleur overlay halo global (subtil)
  Color _getOverlayColor(
      double temp, ThermalThresholds thresholds, double intensity) {
    Color baseColor;

    if (temp <= thresholds.freeze) {
      baseColor = const Color(0xFF1976D2); // Bleu gel
    } else if (temp <= thresholds.cold) {
      baseColor = const Color(0xFF00ACC1); // Cyan froid
    } else if (temp <= thresholds.moderate) {
      return Colors.transparent; // Pas d'overlay pour tempéré
    } else if (temp <= thresholds.hot) {
      baseColor = const Color(0xFFFF8A65); // Orange chaud
    } else {
      baseColor = const Color(0xFFFF5722); // Rouge canicule
    }

    // Appliquer intensité (opacity réduite si écart faible)
    return baseColor.withOpacity(0.08 * intensity); // Max 8% opacity (subtil)
  }

  /// Obtenir couleur glow des bulles
  Color _getGlowColor(double temp, ThermalThresholds thresholds) {
    if (temp <= thresholds.freeze) {
      return const Color(0xFF64B5F6); // Glow bleu glacé
    } else if (temp <= thresholds.cold) {
      return const Color(0xFF4DD0E1); // Glow cyan
    } else if (temp <= thresholds.moderate) {
      return const Color(0xFF81C784); // Glow vert (actuel)
    } else if (temp <= thresholds.hot) {
      return const Color(0xFFFFB74D); // Glow orange
    } else {
      return const Color(0xFFFF8A65); // Glow rouge
    }
  }

  String _getPaletteName(double temp, ThermalThresholds thresholds) {
    if (temp <= thresholds.freeze) return "Gel";
    if (temp <= thresholds.cold) return "Froid";
    if (temp <= thresholds.moderate) return "Tempéré";
    if (temp <= thresholds.hot) return "Chaud";
    return "Canicule";
  }

  bool _isWinterPeriod(int month) => month == 12 || month == 1 || month == 2;
  bool _isSummerPeriod(int month) => month == 6 || month == 7 || month == 8;

  /// Mode debug pour tests forcés
  ThermalPaletteData getDebugPalette(DebugThermalMode mode) {
    switch (mode) {
      case DebugThermalMode.freeze:
        return ThermalPaletteData(
          colorScheme: ThermalColorSchemes.freezePalette,
          intensity: 1.0,
          overlayColor: const Color(0xFF1976D2).withOpacity(0.08),
          glowColor: const Color(0xFF64B5F6),
          paletteName: "DEBUG: Gel",
          isSeasonallyAdjusted: false,
        );
      case DebugThermalMode.heatwave:
        return ThermalPaletteData(
          colorScheme: ThermalColorSchemes.heatwavePalette,
          intensity: 1.0,
          overlayColor: const Color(0xFFFF5722).withOpacity(0.08),
          glowColor: const Color(0xFFFF8A65),
          paletteName: "DEBUG: Canicule",
          isSeasonallyAdjusted: false,
        );
      case DebugThermalMode.moderate:
      default:
        return const ThermalPaletteData(
          colorScheme: ThermalColorSchemes.moderatePalette,
          intensity: 0.0,
          overlayColor: Colors.transparent,
          glowColor: Color(0xFF81C784),
          paletteName: "DEBUG: Tempéré",
          isSeasonallyAdjusted: false,
        );
    }
  }
}

/// Seuils thermiques contextuels
class ThermalThresholds {
  final double freeze;
  final double cold;
  final double moderate;
  final double hot;

  const ThermalThresholds({
    required this.freeze,
    required this.cold,
    required this.moderate,
    required this.hot,
  });
}

/// Données palette thermique complètes
class ThermalPaletteData {
  final ColorScheme colorScheme;
  final double intensity; // 0.0-1.0 intensité thermique
  final Color overlayColor; // Couleur halo global
  final Color glowColor; // Couleur glow bulles
  final String paletteName;
  final bool isSeasonallyAdjusted;

  const ThermalPaletteData({
    required this.colorScheme,
    required this.intensity,
    required this.overlayColor,
    required this.glowColor,
    required this.paletteName,
    required this.isSeasonallyAdjusted,
  });
}

/// Modes debug pour tests
enum DebugThermalMode {
  freeze, // Force palette gel
  heatwave, // Force palette canicule
  moderate, // Force palette tempérée
}


