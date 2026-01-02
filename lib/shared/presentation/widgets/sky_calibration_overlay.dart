import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/sky_calibration_config.dart';
import '../../../core/models/calibration_state.dart';

class SkyCalibrationOverlay extends ConsumerStatefulWidget {
  const SkyCalibrationOverlay({super.key});

  @override
  ConsumerState<SkyCalibrationOverlay> createState() =>
      _SkyCalibrationOverlayState();
}

class _SkyCalibrationOverlayState extends ConsumerState<SkyCalibrationOverlay> {
  // Local state for smooth interaction?
  // We can write directly to provider if performance allows (usually fine for 60fps config update).

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(skyCalibrationProvider);
    final notifier = ref.read(skyCalibrationProvider.notifier);

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;

      if (w == 0 || h == 0) return const SizedBox();

      final cxPixels = config.cx * w;
      final cyPixels = config.cy * h;
      final rxPixels = config.rx * w;
      final ryPixels = config.ry * h;

      // Handles size
      const handleSize = 24.0;

      // Rotated points extraction
      Offset toScreen(double localX, double localY) {
        // Local to Ellipse Center
        // Apply Rotation
        final cosR = math.cos(config.rotation);
        final sinR = math.sin(config.rotation);

        final rotX = localX * cosR - localY * sinR;
        final rotY = localX * sinR + localY * cosR;

        return Offset(cxPixels + rotX, cyPixels + rotY);
      }

      // Points of interest
      final center = Offset(cxPixels, cyPixels);
      final rightHandle = toScreen(rxPixels, 0);
      final bottomHandle = toScreen(0, ryPixels);
      final topHandle =
          toScreen(0, -ryPixels - 40); // Rotation handle slightly above

      return Stack(
        fit: StackFit.expand,
        children: [
          // 1. Darken Background
          Container(color: Colors.black54),

          // 2. Guide Lines
          CustomPaint(
            painter: _CalibrationGuidePainter(
                cx: cxPixels,
                cy: cyPixels,
                rx: rxPixels,
                ry: ryPixels,
                rotation: config.rotation),
            size: Size.infinite,
          ),

          // 3. Center Handle (Move)
          Positioned(
            left: center.dx - handleSize,
            top: center.dy - handleSize,
            child: GestureDetector(
              onPanUpdate: (details) {
                final dx = details.delta.dx / w;
                final dy = details.delta.dy / h;
                notifier.updatePartial(cx: config.cx + dx, cy: config.cy + dy);
              },
              child: _Handle(icon: Icons.open_with, color: Colors.white),
            ),
          ),

          // 4. Right Handle (Resize Radius X)
          Positioned(
            left: rightHandle.dx - handleSize / 2,
            top: rightHandle.dy - handleSize / 2,
            child: GestureDetector(
              onPanUpdate: (details) {
                // Project delta onto the rotation axis
                final cosR = math.cos(config.rotation);
                final sinR = math.sin(config.rotation);
                // Local delta X
                final localDx =
                    (details.delta.dx * cosR + details.delta.dy * sinR);
                notifier.updatePartial(
                    rx: (config.rx + localDx / w).clamp(0.01, 1.0));
              },
              child: _Handle(icon: Icons.code, color: Colors.blueAccent),
            ),
          ),

          // 5. Bottom Handle (Resize Radius Y)
          Positioned(
            left: bottomHandle.dx - handleSize / 2,
            top: bottomHandle.dy - handleSize / 2,
            child: GestureDetector(
              onPanUpdate: (details) {
                // Project delta onto the rotation axis Y
                final cosR = math.cos(config.rotation);
                final sinR = math.sin(config.rotation);
                // Local delta Y (X is sin, Y is cos)
                // Rotation matrix: x' = x cos - y sin, y' = x sin + y cos
                // Inverse: x = x' cos + y' sin, y = -x' sin + y' cos
                final localDy =
                    (-details.delta.dx * sinR + details.delta.dy * cosR);
                notifier.updatePartial(
                    ry: (config.ry + localDy / h).clamp(0.01, 1.0));
              },
              child: _Handle(icon: Icons.height, color: Colors.greenAccent),
            ),
          ),

          // 6. Top Handle (Rotation)
          Positioned(
            left: topHandle.dx - handleSize / 2,
            top: topHandle.dy - handleSize / 2,
            child: GestureDetector(
              onPanUpdate: (details) {
                // Calculate angle from center to touch
                // We don't use delta, we use absolute position for robust rotation?
                // No, simple delta on tangential:
                // Just simpler: compute angle of touch relative to center
                // But here we have drag events.
                // Let's use simple logic: drag right = rotate CW?
                notifier.updatePartial(
                    rotation: config.rotation + details.delta.dx * 0.01);
              },
              child:
                  _Handle(icon: Icons.rotate_right, color: Colors.orangeAccent),
            ),
          ),

          // 7. Close / Save Button
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton.small(
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
              onPressed: () {
                ref
                    .read(calibrationStateProvider.notifier)
                    .disableCalibration();
              },
            ),
          ),

          // Instructions
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              "Ajustez l'ovoïde du ciel\nCentre (Blanc) • Largeur (Bleu) • Hauteur (Vert) • Rotation (Orange)",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black)]),
            ),
          )
        ],
      );
    });
  }
}

class _Handle extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _Handle({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
      ),
      child: Icon(icon, size: 16, color: Colors.black87),
    );
  }
}

class _CalibrationGuidePainter extends CustomPainter {
  final double cx, cy, rx, ry, rotation;
  _CalibrationGuidePainter(
      {required this.cx,
      required this.cy,
      required this.rx,
      required this.ry,
      required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // drawoval
    canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
        paint);

    // cross
    paint.strokeWidth = 0.5;
    // paint.pathEffect = null; // Removed as it causes build error and is not needed if we re-configure paint or use new paint
    canvas.drawLine(Offset(-rx, 0), Offset(rx, 0), paint);
    canvas.drawLine(Offset(0, -ry), Offset(0, ry), paint);

    // rotation line
    paint.color = Colors.orangeAccent;
    canvas.drawLine(Offset(0, -ry), Offset(0, -ry - 40), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CalibrationGuidePainter old) => true;
}

// Pseudo DashPathEffect if not available in dart:ui directly (it is not in basic paint, usually needs Path)
// But canvas.drawEffect is not standard. Usually we use metrics.
// For simplicity we skip DashPathEffect implementation or assume it exists in some helper.
// Wait, DashPathEffect is in dart:ui? No it's not.
// We will just draw plain line for now to avoid compilation error.
