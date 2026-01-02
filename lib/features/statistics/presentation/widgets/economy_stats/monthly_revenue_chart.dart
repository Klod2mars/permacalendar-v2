import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../application/economy_details_provider.dart';

class MonthlyRevenueChart extends StatelessWidget {
  final List<MonthRevenue> monthlyRevenue;

  const MonthlyRevenueChart({super.key, required this.monthlyRevenue});

  @override
  Widget build(BuildContext context) {
    if (monthlyRevenue.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
            child: Text('Pas de données mensuelles',
                style: TextStyle(color: Colors.white54))),
      );
    }

    final maxY = monthlyRevenue.fold(
            0.0, (m, e) => e.totalValue > m ? e.totalValue : m) *
        1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenu Mensuel',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY == 0 ? 100 : maxY,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Colors.black87,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final monthData = monthlyRevenue[group.x.toInt()];
                    return BarTooltipItem(
                      '${_monthName(monthData.month)}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${rod.toY.toStringAsFixed(0)} €',
                          style: const TextStyle(
                            color: Colors.lightGreenAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < monthlyRevenue.length) {
                        // Show only if not too crowded?
                        // For 12 months, usually ok.
                        // Use simplified month letter
                        final m = monthlyRevenue[value.toInt()].month;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _monthShortName(m),
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
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: monthlyRevenue.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.totalValue,
                      color: Colors.lightGreen,
                      width: 14,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  String _monthShortName(int month) {
    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
