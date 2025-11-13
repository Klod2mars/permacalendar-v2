ï»¿import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'insect_animation_config.dart';

/// Custom painter pour dessiner les particules lumineuses en spirale
/// Mission A39-2 : Rendu optimisÃƒÂ© des 12 particules avec effet de cascade
class InsectParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color particleColor;
  final Size bubbleSize;

  InsectParticlesPainter({
    required this.animation,
    required this.particleColor,
    required this.bubbleSize,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    if (progress == 0.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal, InsectAwakeningConfig.blurIntensity);

    // Calculer la phase actuelle de l'animation
    final phase = _getCurrentPhase(progress);

    // Dessiner chaque particule
    for (int i = 0; i < InsectAwakeningConfig.particleCount; i++) {
      final particleProgress = _getParticleProgress(progress, i);
      if (particleProgress <= 0.0) continue;

      // Calculer la position en spirale
      final angle = _calculateAngle(i, progress);
      final radius = _calculateRadius(progress, phase);
      final offset = _calculateOffset(center, angle, radius);

      // Calculer les propriÃƒÂ©tÃƒÂ©s visuelles
      final opacity = _calculateOpacity(progress, particleProgress, phase);
      final particleSize = _calculateSize(progress, phase);

      // Appliquer les propriÃƒÂ©tÃƒÂ©s au paint
      paint.color = particleColor.withOpacity(opacity);

      // Dessiner la particule
      canvas.drawCircle(offset, particleSize, paint);
    }
  }

  /// DÃƒÂ©termine la phase actuelle de l'animation selon le progrÃƒÂ¨s
  InsectAnimationPhase _getCurrentPhase(double progress) {
    if (progress < InsectAnimationPhase.eveil.endProgress) {
      return InsectAnimationPhase.eveil;
    } else if (progress < InsectAnimationPhase.expansion.endProgress) {
      return InsectAnimationPhase.expansion;
    } else if (progress < InsectAnimationPhase.pollinisation.endProgress) {
      return InsectAnimationPhase.pollinisation;
    } else {
      return InsectAnimationPhase.dissipation;
    }
  }

  /// Calcule le progrÃƒÂ¨s individuel de chaque particule avec effet de cascade
  double _getParticleProgress(double globalProgress, int particleIndex) {
    // DÃƒÂ©lai progressif pour effet cascade (0.2 = 20% de l'animation)
    final delay = (particleIndex / InsectAwakeningConfig.particleCount) *
        InsectAwakeningConfig.particleDelayFactor;
    return math.max(0.0, globalProgress - delay);
  }

  /// Calcule l'angle de position de la particule dans la spirale
  double _calculateAngle(int particleIndex, double progress) {
    // Angle de base selon l'index de la particule
    final baseAngle =
        (particleIndex / InsectAwakeningConfig.particleCount) * 2 * math.pi;

    // Rotation supplÃƒÂ©mentaire selon le progrÃƒÂ¨s de l'animation
    final rotationAngle =
        progress * InsectAwakeningConfig.spiralTurns * 2 * math.pi;

    return baseAngle + rotationAngle;
  }

  /// Calcule le rayon de position selon la phase et le progrÃƒÂ¨s
  double _calculateRadius(double progress, InsectAnimationPhase phase) {
    final phaseProgress = phase.getPhaseProgress(progress);

    switch (phase) {
      case InsectAnimationPhase.eveil:
        // Expansion de 0 ÃƒÂ  20% du rayon maximum
        return InsectAwakeningConfig.expansionRadius *
            0.2 *
            InsectAwakeningConfig.eveilCurve.transform(phaseProgress);

      case InsectAnimationPhase.expansion:
        // Expansion de 20% ÃƒÂ  100% du rayon maximum
        return InsectAwakeningConfig.expansionRadius *
            (0.2 +
                0.8 *
                    InsectAwakeningConfig.expansionCurve
                        .transform(phaseProgress));

      case InsectAnimationPhase.pollinisation:
        // Maintien du rayon maximum avec lÃƒÂ©gÃƒÂ¨re oscillation
        return InsectAwakeningConfig.expansionRadius *
            (1.0 + 0.1 * math.sin(phaseProgress * math.pi * 4));

      case InsectAnimationPhase.dissipation:
        // Maintien du rayon maximum pendant la dissipation
        return InsectAwakeningConfig.expansionRadius;

      default:
        return 0.0;
    }
  }

  /// Calcule la position finale de la particule
  Offset _calculateOffset(Offset center, double angle, double radius) {
    return Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
  }

  /// Calcule l'opacitÃƒÂ© de la particule selon la phase
  double _calculateOpacity(
      double progress, double particleProgress, InsectAnimationPhase phase) {
    if (phase == InsectAnimationPhase.dissipation) {
      // Fade out progressif pendant la dissipation
      final phaseProgress = phase.getPhaseProgress(progress);
      return InsectAwakeningConfig.particleOpacity *
          (1.0 -
              InsectAwakeningConfig.dissipationCurve.transform(phaseProgress));
    }

    // OpacitÃƒÂ© basÃƒÂ©e sur le progrÃƒÂ¨s de la particule individuelle
    return InsectAwakeningConfig.particleOpacity * particleProgress;
  }

  /// Calcule la taille de la particule selon la phase
  double _calculateSize(double progress, InsectAnimationPhase phase) {
    if (phase == InsectAnimationPhase.pollinisation) {
      // Pulsation lÃƒÂ©gÃƒÂ¨re pendant la pollinisation
      final phaseProgress = phase.getPhaseProgress(progress);
      final pulsation = math.sin(phaseProgress *
              math.pi *
              InsectAwakeningConfig.pulsationFrequency) *
          InsectAwakeningConfig.pulsationAmplitude;
      return InsectAwakeningConfig.particleSize * (1.0 + pulsation);
    }

    // Taille normale pour les autres phases
    return InsectAwakeningConfig.particleSize;
  }

  @override
  bool shouldRepaint(InsectParticlesPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value ||
        oldDelegate.particleColor != particleColor ||
        oldDelegate.bubbleSize != bubbleSize;
  }
}



