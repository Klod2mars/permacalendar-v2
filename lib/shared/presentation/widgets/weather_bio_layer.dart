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
      _spawnParticles(dt, calib, config);
      _updateParticles(dt, calib, config); // Physics collision
    }

    setState(() {});
  }

  void _updateWeatherState(double dt, WeatherCalibrationState calibState) {
    // 1. If Calibration Mode is ON, force values
    if (calibState.isCalibrationMode) {
      if (calibState.forcedPrecipMm != null) {
        _precipIntensity = calibState.forcedPrecipMm!;
        // If we force intensity, we assume prob is 100% or irrelevant
        _precipProbability = 100.0; 
      }
      if (calibState.forcedWindSpeed != null) {
        _windSpeed = calibState.forcedWindSpeed!;
      }
      if (calibState.forcedCloudCover != null) {
        _cloudCover = calibState.forcedCloudCover!;
      }
      
      // Determine Snow vs Rain based on Forced Code or just use current if not forced
      if (calibState.forcedWeatherCode != null) {
        final code = calibState.forcedWeatherCode!;
        _isSnow = (code >= 70 && code <= 79) || (code >= 85 && code <= 86);
      }
      // If nothing forced, we might keep previous values or read from provider?
      // Ideally we read from provider first, then overwrite.
      // So let's read real weather first below, then overwrite again.
    }

    // 2. Read Real Weather (Always do this to have a fallback base)
    final weatherAsync = ref.read(currentWeatherProvider);
    final timeOffset = ref.read(weatherTimeOffsetProvider);

    weatherAsync.whenData((data) {
      // Interpolation logic
      final projectedTime = DateTime.now()
          .toUtc()
          .add(Duration(minutes: (timeOffset * 60).round()));
      final interpolated = WeatherInterpolation.getInterpolatedWeather(
          data.result.hourlyWeather, projectedTime);

      if (interpolated != null) {
        _updateParamsFromPoint(interpolated);
      }
    });

    // 3. Re-apply overrides if needed (because async update might overwrite)
    if (calibState.isCalibrationMode) {
       if (calibState.forcedPrecipMm != null) _precipIntensity = calibState.forcedPrecipMm!;
       if (calibState.forcedWindSpeed != null) _windSpeed = calibState.forcedWindSpeed!;
       if (calibState.forcedCloudCover != null) _cloudCover = calibState.forcedCloudCover!;
       if (calibState.forcedWeatherCode != null) {
          final code = calibState.forcedWeatherCode!;
          _isSnow = (code >= 70 && code <= 79) || (code >= 85 && code <= 86);
       }
       // Force probability high if we are forcing precip
       if (calibState.forcedPrecipMm != null && calibState.forcedPrecipMm! > 0) {
         _precipProbability = 100.0;
       }
    }
  }

  void _updateParamsFromPoint(HourlyWeatherPoint p) {
    _windSpeed = p.windSpeedkmh;
    _precipIntensity = p.precipitationMm;
    _cloudCover = p.cloudCover.toDouble();
    _visibility = p.visibility;

    // Stocker la probabilité (par sécurité gérer null)
    _precipProbability = p.precipitationProbability.toDouble();

    final code = p.weatherCode;
    // Logique Neige/Pluie
    _isSnow = (code >= 70 && code <= 79) || (code >= 85 && code <= 86);
  }

  void _spawnParticles(double dt, SkyCalibrationConfig calib, WeatherConfig config) {
    // 1. Precipitations
    
    // Check config thresholds
    if (_precipIntensity > config.general.precipThresholdMm ||
        _precipProbability >= config.general.precipThresholdProb) {
      
      // Base spawnRate derived from intensity
      // Rain: 50 * intensity
      // Snow: Configurable multiplier
      
      double spawnRate = 0.0;
      
      if (_isSnow) {
        // Use snow specific base multiplier from config
         spawnRate = _precipIntensity * config.snow.baseMultiplier;
      } else {
         spawnRate = _precipIntensity * config.rain.spawnRateBase;
      }

      // Fallback if probability is high but intensity low (drizzle/mist)
      if (spawnRate < 1.0 && _precipProbability >= config.general.precipThresholdProb) {
        spawnRate = (_precipProbability / 100.0) * 6.0;
      }

      final calculated = (spawnRate * dt).toInt();
      
      // Apply Caps
      final cap = _isSnow ? config.snow.spawnCap : 3000; // Rain cap default high
      final toSpawn = math.max(1, math.min(calculated, cap));

      if (kWeatherDebug) {
        debugPrint(
            'SPAWN -> spawnRate=${spawnRate.toStringAsFixed(2)} isSnow=$_isSnow toSpawn=$toSpawn precip=${_precipIntensity}');
      }

      // Spawn zone
      // Snow can have wider spread
      final hSpread = _isSnow ? config.snow.horizontalSpread : config.rain.horizontalSpread;
      final startYSpread = _isSnow ? config.snow.startYSpread : 0.0;

      final minX = calib.cx - calib.rx * hSpread;
      final maxX = calib.cx + calib.rx * hSpread;
      final baseStartY = calib.cy - calib.ry;

      for (int i = 0; i < toSpawn; i++) {
        final startX = minX + _rng.nextDouble() * (maxX - minX);
        final startY = baseStartY - (_rng.nextDouble() * startYSpread);

        if (_isSnow) {
          final size = config.snow.fallSpeedBase + // Using sizeBase logic mismatch in original code, fixing:
                       config.snow.sizeBase + // Actually using sizeBase
              _rng.nextDouble() * config.snow.sizeVariance; // Use variance from config
          
          // Life logic
          final lifeTime = 10.0 + _rng.nextDouble() * 4.0; 

          _particles.add(_BioParticle(
            x: startX,
            y: startY,
            type: _ParticleType.snow,
            vx: _windSpeed * 0.005 + (_rng.nextDouble() - 0.5) * 0.02, 
            vy: config.snow.fallSpeedBase + _rng.nextDouble() * config.snow.fallSpeedVariance,
            life: lifeTime,
            maxLife: lifeTime,
            size: size,
          ));
        } else {
          _particles.add(_BioParticle(
            x: startX,
            y: startY,
            type: _ParticleType.rain,
            vx: _windSpeed * config.general.windFactor, // Use generalized wind factor? Or keep hardcoded 0.005?
            // Let's assume 0.005 is part of the 'velocityBase' or internal physics, keeping it simple for now or using rain config
             // Actually, Rain Config has velocityBase (0.2). Rain Vy = 0.2 + variance.
            vy: (config.rain.velocityBase + _rng.nextDouble() * config.rain.velocityVariance),
            life: 1.0,
            size: config.rain.sizeBase + _rng.nextDouble() * config.rain.sizeVariance,
          ));
        }
      }
    }
    // Nuages
    if (_cloudCover > 30) {
      final currentClouds =
          _particles.where((p) => p.type == _ParticleType.cloud).length;
      if (currentClouds < config.cloud.maxClouds && _rng.nextDouble() < config.cloud.spawnChance) {
        _particles.add(_BioParticle(
            x: calib.cx + (_rng.nextDouble() - 0.5) * calib.rx * 1.5,
            y: calib.cy - calib.ry + _rng.nextDouble() * calib.ry * 0.5,
            type: _ParticleType.cloud,
            vx: (_rng.nextDouble() - 0.5) * config.cloud.speedVariance,
            vy: 0,
            life: 1.0,
            maxLife: 1.0,
            size: config.cloud.sizeBase + _rng.nextDouble() * config.cloud.sizeVariance));
      }
    }
  }

  void _updateParticles(double dt, SkyCalibrationConfig calib, WeatherConfig config) {
    // Gravité
    final gravity = _isSnow ? config.snow.gravity : config.rain.gravity;

    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= dt;

      // Physique
      if (p.type == _ParticleType.rain || p.type == _ParticleType.snow) {
        p.vy += gravity * dt;
        p.x += p.vx * dt;
        p.y += p.vy * dt;

        // --- COLLISION OVÏDE RÉELLE ---
        if (config.general.enableCollision) {
          // 1. Transformer position particule dans repère local de l'ellipse
          final dx = p.x - calib.cx;
          final dy = p.y - calib.cy;
  
          // Rotation inverse (-rotation)
          final angle = -calib.rotation;
          final localX = dx * math.cos(angle) - dy * math.sin(angle);
          final localY = dx * math.sin(angle) + dy * math.cos(angle);
  
          // 2. Équation ellipse: (x/rx)^2 + (y/ry)^2
          // Si > 1, on est dehors
          final rx = calib.rx;
          final ry = calib.ry;
          final eq =
              (localX * localX) / (rx * rx) + (localY * localY) / (ry * ry);
  
          if (eq >= 1.0) {
            // COLLISION ADOUCIE
            final tangentX = -localY / ry;
            final tangentY = localX / rx;
  
            // Tuning collision damping via simple constant or new config param
            // Keeping hardcoded 0.02 for now as it's physics-y, or use general damping fallback
            p.vx += tangentX * 0.02;
            p.vy += tangentY * 0.02 * 0.1;
  
            p.life -= 0.15; // Hardcoded fade on collision
  
            if (eq > 1.05) p.life = -1;
          }
        }
      } else if (p.type == _ParticleType.cloud) {
        p.x += p.vx * dt;
      }

      if (p.life <= 0) {
        _particles.removeAt(i);
      }
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

