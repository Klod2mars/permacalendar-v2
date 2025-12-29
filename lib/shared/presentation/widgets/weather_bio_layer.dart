import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/hourly_weather_point.dart';
import '../../../core/models/sky_calibration_config.dart';
import '../../../features/climate/domain/models/weather_view_data.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../features/climate/presentation/providers/weather_time_provider.dart';

/// Layer Global pour la simulation de particules (Pluie, Neige, Nuages).
/// Respecte la calibration du ciel.
class WeatherBioLayer extends ConsumerStatefulWidget {
  const WeatherBioLayer({super.key});

  @override
  ConsumerState<WeatherBioLayer> createState() => _WeatherBioLayerState();
}

class _WeatherBioLayerState extends ConsumerState<WeatherBioLayer> with TickerProviderStateMixin {
  late Ticker _ticker;
  final List<_BioParticle> _particles = [];
  final Random _rng = Random();
  double _time = 0.0;
  
  // Weather Params
  double _windSpeed = 0.0;
  double _precipIntensity = 0.0;
  bool _isSnow = false;
  bool _isCloudy = false;
  bool _isSunny = false;

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
    final dt = (elapsed.inMicroseconds - _time * 1000000).clamp(0, 100000) / 1000000.0; // clamp jump
    _time = elapsed.inMicroseconds / 1000000.0;

    // Logic Rate Limit aka "ticks" if needed, but for particles 60fps is fine if optimized.
    if (dt > 0.1) return; 

    // 1. Sync Weather Data
    final weatherAsync = ref.read(currentWeatherProvider);
    final timeOffset = ref.read(weatherTimeOffsetProvider);
    
    weatherAsync.whenData((data) {
       final projected = _getProjectedWeather(data, timeOffset);
       if (projected != null) {
          _updateParamsFromPoint(projected);
       } else {
          _updateParamsFromCurrent(data.result);
       }
    });

    // 2. Physics & Spawn
    final calib = ref.read(skyCalibrationProvider);
    _spawnParticles(dt, calib);
    _updateParticles(dt);

