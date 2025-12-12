import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';
import 'package:permacalendar/features/climate/presentation/widgets/weather_widgets.dart';
import 'package:permacalendar/core/services/open_meteo_service.dart';
import 'package:permacalendar/core/providers/app_settings_provider.dart';
import 'package:permacalendar/core/models/daily_weather_point.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    final userSettings = ref.read(appSettingsProvider); // To get commune name if API fails slightly

    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Invalidate to refresh
              ref.invalidate(currentWeatherProvider);
              ref.invalidate(forecastProvider);
            },
          )
        ],
      ),
      body: weatherAsync.when(
        data: (data) {
          // data.result contains the full OpenMeteoResult with new fields
          final current = data.result;
          final todayDaily = current.dailyWeather.isNotEmpty ? current.dailyWeather.first : null;
          
          // Safety: filter hourly points to show relevant ones (e.g. from now)
          final now = DateTime.now();
          final futureHourly = current.hourlyWeather
              .where((p) => p.time.isAfter(now.subtract(const Duration(hours: 1))))
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
                ref.invalidate(currentWeatherProvider);
                ref.invalidate(forecastProvider);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // A. En-tête
                  WeatherHeader(
                    commune: data.locationLabel,
                    temp: current.currentTemperatureC,
                    weatherCode: current.currentWeatherCode,
                    date: data.timestamp,
                  ),
                  const SizedBox(height: 24),
                  
                  // B. Vent
                  WindCard(
                    windSpeed: current.currentWindSpeed ?? 0.0,
                    windGusts: 0.0, // Pas dispo en "current" direct, mais on pourrait le chopper du premier hourly
                    windDirection: current.currentWindDirection ?? 0,
                    forecast: futureHourly,
                  ),
                  const SizedBox(height: 16),

                  // C. Précipitations
                  PrecipitationCard(hourly: current.hourlyWeather),
                  const SizedBox(height: 16),

                  // D. Températures Detail (optional, maybe specific card or just part of header?)
                  // Let's add a small row for explicit min/max/apparent
                  _buildTemperatureRow(context, current, todayDaily),
                  const SizedBox(height: 16),

                  // E. Soleil & Lune
                  if (todayDaily != null)
                      SunMoonCard(
                          sunrise: todayDaily.sunrise,
                          sunset: todayDaily.sunset,
                          moonrise: todayDaily.moonrise,
                          moonset: todayDaily.moonset,
                          moonPhase: todayDaily.moonPhase,
                      ),
                  const SizedBox(height: 16),

                  // F. Daily Summary
                  if (todayDaily != null)
                      DailySummaryCard(day: todayDaily),
                  
                  const SizedBox(height: 30),
                  const Center(child: Text("Données fournies par Open-Meteo", style: TextStyle(color: Colors.grey, fontSize: 10))),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              const Text('Impossible de charger la météo'),
              Text(err.toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(currentWeatherProvider),
                child: const Text('Réessayer'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureRow(BuildContext context, OpenMeteoResult current, DailyWeatherPoint? today) {
    // Try to get apparent temperature from current hourly point
    final now = DateTime.now();
    double? apparent;
    try {
        final match = current.hourlyWeather.firstWhere((p) => p.time.isAfter(now.subtract(const Duration(minutes: 30))), orElse: () => current.hourlyWeather.last);
        apparent = match.apparentTemperatureC;
    } catch (_) {}

    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.orange.withOpacity(0.05),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    _buildTempItem(context, 'Ressentie', '${apparent?.toStringAsFixed(1) ?? "--"}°'),
                    Container(width: 1, height: 24, color: Colors.grey[300]),
                    _buildTempItem(context, 'Min', '${today?.tMinC?.toStringAsFixed(1) ?? "--"}°'),
                     Container(width: 1, height: 24, color: Colors.grey[300]),
                    _buildTempItem(context, 'Max', '${today?.tMaxC?.toStringAsFixed(1) ?? "--"}°'),
                ],
            ),
        ),
    );
  }

  Widget _buildTempItem(BuildContext context, String label, String value) {
      return Column(
          children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
      );
  }
}