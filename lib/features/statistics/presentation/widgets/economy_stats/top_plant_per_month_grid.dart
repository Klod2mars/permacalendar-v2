import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/economy_details_provider.dart';
import 'package:permacalendar/core/utils/formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/currency_provider.dart';

class TopPlantPerMonthGrid extends ConsumerWidget {
  final Map<int, PlantRanking> topPlantPerMonth;
  final List<MonthRevenue> monthlyRevenue; // Needed for indexing month order

  const TopPlantPerMonthGrid({
    super.key,
    required this.topPlantPerMonth,
    required this.monthlyRevenue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (monthlyRevenue.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.stats_dominant_culture_title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: monthlyRevenue.length,
          itemBuilder: (context, index) {
            final monthRev = monthlyRevenue[index];
            final yearMonth = monthRev.year * 100 + monthRev.month;
            final ranking = topPlantPerMonth[yearMonth];

            return _buildMonthCell(context, monthRev.month, ranking, l10n.localeName, ref);
          },
        ),
      ],
    );
  }

  Widget _buildMonthCell(
      BuildContext context, int month, PlantRanking? ranking, String locale, WidgetRef ref) {
    
    String monthName = '';
    try {
      monthName = DateFormat.MMM(locale).format(DateTime(2024, month)).replaceAll('.', '');
    } catch (_) {
       const months = [
        'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
        'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
      ];
      monthName = (month >= 1 && month <= 12) ? months[month - 1] : '';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            monthName.toUpperCase(),
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          const SizedBox(height: 4),
          if (ranking != null) ...[
            Text(
              ranking.plantName,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              formatCurrency(ranking.totalValue, ref.watch(currencyProvider)),
              style: const TextStyle(color: Colors.greenAccent, fontSize: 10),
            ),
          ] else
            const Text('-', style: TextStyle(color: Colors.white30)),
        ],
      ),
    );
  }
}
