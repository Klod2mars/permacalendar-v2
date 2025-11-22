// lib/features/home/widgets/invisible_garden_zone.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import '../../../core/repositories/dashboard_slots_repository.dart';
import '../../../core/data/hive/garden_boxes.dart';
import '../../../core/adapters/garden_migration_adapters.dart';
import '../../../core/providers/active_garden_provider.dart';
import '../../../core/models/garden_freezed.dart';
import '../../../shared/presentation/themes/organic_palettes.dart';
import '../../../shared/widgets/animations/insect_awakening_widget.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';

/// Widget de zone interactive invisible pour un slot jardin
/// Remplace GardenBubbleWidget avec une approche "invisible + lueur"
class InvisibleGardenZone extends ConsumerStatefulWidget {
  final int slotNumber;
  final Rect zone; // Position et taille en pixels absolus
  final Color glowColor; // Couleur de la lueur pour ce jardin

  // Nouveaux paramètres pour calibration
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
  // Clé globale pour contrôler l'animation insecte
  final GlobalKey<InsectAwakeningWidgetState> _awakeningKey = GlobalKey();

  // --- AJOUT: mémoriser dernier point local de tap pour valider la hit area circulaire
  Offset? _lastLocalTapPosition;

  // --- AJOUT: utilitaire pour vérifier si un point local est dans le cercle
  bool _isPointInsideCircle(Offset localPos, Size circleSize) {
    final center = Offset(circleSize.width / 2, circleSize.height / 2);
    final radius = min(circleSize.width, circleSize.height) / 2;
    return (localPos - center).distance <= radius;
  }

