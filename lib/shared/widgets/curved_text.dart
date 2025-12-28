import 'dart:math' as math;
import 'package:flutter/material.dart';

class CurvedText extends StatelessWidget {
  const CurvedText({
    super.key,
    required this.text,
    required this.textStyle,
    this.radius = 50.0,
    this.startAngle = 0.0,
    this.placement = CurvedTextPlacement.top,
  });

  final String text;
  final TextStyle textStyle;
  final double radius;
  final double startAngle;
  final CurvedTextPlacement placement;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedTextPainter(
        text: text,
        textStyle: textStyle,
        radius: radius,
        startAngle: startAngle,
        placement: placement,
      ),
      size: Size.fromRadius(radius), // Approximate size
    );
  }
}

enum CurvedTextPlacement {
  top, // Arch (curve down / convex) - text is upright at top
  bottom, // Smile (curve up / concave) - text is upright at bottom
}

class _CurvedTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final double radius;
  final double startAngle;
  final CurvedTextPlacement placement;

  _CurvedTextPainter({
    required this.text,
    required this.textStyle,
    required this.radius,
    required this.startAngle,
    required this.placement,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    // Calculate total sweep angle for the text
    // We need to measure each character width to position them correctly along the arc.
    // However, a simple approximation is to measure the full text and divide by circumference,
    // but drawing per-character is safer for rotation.

    // 1. Measure all characters
    double totalArcLength = 0;
    List<double> charWidths = [];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var i = 0; i < text.length; i++) {
        textPainter.text = TextSpan(text: text[i], style: textStyle);
        textPainter.layout();
        charWidths.add(textPainter.width);
        totalArcLength += textPainter.width;
    }

    // Add some spacing? Letter spacing is already in TextStyle if provided.
    
    // 2. Centralize the text around -PI/2 (top) or PI/2 (bottom)
    // For Top placement: Center is at -90 degrees (-pi/2)
    // For Bottom placement: Center is at +90 degrees (+pi/2)
    
    final double circum = 2 * math.pi * radius;
    // Angle covered by text
    final double totalAngle = (totalArcLength / circum) * 2 * math.pi; // s = r*theta => theta = s/r

    double currentAngle = 0.0;

    if (placement == CurvedTextPlacement.top) {
        // Start angle: -PI/2 - (half of total angle)
        currentAngle = -math.pi / 2 - (totalAngle / 2) + startAngle;
    } else {
        // Bottom: PI/2 - (half of total angle)
        // Note: For bottom text to be readable (not upside down), we draw it on the inside of the circle?
        // Or outside? Usually outside but rotated.
        // Let's assume standard "Badge" style:
        // Top text curves over. Bottom text curves under but letters are upright.
        currentAngle = math.pi / 2 - (totalAngle / 2) + startAngle;
    }

    // 3. Draw characters
    for (var i = 0; i < text.length; i++) {
        final char = text[i];
        final w = charWidths[i];
        
        // The angle for this character's center
        // Arc length for this char is w. Angle = w / r.
        final charAngle = w / radius;
        
        // We position the character at the center of its slice
        final drawAngle = currentAngle + (charAngle / 2);

        canvas.save();
        
        if (placement == CurvedTextPlacement.top) {
             // Rotate to position
             canvas.rotate(drawAngle + math.pi / 2); 
             // Move out to radius
             canvas.translate(0, -radius);
             // Move back half char width to center text paint
             canvas.translate(-w / 2, 0);
        } else {
             // For bottom text, to appear upright:
             // We need to rotate such that the baseline is inwards.
             // Angle is around PI/2.
             canvas.rotate(drawAngle - math.pi / 2);
             canvas.translate(0, radius);
              canvas.translate(-w / 2, 0);
        }

        textPainter.text = TextSpan(text: char, style: textStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset.zero);

        canvas.restore();
        
        currentAngle += charAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
