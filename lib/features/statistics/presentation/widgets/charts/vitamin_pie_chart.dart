import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Widget pour afficher un camembert de distribution vitaminique
///
/// Affiche la rÃ©partition des 5 vitamines (A, B, C, E, K) avec des couleurs distinctes
/// et des pourcentages pour chaque secteur
class VitaminPieChart extends StatelessWidget {
  final Map<String, double> vitaminPercentages;
  final double size;

  const VitaminPieChart({
    super.key,
    required this.vitaminPercentages,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    // Couleurs recommandÃ©es pour chaque vitamine
    const vitaminColors = {
      'vitaminA': Color(0xFFFF8C42), // Orange
      'vitaminB9': Color(0xFF4A90E2), // Bleu
      'vitaminC': Color(0xFF7ED321), // Vert clair
      'vitaminE': Color(0xFF9013FE), // Mauve
      'vitaminK': Color(0xFFFFD700), // Jaune pÃ¢le
    };

    // CrÃ©er les sections du camembert
    final sections = <PieChartSectionData>[];

    for (final entry in vitaminPercentages.entries) {
      final vitaminKey = entry.key;
      final percentage = entry.value;

      // Ignorer les vitamines avec 0%
      if (percentage <= 0) continue;

      final color = vitaminColors[vitaminKey] ?? Colors.grey;

      sections.add(
        PieChartSectionData(
          color: color,
          value: percentage,
          title: '${percentage.toStringAsFixed(0)}%',
          radius: size * 0.4,
          titleStyle: TextStyle(
            fontSize: size * 0.12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titlePositionPercentageOffset: 0.6,
        ),
      );
    }

    // Si aucune donnÃ©e, afficher un secteur gris
    if (sections.isEmpty) {
      sections.add(
        PieChartSectionData(
          color: Colors.grey.withOpacity(0.3),
          value: 100,
          title: '',
          radius: size * 0.4,
          titleStyle: const TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return SizedBox(
      height: size,
      width: size,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: size * 0.3,
          sections: sections,
        ),
      ),
    );
  }
}

/// Widget pour afficher la lÃ©gende des vitamines
class VitaminLegend extends StatelessWidget {
  final Map<String, double> vitaminPercentages;

  const VitaminLegend({
    super.key,
    required this.vitaminPercentages,
  });

  @override
  Widget build(BuildContext context) {
    const vitaminColors = {
      'vitaminA': Color(0xFFFF8C42), // Orange
      'vitaminB9': Color(0xFF4A90E2), // Bleu
      'vitaminC': Color(0xFF7ED321), // Vert clair
      'vitaminE': Color(0xFF9013FE), // Mauve
      'vitaminK': Color(0xFFFFD700), // Jaune pÃ¢le
    };

    const vitaminLabels = {
      'vitaminA': 'Vitamine A',
      'vitaminB9': 'Vitamine B',
      'vitaminC': 'Vitamine C',
      'vitaminE': 'Vitamine E',
      'vitaminK': 'Vitamine K',
    };

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: vitaminPercentages.entries
          .where((entry) => entry.value > 0)
          .map((entry) {
        final vitaminKey = entry.key;
        final percentage = entry.value;
        final color = vitaminColors[vitaminKey] ?? Colors.grey;
        final label = vitaminLabels[vitaminKey] ?? vitaminKey;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$label (${percentage.toStringAsFixed(0)}%)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        );
      }).toList(),
    );
  }
}


