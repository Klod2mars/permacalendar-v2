import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import 'package:permacalendar/features/statistics/application/providers/nutrition_detailed_provider.dart';

class SeasonalTrendWidget extends StatelessWidget {
  final int selectedMonth;
  final Map<int, MonthlyNutritionStats> monthlyStatsMap;
  final Map<String, double> annualData;
  final Function(int) onMonthTap;

  const SeasonalTrendWidget({
    super.key,
    required this.selectedMonth,
    required this.monthlyStatsMap,
    required this.annualData,
    required this.onMonthTap,
  });

  @override
  Widget build(BuildContext context) {
    // If no stats at all, return empty? Or empty chart?
    // We assume the map is 1..12 populated (thanks to provider logic).
    
    final l10n = AppLocalizations.of(context)!;
    
    // Get stats for selected month
    final currentStats = monthlyStatsMap[selectedMonth]!;
    final monthlyData = currentStats.nutrientTotals;
    
    // Determine max quantity for chart scaling
    double maxQty = 0.0;
    for (var m = 1; m <= 12; m++) {
      final q = monthlyStatsMap[m]?.totalQuantityKg ?? 0.0;
      if (q > maxQty) maxQty = q;
    }
    if (maxQty == 0) maxQty = 1.0; // Avoid div by zero

    // Identify Top Contributors for the selected month
    String dominantText = "";
    if (monthlyData.isNotEmpty) {
      final sortedEntries = monthlyData.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top3 = sortedEntries.take(3).map((e) => _formatKey(e.key, l10n)).join(", ");
      dominantText = "${l10n.nutrition_dominant_production} $top3";
    } else {
       // If no data for this month
       dominantText = "Aucune donnée nutritive pour ce mois.";
    }

    String monthName;
    try {
      final dt = DateTime(2024, selectedMonth);
      monthName = DateFormat.MMMM(l10n.localeName).format(dt);
    } catch (_) {
      monthName = selectedMonth.toString();
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
          // Header
          Text(
            l10n.nutrition_month_dynamics_title(monthName),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          
          // Dominant production text
          Text(
            dominantText,
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
          
          const SizedBox(height: 24),
          
          // BAR CHART
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final m = index + 1;
                final stat = monthlyStatsMap[m];
                final qty = stat?.totalQuantityKg ?? 0.0;
                final isSelected = m == selectedMonth;
                
                // Height ratio
                final ratio = qty / maxQty;
                // Min height visual (4px)
                final visualRatio = max(0.05, ratio); 
                
                // Color
                final barColor = isSelected 
                    ? const Color(0xFF4CAF50) // Green for selected
                    : (qty > 0 ? Colors.white38 : Colors.white10);
                
                // Month Label (J, F, M...)
                final mLabel = _getMonthLetter(m, l10n.localeName);

                return GestureDetector(
                  onTap: () => onMonthTap(m),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       // Tooltip or Value could go here
                       AnimatedContainer(
                         duration: const Duration(milliseconds: 300),
                         width: 12, // Bar width
                         height: 90 * visualRatio, // 90px max height
                         decoration: BoxDecoration(
                           color: barColor,
                           borderRadius: BorderRadius.circular(4),
                         ),
                       ),
                       const SizedBox(height: 8),
                       Text(
                         mLabel,
                         style: TextStyle(
                           color: isSelected ? const Color(0xFF4CAF50) : Colors.white38,
                           fontSize: 10,
                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                         ),
                       ),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
  
  String _getMonthLetter(int month, String locale) {
    try {
      final dt = DateTime(2024, month);
      final fmt = DateFormat.MMM(locale).format(dt);
      return fmt.substring(0, 1).toUpperCase();
    } catch (_) {
      return "$month";
    }
  }

  String _formatKey(String key, AppLocalizations l10n) {
    final lower = key.toLowerCase();
    
    // Check known l10n keys first
    switch (lower) {
      case 'calcium_mg': return l10n.nut_calcium;
      case 'potassium_mg': return l10n.nut_potassium;
      case 'magnesium_mg': return l10n.nut_magnesium;
      case 'iron_mg': return l10n.nut_iron;
      case 'zinc_mg': return l10n.nut_zinc;
      case 'manganese_mg': return l10n.nut_manganese;
      case 'vitamin_c_mg': return l10n.nut_vitamin_c;
      case 'fiber_g': return l10n.nut_fiber;
      case 'protein_g': return l10n.nut_protein;
    }
    
    // Handle others manually and safely
    if (lower.contains('vitamin_a')) return l10n.localeName == 'fr' ? "Vitamine A" : "Vitamin A";
    if (lower.contains('vitamin_b9') || lower.contains('folate')) return l10n.localeName == 'fr' ? "Vitamine B9" : "Vitamin B9";
    if (lower.contains('vitamin_e')) return l10n.localeName == 'fr' ? "Vitamine E" : "Vitamin E";
    if (lower.contains('vitamin_k')) return l10n.localeName == 'fr' ? "Vitamine K" : "Vitamin K";
    if (lower.contains('vitamin_b6')) return l10n.localeName == 'fr' ? "Vitamine B6" : "Vitamin B6";
    
    // Generic fallback
    String label = key.split('_')[0];
    if (label.toLowerCase() == 'vitamin') {
       // Try to find letter? key like vitamin_a_mcg
       final parts = key.split('_');
       if (parts.length > 1) {
         label = "$label ${parts[1].toUpperCase()}";
       }
    }
    return label.capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
