import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_router.dart';
import '../../core/models/organic_zone_config.dart';
import '../../core/providers/organic_zones_provider.dart';
import '../../core/models/calibration_state.dart';
import '../widgets/calibration_debug_overlay.dart';

/// OrganicDashboardWidget
/// - Affiche une grande image organique (background PNG).
/// - Superpose des hotspots qui peuvent être calibrés (position + taille).
/// - En mode debug, affiche un outline + label pour caler les zones.
class OrganicDashboardWidget extends ConsumerStatefulWidget {
  const OrganicDashboardWidget({
    super.key,
    this.assetPath = 'assets/images/backgrounds/dashboard_organic_final.png',
    this.showDiagnostics = true,
  });

  final String assetPath;
  final bool showDiagnostics;

  // Defaults (migrated from previous static hotspots)
  static const List<_Hotspot> _hotspots = <_Hotspot>[
    _Hotspot(id: 'intelligence', centerX: 0.18, centerY: 0.22, widthFrac: 0.20, heightFrac: 0.20, route: AppRoutes.intelligence, label: 'Intelligence'),
    _Hotspot(id: 'calendar', centerX: 0.18, centerY: 0.50, widthFrac: 0.20, heightFrac: 0.20, route: AppRoutes.calendar, label: 'Calendar'),
    _Hotspot(id: 'activities', centerX: 0.18, centerY: 0.78, widthFrac: 0.20, heightFrac: 0.20, route: AppRoutes.activities, label: 'Activities'),
    _Hotspot(id: 'weather', centerX: 0.50, centerY: 0.18, widthFrac: 0.18, heightFrac: 0.18, route: AppRoutes.weather, label: 'Weather'),
    _Hotspot(id: 'gardens', centerX: 0.65, centerY: 0.28, widthFrac: 0.42, heightFrac: 0.36, route: AppRoutes.gardens, label: 'Gardens'),
  ];

  @override
  ConsumerState<OrganicDashboardWidget> createState() => _OrganicDashboardWidgetState();
}

class _OrganicDashboardWidgetState extends ConsumerState<OrganicDashboardWidget> {
  final GlobalKey _containerKey = GlobalKey();
  double? _initialSizeForScale;

  @override
  void initState() {
    super.initState();
    // Load stored positions / sizes for organic zones (defaults derived from _hotspots)
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
      defaultSizes[hs.id] = (hs.widthFrac > hs.heightFrac) ? hs.widthFrac : hs.heightFrac;
      defaultEnabled[hs.id] = true;
    }

    try {
      await ref.read(organicZonesProvider.notifier).loadFromStorage(
        defaultPositions: defaultPositions,
        defaultSizes: defaultSizes,
        defaultEnabled: defaultEnabled,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('🔧 [CALIBRATION] error loading defaults: $e');
    }
  }

