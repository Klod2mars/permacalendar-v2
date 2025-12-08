import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../features/climate/presentation/providers/weather_providers.dart';

class WeatherBubbleWidget extends ConsumerWidget {
  const WeatherBubbleWidget({super.key});

  String _capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return weatherAsync.when(
      loading: () => const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            color: Colors.white70,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (e, _) => const Center(
        child: Text(
          'Météo indisponible',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            shadows: [Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 2))],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      data: (weather) {
        // Date FR lisible (pas collée au nuage, avec chip dédiée)
        final dateFormatter = DateFormat('EEEE d/M/yy', 'fr_FR');
        final date = _capitalizeFirst(dateFormatter.format(DateTime.now()));

        final descriptionRaw = (weather.description?.trim().isNotEmpty ?? false)
            ? weather.description!.trim()
            : 'Données indisponibles';

        // Tu aimais le rendu "AVERSE LÉGÈRE" => on harmonise en capitales + tracking léger.
        final description = descriptionRaw.toUpperCase();

        final hasMinMax = weather.minTemp != null && weather.maxTemp != null;
        final tempNow = weather.temperature ?? weather.currentTemperatureC;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 220,
              minWidth: 170,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.14),
                        Colors.black.withOpacity(0.18),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.22),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DATE : chip dédiée => plus jamais illisible “au-dessus du nuage”
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withOpacity(0.14), width: 1),
                        ),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 2)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ICÔNE : posée dans un “bubble ring” => plus harmonieux
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.18),
                          border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
                        ),
                        child: Center(
                          child: Image.asset(
                            weather.icon ?? 'assets/weather_icons/sunny.png',
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.wb_cloudy, size: 40, color: Colors.white70);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // DESCRIPTION : chip “verre fumé” => plus de barre rectangulaire chelou
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.14), width: 1),
                        ),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.9,
                            height: 1.15,
                            shadows: [
                              Shadow(blurRadius: 10, color: Colors.black87, offset: Offset(0, 2)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // TEMPÉRATURES : chip bas => plus jamais illisible “en-dessous”
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
                        ),
                        child: Text(
                          hasMinMax
                              ? 'Min ${weather.minTemp!.toStringAsFixed(1)}°  •  Max ${weather.maxTemp!.toStringAsFixed(1)}°'
                              : (tempNow != null ? '${tempNow.toStringAsFixed(1)}°' : '—'),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            shadows: [
                              Shadow(blurRadius: 8, color: Colors.black54, offset: Offset(0, 2)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
