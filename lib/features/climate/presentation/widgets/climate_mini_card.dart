import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/models/daily_weather_point.dart';

/// Widget rÃ©utilisable pour afficher une mini-carte mÃ©tÃ©o
///
/// Phase P2: Mini-carte simple avec icÃ´ne, tempÃ©ratures, prÃ©cipitations et date
/// UtilisÃ© dans la grille du GardenClimatePanel
class ClimateMiniCard extends StatelessWidget {
  const ClimateMiniCard({
    super.key,
    required this.weatherPoint,
    required this.isToday,
    this.onTap,
  });

  final DailyWeatherPoint weatherPoint;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: _FrostCard(
        emphasis: isToday ? FrostEmphasis.high : FrostEmphasis.normal,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec date et accent pour aujourd'hui
            Row(
              children: [
                Expanded(
                  child: Text(
                    _getDateLabel(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isToday) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'AUJ.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.amber.shade200,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 8),

            // IcÃ´ne mÃ©tÃ©o
            Center(
              child: _getWeatherIcon(),
            ),

            const SizedBox(height: 8),

            // TempÃ©ratures
            if (weatherPoint.tMaxC != null && weatherPoint.tMinC != null)
              Center(
                child: Text(
                  '${weatherPoint.tMaxC!.toStringAsFixed(0)}Â° / ${weatherPoint.tMinC!.toStringAsFixed(0)}Â°',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 4),

            // PrÃ©cipitations
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.grain,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${weatherPoint.precipMm.toStringAsFixed(1)}mm',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateLabel() {
    if (isToday) {
      return 'Aujourd\'hui';
    }

    final now = DateTime.now();
    final date = weatherPoint.date;
    final daysDiff = date.difference(now).inDays;

    if (daysDiff == 1) {
      return 'Demain';
    } else if (daysDiff == 2) {
      return 'AprÃ¨s-demain';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    }
  }

  Widget _getWeatherIcon() {
    // Logique simple basÃ©e sur les prÃ©cipitations et tempÃ©ratures
    if (weatherPoint.precipMm > 5.0) {
      return const Icon(
        Icons.grain,
        color: Colors.white,
        size: 24,
      );
    } else if (weatherPoint.precipMm > 1.0) {
      return const Icon(
        Icons.cloudy_snowing,
        color: Colors.white,
        size: 24,
      );
    } else if (weatherPoint.tMaxC != null && weatherPoint.tMaxC! > 25) {
      return const Icon(
        Icons.wb_sunny,
        color: Colors.white,
        size: 24,
      );
    } else if (weatherPoint.tMaxC != null && weatherPoint.tMaxC! < 10) {
      return const Icon(
        Icons.ac_unit,
        color: Colors.white,
        size: 24,
      );
    } else {
      return const Icon(
        Icons.wb_cloudy,
        color: Colors.white,
        size: 24,
      );
    }
  }
}

// ============================================================================
// REUSABLE FROSTED GLASS COMPONENTS (extracted from garden_climate_panel.dart)
// ============================================================================

enum FrostEmphasis { low, normal, high }

class _FrostCard extends StatelessWidget {
  const _FrostCard({
    required this.child,
    this.emphasis = FrostEmphasis.normal,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final FrostEmphasis emphasis;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final blur = switch (emphasis) {
      FrostEmphasis.high => 16.0,
      FrostEmphasis.normal => 12.0,
      FrostEmphasis.low => 8.0,
    };
    final opacity = switch (emphasis) {
      FrostEmphasis.high => 0.28,
      FrostEmphasis.normal => 0.22,
      FrostEmphasis.low => 0.16,
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(opacity),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            // Accent visuel pour la carte d'aujourd'hui
            boxShadow: emphasis == FrostEmphasis.high
                ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}



