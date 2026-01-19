import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

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

    final l10n = AppLocalizations.of(context)!;

    // 1. Identify Top Contributors for this month
    final sortedEntries = monthlyData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top3 = sortedEntries.take(3).map((e) => _formatKey(e.key, l10n)).join(", ");

    String monthName;
    try {
      final dt = DateTime(2024, month);
      monthName = DateFormat.MMMM(l10n.localeName).format(dt);
    } catch (_) {
      monthName = month.toString();
    }

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
            l10n.nutrition_month_dynamics_title(monthName),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "${l10n.nutrition_dominant_production} $top3",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.nutrition_nutrients_origin,
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key, AppLocalizations l10n) {
    switch (key) {
      case 'calcium_mg':
        return l10n.nut_calcium;
      case 'potassium_mg':
        return l10n.nut_potassium;
      case 'magnesium_mg':
        return l10n.nut_magnesium;
      case 'iron_mg':
        return l10n.nut_iron;
      case 'zinc_mg':
        return l10n.nut_zinc;
      case 'manganese_mg':
        return l10n.nut_manganese;
      case 'vitamin_c_mg':
        return l10n.nut_vitamin_c;
      case 'fiber_g':
        return l10n.nut_fiber;
      case 'protein_g':
        return l10n.nut_protein;
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
