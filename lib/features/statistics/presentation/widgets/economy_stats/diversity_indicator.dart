import 'package:flutter/material.dart';

class DiversityIndicator extends StatelessWidget {
  final double diversityIndex;
  final String label;

  const DiversityIndicator({super.key, required this.diversityIndex, required this.label});

  @override
  Widget build(BuildContext context) {
    // 0.0 -> Red, 1.0 -> Green
    final color = Color.lerp(Colors.redAccent, Colors.greenAccent, diversityIndex) ?? Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Diversité Économique',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Tooltip(
              message: 'Indice de diversité (1 = équilibré, 0 = monoculture)',
              triggerMode: TooltipTriggerMode.tap,
              child: Icon(Icons.info_outline, color: Colors.white54, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: diversityIndex,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(diversityIndex * 100).toStringAsFixed(0)}/100',
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ],
    );
  }
}
