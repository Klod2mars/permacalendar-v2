import 'package:flutter/material.dart';
import '../../../../domain/models/plant_value_ranking.dart';

class EconomyTop3Table extends StatelessWidget {
  final List<PlantValueRanking> rankings;

  const EconomyTop3Table({super.key, required this.rankings});

  @override
  Widget build(BuildContext context) {
    if (rankings.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
         decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                   Expanded(
                    flex: 4,
                     child: Text(
                      'Plante',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Valeur',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
                      textAlign: TextAlign.right,
                    ),
                  ),
                   const Expanded(
                    flex: 2,
                    child: SizedBox(), // % column or actions?
                  ),
                ],
              ),
            ),
             const Divider(height: 1, color: Colors.white10),
             // Rows
            ...rankings.asMap().entries.map((entry) {
              final index = entry.key;
              final r = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                child: Row(
                  children: [
                    // Rank badge
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getRankColor(index),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Text(
                        r.plantName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${r.totalValue.toStringAsFixed(2)} €',
                        style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const Expanded(flex: 2, child: SizedBox()), // spacer
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Color _getRankColor(int index) {
      switch(index) {
        case 0: return const Color(0xFFFFD700); // Gold
        case 1: return const Color(0xFFC0C0C0); // Silver
        case 2: return const Color(0xFFCD7F32); // Bronze
        default: return Colors.white24;
      }
  }
}
