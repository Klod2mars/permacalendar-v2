import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import 'dart:math' as math;
import 'package:permacalendar/core/models/daily_weather_point.dart';
import 'package:permacalendar/core/models/hourly_weather_point.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/weather_icon_mapper.dart';

// 1. Header Widget
import '../screens/weather_calibration_screen.dart';

class WeatherHeader extends StatelessWidget {
  final String commune;
  final double? temp;
  final int? weatherCode;
  final DateTime date;

  const WeatherHeader({
    super.key,
    required this.commune,
    this.temp,
    this.weatherCode,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              commune.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
             // SETTINGS BUTTON (Internal)
             IconButton(
              icon: const Icon(Icons.settings, size: 20, color: Colors.black54),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const WeatherCalibrationScreen()));
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE d MMMM • HH:mm', locale).format(date),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        // Watermark / Filigrane design
        Stack(
          alignment: Alignment.center,
          children: [
            if (weatherCode != null)
              SvgPicture.asset(
                WeatherIconMapper.getIconPath(weatherCode!),
                width: 140, // Large watermark
                height: 140,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.2), // Filigrane subtle
                  BlendMode.srcIn,
                ),
              ),
            Text(
              temp != null ? '${temp!.toStringAsFixed(1)}°' : '--',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w300,
                shadows: [
                  const Shadow(blurRadius: 10, color: Colors.black26),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          weatherCode != null
              ? WeatherIconMapper.getLocalizedDescription(l10n, weatherCode!)
              : '',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

// 2. Wind Card
class WindCard extends StatelessWidget {
  final double windSpeed;
  final double windGusts;
  final int windDirection; // degrees
  // Optional: Hourly forecast for wind arrow list?
  final List<HourlyWeatherPoint> forecast;

  const WindCard({
    super.key,
    required this.windSpeed,
    required this.windGusts,
    required this.windDirection,
    this.forecast = const [],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      color: Colors.blueGrey.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.air, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(l10n.weather_label_wind,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfo(
                    context, l10n.weather_data_speed, '${windSpeed.toStringAsFixed(1)} km/h'),
                _buildDirectionArrow(windDirection),
                _buildInfo(
                    context, l10n.weather_data_gusts, '${windGusts.toStringAsFixed(1)} km/h',
                    isWarning: windGusts > 40),
              ],
            ),
            if (forecast.isNotEmpty) ...[
              const Divider(height: 32),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: math.min(forecast.length, 12), // next 12 hours
                  itemBuilder: (ctx, i) {
                    final p = forecast[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${p.time.hour}h',
                              style: const TextStyle(fontSize: 10)),
                          const SizedBox(height: 4),
                          Transform.rotate(
                            angle: p.windDirection * (math.pi / 180),
                            child: const Icon(Icons.navigation,
                                size: 16, color: Colors.blueGrey),
                          ),
                          const SizedBox(height: 4),
                          Text('${p.windSpeedkmh.round()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, String label, String value,
      {bool isWarning = false}) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isWarning ? Colors.redAccent : null)),
      ],
    );
  }

  Widget _buildDirectionArrow(int degrees) {
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SO', 'O', 'NO'];
    final index = ((degrees + 22.5) % 360) ~/ 45;
    final cardDir = directions[index];

    return Column(
      children: [
        Transform.rotate(
          angle: (degrees - 180) *
              (math.pi /
                  180), // Icon points up by default usually, navigation icon points up
          child: const Icon(Icons.navigation, size: 32, color: Colors.blue),
        ),
        Text('$degrees° $cardDir',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// 3. Precipitation Card
class PrecipitationCard extends StatelessWidget {
  final List<HourlyWeatherPoint> hourly;

  const PrecipitationCard({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    // Filter next 24h
    final now = DateTime.now();
    final future = hourly
        .where((p) =>
            p.time.isAfter(now.subtract(const Duration(hours: 1))) &&
            p.time.isBefore(now.add(const Duration(hours: 24))))
        .toList();

    return Card(
      elevation: 0,
      color: Colors.blue.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.umbrella, color: Colors.blue),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.weather_header_precipitations,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: future.length,
                itemBuilder: (ctx, i) {
                  final p = future[i];
                  final isRainy = p.precipitationMm > 0;
                  return Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isRainy
                          ? Colors.blue.withOpacity(
                              0.1 + (math.min(p.precipitationMm, 5.0) / 10))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isRainy
                          ? Border.all(color: Colors.blue.withOpacity(0.3))
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${p.time.hour}h',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                        const Spacer(),
                        if (p.precipitationProbability > 0)
                          Text('${p.precipitationProbability}%',
                              style: const TextStyle(
                                  fontSize: 9, color: Colors.blueAccent)),
                        const SizedBox(height: 4),
                        if (p.precipitationMm > 0)
                          Container(
                            height: math.max(
                                4.0,
                                math.min(
                                    30.0, p.precipitationMm * 5)), // Visual bar
                            width: 8,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text('${p.precipitationMm}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: isRainy
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Sun & Moon Card
class SunMoonCard extends StatelessWidget {
  final String? sunrise;
  final String? sunset;
  final String? moonrise;
  final String? moonset;
  final double? moonPhase; // 0..1

  const SunMoonCard({
    super.key,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      color: Colors.orange.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                const SizedBox(width: 8),
                Text(l10n.weather_label_astro,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAstreColumn(l10n.weather_data_sunrise, Icons.wb_sunny, sunrise ?? '--:--',
                    sunset ?? '--:--', Colors.orange),
                Container(
                    width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                _buildAstreColumn('Lune', Icons.nightlight_round,
                    moonrise ?? '--:--', moonset ?? '--:--', Colors.indigo),
              ],
            ),
            if (moonPhase != null) ...[
              const SizedBox(height: 12),
              Text(_getMoonPhaseName(moonPhase!, l10n),
                  style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.indigo)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildAstreColumn(
      String title, IconData icon, String up, String down, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Row(children: [
          const Icon(Icons.arrow_upward, size: 12, color: Colors.grey),
          const SizedBox(width: 2),
          Text(up, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 2),
        Row(children: [
          const Icon(Icons.arrow_downward, size: 12, color: Colors.grey),
          const SizedBox(width: 2),
          Text(down, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }

  String _getMoonPhaseName(double phase, AppLocalizations l10n) {
    if (phase == 0 || phase == 1) return l10n.moon_phase_new;
    if (phase < 0.25) return l10n.moon_phase_waxing_crescent;
    if (phase == 0.25) return l10n.moon_phase_first_quarter;
    if (phase < 0.5) return l10n.moon_phase_waxing_gibbous;
    if (phase == 0.5) return l10n.moon_phase_full;
    if (phase < 0.75) return l10n.moon_phase_waning_gibbous;
    if (phase == 0.75) return l10n.moon_phase_last_quarter;
    return l10n.moon_phase_waning_crescent;
  }
}

// 5. Daily Summary Card
class DailySummaryCard extends StatelessWidget {
  final DailyWeatherPoint day;

  const DailySummaryCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
        elevation: 0,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(l10n.weather_header_daily_summary,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItem(
                      l10n.weather_data_max, '${day.tMaxC?.toStringAsFixed(1) ?? '--'}°'),
                  _buildItem(
                      l10n.weather_data_min, '${day.tMinC?.toStringAsFixed(1) ?? '--'}°'),
                  _buildItem(l10n.weather_data_rain, '${day.precipMm}mm'),
                  _buildItem(
                      l10n.weather_data_wind_max, '${day.windSpeedMax?.round() ?? '--'}k'),
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildItem(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
