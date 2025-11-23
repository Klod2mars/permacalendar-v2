// lib/shared/widgets/animations/insect_awakening_widget.dart
//
// Widget autonome pour la luminescence persistante des bulles jardins.
// - Usage attendu : envelopper une zone ronde (ClipOval + SizedBox) avec ce widget.
// - InvisibleGardenZone utilise : key: GlobalKey<InsectAwakeningWidgetState>()
//   puis awakeningKey.currentState?.triggerAnimation();
// - Le widget écoute activeGardenIdProvider pour basculer en "persistent".
//

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/providers/active_garden_provider.dart';

/// ---------------------- Configuration -------------------------------------
class InsectAwakeningConfig {
  // Durées
  static const Duration totalDuration = Duration(milliseconds: 800);
  static const Duration fadeOutDuration = Duration(milliseconds: 700);

  // Particules / awakening
  static const int particleCount = 12;
  static const double particleBaseSize = 3.0;
  static const double expansionRadius = 48.0;
  static const double particleOpacity = 0.75;
  static const double blurIntensity = 2.5;

  // Halo persistant
  static const Duration persistentHaloDuration = Duration(seconds: 3);
  static const double persistentHaloMinOpacity = 0.36;
  static const double persistentHaloMaxOpacity = 0.6;
  static const double persistentHaloBlurRadius = 26.0;
  static const Curve persistentHaloCurve = Curves.easeInOutCubic;

  // Audio (optionnel)
  static const String soundAsset = 'sfx/insect_wake.mp3';
  static const double soundVolume = 0.28;
}

/// ---------------------- Enums ------------------------------------------------
enum InsectAnimationState { idle, awakening, persistent, fadingOut }

/// ---------------------- Painters -------------------------------------------
class _ParticlesPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0
  final Color color;
  final Size bubbleSize;

  _ParticlesPainter({
    required this.progress,
    required this.color,
    required this.bubbleSize,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..isAntiAlias = true;
    final particleCount = InsectAwakeningConfig.particleCount;
    final baseRadius = math.min(size.width, size.height) / 2;

    for (int i = 0; i < particleCount; i++) {
      final t = (i / particleCount);
      // Staggered appearance
      final appearOffset = 0.08 * i;
      final localProgress = ((progress - appearOffset) / (1.0 - appearOffset)).clamp(0.0, 1.0);

      if (localProgress <= 0.0) continue;

      // angle rotates with progress
      final angle = (t * 2.0 * math.pi) + (progress * 2.0 * math.pi);
      final radius = baseRadius * 0.15 + (InsectAwakeningConfig.expansionRadius * localProgress * 0.7);

      final dx = center.dx + math.cos(angle) * radius;
      final dy = center.dy + math.sin(angle) * radius;

      final sizeP = InsectAwakeningConfig.particleBaseSize * (0.8 + 0.8 * localProgress);
      final opacity = (InsectAwakeningConfig.particleOpacity * localProgress).clamp(0.0, 1.0);

      paint.color = color.withOpacity(opacity);
      // soft glow
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, InsectAwakeningConfig.blurIntensity);

      canvas.drawCircle(Offset(dx, dy), sizeP, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter old) {
    return old.progress != progress || old.color != color || old.bubbleSize != bubbleSize;
  }
}

class _PersistentHaloPainter extends CustomPainter {
  final double pulsationValue; // 0..1
  final double? fadeOutValue; // null or 0..1 (1 = fully faded out)
  final Color glowColor;
  final Size bubbleSize;

  _PersistentHaloPainter({
    required this.pulsationValue,
    required this.fadeOutValue,
    required this.glowColor,
    required this.bubbleSize,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // pulsation map 0..1 -> opacity between min and max
    final baseOpacity = InsectAwakeningConfig.persistentHaloMinOpacity +
        (InsectAwakeningConfig.persistentHaloMaxOpacity -
                InsectAwakeningConfig.persistentHaloMinOpacity) *
            pulsationValue;

    final fade = (fadeOutValue == null) ? 1.0 : (1.0 - fadeOutValue!.clamp(0.0, 1.0));
    final effectiveOpacity = (baseOpacity * fade).clamp(0.0, 1.0);

    // Outer glow
    final outer = Paint()
      ..color = glowColor.withOpacity(effectiveOpacity * 0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, InsectAwakeningConfig.persistentHaloBlurRadius)
      ..isAntiAlias = true;
    canvas.drawCircle(center, bubbleSize.width * 0.45, outer);

    // Mid glow
    final mid = Paint()
      ..color = glowColor.withOpacity(effectiveOpacity * 0.35)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, InsectAwakeningConfig.persistentHaloBlurRadius * 0.6)
      ..isAntiAlias = true;
    canvas.drawCircle(center, bubbleSize.width * 0.28, mid);

    // Inner soft
    final inner = Paint()
      ..color = glowColor.withOpacity(effectiveOpacity * 0.12)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, InsectAwakeningConfig.persistentHaloBlurRadius * 0.3)
      ..isAntiAlias = true;
    canvas.drawCircle(center, bubbleSize.width * 0.14, inner);
  }

  @override
  bool shouldRepaint(covariant _PersistentHaloPainter old) {
    return old.pulsationValue != pulsationValue ||
        old.fadeOutValue != fadeOutValue ||
        old.glowColor != glowColor ||
        old.bubbleSize != bubbleSize;
  }
}

