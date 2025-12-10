import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';
import 'package:permacalendar/features/climate/domain/models/weather_view_data.dart';
import 'package:permacalendar/core/models/daily_weather_point.dart';
import 'package:permacalendar/core/services/open_meteo_service.dart' as om;
import 'package:permacalendar/core/utils/weather_icon_mapper.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(currentWeatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Météo'),
        elevation: 0,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => _ErrorBody(error: e, onRetry: () => ref.refresh(currentWeatherProvider)),
        data: (view) => WeatherDetailsBody(view: view),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const _ErrorBody({Key? key, required this.error, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text('Impossible de charger la météo', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(error.toString(), textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
            const SizedBox(height: 14),
            ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

class WeatherDetailsBody extends StatelessWidget {
  final WeatherViewData view;
  const WeatherDetailsBody({Key? key, required this.view}) : super(key: key);

  String _fmtTime(DateTime? t) {
    if (t == null) return '—';
    return DateFormat.Hm('fr_FR').format(t);
  }

  String _fmtDay(DateTime d) {
    return DateFormat.E('fr_FR').format(d); // ex : lun., mar.
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    final temp = view.currentTemperatureC?.toStringAsFixed(1) ?? (view.temperature != null ? view.temperature!.toStringAsFixed(1) : '--');
    final iconPath = view.icon;
    final description = view.description ?? '';
    final min = view.minTemp != null ? '${view.minTemp!.round()}°' : '—';
    final max = view.maxTemp != null ? '${view.maxTemp!.round()}°' : '—';

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // icon
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white10),
              child: iconPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(iconPath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.wb_cloudy, size: 40)),
                    )
                  : const Icon(Icons.wb_sunny, size: 40),
            ),
            const SizedBox(width: 12),
            // texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(view.locationLabel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('$temp°', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(description, style: theme.textTheme.bodySmall)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('↑ $max • ↓ $min', style: theme.textTheme.bodySmall),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dailyForecast(BuildContext context) {
    final theme = Theme.of(context);
    final List<DailyWeatherPoint> days = view.dailyWeather;
    return Card(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prévisions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: days.take(7).map((d) {
                final icon = d.icon ?? (d.weatherCode != null ? WeatherIconMapper.getIconPath(d.weatherCode) : null);
                final precip = d.precipitation != null ? '${(d.precipitation! * 1).toStringAsFixed(1)} mm' : '${(d.precipMm).toStringAsFixed(1)} mm';
                final tmax = d.maxTemp ?? d.tMaxC;
                final tmin = d.minTemp ?? d.tMinC;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      SizedBox(width: 56, child: Text(_fmtDay(d.date), style: theme.textTheme.bodyMedium)),
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(icon, width: 28, height: 28, errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 22)),
                        )
                      else
                        const SizedBox(width: 28, height: 28),
                      Expanded(child: Text(precip, style: theme.textTheme.bodySmall)),
                      const SizedBox(width: 12),
                      Text('${tmax?.round() ?? '—'}°', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('${tmin?.round() ?? '—'}°', style: theme.textTheme.bodySmall),
                    ],
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _hourlyPrecip(BuildContext context) {
    final theme = Theme.of(context);
    final List<om.PrecipPoint> hours = view.result.hourlyPrecipitation;
    // show next 12 hours
    final now = DateTime.now();
    final upcoming = hours.where((p) => p.time.isAfter(now.subtract(const Duration(hours: 1)))).toList();
    final take = upcoming.isNotEmpty ? upcoming.take(12).toList() : (hours.take(12).toList());

    return Card(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.03),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Précipitations horaires', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: take.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final p = take[i];
                final hour = DateFormat.Hm('fr_FR').format(p.time);
                return Container(
                  width: 72,
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(hour, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                      Icon(p.millimeters > 0.1 ? Icons.grain : Icons.wb_sunny, color: Colors.white70),
                      Text('${p.millimeters.toStringAsFixed(1)} mm', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 12),
            // Two-column row if width allows
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _dailyForecast(context)),
                    const SizedBox(width: 12),
                    Expanded(flex: 1, child: Column(children: [_hourlyPrecip(context)])),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _dailyForecast(context),
                    const SizedBox(height: 12),
                    _hourlyPrecip(context),
                  ],
                );
              }
            }),
            const SizedBox(height: 18),
            // Simple metadata footer
            Card(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.02),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Données', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Dernière mise à jour : ${DateFormat.yMd('fr_FR').add_Hm().format(view.timestamp)}', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Text('Coordonnées : ${view.coordinates.latitude.toStringAsFixed(3)}, ${view.coordinates.longitude.toStringAsFixed(3)}', style: theme.textTheme.bodySmall),
                ]),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}