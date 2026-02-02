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
  ///
  /// NOTE: on remet aussi l'animation à zéro pour éviter que le CustomPainter
  /// continue d'afficher une intensité résiduelle après l'arrêt.
  void stopPersistent() {
    if (kDebugMode)
      debugPrint('[Insect] stopPersistent for ${widget.gardenId}');
    _isPersistent = false;
    try {
      // Remise à zéro défensive de l'animation pour garantir extinction visuelle
      // -> reset() positionne la valeur au lowerBound (généralement 0.0) et stoppe
      _controller.reset();
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[Insect] stopPersistent controller reset error: $e\n$st');
      // En fallback assurer valeur 0.0
      try {
        _controller.stop(canceled: true);
        _controller.value = 0.0;
      } catch (_) {}
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
        return Stack(
          children: [
            Positioned(
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
            ),
          ],
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

  const GlowPainter({required this.color, this.intensity = 1.0});

  double _safeDouble(double v, double fallback) =>
      (v.isFinite && !v.isNaN) ? v : fallback;

  double _clampOpacity(double o) {
    if (!o.isFinite || o.isNaN) return 0.0;
    if (o < 0.0) return 0.0;
    if (o > 1.0) return 1.0;
    return o;
  }

  double _sigma(double v) {
    final double s = _safeDouble(v, 0.001);
    return (s <= 0.0 || !s.isFinite) ? 0.001 : s;
  }

  @override
  void paint(Canvas canvas, Size size) {
    try {
      // sécurités
      final double w = _safeDouble(size.width, 1.0);
      final double h = _safeDouble(size.height, 1.0);
      final Offset center0 = Offset(w / 2.0, h / 2.0);
      double radius = _safeDouble(math.min(w, h) / 2.0, 1.0);
      if (radius <= 0 || !radius.isFinite) radius = 1.0;

      // facteur d'échelle basé sur la taille — <1 pour petites bulles, ~1 pour tailles normales
      final double sizeFactor = (radius / 28.0).clamp(0.5, 1.4);

      // temps pour animation subtile
      final double now =
          _safeDouble(DateTime.now().millisecondsSinceEpoch / 1000.0, 0.0);
      final double beat = _safeDouble(math.sin(now * 2.0 * math.pi * 0.9), 0.0);
      final double flutter =
          _safeDouble(math.sin(now * 2.0 * math.pi * 1.9), 0.0);

      // amplitudes diminuées et modulées par sizeFactor (plus petits => moins d'amplitude)
      final double beatAmp = _safeDouble(0.035 * intensity * sizeFactor, 0.0);
      final double jitterAmp = _safeDouble(0.015 * intensity * sizeFactor, 0.0);
      final double centerJitterAmp =
          _safeDouble(0.01 * intensity * radius * sizeFactor, 0.0);

      // léger déplacement organique du centre
      final double cjx =
          _safeDouble(math.sin(now * 2.3) * centerJitterAmp, 0.0);
      final double cjy =
          _safeDouble(math.cos(now * 1.7) * centerJitterAmp, 0.0);
      final Offset center = center0 + Offset(cjx, cjy);

      // coeur : respiration douce réduite
      double coreRadius =
          _safeDouble(radius * (0.68 + beat * beatAmp), radius * 0.45);
      if (coreRadius <= 0 || !coreRadius.isFinite)
        coreRadius = math.max(radius * 0.45, 1.0);

      // 1) Outer halo — très léger, garde la teinte verte discrète
      final double outerOpacity = _clampOpacity(_safeDouble(
          (0.06 + 0.015 * beat) * intensity * (0.9 + 0.1 * sizeFactor), 0.05));
      final double outerSigma = _sigma(radius * (0.7 + 0.12 * sizeFactor));
      final outerPaint = Paint()
        ..color = color.withOpacity(outerOpacity)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, outerSigma);
      canvas.drawCircle(
          center,
          _safeDouble(radius * (1.25 + 0.15 * (sizeFactor - 1.0)), radius),
          outerPaint);

      // 2) Mid white halo — plus discret que précédemment
      final double midOpacity = _clampOpacity(_safeDouble(
          (0.09 + 0.02 * flutter) * intensity * (0.85 + 0.15 * sizeFactor),
          0.07));
      final double midSigma = _sigma(radius * (0.48 + 0.08 * sizeFactor));
      final whiteMid = Paint()
        ..color = Colors.white.withOpacity(midOpacity)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, midSigma);
      canvas.drawCircle(
          center,
          _safeDouble(radius * (1.0 + 0.08 * (sizeFactor - 1.0)), radius),
          whiteMid);

      // 3) Petites taches blanches — tailles et opacités fortement réduites pour petites bulles
      final List<Offset> baseOffsets = [
        Offset(-0.05 * radius, -0.02 * radius),
        Offset(0.04 * radius, 0.03 * radius),
        Offset(0.08 * radius, -0.05 * radius),
      ];
      for (int i = 0; i < baseOffsets.length; i++) {
        final double phase = (i + 1) * 1.3;
        final double localFlutter = _safeDouble(
            math.sin(now * 2.0 * math.pi * (1.25 + i * 0.18) + phase), 0.0);
        final Offset ofs = baseOffsets[i] +
            Offset(localFlutter * jitterAmp * radius,
                math.cos(now * 1.4 * (i + 1) + phase) * jitterAmp * radius);

        // factor pour taches plus petites si sizeFactor petit
        final double fBase = 0.16 * (1.0 - i * 0.12);
        final double f = _safeDouble(fBase * (0.6 + 0.5 * sizeFactor), 0.04);
        final double spotOpacityRaw = _safeDouble(
            (0.14 * (1.0 - i * 0.12) * (1.0 + 0.08 * beat)) * intensity, 0.04);
        final double spotOpacity = _clampOpacity(
            spotOpacityRaw.clamp(0.03, 0.26) * (0.8 + 0.2 * sizeFactor));
        final double spotSigma = _sigma(
            radius * 0.22 * (1.0 + 0.04 * flutter) * (0.7 + 0.3 * sizeFactor));

        final spotPaint = Paint()
          ..color = Colors.white.withOpacity(spotOpacity)
          ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, spotSigma);
        canvas.drawCircle(
            center + ofs, _safeDouble(radius * f, 0.8), spotPaint);
      }

      // 4) Core : gradient blanc dominant, teinte verte très faible en périphérie
      final double alignX =
          _safeDouble((math.sin(now * 1.6) * 0.04).clamp(-0.08, 0.08), 0.0);
      final double alignY =
          _safeDouble((math.cos(now * 1.2) * 0.04).clamp(-0.08, 0.08), 0.0);
      final Rect shaderRect =
          Rect.fromCircle(center: center, radius: coreRadius);

      final double coreWhite1 = _clampOpacity(_safeDouble(
          (0.95 - 0.035 * beat) * intensity * (0.9 + 0.1 * sizeFactor), 0.6));
      final double coreWhite2 = _clampOpacity(_safeDouble(
          (0.58 - 0.02 * flutter) * intensity * (0.9 + 0.1 * sizeFactor), 0.3));
      // réduisons fortement la teinte verte pour le coeur
      final double coreTint = _clampOpacity(_safeDouble(
          (0.10 + 0.015 * beat) * intensity * (0.8 + 0.2 * sizeFactor), 0.05));

      final corePaint = Paint()
        ..shader = RadialGradient(
          center: Alignment(alignX, alignY),
          colors: [
            Colors.white.withOpacity(coreWhite1),
            Colors.white.withOpacity(coreWhite2),
            color.withOpacity(coreTint),
          ],
          stops: const [0.0, 0.54, 1.0],
        ).createShader(shaderRect)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, coreRadius, corePaint);

      // 5) Anneau très subtil autour du coeur
      final double ringOpacity = _clampOpacity(
          _safeDouble((0.05 + 0.008 * flutter) * intensity, 0.03));
      final double ringSigma = _sigma(radius * (0.14 + 0.015 * sizeFactor));
      final ringPaint = Paint()
        ..color = Colors.white.withOpacity(ringOpacity)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, ringSigma);
      canvas.drawCircle(
          center,
          _safeDouble(coreRadius * (1.06 + 0.01 * beat), coreRadius * 1.06),
          ringPaint);
    } catch (_) {
      // silencieux : on protège le rendu contre toute exception.
    }
  }

  @override
  bool shouldRepaint(covariant GlowPainter oldDelegate) {
    // On maintient true pour l'animation légère.
    return true;
  }
}
