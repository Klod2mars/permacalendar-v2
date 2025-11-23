// lib/shared/widgets/animations/insect_awakening_widget.dart
//
// InsectAwakeningWidget (révisé)
// - ConsumerStatefulWidget exposant triggerAnimation(), forcePersistent(), stopPersistent()
// - Optionally accepts a LayerLink so the overlay can follow the target via
//   CompositedTransformFollower (recommended when used with CompositedTransformTarget).
// - Defensive: handles Size(0,0), Overlay.of(context) == null, cleans up in dispose.
// - Reduced logging; keep only meaningful debug logs under kDebugMode.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsectAwakeningWidget extends ConsumerStatefulWidget {
  final String gardenId;
  final bool useOverlay;
  final double fallbackSize;
  final LayerLink? layerLink;

  const InsectAwakeningWidget({
    Key? key,
    required this.gardenId,
    this.useOverlay = false,
    this.fallbackSize = 60.0,
    this.layerLink,
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

  // Flag: avoid calling ref.listen multiple times from build
  bool _refListenerAttached = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint(
          '[Insect][init] initState for ${widget.gardenId} key=${widget.key}');
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      if (mounted) {
        // Only trigger a local repaint; overlay (if present) will be markedNeedsBuild below
        setState(() {});
      }
      if (_overlayEntry != null) {
        try {
          _overlayEntry!.markNeedsBuild();
        } catch (e, st) {
          if (kDebugMode) debugPrint('[Overlay] markNeedsBuild error: $e\n$st');
        }
      }
    });

    // After first frame, if this garden is already active, ensure persistent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final active = ref.read(activeGardenIdProvider);
        if (kDebugMode) {
          debugPrint(
              '[Audit] postFrame for ${widget.gardenId} activeProvider=$active');
        }
        if (active != null && active == widget.gardenId) {
          if (mounted) forcePersistent();
        }
      } catch (e, st) {
        if (kDebugMode)
          debugPrint('[Insect] postFrame provider read error: $e\n$st');
      }
    });
  }

  // ---------------- PUBLIC API ----------------

  /// Simple pulse/animation trigger (non-persistent).
  void triggerAnimation() {
    if (kDebugMode) {
      debugPrint(
          '[Insect] triggerAnimation for ${widget.gardenId} overlay=${_overlayEntry != null} controller.value=${_controller.value}');
    }
    if (widget.useOverlay) {
      _ensureOverlay();
    }
    try {
      _controller.forward(from: 0.0);
    } catch (e, st) {
      if (kDebugMode) debugPrint('[Insect] triggerAnimation error: $e\n$st');
    }
    _logState('triggerAnimation');
  }

  /// Make the glow persistent (repeat animation) and ensure overlay present if requested.
  void forcePersistent() {
    if (_isPersistent) return;
    if (kDebugMode)
      debugPrint('[Insect] forcePersistent requested for ${widget.gardenId}');
    _isPersistent = true;
    if (widget.useOverlay) _ensureOverlay();
    try {
      _controller.repeat(period: const Duration(milliseconds: 900));
    } catch (e, st) {
      if (kDebugMode) debugPrint('[Insect] forcePersistent error: $e\n$st');
    }
    _logState('forcePersistent');
  }

  /// Stop persistent state and remove overlay.
  void stopPersistent() {
    if (kDebugMode)
      debugPrint('[Insect] stopPersistent for ${widget.gardenId}');
    _isPersistent = false;
    try {
      _controller.stop(canceled: false);
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Insect] stopPersistent controller stop error: $e\n$st');
    }
    _removeOverlay();
    if (mounted) setState(() {});
    _logState('stopPersistent');
  }

  /// Small helper: show a short, debug-only overlay if the widget isn't mounted in place.
  /// Useful when the hotspot logic wants immediate feedback but the widget isn't ready.
  void triggerTemporaryGlow(
      {Duration duration = const Duration(milliseconds: 700)}) {
    if (!widget.useOverlay) return;
    final overlay = Overlay.of(context);
    if (overlay == null) {
      if (kDebugMode)
        debugPrint(
            '[Insect] triggerTemporaryGlow: Overlay.of(context) == null');
      return;
    }

    // compute a size if possible
    Size size = Size(widget.fallbackSize, widget.fallbackSize);
    try {
      final ro = context.findRenderObject();
      if (ro is RenderBox && ro.attached) {
        final s = ro.size;
        if (s.width > 0 && s.height > 0) size = s;
      }
    } catch (_) {}

    final debugEntry = OverlayEntry(builder: (ctx) {
      return Center(
        child: IgnorePointer(
          ignoring: true,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: CustomPaint(
                painter: GlowPainter(
                  color: Colors.yellowAccent,
                  intensity: 1.0,
                ),
              ),
            ),
          ),
        ),
      );
    });

    try {
      overlay.insert(debugEntry);
      Future.delayed(duration, () {
        try {
          debugEntry.remove();
        } catch (_) {}
      });
      if (kDebugMode) debugPrint('[Insect] triggerTemporaryGlow inserted');
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Insect] triggerTemporaryGlow insert error: $e\n$st');
    }
  }

  // ---------------- Overlay helpers ----------------

  void _ensureOverlay() {
    if (_overlayEntry != null) {
      // overlay already present; keep it
      return;
    }

    // Try to determine the size of the widget; if zero, use fallback.
    Size bubbleSize = Size(widget.fallbackSize, widget.fallbackSize);
    Offset? offset;
    try {
      final renderObject = context.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        final s = renderObject.size;
        if (s.width > 0 && s.height > 0) bubbleSize = s;
        try {
          offset = renderObject.localToGlobal(Offset.zero);
        } catch (_) {
          offset = null;
        }
      }
    } catch (_) {}

    // Create overlay with CompositedTransformFollower if a LayerLink was provided.
    if (widget.layerLink != null) {
      _overlayEntry = OverlayEntry(builder: (ctx) {
        return CompositedTransformFollower(
          link: widget.layerLink!,
          showWhenUnlinked: false,
          offset: Offset(0, 0),
          child: IgnorePointer(
            ignoring: true,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: bubbleSize.width,
                height: bubbleSize.height,
                child: CustomPaint(
                  painter: GlowPainter(
                    color: Colors.greenAccent,
                    intensity: _isPersistent ? 1.0 : _glowAnim.value,
                  ),
                ),
              ),
            ),
          ),
        );
      });
    } else {
      // Fallback: position by absolute offset in the overlay.
      if (offset == null) {
        if (kDebugMode)
          debugPrint(
              '[Overlay] cannot determine offset for ${widget.gardenId}');
        return;
      }
      final left = offset.dx;
      final top = offset.dy;
      final width = math.max(bubbleSize.width, 1.0);
      final height = math.max(bubbleSize.height, 1.0);

      _overlayEntry = OverlayEntry(builder: (ctx) {
        return Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: IgnorePointer(
            ignoring: true,
            child: Material(
              color: Colors.transparent,
              child: CustomPaint(
                size: Size(width, height),
                painter: GlowPainter(
                  color: Colors.greenAccent,
                  intensity: _isPersistent ? 1.0 : _glowAnim.value,
                ),
              ),
            ),
          ),
        );
      });
    }

    try {
      final overlay = Overlay.of(context);
      if (overlay != null && _overlayEntry != null) {
        overlay.insert(_overlayEntry!);
        if (kDebugMode) debugPrint('[Overlay] inserted for ${widget.gardenId}');
      } else {
        if (kDebugMode)
          debugPrint(
              '[Overlay] Overlay.of(context) returned null for ${widget.gardenId}');
        _overlayEntry = null;
      }
    } catch (e, st) {
      if (kDebugMode) debugPrint('[Overlay] insert error: $e\n$st');
      _overlayEntry = null;
    }
    _logState('_ensureOverlay_done');
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
        if (kDebugMode) debugPrint('[Overlay] removed for ${widget.gardenId}');
      } catch (e, st) {
        if (kDebugMode) debugPrint('[Overlay] remove error: $e\n$st');
      }
    }
    _overlayEntry = null;
  }

  // ---------------- Build & provider listen ----------------

  @override
  Widget build(BuildContext context) {
    // Attach ref.listen only during build, and only once (satisfies Riverpod debug assertion).
    if (!_refListenerAttached) {
      _refListenerAttached = true;
      ref.listen<String?>(activeGardenIdProvider, (prev, next) {
        if (kDebugMode) {
          debugPrint(
              '[Insect] provider change prev=$prev next=$next for <${widget.gardenId}>');
        }
        try {
          final activeId = next;
          if (activeId != null && activeId == widget.gardenId) {
            // Ensure forced persistent after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) forcePersistent();
            });
          } else {
            // If we were persistent and active moved away, stop persistent after frame
            if (_isPersistent) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) stopPersistent();
              });
            }
          }
        } catch (e, st) {
          if (kDebugMode) debugPrint('[Insect] provider listen error: $e\n$st');
        }
      });
      if (kDebugMode)
        debugPrint(
            '[Insect] ref.listen attached for widget ${widget.gardenId}');
    }

    return LayoutBuilder(builder: (context, constraints) {
      final bubbleSize = constraints.biggest;
      // Light debug info
      if (kDebugMode) {
        debugPrint(
            '[Audit] InsectAwakeningWidget ${widget.gardenId} - bubbleSize=$bubbleSize state=$_isPersistent overlay=${_overlayEntry != null}');
      }

      // If parent gave zero size, use a visible fallback so developer can see placement.
      if (bubbleSize.width == 0 || bubbleSize.height == 0) {
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

      // Draw local painter; overlay will mirror this if used.
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
    if (kDebugMode)
      debugPrint('[Insect][dispose] dispose called for ${widget.gardenId}');
    _removeOverlay();
    try {
      _controller.dispose();
    } catch (e, st) {
      if (kDebugMode) debugPrint('[Insect] controller dispose error: $e\n$st');
    }
    super.dispose();
  }

  // ---------------- Debug helpers ----------------

  void _logState(String origin) {
    if (kDebugMode) {
      debugPrint(
          '[Insect][state] origin=$origin garden=${widget.gardenId} isPersistent=$_isPersistent controllerValue=${_controller.value.toStringAsFixed(2)} isAnimating=${_controller.isAnimating} overlay=${_overlayEntry != null}');
    }
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
