import 'package:flutter/material.dart';

/// Widget minimal pour une zone calibrable unifiée.
/// Ne dépend pas encore des providers: utilisable en mode isolé.
class OrganicCalibratableZone extends StatelessWidget {
  final Offset position; // normalisé 0..1
  final double size; // normalisé 0..1
  final bool enabled;
  final Widget child;

  const OrganicCalibratableZone({
    super.key,
    required this.position,
    required this.size,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final dx = (position.dx.clamp(0.0, 1.0)) * constraints.maxWidth;
        final dy = (position.dy.clamp(0.0, 1.0)) * constraints.maxHeight;
        final s = size.clamp(0.0, 1.0);
        final dimension = (constraints.biggest.shortestSide) * s;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: dx - dimension / 2,
              top: dy - dimension / 2,
              width: dimension,
              height: dimension,
              child: child,
            ),
          ],
        );
      },
    );
  }
}

