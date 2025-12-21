import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/climate/domain/models/weather_view_data.dart';
import '../../../../features/climate/presentation/providers/weather_providers.dart';

/// Un conteneur météo "Bio-Organique" avec simulation physique.
/// Remplace l'ancien widget statique.
/// - Zone Supérieure (35%) : Simulation physique (Pluie, Neige, Vent).
/// - Zone Inférieure (65%) : Zone protégée pour le texte (Température).
/// - Sol Invisible : Barrière physique élastique séparent les deux zones.
class WeatherBioContainer extends ConsumerStatefulWidget {
  const WeatherBioContainer({super.key, this.showEffects = true});

  final bool showEffects;

  @override
  ConsumerState<WeatherBioContainer> createState() => _WeatherBioContainerState();
}

class _WeatherBioContainerState extends ConsumerState<WeatherBioContainer>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  
  // -- Simulation State --
  final List<_BioParticle> _particles = [];
  final Random _rng = Random();
  double _time = 0.0;
  

  // -- Physics Constants --
  static const double _floorY = 0.35; // Position du sol invisible
  
  // -- Weather Parameters --
  double _windSpeed = 0.0; // km/h
  double _precipIntensity = 0.0; // mm/h
  bool _isSnow = false;
  bool _isCloudy = false;
  bool _isSunny = false; // Add sunny/clear state
  
  @override
  void initState() {
    super.initState();
    if (widget.showEffects) {
      _ticker = createTicker(_onTick)..start();
    }
  }

  @override
  void dispose() {
    if (widget.showEffects) {
      _ticker.dispose();
    }
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    
    // Delta time en secondes (approx 60fps)
    const dt = 1.0 / 60.0;
    _time += dt;

    // Mise à jour des données météo depuis le provider
    // Note: Dans un cas réel optimisé, on ferait ça dans un `listen` ou `didUpdateWidget`
    // mais ici on le fait à la volée pour simplicité.
    final weatherAsync = ref.read(currentWeatherProvider);
    weatherAsync.whenData((data) {
      _updateWeatherParams(data);
    });

    _updatePhysics(dt);
  }

  void _updateWeatherParams(WeatherViewData data) {
    _windSpeed = data.result.currentWindSpeed ?? 0.0;
    
    // Estimation précipitation courante depuis hourly
    if (data.result.hourlyWeather.isNotEmpty) {
      final now = DateTime.now();
      // Simple lookup du point le plus proche
      // (Optimisation possible : ne pas faire ce `firstWhere` à chaque frame)
       try {
        final currentPoint = data.result.hourlyWeather.firstWhere(
            (p) => p.time.isAfter(now.subtract(const Duration(minutes: 30))),
            orElse: () => data.result.hourlyWeather.last,
        );
         _precipIntensity = currentPoint.precipitationMm;
      } catch (_) {
        _precipIntensity = 0.0; 
      }
    } else {
        _precipIntensity = 0.0;
    }

    // Détection Type (Neige vs Pluie) basé sur weatherCode ou température
    final code = data.weatherCode ?? 0;
    // Codes WMO Neige: 71, 73, 75, 77, 85, 86
    _isSnow = (code >= 70 && code <= 79) || (code >= 85 && code <= 86);
    // Codes WMO Nuageux: 1, 2, 3 (Partly cloudy), 45, 48 (Fog), 51-67 (Drizzle/Rain implies clouds)
    _isCloudy = (code >= 1 && code <= 3) || (code >= 45); 
    
    // Codes WMO Soleil: 0 (Clear sky)
    _isSunny = (code == 0) && !_isCloudy && !_isSnow && (_precipIntensity < 0.05);
  }

  void _updatePhysics(double dt) {
    // 0. Global Zen Factor (Ralentissement du temps ressenti)
    const timeScale = 0.5; // Tout va 2x plus lentement
    final gentleDt = dt * timeScale;

    // 1. Spawning (Création de particules)
    // Seuil minimal pour afficher quelque chose (ex: 0.1mm)
    if (_precipIntensity > 0.05 && !_isSunny) {
     // ... (precip spawn logic remains similar but uses gentleDt for probability if strictly tied to time, 
     // but 'rate' is per second, so we check probability: rate * dt)
     // On garde dt réel pour le taux d'apparition pour ne pas en avoir moins, 
     // mais on ajuste la proba si on veut compenser le slow motion visuel.
     // Ici on garde la logique existante.
      final spawnRate = _isSnow 
          ? (_precipIntensity * 2.0).clamp(0.0, 5.0) 
          : (_precipIntensity * 10.0).clamp(0.0, 40.0);
      
      if (_rng.nextDouble() < spawnRate * dt * 5.0) { 
         _spawnParticle();
      }
    }

    // Spawn Nuages (Zen Mode: FADE IN)
    if (_isCloudy) {
       final currentClouds = _particles.where((p) => p.type == _ParticleType.cloud).length;
       // Moins de nuages, plus significatifs
       if (currentClouds < 4 && _rng.nextDouble() < 0.005) { 
           _spawnCloud();
       }
    }

    // Spawn Soleil (Particules Glow)
    if (_isSunny) {
        final currentGlows = _particles.where((p) => p.type == _ParticleType.glow).length;
        if (currentGlows < 8 && _rng.nextDouble() < 0.02) {
            _spawnSunGlow();
        }
    }

    // 2. Physics Update
    // Gravité (pixels/s^2) - Ajustée pour le temps ralenti
    final gravity = _isSnow ? 30.0 : 350.0; 
    // Vent drastiquement réduit pour l'effet Zen
    final windForce = _windSpeed * 2.0; 
    
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= dt; // La vie s'écoule en temps réel pour gérer les durées correctement, ou gentleDt si on veut rallonger
      
      if (p.type == _ParticleType.cloud) {
          // --- ÉTAT A : NUAGEUX (Zen / Flottaison) ---
          
          // Friction énorme (air visqueux)
          p.vx *= 0.95; 
          p.vy *= 0.95;

          // Mouvement Brownien lent + Dérive vent très faible
          p.vx += (windForce * 0.005 * gentleDt) + (_rng.nextDouble() - 0.5) * 1.5 * gentleDt;
          p.vy += (_rng.nextDouble() - 0.5) * 1.0 * gentleDt; // Flottement vertical pur (pas de gravité)
          
          // Doux clamp dans le dôme pour qu'ils ne sortent pas violemment
          // Ils "existent" là.
          if (p.x < 0.05) p.vx += 2.0 * gentleDt;
          if (p.x > 0.95) p.vx -= 2.0 * gentleDt;
          if (p.y < 0.0) p.vy += 2.0 * gentleDt;
          if (p.y > 0.25) p.vy -= 2.0 * gentleDt;
          
          // Mise à jour pos
          p.x += p.vx * gentleDt;
          p.y += p.vy * gentleDt;

      } else if (p.type == _ParticleType.glow) {
          // --- ÉTAT C : SOLEIL (Rayonnement) ---
          // Pas de gravité, mouvement radial lent depuis le spawn (+ dérive légère)
          p.x += p.vx * gentleDt;
          p.y += p.vy * gentleDt;
          
          // Slow down
          p.vx *= 0.98;
          p.vy *= 0.98;
          
      } else {
        // --- ÉTAT B : PLUIE / NEIGE (Chute) ---
        p.vy += gravity * gentleDt;
        p.vx += (windForce * 0.1 * gentleDt) + (_rng.nextDouble() - 0.5) * 5.0 * gentleDt;
        
        // Update Position
        p.x += p.vx * gentleDt;
        p.y += p.vy * gentleDt;

        // Friction air
        p.vx *= 0.99;
        
        // -- WALL COLLISION (Zone A) --
        if (p.y < _floorY) {
            if (p.x < 0.0) {
                p.x = 0.0;
                p.vx = -p.vx * 0.5;
            } else if (p.x > 1.0) {
                p.x = 1.0;
                p.vx = -p.vx * 0.5;
            }
        }

        // -- COLLISION : SOL INVISIBLE --
        if (p.y > _floorY) {
            // Impact !
            p.y = _floorY;
            
            // Rebond
            p.vy = -p.vy * (_isSnow ? 0.0 : 0.15); 
            p.vx += (_rng.nextDouble() - 0.5) * 40.0 * gentleDt;
            
            // Disparition : Elles meurent sur la ligne.
            // On accélère grandement la fin de vie pour qu'elles ne s'accumulent pas trop longtemps
            p.life -= gentleDt * 4.0; 
            
            // Spill léger autorisé au sol, mais la vie baisse vite
            p.x += p.vx * gentleDt; 
        }
      }

      if (p.life <= 0) {
        _particles.removeAt(i);
      }
    }

    // Trigger repaint
    setState(() {});
  }

  void _spawnCloud() {
      // Naissance aléatoire DANS le dôme (pas au bord)
      // Fade in géré par le painter via l'opacité (1.0 au milieu de vie, 0 au début/fin)
      _particles.add(_BioParticle(
      x: 0.3 + _rng.nextDouble() * 0.4, // Centre 0.3-0.7
      y: 0.1 + _rng.nextDouble() * 0.15,
      vx: (_rng.nextDouble() - 0.5) * 0.05, // Vitesse minuscule
      vy: (_rng.nextDouble() - 0.5) * 0.05,
      life: 8.0 + _rng.nextDouble() * 5.0, // Vie longue (8-13s)
      maxLife: 10.0, // used for fade in/out
      size: 30.0 + _rng.nextDouble() * 20.0, // Très gros soft bodies
      type: _ParticleType.cloud,
    ));
  }
  
  void _spawnSunGlow() {
     // Émission radiale depuis le "centre" du ciel (~0.5, 0.15)
     final angle = _rng.nextDouble() * 2 * pi;
     final speed = 0.5 + _rng.nextDouble() * 1.5; // Lent
     _particles.add(_BioParticle(
       x: 0.5, 
       y: 0.15,
       vx: cos(angle) * speed,
       vy: sin(angle) * speed,
       life: 4.0 + _rng.nextDouble() * 2.0,
       maxLife: 6.0,
       size: 5.0 + _rng.nextDouble() * 10.0,
       type: _ParticleType.glow,
     ));
  }


  void _spawnParticle() {
    _particles.add(_BioParticle(
      x: 0.1 + _rng.nextDouble() * 0.8,
      y: -0.05,
      vx: 0.0,
      vy: _isSnow ? 10.0 : 50.0, // Vitesse initiale vers le bas
      life: 2.0 + _rng.nextDouble(), // Durée de vie max
      size: _isSnow ? (2.0 + _rng.nextDouble() * 3.0) : (1.0 + _rng.nextDouble()),
      type: _isSnow ? _ParticleType.snow : _ParticleType.rain,
      maxLife: 3.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // On utilise LayoutBuilder pour scaler la simulation à la taille réelle
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        
        // Récupération des données pour l'affichage texte en bas
        final weatherAsync = ref.watch(currentWeatherProvider);
        
        return Stack(
          clipBehavior: Clip.none, // Allow "Spill" visual overflow
          children: [
            // 1. Simulation Layer (Zone A Mainly)
            if (widget.showEffects)
              Positioned.fill(
                child: CustomPaint(
                  painter: _BioWeatherPainter(
                    particles: _particles,
                    windSpeed: _windSpeed,
                  ),
                ),
              ),
            
            // 2. Clear Zone (Zone B - Text)
            // ANCRAGE BAS DANS LA ZONE PROTEGÉE (Top 35% -> Bottom 100%)
            Positioned(
              top: h * 0.35, // Commence exactement sous le sol invisible
              left: 20,
              right: 20,
              bottom: 10, // Marge du bas
              child: Container(
                // color: Colors.blue.withOpacity(0.1), // Debug Hitbox
                alignment: Alignment.bottomCenter, // Ancrage bas demandé
                child: weatherAsync.when(
                  data: (data) => _buildWeatherInfo(data),
                  loading: () => const SizedBox(),
                  error: (_,__) => const Text('--', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeatherInfo(WeatherViewData data) {
      final temp = data.currentTemperatureC?.toStringAsFixed(0) ?? '--';
      
      // Utilisation d'un FittedBox pour garantir zéro overflow
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
              // Température (Taille réduite 32 comme demandé)
              Text(
                  '$temp°',
                  style: const TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.w300, 
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      height: 1.0, // Tight height
                      shadows: [
                          BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 4))
                      ]
                  ),
              ),
              const SizedBox(height: 4),
              if (data.description != null)
                   Text(
                      data.description!.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.2,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                  ),
          ],
        ),
      );
  }
}

enum _ParticleType { rain, snow, cloud, glow }

class _BioParticle {
  double x; 
  double y; 
  double vx; 
  double vy; 
  double life; 
  double maxLife; // Pour le calcul d'opacité (Fade in/out)
  double size; 
  _ParticleType type;

  _BioParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    this.maxLife = 1.0, // Default to 1.0 if not needed
    required this.size,
    required this.type,
  });
}

