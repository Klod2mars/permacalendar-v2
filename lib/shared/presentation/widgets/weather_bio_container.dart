import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../features/climate/presentation/providers/weather_time_provider.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../core/models/hourly_weather_point.dart';

/// Un conteneur météo "Bio-Organique" SIMPLIFIÉ.
/// Ne gère plus que l'interaction (Drag) et l'affichage des infos projetées.
class WeatherBioContainer extends ConsumerStatefulWidget {
  const WeatherBioContainer({super.key});

  @override
  ConsumerState<WeatherBioContainer> createState() => _WeatherBioContainerState();
}

class _WeatherBioContainerState extends ConsumerState<WeatherBioContainer>
    with SingleTickerProviderStateMixin {
  
  // -- Interaction State (Time Travel) --
  late AnimationController _recoilController;
  double _dragOffsetPixels = 0.0;
  
  // Sensibilité : ~12px pour 1 heure
  static const double _pixelsPerHour = 12.0;
  
  @override
  void initState() {
    super.initState();
    _recoilController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _recoilController.addListener(() {
      setState(() {
         // Rebuild for time update
      });
    });
  }

  @override
  void dispose() {
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
      
      // Update Shared State for Sky
      ref.read(weatherTimeOffsetProvider.notifier).setOffset(_dragOffsetPixels / _pixelsPerHour);
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
        // Update Shared State for Sky during recoil
        ref.read(weatherTimeOffsetProvider.notifier).setOffset(_dragOffsetPixels / _pixelsPerHour);
      });
    });
    
    _recoilController.forward();
  }
  
  // Helper simple pour trouver le point le plus proche (pour l'affichage texte on n'a pas besoin de lerp parfait)
  HourlyWeatherPoint? _findNearest(List<HourlyWeatherPoint> hourly, DateTime target) {
    if (hourly.isEmpty) return null;
    HourlyWeatherPoint? best;
    Duration minD = const Duration(days: 9);
    for(final p in hourly) {
       final d = p.time.difference(target).abs();
       if(d < minD) { minD = d; best = p; }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final hoursOffset = _dragOffsetPixels / _pixelsPerHour;
    final isTimeTraveling = hoursOffset > 0.1;
    
    // Data access
    final weatherAsync = ref.watch(currentWeatherProvider);
    final projectedTime = DateTime.now().toUtc().add(Duration(minutes: (hoursOffset * 60).round()));
    
    return GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          behavior: HitTestBehavior.opaque, 
          child: Stack(
            alignment: Alignment.center,
            children: [
               if (isTimeTraveling)
                 weatherAsync.when(
                    data: (data) {
                       final point = _findNearest(data.result.hourlyWeather, projectedTime);
                       final temp = point?.temperatureC ?? data.result.currentTemperatureC ?? 0;
                       final precip = point?.precipitationMm ?? 0;
                       final prob = point?.precipitationProbability ?? 0;
                       final wind = point?.windSpeedkmh ?? 0;
                       
                       // Local time string
                       final localTime = projectedTime.toLocal();
                       final timeStr = DateFormat('HH:mm').format(localTime);
                       final dayStr = DateFormat('EEEE d', 'fr_FR').format(localTime);

                       return Center(
                         child: FittedBox(
                           fit: BoxFit.scaleDown,
                           child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.update, 
                                color: Colors.cyanAccent, 
                                size: 24,
                                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+ ${hoursOffset.toStringAsFixed(1)} h',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1)),
                                    Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 2)),
                                  ]
                                ),
                              ),
                            ],
                          ),
                         ),
                       );
                    },
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                 ),
            ],
          ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? sub;
  const _StatBadge({required this.icon, required this.value, this.sub});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
        if (sub != null) ...[
          const SizedBox(width: 2),
          Text('($sub)', style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ]
      ],
    );
  }
}
