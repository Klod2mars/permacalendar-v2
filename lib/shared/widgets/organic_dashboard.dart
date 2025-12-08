// lib/shared/widgets/organic_dashboard.dart
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import '../../app_router.dart';
import '../../core/models/organic_zone_config.dart';
import '../../core/providers/organic_zones_provider.dart';
import '../../core/models/calibration_state.dart';
import '../widgets/calibration_debug_overlay.dart';
import '../../core/repositories/dashboard_slots_repository.dart';
import '../../core/providers/active_garden_provider.dart';

// Nouveaux imports pour affichage météo dans la bulle
import '../../features/climate/presentation/providers/weather_providers.dart';
import '../../core/utils/weather_icon_mapper.dart';
import '../presentation/widgets/weather_bubble_widget.dart';

// Nouveaux imports recommandés (à créer si pas encore présent)


/// OrganicDashboardWidget
class OrganicDashboardWidget extends ConsumerStatefulWidget {
  const OrganicDashboardWidget({
    super.key,
    this.assetPath = 'assets/images/backgrounds/dashboard_organic_final.png',
    this.showDiagnostics = true,
  });

  final String assetPath;
  final bool showDiagnostics;

  static const List<_Hotspot> _hotspots = <_Hotspot>[
    _Hotspot(
        id: 'intelligence',
        centerX: 0.18,
        centerY: 0.22,
        widthFrac: 0.20,
        heightFrac: 0.20,
        route: AppRoutes.intelligence,
        label: 'Intelligence'),
    _Hotspot(
        id: 'calendar',
        centerX: 0.18,
        centerY: 0.50,
        widthFrac: 0.20,
        heightFrac: 0.20,
        route: AppRoutes.calendar,
        label: 'Calendar'),
    _Hotspot(
        id: 'activities',
        centerX: 0.18,
        centerY: 0.78,
        widthFrac: 0.20,
        heightFrac: 0.20,
        route: AppRoutes.activities,
        label: 'Activities'),
    _Hotspot(
        id: 'weather',
        centerX: 0.50,
        centerY: 0.18,
        widthFrac: 0.18,
        heightFrac: 0.18,
        route: AppRoutes.weather,
        label: 'Weather'),
    _Hotspot(
        id: 'settings',
        centerX: 0.92,
        centerY: 0.06,
        widthFrac: 0.07,
        heightFrac: 0.07,
        route: AppRoutes.settings,
        label: 'Paramètres'),
    _Hotspot(
        id: 'garden_1',
        centerX: 0.60,
        centerY: 0.52,
        widthFrac: 0.12,
        heightFrac: 0.12,
        route: AppRoutes.gardens,
        label: 'Jardin 1'),
    _Hotspot(
        id: 'garden_2',
        centerX: 0.68,
        centerY: 0.50,
        widthFrac: 0.12,
        heightFrac: 0.12,
        route: AppRoutes.gardens,
        label: 'Jardin 2'),
    _Hotspot(
        id: 'garden_3',
        centerX: 0.72,
        centerY: 0.58,
        widthFrac: 0.12,
        heightFrac: 0.12,
        route: AppRoutes.gardens,
        label: 'Jardin 3'),
    _Hotspot(
        id: 'garden_4',
        centerX: 0.64,
        centerY: 0.60,
        widthFrac: 0.12,
        heightFrac: 0.12,
        route: AppRoutes.gardens,
        label: 'Jardin 4'),
    _Hotspot(
        id: 'garden_5',
        centerX: 0.54,
        centerY: 0.60,
        widthFrac: 0.12,
        heightFrac: 0.12,
        route: AppRoutes.gardens,
        label: 'Jardin 5'),
  ];

  @override
  ConsumerState<OrganicDashboardWidget> createState() =>
      _OrganicDashboardWidgetState();
}

