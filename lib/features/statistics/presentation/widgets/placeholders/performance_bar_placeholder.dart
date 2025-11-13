import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Placeholder visuel pour le pilier Performance
///
/// Affiche un bar chart avec 3 barres grisÃƒÂ©es de trÃƒÂ¨s faible valeur
/// PrÃƒÂªt pour l'intÃƒÂ©gration de donnÃƒÂ©es de performance en Phase 4
class PerformanceBarPlaceholder extends StatelessWidget {
  const PerformanceBarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 15,
                  color: Colors.grey.withOpacity(0.3),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 10,
                  color: Colors.grey.withOpacity(0.3),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 8,
                  color: Colors.grey.withOpacity(0.3),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



