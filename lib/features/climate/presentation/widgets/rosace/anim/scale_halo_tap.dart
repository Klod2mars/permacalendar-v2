import 'package:flutter/material.dart';

/// Scale Halo Tap Animation
///
/// Provides scale + halo animation on tap for rosace components.
/// Duration: 100-140ms for smooth 60fps performance.
///
/// Features:
/// - Scale animation (0.95x to 1.0x)
/// - Subtle shadow halo effect
/// - Smooth easing curve
/// - Performance optimized for Samsung A35
class ScaleHaloTap extends StatefulWidget {
  const ScaleHaloTap({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<ScaleHaloTap> createState() => _ScaleHaloTapState();
}

class _ScaleHaloTapState extends State<ScaleHaloTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _haloAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 120), // 100-140ms range
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _haloAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: _haloAnimation.value > 0
                    ? [
                        BoxShadow(
                          color: Colors.white
                              .withOpacity(0.1 * _haloAnimation.value),
                          blurRadius: 8 * _haloAnimation.value,
                          spreadRadius: 2 * _haloAnimation.value,
                        ),
                      ]
                    : null,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}


