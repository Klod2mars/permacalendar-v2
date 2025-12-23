import 'package:flutter/material.dart';
import '../../../application/providers/nutrition_kpi_providers.dart';

class DeficiencyGauge extends StatelessWidget {
  final List<NutrientDeficiency> deficiencies;
  final Function(String plantSuggestion)? onPlantAction;

  const DeficiencyGauge({super.key, required this.deficiencies, this.onPlantAction});

  @override
  Widget build(BuildContext context) {
    if (deficiencies.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opportunités (Carences)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...deficiencies.map((def) => _buildRow(context, def)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withAlpha((0.1 * 255).toInt()), Colors.green.withAlpha(0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withAlpha((0.2 * 255).toInt())),
      ),
      child:  Row(
        children: [
           Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 24),
           SizedBox(width: 12),
           Expanded(
            child: Text(
              "Excellent ! Votre jardin couvre bien les nutriments surveillés.",
              style: TextStyle(color: Colors.greenAccent.shade100, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, NutrientDeficiency def) {
    // Red/Orange/Yellow based on severity? Here generic orange for deficiency.
    const Color barColor = Color(0xFFFF9F1C); 
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                def.nutrientName,
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
              ),
              Text(
                '${def.currentCoveragePercent.toStringAsFixed(0)}%',
                style: const TextStyle(color: barColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Bar Container
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width * 0.6 * (def.currentCoveragePercent / 100).clamp(0.0, 1.0), // Approximate width constraint
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: barColor.withAlpha((0.5 * 255).toInt()), blurRadius: 6, spreadRadius: 0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Suggestion Action
          InkWell(
            onTap: () => onPlantAction?.call(def.suggestedCrop),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.05 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_circle_outline, size: 14, color: Colors.white60),
                  const SizedBox(width: 6),
                  Text(
                    'Semer : ${def.suggestedCrop}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
