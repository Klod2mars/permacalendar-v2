import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/economy_details_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:permacalendar/core/utils/formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/currency_provider.dart';

class TopPlantsRanking extends ConsumerWidget {
  final List<PlantRanking> rankings;
  final VoidCallback? onViewDetails;

  const TopPlantsRanking({
    super.key,
    required this.rankings,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final top5 = rankings.take(5).toList();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.stats_top_cultures_title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...top5.map((ranking) => _buildRankingRow(context, ranking, l10n, ref)),
        if (rankings.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                l10n.stats_top_cultures_no_data,
                style: const TextStyle(color: Colors.white54),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRankingRow(BuildContext context, PlantRanking ranking, AppLocalizations l10n, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
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
                ranking.plantName.isNotEmpty
                    ? ranking.plantName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
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
                    '${ranking.totalKg.toStringAsFixed(1)} kg • ${ranking.percentShare.toStringAsFixed(1)}% ${l10n.stats_top_cultures_percent_revenue}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(ranking.totalValue, currency),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatPricePerKg(ranking.avgPricePerKg, currency),
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