class _OrganicDashboardWidgetState
    extends ConsumerState<OrganicDashboardWidget> {
  final GlobalKey _containerKey = GlobalKey();
  double? _initialSizeForScale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDefaultsIfNeeded();
    });
  }

  Future<void> _loadDefaultsIfNeeded() async {
    final defaultPositions = <String, Offset>{};
    final defaultSizes = <String, double>{};
    final defaultEnabled = <String, bool>{};

    for (final hs in OrganicDashboardWidget._hotspots) {
      defaultPositions[hs.id] = Offset(hs.centerX, hs.centerY);
      defaultSizes[hs.id] =
          (hs.widthFrac > hs.heightFrac) ? hs.widthFrac : hs.heightFrac;
      defaultEnabled[hs.id] = true;
    }

    try {
      await ref.read(organicZonesProvider.notifier).loadFromStorage(
            defaultPositions: defaultPositions,
            defaultSizes: defaultSizes,
            defaultEnabled: defaultEnabled,
          );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🔧 [CALIBRATION] error loading defaults: $e');
      }
    }
  }

  static Future<_AssetDiagnostic> _diagnoseAsset(String assetPath) async {
    final diag = _AssetDiagnostic();
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      diag.manifestLoaded = true;
      diag.declared =
          manifest.contains('"$assetPath"') || manifest.contains(assetPath);
    } catch (e) {
      diag.manifestLoaded = false;
      diag.manifestError = e.toString();
      diag.declared = false;
    }

    try {
      final bd = await rootBundle.load(assetPath);
      diag.loadOk = true;
      diag.sizeBytes = bd.lengthInBytes;
    } catch (e) {
      diag.loadOk = false;
      diag.loadError = e.toString();
    }
    return diag;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('OrganicDashboard: build called -> ${widget.assetPath}');
    }

    final zones = ref.watch(organicZonesProvider);
    final calibState = ref.watch(calibrationStateProvider);
    final isCalibrating = calibState.activeType == CalibrationType.organic;

    return LayoutBuilder(builder: (context, constraints) {
      final double width = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width;
      final double height = (width * (9.0 / 5.0)).clamp(300.0, 1400.0);

      final Map<String, String> _routeMap = {
        for (final h in OrganicDashboardWidget._hotspots) h.id: h.route
      };

      return SizedBox(
        width: double.infinity,
        height: height,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            key: _containerKey,
            children: [
              Positioned.fill(
                child: Image.asset(
                  widget.assetPath,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  isAntiAlias: true,
                  errorBuilder: (context, error, stack) {
                    if (kDebugMode)
                      debugPrint(
                          'OrganicDashboard: asset not found -> ${widget.assetPath} : $error');
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_not_supported,
                                size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            Text('Visuel absent',
                                style: Theme.of(context).textTheme.bodyMedium),
                            if (kDebugMode) ...[
                              const SizedBox(height: 8),
                              Text(widget.assetPath,
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Zones : fallback defaults ou calibrées
              ...((zones.isEmpty)
                  ? (() {
                      final defaultHotspots =
                          List<_Hotspot>.from(OrganicDashboardWidget._hotspots)
                            ..sort((a, b) {
                              final asz = (a.widthFrac > a.heightFrac)
                                  ? a.widthFrac
                                  : a.heightFrac;
                              final bsz = (b.widthFrac > b.heightFrac)
                                  ? b.widthFrac
                                  : b.heightFrac;
                              return bsz.compareTo(asz); // larger first
                            });

                      return defaultHotspots.map((hs) {
                        final double side = ((hs.widthFrac > hs.heightFrac)
                                ? hs.widthFrac
                                : hs.heightFrac) *
                            (width < height ? width : height);
                        final double left = (hs.centerX * width) - side / 2;
                        final double top = (hs.centerY * height) - side / 2;

                        return Positioned(
                          left: left,
                          top: top,
                          width: side,
                          height: side,
                          child: _HotspotButton(
                            onTap: () {
                              if (kDebugMode)
                                debugPrint(
                                    'OrganicDashboard: tapped hotspot (${hs.id}) -> ${hs.route}');
                              context.push(hs.route);
                            },
                            showDebugOutline:
                                kDebugMode && widget.showDiagnostics,
                            semanticLabel: hs.label,
                            child: hs.id == 'weather'
                                ? const WeatherBubbleWidget()
                                : null,
                          ),
                        );
                      }).toList();
                    })()
                  : (() {
                      final sortedEntries = zones.entries.toList()
                        ..sort((a, b) => b.value.size.compareTo(a.value.size));

                      return sortedEntries.map((entry) {
                        final id = entry.key;
                        final cfg = entry.value;
                        if (!cfg.enabled) return const SizedBox.shrink();

                        final side =
                            (cfg.size * (width < height ? width : height))
                                .clamp(8.0, (width < height ? width : height));
                        final left = (cfg.position.dx * width) - side / 2;
                        final top = (cfg.position.dy * height) - side / 2;

                        return Positioned(
                          left: left,
                          top: top,
                          width: side,
                          height: side,
                          child: _CalibratableHotspot(
                            id: id,
                            cfg: cfg,
                            isCalibrating: isCalibrating,
                            onTapRoute: _routeMap[id],
                            containerKey: _containerKey,
                            ref: ref,
                            showDebugOutline:
                                kDebugMode && widget.showDiagnostics,
                          ),
                        );
                      }).toList();
                    })()),

              if (kDebugMode && widget.showDiagnostics)
                Positioned(
                  top: 8,
                  right: 8,
                  child: FutureBuilder<_AssetDiagnostic>(
                    future: _diagnoseAsset(widget.assetPath),
                    builder: (context, snap) {
                      Color bg = Colors.black.withOpacity(0.18);
                      Widget body;
                      if (snap.connectionState != ConnectionState.done) {
                        body = Row(
                          children: const [
                            SizedBox(width: 8),
                            SizedBox(
                                width: 12,
                                height: 12,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 8),
                            Text('Checking...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        );
                      } else if (snap.hasError) {
                        body = Text('Diag failed: ${snap.error}',
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 12));
                      } else {
                        final d = snap.data!;
                        final declared = d.declared ? 'YES' : 'NO';
                        final declaredColor = d.declared
                            ? Colors.greenAccent
                            : Colors.orangeAccent;
                        final loadOk = d.loadOk
                            ? 'OK (${d.sizeBytes ?? 0} bytes)'
                            : 'FAILED';
                        final loadColor =
                            d.loadOk ? Colors.greenAccent : Colors.redAccent;
                        body = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('asset:',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                                const SizedBox(width: 6),
                                Flexible(
                                    child: Text(widget.assetPath,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12))),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text('declared:',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                                const SizedBox(width: 6),
                                Text(declared,
                                    style: TextStyle(
                                        color: declaredColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('load:',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                                const SizedBox(width: 6),
                                Text(loadOk,
                                    style: TextStyle(
                                        color: loadColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        );
                        bg = d.declared && d.loadOk
                            ? Colors.black.withOpacity(0.24)
                            : Colors.black.withOpacity(0.38);
                      }
                      return Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(maxWidth: 160),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: body,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _AssetDiagnostic {
  bool manifestLoaded = false;
  bool declared = false;
  String? manifestError;

  bool loadOk = false;
  int? sizeBytes;
  String? loadError;
}

class _Hotspot {
  const _Hotspot({
    required this.id,
    required this.centerX,
    required this.centerY,
    required this.widthFrac,
    required this.heightFrac,
    required this.route,
    this.label,
  });

  final String id;
  final double centerX;
  final double centerY;
  final double widthFrac;
  final double heightFrac;
  final String route;
  final String? label;
}

class _HotspotButton extends StatelessWidget {
  const _HotspotButton({
    required this.onTap,
    this.onLongPress,
    this.showDebugOutline = false,
    this.semanticLabel,
    this.child,
  });
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showDebugOutline;
  final String? semanticLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white24,
        child: Semantics(
          button: true,
          label: semanticLabel ?? 'Dashboard hotspot',
          child: Container(
            decoration: showDebugOutline
                ? BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.orangeAccent.withOpacity(0.95),
                        width: 1.5),
                  )
                : const BoxDecoration(color: Colors.transparent),
            child: child ??
                (showDebugOutline
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            semanticLabel ?? 'hotspot',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.98),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              shadows: const [
                                Shadow(
                                    blurRadius: 2,
                                    color: Colors.black87,
                                    offset: Offset(0, 1))
                              ],
                            ),
                          ),
                        ),
                      )
                    : null),
          ),
        ),
      ),
    );
  }
}

/// Hotspot widget that supports calibration (pan + pinch-to-scale)
class _CalibratableHotspot extends StatefulWidget {
  const _CalibratableHotspot({
    Key? key,
    required this.id,
    required this.cfg,
    required this.isCalibrating,
    required this.onTapRoute,
    required this.containerKey,
    required this.ref,
    this.showDebugOutline = false,
  }) : super(key: key);

  final String id;
  final OrganicZoneConfig cfg;
  final bool isCalibrating;
  final String? onTapRoute;
  final GlobalKey containerKey;
  final WidgetRef ref;
  final bool showDebugOutline;

  @override
  State<_CalibratableHotspot> createState() => _CalibratableHotspotState();
}

class _CalibratableHotspotState extends State<_CalibratableHotspot> {
  // Convert "garden_3" -> 3
  int? _extractSlotNumber(String id) {
    if (id.startsWith('garden_')) {
      final parts = id.split('_');
      if (parts.length == 2) {
        return int.tryParse(parts[1]);
      }
    }
    return null;
  }

  double? _startSize;
  Offset? _startFocalLocal;
  Offset? _startNormalizedPos;

  bool _isResizing = false;
  double? _resizeStartSize;

  final Map<int, Offset> _activePointers = {};
  bool _isPinchingInside = false;

  // Awakening/LayerLink removed.


  // Resolved gardenId for this slot (may be null until async resolution)
  String? _gardenId;

  @override
  void initState() {
    super.initState();
    _resolveGardenId();
  }

  Future<void> _resolveGardenId() async {
    final slot = _extractSlotNumber(widget.id);
    if (slot == null) return;
    try {
      final gid = await DashboardSlotsRepository.getGardenIdForSlot(slot);
      if (!mounted) return;

      // Awakening registry logic removed.


      if (kDebugMode) {
        debugPrint(
            '[Insect][resolve] resolved gardenId for ${widget.id} -> $_gardenId');
      }
    } catch (e, st) {
      if (kDebugMode)
        debugPrint(
            '[Insect][resolve] error resolving gardenId for ${widget.id}: $e\n$st');
    }
  }

  void _onPointerDown(PointerDownEvent e) {
    _activePointers[e.pointer] = e.position;
  }

  void _onPointerMove(PointerMoveEvent e) {
    _activePointers[e.pointer] = e.position;
  }

  void _onPointerUp(PointerEvent e) {
    _activePointers.remove(e.pointer);
  }

  void _onPointerCancel(PointerCancelEvent e) {
    _activePointers.remove(e.pointer);
  }

  bool _areAllActivePointersInsideBox(RenderBox box) {
    if (_activePointers.length < 2) return false;
    final size = box.size;
    for (final pos in _activePointers.values) {
      final local = box.globalToLocal(pos);
      if (local.dx < 0 ||
          local.dx > size.width ||
          local.dy < 0 ||
          local.dy > size.height) {
        return false;
      }
    }
    return true;
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    _isResizing = true;
    _resizeStartSize = widget.cfg.size;
    final box =
        widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      _startFocalLocal = box.globalToLocal(details.globalPosition);
      _startNormalizedPos = widget.cfg.position;
    }
    if (kDebugMode) {
      print(
          'DBG: CalibratableHotspot.longPressStart id=${widget.id} resizeStartSize=$_resizeStartSize');
    }
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    _isResizing = false;
    _resizeStartSize = null;
    if (kDebugMode)
      print('DBG: CalibratableHotspot.longPressEnd id=${widget.id}');
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _startSize = widget.cfg.size;
    final box =
        widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      _isPinchingInside = false;
    } else {
      _startFocalLocal = box.globalToLocal(details.focalPoint);
      _startNormalizedPos = widget.cfg.position;
      _isPinchingInside = _areAllActivePointersInsideBox(box);
    }
    if (kDebugMode) {
      print(
          'DBG: CalibratableHotspot.scaleStart id=${widget.id} startSize=$_startSize isPinchingInside=$_isPinchingInside');
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final box =
        widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      if (kDebugMode)
        print(
            'DBG: CalibratableHotspot.scaleUpdate id=${widget.id} - no renderbox');
      return;
    }
    final size = box.size;

    if (_isPinchingInside &&
        _startSize != null &&
        (details.scale - 1.0).abs() > 0.0001) {
      final newSize = (_startSize! * details.scale).clamp(0.05, 1.0);
      widget.ref
          .read(organicZonesProvider.notifier)
          .setSize(widget.id, newSize);
      if (kDebugMode) {
        print(
            'DBG: CalibratableHotspot.pinchResize id=${widget.id} scale=${details.scale} newSize=$newSize');
      }
      widget.ref.read(calibrationStateProvider.notifier).markAsModified();
      return;
    }

    if (_isResizing && _resizeStartSize != null) {
      final delta = details.focalPointDelta.dy;
      final deltaNormalizedSize = -(delta / size.shortestSide);
      final newSize =
          (_resizeStartSize! + deltaNormalizedSize).clamp(0.05, 1.0);
      widget.ref
          .read(organicZonesProvider.notifier)
          .setSize(widget.id, newSize);
      if (kDebugMode) {
        print(
            'DBG: CalibratableHotspot.resize id=${widget.id} delta=$delta deltaNorm=$deltaNormalizedSize newSize=$newSize');
      }
      widget.ref.read(calibrationStateProvider.notifier).markAsModified();
      return;
    }

    if (details.focalPointDelta != Offset.zero) {
      final deltaGlobal = details.focalPointDelta;
      final deltaNormalized =
          Offset(deltaGlobal.dx / size.width, deltaGlobal.dy / size.height);
      final currentPos = widget.cfg.position;
      final newPos = Offset(
        (currentPos.dx + deltaNormalized.dx).clamp(0.0, 1.0),
        (currentPos.dy + deltaNormalized.dy).clamp(0.0, 1.0),
      );
      widget.ref
          .read(organicZonesProvider.notifier)
          .setPosition(widget.id, newPos);
      if (kDebugMode) {
        print(
            'DBG: CalibratableHotspot.pan id=${widget.id} deltaGlobal=$deltaGlobal deltaNormalized=$deltaNormalized newPos=$newPos');
      }
      widget.ref.read(calibrationStateProvider.notifier).markAsModified();
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _startSize = null;
    _startFocalLocal = null;
    _startNormalizedPos = null;
    _resizeStartSize = null;
    _isResizing = false;
    _isPinchingInside = false;
    _activePointers.clear();

    if (kDebugMode) print('DBG: CalibratableHotspot.scaleEnd id=${widget.id}');
  }

  Future<void> _handleGardenTap() async {
    final slot = _extractSlotNumber(widget.id);
    if (slot == null) {
      if (kDebugMode) print('DBG: Slot invalide pour id=${widget.id}');
      return;
    }

    final gardenId = await DashboardSlotsRepository.getGardenIdForSlot(slot);

    if (gardenId != null) {
      // Awakening stop logic removed.


      // 2) Planifier la modification du provider + navigation APRÈS la frame courante
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Efface proprement l'active garden (après le build), évite l'assert Riverpod.
          widget.ref
              .read(activeGardenIdProvider.notifier)
              .setActiveGarden(null);
          if (kDebugMode)
            debugPrint(
                '[Insect][navigate] cleared activeGarden (postFrame) before navigation');
        } catch (e, st) {
          if (kDebugMode)
            debugPrint(
                '[Insect][navigate] error clearing active garden postFrame: $e\n$st');
        }

        try {
          // Sélection du jardin et navigation (toujours après le clear).
          widget.ref.read(gardenProvider.notifier).selectGarden(gardenId);
          context.push('/gardens/$gardenId?fromOrganic=1');
        } catch (e, st) {
          if (kDebugMode)
            debugPrint('[Insect][navigate] select or push error: $e\n$st');
        }
      });
    } else {
      // Pas de garden : navigation vers création, planifiée hors frame pour cohérence.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          context.push('/gardens/create?slot=$slot');
        } catch (e, st) {
          if (kDebugMode)
            debugPrint('[Insect][navigate] push create error: $e\n$st');
        }
      });
    }
  }

  Future<void> _handleGardenLongPress() async {
    final slot = _extractSlotNumber(widget.id);
    if (slot == null) {
      if (kDebugMode) print('DBG: Slot invalide pour id=${widget.id}');
      return;
    }

    final gardenId = await DashboardSlotsRepository.getGardenIdForSlot(slot);

    if (gardenId != null) {
      // 1) Sélection logique (contexte)
      try {
        widget.ref.read(gardenProvider.notifier).selectGarden(gardenId);
      } catch (e, st) {
        if (kDebugMode)
          debugPrint('[Insect][select] selectGarden error: $e\n$st');
      }

      // 2) Toggle atomique via le provider central (qui orchestre registry)
      try {
        widget.ref
            .read(activeGardenIdProvider.notifier)
            .toggleActiveGarden(gardenId);
        if (kDebugMode)
          debugPrint('[Insect][activate] toggleActiveGarden -> $gardenId');
      } catch (e, st) {
        if (kDebugMode)
          debugPrint(
              '[Insect][activate] error toggling active garden: $e\n$st');
      }

      // 3) Lire l'état APRES le toggle pour décider du feedback visuel:
      final nowActive = widget.ref.read(activeGardenIdProvider);

      if (nowActive == gardenId) {
        // Nous venons d'activer ce garden:
          // Awakening triggering removed.
        // Message utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Jardin $gardenId activé'),
              duration: const Duration(seconds: 2)),
        );
      } else {
        // Nous venons de désactiver ce garden.
        // Message utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Jardin $gardenId désactivé'),
              duration: const Duration(seconds: 1)),
        );
      }
    } else {
      // Pas de garden assigné : feedback + navigation si tu veux.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun jardin assigné à ce slot')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCalibrating) {
      return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: GestureDetector(
          onLongPressStart: _handleLongPressStart,
          onLongPressEnd: _handleLongPressEnd,
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onScaleEnd: _handleScaleEnd,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.08),
              border: Border.all(color: Colors.cyan.withOpacity(0.7), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.cfg.id,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }

    final isGardenHotspot = widget.id.startsWith('garden_');

    final hotspotButton = _HotspotButton(
      onTap: isGardenHotspot
          ? _handleGardenTap
          : () {
              if (kDebugMode) {
                debugPrint(
                    'OrganicDashboard: tapped calibrated hotspot (${widget.id}) -> ${widget.onTapRoute}');
              }
              if (widget.onTapRoute != null) {
                context.push(widget.onTapRoute!);
              }
            },
      onLongPress: isGardenHotspot && !widget.isCalibrating
          ? _handleGardenLongPress
          : null,
      semanticLabel: widget.cfg.id,
      showDebugOutline: widget.showDebugOutline,
      child: (!isGardenHotspot && widget.id == 'weather')
          ? const WeatherBubbleWidget()
          : null,
    );

    if (isGardenHotspot) {
      // Awakening widget removed, just returning the hotspot button.
      return hotspotButton;
    }

    return hotspotButton;
  }

  @override
  void dispose() {
    // Registry unregister removed.

    _activePointers.clear();
    super.dispose();
  }
}

class WeatherBubbleContent extends ConsumerWidget {
  const WeatherBubbleContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weatherAsync = ref.watch(currentWeatherProvider);

    return Center(
      child: weatherAsync.when(
        loading: () => const SizedBox(
          width: 42,
          height: 42,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (e, st) => Icon(Icons.cloud_off, color: theme.colorScheme.onSurface, size: 28),
        data: (data) {
          final tempVal = data.temperature ?? data.currentTemperatureC;
          final temp = tempVal != null ? tempVal.toStringAsFixed(0) : '--';
          final iconPath = data.icon ?? WeatherIconMapper.getFallbackIcon();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 6),
              Text('$temp°C',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [Shadow(blurRadius: 2, color: Colors.black54, offset: Offset(0,1))],
                  )),
              if (data.description != null)
                Text(data.description!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
            ],
          );
        },
      ),
    );
  }
}
