ï»¿import 'package:flutter/material.dart';

/// Pulse Alert Animation
///
/// Provides repeating opacity pulse effect when alert is active.
/// Used for alert mode visual feedback on rosace components.
///
/// Features:
/// - Repeating opacity pulse (0.7 to 1.0)
/// - 1.5s cycle duration
/// - Smooth infinite loop
/// - Performance optimized
class PulseAlert extends StatefulWidget {
  const PulseAlert({
    super.key,
    required this.child,
    required this.isActive,
  });

  final Widget child;
  final bool isActive;

  @override
  State<PulseAlert> createState() => _PulseAlertState();
}

class _PulseAlertState extends State<PulseAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // 1.5s cycle
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(PulseAlert oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}


