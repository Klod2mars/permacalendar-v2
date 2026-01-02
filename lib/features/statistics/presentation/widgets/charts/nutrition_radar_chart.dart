import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:permacalendar/features/statistics/application/providers/nutrition_radar_provider.dart';

class NutritionRadarChart extends StatelessWidget {
  final NutritionRadarData data;
  final double? size;

  const NutritionRadarChart({super.key, required this.data, this.size});

  @override
  Widget build(BuildContext context) {
    // Normalization logic for visualization:
    // We want a balanced shape. We take the max value among axes to scale the chart,
    // but we cap the minimum scale to avoid a tiny chart if values are low.
    final maxVal = [
      data.vitaminScore,
      data.mineralScore,
      data.fiberScore,
      data.proteinScore
    ].reduce((curr, next) => curr > next ? curr : next);

    // Si toutes les valeurs sont 0, afficher un chart vide équilibré
    final safeMax = maxVal > 0 ? maxVal * 1.2 : 100.0; // 1.2 for padding

    Widget chart = RadarChart(
      RadarChartData(
        radarTouchData: RadarTouchData(
            enabled: false), // Non interactif pour l'instant (petit widget)
        dataSets: [
          RadarDataSet(
            fillColor: Colors.greenAccent.withOpacity(0.2),
            borderColor: Colors.greenAccent,
            entryRadius: 3,
            dataEntries: [
              RadarEntry(value: data.vitaminScore),
              RadarEntry(value: data.mineralScore),
              RadarEntry(value: data.fiberScore),
              RadarEntry(value: data.proteinScore),
            ],
            borderWidth: 2,
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: const BorderSide(color: Colors.transparent),
        titlePositionPercentageOffset: 0.2,
        titleTextStyle: const TextStyle(color: Colors.white70, fontSize: 10),
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(text: 'Vitamines', angle: angle);
            case 1:
              return RadarChartTitle(text: 'Minéraux', angle: angle);
            case 2:
              return RadarChartTitle(text: 'Fibres', angle: angle);
            case 3:
              return RadarChartTitle(text: 'Protéines', angle: angle);
            default:
              return const RadarChartTitle(text: '');
          }
        },
        tickCount: 3,
        ticksTextStyle: const TextStyle(
            color: Colors.transparent,
            fontSize: 0), // Masquer les ticks internes
        tickBorderData: const BorderSide(color: Colors.white10),
        gridBorderData: const BorderSide(color: Colors.white24, width: 1),
      ),
      swapAnimationDuration: const Duration(milliseconds: 400),
      swapAnimationCurve: Curves.easeInOut,
    );

    if (size != null) {
      return SizedBox(
        width: size,
        height: size,
        child: chart,
      );
    }
    return chart;
  }
}