  // Diagnostic helper that returns asset checks
  static Future<_AssetDiagnostic> _diagnoseAsset(String assetPath) async {
    final diag = _AssetDiagnostic();
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      diag.manifestLoaded = true;
      diag.declared = manifest.contains('"$assetPath"') || manifest.contains(assetPath);
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
      final double width = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
      final double height = (width * (9.0 / 5.0)).clamp(300.0, 1400.0);

      // map of routes from defaults for easy lookup
      final Map<String, String> _routeMap = {for (final h in OrganicDashboardWidget._hotspots) h.id: h.route};

      return SizedBox(
        width: double.infinity,
        height: height,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            key: _containerKey,
            children: [
              // Use BoxFit.fill so the pixel area matches the overlay box (no center crop)
              Positioned.fill(
                child: Image.asset(
                  widget.assetPath,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  isAntiAlias: true,
                  errorBuilder: (context, error, stack) {
                    if (kDebugMode) debugPrint('OrganicDashboard: asset not found -> ${widget.assetPath} : $error');
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_not_supported, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            Text('Visuel absent', style: Theme.of(context).textTheme.bodyMedium),
                            if (kDebugMode) ...[
                              const SizedBox(height: 8),
                              Text(widget.assetPath, style: Theme.of(context).textTheme.labelSmall),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // If zones are empty (race condition), fallback to defaults
              ...((zones.isEmpty) ? OrganicDashboardWidget._hotspots.map((hs) {
                final double side = ((hs.widthFrac > hs.heightFrac) ? hs.widthFrac : hs.heightFrac) * (width < height ? width : height);
                final double left = (hs.centerX * width) - side / 2;
                final double top = (hs.centerY * height) - side / 2;

                return Positioned(
                  left: left,
                  top: top,
                  width: side,
                  height: side,
                  child: _HotspotButton(
                    onTap: () {
                      if (kDebugMode) debugPrint('OrganicDashboard: tapped hotspot (${hs.id}) -> ${hs.route}');
                      context.push(hs.route);
                    },
                    showDebugOutline: kDebugMode && widget.showDiagnostics,
                    semanticLabel: hs.label,
                  ),
                );
              }).toList() : zones.entries.map((entry) {
                final id = entry.key;
                final cfg = entry.value;
                if (!cfg.enabled) return const SizedBox.shrink();

                final side = (cfg.size * (width < height ? width : height)).clamp(8.0, (width < height ? width : height));
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
                    showDebugOutline: kDebugMode && widget.showDiagnostics,
                  ),
                );
              }).toList()),

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
                            SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 8),
                            Text('Checking...', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        );
                      } else if (snap.hasError) {
                        body = Text('Diag failed: ${snap.error}', style: const TextStyle(color: Colors.redAccent, fontSize: 12));
                      } else {
                        final d = snap.data!;
                        final declared = d.declared ? 'YES' : 'NO';
                        final declaredColor = d.declared ? Colors.greenAccent : Colors.orangeAccent;
                        final loadOk = d.loadOk ? 'OK (${d.sizeBytes ?? 0} bytes)' : 'FAILED';
                        final loadColor = d.loadOk ? Colors.greenAccent : Colors.redAccent;

                        body = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('asset:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(width: 6),
                                Flexible(child: Text(widget.assetPath, style: const TextStyle(color: Colors.white, fontSize: 12))),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text('declared:', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(width: 6),
                                Text(declared, style: TextStyle(color: declaredColor, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('load:', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(width: 6),
                                Text(loadOk, style: TextStyle(color: loadColor, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ],
                        );
                        bg = d.declared && d.loadOk ? Colors.black.withOpacity(0.24) : Colors.black.withOpacity(0.38);
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

/// Small hotspot descriptor (defaults)
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

/// Basic tappable hotspot used as fallback / non-calibration UI
class _HotspotButton extends StatelessWidget {
  const _HotspotButton({
    required this.onTap,
    this.showDebugOutline = false,
    this.semanticLabel,
  });

  final VoidCallback onTap;
  final bool showDebugOutline;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                    border: Border.all(color: Colors.orangeAccent.withOpacity(0.95), width: 1.5),
                  )
                : const BoxDecoration(color: Colors.transparent),
            child: showDebugOutline
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
                          shadows: const [Shadow(blurRadius: 2, color: Colors.black87, offset: Offset(0, 1))],
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// Hotspot widget that supports calibration (pan + pinch-to-scale)
class _CalibratableHotspot extends StatelessWidget {
  const _CalibratableHotspot({
    required this.id,
    required this.cfg,
    required this.isCalibrating,
    required this.onTapRoute,
    required this.containerKey,
    required this.ref,
    this.showDebugOutline = false,
    super.key,
  });

  final String id;
  final OrganicZoneConfig cfg;
  final bool isCalibrating;
  final String? onTapRoute;
  final GlobalKey containerKey;
  final WidgetRef ref;
  final bool showDebugOutline;

  void _handlePanUpdate(DragUpdateDetails details) {
    final box = containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    final size = box.size;
    final normalized = Offset((local.dx / size.width).clamp(0.0, 1.0), (local.dy / size.height).clamp(0.0, 1.0));
    ref.read(organicZonesProvider.notifier).setPosition(id, normalized);
    ref.read(calibrationStateProvider.notifier).markAsModified();
  }

  double? _startSize;
  void _handleScaleStart(ScaleStartDetails details) {
    _startSize = cfg.size;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_startSize == null) return;
    final newSize = (_startSize! * details.scale).clamp(0.05, 1.0);
    ref.read(organicZonesProvider.notifier).setSize(id, newSize);
    ref.read(calibrationStateProvider.notifier).markAsModified();
  }

  @override
  Widget build(BuildContext context) {
    if (isCalibrating) {
      return GestureDetector(
        onPanUpdate: _handlePanUpdate,
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.08),
            border: Border.all(color: Colors.cyan.withOpacity(0.7), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              cfg.id,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    // Normal behaviour: tap to navigate
    return _HotspotButton(
      onTap: () {
        if (kDebugMode) debugPrint('OrganicDashboard: tapped calibrated hotspot ($id) -> $onTapRoute');
        if (onTapRoute != null) context.push(onTapRoute!);
      },
      semanticLabel: cfg.id,
      showDebugOutline: showDebugOutline,
    );
  }
}