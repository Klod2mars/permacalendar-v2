// lib/shared/widgets/calibration_debug_overlay.dart
import 'package:flutter/material.dart';

/// Overlay debug pour afficher une zone normalisÃ©e (Offset + size en 0..1).
/// Permet de visualiser les zones de calibration pendant les tests.
class CalibrationDebugOverlay extends StatelessWidget {
  final Offset position; // normalized (0..1)
  final double size; // normalized diameter (0..1) or box side
  final Color color;
  final double strokeWidth;
  final bool circular;

  const CalibrationDebugOverlay({
    super.key,
    required this.position,
    required this.size,
    this.color = Colors.white,
    this.strokeWidth = 2.0,
    this.circular = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;
      final left = (position.dx * w).clamp(0.0, w);
      final top = (position.dy * h).clamp(0.0, h);
      final side = (size * (w < h ? w : h)).clamp(8.0, (w < h ? w : h));

      return Stack(children: [
        Positioned(
          left: left - side / 2,
          top: top - side / 2,
          width: side,
          height: side,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                border: Border.all(color: color, width: strokeWidth),
                shape: circular ? BoxShape.circle : BoxShape.rectangle,
              ),
            ),
          ),
        ),
      ]);
    });
  }
}



