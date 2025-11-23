// lib/shared/widgets/insect_awakening_widget.dart
//
// Self-contained, defensive InsectAwakeningWidget used by the Organic Dashboard.
// This version includes enhanced debug logging to diagnose mounting/size/provider/overlay issues.
//
// - Designed to be mounted with a GlobalKey<InsectAwakeningWidgetState> so parent
//   can call `triggerAnimation()` and `forcePersistent()`.
// - Listens to `activeGardenIdProvider` (Riverpod) and starts/stops persistent glow
//   when garden becomes active/inactive.
// - Optionally uses an OverlayEntry to draw the glow outside parent's clip/z-order.
// - Very defensive: logs, protects against Size(0,0), nulls, and disposes overlay.
//
// IMPORTANT:
// - Adjust the import path for `active_garden_provider.dart` to match your project layout.
//   I used: `package:permacalendar/core/providers/active_garden_provider.dart`
// - Use with GlobalKey:
//     final _awakeningKey = GlobalKey<InsectAwakeningWidgetState>();
//     InsectAwakeningWidget(key: _awakeningKey, gardenId: garden.id, useOverlay: true)
//

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// <-- ADJUST THIS IMPORT to your actual provider path in the project:
import 'package:permacalendar/core/providers/active_garden_provider.dart';

class InsectAwakeningWidget extends ConsumerStatefulWidget {
  final String gardenId;
  final bool useOverlay;
  final double fallbackSize;

  const InsectAwakeningWidget({
    Key? key,
    required this.gardenId,
    this.useOverlay = false,
    this.fallbackSize = 60.0,
  }) : super(key: key);

  @override
  InsectAwakeningWidgetState createState() => InsectAwakeningWidgetState();
}

