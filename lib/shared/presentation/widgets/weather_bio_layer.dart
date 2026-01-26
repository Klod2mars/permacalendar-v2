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
    // 1. RESOLVE PHYSICS FROM AESTHETICS (The "Mapping" Layer V3 + V4 Depth)
    // -------------------------------------------------------------------------
    
    // Derived Physics Values
    double dGravity = 0.5;
    double dSpawnRate = 0.0;
    double dVelocityBase = 0.2;
    double dVelocityVar = 0.1;
    double dSizeBase = 1.0;
    double dSizeVar = 1.0;
    double dHSpread = 1.5;
    double dWindX = 0.0;
    
    // Pick the right sculpted material
    final aesthetic = _isSnow ? config.aesthetics.snow : config.aesthetics.rain;
    
    // --- V3 MAPPING: 5 HOLISTIC PILLARS ---
    
    // 1. QUANTITY (How much?)
    // Controlled by 'quantity' (0-1). 
    // Uses power curve to give fine control at low values.
    if (_isSnow) {
       // V4: Uncapped limits. 10 -> 4000
       dSpawnRate = 10.0 + (math.pow(aesthetic.quantity, 1.5) * 4000.0);
    } else {
       // Rain needs to be dense to be seen
       // V4: Uncapped. 20 -> 2500
       dSpawnRate = 20.0 + (math.pow(aesthetic.quantity, 1.5) * 2500.0);
    }
    
    // 2. AREA (Where?)
    // Controlled by 'area'. 0.0 = Pinpoint, 1.0 = Wide coverage
    // We Map 0-1 to 0.1x - 15.0x Radius
    dHSpread = 0.1 + (aesthetic.area * 14.0); 

    // 3. WEIGHT (Heavy or Light?)
    // Controlled by 'weight'. Affects Gravity and Velocity.
    if (_isSnow) {
      // Light snow floats (0.0), Heavy snow plummets (1.0)
      dGravity = 0.005 + (aesthetic.weight * 0.15); 
      dVelocityBase = 0.02 + (aesthetic.weight * 0.5); 
    } else {
      // Mist (0.0) -> Driving Rain (1.0)
      dGravity = 0.1 + (aesthetic.weight * 0.8);
      dVelocityBase = 0.1 + (aesthetic.weight * 1.5);
    }
    dVelocityVar = dVelocityBase * 0.4;
    
    // 4. SIZE (Scale)
    // Controlled by 'size'. Flake/Drop size.
    if (_isSnow) {
       dSizeBase = 1.0 + (aesthetic.size * 6.0); // Up to 7.0 size
    } else {
       dSizeBase = 0.5 + (aesthetic.size * 2.5); // Up to 3.0 thickness
    }
    dSizeVar = dSizeBase * 0.5;

    // 5. AGITATION (Chaos)
    // Controlled by 'agitation'. Wind, Turbulence, Jitter.
    // Inject some time-based sine wave for "Gusts" if agitation is high.
    final chaosSignal = math.sin(_time * (1.0 + aesthetic.agitation * 5.0));
    final localWind = (_windSpeed * 0.005);
    // Agitation adds random wind + gusting
    dWindX = localWind + (chaosSignal * aesthetic.agitation * 0.02) + ((_rng.nextDouble()-0.5) * aesthetic.agitation * 0.01);
    
    
    // AUTO-TUNING (If not in calibration mode)
    final calibState = ref.read(weatherCalibrationStateProvider);
    if (!calibState.isCalibrationMode) {
      double realIntensity = _precipIntensity / 5.0; // 5mm is base max
      if (_precipProbability > 0) {
         realIntensity = math.max(realIntensity, 0.1); 
      }
      realIntensity = realIntensity.clamp(0.0, 1.0);
      dSpawnRate *= realIntensity;
      if (_precipIntensity <= 0 && _precipProbability < 20) dSpawnRate = 0;
      dWindX = _windSpeed * 0.002;
    }

    // -------------------------------------------------------------------------
    // 2. SPAWN V4 (With Z-Depth)
    // -------------------------------------------------------------------------
    final toSpawn = (dSpawnRate * dt).toInt();
    final spawnCount = math.min(toSpawn, 300); // V4: Higher cap per tick
    
    if (spawnCount > 0) {
       final minX = calib.cx - calib.rx * dHSpread;
       final maxX = calib.cx + calib.rx * dHSpread;
       final startY = calib.cy - calib.ry; // Top of oval roughly
       
       for (int i = 0; i < spawnCount; i++) {
         // Randomize Start X
         final sx = minX + _rng.nextDouble() * (maxX - minX);
         final sy = startY - (_rng.nextDouble() * 0.5); 
         
         // V4: DEPTH ASSIGNMENT
         // Bias slightly towards background (0.0) for volume? Or uniform? 
         // Uniform is fine. 0.0 = Back, 1.0 = Front.
         final z = _rng.nextDouble();
         
         // PARALLAX PHYSICS
         // Background objects move slower.
         // Factor: 0.4 (at z0) to 1.0 (at z1)
         final depthFactor = 0.4 + (0.6 * z);

         if (_isSnow) {
           final life = 5.0 + _rng.nextDouble() * 5.0;
           _particles.add(_BioParticle(
             x: sx, y: sy,
             z: z, // V4
             type: _ParticleType.snow,
             vx: (dWindX + (_rng.nextDouble() - 0.5) * 0.02) * depthFactor, 
             vy: (dVelocityBase + (_rng.nextDouble() * dVelocityVar)) * depthFactor,
             life: life, maxLife: life,
             size: (dSizeBase + (_rng.nextDouble() * dSizeVar)) * depthFactor, // Background is smaller
           ));
         } else {
           _particles.add(_BioParticle(
             x: sx, y: sy,
             z: z, // V4
             type: _ParticleType.rain,
             vx: (dWindX + (_rng.nextDouble() - 0.5) * 0.01) * depthFactor,
             vy: (dVelocityBase + (_rng.nextDouble() * dVelocityVar)) * depthFactor,
             life: 1.0, maxLife: 1.0,
             size: (dSizeBase + (_rng.nextDouble() * 0.5)) * depthFactor,
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
  double x, y, z, vx, vy, life, maxLife, size;
  _ParticleType type;
  _BioParticle(
      {required this.x,
      required this.y,
      this.z = 0.5, // V4: Depth
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
    if (particles.isEmpty) return;
    final w = size.width;
    final h = size.height;

    final paintRain = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    // SNOW PAINTS (Cached variants for performance?)
    // Actually, drawing individually is fine for < 5000 in canvas.
    final paintSnow = Paint()
      ..color = Colors.white.withOpacity(0.92);
      // maskFilter dynamic based on Z? 
    // We will apply maskFilter dynamically if Z is low (blurred background)
    
    final paintCloud = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    final paintMist = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    // V4: SORT Back-to-Front so transparency layers correctly
    // Optimized: Only sort if needed? Sort is fast enough.
    particles.sort((a, b) => a.z.compareTo(b.z));

    for (final p in particles) {
      final px = p.x * w;
      final py = p.y * h;
      
      // Fade in/out logic
      double lifeAlpha = 1.0;
      if (p.life < 0.5) lifeAlpha = p.life / 0.5;
      if (p.maxLife - p.life < 0.5) lifeAlpha = (p.maxLife - p.life) / 0.5;
      lifeAlpha = lifeAlpha.clamp(0.0, 1.0);
      
      // V4: DEPTH VISUALS
      // Opacity drops with distance (Z=0 is back)
      // Z=1.0 -> 100% impact. Z=0.0 -> 30% impact.
      final depthAlpha = 0.3 + (0.7 * p.z);
      
      if (p.type == _ParticleType.rain) {
         // Rain gets thinner/shorter in back
         final rainAlpha = (lifeAlpha * depthAlpha * 0.6).clamp(0.0, 1.0);
         paintRain.color = paintRain.color.withOpacity(rainAlpha);
         paintRain.strokeWidth = 0.5 + (1.5 * p.z); // Thinner in back
         
         // Length depends on Z and Speed
         final len = 5.0 + (15.0 * p.z) * (p.vy * 5.0); 
         canvas.drawLine(
             Offset(px, py), Offset(px - p.vx * len, py - p.vy * len), paintRain);
             
      } else if (p.type == _ParticleType.snow) {
         final snowAlpha = (lifeAlpha * 0.95 * depthAlpha).clamp(0.0, 1.0);
         paintSnow.color = Colors.white.withOpacity(snowAlpha);
         
         // Defocus background interactively?
         // This is expensive (changing mask filter). Only do it for very back?
         // Or just use alpha to simulate distance.
         // Let's rely on Alpha + Size. Blur is too heavy for loop.
         
         final radius = p.size; // Scaled by Z in physics already? Yes.
         canvas.drawCircle(Offset(px, py), radius, paintSnow);
         
      } else if (p.type == _ParticleType.cloud) {
        paintCloud.color = paintCloud.color.withOpacity(lifeAlpha * 0.3);
        canvas.drawCircle(Offset(px, py), p.size, paintCloud);
      } else if (p.type == _ParticleType.mist) {
        paintMist.color = paintMist.color.withOpacity(lifeAlpha * 0.2);
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

