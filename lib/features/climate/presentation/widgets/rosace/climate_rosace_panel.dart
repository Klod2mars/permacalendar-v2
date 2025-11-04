import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'climate_rosace_petal.dart';
import 'climate_rosace_center_ph.dart';
import 'anim/scale_halo_tap.dart';
import 'anim/pulse_alert.dart';
import '../../screens/soil_temp_sheet.dart';
import '../../screens/ph_input_sheet.dart';
import '../../screens/climate_day_detail_screen.dart';
import '../../screens/climate_alerts_screen.dart';
import '../../screens/climate_forecast_history_screen.dart';
import '../../providers/weather_providers.dart';
import '../../../../../features/climate/domain/models/weather_view_data.dart';
import '../../../../../core/models/daily_weather_point.dart';
import '../../providers/soil_temp_provider.dart';
import '../../providers/soil_ph_provider.dart';
import '../../providers/daily_update_provider.dart';
import '../../providers/narrative_mode_provider.dart';
import '../../anim/weather_halo_controller.dart';

/// Climate Rosace Panel - V2 Geometric Rounded Design
///
/// 4-petal rosace with central pH core, featuring:
/// - North: Alerts (with pulse if active)
/// - East: Day J0 (current weather)
/// - South: Forecast/History
/// - West: Soil Temperature
/// - Center: pH value (tappable)
///
/// Height constraint: ≤240dp on mobile 360×800
/// Performance: 60fps on Samsung A35
class ClimateRosacePanel extends ConsumerWidget {
  const ClimateRosacePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Phase 2: Wire up real providers
    const scopeKey = "garden:demo"; // TODO: Get from current garden selection

    // Watch providers for real data
    final hasAlerts = ref.watch(shouldPulseAlertProvider);
    final currentWeather = ref.watch(currentWeatherProvider);
    final forecast = ref.watch(forecastProvider);
    final soilTempAsync = ref.watch(soilTempProviderByScope(scopeKey));
    final soilPHAsync = ref.watch(soilPHProviderByScope(scopeKey));

    // Phase 4: Watch narrative mode and halo color
    final narrativeMode = ref.watch(narrativeModeProvider);
    final haloColor = ref.watch(weatherHaloColorProvider);

    // Helper to parse condition string to WeatherConditionType
    WeatherConditionType? parseCondition(String? conditionStr) {
      if (conditionStr == null) return null;
      try {
        // Extract enum name from string (e.g., "WeatherConditionType.sunny" -> "sunny")
        final name = conditionStr.contains('.')
            ? conditionStr.split('.').last
            : conditionStr;
        return WeatherConditionType.values.firstWhere(
          (e) => e.name == name,
          orElse: () => WeatherConditionType.other,
        );
      } catch (_) {
        return WeatherConditionType.other;
      }
    }

    // Extract values with fallbacks
    final minTemp =
        currentWeather.hasValue ? currentWeather.value!.minTemp : null;
    final maxTemp =
        currentWeather.hasValue ? currentWeather.value!.maxTemp : null;
    final weatherIcon =
        currentWeather.hasValue ? (currentWeather.value!.icon ?? '☀️') : '☀️';
    final weatherCondition = currentWeather.hasValue
        ? parseCondition(currentWeather.value!.condition)
        : null;

    final soilTemp =
        soilTempAsync.hasValue ? (soilTempAsync.value ?? 18.3) : 18.3;
    final soilPH = soilPHAsync.hasValue ? (soilPHAsync.value ?? 6.8) : 6.8;

    // Get J+1 forecast data
    final tomorrowForecast = forecast.hasValue && forecast.value!.isNotEmpty
        ? forecast.value!.first
        : null;

