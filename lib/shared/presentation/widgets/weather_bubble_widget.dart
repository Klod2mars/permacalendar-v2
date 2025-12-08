import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';
import 'package:intl/intl.dart';

class WeatherBubbleWidget extends ConsumerWidget {
  const WeatherBubbleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return weatherAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Colors.white70,
          strokeWidth: 2,
        ),
      ),
      error: (e, _) => const Center(
        child: Text(
          'Météo indisponible',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
      data: (weather) {
        // Formater la date au format français (ex: 'dimanche 2/11/25')
        final dateFormatter = DateFormat('EEEE d/M/yy', 'fr_FR');
        final date = dateFormatter.format(DateTime.now());

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle dark rounded overlay behind text to ensure legibility
              Container(
                width: 180,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.32),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              // Content (date, icon, description, temps)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Date
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(blurRadius: 2, color: Colors.black54, offset: Offset(0, 1))
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Icône météo (même fallback)
                  Image.asset(
                    weather.icon ?? 'assets/weather_icons/sunny.png',
                    width: 64,
                    height: 64,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.wb_cloudy,
                        size: 64,
                        color: Colors.white70,
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Description — stroked outline + fill for strong legibility on bright backgrounds
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        weather.description ?? 'Données indisponibles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.black.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        weather.description ?? 'Données indisponibles',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Températures min/max (ou température courante)
                  if (weather.minTemp != null && weather.maxTemp != null)
                    Text(
                      'Min ${weather.minTemp!.toStringAsFixed(1)}° / Max ${weather.maxTemp!.toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        shadows: [
                          Shadow(blurRadius: 2, color: Colors.black45, offset: Offset(0, 1))
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  else if (weather.temperature != null || weather.currentTemperatureC != null)
                    Text(
                      '${(weather.temperature ?? weather.currentTemperatureC ?? 0.0).toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        shadows: [
                          Shadow(blurRadius: 2, color: Colors.black45, offset: Offset(0, 1))
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
