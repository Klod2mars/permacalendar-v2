import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../application/economy_details_provider.dart';
import 'package:intl/intl.dart';

class HistoricalRevenueWidget extends StatelessWidget {
  final List<SeriesPoint> revenueSeries;

  const HistoricalRevenueWidget({super.key, required this.revenueSeries});

  @override
  Widget build(BuildContext context) {
    if (revenueSeries.isEmpty) return const SizedBox.shrink();

    final maxY =
        revenueSeries.fold(0.0, (m, e) => e.value > m ? e.value : m) * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historique du Revenu',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.only(right: 16, top: 24, bottom: 12),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withOpacity(0.05),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: _calculateInterval(revenueSeries.length),
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < revenueSeries.length) {
                        final date = revenueSeries[value.toInt()].date;
                        // If spanning years, show Year, else show Month
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _formatDate(date, revenueSeries.length > 12),
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (revenueSeries.length - 1).toDouble(),
              minY: 0,
              maxY: maxY == 0 ? 10 : maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: revenueSeries.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value.value);
                  }).toList(),
                  isCurved: true,
                  color: Colors.cyanAccent,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyanAccent.withOpacity(0.3),
                        Colors.blueAccent.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.black87,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final point = revenueSeries[touchedSpot.x.toInt()];
                      return LineTooltipItem(
                        '${DateFormat('MMMM yyyy', 'fr_FR').format(point.date)}\n',
                        const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: '${point.value.toStringAsFixed(0)} €',
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateInterval(int length) {
    if (length <= 6) return 1;
    if (length <= 12) return 2;
    return (length / 6).ceilToDouble();
  }

  String _formatDate(DateTime date, bool showYear) {
    if (showYear) {
      return DateFormat('MM/yy').format(date);
    }
    return DateFormat('MMM').format(date);
  }
}
