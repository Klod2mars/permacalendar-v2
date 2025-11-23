// lib/shared/widgets/animations/insect_persistent_halo_painter.dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'insect_animation_config.dart';

/// Painter pour le halo persistant des jardins actifs
/// Version "visible" : radial gradient + blur, pulsation + fadeOut support
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
          ]),
        );

  @override
  void paint(Canvas canvas, Size size) {
    // Sécurité : si pas de taille utile, rien à faire
    if (bubbleSize.width <= 0 || bubbleSize.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);

    // Calculer baseOpacity selon la pulsation mais garantir une valeur minimale visible
    double minOp = InsectAwakeningConfig.persistentHaloMinOpacity ??
        0.10; // fallback si non défini
    double maxOp = InsectAwakeningConfig.persistentHaloMaxOpacity ??
        0.65; // fallback si non défini

    // Défaut prudent si les constantes sont null (assume elles existent normalement)
    minOp = minOp.clamp(0.0, 1.0);
    maxOp = maxOp.clamp(0.0, 1.0);

    // valeur pulsée
    double baseOpacity = minOp + (maxOp - minOp) * pulsationAnimation.value;

    // garantir visibilité minimale pour test (on peut réduire ensuite)
    baseOpacity = baseOpacity.clamp(0.18, 1.0);

    // appliquer fadeOut si présent
    if (fadeOutAnimation != null) {
      baseOpacity *= (1.0 - fadeOutAnimation!.value).clamp(0.0, 1.0);
    }

    // Taille du halo proportionnelle à la bulle (empirique, ajustable)
    final radius =
        (bubbleSize.width / 2.0) * 1.05; // un peu plus grand que la bulle
    final innerRadius = radius * 0.45;
    final midRadius = radius * 0.7;

    // Construire un gradient radial pour une lueur douce et contrôlable
    final stops = <double>[0.0, innerRadius / radius, midRadius / radius, 1.0];
    final colors = <Color>[
      glowColor.withOpacity((baseOpacity).clamp(0.0, 1.0)), // centre vif
      glowColor.withOpacity((baseOpacity * 0.7).clamp(0.0, 1.0)),
      glowColor.withOpacity((baseOpacity * 0.35).clamp(0.0, 1.0)),
      Colors.transparent,
    ];

    final shader = ui.Gradient.radial(
      center,
      radius,
      colors,
      stops,
      ui.TileMode.clamp,
    );

    final paint = Paint()
      ..shader = shader
      // ajouter un maskFilter blur pour adoucir l'extérieur
      ..maskFilter = MaskFilter.blur(BlurStyle.normal,
          InsectAwakeningConfig.persistentHaloBlurRadius ?? 18.0)
      ..isAntiAlias = true
      ..blendMode = BlendMode.screen;

    // Dessiner le halo via un cercle (le shader s'en occupe)
    canvas.drawCircle(center, radius, paint);

    // Optionnel : dessiner un anneau intérieur lumineux pour accentuer
    final innerPaint = Paint()
      ..color = glowColor.withOpacity((baseOpacity * 0.9).clamp(0.0, 1.0))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0)
      ..isAntiAlias = true
      ..blendMode = BlendMode.screen;

    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(InsectPersistentHaloPainter oldDelegate) {
    return oldDelegate.pulsationAnimation.value != pulsationAnimation.value ||
        oldDelegate.fadeOutAnimation?.value != fadeOutAnimation?.value ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.bubbleSize != bubbleSize;
  }
}
