import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Un painter qui imite l'esthétique "Organic Glass" du dashboard.
/// - Volume 3D (Ombre interne + lumière)
/// - Contour "Rim Light"
/// - Reflet spéculaire (Gloss)
class OrganicGlassBubblePainter extends CustomPainter {
  final double glossary; // 0.0 - 1.0 (intensité du reflet)

  OrganicGlassBubblePainter({this.glossary = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;

    // 1. FOND PRINCIPAL (Corps de la bulle)
    // Sombre mais avec une teinte verte très profonde
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 0.0),
        radius: 0.9,
        colors: [
          const Color(0xFF1E3324).withOpacity(0.5), // Vert très sombre au centre
          const Color(0xFF050906).withOpacity(0.95), // Quasi noir sur les bords
        ],
        stops: const [0.0, 1.0],
      ).createShader(rect);

    canvas.drawCircle(center, radius, bodyPaint);

    // 2. VOLUME / OMBRE INTERNE (Bas-Droit)
    // Renforce l'effet sphérique en assombrissant le bas
    final shadowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.6, 0.6), // Vers le bas droite
        radius: 0.8,
        colors: [
           const Color(0xFF000000).withOpacity(0.0),
           const Color(0xFF000000).withOpacity(0.8),
        ],
      ).createShader(rect);
    
    // On dessine l'ombre sur la moitié inférieure via un clip ou juste par dessus
    canvas.drawCircle(center, radius, shadowPaint);

    // 3. RIM LIGHT (Contour lumineux subtil)
    // Surtout en haut à gauche (source de lumière) et un peu en bas (réflexion sol)
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: math.pi * 2,
        colors: [
          Colors.white.withOpacity(0.05), // Droit -> faible
          Colors.white.withOpacity(0.1), // Bas -> réflexion sol
          Colors.white.withOpacity(0.05), // Gauche -> faible
          Colors.white.withOpacity(0.4), // Haut -> LUMIÈRE FORTE
          Colors.white.withOpacity(0.05), // Retour
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        transform: const GradientRotation(math.pi / 4), // Rotation pour aligner lumière Haut-Gauche
      ).createShader(rect);

    canvas.drawCircle(center, radius, rimPaint);

    // 4. SPECULAR HIGHLIGHT (Reflet brillant)
    // Ovale blanc flouté en haut à gauche
    _drawConstructedHighlight(canvas, center, radius);
  }

  void _drawConstructedHighlight(Canvas canvas, Offset center, double radius) {
    // Position du reflet : Haut-Gauche
    final highlightCenter = center + Offset(-radius * 0.4, -radius * 0.45);
    final highlightSize = Size(radius * 0.7, radius * 0.45);

    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.35 * glossary),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCenter(
        center: highlightCenter, 
        width: highlightSize.width, 
        height: highlightSize.height
      ));
    
    // Forme organique (patatoïde) pour le reflet
    final path = Path()
      ..addOval(Rect.fromCenter(
          center: highlightCenter,
          width: highlightSize.width,
          height: highlightSize.height));
    
    // Rotation pour suivre la courbure
    canvas.save();
    canvas.translate(highlightCenter.dx, highlightCenter.dy);
    canvas.rotate(-math.pi / 4);
    canvas.translate(-highlightCenter.dx, -highlightCenter.dy);
    
    canvas.drawPath(path, highlightPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OrganicGlassBubblePainter oldDelegate) => false;
}
