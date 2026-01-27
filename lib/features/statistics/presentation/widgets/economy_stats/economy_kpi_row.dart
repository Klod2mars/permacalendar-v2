import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/economy_details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/utils/formatters.dart';
import 'package:permacalendar/core/providers/currency_provider.dart';

class EconomyKpiRow extends ConsumerWidget {
  final EconomyDetails details;

  const EconomyKpiRow({super.key, required this.details});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currency = ref.watch(currencyProvider);
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            context,
            l10n.stats_kpi_total_revenue,
            formatCurrency(details.totalValue, currency),
            currency.icon ?? Icons.attach_money,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKpiCard(
            context,
            l10n.stats_kpi_total_volume,
            '${details.totalKg.toStringAsFixed(1)} kg',
            Icons.scale,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKpiCard(
            context,
            l10n.stats_kpi_avg_price,
            formatPricePerKg(details.weightedAvgPrice, currency),
            Icons.price_change,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
