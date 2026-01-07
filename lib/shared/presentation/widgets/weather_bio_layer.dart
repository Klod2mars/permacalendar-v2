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

  // DEBUG / TEMP FLAGS - à désactiver après diagnostic
  static const bool kWeatherDebug = true;
  static const double kPrecipSpawnThreshold = 0.02; // mm, seuil réduit pour tests
  static const double kPrecipProbabilityThreshold = 30.0; // % - si >=, on force spawn

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

    if (dt > 0.0) {
      _updateWeatherState(dt);
      _spawnParticles(dt, calib);
      _updateParticles(dt, calib); // Physics collision
    }

    setState(() {});
  }

  void _updateWeatherState(double dt) {
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

    if (kWeatherDebug) {
      debugPrint(
          'WEATHER_BIO -> time=${p.time.toUtc().toIso8601String()} precip=${_precipIntensity}mm prob=${_precipProbability}% code=${code} isSnow=${_isSnow} wind=${_windSpeed}km/h');
    }
  }

  void _spawnParticles(double dt, SkyCalibrationConfig calib) {
    // 1. Precipitations
    // On déclenche si l'intensité (mm) dépasse un seuil de test, OU si la probabilité est importante.
    if (_precipIntensity > kPrecipSpawnThreshold ||
        _precipProbability >= kPrecipProbabilityThreshold) {
      // Taux de spawn (particules / sec) basé sur l'intensité
      double spawnRate = _precipIntensity * 50;
      if (_isSnow) spawnRate *= 0.2; // Moins de flocons que de gouttes

      // Si l'intensité est très faible mais la probabilité est élevée,
      // créer un spawnRate minimal pour rendre l'effet visible en test.
      if (spawnRate < 1.0 && _precipProbability >= kPrecipProbabilityThreshold) {
        // Convertit prob en un spawnRate de test (ex: prob 50% -> ~5 particules/s)
        spawnRate = (_precipProbability / 100.0) * 10.0;
      }

      final toSpawn = math.max(1, (spawnRate * dt).toInt());

      if (kWeatherDebug) {
        debugPrint(
            'SPAWN -> spawnRate=${spawnRate.toStringAsFixed(2)} isSnow=$_isSnow toSpawn=$toSpawn precip=${_precipIntensity} prob=${_precipProbability}');
      }

      if (kWeatherDebug) {
        debugPrint('CALIB -> cx=${calib.cx} cy=${calib.cy} rx=${calib.rx} ry=${calib.ry} rot=${calib.rotation}');
      }

      // Spawn zone: en haut de l'ellipse
      final minX = calib.cx - calib.rx * 0.8;
      final maxX = calib.cx + calib.rx * 0.8;
      final startY = calib.cy - calib.ry;

      for (int i = 0; i < toSpawn; i++) {
        final startX = minX + _rng.nextDouble() * (maxX - minX);
        _particles.add(_BioParticle(
          x: startX,
          y: startY,
          type: _isSnow ? _ParticleType.snow : _ParticleType.rain,
          vx: _windSpeed * 0.005, // Vent influence X
          vy: _isSnow
              ? (0.05 + _rng.nextDouble() * 0.02)
              : (0.2 + _rng.nextDouble() * 0.1), // Gravité
          life: 1.0,
          size: _rng.nextDouble() * 2 + 1,
        ));
      }
    }
    // Nuages (basé sur cloudCover)
    if (_cloudCover > 30) {
      final currentClouds =
          _particles.where((p) => p.type == _ParticleType.cloud).length;
      if (currentClouds < 4 && _rng.nextDouble() < 0.02) {
        _particles.add(_BioParticle(
            x: calib.cx + (_rng.nextDouble() - 0.5) * calib.rx * 1.5,
            y: calib.cy - calib.ry + _rng.nextDouble() * calib.ry * 0.5,
            type: _ParticleType.cloud,
            vx: (_rng.nextDouble() - 0.5) * 0.01,
            vy: 0,
            life: 1.0,
            maxLife: 1.0,
            size: 40 + _rng.nextDouble() * 30));
      }
    }
  }

  void _updateParticles(double dt, SkyCalibrationConfig calib) {
    // Gravité
    final gravity = _isSnow ? 0.05 : 0.5;

    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= dt;

      // Physique
      if (p.type == _ParticleType.rain || p.type == _ParticleType.snow) {
        p.vy += gravity * dt;
        p.x += p.vx * dt;
        p.y += p.vy * dt;

        // --- COLLISION OVÏDE RÉELLE ---
        // 1. Transformer position particule dans repère local de l'ellipse
        // Centre ellipse (cx, cy)
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
          // COLLISION !
          // Option A: Disparition (Splash)
          p.life = -1;

          // Option B (Avancé): Faire glisser ou rebondir.
          // Ici on se contente de tuer pour éviter la charge visuelle,
          // mais c'est BEAUCOUP plus propre que y > 1.0 car cela suit la forme.
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
    final paintSnow = Paint()..color = Colors.white.withOpacity(0.8);
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
        paintSnow.color = paintSnow.color.withOpacity(alpha * 0.9);
        canvas.drawCircle(Offset(px, py), p.size, paintSnow);
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
