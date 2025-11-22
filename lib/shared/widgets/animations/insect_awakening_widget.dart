// lib/shared/widgets/animations/insect_awakening_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'insect_animation_config.dart';
import 'insect_particles_painter.dart';
import 'insect_persistent_halo_painter.dart';
import '../../../core/providers/active_garden_provider.dart';

/// Widget d'animation "éveil insecte" avec particules et halo persistant
///
/// Conçu pour être monté autour d'une zone circulaire (ex : ClipOval + SizedBox),
/// il écoute `activeGardenIdProvider` et passe en état `persistent` lorsque
/// son gardenId devient actif.
class InsectAwakeningWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Color particleColor;
  final VoidCallback? onAnimationComplete;
  final bool enabled;
  final String gardenId;

  const InsectAwakeningWidget({
    super.key,
    required this.child,
    required this.particleColor,
    required this.gardenId,
    this.onAnimationComplete,
    this.enabled = true,
  });

  @override
  ConsumerState<InsectAwakeningWidget> createState() =>
      InsectAwakeningWidgetState();
}

class InsectAwakeningWidgetState extends ConsumerState<InsectAwakeningWidget>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _awakeningController;
  late Animation<double> _awakeningAnimation;

  late AnimationController _persistentHaloController;
  late Animation<double> _persistentHaloAnimation;

  AnimationController? _fadeOutController;
  Animation<double>? _fadeOutAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  InsectAnimationState _currentState = InsectAnimationState.idle;

  // Guard to avoid repeatedly calling repeat() on persistent controller
  bool _persistentRepeatActive = false;

  @override
  void initState() {
    super.initState();

    _initializeAnimations();

    // Listen to the awakening animation status to move to persistent state.
    _awakeningController.addStatusListener(_onAwakeningStatusChange);

    // Reliable listen to provider for immediate reaction to active garden changes.
    // Using ref.listen inside initState is safe in ConsumerState.
    ref.listen<String?>(activeGardenIdProvider, (prev, next) {
      final isActive = next == widget.gardenId;
      if (isActive) {
        // If garden becomes active, either start animation (idle) or cancel fadeOut.
        if (_currentState == InsectAnimationState.idle) {
          triggerAnimation();
        } else if (_currentState == InsectAnimationState.fadingOut) {
          // Cancel fade out and go straight to persistent
          _fadeOutController?.stop();
          _fadeOutController?.dispose();
          _fadeOutController = null;
          _fadeOutAnimation = null;
          setState(() {
            _currentState = InsectAnimationState.persistent;
          });
          _startPersistentIfNeeded();
        }
      } else {
        // If garden is no longer active, and we were persistent/awakening, fade out.
        if (_currentState == InsectAnimationState.persistent ||
            _currentState == InsectAnimationState.awakening) {
          _startFadeOut();
        }
      }
    });
  }

  @override
  void dispose() {
    _awakeningController.removeStatusListener(_onAwakeningStatusChange);
    _awakeningController.dispose();
    _persistentHaloController.dispose();
    _fadeOutController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _awakeningController = AnimationController(
      duration: InsectAwakeningConfig.totalDuration,
      vsync: this,
    );
    _awakeningAnimation = CurvedAnimation(
      parent: _awakeningController,
      curve: Curves.linear,
    );

    _persistentHaloController = AnimationController(
      duration: InsectAwakeningConfig.persistentHaloDuration,
      vsync: this,
    );
    _persistentHaloAnimation = CurvedAnimation(
      parent: _persistentHaloController,
      curve: InsectAwakeningConfig.persistentHaloCurve,
    );
  }

  /// Ensure persistent controller is running once.
  void _startPersistentIfNeeded() {
    if (!_persistentHaloController.isAnimating) {
      _persistentHaloController.repeat(reverse: true);
      _persistentRepeatActive = true;
    }
  }

  void _stopPersistentIfNeeded() {
    if (_persistentHaloController.isAnimating) {
      _persistentHaloController.stop();
      _persistentRepeatActive = false;
    }
  }

  /// Called when awakening animation completes.
  void _onAwakeningStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Switch to persistent with setState so UI rebuilds and painter is shown.
      setState(() {
        _currentState = InsectAnimationState.persistent;
      });

      // Reset awakening controller for future uses.
      _awakeningController.reset();

      // Start persistent pulsation loop.
      _startPersistentIfNeeded();

      widget.onAnimationComplete?.call();
    }
  }

  /// Trigger the awakening animation (or directly persistent if animations disabled).
  Future<void> triggerAnimation() async {
    if (!widget.enabled || _currentState == InsectAnimationState.awakening) {
      return;
    }

    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery != null && mediaQuery.disableAnimations) {
      // Accessibility mode: directly go persistent.
      setState(() {
        _currentState = InsectAnimationState.persistent;
      });
      _startPersistentIfNeeded();
      widget.onAnimationComplete?.call();
      return;
    }

    // Cancel any in-flight fade-out
    if (_fadeOutController != null) {
      _fadeOutController!.stop();
      _fadeOutController!.dispose();
      _fadeOutController = null;
      _fadeOutAnimation = null;
    }

    setState(() {
      _currentState = InsectAnimationState.awakening;
    });

    _awakeningController.forward(from: 0.0);
    // Play sound opportunistically; errors are ignored.
    _playInsectSound();
  }

  Future<void> _playInsectSound() async {
    try {
      await _audioPlayer.setVolume(InsectAwakeningConfig.soundVolume);
      await _audioPlayer.play(AssetSource(InsectAwakeningConfig.soundAsset));
    } catch (_) {
      // Silent catch: sound is optional
    }
  }

  void _startFadeOut() {
    if (_currentState == InsectAnimationState.fadingOut ||
        _currentState == InsectAnimationState.idle) {
      return;
    }

    setState(() {
      _currentState = InsectAnimationState.fadingOut;
    });

    // Stop persistent pulsation immediately
    _stopPersistentIfNeeded();

    // Build fade-out controller
    _fadeOutController = AnimationController(
      duration: InsectAwakeningConfig.fadeOutDuration,
      vsync: this,
    );
    _fadeOutAnimation = CurvedAnimation(
      parent: _fadeOutController!,
      curve: InsectAwakeningConfig.fadeOutCurve,
    );

    _fadeOutController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Fully faded out: go idle and dispose fade controller
        setState(() {
          _currentState = InsectAnimationState.idle;
        });
        _fadeOutController?.dispose();
        _fadeOutController = null;
        _fadeOutAnimation = null;
      }
    });

    _fadeOutController!.forward(from: 0.0);
  }

  /// Fallback check: useful if widget's gardenId has changed or after a hot reload.
  void _checkActiveGardenChange() {
    final activeGardenId = ref.read(activeGardenIdProvider);
    final isThisGardenActive = activeGardenId == widget.gardenId;

    if (isThisGardenActive && _currentState == InsectAnimationState.idle) {
      // If garden already active, ensure persistent state
      triggerAnimation();
    } else if (!isThisGardenActive &&
        (_currentState == InsectAnimationState.persistent ||
            _currentState == InsectAnimationState.awakening)) {
      _startFadeOut();
    }
  }

  @override
  void didUpdateWidget(InsectAwakeningWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the gardenId changed (or other props), re-evaluate active state
    if (oldWidget.gardenId != widget.gardenId) {
      _checkActiveGardenChange();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkActiveGardenChange();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Child content (the bubble/base)
        widget.child,

        // Awakening particles (shown only during awakening)
        if (widget.enabled && _currentState == InsectAnimationState.awakening)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _awakeningAnimation,
                builder: (context, child) {
                  return LayoutBuilder(builder: (context, constraints) {
                    final bubbleSize = constraints.biggest;
                    // If bubble has no meaningful size, avoid painting
                    if (bubbleSize.width <= 0 || bubbleSize.height <= 0) {
                      return const SizedBox.shrink();
                    }
                    return CustomPaint(
                      size: bubbleSize,
                      painter: InsectParticlesPainter(
                        animation: _awakeningAnimation,
                        particleColor: widget.particleColor,
                        bubbleSize: bubbleSize,
                      ),
                    );
                  });
                },
              ),
            ),
          ),

        // Persistent halo (shown in persistent or fadingOut states)
        if (widget.enabled &&
            (_currentState == InsectAnimationState.persistent ||
                _currentState == InsectAnimationState.fadingOut))
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _persistentHaloAnimation,
                  if (_fadeOutAnimation != null) _fadeOutAnimation!,
                ]),
                builder: (context, child) {
                  return LayoutBuilder(builder: (context, constraints) {
                    final bubbleSize = constraints.biggest;
                    if (bubbleSize.width <= 0 || bubbleSize.height <= 0) {
                      return const SizedBox.shrink();
                    }

                    return CustomPaint(
                      size: bubbleSize,
                      painter: InsectPersistentHaloPainter(
                        pulsationAnimation: _persistentHaloAnimation,
                        fadeOutAnimation: _fadeOutAnimation,
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

/// Extension helper to create default widget quickly.
extension InsectAwakeningWidgetExtension on InsectAwakeningWidget {
  static InsectAwakeningWidget createDefault({
    required Widget child,
    required Color particleColor,
    required String gardenId,
    VoidCallback? onAnimationComplete,
    bool enabled = true,
  }) {
    return InsectAwakeningWidget(
      child: child,
      particleColor: particleColor,
      gardenId: gardenId,
      onAnimationComplete: onAnimationComplete,
      enabled: enabled,
    );
  }
}
