import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/economy_details_provider.dart';
import 'package:permacalendar/core/utils/formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/currency_provider.dart';

class KeyMonthsWidget extends ConsumerWidget {
  final List<MonthRevenue> monthlyRevenue;
  final int mostProfitableIndex;
  final int leastProfitableIndex;

  const KeyMonthsWidget({
    super.key,
    required this.monthlyRevenue,
    required this.mostProfitableIndex,
    required this.leastProfitableIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (monthlyRevenue.isEmpty || mostProfitableIndex == -1) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final best = monthlyRevenue[mostProfitableIndex];
    final worst = (leastProfitableIndex != -1 &&
            leastProfitableIndex < monthlyRevenue.length)
        ? monthlyRevenue[leastProfitableIndex]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.stats_key_months_title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMonthCard(
                context,
                l10n.stats_most_profitable,
                best,
                Colors.greenAccent,
                Icons.trending_up,
                l10n.localeName,
                ref
              ),
            ),
            if (worst != null && worst != best) ...[
              const SizedBox(width: 16),
              Expanded(
                child: _buildMonthCard(
                  context,
                  l10n.stats_least_profitable,
                  worst,
                  Colors.orangeAccent,
                  Icons.trending_down,
                  l10n.localeName,
                  ref
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMonthCard(
    BuildContext context,
    String label,
    MonthRevenue data,
    Color color,
    IconData icon,
    String locale,
    WidgetRef ref
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _monthName(data.month, locale),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatCurrency(data.totalValue, ref.watch(currencyProvider)),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${data.year}',
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month, String locale) {
    final dt = DateTime(2024, month);
    try {
      return DateFormat.MMMM(locale).format(dt);
    } catch (_) {
      const months = [
        'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
        'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
      ];
      if (month >= 1 && month <= 12) return months[month - 1];
      return '';
    }
  }
}
