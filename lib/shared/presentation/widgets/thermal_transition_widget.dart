ï»¿import 'package:flutter/material.dart';
import '../../../core/theme/thermal_color_schemes.dart';

/// Widget pour transitions thermiques graduelles et douces (2-5s)
/// Morphing graduel sans flash brutal
class ThermalTransitionWidget extends StatefulWidget {
  final Widget child;
  final ColorScheme targetColorScheme;
  final Duration transitionDuration;

  const ThermalTransitionWidget({
    super.key,
    required this.child,
    required this.targetColorScheme,
    this.transitionDuration = const Duration(seconds: 3), // Transition douce 3s
  });

  @override
  State<ThermalTransitionWidget> createState() =>
      _ThermalTransitionWidgetState();
}

class _ThermalTransitionWidgetState extends State<ThermalTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  ColorScheme? _currentColorScheme;
  ColorScheme? _previousColorScheme;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic, // Courbe douce et naturelle
    );

    _currentColorScheme = widget.targetColorScheme;
  }

  @override
  void didUpdateWidget(ThermalTransitionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Détection changement de palette
    if (oldWidget.targetColorScheme.primary !=
        widget.targetColorScheme.primary) {
      _previousColorScheme = _currentColorScheme;
      _currentColorScheme = widget.targetColorScheme;

      // Démarrer transition douce (pas de flash brutal)
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        ColorScheme effectiveColorScheme;

        if (_previousColorScheme != null && _animationController.isAnimating) {
          // Interpolation douce entre palettes
          effectiveColorScheme = ThermalColorSchemes.interpolatePalettes(
            _previousColorScheme!,
            _currentColorScheme!,
            _animation.value,
          );
        } else {
          effectiveColorScheme = _currentColorScheme!;
        }

        return Theme(
          data: Theme.of(context).copyWith(colorScheme: effectiveColorScheme),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Widget d'animation respirante pour les glow
/// Animation continue 4s pour effet vivant
class ThermalGlowWidget extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double intensity;

  const ThermalGlowWidget({
    super.key,
    required this.child,
    required this.glowColor,
    this.intensity = 0.6,
  });

  @override
  State<ThermalGlowWidget> createState() => _ThermalGlowWidgetState();
}

class _ThermalGlowWidgetState extends State<ThermalGlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: const Duration(seconds: 4), // Respiration lente
      vsync: this,
    );
    _breatheAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _breatheController,
      curve: Curves.easeInOut,
    ));

    _breatheController.repeat(reverse: true); // Animation respirante continue
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breatheAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(
                    widget.intensity * _breatheAnimation.value * 0.3),
                blurRadius: 15 * _breatheAnimation.value,
                spreadRadius: 3 * _breatheAnimation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }
}

/// Widget pour transitions de glow coloré
/// Permet de changer la couleur du glow avec transition
class ThermalGlowTransitionWidget extends StatefulWidget {
  final Widget child;
  final Color targetGlowColor;
  final double intensity;
  final Duration transitionDuration;

  const ThermalGlowTransitionWidget({
    super.key,
    required this.child,
    required this.targetGlowColor,
    this.intensity = 0.6,
    this.transitionDuration = const Duration(seconds: 2),
  });

  @override
  State<ThermalGlowTransitionWidget> createState() =>
      _ThermalGlowTransitionWidgetState();
}

class _ThermalGlowTransitionWidgetState
    extends State<ThermalGlowTransitionWidget> with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _colorController;
  late Animation<double> _breatheAnimation;
  late Animation<Color?> _colorAnimation;

  Color? _currentGlowColor;
  Color? _previousGlowColor;

  @override
  void initState() {
    super.initState();

    // Animation respirante continue
    _breatheController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breatheAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _breatheController,
      curve: Curves.easeInOut,
    ));

    // Animation de transition de couleur
    _colorController = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: widget.targetGlowColor,
      end: widget.targetGlowColor,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    _currentGlowColor = widget.targetGlowColor;
    _breatheController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ThermalGlowTransitionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.targetGlowColor != widget.targetGlowColor) {
      _previousGlowColor = _currentGlowColor;
      _currentGlowColor = widget.targetGlowColor;

      _colorAnimation = ColorTween(
        begin: _previousGlowColor,
        end: _currentGlowColor,
      ).animate(CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ));

      _colorController.reset();
      _colorController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breatheAnimation, _colorAnimation]),
      builder: (context, child) {
        final effectiveGlowColor = _colorAnimation.value ?? _currentGlowColor!;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: effectiveGlowColor.withOpacity(
                    widget.intensity * _breatheAnimation.value * 0.3),
                blurRadius: 15 * _breatheAnimation.value,
                spreadRadius: 3 * _breatheAnimation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _colorController.dispose();
    super.dispose();
  }
}


