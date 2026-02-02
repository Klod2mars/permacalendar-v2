import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/models/meta_tap_zone_config.dart';
import 'package:permacalendar/core/providers/meta_tap_zones_provider.dart';
import 'package:permacalendar/core/models/calibration_state.dart';

/// A widget that defines an interactive (or calibratable) Meta Tap Zone.
///
/// It strictly separates the "visual" size from the "hit" size by applying
/// an automatic inflation if the zone is too small (acc. to [minTapSizeDp]).
///
/// In Calibration Mode, it supports Dragging to reposition.
class MetaTapZoneWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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

    return SizedBox(
      width: containerSize.width,
      height: containerSize.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: left - inflation,
            top: top - inflation,
            width: effectiveSize,
            height: effectiveSize,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (isCalibrationMode) {
                  return;
                }
                HapticFeedback.lightImpact();
                onTap();
              },
              // --- Calibration Drag Logic ---
              onPanUpdate: isCalibrationMode
                  ? (details) {
                      // Calculate normalized delta
                      final dx = details.delta.dx / containerSize.width;
                      final dy = details.delta.dy / containerSize.height;
                      
                      final newPos = Offset(
                        (config.position.dx + dx).clamp(0.0, 1.0),
                        (config.position.dy + dy).clamp(0.0, 1.0),
                      );

                      ref.read(metaTapZonesProvider.notifier).setPosition(config.id, newPos);
                      ref.read(calibrationStateProvider.notifier).markAsModified();
                    }
                  : null,
              // ------------------------------
              child: isCalibrationMode
                  ? _buildCalibrationOverlay(zoneDiameter)
                  : const SizedBox.expand(),
            ),
          ),
        ],
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