  @override
  Widget build(BuildContext context) {
    // Récupération du jardin pour ce slot
    final garden = _getGardenForSlot(ref);

    // Vérification état actif
    final isActive = _isGardenActive(ref, garden);

    // Identifiant de zone pour le drag (format: JARDIN_X)
    final zoneId = 'JARDIN_${widget.slotNumber}';

    // Diamètre pour la bulle : 75% du plus petit côté du rect (pour être 1/4 plus petit)
    final diameter = min(widget.zone.width, widget.zone.height) * 0.75;

    // Debug/log AFTER avoir calculé isActive et diameter
    debugPrint(
      '[Audit] InvisibleGardenZone build slot=${widget.slotNumber} '
      'gardenId=${garden?.id} isCalibration=${widget.isCalibrationMode} '
      'isActive=$isActive diameter=$diameter',
    );

    return Positioned.fromRect(
      rect: widget.zone,
      child: ClipOval(
        // clippe la peinture pour éviter tout débordement carré
        child: InsectAwakeningWidget(
          key: _awakeningKey,
          particleColor: widget.glowColor,
          gardenId: garden?.id ?? 'slot_${widget.slotNumber}',
          enabled: !widget.isCalibrationMode,
          child: Center(
            child: SizedBox(
              width: diameter,
              height: diameter,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,

                // Pour que la zone tactile corresponde parfaitement au rond,
                // on mémorise la position locale du tap et on valide via distance
                onTapDown: (details) {
                  _lastLocalTapPosition = details.localPosition;
                },

                // Sécurité: si le tap est annulé, on reset la position
                onTapCancel: () {
                  _lastLocalTapPosition = null;
                },

                onTap: () {
                  if (_lastLocalTapPosition != null &&
                      _isPointInsideCircle(
                          _lastLocalTapPosition!, Size(diameter, diameter))) {
                    if (!widget.isCalibrationMode) {
                      _handleTap(context, ref, garden);
                    }
                  }
                  _lastLocalTapPosition = null;
                },
                onLongPressStart: (details) {
                  if (_isPointInsideCircle(
                      details.localPosition, Size(diameter, diameter))) {
                    if (!widget.isCalibrationMode) {
                      _handleLongPress(context, ref, garden);
                    }
                  }
                },

                // Calibration gestures (conserve le comportement)
                onPanStart:
                    widget.isCalibrationMode && widget.onPanStart != null
                        ? (details) => widget.onPanStart!(zoneId, details)
                        : null,
                onPanUpdate: widget.isCalibrationMode &&
                        widget.onPanUpdate != null
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
                  alignment: Alignment.center,
                  children: [
                    // Cercle de base (visible uniquement en calibration)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: widget.isCalibrationMode
                            ? Border.all(
                                color:
                                    Colors.cyan.withAlpha((0.6 * 255).round()),
                                width: 2,
                              )
                            : null,
                        color: widget.isCalibrationMode
                            ? Colors.cyan.withAlpha((0.08 * 255).round())
                            : Colors.transparent,
                      ),
                    ),

                    // L'étiquette discrète (si nécessaire)
                    if (widget.isCalibrationMode)
                      Center(
                        child: Text(
                          garden?.name ?? 'Slot ${widget.slotNumber}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (garden != null)
                      Center(child: _buildDiscreetLabel(garden, isActive)),
                    // Note : l'animation visuelle (flame) est dessinée par InsectAwakeningWidget
                    // et, grâce au ClipOval, restera ronde et ne dépassera pas en coins carrés.
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Récupère le jardin associé à ce slot
  /// Dans le nouveau système, on utilise l'ordre des jardins pour les associer aux slots
  GardenFreezed? _getGardenForSlot(WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    final activeGardens = gardenState.activeGardens;

    // 1) Si la box dashboard_slots est prête, tenter la lecture persistante (prévalente)
    final mappedId =
        DashboardSlotsRepository.getGardenIdForSlotSync(widget.slotNumber);
    if (mappedId != null) {
      final matches = activeGardens.where((g) => g.id == mappedId).toList();
      if (matches.isNotEmpty) return matches.first;

      // mappedId existe mais jardin non chargé -> tenter résolution legacy (synchronique)
      // Si l'ID pointe vers un ancien modèle Garden (box 'gardens'), on le récupère
      // et le convertit en GardenFreezed via GardenMigrationAdapters.
      try {
        final legacyGarden = GardenBoxes.getGarden(mappedId);
        if (legacyGarden != null) {
          return GardenMigrationAdapters.fromLegacy(legacyGarden);
        }
      } catch (e) {
        // Logging léger ; on continue le fallback index ci-dessous
        debugPrint(
            '[InvisibleGardenZone] legacy lookup failed for $mappedId: $e');
      }

      // mappedId existe mais jardin non chargé -> fallback index
    }

    // 2) Fallback : associer les jardins actifs aux slots par ordre d'index (ancienne logique)
    if (widget.slotNumber > 0 && widget.slotNumber <= activeGardens.length) {
      return activeGardens[widget.slotNumber - 1];
    }

    return null; // Aucun jardin pour ce slot
  }

  /// Vérifie si ce jardin est actuellement actif
  bool _isGardenActive(WidgetRef ref, GardenFreezed? garden) {
    if (garden == null) return false;

    final activeGardenId = ref.watch(activeGardenIdProvider);
    return activeGardenId == garden.id;
  }

  /// Gère le tap simple : ouvre le jardin OU crée un nouveau jardin
  Future<void> _handleTap(
      BuildContext context, WidgetRef ref, GardenFreezed? garden) async {
    HapticFeedback.lightImpact();

    // Déclencher l'animation insecte
    final awakeningState = _awakeningKey.currentState;
    if (awakeningState != null) {
      await awakeningState.triggerAnimation();
      // Petit délai pour laisser l'animation commencer
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (garden != null) {
      // Ouvrir le jardin existant avec gestion d'erreur
      try {
        if (!context.mounted) {
          return;
        }
        context.push('/gardens/${garden.id}');
      } catch (e) {
        // Afficher un message contextuel si le jardin est introuvable
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jardin introuvable: ${garden.name}'),
            backgroundColor: Colors.red.shade400,
            duration: const Duration(seconds: 2),
          ),
        );
        debugPrint('✖ Erreur navigation jardin ${garden.id}: $e');
      }
    } else {
      // Créer un nouveau jardin pour ce slot
      if (context.mounted) {
        _showCreateGardenDialog(context, ref);
      }
    }
  }

  /// Gère le long press : active le jardin
  Future<void> _handleLongPress(
      BuildContext context, WidgetRef ref, GardenFreezed? garden) async {
    if (garden == null) return;

    HapticFeedback.mediumImpact(); // Feedback plus fort pour le long press

    // Audit log avant action
    debugPrint(
        '[Audit] InvisibleGardenZone longPress slot=${widget.slotNumber} gardenId=${garden.id} gardenName=${garden.name}');

    // Déclencher l'animation insecte
    final awakeningState = _awakeningKey.currentState;
    await awakeningState?.triggerAnimation();

    // Activer ce jardin comme jardin courant
    debugPrint(
        '[Audit] InvisibleGardenZone calling setActiveGarden for ${garden.id}');
    ref.read(activeGardenIdProvider.notifier).setActiveGarden(garden.id);
    debugPrint(
        '[Audit] InvisibleGardenZone setActiveGarden called for ${garden.id}');

    // Feedback visuel optionnel (SnackBar)
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${garden.name} activé comme jardin courant'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Affiche le dialogue de création de jardin
  void _showCreateGardenDialog(BuildContext context, WidgetRef ref) {
    // Pour l'instant, navigation vers la page de création
    context.go('/gardens/create?slot=${widget.slotNumber}');
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
