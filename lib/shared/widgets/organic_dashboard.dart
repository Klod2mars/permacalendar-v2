// lib/shared/widgets/organic_dashboard.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app_router.dart';

/// OrganicDashboardWidget
/// - Affiche l'image PNG organique (background).
/// - Superpose des hotspots responsives (Fraction based).
/// - Chaque hotspot fait `context.push(...)` vers une route existante.
///
/// NOTE: les fractions (x, y, w, h) sont empiriques et peuvent être ajustées
/// via essais/erreurs pour coller parfaitement à ton PNG.
class OrganicDashboardWidget extends StatelessWidget {
  const OrganicDashboardWidget({super.key, this.assetPath = 'assets/images/backgrounds/organic_dashboard.png'});

  final String assetPath;

  // Hotspot definition: centerX, centerY, widthFrac, heightFrac and route
  static const _hotspots = <_Hotspot>[
    // Top-left : graph/weather -> Intelligence
    _Hotspot(centerX: 0.20, centerY: 0.25, widthFrac: 0.22, heightFrac: 0.22, route: AppRoutes.intelligence),
    // Middle-left : calendar -> Calendar
    _Hotspot(centerX: 0.20, centerY: 0.49, widthFrac: 0.22, heightFrac: 0.22, route: AppRoutes.calendar),
    // Bottom-left : stats -> Activities (ou adapt to /stats if available)
    _Hotspot(centerX: 0.20, centerY: 0.78, widthFrac: 0.22, heightFrac: 0.22, route: AppRoutes.activities),
    // Central big leaf : gardens overview
    _Hotspot(centerX: 0.62, centerY: 0.22, widthFrac: 0.46, heightFrac: 0.34, route: AppRoutes.gardens),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Container size that will hold the image and the hotspots
      final width = constraints.maxWidth;
      // Compute a height that works well on portrait phones (we keep image contained)
      // Using a tall aspect roughly matching the sample artwork; UI will adapt.
      final height = (width * (9.0 / 5.0)).clamp(300.0, 1400.0); // tuning: tall container

      return SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          children: [
            // Background image (fit: cover/contain - we choose cover to fill area)
            Positioned.fill(
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                isAntiAlias: true,
              ),
            ),

            // Hotspot overlays
            ..._hotspots.map((hs) {
              final left = (hs.centerX - hs.widthFrac / 2) * width;
              final top = (hs.centerY - hs.heightFrac / 2) * height;
              final w = hs.widthFrac * width;
              final h = hs.heightFrac * height;

              return Positioned(
                left: left,
                top: top,
                width: w,
                height: h,
                child: _HotspotButton(
                  onTap: () {
                    // Debug log
                    if (kDebugMode) {
                      debugPrint('OrganicDashboard: tapped hotspot -> ${hs.route}');
                    }
                    // Navigate
                    context.push(hs.route);
                  },
                  // In debug mode we show a subtle outline to help position zones
                  showDebugOutline: kDebugMode,
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}

class _Hotspot {
  const _Hotspot({
    required this.centerX,
    required this.centerY,
    required this.widthFrac,
    required this.heightFrac,
    required this.route,
  });

  final double centerX;
  final double centerY;
  final double widthFrac;
  final double heightFrac;
  final String route;
}

class _HotspotButton extends StatelessWidget {
  const _HotspotButton({required this.onTap, this.showDebugOutline = false});

  final VoidCallback onTap;
  final bool showDebugOutline;

  @override
  Widget build(BuildContext context) {
    // A transparent material with InkWell to get ripple / accessibility
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Semantics(
          button: true,
          label: 'Dashboard hotspot',
          child: Container(
            // Transparent hit area; debug outline optional
            decoration: showDebugOutline
                ? BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.orangeAccent.withOpacity(0.9), width: 1),
                  )
                : const BoxDecoration(
                    color: Colors.transparent,
                  ),
          ),
        ),
      ),
    );
  }
}
