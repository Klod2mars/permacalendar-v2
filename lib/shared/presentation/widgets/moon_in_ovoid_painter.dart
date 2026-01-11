import 'package:flutter/material.dart';
import 'dart:math' as math;

class MoonInOvoidPainter extends CustomPainter {
  final double phase; // 0..1 (Open-Meteo)
  final Rect ovalRect; // bounds of the ovoid in absolute coordinates (or derived)
  final Offset animOffset; // small offset for micro-motion
  final double darkness; // 0..1, how dark the night is (optional)

  MoonInOvoidPainter({
    required this.phase,
    required this.ovalRect,
    required this.animOffset,
    required this.darkness,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    if (phase < 0.02 || phase > 0.98) return; // New Moon invisible

    final center = Offset(
            ovalRect.center.dx + ovalRect.width * 0.22,
            ovalRect.center.dy - ovalRect.height * 0.18) +
        animOffset;

    final r =
        (ovalRect.width < ovalRect.height ? ovalRect.width : ovalRect.height) *
            0.12 /
            2;

    // Illumination intensity (0.0 to 1.0) for opacity/glow
    // Full moon (0.5) -> 1.0, New moon (0.0/1.0) -> 0.0
    double illumIntensity =
        1.0 - (2.0 * (phase - 0.5).abs()); // Linear map 0.5->1, 0/1->0

    // Visibility based on darkness
    final opacity = (0.6 + 0.4 * illumIntensity) * darkness.clamp(0.0, 1.0);
    final baseColor = const Color(0xFFF1F6FF).withOpacity(opacity);

    final paint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    // --- PHASE LOGIC (Elliptical Terminator) ---
    // Phase 0..1 from Open-Meteo:
    // 0 = New, 0.25 = First Q, 0.5 = Full, 0.75 = Last Q, 1 = New.
    // Waxing: 0 to 0.5 (Lit on Right for N.Hemi? Actually depends on lat but let's assume standard icon view)
    // Standard icon: Waxing = Right side lit (D shape). Waning = Left side lit (C shape).

    final isWaxing = phase <= 0.5;
    final isGibbous = (phase > 0.25 && phase < 0.75);

    // We build the path for the Lit part
    final moonPath = Path();

    // 1. Draw the "Outer" semi-circle arc
    // If Waxing (0..0.5), right side is lit -> Draw Right Semi-Circle (Top to Bottom)
    // If Waning (0.5..1), left side is lit -> Draw Left Semi-Circle (Bottom to Top)
    
    if (isWaxing) {
      // Lit on Right
      moonPath.addArc(Rect.fromCircle(center: center, radius: r), -math.pi / 2, math.pi);
    } else {
      // Lit on Left
      moonPath.addArc(Rect.fromCircle(center: center, radius: r), math.pi / 2, math.pi);
    }

    // 2. Draw the "Terminator" (Inner edge)
    // This is a semi-ellipse connecting the two poles.
    // The width of this ellipse depends on phase progress.
    // Progress p goes from 0 (Quarter) to 1 (Full) to 0 (Quarter).
    
    // Normalize phase for ellipse width:
    // We want a factor that goes:
    // 0.0 (New) -> ellipse width = -R (Concave)
    // 0.25 (Quarter) -> ellipse width = 0 (Flat)
    // 0.5 (Full) -> ellipse width = +R (Convex, Full Circle)
    // But we are drawing half-moon base.
    
    // Easier approach with set operations:
    // Calculate the 'bulge' width [-r to r]
    // cos(2*pi*phase) ? 
    // New (0) -> 1. Full (0.5) -> -1. 
    // Quarter (0.25) -> 0.
    
    // Bulge offset X from center.
    final bulgeUser = -math.cos(phase * 2 * math.pi) * r;

    // We always close the path back to starting point with a semi-ellipse.
    // But [addOval] isn't suitable, we need curves.
    // We can use scaling transformation on a semi-circle path?
    
    // Constructing exact path:
    // Left pole (cx - r, cy), Right pole (cx + r, cy)? No, North/South poles: (cx, cy-r), (cx, cy+r).
    
    // Let's stick to the "Add/Subtract" Shapes composition, simpler to read.
    // Base: Semi-Circle (Lit Side).
    // Addition/Subtraction: Semi-Ellipse on the other side.
    
    Path baseSemi = Path();
    if (isWaxing) {
      // Right semi-circle
      baseSemi.addArc(Rect.fromCircle(center: center, radius: r), -math.pi / 2, math.pi);
    } else {
      // Left semi-circle
      baseSemi.addArc(Rect.fromCircle(center: center, radius: r), math.pi / 2, math.pi);
    }

    // Ellipse part
    // Width abs(bulge). Sign determines if we add or mask.
    // If Waxing:
    //   0..0.25 (Crescent): Bulge is negative (on Left). We must SUBTRACT this "hole" from the semi-circle? 
    //      No, the base semi-circle covers 0 to R. The dark part is -R to 0.
    //      Actually, for crescent, we see a sliver on right. 
    //      Bulge is near 0.
    //      Let's allow Path.combine to handle it.
    
    // Simplified Geometry:
    // Create a path composed of two arcs.
    // Arc 1: Semi-circle of radius R.
    // Arc 2: Semi-ellipse of radius (W, R).
    
    // We draw the final moon shape manually:
    final path = Path();
    
    // Start at North Pole
    path.moveTo(center.dx, center.dy - r);
    
    // Outer Arc (Always R)
    if (isWaxing) {
      // Right side arc to South Pole
      path.arcToPoint(Offset(center.dx, center.dy + r), radius: Radius.circular(r), clockwise: true);
    } else {
      // Left side arc to South Pole
      path.arcToPoint(Offset(center.dx, center.dy + r), radius: Radius.circular(r), clockwise: false);
    }
    
    // Terminator Arc (Ellipse width W) back to North Pole
    // Use quadratic or conic? Conic is better for ellipse.
    // Or just simple cubic.
    // Width W varies:
    // At Full Moon (0.5), W = R (bulge opposite to outer arc -> Full circle).
    // At Quarter (0.25), W = 0 (Straight line).
    // At New (0), W = -R (bulge same as outer arc -> Empty).
    
    // Calculate terminator control X
    // For Waxing:
    // Outer is Right. Inner goes from Bottom to Top.
    // If Gibbous (0.3), Inner bulges Left.
    // If Crescent (0.1), Inner bulges Right.
    
    // Map phase to simple width factor relative to center for the 'bulge'
    // 0.0 -> +R (Matches outer right arc, result empty... wait? no)
    // Let's use cosine directly.
    // width = -R * cos(2*pi*phase)
    
    // 0.00 -> -R * 1 = -R. 
    // 0.25 -> -R * 0 = 0.
    // 0.50 -> -R * -1 = +R.
    
    final w = -r * math.cos(2 * math.pi * phase);
    
    // We need to draw semi-ellipse from (0, r) to (0, -r) (relative).
    // From South Pole to North Pole.
    
    // Using arcTo with oval rect is best if it's a true ellipse.
    // Rect for ellipse: Center at 'center', Width = 2*|w|, Height = 2*r.
    var rectWidth = w.abs() * 2;
    if (rectWidth < 0.1) rectWidth = 0.1; // Avoid zero div
    
    final ellipseRect = Rect.fromCenter(center: center, width: rectWidth, height: r * 2);
    
    // Direction calculation
    // We are at South Pole (bottom). We want to go to North Pole (top).
    // If w > 0 (Bulge Right), we go clockwise (left side of ellipse? No).
    // Standard Draw direction:
    // Waxing (Outer Right):
    //   Terminator moves South -> North.
    //   If w > 0 (Gibbous, bulge Left), we want left side of ellipse.
    //   If w < 0 (Crescent, bulge Right), we want right side of ellipse?
    
    // Let's define it simply:
    // The terminator x-coordinates follow the ellipse x = w * sin(t)?
    
    // Let's use simple bezier approximation for semi-ellipse.
    // Control point offset should be approx 4/3 * w? No, 1.33 for circle.
    // Yes, K = 0.55228 for quarter circle. For semi-circle/ellipse, handle at approx 1.33 * semi-axis?
    // Let's use an arbitrary factor that looks good. 
    
    final cpX = center.dx - (w * 1.33); // why minus? Coordinate system logic.
    // If W is positive (towards left for Quarter logic?), wait.
    
    // Let's rely on cosine 'w' calculated above: 
    // 0.25 (Quarter) -> w = 0. 
    // Waxing (Right lit): Outer Right.
    // Terminator is straight line. cpX = center.
    // 0.5 (Full) -> w = +R.
    // Waxing Gibbous. Terminator bulges Left.
    // so we need X to go Left.
    // So 'w' should be positive towards Left.
    // math.cos(pi) = -1. So if phase=0.5, w = -R*(-1) = R.
    // If coordinate system X+ is Right. R is positive.
    // We want bulge to Left (X-). So we want -R.
    // So we need negative sign?
    
    // Let's use a simpler heuristic that works:
    // Just draw the ellipse path separately and use combine.
    
    final terminatorPath = Path();
    terminatorPath.addOval(Rect.fromCenter(center: center, width: w.abs() * 2, height: r * 2));
    
    // Determine the side of the ellipse to use
    // If phase < 0.5 (Waxing):
    //    Outer is Right Semi.
    //    If phase < 0.25 (Crescent): Terminator is Right Semi-Ellipse.
    //       Result = Outer - Terminator? No. 
    //       Geometric Intersection (Outer, Terminator)?
    //    If phase > 0.25 (Gibbous): Terminator is Left Semi-Ellipse.
    //       Result = Outer + Terminator.
    
    // Set Operations Logic works best here.
    Path result;
    
    if (isWaxing) {
        // Base is Right Semi-Circle
        Path rightSemi = Path()..addArc(Rect.fromCircle(center: center, radius: r), -math.pi/2, math.pi);
        
        if (phase < 0.25) { 
            // Crescent: Intersection of Right Semi and Ellipse? 
            // Ellipse is thin on right.
            // RightSemi covers 0..R. Ellipse covers 0..w.
            // Result is 0..w? No, w..R?
            // Correct shape involves removing the "dark" ellipse part.
            // Actually for Crescent: Lit part is (w to R).
            // w is positive (calculated above? no cos(0)=1 -> w=-R).
            // Let's rethink variables.
            
            // Re-calc: bulge W relative to center X=0.
            // Full Moon (0.5): W should be -R (Left). Lit is (-R to R).
            // New Moon (0.0): W should be +R (Right). Lit is (+R to R) = Empty.
            // Quarter (0.25): W should be 0. Lit is (0 to R).
            
            final boundaryX = -r * math.cos(2 * math.pi * phase);
            
            // Base Right Semicircle
            Path base = Path()..addArc(Rect.fromCircle(center: center, radius: r), -math.pi/2, math.pi);
            
            // Correction Ellipse
            Path ellipse = Path()..addOval(Rect.fromCenter(center: center, width: boundaryX.abs()*2, height: r*2));
            
            if (phase < 0.25) {
                 // Crescent: Subtract the ellipse from the semicircle
                 result = Path.combine(PathOperation.difference, base, ellipse);
            } else {
                 // Gibbous: Add the ellipse to the semicircle
                 result = Path.combine(PathOperation.union, base, ellipse);
            }
            
        } else {
            // Gibbous phase > 0.25
             final boundaryX = -r * math.cos(2 * math.pi * phase);
             // Logic is same: if abs(boundary) grows left, we union.
             Path base = Path()..addArc(Rect.fromCircle(center: center, radius: r), -math.pi/2, math.pi);
             Path ellipse = Path()..addOval(Rect.fromCenter(center: center, width: boundaryX.abs()*2, height: r*2));
             result = Path.combine(PathOperation.union, base, ellipse);
        }
    } else {
        // Waning - Lit Left (90 to 270 deg)
         Path base = Path()..addArc(Rect.fromCircle(center: center, radius: r), math.pi/2, math.pi);
         
         // 0.5 (Full) -> 0.75 (Quarter) -> 1.0 (New)
         // Full: bulge right (+R). Quarter: 0. New: bulge left (-R).
         // Phase 0.5 -> cos= -1 -> boundary = +R. (Union)
         // Phase 0.75 -> cos=0 -> boundary = 0.
         // Phase 0.9 -> cos > 0 -> boundary = -R ??
         // cos(2pi * 0.9) = cos(1.8pi) = cos(-0.2pi) ~ 1.
         // boundary = -R.
         
         final boundaryX = -r * math.cos(2 * math.pi * phase);
         Path ellipse = Path()..addOval(Rect.fromCenter(center: center, width: boundaryX.abs()*2, height: r*2));

         if (phase < 0.75) {
             // Waning Gibbous (0.5 to 0.75)
             // Union
             result = Path.combine(PathOperation.union, base, ellipse);
         } else {
             // Waning Crescent (0.75 to 1.0)
             // Difference
             result = Path.combine(PathOperation.difference, base, ellipse);
         }
    }
    
    canvas.drawPath(result, paint);
    
    // Optional glow
    if (darkness > 0.5 && illumIntensity > 0.2) {
      final glowPaint = Paint()
        ..color = const Color(0xFFF1F6FF).withOpacity(0.15 * darkness * illumIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(center, r * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MoonInOvoidPainter old) {
    return old.phase != phase ||
        old.animOffset != animOffset ||
        old.darkness != darkness ||
        old.ovalRect != ovalRect;
  }
}
