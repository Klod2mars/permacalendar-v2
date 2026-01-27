import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/economy_details_provider.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/core/utils/formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/currency_provider.dart';

class AnnualRevenueLine extends ConsumerWidget {
  final List<SeriesPoint> revenueSeries;

  const AnnualRevenueLine({super.key, required this.revenueSeries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (revenueSeries.isEmpty) return const SizedBox.shrink();

    final maxY =
        revenueSeries.fold(0.0, (m, e) => e.value > m ? e.value : m) * 1.2;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.stats_annual_evolution_title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < revenueSeries.length) {
                        final date = revenueSeries[value.toInt()].date;
                        // Show only generic months or short date
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            DateFormat('MMM', l10n.localeName).format(date),
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
                  color: Colors.greenAccent,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.greenAccent.withOpacity(0.2),
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
                        '${DateFormat.yMMMM(l10n.localeName).format(point.date)}\n',
                        const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: formatCurrency(point.value, ref.watch(currencyProvider)),
                            style: const TextStyle(
                              color: Colors.greenAccent,
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
}
