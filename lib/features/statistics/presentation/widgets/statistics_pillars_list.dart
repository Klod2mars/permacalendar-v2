import 'package:flutter/material.dart';
import '../enums/pillar_type.dart';
import 'statistics_pillar_card.dart';

/// Liste des 4 piliers métier principaux
///
/// Responsabilité : Afficher les 4 nouveaux piliers en liste verticale
///
/// Design :
/// - Column simple pour s'intégrer dans un parent scrollable (SliverToBoxAdapter)
/// - Cartes placeholders simples avec style cohérent
/// - Prêt pour l'intégration des KPIs réels en Phase 2
class StatisticsPillarsList extends StatelessWidget {
  const StatisticsPillarsList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pillars = [
          PillarType.economieVivante,
          PillarType.sante,
          PillarType.patrimoine,
        ];
        final width = constraints.maxWidth;
        // Basic responsive logic:
        // If wide enough, maybe 3 in a row? But on mobile usually 2.
        // Let's try to fit 2 items per row with some spacing.
        final crossAxisCount = (width > 600) ? 3 : 2; 
        final spacing = 16.0;
        final itemWidth = (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: 40.0, // More vertical space
          alignment: WrapAlignment.center,
          children: pillars.map((pillarType) {
            // Configuration "Organique"
            final (scale, topPadding) = switch (pillarType) {
              PillarType.economieVivante => (1.0, 0.0),
              PillarType.sante => (0.94, 110.0), // Stronger staggered drop
              PillarType.patrimoine => (1.05, 20.0), // Larger and pushed down
            };

            return Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: SizedBox(
                width: itemWidth * scale,
                child: StatisticsPillarCard(type: pillarType),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
