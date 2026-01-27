import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/economy_details_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/currency_provider.dart';
import 'package:permacalendar/core/utils/formatters.dart';

class FastVsLongTable extends ConsumerWidget {
  final List<FastLongMetrics> metrics;

  const FastVsLongTable({super.key, required this.metrics});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (metrics.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    // Sort by avgDays DESC
    final sorted = List<FastLongMetrics>.from(metrics)
      ..sort((a, b) => b.avgDaysToHarvest.compareTo(a.avgDaysToHarvest));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.stats_profitability_cycle_title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.bold),
              dataTextStyle: const TextStyle(color: Colors.white),
              columns: [
                DataColumn(label: Text(l10n.stats_table_crop)),
                DataColumn(label: Text(l10n.stats_table_days)),
                DataColumn(label: Text(l10n.stats_table_revenue)),
                DataColumn(label: Text(l10n.stats_table_type)),
              ],
              rows: sorted.map((m) {
                Color typeColor = Colors.white;
                String typeText = m.classification;
                
                if (m.classification == 'Rapide' || m.classification == 'Fast') {
                  typeColor = Colors.greenAccent;
                  typeText = l10n.stats_type_fast;
                } else if (m.classification == 'Long terme' || m.classification == 'Long Term') {
                  typeColor = Colors.orangeAccent;
                  typeText = l10n.stats_type_long_term;
                }

                return DataRow(cells: [
                  DataCell(Text(m.plantName)),
                  DataCell(Text('${m.avgDaysToHarvest.toStringAsFixed(0)}j')),
                  DataCell(
                      Text(formatCurrency(m.avgRevenuePerHarvest, ref.watch(currencyProvider)))),
                  DataCell(Text(typeText,
                      style: TextStyle(color: typeColor))),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
