import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';
import 'package:permacalendar/features/climate/presentation/widgets/weather_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permacalendar/core/utils/weather_icon_mapper.dart';
import 'package:permacalendar/features/climate/presentation/widgets/weather_widgets_extended.dart';
import 'package:permacalendar/core/services/open_meteo_service.dart';
import 'package:permacalendar/core/providers/app_settings_provider.dart';
import 'package:permacalendar/core/models/daily_weather_point.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import 'weather_calibration_screen.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({super.key});

  String _formatTime(String? isoString) {
    if (isoString == null) return '--:--';
    try {
       DateTime dt;
       if (!isoString.endsWith('Z') && !isoString.contains('+')) {
         dt = DateTime.parse('${isoString}Z').toLocal();
       } else {
         dt = DateTime.parse(isoString).toLocal();
       }
       return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.weather_screen_title,
            style: const TextStyle(
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black45)])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.invalidate(currentWeatherProvider);
              ref.invalidate(forecastProvider);
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Gradient background stimulating the "Organic" feel
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6FABBA),
              Color(0xFF90C2C3)
            ], // Teal/Blueish inspired by screenshots
          ),
        ),
        child: weatherAsync.when(
          data: (data) {
            final current = data.result;
            final todayDaily = current.dailyWeather.isNotEmpty
                ? current.dailyWeather.first
                : null;

            final now = DateTime.now();
            final futureHourly = current.hourlyWeather
                .where((p) =>
                    p.time.isAfter(now.subtract(const Duration(hours: 1))))
                .toList();

            // Find current pressure from hourly data (closest to now)
            double currentPressure = 1013.0;
            try {
              final closest = current.hourlyWeather.reduce((a, b) =>
                  a.time.difference(now).abs() < b.time.difference(now).abs()
                      ? a
                      : b);
              currentPressure = closest.pressureMsl ?? 1013.0;
            } catch (_) {}

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(currentWeatherProvider);
                ref.invalidate(forecastProvider);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 100, left: 16, right: 16, bottom: 40),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // A. En-tête (White text for contrast)
                    // Use a clean custom header or keep existing but force white style
                    // A. En-tête (White text for contrast)
                    // Custom header with Watermark
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Filigrane SVG behind the temperature
                        if (current.currentWeatherCode != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SvgPicture.asset(
                              WeatherIconMapper.getIconPath(
                                  current.currentWeatherCode),
                              width: 200, // Large proportional size
                              height: 200,
                              colorFilter: ColorFilter.mode(
                                  Colors.white
                                      .withOpacity(0.15), // 12-25% opacity
                                  BlendMode.srcIn),
                            ),
                          ),

                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data.locationLabel.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(blurRadius: 4, color: Colors.black26)
                                      ])),
                              IconButton(
                                icon: const Icon(Icons.settings,
                                    size: 20, color: Colors.white70),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          const WeatherCalibrationScreen()));
                                },
                              ),
                            ],
                          ),
                          Text(
                              '${current.currentTemperatureC?.toStringAsFixed(1)}°',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                                  fontWeight: FontWeight.w200,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 10, color: Colors.black26)
                                  ])),
                          Text(
                              data.weatherCode != null
                                  ? WeatherIconMapper.getLocalizedDescription(
                                      l10n, data.weatherCode!)
                                  : (data.description ?? ''),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(blurRadius: 4, color: Colors.black26)
                                  ])),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // B. Hourly Graph (Green Star)
                    HourlyForecastWidget(hourlyData: futureHourly),
                    const SizedBox(height: 16),

                    // C. Daily List (Green Star)
                    DailyForecastListWidget(dailyData: current.dailyWeather),
                    const SizedBox(height: 16),

                    // D. Grid Modules
                    LayoutBuilder(builder: (context, constraints) {
                      final w = (constraints.maxWidth - 16) / 2;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: w,
                            child: WindCompassWidget(
                              speedKmh: current.currentWindSpeed ?? 0,
                              directionDegrees:
                                  current.currentWindDirection ?? 0,
                              gustsKmh: 0, // Could fetch from hourly
                            ),
                          ),
                          SizedBox(
                            width: w,
                            child: PressureGaugeWidget(
                                pressureHPa: currentPressure),
                          ),
                          if (todayDaily != null) ...[
                            SizedBox(
                                width: constraints.maxWidth,
                                child: SunPathWidget(
                                    sunrise: _formatTime(todayDaily.sunrise),
                                    sunset: _formatTime(todayDaily.sunset))),
                            SizedBox(
                                width: constraints.maxWidth,
                                child: MoonPhaseWidget(
                                  phase: todayDaily.moonPhase ?? 0.0,
                                  moonrise: _formatTime(todayDaily.moonrise),
                                  moonset: _formatTime(todayDaily.moonset),
                                )),
                          ]
                        ],
                      );
                    }),

                    const SizedBox(height: 30),
                    Center(
                        child: Text(l10n.weather_provider_credit,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 10))),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white)),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: Colors.white70),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Text(l10n.weather_error_loading,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(currentWeatherProvider),
                  child: Text(l10n.weather_action_retry),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
