import 'package:flutter/material.dart';
import '../../../application/providers/nutrition_kpi_providers.dart';

class TopHealersWidget extends StatelessWidget {
  final List<HealerPlant> healers;

  const TopHealersWidget({super.key, required this.healers});

  @override
  Widget build(BuildContext context) {
    if (healers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.05 * 255).toInt()),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('Aucune donnée nutritive pour le moment.',
              style: TextStyle(color: Colors.white38)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top 3 Contributeurs',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
             Icon(Icons.medical_services_outlined, color: Colors.greenAccent.shade100, size: 18),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120, // Hauteur fixe pour le scroll horizontal
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: healers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final healer = healers[index];
              return _buildHealerCard(context, healer, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHealerCard(BuildContext context, HealerPlant healer, int index) {
    // Colors based on ranking
    final colors = [
      const Color(0xFF6BFFB8), // 1st: Bright Green
      const Color(0xFF4DE1C1), // 2nd: Teal
      const Color(0xFF2FA4BA), // 3rd: Blueish
    ];
    final color = colors[index % colors.length];

    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt()), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${index + 1}',
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900),
            ),
          ),
          const Spacer(),
          Text(
            healer.plantName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            healer.mainBenefit,
            style: TextStyle(
              color: Colors.white.withAlpha((0.6 * 255).toInt()),
              fontSize: 10,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
