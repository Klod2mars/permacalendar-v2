import 'package:flutter/material.dart';
import '../../../application/economy_details_provider.dart';

class FastVsLongTable extends StatelessWidget {
  final List<FastLongMetrics> metrics;

  const FastVsLongTable({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();

    // Sort by avgDays DESC
    final sorted = List<FastLongMetrics>.from(metrics)..sort((a,b) => b.avgDaysToHarvest.compareTo(a.avgDaysToHarvest));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle de Rentabilité',
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
              headingTextStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              dataTextStyle: const TextStyle(color: Colors.white),
              columns: const [
                DataColumn(label: Text('Culture')),
                DataColumn(label: Text('Jours (Moy)')),
                DataColumn(label: Text('Rev/Récolte')),
                DataColumn(label: Text('Type')),
              ],
              rows: sorted.map((m) {
                Color typeColor = Colors.white;
                if (m.classification == 'Rapide') typeColor = Colors.greenAccent;
                if (m.classification == 'Long terme') typeColor = Colors.orangeAccent;

                return DataRow(cells: [
                  DataCell(Text(m.plantName)),
                  DataCell(Text('${m.avgDaysToHarvest.toStringAsFixed(0)}j')),
                  DataCell(Text('${m.avgRevenuePerHarvest.toStringAsFixed(2)} €')),
                  DataCell(Text(m.classification, style: TextStyle(color: typeColor))),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
