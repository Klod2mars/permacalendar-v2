import 'package:flutter/material.dart';
import '../../../application/economy_details_provider.dart';
import '../../../../../core/utils/formatters.dart';

class EconomyKpiRow extends StatelessWidget {
  final EconomyDetails details;

  const EconomyKpiRow({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            context,
            'Revenu Total',
            formatCurrency(details.totalValue),
            Icons.euro,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKpiCard(
            context,
            'Volume Total',
            '${details.totalKg.toStringAsFixed(1)} kg',
            Icons.scale,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKpiCard(
            context,
            'Prix Moyen',
            formatPricePerKg(details.weightedAvgPrice),
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