class _BioWeatherPainter extends CustomPainter {
  final List<_BioParticle> particles;
  final double windSpeed;

  _BioWeatherPainter({required this.particles, required this.windSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    
    final paintRain = Paint()
      ..color = const Color(0xFF80D8FF).withOpacity(0.6) // Cyan clair
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintSnow = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.fill;
        
    final paintCloud = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0); // Soft body effect

    final paintGlow = Paint()
        ..color = const Color(0xFFFFE57F).withOpacity(0.4) // Jaune pâle
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);

    for (final p in particles) {
        // Mapping espace 0..1 -> pixels
        final px = p.x * size.width;
        final py = p.y * size.height;
        
        // Calcul opacité avec Fade-In et Fade-Out pour Clouds et Glow
        double opacity = (p.life).clamp(0.0, 1.0);
        if (p.type == _ParticleType.cloud || p.type == _ParticleType.glow) {
             // Fade in sur le premier tiers, Fade out sur le dernier
             double progress = 1.0 - (p.life / p.maxLife); // 0.0 (début) -> 1.0 (fin)
             if (progress < 0.2) {
                 opacity = progress / 0.2;
             } else if (progress > 0.8) {
                 opacity = (1.0 - progress) / 0.2;
             } else {
                 opacity = 1.0;
             }
        }
        opacity = opacity.clamp(0.0, 1.0);
        
        if (p.type == _ParticleType.rain) {
            paintRain.color = paintRain.color.withOpacity(opacity * 0.6);
            
            // La goutte est allongée selon sa vitesse
            canvas.drawLine(Offset(px, py), Offset(px - (p.vx * 0.05), py - (p.vy * 0.05).clamp(2.0, 10.0)), paintRain);
        } else if (p.type == _ParticleType.snow) {
            // Snow
            paintSnow.color = paintSnow.color.withOpacity(opacity * 0.8);
            canvas.drawCircle(Offset(px, py), p.size, paintSnow);
        } else if (p.type == _ParticleType.cloud) {
             // Cloud Soft Body
             paintCloud.color = paintCloud.color.withOpacity(0.25 * opacity); 
             canvas.drawCircle(Offset(px, py), p.size, paintCloud);
        } else if (p.type == _ParticleType.glow) {
             // Sun Glow
             paintGlow.color = paintGlow.color.withOpacity(0.3 * opacity);
             canvas.drawCircle(Offset(px, py), p.size, paintGlow);
        }
    }
  }

  @override
  bool shouldRepaint(covariant _BioWeatherPainter oldDelegate) => true;
}
