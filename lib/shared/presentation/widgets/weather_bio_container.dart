import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/hourly_weather_point.dart';
import '../../../features/climate/domain/models/weather_view_data.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';

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
    with TickerProviderStateMixin {
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
  
  // -- Interaction State (Time Travel) --
  late AnimationController _recoilController;
  double _dragOffsetPixels = 0.0;
  
  // Sensibilité : ~12px pour 1 heure
  // User request: "12h sur 3-4cm". 4cm ~ 150px. 150/12 ~ 12.5.
  // On fixe à 12.0 pour garantir l'atteinte des 12h facilement.
  static const double _pixelsPerHour = 12.0;
  
  @override
  void initState() {
    super.initState();
    if (widget.showEffects) {
      _ticker = createTicker(_onTick)..start();
    }
    _recoilController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _recoilController.addListener(() {
      setState(() {
         // L'animation va de 0 à 1, mais nous on veut animer _dragOffsetPixels
         // On gère ça dans le listener de l'animation Tween créé au dragEnd
      });
    });
  }

  @override
  void dispose() {
    if (widget.showEffects) {
      _ticker.dispose();
    }
    _recoilController.dispose();
    super.dispose();
  }

  // --- Input Handling ---

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_recoilController.isAnimating) {
      _recoilController.stop();
    }
    setState(() {
      _dragOffsetPixels += details.primaryDelta ?? 0.0;
      // On ne permet pas d'aller dans le passé (offset < 0)
      if (_dragOffsetPixels < 0) _dragOffsetPixels = 0;
      // Max 12h de prévision (1200px) pour rester raisonnable
      if (_dragOffsetPixels > 12 * _pixelsPerHour) _dragOffsetPixels = 12 * _pixelsPerHour;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Animation de retour à la réalité (Spring effect)
    final start = _dragOffsetPixels;
    
    _recoilController.reset();
    
    final animation = Tween<double>(begin: start, end: 0.0).animate(
      CurvedAnimation(parent: _recoilController, curve: Curves.elasticOut)
    );
    
    animation.addListener(() {
      setState(() {
        _dragOffsetPixels = animation.value;
      });
    });
    
    _recoilController.forward();
  }

  // --- Simulation Logic ---

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    
    // Delta time en secondes (approx 60fps)
    const dt = 1.0 / 60.0;
    _time += dt;

    // Mise à jour des données météo depuis le provider
    final weatherAsync = ref.read(currentWeatherProvider);
    weatherAsync.whenData((data) {
       // Calcul du décalage temporel en heures
       final offsetHours = _dragOffsetPixels / _pixelsPerHour;
       
       // Récupérer la météo projetée (Maintenant + Offset)
       final projected = _getProjectedWeather(data, offsetHours);
       
       if (projected != null) {
          _updateWeatherParamsFromPoint(projected);
       } else {
          // Fallback sur data current si pas de projection
          _updateWeatherParamsResults(data.result);
       }
    });

    _updatePhysics(dt);
  }
  
  HourlyWeatherPoint? _getProjectedWeather(WeatherViewData data, double offsetHours) {
      if (data.result.hourlyWeather.isEmpty) return null;
      
      // Si offset procha de 0, on prend le current
      if (offsetHours < 0.1) return null; // Use regular current logic fallback usually best
      
      final now = DateTime.now();
      final targetTime = now.add(Duration(minutes: (offsetHours * 60).round()));
      
      HourlyWeatherPoint? closest;
      Duration minDiff = const Duration(days: 999);
  
      for (final p in data.result.hourlyWeather) {
        final diff = p.time.difference(targetTime).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closest = p;
        }
      }
      return closest;
  }

  void _updateWeatherParamsResults(dynamic result) { // Helper pour direct result objects
      // Use existing logic for current weather
      if (result == null) return;
      
      _windSpeed = result.currentWindSpeed ?? 0.0;
      
      // Check hourly for precip intensity if available (logic from original code)
      // We assume result is OpenMeteoResult
      final hourly = result.hourlyWeather as List<HourlyWeatherPoint>? ?? [];
      
      if (hourly.isNotEmpty) {
          final now = DateTime.now();
          try {
             final currentPoint = hourly.firstWhere(
                (p) => p.time.isAfter(now.subtract(const Duration(minutes: 30))),
                orElse: () => hourly.last,
             );
             _precipIntensity = currentPoint.precipitationMm;
          } catch (_) {
             _precipIntensity = 0.0;
          }
      } else {
          _precipIntensity = 0.0;
      }

      final code = result.currentWeatherCode ?? 0;
      _deriveBooleans(code);
  }

  void _updateWeatherParamsFromPoint(HourlyWeatherPoint p) {
      _windSpeed = p.windSpeedkmh;
      _precipIntensity = p.precipitationMm;
      _deriveBooleans(p.weatherCode);
  }
  
  void _deriveBooleans(int code) {
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
    if (_precipIntensity > 0.05 && !_isSunny) {
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
    // Gravité et Vent
    final gravity = _isSnow ? 30.0 : 350.0; 
    final windForce = _windSpeed * 2.0; 
    
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= dt; 
      
      if (p.type == _ParticleType.cloud) {
          // --- ÉTAT A : NUAGEUX (Zen / Flottaison) ---
          p.vx *= 0.95; 
          p.vy *= 0.95;
          p.vx += (windForce * 0.005 * gentleDt) + (_rng.nextDouble() - 0.5) * 1.5 * gentleDt;
          p.vy += (_rng.nextDouble() - 0.5) * 1.0 * gentleDt; 
          
          if (p.x < 0.05) p.vx += 2.0 * gentleDt;
          if (p.x > 0.95) p.vx -= 2.0 * gentleDt;
          if (p.y < 0.0) p.vy += 2.0 * gentleDt;
          if (p.y > 0.25) p.vy -= 2.0 * gentleDt;
          
          p.x += p.vx * gentleDt;
          p.y += p.vy * gentleDt;

      } else if (p.type == _ParticleType.glow) {
          // --- ÉTAT C : SOLEIL (Rayonnement) ---
          p.x += p.vx * gentleDt;
          p.y += p.vy * gentleDt;
          p.vx *= 0.98;
          p.vy *= 0.98;
          
      } else {
        // --- ÉTAT B : PLUIE / NEIGE (Chute) ---
        p.vy += gravity * gentleDt;
        p.vx += (windForce * 0.1 * gentleDt) + (_rng.nextDouble() - 0.5) * 5.0 * gentleDt;
        
        p.x += p.vx * gentleDt;
        p.y += p.vy * gentleDt;
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
            p.y = _floorY;
            p.vy = -p.vy * (_isSnow ? 0.0 : 0.15); 
            p.vx += (_rng.nextDouble() - 0.5) * 40.0 * gentleDt;
            p.life -= gentleDt * 4.0; 
            p.x += p.vx * gentleDt; 
        }
      }

      if (p.life <= 0) {
        _particles.removeAt(i);
      }
    }

    setState(() {});
  }

  void _spawnCloud() {
      _particles.add(_BioParticle(
      x: 0.3 + _rng.nextDouble() * 0.4, 
      y: 0.1 + _rng.nextDouble() * 0.15,
      vx: (_rng.nextDouble() - 0.5) * 0.05, 
      vy: (_rng.nextDouble() - 0.5) * 0.05,
      life: 8.0 + _rng.nextDouble() * 5.0, 
      maxLife: 10.0, 
      size: 30.0 + _rng.nextDouble() * 20.0, 
      type: _ParticleType.cloud,
    ));
  }
  
  void _spawnSunGlow() {
     final angle = _rng.nextDouble() * 2 * pi;
     final speed = 0.5 + _rng.nextDouble() * 1.5; 
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
      vy: _isSnow ? 10.0 : 50.0, 
      life: 2.0 + _rng.nextDouble(), 
      size: _isSnow ? (2.0 + _rng.nextDouble() * 3.0) : (1.0 + _rng.nextDouble()),
      type: _isSnow ? _ParticleType.snow : _ParticleType.rain,
      maxLife: 3.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final w = constraints.maxWidth;
        // final h = constraints.maxHeight;
        
        final hoursOffset = _dragOffsetPixels / _pixelsPerHour;
        final isTimeTraveling = hoursOffset > 0.1;
        
        return GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          behavior: HitTestBehavior.opaque, // Intercepter tout le conteneur
          child: Stack(
            clipBehavior: Clip.none, 
            children: [
              // 1. Simulation Layer
              if (widget.showEffects)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BioWeatherPainter(
                      particles: _particles,
                      windSpeed: _windSpeed,
                    ),
                  ),
                ),
              
              // 2. Time Travel Indicator Layer
              if (isTimeTraveling)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history_toggle_off, 
                        color: Colors.white, 
                        size: 28,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 2))
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+ ${hoursOffset.toStringAsFixed(1)} h',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 2)),
                            Shadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 4)), // Double shadow for legibility
                          ]
                        ),
                      ),
                    ],
                  ),
                ),

              // Note: Plus d'affichage texte de température ici.
              // La zone est maintenant purement visuelle et interactive.
            ],
          ),
        );
      },
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
  double maxLife; 
  double size; 
  _ParticleType type;

  _BioParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    this.maxLife = 1.0, 
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
      ..color = const Color(0xFF80D8FF).withOpacity(0.6) 
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintSnow = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.fill;
        
    final paintCloud = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0); 

    final paintGlow = Paint()
        ..color = const Color(0xFFFFE57F).withOpacity(0.4) 
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);

    for (final p in particles) {
        final px = p.x * size.width;
        final py = p.y * size.height;
        
        double opacity = (p.life).clamp(0.0, 1.0);
        if (p.type == _ParticleType.cloud || p.type == _ParticleType.glow) {
             double progress = 1.0 - (p.life / p.maxLife); 
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
            canvas.drawLine(Offset(px, py), Offset(px - (p.vx * 0.05), py - (p.vy * 0.05).clamp(2.0, 10.0)), paintRain);
        } else if (p.type == _ParticleType.snow) {
            paintSnow.color = paintSnow.color.withOpacity(opacity * 0.8);
            canvas.drawCircle(Offset(px, py), p.size, paintSnow);
        } else if (p.type == _ParticleType.cloud) {
             paintCloud.color = paintCloud.color.withOpacity(0.25 * opacity); 
             canvas.drawCircle(Offset(px, py), p.size, paintCloud);
        } else if (p.type == _ParticleType.glow) {
             paintGlow.color = paintGlow.color.withOpacity(0.3 * opacity);
             canvas.drawCircle(Offset(px, py), p.size, paintGlow);
        }
    }
  }

  @override
  bool shouldRepaint(covariant _BioWeatherPainter oldDelegate) => true;
}
