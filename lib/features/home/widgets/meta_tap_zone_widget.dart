import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permacalendar/core/models/meta_tap_zone_config.dart';

/// A widget that defines an interactive (or calibratable) Meta Tap Zone.
///
/// It strictly separates the "visual" size from the "hit" size by applying
/// an automatic inflation if the zone is too small (acc. to [minTapSizeDp]).
class MetaTapZoneWidget extends StatelessWidget {
  const MetaTapZoneWidget({
    super.key,
    required this.config,
    required this.isCalibrationMode,
    required this.onTap,
    this.minTapSizeDp = 48.0,
    required this.containerSize,
  });

  final MetaTapZoneConfig config;
  final bool isCalibrationMode;
  final VoidCallback onTap;
  final double minTapSizeDp;
  final Size containerSize;

  @override
  Widget build(BuildContext context) {
    // Calculate the absolute geometry from normalized configuration
    final double shortestSide =
        containerSize.width < containerSize.height
            ? containerSize.width
            : containerSize.height;

    final double zoneDiameter = config.size * shortestSide;
    final double left = config.position.dx * containerSize.width - zoneDiameter / 2;
    final double top = config.position.dy * containerSize.height - zoneDiameter / 2;

    // Calculate inflation to meet minimum tap size requirements
    final double effectiveSize = zoneDiameter >= minTapSizeDp ? zoneDiameter : minTapSizeDp;
    final double inflation = (effectiveSize - zoneDiameter) / 2.0;

    // We position the widget to cover the INFLATED area.
    // Inside, we might render the visual debug marker smaller if needed,
    // but the GestureDetector covers the whole inflamed area.
    
    return Positioned(
      left: left - inflation,
      top: top - inflation,
      width: effectiveSize,
      height: effectiveSize,
      child: GestureDetector(
        // Translucent allows us to catch taps even if we are invisible
        // BUT also lets clicks pass through if we explicitly ignore them?
        // No, translucent means: if I hit a visual part (even transparent), I win.
        // If I hit a hole, I pass. But Container with color: Colors.transparent IS hit.
        // We want to CAPTURE the tap if we are the priority target.
        // Since we are rendered *before* business zones (underneath), 
        // we actually want the OPPOSITE of "Stack priority dictates top-most wins".
        // Wait.
        // Standard Stack: Last child is on top. Top-most receives tap.
        // User Plan: "Render meta-zones BEFORE business hotspots... so business hotspots (rendered later) remain on top."
        // Correct. If business zone overlaps this, business zone is on top and takes the tap.
        // So we just need standard Opaque/Translucent behavior.
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (isCalibrationMode) {
            // In calibration mode, taps might be handled by a parent layer 
            // or we might want to select this zone.
            // For now, let's just consume it or let the parent logic (if any) handle selection.
            // But usually calibration involves dragging.
            return;
          }
          HapticFeedback.lightImpact();
          onTap();
        },
        child: isCalibrationMode
            ? _buildCalibrationOverlay(zoneDiameter)
            : const SizedBox.expand(),
      ),
    );
  }

  Widget _buildCalibrationOverlay(double actualVisualDiameter) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // The Hit Area (diffused red visualization)
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        // The Visual Target (simulating the bubble size)
        Container(
          width: actualVisualDiameter,
          height: actualVisualDiameter,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent, width: 2),
          ),
          child: const Center(
            child: Icon(Icons.touch_app, size: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
