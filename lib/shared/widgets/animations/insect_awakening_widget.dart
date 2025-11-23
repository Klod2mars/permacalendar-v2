// lib/shared/widgets/animations/insect_awakening_widget.dart
//
// InsectAwakeningWidget (version retravaillée)
// - ConsumerStatefulWidget exposant triggerAnimation(), forcePersistent(), stopPersistent()
// - Support optionnel de LayerLink pour overlay follow via CompositedTransformFollower
// - Clamp de la taille de l'overlay pour éviter des boules géantes
// - Logs d'insertions d'overlay explicites pour debug
// - Throttling des logs d'audit (on logge seulement quand bubbleSize ou isPersistent change)
// - Défensif : protections pour Size(0,0), Overlay.of(context) == null, nettoyage dans dispose
//
// Remarque : utilise les imports package: pour éviter les erreurs d'import relatif.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assure-toi que le package name dans pubspec.yaml est 'permacalendar'.
// Si différent, remplace 'permacalendar' par le nom correct.
import 'package:permacalendar/core/providers/active_garden_provider.dart';

/// Widget d'éveil / lueur pour un "garden" (petite bulle).
/// - Peut dessiner localement ou via Overlay (useOverlay=true).
/// - Si [layerLink] est fourni, l'overlay utilise CompositedTransformFollower pour suivre la bulle.
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

  // Flag : n'attacher ref.listen qu'une seule fois (satisfait assertion Riverpod)
  bool _refListenerAttached = false;

  // Audit throttling : n'imprimer que sur changement
  Size? _lastAuditSize;
  bool? _lastPersistentState;

  // Safety clamp pour overlay size
  static const double _maxOverlaySide = 180.0;
  static const double _minOverlaySide = 10.0;

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
      // repaint local
      if (mounted) setState(() {});
      // if overlay present, mark it needs build
      if (_overlayEntry != null) {
        try {
          _overlayEntry!.markNeedsBuild();
        } catch (e, st) {
          if (kDebugMode) debugPrint('[Overlay] markNeedsBuild error: $e\n$st');
        }
      }
    });

    // Si le jardin est déjà actif au mount, forcer persistent après le 1er frame
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

  /// Déclenche une animation courte (non persistante)
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

  /// Rendre la lueur persistante (répétée)
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

  /// Stoppe la persistance et enlève l'overlay (si présent)
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

  /// Affiche une lueur temporaire via un overlay de debug (utile si widget n'est pas monté)
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

    Size size = Size(widget.fallbackSize, widget.fallbackSize);
    try {
      final ro = context.findRenderObject();
      if (ro is RenderBox && ro.attached) {
        final s = ro.size;
        if (s.width > 0 && s.height > 0) size = s;
      }
    } catch (_) {}

    // clamp size
    size = Size(
      size.width.clamp(_minOverlaySide, _maxOverlaySide),
      size.height.clamp(_minOverlaySide, _maxOverlaySide),
    );

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
      if (kDebugMode)
        debugPrint(
            '[Insect] triggerTemporaryGlow inserted for ${widget.gardenId}');
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Insect] triggerTemporaryGlow insert error: $e\n$st');
    }
  }

  // ---------------- Overlay helpers ----------------

  void _ensureOverlay() {
    if (_overlayEntry != null) return;

    // Tentative de déterminer la taille réelle du widget ; fallback si zéro
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

    // Clamp de sécurité pour éviter des overflows visuels
    bubbleSize = Size(
      bubbleSize.width.clamp(_minOverlaySide, _maxOverlaySide),
      bubbleSize.height.clamp(_minOverlaySide, _maxOverlaySide),
    );

    // Log informatif
    if (kDebugMode) {
      debugPrint(
          '[Overlay] final bubbleSize=$bubbleSize for ${widget.gardenId} layerLink=${widget.layerLink != null}');
    }

    // Créer overlay via CompositedTransformFollower si layerLink fourni
    if (widget.layerLink != null) {
      if (kDebugMode) {
        debugPrint(
            '[Overlay] using LayerLink for ${widget.gardenId}, size=$bubbleSize');
      }
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
      // Fallback: position par offset global
      if (offset == null) {
        if (kDebugMode)
          debugPrint(
              '[Overlay] cannot determine offset for ${widget.gardenId} - skipping overlay');
        return;
      }
      final left = offset.dx;
      final top = offset.dy;
      final width = math.max(bubbleSize.width, 1.0);
      final height = math.max(bubbleSize.height, 1.0);

      if (kDebugMode) {
        debugPrint(
            '[Overlay] creating Positioned overlay for ${widget.gardenId} at left=$left top=$top size=${width}x${height}');
      }

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

    // Insert overlay (si possible)
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
    // Attach ref.listen only during build, and only once (satisfies Riverpod debug assert)
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
            // Force persistent après le prochain frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) forcePersistent();
            });
          } else {
            // Si on était persistent et que l'actif a changé, stop après frame
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

      // Audit throttling : ne logger que si changement de taille ou d'état persistent
      if (kDebugMode) {
        if (_lastAuditSize == null ||
            _lastPersistentState == null ||
            _lastAuditSize != bubbleSize ||
            _lastPersistentState != _isPersistent) {
          debugPrint(
              '[Audit] InsectAwakeningWidget ${widget.gardenId} - bubbleSize=$bubbleSize state=$_isPersistent overlay=${_overlayEntry != null}');
          _lastAuditSize = bubbleSize;
          _lastPersistentState = _isPersistent;
        }
      }

      // Si parent donne une taille zero, rendre fallback visible pour le debug
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

      // Dessin local ; si overlay actif il le reflètera
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

/// Painter pour la lueur (halo)
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
