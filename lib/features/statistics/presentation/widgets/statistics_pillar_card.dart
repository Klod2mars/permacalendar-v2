import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../enums/pillar_type.dart';
import '../../application/providers/statistics_kpi_providers.dart';
import '../../application/providers/vitamin_distribution_provider.dart';

import 'top_economy_bubble_chart.dart';
import 'charts/nutrition_radar_chart.dart';
import '../../application/providers/nutrition_radar_provider.dart';

import '../providers/statistics_filters_provider.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../../../core/providers/currency_provider.dart';
import '../../../../core/utils/formatters.dart';

class StatisticsPillarCard extends ConsumerWidget {
  final PillarType type;

  const StatisticsPillarCard({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Titres seulement, plus d'icônes
    final title = switch (type) {
      PillarType.economieVivante => l10n.pillar_economy_title,
      PillarType.sante => l10n.pillar_nutrition_title,
      PillarType.patrimoine => l10n.pillar_export_title,
    };

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: AspectRatio(
          aspectRatio: 1.0, 
          child: LayoutBuilder(
            builder: (context, constraints) {
              final diameter = constraints.maxWidth;
              final innerPadding = diameter * 0.1;

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // DEEP MATTE EFFECT: Fond sombre avec halo subtil
                  gradient: const RadialGradient(
                    center: Alignment(0.0, -0.4), // Halo légèrement décentré vers le haut
                    radius: 0.85,
                    colors: [
                      Color(0xFF222625), // Gris-Vert très sombre (halo interne)
                      Color(0xFF080908), // Noir quasi total (bords)
                    ],
                    stops: [0.0, 1.0],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08), // Bordure très fine et subtile
                    width: 1.0,
                  ),
                  boxShadow: [
                    // Ombre portée externe très douce pour détacher du fond
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      _handleTap(context, ref);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(innerPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 1. TITRE (Haut) - Typographie légère et espacée
                          Text(
                            title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: diameter * 0.035,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300, 
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          
                          SizedBox(height: diameter * 0.05),

                          // 2. CONTENU PRINCIPAL (Centre)
                          Expanded(
                            child: Center(
                              child: _buildDeepContent(type, diameter, context, ref, l10n),
                            ),
                          ),

                          // 3. LABEL SECONDAIRE (Bas) - Très discret
                          Text(
                            _getKpiLabel(l10n),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF00FF88).withOpacity(0.5), // Vert bio luminescent faible
                              fontSize: diameter * 0.025,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    final state = GoRouterState.of(context);
    final activeGardenId = state.pathParameters['id'];

    if (type == PillarType.economieVivante) {
      if (activeGardenId != null) {
        context.pushNamed('garden-stats-economie',
            pathParameters: {'id': activeGardenId});
      } else {
        context.pushNamed('statistics-global-economie');
      }
      return;
    }

    if (type == PillarType.sante) {
      if (activeGardenId != null) {
        context.pushNamed('garden-stats-sante',
            pathParameters: {'id': activeGardenId});
      } else {
        context.pushNamed('statistics-global-sante');
      }
      return;
    }

    if (type == PillarType.patrimoine) {
      context.pushNamed('export');
      return;
    }
  }

  Widget _buildDeepContent(
      PillarType type, double diameter, BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    
    switch (type) {
      case PillarType.economieVivante:
        // HERO VALUE - Grande, fine, élégante. Pas d'icône panier.
        final totalValue = ref.watch(totalEconomyKpiProvider);
        final hasRecords = ref.watch(harvestRecordsProvider).records.isNotEmpty;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Opacity(
               opacity: hasRecords ? 1.0 : 0.3,
               child: FittedBox(
                 fit: BoxFit.scaleDown,
                 child: Text(
                   hasRecords ? formatCurrency(totalValue, ref.watch(currencyProvider)) : '--',
                   style: TextStyle(
                     // Font "Premium" : Thin mais large
                     fontFamily: 'Outfit', // Si dispo, sinon défaut
                     fontWeight: FontWeight.w200, 
                     fontSize: diameter * 0.18,
                     color: Colors.white,
                     letterSpacing: -1.0,
                   ),
                 ),
               ),
             ),
             SizedBox(height: diameter * 0.05),
             // Bulles graphiques (on garde car c'est abstrait et joli)
             SizedBox(
                height: diameter * 0.12,
                child: TopEconomyBubbleChart(
                    rankings: ref.watch(top3PlantsValueRankingProvider)),
             )
          ],
        );

      case PillarType.sante:
        // RADAR ABSTRAIT - Pas d'icône salade.
        final vitDist = ref.watch(vitaminDistributionProvider);
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             // Score en haut, assez fin
             vitDist.maybeWhen(
                data: (distribution) {
                  final detected = distribution.values.where((v) => v > 0).length;
                  return Text(
                    '$detected / 5',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: diameter * 0.15,
                      color: Colors.white,
                    ),
                  );
                },
                orElse: () => const Text('...', style: TextStyle(color: Colors.white54)),
             ),
             SizedBox(height: diameter * 0.02),
             // Radar Chart existant (il est déjà assez abstrait)
             SizedBox(
               width: diameter * 0.35, // Un peu plus grand qu'avant
               height: diameter * 0.35,
               child: Consumer(builder: (context, ref, child) {
                  final radarDataAsync = ref.watch(nutritionRadarProvider);
                  return radarDataAsync.maybeWhen(
                    data: (d) => NutritionRadarChart(data: d, size: diameter * 0.35),
                    orElse: () => const SizedBox(),
                  );
               }),
             ),
          ],
        );

      case PillarType.patrimoine:
        // PORTAL / EXPORT - Pas de parchemin.
        // Concept: Un cercle ou un flux de données. Pour l'instant texte "Start" simple et élégant.
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Un cercle "Portail" minimaliste
            Container(
              width: diameter * 0.2,
              height: diameter * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                ),
              ),
              child: Center(
                 child: Icon(Icons.arrow_outward, color: Colors.white70, size: diameter * 0.08),
              ),
            ),
            SizedBox(height: diameter * 0.04),
            Text(
              "DATA",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: diameter * 0.04,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            )
          ],
        );
    }
  }

  String _getKpiLabel(AppLocalizations l10n) {
    switch (type) {
      case PillarType.economieVivante:
        return l10n.pillar_economy_label; // ex: "Valeur totale"
      case PillarType.sante:
        return l10n.pillar_nutrition_label; // ex: "Diversité"
      case PillarType.patrimoine:
        return l10n.pillar_export_label; // ex: "Exporter"
    }
  }
}