    setState(() {});
  }
  
  void _spawnParticles(double dt, SkyCalibrationConfig calib) {
    // Check global availability
    // Note: We use calibration to determine spawn X relative to screen width 0..1
    // Simplification: Spawn across the width of the bounding box of the ellipse
    
    if (_precipIntensity > 0.05 && !_isSunny) {
         final spawnRate = _precipIntensity * 50 + (_isSnow ? 20 : 0);
         final toSpawn = (spawnRate * dt).toInt();
         
         // Bounding Box X
         // Center X +/- Radius X (ignoring rotation for spawn area approximation, particles fall down anyway)
         // Actually if rotated, gravity is still Down (screen Y).
         
         final minX = calib.cx - calib.rx;
         final maxX = calib.cx + calib.rx;
         final startY = calib.cy - calib.ry; // Top of oval

         for(int i=0; i<toSpawn; i++) {
             // Random X in bounds
             final startX = minX + _rng.nextDouble() * (maxX - minX);
             
             _particles.add(_BioParticle(
               x: startX, 
               y: startY,
               type: _isSnow ? _ParticleType.snow : _ParticleType.rain,
               vx: _windSpeed * 0.01 + (_rng.nextDouble() - 0.5) * 0.005,
               vy: _isSnow ? 0.05 : 0.2 + (_rng.nextDouble() * 0.1),
               life: 1.0,
               size: _rng.nextDouble() * 2 + 1,
             ));
         }
    }
    
    // Clouds
    if (_isCloudy) {
       final currentClouds = _particles.where((p) => p.type == _ParticleType.cloud).length;
       if (currentClouds < 5 && _rng.nextDouble() < 0.01) {
           _particles.add(_BioParticle(
             x: calib.cx + (_rng.nextDouble()-0.5)*calib.rx*2,
             y: calib.cy - calib.ry + _rng.nextDouble()*calib.ry,
             type: _ParticleType.cloud,
             vx: (_rng.nextDouble()-0.5)*0.02,
             vy: 0,
             life: 10.0,
             maxLife: 10.0,
             size: 30 + _rng.nextDouble()*20
           ));
       }
    }
  }

  void _updateParticles(double dt) {
     final gravity = _isSnow ? 0.05 : 0.5; // Scaled down for 0..1 coord system (1.0 = screen height)
     
     for (int i = _particles.length - 1; i >= 0; i--) {
        final p = _particles[i];
        p.life -= dt;
        
        if (p.type == _ParticleType.rain || p.type == _ParticleType.snow) {
           p.vy += gravity * dt;
           p.x += p.vx * dt;
           p.y += p.vy * dt;
           
           // Floor Collision (Calibration dependent? No, let's keep floor simple or relative to oval bottom)
           // Actually, "Floor" was 0.35 in old widget. In global overlay, floor is much lower.
           // Let's say floor is proper bottom of screen (1.0) or simply kill if > 1.0
           if (p.y > 1.0) p.life = -1;
        } else if (p.type == _ParticleType.cloud) {
           p.x += p.vx * dt;
           // Cloud drift
        }
        
        if (p.life <= 0) {
           _particles.removeAt(i);
        }
     }
  }

  // --- Weather Helpers (duplicated from BioContainer but simplified) ---
  HourlyWeatherPoint? _getProjectedWeather(WeatherViewData data, double offsetHours) {
      if (data.result.hourlyWeather.isEmpty) return null;
      if (offsetHours < 0.02) return null;
      final target = DateTime.now().toUtc().add(Duration(minutes: (offsetHours * 60).round()));
      // Simple loop search
      HourlyWeatherPoint? best;
      Duration minD = const Duration(days: 9);
      for(final p in data.result.hourlyWeather) {
         final d = p.time.difference(target).abs();
         if(d < minD) { minD = d; best = p; }
      }
      return best;
  }
  
  void _updateParamsFromCurrent(dynamic res) {
      if (res == null) return;
      _windSpeed = res.currentWindSpeed ?? 0.0;
      // Precip? Check hourly or assume 0 if not provided in current
      _precipIntensity = 0.0; // Simplification, ideally verify hourly like before
      final code = res.currentWeatherCode ?? 0;
      _deriveBooleans(code);
  }
  
  void _updateParamsFromPoint(HourlyWeatherPoint p) {
      _windSpeed = p.windSpeedkmh;
      _precipIntensity = p.precipitationMm;
      _deriveBooleans(p.weatherCode);
  }

  void _deriveBooleans(int code) {
      _isSnow = (code >= 70 && code <= 79) || (code >= 85 && code <= 86);
      _isCloudy = (code >= 1 && code <= 3) || (code >= 45); 
      _isSunny = (code == 0) && !_isCloudy && !_isSnow && (_precipIntensity < 0.05);
  }

  @override
  Widget build(BuildContext context) {
    final calib = ref.watch(skyCalibrationProvider);
    
    return IgnorePointer( // NON-INTERACTIVE : JUST VISUALS
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

enum _ParticleType { rain, snow, cloud }
class _BioParticle {
  double x, y, vx, vy, life, maxLife, size;
  _ParticleType type;
  _BioParticle({required this.x, required this.y, required this.type, this.vx=0, this.vy=0, this.life=1, this.maxLife=1, this.size=1});
}

class _BioParticlePainter extends CustomPainter {
  final List<_BioParticle> particles;
  final bool isSnow;
  _BioParticlePainter(this.particles, this.isSnow);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paintRain = Paint()..color = Colors.blueAccent.withOpacity(0.6)..strokeWidth=1.5..strokeCap=StrokeCap.round;
    final paintSnow = Paint()..color = Colors.white.withOpacity(0.8)..style = PaintingStyle.fill;
    final paintCloud = Paint()..color = Colors.white.withOpacity(0.3)..maskFilter=const MaskFilter.blur(BlurStyle.normal, 10);
    
    for(final p in particles) {
       final px = p.x * size.width;
       final py = p.y * size.height;
       final alpha = (p.life / p.maxLife).clamp(0.0, 1.0);
       
       if (p.type == _ParticleType.rain) {
          paintRain.color = paintRain.color.withOpacity(alpha * 0.6);
          canvas.drawLine(Offset(px, py), Offset(px - p.vx*10, py - p.vy*10), paintRain);
       } else if (p.type == _ParticleType.snow) {
          paintSnow.color = paintSnow.color.withOpacity(alpha * 0.8);
          canvas.drawCircle(Offset(px, py), p.size, paintSnow);
       } else if (p.type == _ParticleType.cloud) {
          paintCloud.color = paintCloud.color.withOpacity(alpha * 0.3);
          canvas.drawCircle(Offset(px, py), p.size, paintCloud);
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
    // Replicate same logic as before
    final w = size.width;
    final h = size.height;
    final center = Offset(config.cx * w, config.cy * h);
    final matrix = Matrix4.identity()..translate(center.dx, center.dy)..rotateZ(config.rotation);
    
    final path = Path()..addOval(Rect.fromCenter(center: Offset.zero, width: config.rx * w * 2, height: config.ry * h * 2));
    return path.transform(matrix.storage);
  }
  @override
  bool shouldReclip(covariant _OrganicSkyClipper old) => old.config != config;
}
