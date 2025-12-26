
import 'package:flutter/material.dart';
import '../../application/providers/nutrition_detailed_provider.dart';

class NutritionBarList extends StatelessWidget {
  final List<NutrientBarData> data;
  final String title;
  final Color baseColor;

  const NutritionBarList({
    super.key,
    required this.data,
    required this.title,
    this.baseColor = Colors.greenAccent,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    // On ne montre que les lignes pertinents (ou toutes ? Le user veut "Chaque entrée").
    // On va tout montrer, mais peut-être griser ceux à 0 ?
    // Option: Filtrer ceux à 0 si on veut moins de bruit, mais "bâtonnets" implique souvent comparatif.
    // Affichons tout pour l'exhaustivité demandée.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: baseColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ...data.map((item) => _buildBarRow(context, item)),
      ],
    );
  }

  Widget _buildBarRow(BuildContext context, NutrientBarData item) {
    // Calcul de la largeur de la barre (max 100% visuellement, mais le chiffre peut dépasser)
    final double visualPct = (item.driPercentage / 100.0).clamp(0.0, 1.0);
    final bool isZero = item.totalValue <= 0;
    
    // Formatting value
    String valText = '${item.totalValue.toStringAsFixed(1)} ${item.unit}';
    if (item.totalValue > 100 && item.totalValue < 1000) valText = '${item.totalValue.toStringAsFixed(0)} ${item.unit}';
    if (item.totalValue >= 1000) valText = '${(item.totalValue / 1000).toStringAsFixed(1)} k${item.unit == "kcal" ? "" : item.unit}'; // Simplification k units ? Non gardons brut.
    if (item.unit == 'kcal') valText = '${item.totalValue.toStringAsFixed(0)} kcal';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Line: "Vitamine C        45 mg (50%)"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  color: Colors.white.withOpacity(isZero ? 0.5 : 0.9),
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    valText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isZero ? Colors.grey.withOpacity(0.1) : baseColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item.driPercentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: isZero ? Colors.white30 : baseColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Bar Stack
          Stack(
            children: [
              // Background track
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Filled bar
              FractionallySizedBox(
                widthFactor: visualPct,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: isZero ? Colors.transparent : baseColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: isZero ? null : [
                      BoxShadow(
                        color: baseColor.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
