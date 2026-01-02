import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../application/providers/nutrition_kpi_providers.dart';

class SeasonalTimelineChart extends StatelessWidget {
  final List<SeasonalPoint> points;

  const SeasonalTimelineChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox();

    const Color primaryColor = Color(0xFF00FFC2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chronologie de Protection',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(color: Colors.white10, strokeWidth: 1);
                },
              ),
              titlesData: const FlTitlesData(
                show: true,
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: _getTitles,
                  ),
                ),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 1,
              maxX: 12,
              minY: 0,
              maxY: 150, // Cap visuals
              lineBarsData: [
                LineChartBarData(
                  spots: points
                      .map((p) => FlSpot(p.month.toDouble(), p.score))
                      .toList(),
                  isCurved: true,
                  color: primaryColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) =>
                          spot.y > 0, // Show dots only where there is data
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.black,
                          strokeWidth: 2,
                          strokeColor: primaryColor,
                        );
                      }),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withAlpha((0.3 * 255).toInt()),
                        primaryColor.withAlpha(0)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _getTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white54, fontSize: 10);
    int m = value.toInt();
    if (m % 2 != 0) return const SizedBox(); // Show every 2 months
    const months = [
      '',
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D'
    ];
    if (m >= 1 && m <= 12) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(months[m], style: style),
      );
    }
    return const SizedBox();
  }
}
