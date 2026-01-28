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
import 'organic_glass_bubble_painter.dart';
import '../../../../shared/widgets/active_garden_aura.dart';

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
    
    // TITRES COURTS (Demande utilisateur: "Économie", "Nutrition", "Export")
    // On hardcode ici pour le test ou on utilise des clés plus courtes si dispo.
    final title = switch (type) {
      PillarType.economieVivante => "ÉCONOMIE",
      PillarType.sante => "NUTRITION",
      PillarType.patrimoine => "EXPORT",
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

              // HALO ORGANIQUE (Nuage vert derrière)
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                   // AURA VIVANTE
                   Positioned.fill(
                     child: Center(
                       child: SizedBox(
                         width: diameter * 1.3, // Un peu plus large que la bulle
                         height: diameter * 1.3,
                         child: ActiveGardenAura(
                           isActive: true,
                           color: const Color(0xFF4CAF50).withOpacity(0.4), // Vert bio
                           size: diameter * 1.3,
                           animationDuration: const Duration(seconds: 20), // Vitesse très lente pour éviter le "tournis"
                         ),
                       ),
                     ),
                   ),

                   // BULLE ORGANIQUE GLASS
                   SizedBox(
                     height: diameter,
                     width: diameter,
                     child: CustomPaint(
                      painter: OrganicGlassBubblePainter(),
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
                                // 1. TITRE (Haut) - COURT ET GROS
                                SizedBox(height: diameter * 0.06), // Un peu plus bas pour l'équilibre
                                Text(
                                  _toTitleCase(title), 
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: diameter * 0.085, // Beaucoup plus gros (ex: 0.05)
                                    letterSpacing: 0.5, 
                                    fontWeight: FontWeight.w500, // Un peu plus de poids
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 4, offset: const Offset(0, 2))
                                    ],
                                  ),
                                ),
                                
                                // Spacer dynamique
                                Spacer(),

                                // 2. CONTENU PRINCIPAL (Centre)
                                // Wrapped in Flexible/Expanded/FittedBox to avoid overflow
                                Flexible(
                                  flex: 10,
                                  child: _buildDeepContent(type, diameter, context, ref, l10n),
                                ),
                                
                                Spacer(),
                                
                                 // 3. Espace bas
                                 SizedBox(height: diameter * 0.10), 
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                   ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  
  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    // Simple naive implementation for now, or just capitalize first letter if localized strings allow
    // "ÉCONOMIE DU JARDIN" -> "Économie du jardin"
    return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Opacity(
               opacity: hasRecords ? 1.0 : 0.5,
               child: FittedBox(
                 fit: BoxFit.scaleDown,
                 child: Text(
                   hasRecords ? formatCurrency(totalValue, ref.watch(currencyProvider)) : '--',
                   style: TextStyle(
                     // Font "Premium" : Thin mais large
                     fontFamily: 'Outfit', // Si dispo, sinon défaut
                     fontWeight: FontWeight.w300, // Plus lisible que w200
                     fontSize: diameter * 0.22, // MAX VALUE
                     color: Colors.white,
                     letterSpacing: -1.0,
                     shadows: [
                       Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))
                     ]
                   ),
                 ),
               ),
             ),
             SizedBox(height: diameter * 0.02),
             // Bulles graphiques (on garde car c'est abstrait et joli)
             SizedBox(
                height: diameter * 0.15, // Un peu plus grand
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             // Score en haut, assez fin
             vitDist.maybeWhen(
                data: (distribution) {
                  final detected = distribution.values.where((v) => v > 0).length;
                  return Text(
                    '$detected / 5',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: diameter * 0.15, // Reduced from 0.16
                      color: Colors.white,
                      shadows: [
                       Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset:const Offset(0, 2))
                     ]
                    ),
                  );
                },
                orElse: () => const Text('...', style: TextStyle(color: Colors.white54)),
             ),
             // Minimal spacing
             SizedBox(height: diameter * 0.005), // Ultra minimal
             // Radar - Reduced size significantly to ensure fit
             SizedBox(
               width: diameter * 0.30, // Reduced from 0.32 to prevent overflow
               height: diameter * 0.30,
               child: Consumer(builder: (context, ref, child) {
                  final radarDataAsync = ref.watch(nutritionRadarProvider);
                  return radarDataAsync.maybeWhen(
                    data: (d) => NutritionRadarChart(data: d, size: diameter * 0.30),
                    orElse: () => const SizedBox(),
                  );
               }),
             ),
          ],
        );

      case PillarType.patrimoine:
        // DATA PORTAL - Softer
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon simple "floating" with glow, no rigid border
            Container(
              width: diameter * 0.25,
              height: diameter * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Soft glow background instead of border
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.15), Colors.transparent],
                  stops: const [0.3, 1.0],
                ),
              ),
              child: Center(
                 // Rounded arrow, angled
                 child: Icon(Icons.arrow_outward_rounded, color: Colors.white.withOpacity(0.9), size: diameter * 0.12),
              ),
            ),
            SizedBox(height: diameter * 0.02),
            Text(
              "DATA",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: diameter * 0.05,
                fontWeight: FontWeight.w600, // Less bold?
                letterSpacing: 2.0, // Reduced from 2.5
                 shadows: [
                       Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 2))
                  ]
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
