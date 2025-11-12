import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cellular_rosace_widget.dart';
import '../../providers/weather_providers.dart';
import '../../providers/soil_temp_provider.dart';
import '../../providers/soil_ph_provider.dart';

/// Integration Example: Cellular Rosace with Real Climate Data
///
/// This example shows how to integrate the Cellular Rosace V3 with
/// existing Riverpod providers for real climate data.
class CellularRosaceIntegrationExample extends ConsumerWidget {
  const CellularRosaceIntegrationExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers for real data
    const scopeKey = "garden:demo"; // TODO: Get from current garden selection

    final hasAlerts = ref.watch(shouldPulseAlertProvider);
    final currentWeather = ref.watch(currentWeatherProvider);
    final forecast = ref.watch(forecastProvider);
    final soilTempAsync = ref.watch(soilTempProviderByScope(scopeKey));
    final soilPHAsync = ref.watch(soilPHProviderByScope(scopeKey));

    // Extract values with fallbacks
    final minTemp =
        currentWeather.hasValue ? currentWeather.value!.minTemp : null;
    final maxTemp =
        currentWeather.hasValue ? currentWeather.value!.maxTemp : null;
    final weatherCondition =
        currentWeather.hasValue ? currentWeather.value!.condition : null;

    final soilTemp =
        soilTempAsync.hasValue ? (soilTempAsync.value ?? 18.3) : 18.3;
    final soilPH = soilPHAsync.hasValue ? (soilPHAsync.value ?? 6.8) : 6.8;

    // Get J+1 forecast data
    final tomorrowForecast = forecast.hasValue && forecast.value!.isNotEmpty
        ? forecast.value!.first
        : null;

    // Create data hierarchy based on real data
    final dataHierarchy = _createDataHierarchy(
      hasAlerts: hasAlerts,
      soilTemp: soilTemp,
      soilPH: soilPH,
      currentWeather: currentWeather,
      forecastData: tomorrowForecast,
    );

    // Create custom colors based on weather conditions
    final customColors = _createCustomColors(
      weatherCondition: weatherCondition,
      hasAlerts: hasAlerts,
      soilTemp: soilTemp,
      soilPH: soilPH,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cellular Rosace - Real Data'),
        backgroundColor: const Color(0xFF1B4332),
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: Column(
          children: [
            // Data status display
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Real Climate Data Integration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDataStatus('Weather', currentWeather.hasValue),
                  _buildDataStatus('Soil Temp', soilTempAsync.hasValue),
                  _buildDataStatus('Soil pH', soilPHAsync.hasValue),
                  _buildDataStatus('Forecast', forecast.hasValue),
                  _buildDataStatus('Alerts', hasAlerts),
                ],
              ),
            ),

            // Cellular rosace with real data
            Expanded(
              child: Center(
                child: CellularRosaceWidget(
                  dataHierarchy: dataHierarchy,
                  customColors: customColors,
                  onCellTap: (cellId) => _handleCellTap(context, cellId),
                  height: 280.0,
                  margin: const EdgeInsets.all(20.0),
                ),
              ),
            ),

