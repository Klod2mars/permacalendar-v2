// lib/features/home/widgets/invisible_garden_zone.dart
//
// InvisibleGardenZone — parent d'une "bulle" de jardin.
// - Déclare une GlobalKey<InsectAwakeningWidgetState> en champ du State,
//   monte InsectAwakeningWidget(key: _awakeningKey, useOverlay: true)
// - Défensif : logs détaillés (Audit A/B/C), fallback visible si Size == 0,
//   GestureDetector avec HitTestBehavior.translucent.
// - Ajuste les imports / types selon ton projet.
//
// A ADAPTER :
// - Vérifie le chemin d'import de InsectAwakeningWidget et active useOverlay si tu veux échapper au clipping.
// - Si tu as un type Garden, remplace `dynamic garden` par `Garden garden` partout.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ajuste ce chemin si nécessaire (chemin observé dans ton repo)
import 'package:permacalendar/shared/widgets/animations/insect_awakening_widget.dart';

// Ajuste le chemin de ton provider si besoin
import 'package:permacalendar/core/providers/active_garden_provider.dart';

/// Parent widget qui occupe une zone cliquable/long-pressable pour un garden.
class InvisibleGardenZone extends ConsumerStatefulWidget {
  // `garden` est typé dynamic pour éviter d'imposer ton modèle exact ici.
  final dynamic garden;
  final int slotNumber;
  final Rect zoneRect; // position/size à utiliser pour le Positioned

  const InvisibleGardenZone({
    Key? key,
    required this.garden,
    required this.slotNumber,
    required this.zoneRect,
  }) : super(key: key);

  @override
  _InvisibleGardenZoneState createState() => _InvisibleGardenZoneState();
}

class _InvisibleGardenZoneState extends ConsumerState<InvisibleGardenZone> {
  // -------------------- IMPORTANT --------------------
  // GlobalKey MUST be a field of State (not recreated in build()):
  final GlobalKey<InsectAwakeningWidgetState> _awakeningKey =
      GlobalKey<InsectAwakeningWidgetState>();
  // --------------------------------------------------

  @override
  void initState() {
    super.initState();
    debugPrint(
        '[Audit] InvisibleGardenZone.initState slot=${widget.slotNumber} garden=${widget.garden?.id}');
  }

  @override
  void didUpdateWidget(covariant InvisibleGardenZone oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Log utile lors des rebuilds / changements de garden
    debugPrint(
        '[Audit] InvisibleGardenZone.didUpdateWidget slot=${widget.slotNumber} oldGarden=${oldWidget.garden?.id} newGarden=${widget.garden?.id}');
  }

  @override
  Widget build(BuildContext context) {
    // Log build : utile pour confirmer que la zone est montée et quelle clé est utilisée
    debugPrint(
        '[Audit] InvisibleGardenZone build slot=${widget.slotNumber} garden=${widget.garden?.id} awakeningKey=$_awakeningKey');

    // Use Positioned.fromRect so the caller can place this zone inside a Stack
    return Positioned.fromRect(
      rect: widget.zoneRect,
      child: GestureDetector(
        behavior:
            HitTestBehavior.translucent, // important pour capter le long press
        onLongPress: _handleLongPress,
        child: Stack(
          children: [
            // --- 1) Ton contenu visible habituel (icône/bulle) ---
            // Ici, tu dois replacer le rendu réel de la bulle.
            // J'ajoute un Container transparent pour garder la hitbox si nécessaire.
            // Tu peux remplacer ce Container par ton widget existant.
            Positioned.fill(
              child: Container(
                // Transparence totale mais conserve la zone cliquable
                color: Colors.transparent,
              ),
            ),

            // --- 2) InsectAwakeningWidget monté avec la clé --
            // Cette instance fournit triggerAnimation() & forcePersistent()
            // NOTE: useOverlay:true permet d'échapper au clipping du parent.
            InsectAwakeningWidget(
              key: _awakeningKey,
              gardenId: widget.garden?.id?.toString() ??
                  'unknown_garden_${widget.slotNumber}',
              useOverlay: true,
              fallbackSize: widget.zoneRect.size.shortestSide,
            ),

            // --- 3) Debug fallback (optionnel) ---
            // si tu as besoin d'un indicateur visuel léger du slot pendant debug,
            // décommente la ligne suivante:
            // Positioned(
            //   right: 2, top: 2,
            //   child: Container(width:8,height:8,decoration:BoxDecoration(shape:BoxShape.circle,color:Colors.red.withOpacity(0.6))),
            // ),
          ],
        ),
      ),
    );
  }

