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

import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

// InsectAwakeningWidget - assure-toi que ce chemin package: est correct
import 'package:permacalendar/core/providers/active_garden_provider.dart';
import 'package:permacalendar/core/repositories/dashboard_slots_repository.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import 'package:permacalendar/shared/presentation/themes/organic_palettes.dart';

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
  // LayerLink (kept for layout / future use). Lueur/awakening logic removed.
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

    // NOTE: awakening/registry registration removed. InvisibleGardenZone no longer
    // manages the insect awakening overlay or registry.

    // FIX: Force a layout recalculation after stabilization.
    // We use a small delay to allow fonts (GoogleFonts) to fully load and metrics to stabilize.
    // The immediate PostFrameCallback is sometimes too fast if assets are still decoding.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _frameStabilized = true; // Will trigger a Key change to force AutoSizeText flush
          });
        }
      });
    });
  }
  
  // Flag to force AutoSizeText refresh
  bool _frameStabilized = false;

  @override
  void didUpdateWidget(covariant InvisibleGardenZone oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kDebugMode) {
      debugPrint(
          '[Audit] InvisibleGardenZone.didUpdateWidget slot=${widget.slotNumber} oldGarden=${oldWidget.garden?.id} newGarden=${widget.garden?.id}');
    }

    // Previously we updated the awakening registry here. That logic has been removed
    // because garden activation / awakening is now handled elsewhere (in the
    // cultural/plot code). We keep didUpdateWidget for potential future hooks.
  }

  @override
  void dispose() {
    // Awakening/registry cleanup removed. Nothing to stop here.

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

  /// Helper: extract gardenName from dynamic or fallback
  String? _gardenNameFromDynamic(dynamic g) {
    if (g == null) return null;
    if (g is Map && g.containsKey('name')) return g['name']?.toString();
    try {
      // ignore: avoid_dynamic_calls
      final val = g.name;
      return val?.toString();
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
      // Deactivated — no local awakening widget to stop.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Jardin $gardenId désactivé'),
            duration: const Duration(seconds: 1)),
      );
    }

    // Awakening/trigger removed: the UI no longer triggers the insect overlay.
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
      // Défensive : s'assurer que Positioned a un Stack parent -> évite le cast ParentData error
      return Stack(
        children: [
          Positioned(
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
                    border: Border.all(
                        color: Colors.orange.withOpacity(0.6), width: 2),
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
          ),
        ],
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
    // [DEFENSIVE FIX] Wrapped in Stack to ensure Positioned always has a StackParentData context.
    // If used nested in another Stack, this inner Stack provides the context.
    return Stack(
      fit: StackFit.passthrough, // Try to respect constraints
      children: [
        Positioned.fromRect(
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

              // --- 2) InsectAwakeningWidget supprimé ---
              // Lueur / awakening supprimée : InsectAwakeningWidget retiré parce que
              // le système d'activation a été déplacé dans les zones de culture.

              // --- 3) Label text (Garden Name) ---
              // Ajout dynamique du nom avec style Organic
              Consumer(builder: (context, ref, child) {
                final activeId = ref.watch(activeGardenIdProvider);
                final gardenId = widget.garden?.id?.toString();
                final isActive = (gardenId != null && activeId == gardenId);

                final gardenName = _gardenNameFromDynamic(widget.garden) ??
                    'Jardin ${widget.slotNumber}';

                final targetOpacity = isActive
                    ? GardenLabelStyle.activeOpacity
                    : GardenLabelStyle.discreetOpacity;
                final targetFontSize = isActive
                    ? GardenLabelStyle.activeFontSize
                    : GardenLabelStyle.discreetFontSize;
                final targetWeight = isActive
                    ? GardenLabelStyle.activeWeight
                    : GardenLabelStyle.discreetWeight;

                return Positioned.fill(
                  child: Center(
                    child: AnimatedOpacity(
                      duration: GardenLabelStyle.transitionDuration,
                      curve: GardenLabelStyle.transitionCurve,
                      opacity: targetOpacity,
                      child: AutoSizeText(
                        key: ValueKey('garden_label_${_frameStabilized ? 'stable' : 'init'}'),
                        gardenName.toUpperCase(), // garder cohérence avec les autres bulles
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        minFontSize: 6,
                        maxFontSize: targetFontSize,
                        stepGranularity: 0.1,
                        overflow: TextOverflow.ellipsis,
                        wrapWords: false, // évite la césure au milieu des mots lorsque possible
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: targetFontSize,
                          fontWeight: targetWeight,
                          shadows: [GardenLabelStyle.textShadow],
                          height: 1.05,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
      ],
    );
  }
}