            // Real data values display
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Values:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildValueDisplay('pH', soilPH.toStringAsFixed(1)),
                  _buildValueDisplay(
                      'Soil Temp', '${soilTemp.toStringAsFixed(1)}°C'),
                  _buildValueDisplay(
                      'Weather', _formatWeatherValue(minTemp, maxTemp)),
                  _buildValueDisplay(
                      'Forecast', _formatForecastValue(tomorrowForecast)),
                  _buildValueDisplay('Alerts', hasAlerts ? '2 active' : 'None'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataStatus(String label, bool hasData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            hasData ? Icons.check_circle : Icons.error_outline,
            size: 16,
            color: hasData ? const Color(0xFF4CAF50) : const Color(0xFFFF5722),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF558B2F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueDisplay(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF558B2F),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF689F38),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Create data hierarchy based on real climate data
  Map<String, double> _createDataHierarchy({
    required bool hasAlerts,
    required double soilTemp,
    required double soilPH,
    required AsyncValue currentWeather,
    required dynamic forecastData,
  }) {
    final hierarchy = <String, double>{};

    // pH core - always central and important
    hierarchy['ph_core'] = 1.0;

    // Weather current - high importance if data available
    hierarchy['weather_current'] = currentWeather.hasValue ? 0.9 : 0.3;

    // Soil temperature - importance based on value
    final soilTempImportance = _calculateSoilTempImportance(soilTemp);
    hierarchy['soil_temp'] = soilTempImportance;

    // Forecast - medium importance if available
    hierarchy['weather_forecast'] = forecastData != null ? 0.6 : 0.2;

    // Alerts - high importance if active
    hierarchy['alerts'] = hasAlerts ? 0.8 : 0.1;

    return hierarchy;
  }

  /// Calculate soil temperature importance based on value
  double _calculateSoilTempImportance(double soilTemp) {
    // Optimal soil temp range: 15-25°C
    if (soilTemp >= 15 && soilTemp <= 25) {
      return 0.7; // Normal importance
    } else if (soilTemp < 10 || soilTemp > 30) {
      return 0.9; // High importance (extreme values)
    } else {
      return 0.8; // Medium-high importance (suboptimal)
    }
  }

  /// Create custom colors based on real data conditions
  Map<String, Color> _createCustomColors({
    required dynamic weatherCondition,
    required bool hasAlerts,
    required double soilTemp,
    required double soilPH,
  }) {
    final colors = <String, Color>{};

    // pH color based on value
    if (soilPH < 6.0) {
      colors['ph_core'] = Colors.red.withOpacity(0.8); // Too acidic
    } else if (soilPH > 7.5) {
      colors['ph_core'] = Colors.blue.withOpacity(0.8); // Too alkaline
    } else {
      colors['ph_core'] = Colors.green.withOpacity(0.8); // Optimal
    }

    // Soil temp color based on value
    if (soilTemp < 10) {
      colors['soil_temp'] = Colors.blue.withOpacity(0.8); // Too cold
    } else if (soilTemp > 30) {
      colors['soil_temp'] = Colors.red.withOpacity(0.8); // Too hot
    } else {
      colors['soil_temp'] = Colors.green.withOpacity(0.8); // Optimal
    }

    // Alert color
    if (hasAlerts) {
      colors['alerts'] = Colors.orange.withOpacity(0.8); // Active alerts
    }

    return colors;
  }

  /// Format weather value for display
  String _formatWeatherValue(double? minTemp, double? maxTemp) {
    if (minTemp != null && maxTemp != null) {
      return '${maxTemp.toStringAsFixed(0)}° / ${minTemp.toStringAsFixed(0)}°';
    } else if (maxTemp != null) {
      return '${maxTemp.toStringAsFixed(0)}°';
    } else if (minTemp != null) {
      return '${minTemp.toStringAsFixed(0)}°';
    }
    return 'N/A';
  }

  /// Format forecast value for display
  String _formatForecastValue(dynamic forecast) {
    if (forecast == null) return 'N/A';

    // Assuming forecast has minTemp and maxTemp properties
    try {
      final minTemp = forecast.minTemp;
      final maxTemp = forecast.maxTemp;

      if (minTemp != null && maxTemp != null) {
        return 'J+1: ${maxTemp.toStringAsFixed(0)}°/${minTemp.toStringAsFixed(0)}°';
      } else if (maxTemp != null) {
        return 'J+1: ${maxTemp.toStringAsFixed(0)}°';
      }
    } catch (e) {
      // Handle different forecast data structures
    }

    return 'J+1: Available';
  }

  /// Handle cell tap with navigation
  void _handleCellTap(BuildContext context, String cellId) {
    String message;

    switch (cellId) {
      case 'ph_core':
        message = 'pH Core tapped - Navigate to pH input';
        break;
      case 'weather_current':
        message = 'Weather tapped - Navigate to day detail';
        break;
      case 'soil_temp':
        message = 'Soil temp tapped - Navigate to soil temp sheet';
        break;
      case 'weather_forecast':
        message = 'Forecast tapped - Navigate to forecast screen';
        break;
      case 'alerts':
        message = 'Alerts tapped - Navigate to alerts screen';
        break;
      default:
        message = 'Unknown cell tapped: $cellId';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

