ï»¿import 'package:flutter/material.dart';
import 'insect_animation_config.dart';

/// Painter pour le halo persistant des jardins actifs
/// Mission A39-2.1 : Halo lumineux discret avec pulsation lente
class InsectPersistentHaloPainter extends CustomPainter {
  final Animation<double> pulsationAnimation;
  final Animation<double>? fadeOutAnimation; // null si pas de fade out
  final Color glowColor;
  final Size bubbleSize;

  InsectPersistentHaloPainter({
    required this.pulsationAnimation,
    this.fadeOutAnimation,
    required this.glowColor,
    required this.bubbleSize,
  }) : super(
            repaint: Listenable.merge([
          pulsationAnimation,
          if (fadeOutAnimation != null) fadeOutAnimation,
        ]));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculer opacité avec fade out si actif
    double baseOpacity = InsectAwakeningConfig.persistentHaloMinOpacity +
        (InsectAwakeningConfig.persistentHaloMaxOpacity -
                InsectAwakeningConfig.persistentHaloMinOpacity) *
            pulsationAnimation.value;

    if (fadeOutAnimation != null) {
      baseOpacity *= (1.0 - fadeOutAnimation!.value);
    }

    // Dessiner halo circulaire principal
    final paint = Paint()
      ..color = glowColor.withOpacity(baseOpacity * 0.6)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        InsectAwakeningConfig.persistentHaloBlurRadius,
      );

    // Cercle principal
    canvas.drawCircle(
      center,
      bubbleSize.width * 0.4, // Rayon proportionnel à la bulle
      paint,
    );

    // Cercle intérieur plus lumineux
    paint.color = glowColor.withOpacity(baseOpacity * 0.3);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);
    canvas.drawCircle(
      center,
      bubbleSize.width * 0.25,
      paint,
    );

    // Cercle central très subtil
    paint.color = glowColor.withOpacity(baseOpacity * 0.1);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawCircle(
      center,
      bubbleSize.width * 0.15,
      paint,
    );
  }

  @override
  bool shouldRepaint(InsectPersistentHaloPainter oldDelegate) {
    return oldDelegate.pulsationAnimation.value != pulsationAnimation.value ||
        oldDelegate.fadeOutAnimation?.value != fadeOutAnimation?.value ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.bubbleSize != bubbleSize;
  }
}


