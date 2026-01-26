import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/hourly_weather_point.dart';
import '../../../core/models/sky_calibration_config.dart';
import '../../../features/climate/domain/models/weather_view_data.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../features/climate/domain/utils/weather_interpolation.dart';
import '../../../features/climate/presentation/providers/weather_time_provider.dart';
// Config & Calibration imports
import '../../../features/climate/presentation/providers/weather_config_provider.dart';
import '../../../features/climate/domain/models/weather_config.dart';

/// Layer Global pour la simulation de particules (Pluie, Neige, Nuages, Brume).
/// Respecte la calibration du ciel et inclut physique de collision avec l'ovoïde.
class WeatherBioLayer extends ConsumerStatefulWidget {
  const WeatherBioLayer({super.key});

  @override
  ConsumerState<WeatherBioLayer> createState() => _WeatherBioLayerState();
}

class _WeatherBioLayerState extends ConsumerState<WeatherBioLayer>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  final List<_BioParticle> _particles = [];
  final math.Random _rng = math.Random();
  double _time = 0.0;

  // Weather Params Interpolated
  double _windSpeed = 0.0;
  double _precipIntensity = 0.0; // mm
  // double _precipProb = 0.0; // Utilisation directe de l'intensité
  // double _temperature = 0.0;
  double _cloudCover = 0.0; // 0..100
  double _visibility = 10000.0; // m

  // DEBUG / TEMP FLAGS - désactivé par défaut pour éviter spam terminal
  // Mettre true temporairement lors d'un diagnostic local seulement.
  static const bool kWeatherDebug = false;

  // Constants removed in favor of WeatherConfig


  // NOTE: variable additionnelle pour stocker la probabilité de précipitation
  double _precipProbability = 0.0; // 0..100

  bool _isSnow = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;

    // Time delta
    final dt = (elapsed.inMicroseconds - _time * 1000000).clamp(0, 50000) /
        1000000.0; // clamp 50ms
    _time = elapsed.inMicroseconds / 1000000.0;

    final calib = ref.read(skyCalibrationProvider);
    final config = ref.read(weatherConfigProvider);
    final calibState = ref.read(weatherCalibrationStateProvider);

    if (dt > 0.0) {
      _updateWeatherState(dt, calibState);
      _processEngine(dt, calib, config);
    }

    setState(() {});
  }

  void _updateWeatherState(double dt, WeatherCalibrationState calibState) {
    // 1. If Calibration Mode is ON, force values
    if (calibState.isCalibrationMode) {
      if (calibState.forcedPrecipMm != null) {
        _precipIntensity = calibState.forcedPrecipMm!;
        _precipProbability = 100.0; 
      }
      if (calibState.forcedWindSpeed != null) {
        _windSpeed = calibState.forcedWindSpeed!;
      }
      if (calibState.forcedCloudCover != null) {
        _cloudCover = calibState.forcedCloudCover!;
      }
      
      if (calibState.forcedWeatherCode != null) {
        final code = calibState.forcedWeatherCode!;
        _isSnow = (code >= 70 && code <= 79) || (code >= 85 && code <= 86);
      }
    } else {
      // 2. Read Real Weather (Fallback base)
      final weatherAsync = ref.read(currentWeatherProvider);
      final timeOffset = ref.read(weatherTimeOffsetProvider);

      weatherAsync.whenData((data) {
        final projectedTime = DateTime.now()
            .toUtc()
            .add(Duration(minutes: (timeOffset * 60).round()));
        final interpolated = WeatherInterpolation.getInterpolatedWeather(
            data.result.hourlyWeather, projectedTime);

        if (interpolated != null) {
          _updateParamsFromPoint(interpolated);
        }
      });
    }
  }

  void _updateParamsFromPoint(HourlyWeatherPoint p) {
    _windSpeed = p.windSpeedkmh;
    _precipIntensity = p.precipitationMm;
    _cloudCover = p.cloudCover.toDouble();
    _visibility = p.visibility;
    _precipProbability = p.precipitationProbability.toDouble();
    final code = p.weatherCode;
    _isSnow = (code >= 70 && code <= 79) || (code >= 85 && code <= 86);
  }

  // ===========================================================================
  // V2 ENGINE: COMPOSER (Aesthetics -> Physics)
  // ===========================================================================

  void _processEngine(double dt, SkyCalibrationConfig calib, WeatherConfig config) {
    // -------------------------------------------------------------------------
    // 1. RESOLVE PHYSICS FROM AESTHETICS (The "Mapping" Layer)
    // -------------------------------------------------------------------------
    
    // Derived Physics Values (Rain/Snow agnostic holders)
    double dGravity = 0.5;
    double dSpawnRate = 0.0;
    double dVelocityBase = 0.2;
    double dVelocityVar = 0.1;
    double dSizeBase = 1.0;
    double dSizeVar = 1.0;
    double dHSpread = 1.5;
    double dWindX = 0.0;
    
    if (_isSnow) {
      final a = config.aesthetics;
      
      // NON-LINEAR DENSITY: 10% -> 100 particles, 100% -> 3000 particles
      // Curve: Power 2.5
      dSpawnRate = 10.0 + (math.pow(a.snowDensity, 2.5) * 3000.0);
      
      // HEAVINESS affects Gravity & Size
      // Heaviness 0.0 -> Float fast/small, 1.0 -> Fall heavy/large
      dGravity = 0.01 + (a.snowHeaviness * 0.15); // 0.01 to 0.16
      dSizeBase = 1.5 + (a.snowHeaviness * 3.0);  // 1.5 to 4.5
      dSizeVar = dSizeBase * 0.5;
      
      // DENSITY affects Spread (More density needs more space visually)
      dHSpread = 2.0 + (a.snowDensity * 10.0); // 2.0 to 12.0
      
      // FALL SPEED (Velocity)
      // Snow falls slowly generally
      dVelocityBase = 0.05 + (a.snowHeaviness * 0.2); 
      dVelocityVar = dVelocityBase * 0.5;
      
      // WIND / CHAOS
      // WindSpeed from real weather or override
      dWindX = (_windSpeed * 0.002) + (math.sin(_time * 2.0) * 0.005);

    } else {
      // RAIN
      final a = config.aesthetics;
      
      // Intensity drives SpawnRate heavily too
      // Rain needs MUCH MORE particles to be visible at high intensity (motion blur effect)
      dSpawnRate = 20.0 + (math.pow(a.rainDensity, 2.0) * 1000.0);
      
      // Intensity drives Velocity (Speed)
      dVelocityBase = 0.2 + (a.rainIntensity * 0.8); // 0.2 to 1.0 (Fast!)
      dVelocityVar = 0.1;
      
      dGravity = 0.5; // Constant for rain usually, velocity dominates
      
      dSizeBase = 0.8 + (a.rainIntensity * 1.5); // Thicker streaks
      dHSpread = 1.5 + (a.rainDensity * 5.0); // Spread with density
      
      // Slant (Wind/Chaos)
      dWindX = (_windSpeed * 0.005) + ((a.rainSlant - 0.2) * 0.1);
    }
    
    // Override SpawnRate with Precip Intensity if in "Real" mode and not heavy forcing?
    // User wants "Sculpting" mode -> He uses the sliders in calibration.
    // In Real Mode (Calibration OFF), we need to map Real _precipIntensity to Aesthetics.
    // TODO: That's a later step. For now, we assume Config IS the current state.
    // BUT: The original code scaled spawn based on _precipIntensity.
    // We should scale the "Master Density" by the real precip intensity if NOT in calibration mode.
    // However, the prompt implies replacing the system. Let's stick to using config values, 
    // assuming the Provider updates the config based on weather? 
    // NO, the Config is "Tuneables". The Weather Provider gives "Data".
    // WE MUST MODULATE THE CONFIG VALUES BY THE WEATHER DATA.
    
    final calibState = ref.read(weatherCalibrationStateProvider);
    if (!calibState.isCalibrationMode) {
      // AUTO-TUNING: Map real weather to aesthetic 0..1 values locally
      // This allows the Engine to run autonomously using the "Presets" defined in config as baselines?
      // Or simply scale the results.
      
      double intensityFactor = (_precipIntensity / 5.0).clamp(0.0, 1.0); // 5mm is heavy
      
      // Modulate spawn rate
      dSpawnRate *= intensityFactor;
      if (_precipProbability > 0 && dSpawnRate < 10) dSpawnRate = 10; // Min drizzle
      if (_precipIntensity <= 0 && _precipProbability < 20) dSpawnRate = 0;
            
      // Modulate wind
      dWindX = _windSpeed * 0.005;
    }

    // -------------------------------------------------------------------------
    // 2. SPAWN
    // -------------------------------------------------------------------------
    final toSpawn = (dSpawnRate * dt).toInt();
    final spawnCount = math.min(toSpawn, 100); // Cap per tick
    
    if (spawnCount > 0) {
       final minX = calib.cx - calib.rx * dHSpread;
       final maxX = calib.cx + calib.rx * dHSpread;
       final startY = calib.cy - calib.ry; // Top of oval roughly
       
       for (int i = 0; i < spawnCount; i++) {
         // Randomize Start X
         final sx = minX + _rng.nextDouble() * (maxX - minX);
         // Randomize Start Y slightly above
         final sy = startY - (_rng.nextDouble() * 0.5); // Start a bit higher
         
         if (_isSnow) {
           final life = 5.0 + _rng.nextDouble() * 5.0;
           _particles.add(_BioParticle(
             x: sx, y: sy,
             type: _ParticleType.snow,
             vx: dWindX + (_rng.nextDouble() - 0.5) * 0.02, // Jitter
             vy: dVelocityBase + (_rng.nextDouble() * dVelocityVar),
             life: life, maxLife: life,
             size: dSizeBase + (_rng.nextDouble() * dSizeVar),
           ));
         } else {
           _particles.add(_BioParticle(
             x: sx, y: sy,
             type: _ParticleType.rain,
             vx: dWindX + (_rng.nextDouble() - 0.5) * 0.01,
             vy: dVelocityBase + (_rng.nextDouble() * dVelocityVar),
             life: 1.0, maxLife: 1.0,
             size: dSizeBase + (_rng.nextDouble() * 0.5),
           ));
         }
       }
    }
    
    // -------------------------------------------------------------------------
    // 3. CLOUDS (Simplified for now)
    // -------------------------------------------------------------------------
    // Keeping original cloud logic or mapping it later. 
    // Focusing on Rain/Snow as requested.
    if (_cloudCover > 20) {
       if (_particles.where((p) => p.type == _ParticleType.cloud).length < config.cloud.maxClouds) {
         if (_rng.nextDouble() < 0.01) {
            _particles.add(_BioParticle(
              x: calib.cx + (_rng.nextDouble()-0.5)*calib.rx*2,
              y: calib.cy - calib.ry + (_rng.nextDouble()*0.2),
              type: _ParticleType.cloud,
              vx: 0.002, vy:0, life:1, size: 50
            ));
         }
       }
    }

    // -------------------------------------------------------------------------
    // 4. UPDATE PHYSICS
    // -------------------------------------------------------------------------
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= dt;
      
      if (p.type == _ParticleType.rain || p.type == _ParticleType.snow) {
         p.vy += dGravity * dt; 
         p.x += p.vx * dt;
         p.y += p.vy * dt;
         
         // Collision
         if (config.general.enableCollision) {
            _handleCollision(p, calib);
         }
      } else if (p.type == _ParticleType.cloud) {
        p.x += p.vx * dt;
      }
      
      if (p.life <= 0) _particles.removeAt(i);
    }
  }

  void _handleCollision(_BioParticle p, SkyCalibrationConfig calib) {
      final dx = p.x - calib.cx;
      final dy = p.y - calib.cy;
      final angle = -calib.rotation;
      final localX = dx * math.cos(angle) - dy * math.sin(angle);
      final localY = dx * math.sin(angle) + dy * math.cos(angle);
      
      final rx = calib.rx;
      final ry = calib.ry;
      final eq = (localX * localX) / (rx * rx) + (localY * localY) / (ry * ry);
      
      if (eq >= 1.0) {
         // Simple deflection
         p.vx *= 0.5; // Dampen
         p.life -= 0.2; // Kill fast on impact
         if (eq > 1.1) p.life = -1;
      }
  }

  @override
  Widget build(BuildContext context) {
    final calib = ref.watch(skyCalibrationProvider);

    return IgnorePointer(
      child: RepaintBoundary(
        child: ClipPath(
          clipper: _OrganicSkyClipper(calib),
          child: CustomPaint(
            painter: _BioParticlePainter(_particles, _isSnow),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

enum _ParticleType { rain, snow, cloud, mist }

class _BioParticle {
  double x, y, vx, vy, life, maxLife, size;
  _ParticleType type;
  _BioParticle(
      {required this.x,
      required this.y,
      required this.type,
      this.vx = 0,
      this.vy = 0,
      this.life = 1,
      this.maxLife = 1,
      this.size = 1});
}

class _BioParticlePainter extends CustomPainter {
  final List<_BioParticle> particles;
  final bool isSnow;
  _BioParticlePainter(this.particles, this.isSnow);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintRain = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final paintSnow = Paint()
      ..color = Colors.white.withOpacity(0.92)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0); // doux pour flocons
    final paintCloud = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    final paintMist = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    for (final p in particles) {
      final px = p.x * w;
      final py = p.y * h;
      // Fade in/out
      double alpha = 1.0;
      if (p.life < 0.5) alpha = p.life / 0.5;
      if (p.maxLife - p.life < 0.5) alpha = (p.maxLife - p.life) / 0.5;
      alpha = alpha.clamp(0.0, 1.0);

      if (p.type == _ParticleType.rain) {
        paintRain.color = paintRain.color.withOpacity(alpha * 0.6);
        // Stretch rain by velocity
        canvas.drawLine(
            Offset(px, py), Offset(px - p.vx * 15, py - p.vy * 15), paintRain);
      } else if (p.type == _ParticleType.snow) {
        paintSnow.color =
            Colors.white.withOpacity((alpha * 0.9).clamp(0.0, 1.0));
        final radius = p.size;
        canvas.drawCircle(Offset(px, py), radius, paintSnow);
      } else if (p.type == _ParticleType.cloud) {
        paintCloud.color = paintCloud.color.withOpacity(alpha * 0.3);
        canvas.drawCircle(Offset(px, py), p.size, paintCloud);
      } else if (p.type == _ParticleType.mist) {
        paintMist.color = paintMist.color.withOpacity(alpha * 0.2);
        canvas.drawCircle(Offset(px, py), p.size, paintMist);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BioParticlePainter old) => true;
}

class _OrganicSkyClipper extends CustomClipper<Path> {
  final SkyCalibrationConfig config;
  _OrganicSkyClipper(this.config);

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(config.cx * w, config.cy * h);
    final matrix = Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..rotateZ(config.rotation);

    final path = Path()
      ..addOval(Rect.fromCenter(
          center: Offset.zero,
          width: config.rx * w * 2,
          height: config.ry * h * 2));
    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(covariant _OrganicSkyClipper old) => old.config != config;
}

// _SnowPreset removed as it is superseded by WeatherConfig

