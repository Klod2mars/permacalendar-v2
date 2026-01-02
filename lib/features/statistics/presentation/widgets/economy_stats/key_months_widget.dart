import 'package:flutter/material.dart';
import '../../../application/economy_details_provider.dart';

class KeyMonthsWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (monthlyRevenue.isEmpty || mostProfitableIndex == -1) {
      return const SizedBox.shrink();
    }

    final best = monthlyRevenue[mostProfitableIndex];
    final worst = (leastProfitableIndex != -1 &&
            leastProfitableIndex < monthlyRevenue.length)
        ? monthlyRevenue[leastProfitableIndex]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mois Clés du Jardin',
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
                'Le plus rentable',
                best,
                Colors.greenAccent,
                Icons.trending_up,
              ),
            ),
            if (worst != null && worst != best) ...[
              const SizedBox(width: 16),
              Expanded(
                child: _buildMonthCard(
                  context,
                  'Le moins rentable',
                  worst,
                  Colors.orangeAccent,
                  Icons.trending_down,
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
            _monthName(data.month),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${data.totalValue.toStringAsFixed(0)} €',
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

  String _monthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