    // Trigger daily update check on first build and when weather changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleWeatherUpdate(ref, scopeKey, currentWeather);
    });

    return WeatherHaloControllerWidget(
      child: Container(
        height: 240, // Max height constraint
        margin: const EdgeInsets.all(16),
        child: _FrostCard(
          emphasis: FrostEmphasis.normal,
          weatherCondition: weatherCondition,
          narrativeMode: narrativeMode,
          haloColor: haloColor,
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              // 4 Petals positioned in NSEW
              _buildPetal(
                context: context,
                position: RosacePosition.north,
                icon: Icons.warning_amber_rounded,
                label: 'Alertes',
                value: hasAlerts ? '2' : null,
                alertMode: hasAlerts,
                onTap: () => _navigateToAlerts(context),
              ),

              _buildPetal(
                context: context,
                position: RosacePosition.east,
                icon: Icons.wb_sunny,
                label: 'Aujourd\'hui',
                value: _formatWeatherValue(minTemp, maxTemp),
                weatherIcon: weatherIcon,
                onTap: () => _navigateToDayDetail(context),
              ),

              _buildPetal(
                context: context,
                position: RosacePosition.south,
                icon: Icons.timeline,
                label: 'Prévisions',
                value: _formatForecastValue(tomorrowForecast),
                onTap: () => _navigateToForecast(context),
              ),

              _buildPetal(
                context: context,
                position: RosacePosition.west,
                icon: Icons.thermostat,
                label: 'Sol',
                value: '${soilTemp.toStringAsFixed(1)}°',
                onTap: () => _showSoilTempSheet(context),
              ),

              // Central pH circle
              Center(
                child: ScaleHaloTap(
                  onTap: () => _showPHInputSheet(context),
                  child: ClimateRosaceCenterPH(
                    phValue: soilPH,
                    alertMode: hasAlerts,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetal({
    required BuildContext context,
    required RosacePosition position,
    required IconData icon,
    required String label,
    required String? value,
    required VoidCallback onTap,
    bool alertMode = false,
    String? weatherIcon,
  }) {
    return Positioned(
      top: position.top,
      left: position.left,
      right: position.right,
      bottom: position.bottom,
      child: ScaleHaloTap(
        onTap: onTap,
        child: PulseAlert(
          isActive: alertMode,
          child: ClimateRosacePetal(
            icon: icon,
            label: label,
            value: value,
            alertMode: alertMode,
            weatherIcon: weatherIcon,
          ),
        ),
      ),
    );
  }

  void _navigateToAlerts(BuildContext context) {
    // TODO: Add route to app_router.dart
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClimateAlertsScreen(),
      ),
    );
  }

  void _navigateToDayDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClimateDayDetailScreen(),
      ),
    );
  }

  void _navigateToForecast(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClimateForecastHistoryScreen(),
      ),
    );
  }

  void _showSoilTempSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SoilTempSheet(),
    );
  }

  void _showPHInputSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PHInputSheet(),
    );
  }

  /// Format weather value for EAST petal (min/max temp)
  String? _formatWeatherValue(double? minTemp, double? maxTemp) {
    if (minTemp != null && maxTemp != null) {
      return '${maxTemp.toStringAsFixed(0)}° / ${minTemp.toStringAsFixed(0)}°';
    } else if (maxTemp != null) {
      return '${maxTemp.toStringAsFixed(0)}°';
    } else if (minTemp != null) {
      return '${minTemp.toStringAsFixed(0)}°';
    }
    return null;
  }

  /// Format forecast value for SOUTH petal (J+1)
  String? _formatForecastValue(DailyWeatherPoint? forecast) {
    if (forecast == null) return 'J+1';

    // Utiliser tMinC/tMaxC (bruts) ou minTemp/maxTemp (enrichis) selon disponibilité
    final maxTemp = forecast.maxTemp ?? forecast.tMaxC;
    final minTemp = forecast.minTemp ?? forecast.tMinC;

    if (minTemp != null && maxTemp != null) {
      return 'J+1\n${maxTemp.toStringAsFixed(0)}°/${minTemp.toStringAsFixed(0)}°';
    } else if (maxTemp != null) {
      return 'J+1\n${maxTemp.toStringAsFixed(0)}°';
    }
    return 'J+1';
  }

  /// Handle weather update and trigger soil temp update if needed
  void _handleWeatherUpdate(WidgetRef ref, String scopeKey,
      AsyncValue<WeatherViewData> currentWeather) {
    if (!currentWeather.hasValue) return;

    final weatherData = currentWeather.value!;
    final now = DateTime.now();

    // Check if this is a new day or if weather data is fresh
    final isNewDay = _isNewDay(weatherData.timestamp);
    final isFreshData = now.difference(weatherData.timestamp).inHours < 1;

    if (isNewDay || isFreshData) {
      // Trigger soil temperature update with current air temperature
      ref.read(dailyUpdateProvider).checkAndUpdateSoilTemp(scopeKey);
    }
  }

  /// Check if the weather timestamp represents a new day
  bool _isNewDay(DateTime weatherTimestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weatherDay = DateTime(
        weatherTimestamp.year, weatherTimestamp.month, weatherTimestamp.day);

    return weatherDay.isAtSameMomentAs(today);
  }
}

/// Position helper for the 4 petals
class RosacePosition {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const RosacePosition({
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  static const north = RosacePosition(top: 0, left: 0, right: 0);
  static const east = RosacePosition(top: 0, right: 0, bottom: 0);
  static const south = RosacePosition(left: 0, right: 0, bottom: 0);
  static const west = RosacePosition(top: 0, left: 0, bottom: 0);
}

// ============================================================================
// FROST CARD COMPONENT (reused from existing climate widgets)
// ============================================================================

enum FrostEmphasis { low, normal, high }

class _FrostCard extends StatelessWidget {
  const _FrostCard({
    required this.child,
    this.emphasis = FrostEmphasis.normal,
    this.weatherCondition,
    this.narrativeMode = true,
    this.haloColor = Colors.transparent,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final FrostEmphasis emphasis;
  final WeatherConditionType? weatherCondition;
  final bool narrativeMode;
  final Color haloColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final blur = switch (emphasis) {
      FrostEmphasis.high => 16.0,
      FrostEmphasis.normal => 12.0,
      FrostEmphasis.low => 8.0,
    };
    final opacity = switch (emphasis) {
      FrostEmphasis.high => 0.28,
      FrostEmphasis.normal => 0.22,
      FrostEmphasis.low => 0.16,
    };

    // Get halo color based on narrative mode
    final effectiveHaloColor =
        narrativeMode ? haloColor : _getWeatherHaloColor(weatherCondition);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24), // More rounded for V2
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            // Add weather-reactive halo as a subtle overlay
            boxShadow: effectiveHaloColor != null &&
                    effectiveHaloColor != Colors.transparent
                ? [
                    BoxShadow(
                      color: effectiveHaloColor,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }

  /// Get weather-reactive halo color based on condition
  Color? _getWeatherHaloColor(WeatherConditionType? condition) {
    if (condition == null) return null;

    switch (condition) {
      case WeatherConditionType.sunny:
        return Colors.amber.withValues(alpha: 0.15);
      case WeatherConditionType.rainy:
        return Colors.blueAccent.withValues(alpha: 0.15);
      case WeatherConditionType.hot:
        return Colors.orange.withValues(alpha: 0.15);
      case WeatherConditionType.snowOrFrost:
        return const Color(0xFFB3E5FC).withValues(alpha: 0.15);
      case WeatherConditionType.cloudy:
        return Colors.grey.withValues(alpha: 0.10);
      case WeatherConditionType.stormy:
        return Colors.purple.withValues(alpha: 0.15);
      case WeatherConditionType.other:
        return null; // No halo for other conditions
    }
  }
}
