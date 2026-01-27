import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/currency_provider.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/plant_value_ranking.dart';

/// Widget pour afficher le Top 3 des plantes les plus rentables sous forme de bulles colorées
///
/// Design :
/// - 3 bulles de tailles proportionnelles aux valeurs
/// - Couleurs pastel fixes : vert, bleu clair, ambre
/// - Nom et valeur affichés sous chaque bulle
/// - Disposition en Row avec espacement uniforme
class TopEconomyBubbleChart extends ConsumerWidget {
  final List<PlantValueRanking> rankings;

  const TopEconomyBubbleChart({required this.rankings, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (rankings.isEmpty) return const SizedBox.shrink();

    final double maxValue = rankings.first.totalValue;

    final bubbleColors = [
      Colors.greenAccent.shade200,
      Colors.lightBlue.shade200,
      Colors.amber.shade200,
    ];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rankings.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final ratio = data.totalValue / maxValue;
          final double bubbleSize = 80 * ratio.clamp(0.4, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                Container(
                  width: bubbleSize,
                  height: bubbleSize,
                  decoration: BoxDecoration(
                    color: bubbleColors[index],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.plantName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formatCurrency(data.totalValue, ref.watch(currencyProvider)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
