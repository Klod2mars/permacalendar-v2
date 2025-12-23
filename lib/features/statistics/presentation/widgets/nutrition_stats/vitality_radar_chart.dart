import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../application/providers/nutrition_radar_provider.dart';

class VitalityRadarChart extends StatelessWidget {
  final NutritionRadarData data;

  const VitalityRadarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Neon Green Colors
    const Color primaryColor = Color(0xFF00FFC2); // Cyber Green
    const Color gridColor = Color(0xFF333333);
    const Color textColor = Colors.white70;

    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: primaryColor.withAlpha((0.4 * 255).toInt()), // 40% opacity for Silhouette effect
              borderColor: primaryColor,
              entryRadius: 3,
              borderWidth: 2,
              dataEntries: [
                RadarEntry(value: _cap(data.energyScore)),
                RadarEntry(value: _cap(data.proteinScore)),
                RadarEntry(value: _cap(data.fiberScore)),
                RadarEntry(value: _cap(data.vitaminScore)),
                RadarEntry(value: _cap(data.mineralScore)),
                RadarEntry(value: _cap(data.antioxidantScore)),
              ],
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.transparent),
          titlePositionPercentageOffset: 0.15, // Distance titles from center
          titleTextStyle: const TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
          getTitle: (index, angle) {
            switch (index) {
              case 0: return const RadarChartTitle(text: 'Énergie', angle: 0);
              case 1: return const RadarChartTitle(text: 'Protéines', angle: 0);
              case 2: return const RadarChartTitle(text: 'Fibres', angle: 0);
              case 3: return const RadarChartTitle(text: 'Vitamines', angle: 0);
              case 4: return const RadarChartTitle(text: 'Minéraux', angle: 0);
              case 5: return const RadarChartTitle(text: 'Antiox', angle: 0);
              default: return const RadarChartTitle(text: '');
            }
          },
          tickCount: 3,
          ticksTextStyle: const TextStyle(color: Colors.transparent), // Hide ticks text
          tickBorderData: const BorderSide(color: gridColor, width: 1),
          gridBorderData: const BorderSide(color: gridColor, width: 1),
        ),

      ),
    );
  }

  // Cap values visually at 120% to avoid graph breaking, but conceptually keep logic
  double _cap(double value) {
    if (value > 120) return 120;
    return value;
  }
}
