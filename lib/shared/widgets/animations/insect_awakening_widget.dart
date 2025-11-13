ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'insect_animation_config.dart';
import 'insect_particles_painter.dart';
import 'insect_persistent_halo_painter.dart';
import '../../../core/providers/active_garden_provider.dart';

/// Widget d'animation "éveil insecte" avec 12 particules lumineuses en spirale
/// Mission A39-2 : Animation de 800ms avec son de bourdonnement
/// Mission A39-2.1 : Halo persistant pour jardins actifs
class InsectAwakeningWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Color particleColor;
  final VoidCallback? onAnimationComplete;
  final bool enabled;
  final String gardenId; // NOUVEAU : ID du jardin pour tracking

  const InsectAwakeningWidget({
    super.key,
    required this.child,
    required this.particleColor,
    required this.gardenId, // NOUVEAU
    this.onAnimationComplete,
    this.enabled = true,
  });

  @override
  ConsumerState<InsectAwakeningWidget> createState() =>
      InsectAwakeningWidgetState();
}

class InsectAwakeningWidgetState extends ConsumerState<InsectAwakeningWidget>
    with TickerProviderStateMixin {
  // Animation éveil (existante)
  late AnimationController _awakeningController;
  late Animation<double> _awakeningAnimation;

  // NOUVEAUX : Animation halo persistant
  late AnimationController _persistentHaloController;
  late Animation<double> _persistentHaloAnimation;

  // NOUVEAU : Animation fade out
  AnimationController? _fadeOutController;
  Animation<double>? _fadeOutAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  InsectAnimationState _currentState = InsectAnimationState.idle;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _awakeningController.addStatusListener(_onAwakeningStatusChange);
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

  @override
  void didUpdateWidget(InsectAwakeningWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Détecter changement de jardin actif
    _checkActiveGardenChange();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkActiveGardenChange();
  }

  /// Initialise les contrôleurs d'animation
  void _initializeAnimations() {
    // Controller éveil (existant)
    _awakeningController = AnimationController(
      duration: InsectAwakeningConfig.totalDuration,
      vsync: this,
    );
    _awakeningAnimation = CurvedAnimation(
      parent: _awakeningController,
      curve: Curves.linear,
    );

    // NOUVEAU : Controller halo persistant
    _persistentHaloController = AnimationController(
      duration: InsectAwakeningConfig.persistentHaloDuration,
      vsync: this,
    );
    _persistentHaloAnimation = CurvedAnimation(
      parent: _persistentHaloController,
      curve: InsectAwakeningConfig.persistentHaloCurve,
    );
  }

  /// NOUVEAU : Vérifier si ce jardin est actif
  void _checkActiveGardenChange() {
    final activeGardenId = ref.watch(activeGardenIdProvider);
    final isThisGardenActive = activeGardenId == widget.gardenId;

    if (isThisGardenActive && _currentState == InsectAnimationState.idle) {
      // Ce jardin vient d'être activé ailleurs (ex: par long press)
      // Lancer l'animation complète
      triggerAnimation();
    } else if (!isThisGardenActive &&
        (_currentState == InsectAnimationState.persistent ||
            _currentState == InsectAnimationState.awakening)) {
      // Ce jardin n'est plus actif, lancer fade out
      _startFadeOut();
    }
  }

  /// Gère les changements de statut de l'animation d'éveil
  void _onAwakeningStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Animation éveil terminée, passer en mode persistant
      _currentState = InsectAnimationState.persistent;
      _awakeningController.reset();

      // Démarrer la pulsation du halo persistant
      _persistentHaloController.repeat(reverse: true);

      widget.onAnimationComplete?.call();
    }
  }

  /// Déclenche l'animation d'éveil insecte
  /// Vérifie les paramètres d'accessibilité et lance l'animation + son
  Future<void> triggerAnimation() async {
    if (!widget.enabled || _currentState == InsectAnimationState.awakening) {
      return;
    }

    // Vérifier accessibilité
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery != null && mediaQuery.disableAnimations) {
      _currentState = InsectAnimationState.persistent;
      _persistentHaloController.repeat(reverse: true);
      widget.onAnimationComplete?.call();
      return;
    }

    // Annuler fade out si en cours
    _fadeOutController?.stop();
    _fadeOutController = null;
    _fadeOutAnimation = null;

    _currentState = InsectAnimationState.awakening;

    // Lancer animation éveil
    _awakeningController.forward(from: 0.0);

    // Lancer le son
    await _playInsectSound();
  }

  /// NOUVEAU : Démarre la transition fade out
  void _startFadeOut() {
    if (_currentState == InsectAnimationState.fadingOut ||
        _currentState == InsectAnimationState.idle) {
      return;
    }

    _currentState = InsectAnimationState.fadingOut;

    // Arrêter la pulsation
    _persistentHaloController.stop();

    // Créer controller fade out
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
        setState(() {
          _currentState = InsectAnimationState.idle;
          _fadeOutController?.dispose();
          _fadeOutController = null;
          _fadeOutAnimation = null;
        });
      }
    });

    _fadeOutController!.forward();
  }

  /// Joue le son de bourdonnement d'insecte
  /// Gère les erreurs de lecture audio de manière silencieuse
  Future<void> _playInsectSound() async {
    try {
      await _audioPlayer.setVolume(InsectAwakeningConfig.soundVolume);
      await _audioPlayer.play(AssetSource(InsectAwakeningConfig.soundAsset));
    } catch (e) {
      // Log silencieux pour éviter de spammer la console
      // Le son est optionnel et ne doit pas bloquer l'animation
      debugPrint('ðŸ InsectAwakening: Erreur lecture son (optionnel): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Widget enfant (zone de jardin)
        widget.child,

        // Animation éveil (particules)
        if (widget.enabled && _currentState == InsectAnimationState.awakening)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _awakeningAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: InsectParticlesPainter(
                      animation: _awakeningAnimation,
                      particleColor: widget.particleColor,
                      bubbleSize: MediaQuery.of(context).size,
                    ),
                  );
                },
              ),
            ),
          ),

        // NOUVEAU : Halo persistant
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
                  return CustomPaint(
                    painter: InsectPersistentHaloPainter(
                      pulsationAnimation: _persistentHaloAnimation,
                      fadeOutAnimation: _fadeOutAnimation,
                      glowColor: widget.particleColor,
                      bubbleSize: MediaQuery.of(context).size,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// Extension pour faciliter l'utilisation du widget
extension InsectAwakeningWidgetExtension on InsectAwakeningWidget {
  /// Crée une instance avec des paramètres par défaut optimisés
  static InsectAwakeningWidget createDefault({
    required Widget child,
    required Color particleColor,
    required String gardenId,
    VoidCallback? onAnimationComplete,
    bool enabled = true,
  }) {
    return InsectAwakeningWidget(
      particleColor: particleColor,
      gardenId: gardenId,
      onAnimationComplete: onAnimationComplete,
      enabled: enabled,
      child: child,
    );
  }
}


