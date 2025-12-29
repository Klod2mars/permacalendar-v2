import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/sky_calibration_config.dart';
import '../../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../../features/climate/presentation/providers/weather_time_provider.dart';

// Import for provider access if separate file
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
         final daily = weather.dailyWeather.isNotEmpty ? weather.dailyWeather.first : null;
         final sunrise = parseUtc(daily?.sunrise);
         final sunset = parseUtc(daily?.sunset);
         
         // Fallback safe
         final safeSunrise = (sunrise.year == projectedTime.year) ? sunrise : DateTime(projectedTime.year, projectedTime.month, projectedTime.day, 6, 0).toUtc();
         final safeSunset = (sunset.year == projectedTime.year) ? sunset : DateTime(projectedTime.year, projectedTime.month, projectedTime.day, 20, 0).toUtc();

         final elevation = _calculateSolarElevation(projectedTime, safeSunrise, safeSunset);
         
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

  double _calculateSolarElevation(DateTime current, DateTime sunrise, DateTime sunset) {
    if (current.isAfter(sunrise) && current.isBefore(sunset)) {
      // JOUR : 0 -> 1 -> 0
      final totalMinutes = sunset.difference(sunrise).inMinutes;
      final currentMinutes = current.difference(sunrise).inMinutes;
      final progress = currentMinutes / totalMinutes; 
      return math.sin(progress * math.pi); 
    } else {
      // NUIT : 0 -> -1
      final distSunrise = current.difference(sunrise).inMinutes.abs();
      final distSunset = current.difference(sunset).inMinutes.abs();
      final minDist = math.min(distSunrise, distSunset);
      // Nuit profonde atteinte en 60min
      final elevation = -(minDist / 60.0).clamp(0.0, 1.0);
      return elevation;
    }
  }
}

class _OrganicSkyPainter extends CustomPainter {
  final double cx, cy, rx, ry, rotation;
  final double elevation; // -1.0 (Nuit) ... 0.0 (Horizon) ... 1.0 (Zénith)

  _OrganicSkyPainter({
    required this.cx, required this.cy, 
    required this.rx, required this.ry, 
    required this.rotation,
    required this.elevation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Définir la zone (Masque)
    final w = size.width;
    final h = size.height;
    final center = Offset(cx * w, cy * h);
    final radiusX = rx * w;
    final radiusY = ry * h;

    canvas.save();
    
    // Application de la transformation (Rotation autour du centre)
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    // On dessine centré en 0,0 localement
    final ovalRect = Rect.fromCenter(center: Offset.zero, width: radiusX * 2, height: radiusY * 2);
    
    // Clipping : Tout se passe DANS l'ovoïde
    // Note: clipPath est plus coûteux que clipRect/RRect, mais pour une ellipse rotated c'est nécessaire ou bien scale/clipOval.
    // Ici on a déjà transformé le canvas, donc un simple drawOval ou clipPath d'oval suffit.
    // Cependant, pour appliquer les BlendModes correctement sur tout le reste, il vaut mieux dessiner la forme avec le BlendMode.
    
    // --- LOGIQUE LUMIÈRE ORGANIQUE ---
    
    if (elevation > 0) {
       // === JOUR (ADDITIF) ===
       // On ajoute de la lumière (BlendMode.screen ou plus)
       // Intensité basée sur elevation
       final intensity = elevation.clamp(0.0, 1.0);
       
       // Couleur : Blanc chaud (Matin/Soir) -> Blanc pur (Zénith)
       // On peut garder une teinte dorée légère.
       final color = Color.lerp(
         const Color(0xFFFFD5AB), // Doré
         const Color(0xFFFFFFFF), // Blanc
         intensity
       )!.withOpacity(0.15 + 0.15 * intensity); // 15% -> 30% d'opacité max (subtil)

       final paint = Paint()
         ..shader = RadialGradient(
           colors: [color, color.withOpacity(0.0)],
           stops: const [0.2, 1.0], // Centre diffus
         ).createShader(ovalRect)
         ..blendMode = BlendMode.screen; // ÉCLAIRCIR LA MATIÈRE

       canvas.drawOval(ovalRect, paint);
       
    } else {
       // === NUIT (SOUSTRACTIF) ===
       // On assombrit la matière (BlendMode.multiply)
       final darkness = (-elevation).clamp(0.0, 1.0);
       
       if (darkness > 0.01) {
          // --- TWILIGHT PAHSE (Heure Bleue / Chien et Loup) ---
          // De 0.0 à 0.4 (approx 24min après coucher), on est dans le bleu profond.
          // Au delà, on va vers le noir.
          
          Color nightColor;
          if (darkness < 0.4) {
             // Phase Crépuscule : Transition Transparent -> Bleu Nuit
             final t = darkness / 0.4;
             nightColor = Color.lerp(
                Colors.transparent, 
                const Color(0xFF101835), // Bleu nuit profond (Twilight)
                t
             )!;
          } else {
             // Phase Nuit Noire : Transition Bleu Nuit -> Noir Abyssal
             final t = ((darkness - 0.4) / 0.6).clamp(0.0, 1.0);
             nightColor = Color.lerp(
                const Color(0xFF101835), // Start from Twilight
                const Color(0xFF000208), // Noir quasi absolu
                t
             )!;
          }

          final paint = Paint()
             ..color = nightColor
             ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20) // Bords flous (Feather)
             ..blendMode = BlendMode.multiply; // ASSOMBRIR LA MATIÈRE

          // On dessine l'ovale un tout petit peu plus grand pour le feather ? 
          // Le feather est sur le masque, ou sur la forme peinte.
          // Ici on peint une forme floue.
          canvas.drawOval(ovalRect, paint);
          
          // === ÉTOILES (NOISE VIVANT) ===
          // Seulement si nuit bien installée (après le crépuscule civil)
          if (darkness > 0.4) {
             // Opacité progressive des étoiles
             final starOpacity = ((darkness - 0.4) / 0.3).clamp(0.0, 1.0);
             if (starOpacity > 0) {
                 _drawLiveStars(canvas, ovalRect, starOpacity);
             }
          }
       }
    }
    
    canvas.restore();
  }
  
