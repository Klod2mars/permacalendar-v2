// lib/shared/widgets/active_garden_aura.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ActiveGardenAura extends StatefulWidget {
  const ActiveGardenAura({
    super.key,
    this.size = 100.0,
    this.color,
    this.isActive = true,
  });

  final double size;
  final Color? color;
  final bool isActive;

  @override
  State<ActiveGardenAura> createState() => _ActiveGardenAuraState();
}

class _ActiveGardenAuraState extends State<ActiveGardenAura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500), // Speed up (was 6000)
    );
    if (widget.isActive) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(covariant ActiveGardenAura old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.isActive && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final disableAnimations = mq.disableAnimations || mq.accessibleNavigation;
    // Use a brighter white/green by default for better contrast
    final color = widget.color ?? const Color(0xFFFFFFFF); 

    if (disableAnimations) {
      return CustomPaint(
        painter: _OrganicCloudPainter(
          progress: 0.0,
          color: color,
          staticMode: true,
        ),
        size: Size(widget.size, widget.size),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return CustomPaint(
            painter: _OrganicCloudPainter(
              progress: _ctrl.value,
              color: color,
              staticMode: false,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

class _OrganicCloudPainter extends CustomPainter {
  _OrganicCloudPainter({
    required this.progress,
    required this.color,
    this.staticMode = false,
  });

  final double progress;
  final Color color;
  final bool staticMode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.5;

    // Increased opacity for better visibility
    final paint = Paint()
      ..color = color.withAlpha(100) // Was 25 -> significantly boosted
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0); // Slightly sharper blur

    if (staticMode) {
      // Stronger static indicator
      canvas.drawCircle(center, radius * 1.1, paint..color = color.withAlpha(150));
      return;
    }

    // 5 blobs with higher opacity logic
    final count = 5;
    for (int i = 0; i < count; i++) {
      final t = (progress + i / count) * 2 * math.pi;
      
      final offset1 = Offset(
        math.cos(t) * radius * 0.25, // Widen orbit slightly
        math.sin(t) * radius * 0.25,
      );
      
      final blobRadius = radius * (0.85 + 0.15 * math.sin(t * 2.0));
      
      // Dynamic opacity: 80..140 range (much higher than 20..30)
      paint.color = color.withAlpha(80 + (60 * math.sin(t)).toInt().abs());
      canvas.drawCircle(center + offset1, blobRadius, paint);
    }
    
    // Core glow - stronger
    final corePaint = Paint()
      ..color = color.withAlpha(120)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25.0);
      
    canvas.drawCircle(center, radius * 0.9, corePaint);

    // Inner distinct ring (optional, but helps define it if background is chaotic)
    // Subtle white stroke
    final ringPaint = Paint()
      ..color = color.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
      
    canvas.drawCircle(center, radius * 1.15, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _OrganicCloudPainter old) {
    return old.progress != progress || old.color != color || old.staticMode != staticMode;
  }
}
