import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/sky_calibration_config.dart';
import '../../../core/models/daily_weather_point.dart';
import '../../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../../features/climate/presentation/providers/weather_time_provider.dart';
import '../../../core/models/calibration_state.dart';

class WeatherSkyBackground extends ConsumerWidget {
  const WeatherSkyBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // 1. Calibration (Où peindre ?)
    final calib = ref.watch(skyCalibrationProvider);
    
    // 2. Temps & Météo (Quoi peindre ?)
    final timeOffset = ref.watch(weatherTimeOffsetProvider);
    final projectedTime = DateTime.now().toUtc().add(Duration(minutes: (timeOffset * 60).round()));
    final weatherAsync = ref.watch(currentWeatherProvider);

    return weatherAsync.when(
      data: (weather) {
         // Récupération Sunrise/Sunset (UTC)
         DateTime parseUtc(String? iso) {
            if (iso == null) return projectedTime;
            if (!iso.endsWith('Z') && !iso.contains('+')) {
              return DateTime.parse('${iso}Z').toUtc();
            }
            return DateTime.parse(iso).toUtc();
         }

         // Accès safe aux données daily
         // helper: find correct daily point
         DailyWeatherPoint? findDailyForProjectedDate(List<DailyWeatherPoint> daily, DateTime projected) {
            final pDate = DateTime.utc(projected.year, projected.month, projected.day);
            for (final d in daily) {
               // d.date is already utc thanks to OpenMeteoService fix
               final dDate = DateTime.utc(d.date.year, d.date.month, d.date.day);
               if (dDate == pDate) return d;
            }
            // Fallback: nearest
            if (daily.isEmpty) return null;
            
            DailyWeatherPoint? best;
            int minDiff = 9999;
            for (final d in daily) {
               final dDate = DateTime.utc(d.date.year, d.date.month, d.date.day);
               final diff = dDate.difference(pDate).inDays.abs();
               if (diff < minDiff) {
                 minDiff = diff;
                 best = d;
               }
            }
            return best;
         }

         // 1. Troubles Daily selection logic
         final daily = findDailyForProjectedDate(weather.dailyWeather, projectedTime);
         
         final sunrise = parseUtc(daily?.sunrise);
         final sunset = parseUtc(daily?.sunset);
         
         // --- CORRECTION FALLBACK SÉCURISÉ ---
         // Si les dates sunrise/sunset semblent invalides (ex: égales à projectedTime suite à un parse null),
         // on force des valeurs par défaut (6h et 20h UTC).
         final bool isSunriseValid = sunrise != projectedTime && sunrise.year > 2000;
         final bool isSunsetValid = sunset != projectedTime && sunset.year > 2000;

         final safeSunrise = isSunriseValid 
              ? sunrise 
              : DateTime.utc(projectedTime.year, projectedTime.month, projectedTime.day, 6, 0);
         
         final safeSunset = isSunsetValid 
              ? sunset 
              : DateTime.utc(projectedTime.year, projectedTime.month, projectedTime.day, 20, 0);
         
         // On calcule 'progress' (0.0 Sunrise -> 1.0 Sunset) pour la position du soleil
         final dayProgress = _calculateDayProgress(projectedTime, safeSunrise, safeSunset);
         // On garde 'elevation' pour l'intensité du zénith (0.0 Horizon -> 1.0 Midi)
         final elevation = _calculateSolarIntensity(dayProgress);
         
         return CustomPaint(
           painter: _OrganicSkyPainter(
             cx: calib.cx, cy: calib.cy,
             rx: calib.rx, ry: calib.ry,
             rotation: calib.rotation,
             elevation: elevation,
           ),
           size: Size.infinite,
         );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  double _calculateDayProgress(DateTime current, DateTime sunrise, DateTime sunset) {
    // < 0.0 : Avant l'aube
    // 0.0 .. 1.0 : Jour
    // > 1.0 : Après crépuscule
    
    if (current.isBefore(sunrise)) {
       // Nuit matin
       final diff = current.difference(sunrise).inMinutes;
       // On normalise sur 12h de nuit arbitraire (720min) pour avoir une pente
       return diff / 720.0; 
    } else if (current.isAfter(sunset)) {
       final diff = current.difference(sunset).inMinutes;
       return 1.0 + diff / 720.0; 
    } else {
       final total = sunset.difference(sunrise).inMinutes;
       final passed = current.difference(sunrise).inMinutes;
       if (total == 0) return 0.5;
       return passed / total; 
    }
  }

  double _calculateSolarIntensity(double progress) {
    // Sinusoide qui va dans le négatif pour la nuit
    // progress 0 (levere) -> sin(0) = 0
    // progress 0.5 (midi) -> sin(PI/2) = 1
    // progress 1 (coucher) -> sin(PI) = 0
    // progress -0.5 -> sin(-PI/2) = -1
    return math.sin(progress * math.pi);
  }
}

class _OrganicSkyPainter extends CustomPainter {
  final double cx, cy, rx, ry, rotation;
  final double elevation;

  _OrganicSkyPainter({
    required this.cx, required this.cy, 
    required this.rx, required this.ry, 
    required this.rotation,
    required this.elevation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(cx * w, cy * h);
    final radiusX = rx * w;
    final radiusY = ry * h;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final ovalRect = Rect.fromCenter(center: Offset.zero, width: radiusX * 2, height: radiusY * 2);
    
    if (elevation > -0.05) { // Zone Jour + Crépuscule proche
       // --- JOUR (Soleil organique, plus de "tache blanche") ---
       final intensity = elevation.clamp(0.0, 1.0);
       
       // Correction : Utilisation d'une lumière ambrée/dorée au lieu du blanc pur
       // On garde un léger jaune clair au zénith, mais majoritairement chaud
       final sunColor = Color.lerp(
         const Color(0xFFE6A35C), // Orange chaud (Soleil bas)
         const Color(0xFFFFF8E0), // Blanc cassé très chaud (Zénith)
         intensity
       )!;
       
       // Opacité réduite pour plus de subtilité (max 15% au lieu de 30%)
       final opacity = (0.05 + 0.10 * intensity).clamp(0.0, 0.15);

       final paint = Paint()
         ..shader = RadialGradient(
           colors: [sunColor.withOpacity(opacity), sunColor.withOpacity(0.0)],
           stops: const [0.0, 0.8], // Gradient plus doux
         ).createShader(ovalRect)
         ..blendMode = BlendMode.srcOver; // On utilise srcOver ou un mode très léger pour ne pas "brûler" le fond

       canvas.drawOval(ovalRect, paint);
       
    } else {
       // === NUIT ===
       final darkness = (-elevation).clamp(0.0, 1.0);
       
       if (darkness > 0.01) {
          // Crépuscule (0.0 à 0.4) -> Nuit (0.4+)
          Color nightColor;
          if (darkness < 0.4) {
             final t = darkness / 0.4;
             nightColor = Color.lerp(Colors.transparent, const Color(0xFF0F172A), t)!; // Bleu nuit plus riche
          } else {
             final t = ((darkness - 0.4) / 0.6).clamp(0.0, 1.0);
             nightColor = Color.lerp(const Color(0xFF0F172A), const Color(0xFF020205), t)!; // Noir profond
          }

          final paint = Paint()
             ..color = nightColor
             ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15) // Flou légèrement réduit
             ..blendMode = BlendMode.multiply;
          canvas.drawOval(ovalRect, paint);
          
          // Étoiles (inchangé, car fonctionnel)
          if (darkness > 0.4) {
             final starOpacity = ((darkness - 0.4) / 0.3).clamp(0.0, 1.0);
             if (starOpacity > 0) _drawLiveStars(canvas, ovalRect, starOpacity);
          }
       }
    }
    canvas.restore();
  }
  
  void _drawLiveStars(Canvas canvas, Rect rect, double opacity) {
      final rng = math.Random(42); 
      final starPaint = Paint()..blendMode = BlendMode.srcOver;
      final count = 25;
      for(int i=0; i<count; i++) {
        final x = (rng.nextDouble() - 0.5) * rect.width;
        final y = (rng.nextDouble() - 0.5) * rect.height;
        if ((x*x)/((rect.width/2)*(rect.width/2)) + (y*y)/((rect.height/2)*(rect.height/2)) > 0.9) continue;
        final size = rng.nextDouble() * 1.2 + 0.5;
        final starAlpha = (rng.nextDouble() * 0.5 + 0.5) * opacity;
        starPaint.color = Colors.white.withOpacity(starAlpha.clamp(0.0, 0.8));
        canvas.drawCircle(Offset(x, y), size, starPaint);
      }
  }

  @override
  bool shouldRepaint(covariant _OrganicSkyPainter old) {
    return old.elevation != elevation || old.cx != cx || old.cy != cy || old.rx != rx || old.ry != ry || old.rotation != rotation;
  }
}