  void _drawLiveStars(Canvas canvas, Rect rect, double opacity) {
      // Génération déterministe pseudo-aléatoire pour que les étoiles soient fixes
      // mais on veut qu'elles scintillent.
      // On utilise le temps actuel pour l'animation (pas passé en paramètre ici pour simplifier, 
      // mais idéalement il faudrait un ticker. Pour l'instant static noise ou based on elevation jitter?)
      
      // Hack: utiliser elevation comme seed de scintillement partiel ? 
      // Non, ça ferait bouger les étoiles quand on drag.
      // On veut des étoiles fixes en position.
      
      final rng = math.Random(42); // Seed fixe pour positions
      final starPaint = Paint()..blendMode = BlendMode.srcOver; // Dessin normal par dessus l'ombre
      
      final count = 25;
      for(int i=0; i<count; i++) {
        // Position relative dans le rect (-w/2 .. w/2)
        final x = (rng.nextDouble() - 0.5) * rect.width;
        final y = (rng.nextDouble() - 0.5) * rect.height;
        
        // Vérif si dans l'ellipse (x/rx)^2 + (y/ry)^2 <= 1
        if ((x*x)/((rect.width/2)*(rect.width/2)) + (y*y)/((rect.height/2)*(rect.height/2)) > 0.9) continue;
        
        // Taille
        final size = rng.nextDouble() * 1.2 + 0.5;
        
        // Opacité
        // On veut qu'elles apparaissent progressivement avec darkness
        // Et un peu de variation aléatoire.
        // starOpacity est passé en paramètre (0..1)
        final starAlpha = (rng.nextDouble() * 0.5 + 0.5) * opacity;
        
        starPaint.color = Colors.white.withOpacity(starAlpha.clamp(0.0, 0.8));
        canvas.drawCircle(Offset(x, y), size, starPaint);
      }
  }

  @override
  bool shouldRepaint(covariant _OrganicSkyPainter old) {
    return old.elevation != elevation || 
           old.cx != cx || old.cy != cy || 
           old.rx != rx || old.ry != ry || 
           old.rotation != rotation;
  }
}