  /// _handleLongPress : version défensive avec logs A
  void _handleLongPress() {
    final garden = widget.garden;
    final rect = widget.zoneRect;

    debugPrint(
        '[Audit] InvisibleGardenZone longPress slot=${widget.slotNumber} garden.id=${garden?.id} rect=$rect');

    // Check the awakeningKey.currentState (log A)
    final awakeningState = _awakeningKey.currentState;
    debugPrint('[Audit] awakeningKey.currentState => $awakeningState');

    // 1) activate the garden via provider (log the result)
    try {
      // ATTENTION: adapte cette ligne si ton provider a une API différente
      ref.read(activeGardenIdProvider.notifier).setActiveGarden(garden.id);
      final now = ref.read(activeGardenIdProvider);
      debugPrint(
          '[Audit] setActiveGarden called with=${garden.id}, provider now=$now');
    } catch (e, st) {
      debugPrint('[Audit] setActiveGarden ERROR: $e\n$st');
    }

    // 2) If InsectAwakeningWidget is mounted, call its public API
    if (awakeningState != null) {
      try {
        awakeningState.triggerAnimation();
        awakeningState.forcePersistent();
        debugPrint(
            '[Audit] Called triggerAnimation & forcePersistent on awakeningState for garden=${garden?.id}');
      } catch (e, st) {
        debugPrint('[Audit] awakeningState call error: $e\n$st');
      }
      return;
    }

    // 3) Fallback: awakeningState == null
    debugPrint(
        '[Audit] awakeningState was null - the InsectAwakeningWidget is not mounted for garden=${garden?.id}');

    // Fallback visual: create a short overlay so you see something immediately.
    // This overlay is purely for debug; remove when not needed.
    _showDebugOverlay(rect, duration: const Duration(milliseconds: 700));
  }

  /// Small debug overlay to show an immediate circle when the widget is not mounted.
  void _showDebugOverlay(Rect rect,
      {Duration duration = const Duration(milliseconds: 700)}) {
    final overlay = Overlay.of(context);
    if (overlay == null) {
      debugPrint(
          '[Audit] _showDebugOverlay: Overlay.of(context) returned null');
      return;
    }
    final overlayEntry = OverlayEntry(builder: (ctx) {
      return Positioned(
        left: rect.left,
        top: rect.top,
        width: rect.width,
        height: rect.height,
        child: IgnorePointer(
          ignoring: true,
          child: Center(
            child: Container(
              width: rect.width * 0.9,
              height: rect.height * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.withOpacity(0.22),
                border:
                    Border.all(color: Colors.orange.withOpacity(0.6), width: 2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.orange.withOpacity(0.35),
                      blurRadius: 18,
                      spreadRadius: 4),
                ],
              ),
            ),
          ),
        ),
      );
    });

    try {
      overlay.insert(overlayEntry);
      Future.delayed(duration, () {
        try {
          overlayEntry.remove();
        } catch (e, st) {
          debugPrint('[Audit] _showDebugOverlay remove error: $e\n$st');
        }
      });
      debugPrint('[Audit] _showDebugOverlay inserted at $rect');
    } catch (e, st) {
      debugPrint('[Audit] _showDebugOverlay insert error: $e\n$st');
    }
  }

  @override
  void dispose() {
    // If the awakening widget is persistent, ask it to stop (defensive).
    try {
      _awakeningKey.currentState?.stopPersistent();
      debugPrint(
          '[Audit] _InvisibleGardenZoneState.dispose - requested stopPersistent on awakeningState for garden=${widget.garden?.id}');
    } catch (e, st) {
      debugPrint('[Audit] dispose: stopPersistent error: $e\n$st');
    }
    super.dispose();
  }
}
