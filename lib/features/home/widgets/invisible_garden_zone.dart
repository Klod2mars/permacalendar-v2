// lib/features/home/widgets/invisible_garden_zone.dart
//
// InvisibleGardenZone — parent d'une "bulle" de jardin.
// Version finale adaptée au nouveau ActiveGardenIdNotifier:
// - Utilise toggleActiveGarden() (le provider orchestre la registry).
// - S'enregistre / se désenregistre dans gardenAwakeningRegistryProvider.
// - Fournit LayerLink pour que l'Overlay suive la bulle.
// - Debounce des long-press pour éviter doubles toggles.
// - Fallback pour slot -> getGardenIdForSlot.
// - Logs réduits mais informatifs (kDebugMode).
//

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// InsectAwakeningWidget - assure-toi que ce chemin package: est correct
import 'package:permacalendar/shared/widgets/animations/insect_awakening_widget.dart';
import 'package:permacalendar/core/providers/active_garden_provider.dart';
import 'package:permacalendar/core/providers/garden_awakening_registry.dart';
import 'package:permacalendar/core/repositories/dashboard_slots_repository.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';

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

  // Debounce to block rapid toggles
  DateTime? _lastToggleAt;
  // --------------------------------------------------

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint(
          '[Audit] InvisibleGardenZone.initState slot=${widget.slotNumber} garden=${widget.garden?.id}');
    }

    // Register if garden available at mount
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
    if (kDebugMode) {
      debugPrint(
          '[Audit] InvisibleGardenZone.didUpdateWidget slot=${widget.slotNumber} oldGarden=${oldWidget.garden?.id} newGarden=${widget.garden?.id}');
    }

    final oldGid = _gardenIdFromDynamic(oldWidget.garden);
    final newGid = _gardenIdFromWidget();

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
    // Defensive: stop persistent if mounted
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
      if (g is String) return g;
      if (g is Map && g.containsKey('id')) return g['id']?.toString();
      // Reflection-free attempt to access `.id` if present
      try {
        // ignore: avoid_dynamic_calls
        final idVal = g.id;
        return idVal?.toString();
      } catch (_) {
        return null;
      }
    } catch (_) {}
    return null;
  }

  /// Handle long press: toggleActiveGarden via provider (atomic).
  /// Debounce to avoid double toggles. Provide fallback when no garden assigned.
  Future<void> _handleLongPress() async {
    // Debounce : ignore multiple rapid activations
    final now = DateTime.now();
    if (_lastToggleAt != null &&
        now.difference(_lastToggleAt!) < const Duration(milliseconds: 350)) {
      if (kDebugMode)
        debugPrint(
            '[Insect] ignoring rapid longPress for slot=${widget.slotNumber}');
      return;
    }
    _lastToggleAt = now;

    String? gardenId = _gardenIdFromWidget();

    // If not in widget.garden, try resolving via slots repository
    if (gardenId == null) {
      try {
        gardenId = await DashboardSlotsRepository.getGardenIdForSlot(
            widget.slotNumber);
      } catch (e, st) {
        if (kDebugMode)
          debugPrint(
              '[Insect][resolve] error resolving garden for slot ${widget.slotNumber}: $e\n$st');
      }
    }

    if (gardenId == null) {
      // No garden assigned: visual feedback and message
      _showDebugOverlay(widget.zoneRect,
          duration: const Duration(milliseconds: 700));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun jardin assigné à ce slot')),
      );
      return;
    }

    // Select the garden for context (UI state)
    try {
      ref.read(gardenProvider.notifier).selectGarden(gardenId);
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Insect][select] selectGarden error: $e\n$st');
    }

    // Toggle atomically via provider. The provider will orchestrate registry stop/force.
    try {
      ref.read(activeGardenIdProvider.notifier).toggleActiveGarden(gardenId);
      if (kDebugMode)
        debugPrint('[Insect][activate] toggleActiveGarden -> $gardenId');
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Insect][activate] error toggling active garden: $e\n$st');
    }

    // Read the new state to decide local actions (feedback)
    final nowActive = ref.read(activeGardenIdProvider);

    if (nowActive == gardenId) {
      // Activated — provide feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Jardin $gardenId activé'),
            duration: const Duration(seconds: 2)),
      );
    } else {
      // Deactivated — ensure local awakening widget stops as defensive measure
      try {
        _awakeningKey.currentState?.stopPersistent();
      } catch (e, st) {
        if (kDebugMode)
          debugPrint(
              '[Insect][activate] awakeningKey.stopPersistent error: $e\n$st');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Jardin $gardenId désactivé'),
            duration: const Duration(seconds: 1)),
      );
    }

    // Trigger a short animation for immediate feedback (if mounted)
    try {
      _awakeningKey.currentState?.triggerAnimation();
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Insect][trigger] triggerAnimation error: $e\n$st');
    }
  }

  /// Small debug overlay to show an immediate circle when the widget is not mounted.
  /// This overlay is purely for debug; keep rect log for diagnosis of mega-spheres.
  void _showDebugOverlay(Rect rect,
      {Duration duration = const Duration(milliseconds: 700)}) {
    final overlay = Overlay.of(context);
    if (overlay == null) {
      if (kDebugMode)
        debugPrint(
            '[Audit] _showDebugOverlay: Overlay.of(context) returned null');
      return;
    }

    if (kDebugMode)
      debugPrint(
          '[Audit] _showDebugOverlay inserting rect=$rect for slot=${widget.slotNumber}');

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
      if (kDebugMode)
        debugPrint(
            '[Audit] _showDebugOverlay inserted at $rect for slot=${widget.slotNumber}');
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
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              ),

              // --- 2) InsectAwakeningWidget monté avec la clé + layerLink --
              InsectAwakeningWidget(
                key: _awakeningKey,
                gardenId: widget.garden?.id?.toString() ??
                    'unknown_garden_${widget.slotNumber}',
                useOverlay: true,
                layerLink: _layerLink,
                fallbackSize: widget.zoneRect.size.shortestSide,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