class InsectAwakeningWidgetState extends ConsumerState<InsectAwakeningWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnim;

  bool _isPersistent = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '[Insect][init] initState for ${widget.gardenId} key=${widget.key}');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      // ensure the widget repaint; for overlay also mark it needs build
      setState(() {});
      if (_overlayEntry != null) {
        try {
          _overlayEntry!.markNeedsBuild();
        } catch (e, st) {
          debugPrint('[Overlay] markNeedsBuild error: $e\n$st');
        }
      }
    });

    // Listen the active garden provider so that when this garden becomes active
    // we can start the persistent glow.
    ref.listen<dynamic>(activeGardenIdProvider, (prev, next) {
      debugPrint(
          '[Insect] provider change prev=$prev next=$next for <${widget.gardenId}>');
      try {
        final activeId = next;
        if (activeId != null && activeId == widget.gardenId) {
          debugPrint(
              '[Insect] detected active garden matches this widget -> forcePersistent');
          forcePersistent();
        } else {
          if (_isPersistent) {
            debugPrint('[Insect] active garden changed away -> stopPersistent');
            stopPersistent();
          }
        }
      } catch (e, st) {
        debugPrint('[Insect] provider listen error: $e\n$st');
      }
    });

    // If the garden is already active at mount, force persistent after frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final active = ref.read(activeGardenIdProvider);
        debugPrint(
            '[Audit] postFrame for ${widget.gardenId} activeProvider=$active');
        if (active != null && active == widget.gardenId) {
          debugPrint('[Audit] active matches on mount, forcing persistent.');
          forcePersistent();
        }
      } catch (e, st) {
        debugPrint('[Insect] postFrame provider read error: $e\n$st');
      }
    });
  }

  /// Public API: short animation (non persistent).
  void triggerAnimation() {
    debugPrint(
        '[Insect] triggerAnimation for ${widget.gardenId} overlay=${_overlayEntry != null} controller.value=${_controller.value}');
    if (widget.useOverlay) {
      _ensureOverlay();
    }
    try {
      _controller.forward(from: 0.0);
    } catch (e, st) {
      debugPrint('[Insect] triggerAnimation error: $e\n$st');
    }
    _logState('triggerAnimation');
  }

  /// Public API: force persistent glow (repeat animation).
  void forcePersistent() {
    debugPrint(
        '[Insect] forcePersistent requested for ${widget.gardenId} (already=$_isPersistent)');
    if (_isPersistent) {
      return;
    }
    _isPersistent = true;
    if (widget.useOverlay) {
      _ensureOverlay();
    }
    try {
      _controller.repeat(period: const Duration(milliseconds: 900));
      debugPrint(
          '[Insect] persistent controller repeat started for ${widget.gardenId}');
    } catch (e, st) {
      debugPrint('[Insect] forcePersistent error: $e\n$st');
    }
    _logState('forcePersistent');
  }

  /// Public API: stop persistent glow.
  void stopPersistent() {
    debugPrint('[Insect] stopPersistent for ${widget.gardenId}');
    _isPersistent = false;
    try {
      _controller.stop(canceled: false);
    } catch (e, st) {
      debugPrint('[Insect] stopPersistent controller stop error: $e\n$st');
    }
    _removeOverlay();
    setState(() {});
    _logState('stopPersistent');
  }

  // ----------------- Overlay helpers -----------------

  void _ensureOverlay() {
    if (_overlayEntry != null) {
      debugPrint('[Overlay] already present for ${widget.gardenId}');
      return;
    }

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) {
      debugPrint(
          '[Overlay] cannot get RenderBox for ${widget.gardenId} (renderObject=$renderObject)');
      return;
    }

    final size = renderObject.size;
    final offset = renderObject.localToGlobal(Offset.zero);

    debugPrint(
        '[Overlay] creating for ${widget.gardenId} offset=$offset size=$size overlayExists=${_overlayEntry != null}');

    // Capture offset/size at insertion time. If the widget moves you can extend
    // this method to recalculate and reposition the overlay.
    _overlayEntry = OverlayEntry(builder: (ctx) {
      // The builder uses current _isPersistent/_glowAnim values each markNeedsBuild.
      return Positioned(
        left: offset.dx,
        top: offset.dy,
        width: math.max(size.width, 1.0),
        height: math.max(size.height, 1.0),
        child: IgnorePointer(
          ignoring: true,
          child: Material(
            color: Colors.transparent,
            child: CustomPaint(
              size: Size(size.width, size.height),
              painter: GlowPainter(
                color: Colors.greenAccent,
                intensity: _isPersistent ? 1.0 : _glowAnim.value,
              ),
            ),
          ),
        ),
      );
    });

    try {
      final overlay = Overlay.of(context);
      if (overlay != null) {
        overlay.insert(_overlayEntry!);
        debugPrint(
            '[Overlay] inserted for ${widget.gardenId} at offset=$offset size=$size');
      } else {
        debugPrint(
            '[Overlay] Overlay.of(context) returned null for ${widget.gardenId}');
        _overlayEntry = null;
      }
    } catch (e, st) {
      debugPrint('[Overlay] insert error: $e\n$st');
      _overlayEntry = null;
    }
    _logState('_ensureOverlay_done');
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
        debugPrint('[Overlay] removed for ${widget.gardenId}');
      } catch (e, st) {
        debugPrint('[Overlay] remove error: $e\n$st');
      }
    } else {
      debugPrint(
          '[Overlay] _removeOverlay called but _overlayEntry==null for ${widget.gardenId}');
    }
    _overlayEntry = null;
  }

  // ----------------- Build & painter -----------------

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bubbleSize = constraints.biggest;
      debugPrint(
          '[Audit] InsectAwakeningWidget ${widget.gardenId} - bubbleSize=$bubbleSize state=$_isPersistent mounted=${mounted} overlay=${_overlayEntry != null}');

      // If parent gave zero size, use a visible fallback so developer can see placement.
      if (bubbleSize.width == 0 || bubbleSize.height == 0) {
        debugPrint(
            '[Audit] bubbleSize is zero for ${widget.gardenId} - returning fallbackSize ${widget.fallbackSize}');
        return SizedBox(
          width: widget.fallbackSize,
          height: widget.fallbackSize,
          child: Center(
            child: Container(
              width: widget.fallbackSize,
              height: widget.fallbackSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.18),
                border:
                    Border.all(color: Colors.red.withOpacity(0.4), width: 1.0),
              ),
              child: const Center(
                  child: Text('DBG', style: TextStyle(fontSize: 10))),
            ),
          ),
        );
      }

      // If overlay is used, we still draw a local shape as fallback; overlay handles
      // the "escape clip / z-order" case.
      return CustomPaint(
        size: bubbleSize,
        painter: GlowPainter(
          color: Colors.greenAccent,
          intensity: _isPersistent ? 1.0 : _glowAnim.value,
        ),
      );
    });
  }

  @override
  void dispose() {
    debugPrint('[Insect][dispose] dispose called for ${widget.gardenId}');
    _removeOverlay();
    try {
      _controller.dispose();
    } catch (e, st) {
      debugPrint('[Insect] controller dispose error: $e\n$st');
    }
    super.dispose();
  }

  // ----------------- Debug helpers -----------------

  void _logState(String origin) {
    debugPrint(
        '[Insect][state] origin=$origin garden=${widget.gardenId} isPersistent=$_isPersistent controllerValue=${_controller.value.toStringAsFixed(2)} isAnimating=${_controller.isAnimating} overlay=${_overlayEntry != null}');
  }

  String debugInfo() {
    return 'gardenId=${widget.gardenId} isPersistent=$_isPersistent controller=${_controller.value} overlay=${_overlayEntry != null}';
  }
}

/// Painter for the glow. Uses MaskFilter.blur to create a soft halo.
class GlowPainter extends CustomPainter {
  final Color color;
  final double intensity; // 0..1

  GlowPainter({required this.color, this.intensity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Outer halo / glow (soft blurred)
    final glowPaint = Paint()
      ..color = color.withOpacity(0.25 * intensity)
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, radius * 0.6);

    canvas.drawCircle(center, radius * 1.25, glowPaint);

    // Mid halo
    final midPaint = Paint()
      ..color = color.withOpacity(0.16 * intensity)
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, radius * 0.3);
    canvas.drawCircle(center, radius * 1.0, midPaint);

    // Core circle
    final circlePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.95 * intensity),
          color.withOpacity(0.6 * intensity),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.75, circlePaint);
  }

  @override
  bool shouldRepaint(covariant GlowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.intensity != intensity;
  }
}
