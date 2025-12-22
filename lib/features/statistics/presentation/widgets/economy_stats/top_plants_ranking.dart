import 'package:flutter/material.dart';
import '../../../application/economy_details_provider.dart';
import 'package:go_router/go_router.dart';

class TopPlantsRanking extends StatelessWidget {
  final List<PlantRanking> rankings;
  final VoidCallback? onViewDetails;

  const TopPlantsRanking({
    super.key,
    required this.rankings,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final top5 = rankings.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Cultures (Valeur)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...top5.map((ranking) => _buildRankingRow(context, ranking)),
        if (rankings.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Aucune donnée',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRankingRow(BuildContext context, PlantRanking ranking) {
    return InkWell(
      onTap: () {
        // Navigate to plant details if useful
        // context.pushNamed('plant-detail', pathParameters: {'id': ranking.plantId});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                ranking.plantName.isNotEmpty ? ranking.plantName[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ranking.plantName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${ranking.totalKg.toStringAsFixed(1)} kg • ${ranking.percentShare.toStringAsFixed(1)}% du total',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${ranking.totalValue.toStringAsFixed(0)} €',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${ranking.avgPricePerKg.toStringAsFixed(2)} €/kg',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
