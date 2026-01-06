// lib/shared/widgets/active_garden_aura.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ActiveGardenAura extends StatefulWidget {
  const ActiveGardenAura({
    super.key,
    this.size = 80.0,
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
      duration: const Duration(milliseconds: 2000),
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
    // Respect reduced motion / accessibility
    final mq = MediaQuery.of(context);
    final disableAnimations = mq.disableAnimations || mq.accessibleNavigation;
    final color = widget.color ?? const Color(0xFF7BC26A); // doux vert

    if (disableAnimations) {
      // static aura fallback (subtil ring)
      return SizedBox(
        width: widget.size * 1.3,
        height: widget.size * 1.3,
        child: Center(
          child: CustomPaint(
            painter: _AuraPainter(
              progress: 0.0,
              color: color,
              staticMode: true,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.size * 1.4,
      height: widget.size * 1.4,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            return Transform.rotate(
              angle: _ctrl.value * 2 * math.pi,
              child: CustomPaint(
                painter: _AuraPainter(
                  progress: _ctrl.value,
                  color: color,
                  staticMode: false,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuraPainter extends CustomPainter {
  _AuraPainter({
    required this.progress,
    required this.color,
    this.staticMode = false,
  });

  final double progress; // 0..1 animation phase
  final Color color;
  final bool staticMode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) * 0.45;

    // --- halo radial gradient ---
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withAlpha(46), // ~0.18
          color.withAlpha(15), // ~0.06
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.15))
      ..isAntiAlias = true
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18.0);

    canvas.drawCircle(center, radius * 1.15, haloPaint);

    // --- small organic spots (particles) ---
    final particlePaint = Paint()
      ..color = color.withAlpha(56) // ~0.22
      ..isAntiAlias = true
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    final count = 4;
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi + progress * 2 * math.pi * (0.6 + (i * 0.08));
      final r = radius * (0.7 + 0.12 * math.sin(progress * 2 * math.pi + i));
      final dx = center.dx + r * math.cos(angle);
      final dy = center.dy + r * math.sin(angle);
      final s = radius * (0.12 + 0.03 * math.cos(progress * 2 * math.pi + i));
      canvas.drawCircle(Offset(dx, dy), s, particlePaint);
    }

    // --- thin inner ring for contrast ---
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = color.withAlpha(217); // ~0.85

    canvas.drawCircle(center, radius * 0.98, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _AuraPainter old) {
    return old.progress != progress || old.color != color || old.staticMode != staticMode;
  }
}
