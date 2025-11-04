import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_providers.dart';

class WeatherWidget extends ConsumerWidget {
  final double lat;
  final double lon;
  const WeatherWidget({super.key, required this.lat, required this.lon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(weatherRepositoryProvider).getCurrent(lat, lon),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 60, child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return const SizedBox(
              height: 60, child: Center(child: Text('Météo indisponible')));
        }
        final data = snapshot.data as Map<String, dynamic>;
        final current = data['current_weather'] as Map<String, dynamic>?;
        if (current == null) {
          return const SizedBox(
              height: 60, child: Center(child: Text('Météo indisponible')));
        }
        final temp = current['temperature'];
        final wind = current['windspeed'];
        return SizedBox(
          height: 60,
          child: Row(
            children: [
              const Icon(Icons.wb_sunny_outlined),
              const SizedBox(width: 8),
              Text(
                  'Temp: ${temp?.toString()}°C  ·  Vent: ${wind?.toString()} km/h'),
            ],
          ),
        );
      },
    );
  }
}
