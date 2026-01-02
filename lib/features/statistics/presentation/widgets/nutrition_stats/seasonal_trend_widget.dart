import 'package:flutter/material.dart';

class SeasonalTrendWidget extends StatelessWidget {
  final int month;
  final Map<String, double> monthlyData;
  final Map<String, double> annualData;

  const SeasonalTrendWidget({
    super.key,
    required this.month,
    required this.monthlyData,
    required this.annualData,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    // 1. Identify Top Contributors for this month
    final sortedEntries = monthlyData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top3 = sortedEntries.take(3).map((e) => _formatKey(e.key)).join(", ");

    // 2. Calculate "Intensity" of this month vs Annual Average (Simple approach)
    // Average monthly production = Annual / 12 (approx)
    // Intensity = ThisMonthTotalMass / (AnnualTotalMass / 12)
    // Note: This is rough, as mass depends heavily on *what* is harvested (pumpkins vs herbs).
    // Let's stick to qualitative.

    final monthNames = [
      '',
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dynamique de ${monthNames[month]}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Production dominante : $top3",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "Ces nutriments proviennent de vos récoltes du mois.",
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    switch (key) {
      case 'calcium_mg':
        return 'Calcium';
      case 'potassium_mg':
        return 'Potassium';
      case 'magnesium_mg':
        return 'Magnésium';
      case 'iron_mg':
        return 'Fer';
      case 'vitamin_c_mg':
        return 'Vitamine C';
      case 'fiber_g':
        return 'Fibres';
      case 'protein_g':
        return 'Protéines';
      default:
        return key.split('_')[0].capitalize();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
