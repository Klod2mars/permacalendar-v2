import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/climate/presentation/providers/weather_time_provider.dart';

/// Un conteneur météo "Bio-Organique" SIMPLIFIÉ.
/// Ne gère plus que l'interaction (Drag) et l'affichage du texte "+X h".
/// Le rendu des particules est désormais global (WeatherBioLayer).
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

  @override
  Widget build(BuildContext context) {
    final hoursOffset = _dragOffsetPixels / _pixelsPerHour;
    final isTimeTraveling = hoursOffset > 0.1;
    
    return GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          behavior: HitTestBehavior.opaque, // Important pour capturer les touches sur la zone transparente
          child: Stack(
            alignment: Alignment.center,
            children: [
               // Debug/Dev or Nothing. Visible Particles are now GLOBAL.
               // This widget is TRANSPARENT touch zone essentially.
               
               // But we show the Text Indicator when traveling
               if (isTimeTraveling)
                 Column(
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
            ],
          ),
    );
  }
}
