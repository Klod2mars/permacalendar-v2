import '../../../core/repositories/dashboard_slots_repository.dart';
import 'package:permacalendar/app_router.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter/services.dart';

import '../../../core/providers/active_garden_provider.dart';

import '../../../core/models/garden_freezed.dart';

import '../../../shared/presentation/themes/organic_palettes.dart';

import '../../../shared/widgets/animations/insect_awakening_widget.dart';

/// Widget de zone interactive invisible pour un slot jardin

/// Remplace GardenBubbleWidget avec une approche "invisible + lueur"

class InvisibleGardenZone extends ConsumerStatefulWidget {
  final int slotNumber;

  final Rect zone; // Position et taille en pixels absolus

  final Color glowColor; // Couleur de la lueur pour ce jardin

  // âÅ“… NOUVEAUX PARAMÃƒË†TRES pour calibration

  final bool isCalibrationMode;

  final Function(String zoneId, DragStartDetails details)? onPanStart;

  final Function(String zoneId, DragUpdateDetails details, double screenWidth,
      double screenHeight)? onPanUpdate;

  final Function(String zoneId, DragEndDetails details)? onPanEnd;

  const InvisibleGardenZone({
    super.key,
    required this.slotNumber,
    required this.zone,
    required this.glowColor,
    this.isCalibrationMode = false,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
  });

  @override
  ConsumerState<InvisibleGardenZone> createState() =>
      _InvisibleGardenZoneState();
}

class _InvisibleGardenZoneState extends ConsumerState<InvisibleGardenZone> {
  // ClÃƒÂ© globale pour contrÃƒÂ´ler l'animation insecte

  final GlobalKey<InsectAwakeningWidgetState> _awakeningKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // âÅ“… RÃƒÂ©cupÃƒÂ©ration du jardin pour ce slot (LOGIQUE CONSERVÃƒâ€°E)

    final garden = _getGardenForSlot(ref);

    // âÅ“… VÃƒÂ©rification ÃƒÂ©tat actif (LOGIQUE CONSERVÃƒâ€°E)

    final isActive = _isGardenActive(ref, garden);

    // Identifiant de zone pour le drag (format: JARDIN_X)

    final zoneId = 'JARDIN_${widget.slotNumber}';

    return Positioned.fromRect(
      rect: widget.zone,
      child: InsectAwakeningWidget(
        key: _awakeningKey,

        particleColor: widget.glowColor,

        gardenId: garden?.id ??
            'slot_${widget.slotNumber}', // NOUVEAU : passer l'ID du jardin

        enabled: !widget.isCalibrationMode,

        child: GestureDetector(
          // âÅ“… Interactions conservÃƒÂ©es

          onTap: widget.isCalibrationMode
              ? null
              : () => _handleTap(context, ref, garden),

          onLongPress: widget.isCalibrationMode
              ? null
              : () => _handleLongPress(context, ref, garden),

          // âÅ“… NOUVEAUX GESTURES : Drag & Drop pour calibration

          onPanStart: widget.isCalibrationMode && widget.onPanStart != null
              ? (details) => widget.onPanStart!(zoneId, details)
              : null,

          onPanUpdate: widget.isCalibrationMode && widget.onPanUpdate != null
              ? (details) {
                  final screenWidth = MediaQuery.of(context).size.width;

                  final screenHeight = MediaQuery.of(context).size.height;

                  widget.onPanUpdate!(
                      zoneId, details, screenWidth, screenHeight);
                }
              : null,

          onPanEnd: widget.isCalibrationMode && widget.onPanEnd != null
              ? (details) => widget.onPanEnd!(zoneId, details)
              : null,

          child: Stack(
            children: [
              // âÅ“… NOUVEAU : Zone invisible (base) ou visible en mode calibration

              Container(
                decoration: BoxDecoration(
                  // Mode calibration : afficher cadre pointillÃƒÂ©

                  border: widget.isCalibrationMode
                      ? Border.all(
                          color: Colors.cyan.withValues(alpha: 0.6),
                          width: 2,
                        )
                      : null,

                  // Mode normal : transparent total

                  color: widget.isCalibrationMode
                      ? Colors.cyan.withValues(alpha: 0.1)
                      : Colors.transparent,
                ),
              ),

              // âÅ“… NOUVEAU : Lueur organique animÃƒÂ©e (SI ACTIF UNIQUEMENT et PAS en mode calibration)

              if (isActive && !widget.isCalibrationMode)
                _OrganicGlowAnimation(glowColor: widget.glowColor),

              // âÅ“… Label : soit jardin existant, soit nom du slot en calibration

              if (widget.isCalibrationMode)
                Center(
                  child: Text(
                    garden?.name ?? 'Slot ${widget.slotNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (garden != null)
                Center(child: _buildDiscreetLabel(garden, isActive)),
            ],
          ),
        ),
      ),
    );
  }

  // â•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Â

  // MÃƒâ€°THODES CONSERVÃƒâ€°ES DE GardenBubbleWidget

  // â•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Ââ•Â

  /// RÃƒÂ©cupÃƒÂ¨re le jardin associÃƒÂ© ÃƒÂ  ce slot

  /// Dans le nouveau systÃƒÂ¨me, on utilise l'ordre des jardins pour les associer aux slots

  GardenFreezed? _getGardenForSlot(WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);

    final activeGardens = gardenState.activeGardens;

    // 1) Si la box dashboard_slots est prête, tenter la lecture persistante (prévalente)

    final mappedId =
        DashboardSlotsRepository.getGardenIdForSlotSync(widget.slotNumber);

    if (mappedId != null) {
      final matches = activeGardens.where((g) => g.id == mappedId).toList();

      if (matches.isNotEmpty) return matches.first;

      // mappedId existe mais jardin non chargé -> fallback index
    }

    // 2) Fallback : associer les jardins actifs aux slots par ordre d'index (ancienne logique)

    if (widget.slotNumber > 0 && widget.slotNumber <= activeGardens.length) {
      return activeGardens[widget.slotNumber - 1];
    }

    return null; // Aucun jardin pour ce slot
  }

