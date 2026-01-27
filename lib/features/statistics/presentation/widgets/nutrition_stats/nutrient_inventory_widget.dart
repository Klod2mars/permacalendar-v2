import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

class NutrientInventoryWidget extends StatelessWidget {
  final Map<String, double> data;
  final bool showHumanUnits;

  const NutrientInventoryWidget({
    super.key,
    required this.data,
    this.showHumanUnits = false,
  });

  // Reference Daily Intakes (approximate for adults)
  // Used only to scale the visual bars linearly within a category.
  static const Map<String, double> rdiMap = {
    'calories_kcal': 2000,
    'protein_g': 50,
    'fiber_g': 30,
    'fat_g': 70,
    'carbs_g': 260,
    'sugar_g': 90,
    'vitamin_a_mcg': 900,
    'vitamin_c_mg': 90,
    'vitamin_e_mg': 15,
    'vitamin_k_mcg': 120,
    'vitamin_b9_mcg': 400,
    'vitamin_b6_mg': 1.7,
    'calcium_mg': 1000,
    'magnesium_mg': 400,
    'potassium_mg': 4700,
    'iron_mg': 18,
    'zinc_mg': 11,
    'manganese_mg': 2.3,
  };

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.nutrition_no_data_period,
          style: const TextStyle(color: Colors.white24),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    
    // 1. Group Data
    final macros = _filter(data, ['calories_kcal', 'protein_g', 'carbs_g', 'fat_g', 'fiber_g', 'sugar_g']);
    final vitamins = _filter(data, ['vitamin_a_mcg', 'vitamin_c_mg', 'vitamin_e_mg', 'vitamin_k_mcg', 'vitamin_b9_mcg', 'vitamin_b6_mg']);
    final minerals = _filter(data, ['calcium_mg', 'magnesium_mg', 'potassium_mg', 'iron_mg', 'zinc_mg', 'manganese_mg']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (vitamins.isNotEmpty) ...[
          _buildSectionTitle("Vitamines", Colors.tealAccent),
          ..._buildBars(vitamins, l10n, Colors.teal),
          const SizedBox(height: 24),
        ],
        if (minerals.isNotEmpty) ...[
          _buildSectionTitle("Minéraux", Colors.blueAccent),
          ..._buildBars(minerals, l10n, Colors.blue),
          const SizedBox(height: 24),
        ],
        if (macros.isNotEmpty) ...[
          _buildSectionTitle("Macronutriments", Colors.orangeAccent),
          ..._buildBars(macros, l10n, Colors.orange),
        ]
      ],
    );
  }

  Map<String, double> _filter(Map<String, double> source, List<String> allowedKeys) {
    return Map.fromEntries(source.entries.where((e) => allowedKeys.contains(e.key) && e.value > 0));
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  List<Widget> _buildBars(Map<String, double> sectionData, AppLocalizations l10n, MaterialColor colorBase) {
    // Determine max Ratio (Value / RDI) in this section to normalize bar widths
    double maxRatio = 0.0;
    for (var entry in sectionData.entries) {
      final rdi = rdiMap[entry.key] ?? 1.0;
      final ratio = entry.value / rdi;
      if (ratio > maxRatio) maxRatio = ratio;
    }
    if (maxRatio == 0) maxRatio = 1.0;

    return sectionData.entries.map((e) {
      final rdi = rdiMap[e.key] ?? 1.0; // Avoid div by zero
      final ratio = e.value / rdi;
      
      // Normalize width relative to the "biggest" contributor in this group
      // Min width 5% for visibility
      final barWidthPercent = (ratio / maxRatio).clamp(0.05, 1.0);
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            // Label (Left)
            SizedBox(
              width: 100,
              child: Text(
                _formatKey(e.key, l10n),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Bar (Center)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutQuad,
                      width: constraints.maxWidth * barWidthPercent,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorBase.withOpacity(0.6 + (0.4 * barWidthPercent)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                },
              ),
            ),


            const SizedBox(width: 12),
            
            // Value (Right)
            SizedBox(
              width: 80,
              child: Text(
                _formatValue(e.key, e.value),
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatValue(String key, double value) {
    // 1. Identify base unit
    String baseUnit = "";
    double val = value;
    
    if (key.endsWith('_mg')) baseUnit = "mg";
    else if (key.endsWith('_mcg')) baseUnit = "µg";
    else if (key.endsWith('_g')) baseUnit = "g";
    else if (key.endsWith('_kcal')) baseUnit = "kcal";

    // 2. Logic for Human Readable Units
    if (showHumanUnits) {
      if (baseUnit == "µg") {
        if (val >= 1000) {
          val /= 1000;
          baseUnit = "mg";
        }
      }
      
      // Check again (cascade)
      if (baseUnit == "mg") {
        if (val >= 1000) {
          val /= 1000;
          baseUnit = "g";
        }
      }
      
      // Check again (cascade)
      if (baseUnit == "g") {
        if (val >= 1000) {
          val /= 1000;
          baseUnit = "kg";
        }
      }
      
      // Kcal logic
      if (baseUnit == "kcal") {
         // usually we keep kcal, maybe Mcal if huge? 
         // But for gardens, Mcal is possible.
         if (val >= 1000) {
            // val /= 1000; 
            // baseUnit = "Mcal"; // Maybe not standard enough. Keep as is or kCal.
         }
      }

      // Formatting for human readable
      // If > 10, no decimals. If < 10, 1 decimal.
      String valStr;
      if (val >= 100) {
        valStr = val.toStringAsFixed(0);
      } else if (val >= 10) {
        valStr = val.toStringAsFixed(0); // 12 g
      } else {
        valStr = val.toStringAsFixed(1); // 4.5 g
      }
      
      // Clean
      if (valStr.endsWith('.0')) valStr = valStr.substring(0, valStr.length - 2);
      
      return "$valStr $baseUnit";
    }

    // 3. Logic for Technical Units (Existing behavior)
    String valStr;
    if (value >= 1000) {
      if (value > 9999) {
         valStr = value.toStringAsFixed(0);
      } else {
         valStr = value.toStringAsFixed(0);
      }
    } else if (value < 1) {
       valStr = value.toStringAsFixed(2);
    } else {
       valStr = value.toStringAsFixed(1);
    }
    
    if (valStr.endsWith('.0')) valStr = valStr.substring(0, valStr.length - 2);
    if (valStr.endsWith('.00')) valStr = valStr.substring(0, valStr.length - 3);

    return "$valStr $baseUnit";
  }

  String _formatKey(String key, AppLocalizations l10n) {
    final lower = key.toLowerCase();
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
    
    // Robust fallbacks
    if (lower.contains('vitamin_a')) return l10n.localeName == 'fr' ? "Vitamine A" : "Vitamin A";
    if (lower.contains('vitamin_b9') || lower.contains('folate')) return l10n.localeName == 'fr' ? "Vitamine B9" : "Vitamin B9";
    if (lower.contains('vitamin_e')) return l10n.localeName == 'fr' ? "Vitamine E" : "Vitamin E";
    if (lower.contains('vitamin_k')) return l10n.localeName == 'fr' ? "Vitamine K" : "Vitamin K";
    if (lower.contains('vitamin_b6')) return l10n.localeName == 'fr' ? "Vitamine B6" : "Vitamin B6";
    if (lower.contains('calories')) return "Calories";
    if (lower.contains('fat')) return l10n.localeName == 'fr' ? "Lipides" : "Fats";
    if (lower.contains('carbs') || lower.contains('glucide')) return l10n.localeName == 'fr' ? "Glucides" : "Carbs";
    if (lower.contains('sugar')) return l10n.localeName == 'fr' ? "Sucres" : "Sugars";

    String label = key.split('_')[0];
    return "${label[0].toUpperCase()}${label.substring(1)}";
  }
}
