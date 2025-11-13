ï»¿import 'package:flutter/material.dart';
import '../enums/pillar_type.dart';
import 'statistics_pillar_card.dart';

/// Liste des 4 piliers métier principaux
///
/// Responsabilité : Afficher les 4 nouveaux piliers en liste verticale
///
/// Design :
/// - CustomScrollView avec SliverList pour une navigation fluide
/// - Cartes placeholders simples avec style cohérent
/// - Prêt pour l'intégration des KPIs réels en Phase 2
class StatisticsPillarsList extends StatelessWidget {
  const StatisticsPillarsList({super.key});

  @override
  Widget build(BuildContext context) {
    final pillars = [
      PillarType.economieVivante,
      PillarType.sante,
      PillarType.performance,
      PillarType.alignement,
    ];

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final pillarType = pillars[index];
              return StatisticsPillarCard(type: pillarType);
            },
            childCount: pillars.length,
          ),
        ),
      ],
    );
  }
}


