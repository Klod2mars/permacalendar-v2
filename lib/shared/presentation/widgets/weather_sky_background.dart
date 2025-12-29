import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../features/climate/presentation/providers/weather_time_provider.dart';

/// Widget de fond "Ciel Dynamique" qui évolue selon le temps projeté.
/// Affiche :
/// 1. Un dégradé atmosphérique (Bleu -> Orange -> Nuit).
/// 2. Les astres (Soleil / Lune) sur une trajectoire en arc.
/// 3. Les étoiles (si nuit).
class WeatherSkyBackground extends ConsumerWidget {
  const WeatherSkyBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offsetHours = ref.watch(weatherTimeOffsetProvider);
    final weatherAsync = ref.watch(currentWeatherProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return weatherAsync.when(
          data: (data) {
            // 1. Calcul du temps projeté (UTC pour logique, Local pour UI si besoin)
            final nowUtc = DateTime.now().toUtc();
            final nowLocal = DateTime.now(); // Pour debug
            
            // On ajoute l'offset (en heures)
            final projectedTime = nowUtc.add(Duration(
              minutes: (offsetHours * 60).round(),
            ));

            // 2. Récupérer Sunrise / Sunset du jour pertinent
            // On cherche dans le dailyWeather la date correspondante à projectedTime
            // (Car si on dépasse minuit, on change de jour solaire)
            String? sunriseIso;
            String? sunsetIso;
            
            // Fallback sur le premier jour si list vide
            if (data.dailyWeather.isNotEmpty) {
                 // Trouver le jour qui matche projectedTime
                 try {
                   final dayPoint = data.dailyWeather.firstWhere((d) {
                       return d.date.year == projectedTime.year && 
                              d.date.month == projectedTime.month && 
                              d.date.day == projectedTime.day;
                   }, orElse: () => data.dailyWeather.first);
                   
                   sunriseIso = dayPoint.sunrise;
                   sunsetIso = dayPoint.sunset;
                 } catch(_) {}
            }
            
            // Si pas de donnée solaire, on simule 06h-20h (Cas rare/Erreur)
            DateTime parseUtc(String? iso) {
              if (iso == null) return projectedTime;
              if (!iso.endsWith('Z') && !iso.contains('+')) {
                return DateTime.parse('${iso}Z').toUtc();
              }
              return DateTime.parse(iso).toUtc();
            }

            final sunrise = parseUtc(sunriseIso);
            final sunset = parseUtc(sunsetIso);
            
            // Si parsing échoue ou données fantômes, fallback hardcodé safe
            final safeSunrise = (sunrise.year == projectedTime.year) ? sunrise : DateTime(projectedTime.year, projectedTime.month, projectedTime.day, 6, 0).toUtc();
            final safeSunset = (sunset.year == projectedTime.year) ? sunset : DateTime(projectedTime.year, projectedTime.month, projectedTime.day, 20, 0).toUtc();
            
            // 3. Calcul de la "Hauteur Solaire" (0.0 = Horizon/Crépuscule, 1.0 = Zénith Midi, -1.0 = Zénith Minuit)
            // On simplifie pour l'effet visuel :
            // Jour : Sunrise -> Sunset
            // Nuit : Sunset -> Sunrise Au jour suivant
            
            final isDay = projectedTime.isAfter(safeSunrise) && projectedTime.isBefore(safeSunset);
            
            // Progression dans la phase (0.0 au début, 1.0 à la fin)
            double phaseProgress = 0.0;
            if (isDay) {
               final dayDuration = safeSunset.difference(safeSunrise).inMinutes;
               final elapsed = projectedTime.difference(safeSunrise).inMinutes;
               phaseProgress = (elapsed / dayDuration).clamp(0.0, 1.0);
            } else {
               // Nuit : on doit gérer le passage à minuit pour la continuité
               // C'est complexe, pour l'instant on fait une interpolation simple "Distance au soleil le plus proche"
               // Visual Hack: On regarde juste l'écart au sunset ou sunrise
               // Si on est APRÈS le sunset : progress part de 0
               // Si on est AVANT le sunrise : progress finit à 1
               // Simplification : Cycle sinusoïdal basé sur l'heure tout court ? 
               // NON, on veut respecter les vrais horaires.
            }

            // --- NOUVELLE LOGIQUE ORGANIQUE ---
            // On ne dessine pas d'astre. On modifie la matière.
            
            // Calcul de l'élévation (-1.0 à 1.0)
            double elevation = _calculateSolarElevation(projectedTime, safeSunrise, safeSunset);
            
            // Calcul des intensités
            double dayIntensity = 0.0;
            double nightIntensity = 0.0;
            
            if (elevation > 0) {
              // JOUR : 0.0 -> 1.0
              dayIntensity = elevation.clamp(0.0, 1.0);
            } else {
              // NUIT : 0.0 -> 1.0 (de plus en plus sombre)
              nightIntensity = (-elevation).clamp(0.0, 1.0);
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Couche NUIT (Assombrissement substratif)
                // L'ovoïde s'éteint de l'intérieur.
                if (nightIntensity > 0.01)
                  Opacity(
                    opacity: nightIntensity,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.8, // Focus au centre
                          colors: [
                            Color(0xFF05101A), // Bleu nuit profond translucide (sera modulé par opacity)
                            Color(0xFF000000), // Noir bord
                          ],
                          stops: [0.2, 1.0],
                        ),
                      ),
                    ),
                  ),
                
                // 2. Couche ETOILES (Bruit vivant)
                // Apparaissent dans le noir profond
                if (nightIntensity > 0.4) 
                  Opacity(
                    opacity: (nightIntensity - 0.4) / 0.6,
                    child: const _BioStarsLayer(),
                  ),

                // 3. Couche JOUR (Lumière additive)
                // Voile lumineux directionnel
                if (dayIntensity > 0.01)
                  Opacity(
                    opacity: dayIntensity,
                    child: _DayLightOverlay(elevation: elevation),
                  ),
              ],
            );
          },
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        );
      },
    );
  }

  /// Retourne une valeur entre -1.0 (Nuit profonde) et 1.0 (Zénith).
  double _calculateSolarElevation(DateTime current, DateTime sunrise, DateTime sunset) {
    if (current.isAfter(sunrise) && current.isBefore(sunset)) {
      // JOUR
      final totalMinutes = sunset.difference(sunrise).inMinutes;
      final currentMinutes = current.difference(sunrise).inMinutes;
      final progress = currentMinutes / totalMinutes; 
      return math.sin(progress * math.pi); 
    } else {
      // NUIT
      final distSunrise = current.difference(sunrise).inMinutes.abs();
      final distSunset = current.difference(sunset).inMinutes.abs();
      final minDist = math.min(distSunrise, distSunset);
      // Nuit profonde atteinte plus vite (60min) pour sensation immédiate
      final elevation = -(minDist / 60.0).clamp(0.0, 1.0);
      return elevation;
    }
  }
}

