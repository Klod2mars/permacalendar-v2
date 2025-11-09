// lib/shared/widgets/organic_dashboard.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app_router.dart';

/// OrganicDashboardWidget
///
/// - Affiche une grande image organique (background PNG).
/// - Superpose des hotspots (définis en fractions) qui déclenchent des routes.
/// - En mode debug, affiche un outline semi-transparent + label pour caler les zones.
/// - Si l'asset manque, affiche un fallback visuel et écrit un debugPrint.
class OrganicDashboardWidget extends StatelessWidget {
  /// Chemin vers l'asset par défaut.
  /// Par défaut on pointe vers le nom présent dans le repo : dashboard_organic_final.png
  const OrganicDashboardWidget({
    super.key,
    this.assetPath = 'assets/images/backgrounds/dashboard_organic_final.png',
  });

  final String assetPath;

  // Définition des hotspots par défaut (centerX, centerY, widthFrac, heightFrac)
  // Les valeurs sont exprimées en fraction (0.0..1.0) de la largeur/hauteur du conteneur.
  // Ajuste ±0.02 pour peaufiner sur l'appareil.
  static const List<_Hotspot> _hotspots = <_Hotspot>[
    // Top-left icon (intelligence)
    _Hotspot(
      id: 'intelligence',
      centerX: 0.18,
      centerY: 0.22,
      widthFrac: 0.20,
      heightFrac: 0.20,
      route: AppRoutes.intelligence,
      label: 'Intelligence',
    ),

    // Middle-left (calendar)
    _Hotspot(
      id: 'calendar',
      centerX: 0.18,
      centerY: 0.50,
      widthFrac: 0.20,
      heightFrac: 0.20,
      route: AppRoutes.calendar,
      label: 'Calendar',
    ),

    // Bottom-left (activities)
    _Hotspot(
      id: 'activities',
      centerX: 0.18,
      centerY: 0.78,
      widthFrac: 0.20,
      heightFrac: 0.20,
      route: AppRoutes.activities,
      label: 'Activities',
    ),

    // Large central leaf (gardens overview)
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double width =
          constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
      // Aspect ratio choisi pour l'œuvre ; clamp pour éviter une hauteur extrême.
      final double height = (width * (9.0 / 5.0)).clamp(300.0, 1400.0);

      return SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          children: [
            // Image de fond (cover). errorBuilder fournit un fallback visible si absent.
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
                    // Navigation via GoRouter
                    context.push(hs.route);
                  },
                  showDebugOutline: kDebugMode,
                  semanticLabel: hs.label,
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
    // Transparent Material + InkWell pour ripple + accessibilité.
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
            // Zone de hit transparente ; si debug => outline + label centré.
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