/// ---------------------- Widget ---------------------------------------------
class InsectAwakeningWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Color particleColor;
  final String gardenId;
  final bool enabled;
  final VoidCallback? onAnimationComplete;

  const InsectAwakeningWidget({
    super.key,
    required this.child,
    required this.particleColor,
    required this.gardenId,
    this.enabled = true,
    this.onAnimationComplete,
  });

  @override
  InsectAwakeningWidgetState createState() => InsectAwakeningWidgetState();
}

class InsectAwakeningWidgetState extends ConsumerState<InsectAwakeningWidget>
    with TickerProviderStateMixin {
  late final AnimationController _awakeningController;
  late final Animation<double> _awakeningAnim;

  late final AnimationController _persistentController;
  late final Animation<double> _persistentAnim;

  AnimationController? _fadeOutController;
  Animation<double>? _fadeOutAnim;

  final AudioPlayer _audioPlayer = AudioPlayer();
  InsectAnimationState _currentState = InsectAnimationState.idle;

  bool _persistentRepeatActive = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) debugPrint('[Insect] init for ${widget.gardenId}');

    _awakeningController = AnimationController(
      vsync: this,
      duration: InsectAwakeningConfig.totalDuration,
    );
    _awakeningAnim = CurvedAnimation(parent: _awakeningController, curve: Curves.linear);

    _persistentController = AnimationController(
      vsync: this,
      duration: InsectAwakeningConfig.persistentHaloDuration,
    );
    _persistentAnim = CurvedAnimation(parent: _persistentController, curve: InsectAwakeningConfig.persistentHaloCurve);

    _awakeningController.addStatusListener(_onAwakeningStatusChange);

    // Listen provider changes
    ref.listen<String?>(activeGardenIdProvider, (prev, next) {
      final isActive = (next == widget.gardenId);
      if (kDebugMode) debugPrint('[Insect] provider change prev=$prev next=$next for ${widget.gardenId}');
      if (isActive) {
        // If the garden becomes active, ensure persistent immediately,
        // and optionally run the awakening animation as a visual cue.
        if (_currentState == InsectAnimationState.idle) {
          setState(() => _currentState = InsectAnimationState.persistent);
          _ensurePersistent();
          if (widget.enabled) {
            // start the awakening visuals but do not block
            triggerAnimation();
          }
        } else if (_currentState == InsectAnimationState.fadingOut) {
          _fadeOutController?.stop();
          _fadeOutController?.dispose();
          _fadeOutController = null;
          _fadeOutAnim = null;
          setState(() => _currentState = InsectAnimationState.persistent);
          _ensurePersistent();
        }
      } else {
        if (_currentState == InsectAnimationState.persistent || _currentState == InsectAnimationState.awakening) {
          _startFadeOut();
        }
      }
    });

    // Post frame initial check: if garden already active at mount, start persistent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final active = ref.read(activeGardenIdProvider);
        if (kDebugMode) debugPrint('[Insect] postFrame active=$active for ${widget.gardenId}');
        if (active == widget.gardenId) {
          setState(() => _currentState = InsectAnimationState.persistent);
          _ensurePersistent();
        }
      } catch (e) {
        if (kDebugMode) debugPrint('[Insect] postFrame check error: $e');
      }
    });
  }

  @override
  void dispose() {
    _awakeningController.removeStatusListener(_onAwakeningStatusChange);
    _awakeningController.dispose();
    _persistentController.dispose();
    _fadeOutController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Public: trigger awakening animation (awaitable)
  Future<void> triggerAnimation() async {
    if (!widget.enabled) {
      if (kDebugMode) debugPrint('[Insect] triggerAnimation disabled for ${widget.gardenId}');
      return;
    }
    if (_currentState == InsectAnimationState.awakening) {
      if (kDebugMode) debugPrint('[Insect] already awakening for ${widget.gardenId}');
      return;
    }
    // Cancel any fade-out
    if (_fadeOutController != null) {
      _fadeOutController!.stop();
      _fadeOutController!.dispose();
      _fadeOutController = null;
      _fadeOutAnim = null;
    }

    setState(() => _currentState = InsectAnimationState.awakening);

    try {
      _awakeningController.forward(from: 0.0);
    } catch (e) {
      if (kDebugMode) debugPrint('[Insect] awakening forward failed: $e');
      // If controller failed, fallback to persistent
      setState(() => _currentState = InsectAnimationState.persistent);
      _ensurePersistent();
      widget.onAnimationComplete?.call();
      return;
    }

    // Attempt to play sound (best-effort)
    _playSound();

    // Await the completion of the awakening animation
    await _awakeningController.forward().whenComplete(() {});
  }

  // Public debug method: force immediate persistent halo
  void forcePersistent() {
    if (kDebugMode) debugPrint('[Insect] forcePersistent for ${widget.gardenId}');
    setState(() => _currentState = InsectAnimationState.persistent);
    _ensurePersistent();
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.setVolume(InsectAwakeningConfig.soundVolume);
      await _audioPlayer.play(AssetSource(InsectAwakeningConfig.soundAsset));
    } catch (e) {
      if (kDebugMode) debugPrint('[Insect] audio play failed: $e');
    }
  }

  void _onAwakeningStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (kDebugMode) debugPrint('[Insect] awakening completed for ${widget.gardenId}');
      setState(() => _currentState = InsectAnimationState.persistent);
      _awakeningController.reset();
      _ensurePersistent();
      widget.onAnimationComplete?.call();
    }
  }

  void _ensurePersistent() {
    if (!_persistentController.isAnimating) {
      if (kDebugMode) debugPrint('[Insect] starting persistent controller for ${widget.gardenId}');
      _persistentController.repeat(reverse: true);
      _persistentRepeatActive = true;
    }
  }

  void _stopPersistent() {
    if (_persistentController.isAnimating) {
      if (kDebugMode) debugPrint('[Insect] stopping persistent controller for ${widget.gardenId}');
      _persistentController.stop();
      _persistentRepeatActive = false;
    }
  }

  void _startFadeOut() {
    if (_currentState == InsectAnimationState.fadingOut || _currentState == InsectAnimationState.idle) {
      if (kDebugMode) debugPrint('[Insect] fadeOut early return for ${widget.gardenId}');
      return;
    }

    setState(() => _currentState = InsectAnimationState.fadingOut);
    _stopPersistent();

    _fadeOutController = AnimationController(vsync: this, duration: InsectAwakeningConfig.fadeOutDuration);
    _fadeOutAnim = CurvedAnimation(parent: _fadeOutController!, curve: Curves.easeOut);

    _fadeOutController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _currentState = InsectAnimationState.idle);
        _fadeOutController?.dispose();
        _fadeOutController = null;
        _fadeOutAnim = null;
      }
    });

    _fadeOutController!.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base child (bubble)
        widget.child,

        // Awakening particles overlay
        if (widget.enabled && _currentState == InsectAnimationState.awakening)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _awakeningAnim,
                builder: (context, _) {
                  return LayoutBuilder(builder: (context, constraints) {
                    final bubbleSize = constraints.biggest;
                    if (kDebugMode) {
                      debugPrint('[Insect] build awakening ${widget.gardenId} bubbleSize=$bubbleSize state=$_currentState');
                    }
                    if (bubbleSize.width <= 0 || bubbleSize.height <= 0) return const SizedBox.shrink();

                    return CustomPaint(
                      size: bubbleSize,
                      painter: _ParticlesPainter(
                        progress: _awakeningAnim.value,
                        color: widget.particleColor,
                        bubbleSize: bubbleSize,
                      ),
                    );
                  });
                },
              ),
            ),
          ),

        // Persistent halo overlay (persistent OR fadingOut)
        if (widget.enabled &&
            (_currentState == InsectAnimationState.persistent || _currentState == InsectAnimationState.fadingOut))
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _persistentAnim,
                  if (_fadeOutAnim != null) _fadeOutAnim!,
                ]),
                builder: (context, _) {
                  return LayoutBuilder(builder: (context, constraints) {
                    final bubbleSize = constraints.biggest;
                    if (kDebugMode) {
                      debugPrint('[Insect] build persistent ${widget.gardenId} bubbleSize=$bubbleSize state=$_currentState');
                    }
                    if (bubbleSize.width <= 0 || bubbleSize.height <= 0) return const SizedBox.shrink();

                    return CustomPaint(
                      size: bubbleSize,
                      painter: _PersistentHaloPainter(
                        pulsationValue: _persistentAnim.value,
                        fadeOutValue: _fadeOutAnim?.value,
                        glowColor: widget.particleColor,
                        bubbleSize: bubbleSize,
                      ),
                    );
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}