class _DayLightOverlay extends StatelessWidget {
  final double elevation;
  const _DayLightOverlay({required this.elevation});

  @override
  Widget build(BuildContext context) {
    // La lumière se déplace légèrement (Est -> Ouest) ou Zénith ?
    // Simplification organique : Une lueur chaude/blanche qui vient du haut.
    // Crépuscule (elevation bas) : teinte plus orange/rosée.
    // Zénith (elevation haut) : teinte blanche pure.
    
    final color = Color.lerp(
       const Color(0xFFFFD5AB), // Doré (Horizon)
       const Color(0xFFFFFFFF), // Blanc (Zénith)
       elevation,
    )!.withOpacity(0.3); // Jamais trop opaque, c'est un voile

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.0, -0.5), // Lumière vient du haut un peu
          radius: 1.2,
          colors: [
            color,
            Colors.transparent,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

class _BioStarsLayer extends StatefulWidget {
  const _BioStarsLayer();

  @override
  State<_BioStarsLayer> createState() => _BioStarsLayerState();
}

class _BioStarsLayerState extends State<_BioStarsLayer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  // Génération fixe des positions pour éviter le clignotement au rebuild
  final List<Offset> _starPositions = [];
  final List<double> _starSizes = [];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    
    final rng = math.Random(1337);
    for(int i=0; i<30; i++) {
      _starPositions.add(Offset(rng.nextDouble(), rng.nextDouble()));
      _starSizes.add(rng.nextDouble() * 2.0 + 0.5);
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
         return CustomPaint(
           painter: _StarNoisePainter(
             positions: _starPositions, 
             sizes: _starSizes, 
             time: _controller.value
           ),
           size: Size.infinite,
         );
      }
    );
  }
}

class _StarNoisePainter extends CustomPainter {
  final List<Offset> positions;
  final List<double> sizes;
  final double time;

  _StarNoisePainter({required this.positions, required this.sizes, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    
    for(int i=0; i<positions.length; i++) {
       final pos = positions[i];
       // Scintillement déphasé
       final flicker = math.sin((time * 2 * math.pi) + (i * 1.5)); 
       final opacity = ((flicker + 1.0) / 2.0) * 0.7; // 0.0 -> 0.7
       
       paint.color = Colors.white.withOpacity(opacity);
       canvas.drawCircle(Offset(pos.dx * size.width, pos.dy * size.height), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarNoisePainter old) => true; // Animates
}
