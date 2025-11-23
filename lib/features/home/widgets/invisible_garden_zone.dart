// lib/features/home/widgets/invisible_garden_zone.dart
//
// InvisibleGardenZone — parent d'une "bulle" de jardin.
// Version mise à jour :
// - Utilise toggleActiveGarden() au lieu d'appels ad hoc.
// - S'enregistre dans gardenAwakeningRegistryProvider pour orchestration synchrone.
// - Fournit un LayerLink pour que l'overlay suive la bulle (CompositedTransformTarget/Follower).
// - Défensif : fallback overlay temporaire si InsectAwakeningWidget n'est pas monté.
// - Logs réduits (kDebugMode).
//

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ajuste le chemin si nécessaire (doit correspondre à ton arborescence)
import 'package:permacalendar/shared/widgets/animations/insect_awakening_widget.dart';
import 'package:permacalendar/core/providers/active_garden_provider.dart';
import 'package:permacalendar/core/providers/garden_awakening_registry.dart';

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
  // LayerLink so the overlay created by InsectAwakeningWidget can follow this widget
  final LayerLink _layerLink = LayerLink();
  // --------------------------------------------------

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint(
          '[Audit] InvisibleGardenZone.initState slot=${widget.slotNumber} garden=${widget.garden?.id}');
    }

    // If garden is already present at mount, try to register in the registry.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gid = _gardenIdFromWidget();
      if (gid != null) {
        try {
          ref
              .read(gardenAwakeningRegistryProvider)
              .register(gid, _awakeningKey);
          if (kDebugMode)
            debugPrint('[Audit] registered awakeningKey at init for $gid');
        } catch (e) {
          if (kDebugMode)
            debugPrint('[Audit] registry register error at init: $e');
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant InvisibleGardenZone oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Log utile lors des rebuilds / changements de garden
    if (kDebugMode) {
      debugPrint(
          '[Audit] InvisibleGardenZone.didUpdateWidget slot=${widget.slotNumber} oldGarden=${oldWidget.garden?.id} newGarden=${widget.garden?.id}');
    }

    final oldGid = _gardenIdFromDynamic(oldWidget.garden);
    final newGid = _gardenIdFromWidget();

    // If garden changed, update registry accordingly
    if (oldGid != newGid) {
      if (oldGid != null) {
        try {
          ref.read(gardenAwakeningRegistryProvider).unregister(oldGid);
          if (kDebugMode)
            debugPrint('[Audit] unregistered old awakeningKey for $oldGid');
        } catch (e) {
          if (kDebugMode) debugPrint('[Audit] registry unregister error: $e');
        }
      }
      if (newGid != null) {
        try {
          ref
              .read(gardenAwakeningRegistryProvider)
              .register(newGid, _awakeningKey);
          if (kDebugMode)
            debugPrint('[Audit] registered awakeningKey for new $newGid');
        } catch (e) {
          if (kDebugMode) debugPrint('[Audit] registry register error: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    // If the awakening widget is persistent, ask it to stop (defensive).
    try {
      _awakeningKey.currentState?.stopPersistent();
      if (kDebugMode)
        debugPrint(
            '[Audit] dispose requested stopPersistent for garden=${widget.garden?.id}');
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Audit] dispose: stopPersistent error: $e\n$st');
    }

    // Unregister from registry if present
    final gid = _gardenIdFromWidget();
    if (gid != null) {
      try {
        ref.read(gardenAwakeningRegistryProvider).unregister(gid);
        if (kDebugMode)
          debugPrint('[Audit] dispose: unregistered awakeningKey for $gid');
      } catch (e) {
        if (kDebugMode)
          debugPrint('[Audit] dispose: registry unregister error: $e');
      }
    }

    super.dispose();
  }

  /// Helper: extract gardenId string from widget.garden if possible.
  String? _gardenIdFromWidget() => _gardenIdFromDynamic(widget.garden);

  String? _gardenIdFromDynamic(dynamic g) {
    try {
      if (g == null) return null;
      // Try common patterns
      if (g is String) return g;
      if (g is Map && g.containsKey('id')) return g['id']?.toString();
      if (g is Object) {
        // Reflection-free attempt: check .id property if accessible
        final dyn = g;
        try {
          // ignore: avoid_dynamic_calls
          final idVal = dyn.id;
          return idVal?.toString();
        } catch (_) {
          return null;
        }
      }
    } catch (_) {}
    return null;
  }

  /// Handle long press: toggle the active garden via provider (atomic),
  /// and orchestrate registry for synchronous start/stop of overlays.
  void _handleLongPress() {
    final garden = widget.garden;
    final rect = widget.zoneRect;

    if (kDebugMode) {
      debugPrint(
          '[Audit] InvisibleGardenZone longPress slot=${widget.slotNumber} garden.id=${garden?.id}');
      debugPrint(
          '[Audit] awakeningKey.currentState => ${_awakeningKey.currentState}');
    }

    final gardenId = _gardenIdFromWidget();
    if (gardenId == null) {
      // No garden assigned: show temporary overlay as feedback
      _showDebugOverlay(rect, duration: const Duration(milliseconds: 700));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun jardin assigné à ce slot')),
      );
      return;
    }

    try {
      // 1) Toggle active garden (atomic)
      ref.read(activeGardenIdProvider.notifier).toggleActiveGarden(gardenId);

      // 2) Read the new state synchronously
      final now = ref.read(activeGardenIdProvider);

      // 3) If we just activated this garden, stop others synchronously then force persistent for this one.
      if (now == gardenId) {
        try {
          ref.read(gardenAwakeningRegistryProvider).stopAllExcept(gardenId);
        } catch (e) {
          if (kDebugMode)
            debugPrint('[Audit] registry stopAllExcept error: $e');
        }
        // Try to force persistent synchronously via registry (if state available)
        try {
          ref
              .read(gardenAwakeningRegistryProvider)
              .forcePersistentFor(gardenId);
        } catch (e) {
          if (kDebugMode)
            debugPrint('[Audit] registry forcePersistentFor error: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Jardin $gardenId activé'),
              duration: const Duration(seconds: 2)),
        );
      } else {
        // It was toggled off — ensure we stop persistent if any
        try {
          ref.read(gardenAwakeningRegistryProvider).stopPersistentFor(gardenId);
        } catch (e) {
          if (kDebugMode)
            debugPrint('[Audit] registry stopPersistentFor error: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Jardin $gardenId désactivé'),
              duration: const Duration(seconds: 1)),
        );
      }

      // 4) Trigger a short animation locally if InsectAwakeningWidget is mounted.
      final awakeningState = _awakeningKey.currentState;
      if (awakeningState != null) {
        try {
          awakeningState.triggerAnimation();
        } catch (e, st) {
          if (kDebugMode)
            debugPrint(
                '[Audit] awakeningState.triggerAnimation error: $e\n$st');
        }
      } else {
        // If the widget is not mounted, show the debug overlay for visual feedback
        _showDebugOverlay(rect, duration: const Duration(milliseconds: 700));
      }
    } catch (e, st) {
      if (kDebugMode) debugPrint('[Audit] _handleLongPress error: $e\n$st');
    }
  }

  /// Small debug overlay to show an immediate circle when the widget is not mounted.
  /// This overlay is purely for debug; remove or reduce when not needed.
  void _showDebugOverlay(Rect rect,
      {Duration duration = const Duration(milliseconds: 700)}) {
    final overlay = Overlay.of(context);
    if (overlay == null) {
      if (kDebugMode)
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
        } catch (e) {
          if (kDebugMode)
            debugPrint('[Audit] _showDebugOverlay remove error: $e');
        }
      });
      if (kDebugMode) debugPrint('[Audit] _showDebugOverlay inserted at $rect');
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Audit] _showDebugOverlay insert error: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Positioned.fromRect so the caller can place this zone inside a Stack
    return Positioned.fromRect(
      rect: widget.zoneRect,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          behavior: HitTestBehavior
              .translucent, // important pour capter le long press
          onLongPress: _handleLongPress,
          child: Stack(
            children: [
              // --- 1) Ton contenu visible habituel (icône/bulle) ---
              // Ici, tu dois replacer le rendu réel de la bulle.
              // J'ajoute un Container transparent pour garder la hitbox si nécessaire.
              Positioned.fill(
                child: Container(
                  // Transparence totale mais conserve la zone cliquable
                  color: Colors.transparent,
                ),
              ),

              // --- 2) InsectAwakeningWidget monté avec la clé + layerLink --
              // Cette instance fournit triggerAnimation() & forcePersistent().
              // NOTE: useOverlay:true permet d'échapper au clipping du parent.
              InsectAwakeningWidget(
                key: _awakeningKey,
                gardenId: widget.garden?.id?.toString() ??
                    'unknown_garden_${widget.slotNumber}',
                useOverlay: true,
                layerLink: _layerLink,
                fallbackSize: widget.zoneRect.size.shortestSide,
              ),

              // --- 3) Optional debug marker ---
              // si tu as besoin d'un indicateur visuel léger du slot pendant debug,
              // décommente la ligne suivante:
              // Positioned(
              //   right: 2, top: 2,
              //   child: Container(width:8,height:8,decoration:BoxDecoration(shape:BoxShape.circle,color:Colors.red.withOpacity(0.6))),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