  /// VÃƒÂ©rifie si ce jardin est actuellement actif

  bool _isGardenActive(WidgetRef ref, GardenFreezed? garden) {
    if (garden == null) return false;

    final activeGardenId = ref.watch(activeGardenIdProvider);

    return activeGardenId == garden.id;
  }

  /// GÃƒÂ¨re le tap simple : ouvre le jardin OU crÃƒÂ©e un nouveau jardin

  Future<void> _handleTap(
      BuildContext context, WidgetRef ref, GardenFreezed? garden) async {
    HapticFeedback.lightImpact();

    // DÃƒÂ©clencher l'animation insecte

    final awakeningState = _awakeningKey.currentState;

    if (awakeningState != null) {
      await awakeningState.triggerAnimation();

      // Petit dÃƒÂ©lai pour laisser l'animation commencer

      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (garden != null) {
      // Ouvrir le jardin existant avec gestion d'erreur

      try {
        if (!context.mounted) return;

        context.push('/gardens/${garden.id}');
      } catch (e) {
        // Afficher un message contextuel si le jardin est introuvable

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jardin introuvable: ${garden.name}'),
            backgroundColor: Colors.red.shade400,
            duration: const Duration(seconds: 2),
          ),
        );

        debugPrint('âÂÅ’ Erreur navigation jardin ${garden.id}: $e');
      }
    } else {
      // CrÃƒÂ©er un nouveau jardin pour ce slot

      if (context.mounted) {
        _showCreateGardenDialog(context, ref);
      }
    }
  }

  /// GÃƒÂ¨re le long press : active le jardin

  Future<void> _handleLongPress(
      BuildContext context, WidgetRef ref, GardenFreezed? garden) async {
    if (garden == null) return;

    HapticFeedback.mediumImpact(); // Feedback plus fort pour le long press

    // DÃƒÂ©clencher l'animation insecte

    final awakeningState = _awakeningKey.currentState;

    await awakeningState?.triggerAnimation();

    // Activer ce jardin comme jardin courant

    ref.read(activeGardenIdProvider.notifier).setActiveGarden(garden.id);

    // Feedback visuel optionnel (SnackBar)

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${garden.name} activÃƒÂ© comme jardin courant'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Affiche le dialogue de création de jardin
  void _showCreateGardenDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implémenter le dialogue de création

    // navigation vers la page de création en push (réversible)

    final uri = Uri(
      path: AppRoutes.gardenCreate,
      queryParameters: {'slot': widget.slotNumber.toString()},
    ).toString();
    context.push(uri);
  }

  /// Construit le label de texte discret

  Widget _buildDiscreetLabel(GardenFreezed garden, bool isActive) {
    return AnimatedDefaultTextStyle(
      duration: GardenLabelStyle.transitionDuration,
      curve: GardenLabelStyle.transitionCurve,
      style: TextStyle(
        color: Colors.white.withValues(
            alpha: isActive
                ? GardenLabelStyle.activeOpacity
                : GardenLabelStyle.discreetOpacity),
        fontSize: isActive
            ? GardenLabelStyle.activeFontSize
            : GardenLabelStyle.discreetFontSize,
        fontWeight: isActive
            ? GardenLabelStyle.activeWeight
            : GardenLabelStyle.discreetWeight,
        shadows: const [GardenLabelStyle.textShadow],
      ),
      child: Text(
        garden.name,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Animation de respiration organique pour la lueur des jardins actifs

class _OrganicGlowAnimation extends StatefulWidget {
  final Color glowColor;

  const _OrganicGlowAnimation({required this.glowColor});

  @override
  _OrganicGlowAnimationState createState() => _OrganicGlowAnimationState();
}

class _OrganicGlowAnimationState extends State<_OrganicGlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: OrganicBreathAnimation.cycleDuration,
      vsync: this,
    )..repeat(reverse: true); // âÅ“… Boucle infinie aller-retour

    _animation = CurvedAnimation(
      parent: _controller,
      curve: OrganicBreathAnimation.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calcul des valeurs animÃƒÂ©es

        final opacity = OrganicBreathAnimation.minOpacity +
            (_animation.value * OrganicBreathAnimation.opacityAmplitude);

        final blurRadius = OrganicBreathAnimation.minBlurRadius +
            (_animation.value * OrganicBreathAnimation.blurAmplitude);

        final spreadRadius = OrganicBreathAnimation.minSpreadRadius +
            (_animation.value * OrganicBreathAnimation.spreadAmplitude);

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(opacity),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // âÅ“… CRITIQUE : ÃƒÂ©viter fuite mÃƒÂ©moire

    super.dispose();
  }
}
