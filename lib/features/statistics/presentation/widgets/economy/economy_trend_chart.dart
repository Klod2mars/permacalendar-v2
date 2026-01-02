import 'package:flutter/material.dart';
import '../../../domain/models/economy_trend_point.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart' hide TextDirection;

class EconomyTrendChart extends StatelessWidget {
  final List<EconomyTrendPoint> points;
  final double height;
  final Color lineColor;
  final Color gradientStartColor;
  final Color gradientEndColor;

  const EconomyTrendChart({
    super.key,
    required this.points,
    this.height = 200,
    this.lineColor = Colors.greenAccent,
    this.gradientStartColor = Colors.greenAccent,
    this.gradientEndColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'Pas assez de données pour afficher la tendance',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    // Si un seul point, on ne peut pas tracer de ligne, on affiche juste un point ou un message
    if (points.length < 2) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${points.first.value.toStringAsFixed(2)} €',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const Text('Données insuffisantes pour une courbe',
                  style: TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ),
      );
    }

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomPaint(
        size: Size.infinite,
        painter: _TrendPainter(
          points: points,
          lineColor: lineColor,
          gradientStartColor: gradientStartColor.withOpacity(0.3),
          gradientEndColor: gradientEndColor,
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<EconomyTrendPoint> points;
  final Color lineColor;
  final Color gradientStartColor;
  final Color gradientEndColor;

  _TrendPainter({
    required this.points,
    required this.lineColor,
    required this.gradientStartColor,
    required this.gradientEndColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double width = size.width;
    final double height = size.height;

    // 1. Trouver min/max Y pour l'échelle
    double maxY = 0.0;
    double minY = double.infinity;
    for (var p in points) {
      if (p.value > maxY) maxY = p.value;
      if (p.value < minY) minY = p.value;
    }

    // Marge visuelle pour ne pas coller aux bords (en haut et bas)
    if (maxY == 0) maxY = 100; // éviter div/0
    if (maxY == minY) {
      maxY += 10;
      minY -= 10;
    }

    final double rangeY = maxY - minY;
    // On ajoute 20% de marge en haut pour respirer
    final double scaleY = height / (rangeY * 1.2);
    final double offsetY = minY;

    // 2. Construire le path
    final path = Path();
    final fillPath = Path();

    // Echelle X: distribution uniforme des points
    final double stepX = width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final double x = i * stepX;
      // Inverser Y car canvas 0 est en haut.
      // value = minY -> y = height
      // value = maxY -> y = height - (maxY - minY)*scaleY
      // On veut mapping:
      // y = height - (point.value - offsetY) * scaleY
      final double y = height -
          (points[i].value - offsetY) * scaleY -
          (height * 0.1); // petit offset bas pour centrer

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height); // bas gauche
        fillPath.lineTo(x, y);
      } else {
        // Lissage simple (cubic bezier)
        final double prevX = (i - 1) * stepX;
        final double prevY =
            height - (points[i - 1].value - offsetY) * scaleY - (height * 0.1);

        final double midX = (prevX + x) / 2;
        path.cubicTo(midX, prevY, midX, y, x, y);
        fillPath.cubicTo(midX, prevY, midX, y, x, y);
      }

      if (i == points.length - 1) {
        fillPath.lineTo(x, height); // bas droite
        fillPath.close();
      }

      // Points d'intérêts (cercles)
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = lineColor);
      // Fond du cercle (pour "trouer" la ligne si on voulait, ici juste overlay blanc)
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.black);
    }

    // 3. Dessiner gradient fill
    final rect = Rect.fromLTWH(0, 0, width, height);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [gradientStartColor, gradientEndColor],
    );
    final paintFill = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, paintFill);

    // 4. Dessiner la ligne
    canvas.drawPath(path, paintLine);

    // 5. Labels (Min/Max/Dernier) -- optionnel, on le fait simple
    // Juste afficher la date du premier et dernier point en bas
    final textStyle = const TextStyle(color: Colors.white54, fontSize: 10);
    final dateFmt = DateFormat(
        'MMM yyyy', 'fr_FR'); // suppose locale fr dispo, sinon 'MM/yy'

    // Label gauche (start date)
    _drawText(canvas, _formatDate(points.first.date), Offset(0, height + 5),
        textStyle);
    // Label droite (end date)
    _drawText(canvas, _formatDate(points.last.date),
        Offset(width - 30, height + 5), textStyle); // ajuster x
  }

  String _formatDate(DateTime d) {
    return "${d.day}/${d.month}";
  }

  void _drawText(Canvas canvas, String text, Offset pos, TextStyle style) {
    final span = TextSpan(style: style, text: text);
    final painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter old) {
    return old.points != points || old.lineColor != lineColor;
  }
}
