// lib/shared/widgets/organic_dashboard.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app_router.dart';

/// OrganicDashboardWidget
///
/// - Affiche une grande image organique (background PNG).
/// - Superpose des hotspots (dÃ©finis en fractions) qui dÃ©clenchent des routes.
/// - En mode debug, affiche un outline semi-transparent + label pour caler les zones.
/// - Si l'asset manque, affiche un fallback visuel.
/// - En mode debug, affiche un panneau visuel contenant :
///    * build called
///    * si AssetManifest contient l'asset
///    * si rootBundle.load rÃ©ussit et la taille (bytes) ou l'erreur.
class OrganicDashboardWidget extends StatelessWidget {
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
      label: 'Intelligence',
    ),
    _Hotspot(
      id: 'calendar',
      centerX: 0.18,
      centerY: 0.50,
      widthFrac: 0.20,
      heightFrac: 0.20,
      route: AppRoutes.calendar,
      label: 'Calendar',
    ),
    _Hotspot(
      id: 'activities',
      centerX: 0.18,
      centerY: 0.78,
      widthFrac: 0.20,
      heightFrac: 0.20,
      route: AppRoutes.activities,
      label: 'Activities',
    ),
    _Hotspot(
      id: 'weather',
      centerX: 0.50,
      centerY: 0.18,
      widthFrac: 0.18,
      heightFrac: 0.18,
      route: AppRoutes.weather,
      label: 'Weather',
    ),
    _Hotspot(
      id: 'gardens',
      centerX: 0.65,
      centerY: 0.28,
      widthFrac: 0.42,
      heightFrac: 0.36,
      route: AppRoutes.gardens,
      label: 'Gardens',
    ),
  ];

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
    // Immediate visual trace (will also be shown in the overlay).
    if (kDebugMode) {
      // synchronous debug print to keep older behaviour too
      debugPrint('OrganicDashboard: build called -> $assetPath');
    }

    return LayoutBuilder(builder: (context, constraints) {
      final double width =
          constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
      final double height = (width * (9.0 / 5.0)).clamp(300.0, 1400.0);

      return SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          children: [
            // Background image (cover). errorBuilder gives a visible fallback if missing.
            Positioned.fill(
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                isAntiAlias: true,
                errorBuilder: (context, error, stack) {
                  if (kDebugMode) {
                    debugPrint('OrganicDashboard: asset not found -> $assetPath : $error');
                  }
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
                            Text(assetPath, style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Hotspot overlays
            ..._hotspots.map((hs) {
              final double left = (hs.centerX - hs.widthFrac / 2) * width;
              final double top = (hs.centerY - hs.heightFrac / 2) * height;
              final double w = hs.widthFrac * width;
              final double h = hs.heightFrac * height;

              return Positioned(
                left: left,
                top: top,
                width: w,
                height: h,
                child: _HotspotButton(
                  onTap: () {
                    if (kDebugMode) {
                      debugPrint('OrganicDashboard: tapped hotspot (${hs.id}) -> ${hs.route}');
                    }
                    context.push(hs.route);
                  },
                  showDebugOutline: kDebugMode && showDiagnostics,
                  semanticLabel: hs.label,
                ),
              );
            }).toList(),

            // Debug overlay (visible only in debug mode)
            if (kDebugMode && showDiagnostics)
              Positioned(
                top: 8,
                right: 8,
                child: FutureBuilder<_AssetDiagnostic>(
                  future: _diagnoseAsset(assetPath),
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
                              Flexible(child: Text(assetPath, style: const TextStyle(color: Colors.white, fontSize: 12))),
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
                          if (!d.manifestLoaded && d.manifestError != null) ...[
                            const SizedBox(height: 6),
                            Text('manifest err: ${d.manifestError}', style: const TextStyle(color: Colors.redAccent, fontSize: 10)),
                          ],
                          if (!d.loadOk && d.loadError != null) ...[
                            const SizedBox(height: 6),
                            Text('load err: ${d.loadError}', style: const TextStyle(color: Colors.redAccent, fontSize: 10)),
                          ],
                        ],
                      );
                      // set bg color small hint
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

/// Small hotspot descriptor
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
    this.showDebugOutline = false,
    this.semanticLabel,
  });

  final VoidCallback onTap;
  final bool showDebugOutline;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    // Transparent Material + InkWell pour ripple + accessibilitÃ©.
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
                    border: Border.all(
                      color: Colors.orangeAccent.withOpacity(0.95),
                      width: 1.5,
                    ),
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


