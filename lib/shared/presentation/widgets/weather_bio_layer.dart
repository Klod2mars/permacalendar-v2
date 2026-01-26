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
import '../../../features/climate/presentation/providers/weather_metrics_provider.dart';


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
  
  // Lightning State
  double _lightningFlashOpacity = 0.0;
  double _timeSinceLastFlash = 0.0;
  double _secondaryFlashCountdown = -1.0; // < 0 means inactive

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
  
  double _lastCalculatedSpawnRate = 0.0;
  int _ticksCount = 0;
  DateTime _lastMetricsUpdate = DateTime.now();
  int _lastCollisionRate = 0;

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

    // Metrics Throttling (2 times per second)
    _ticksCount++;
    if (_ticksCount % 30 == 0) {
        final now = DateTime.now();
        if (now.difference(_lastMetricsUpdate).inMilliseconds > 500) {
           _lastMetricsUpdate = now;
           // Update provider
           final metrics = WeatherEngineMetrics(
              particleCount: _particles.length,
              spawnRate: _lastCalculatedSpawnRate,
              collisionRate: _lastCollisionRate, // this is mostly cummulative current frame... actually reset it?
           );
           _lastCollisionRate = 0; // Reset counter for next window
           
           // Use Microtask to avoid build conflicts
           Future.microtask(() {
              if (mounted) ref.read(weatherMetricsProvider.notifier).updateMetrics(metrics);
           });
        }
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
    // 1. RESOLVE PHYSICS FROM AESTHETICS (V4.1 Refined - Decoupled)
    // -------------------------------------------------------------------------
    
    // Pick the right sculpted material
    final aesthetic = _isSnow ? config.aesthetics.snow : config.aesthetics.rain;
    
    // Derived Physics Values
    double dGravity = 0.5;
    double dSpawnRate = 0.0;
    double dVelocityBase = 0.2;
    double dVelocityVar = 0.1;
    double dSizeBase = 1.0;
    double dSizeVar = 1.0;
    double dHSpread = 1.5;
    double dWindX = 0.0;
    
    // V5: FULL VOLUME WIDENING
    // Area maps to "How much of the ovoid width is covered?"
    // 1.0 = Full Ovoid Width + 30% margin for parallax.
    // 0.2 = Narrow central column.
    dHSpread = 0.2 + (aesthetic.area * 1.3); 
    
    // Density Control (Particles per Unit Area)
    // We want Quantity to mean "How dense is it LOCALLY".
    // So distinct from Area.
    // If Area is small, Quantity=1.0 -> Dense core.
    // If Area is large, Quantity=1.0 -> Dense everywhere.
    // This implies TotalSpawnRate = Density * Area.
    
    final baseDensity = aesthetic.quantity; // 0..1
    double densityCurve = math.pow(baseDensity, 1.6).toDouble(); // gentle power
    
    double spawnPerUnit = _isSnow ? 2500.0 : 3000.0; // V5 Boost: Maximum Intensity
    double spawnRateRaw = (densityCurve * spawnPerUnit) * dHSpread;
    
    // SOFT CAP to prevent explosions
    // V5: Raised limits to allow "Heavy Rain" over "Wide Area"
    final softCap = _isSnow ? 12000.0 : 15000.0;
    if (spawnRateRaw > softCap) {
       // Logarithmic approach to limit
       spawnRateRaw = softCap + (math.log(spawnRateRaw - softCap + 1) * 100);
    }
    
    dSpawnRate = spawnRateRaw;

    // 3. WEIGHT (Heavy or Light?)
    if (_isSnow) {
      dGravity = 0.005 + (aesthetic.weight * 0.15); 
      dVelocityBase = 0.02 + (aesthetic.weight * 0.5); 
    } else {
      // V5: Relaxed Rain Physics to allow "Beautiful Rain" (Snow-like float)
      // Old: 0.1 was min gravity. Now 0.02 to allow slow falls.
      dGravity = 0.02 + (aesthetic.weight * 0.8);
      dVelocityBase = 0.05 + (aesthetic.weight * 1.5);
    }
    dVelocityVar = dVelocityBase * 0.4;
    
    // 4. SIZE (Scale)
    if (_isSnow) {
       dSizeBase = 1.0 + (aesthetic.size * 5.0); 
    } else {
       dSizeBase = 0.5 + (aesthetic.size * 2.5); 
    }
    dSizeVar = dSizeBase * 0.5;

    // 5. AGITATION (Chaos)
    final chaosSignal = math.sin(_time * (1.0 + aesthetic.agitation * 5.0));
    final localWind = (_windSpeed * 0.005);
    dWindX = localWind + (chaosSignal * aesthetic.agitation * 0.02) + ((_rng.nextDouble()-0.5) * aesthetic.agitation * 0.01);
    
    // -------------------------------------------------------------------------
    // V5: LIGHTNING (Additive)
    // -------------------------------------------------------------------------
    _timeSinceLastFlash += dt;
    if (aesthetic.lightning > 0) {
       // Cooldown of 2 seconds minimum
       // Probability scales with lightning parameter.
       // 0.8 => Frequent (every ~3-8 sec?)
       if (_timeSinceLastFlash > 2.0) {
          final chance = aesthetic.lightning * 0.01 * dt * 60; // Approximate per frame
          if (_rng.nextDouble() < chance) {
             _triggerFlash(intensity: 0.6 + (_rng.nextDouble() * 0.4));
             _timeSinceLastFlash = 0.0;
             
             // DOUBLE IMPACT LOGIC (User Request)
             // 35% chance to trigger a secondary flash 50-150ms later
             if (_rng.nextDouble() < 0.35) {
                _secondaryFlashCountdown = 0.05 + (_rng.nextDouble() * 0.10);
             } else {
                _secondaryFlashCountdown = -1.0;
             }
          }
       }
    }
    
    // Handle Secondary Flash
    if (_secondaryFlashCountdown > 0) {
       _secondaryFlashCountdown -= dt;
       if (_secondaryFlashCountdown <= 0) {
          // Trigger the echo
          _triggerFlash(intensity: 0.4 + (_rng.nextDouble() * 0.4)); // Slightly weaker or random
          _secondaryFlashCountdown = -1.0; 
       }
    }
    
    // Decay Flash
    if (_lightningFlashOpacity > 0) {
       _lightningFlashOpacity -= dt * 5.0; // Quick fade out (0.2s)
       if (_lightningFlashOpacity < 0) _lightningFlashOpacity = 0;
    }
    
    // -------------------------------------------------------------------------
    // 2. SPAWN V4.1 (Clumping & Z-Depth)
    // -------------------------------------------------------------------------
    
    // Calculate total spawning budget for this tick
    int toSpawn = (dSpawnRate * dt).toInt();
    
    // Granularity (Burstiness)
    const burstChance = 0.1; // 10% chance to burst
    bool isBurst = false;
    if (aesthetic.granularity > 0) {
       // Reduce steady spawn, add potential bursts
       if (_rng.nextDouble() < burstChance) {
          isBurst = true;
          toSpawn = (toSpawn * (1.0 + aesthetic.granularity * 5.0)).toInt();
       } else {
          toSpawn = (toSpawn * (1.0 - aesthetic.granularity * 0.8)).toInt();
       }
    }
    
    final spawnCapPerTick = 2000; // V5 Boost: Relaxed safety cap
    int validSpawn = math.min(toSpawn, spawnCapPerTick);
    
    if (validSpawn > 0) {
       final minX = calib.cx - calib.rx * dHSpread;
       final maxX = calib.cx + calib.rx * dHSpread;
       final startY = calib.cy - calib.ry; 
       
       for (int i = 0; i < validSpawn; i++) {
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
    // 3. CLOUDS (DISABLED V5 per User Feedback)
    // -------------------------------------------------------------------------
    /*
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
    */

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
         // V5: DISABLE COLLISION FOR RAIN (Prevent funneling, allow straight fall)
         // Only apply collision to snow for "drift/settle" effect.
         if (config.general.enableCollision && p.type == _ParticleType.snow) {
            _handleCollision(p, calib);
         }
      } else if (p.type == _ParticleType.cloud) {
        p.x += p.vx * dt;
      }
      
      if (p.life <= 0) _particles.removeAt(i);
    }
  }

  void _spawnParticle(double sx, double sy, double sz, double windX, double baseV, double varV, double baseS, double varS, WeatherConfig config) {
     final depthFactor = 0.4 + (0.6 * sz);
     
     if (_isSnow) {
       final life = 5.0 + _rng.nextDouble() * 5.0;
       _particles.add(_BioParticle(
         x: sx, y: sy,
         z: sz,
         type: _ParticleType.snow,
         vx: (windX + (_rng.nextDouble() - 0.5) * 0.02) * depthFactor, 
         vy: (baseV + (_rng.nextDouble() * varV)) * depthFactor,
         life: life, maxLife: life,
         size: (baseS + (_rng.nextDouble() * varS)) * depthFactor, 
       ));
     } else {
       _particles.add(_BioParticle(
         x: sx, y: sy,
         z: sz,
         type: _ParticleType.rain,
         vx: (windX + (_rng.nextDouble() - 0.5) * 0.01) * depthFactor,
         vy: (baseV + (_rng.nextDouble() * varV)) * depthFactor,
         life: 1.0, maxLife: 1.0,
         size: (baseS + (_rng.nextDouble() * 0.5)) * depthFactor, 
       ));
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
      
      // SOFT COLLISION V4.1
      if (eq >= 1.0) {
         final penetration = (eq - 1.0);
         if (penetration < 0.2) { // 20% margin
            _lastCollisionRate++;
            p.vx *= 0.6; 
            p.vy *= 0.4; 
            p.life -= 0.1; 
         } else {
            p.life = -1;
         }
      }
  }

  void _triggerFlash({required double intensity}) {
      // If a flash is already happening, we add to it or overwrite if brighter
      if (intensity > _lightningFlashOpacity) {
         _lightningFlashOpacity = intensity;
      } else {
         // boost slightly
         _lightningFlashOpacity = (_lightningFlashOpacity + intensity).clamp(0.0, 1.0);
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
            painter: _BioParticlePainter(_particles, _isSnow, _lightningFlashOpacity),
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
  final double flashOpacity;
  
  _BioParticlePainter(this.particles, this.isSnow, this.flashOpacity);

  @override
  void paint(Canvas canvas, Size size) {
    // 0. FLASH BACKGROUND (Illuminates sky)
    if (flashOpacity > 0.01) {
       canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), 
          Paint()..color = Colors.white.withOpacity(flashOpacity)
       );
    }

    if (particles.isEmpty) return;
    final w = size.width;
    final h = size.height;

    final paintRain = Paint()
      // V5: WHITER RAIN (Silvery/Nuanced)
      // User feedback: Blue was too fake. Wanted "White slightly nuanced".
      ..color = const Color(0xFFD6E4FF).withOpacity(0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    // SNOW PAINTS (Soft, Matte, White)
    final paintSnow = Paint()
      ..color = Colors.white.withOpacity(0.85) // Matte White (less glare)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5); // Soft edges
    
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
         
         // Length: Drastically reduced to avoid "Blue Screen" saturation
         // Old: 5.0 + (15.0 * z) * (p.vy * 5.0)
         // New: More discrete drops, less "Laser beams"
         final len = 4.0 + (8.0 * p.z) * (p.vy * 1.5); 
         canvas.drawLine(
             Offset(px, py), Offset(px - p.vx * len, py - p.vy * len), paintRain);
             
      } else if (p.type == _ParticleType.snow) {
         final snowAlpha = (lifeAlpha * 0.95 * depthAlpha).clamp(0.0, 1.0);
         paintSnow.color = Colors.white.withOpacity(snowAlpha);
         
         // Defocus background interactively?
         // This is expensive (changing mask filter). Only do it for very back?
         // Or just use alpha to simulate distance.
         // Let's rely on Alpha + Size. Blur is too heavy for loop.
         
         // Defocus background interactively?
         // This is expensive (changing mask filter). Only do it for very back?
         // Or just use alpha to simulate distance.
         // Let's rely on Alpha + Size. Blur is too heavy for loop.
         
         final radius = p.size; // Scaled by Z in physics already? Yes.
         canvas.drawCircle(Offset(px, py), radius, paintSnow);
         
      } 
      /*
      else if (p.type == _ParticleType.cloud) {
        paintCloud.color = paintCloud.color.withOpacity(lifeAlpha * 0.3);
        canvas.drawCircle(Offset(px, py), p.size, paintCloud);
      } else if (p.type == _ParticleType.mist) {
        paintMist.color = paintMist.color.withOpacity(lifeAlpha * 0.2);
        canvas.drawCircle(Offset(px, py), p.size, paintMist);
      }
      */
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
