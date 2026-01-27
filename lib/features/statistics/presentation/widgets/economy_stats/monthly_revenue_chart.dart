import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/economy_details_provider.dart';
import 'package:permacalendar/core/utils/formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/currency_provider.dart';

class MonthlyRevenueChart extends ConsumerWidget {
  final List<MonthRevenue> monthlyRevenue;

  const MonthlyRevenueChart({super.key, required this.monthlyRevenue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (monthlyRevenue.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
            child: Text(AppLocalizations.of(context)!.stats_monthly_revenue_no_data,
                style: const TextStyle(color: Colors.white54))),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    final maxY = monthlyRevenue.fold(
            0.0, (m, e) => e.totalValue > m ? e.totalValue : m) *
        1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.stats_monthly_revenue_title,
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
                      '${_monthName(monthData.month, l10n.localeName)}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: formatCurrency(rod.toY, ref.watch(currencyProvider)),
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
                        final m = monthlyRevenue[value.toInt()].month;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _monthShortName(m, l10n.localeName),
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

  String _monthName(int month, String locale) {
    // 2024 is a leap year, doesn't matter for month name
    final dt = DateTime(2024, month);
    try {
      return DateFormat.MMMM(locale).format(dt);
    } catch (_) {
      // Fallback if locale format fails or intl not initialized for specific locale logic
      final months = [
        'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
        'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
      ];
      if (month >= 1 && month <= 12) return months[month - 1];
      return '';
    }
  }

  String _monthShortName(int month, String locale) {
    final dt = DateTime(2024, month);
    try {
      // Try to get 1st letter of month name for compactness or just MMM
      // The original code used 1 letter. "J", "F", "M". 
      // Let's use DateFormat.ABBR_MONTH (MMM) usually 3 letters.
      // If we strictly want 1 letter, we can substring.
      // Given font size 10, 3 chars is fine.
      return DateFormat.MMM(locale).format(dt).toUpperCase();
    } catch (_) {
      const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
      if (month >= 1 && month <= 12) return months[month - 1];
      return '';
    }
  }
}
