import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PlantSharePie extends StatelessWidget {
  final Map<String, double> plantShare;

  const PlantSharePie({super.key, required this.plantShare});

  @override
  Widget build(BuildContext context) {
    if (plantShare.isEmpty) return const SizedBox.shrink();

    // Limit to top 5 + "Autres" for readability
    final entries = plantShare.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topEntries = entries.take(5).toList();
    double otherShare = 0;
    if (entries.length > 5) {
      for (int i = 5; i < entries.length; i++) {
        otherShare += entries[i].value;
      }
    }

    final dataPoints = [...topEntries];
    if (otherShare > 0) {
      dataPoints.add(MapEntry('Autres', otherShare));
    }

    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.grey,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Répartition par Culture',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  sections: List.generate(dataPoints.length, (i) {
                    final entry = dataPoints[i];
                    return PieChartSectionData(
                      color: colors[i % colors.length],
                      value: entry.value,
                      title: '', // Too small, rely on legend
                      radius: 40,
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(dataPoints.length, (i) {
                  final entry = dataPoints[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${entry.value.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
