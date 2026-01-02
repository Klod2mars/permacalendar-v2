import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../enums/pillar_type.dart';
import '../../application/providers/statistics_kpi_providers.dart';
import '../../application/providers/vitamin_distribution_provider.dart';

import 'top_economy_bubble_chart.dart';
import 'charts/nutrition_radar_chart.dart';
import '../../application/providers/nutrition_radar_provider.dart';

// 🔄 V4_UNIFIED_MEMBRANE: Import V4 unified membrane system if needed,
// though we use TopEconomyBubbleChart for economy now.

import '../providers/statistics_filters_provider.dart';
import '../../../harvest/application/harvest_records_provider.dart';

class StatisticsPillarCard extends ConsumerWidget {
  final PillarType type;

  const StatisticsPillarCard({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconAndTitle = switch (type) {
      PillarType.economieVivante => {'icon': '🌾', 'title': 'Économie Vivante'},
      PillarType.sante => {'icon': '🥗', 'title': 'Équilibre Nutritionnel'},
      PillarType.patrimoine => {'icon': '📜', 'title': 'Patrimoine'},
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: AspectRatio(
            aspectRatio: 1.0, // cercle parfait
            child: LayoutBuilder(
              builder: (context, constraints) {
                final diameter = constraints.maxWidth;
                final innerPadding = diameter * 0.08;
                final contentMaxWidth = diameter - innerPadding * 2;

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.12), width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF88).withOpacity(0.18),
                        blurRadius: 60,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Material(
                        color: Colors.white.withOpacity(0.06),
                        child: InkWell(
                          onTap: () {
                            final state = GoRouterState.of(context);
                            final activeGardenId = state.pathParameters['id'];

                            // 1. Nouvelle route globale pour l'Économie
                            if (type == PillarType.economieVivante) {
                              if (activeGardenId != null) {
                                context.pushNamed('garden-stats-economie',
                                    pathParameters: {'id': activeGardenId});
                              } else {
                                context.pushNamed('statistics-global-economie');
                              }
                              return;
                            }

                            // 2. Nouvelle route globale pour la Santé / Nutrition
                            if (type == PillarType.sante) {
                              if (activeGardenId != null) {
                                context.pushNamed('garden-stats-sante',
                                    pathParameters: {'id': activeGardenId});
                              } else {
                                context.pushNamed('statistics-global-sante');
                              }
                              return;
                            }

                            // 3. Route pour Patrimoine -> Export Builder
                            if (type == PillarType.patrimoine) {
                              context.pushNamed('export');
                              return;
                            }

                            // 3. Comportement existant pour les autres piliers (en attendant le refactoring)
                            final routeName = switch (type) {
                              PillarType.economieVivante =>
                                'garden-stats-economie',
                              PillarType.sante => 'garden-stats-sante',
                              PillarType.patrimoine =>
                                'garden-stats-patrimoine',
                            };

                            String? targetId = activeGardenId;

                            // fallback : premier jardin sélectionné dans le filtre de stats
                            if (targetId == null) {
                              try {
                                final filters =
                                    ref.read(statisticsFiltersProvider);
                                if (filters.selectedGardenIds.isNotEmpty) {
                                  targetId = filters.selectedGardenIds.first;
                                }
                              } catch (_) {
                                // mode silencieux
                              }
                            }

                            if (targetId != null) {
                              context.pushNamed(routeName,
                                  pathParameters: {'id': targetId});
                            } else {
                              // aucun jardin sélectionné : ouvrir la vue agrégée si route existe (sinon ça plantera pour l'instant)
                              context.pushNamed(
                                  routeName); // Warning: routes expects :id usually
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(innerPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Header icon + title
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(iconAndTitle['icon']!,
                                        style: TextStyle(
                                            fontSize: diameter * 0.10,
                                            height: 1.0)),
                                    SizedBox(height: diameter * 0.02),
                                    FittedBox(
                                      child: Text(
                                        iconAndTitle['title']!.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                              color: Colors.white
                                                  .withOpacity(0.95),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: diameter * 0.04),

                                // SUMMARY ZONE : voici l'élément central lisible
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: contentMaxWidth,
                                        maxHeight: diameter * 0.5),
                                    child: _buildSummaryContent(
                                        type, diameter, context, ref),
                                  ),
                                ),

                                SizedBox(height: diameter * 0.03),

                                // petit label descriptif
                                Text(
                                  _getKpiLabel(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            Colors.greenAccent.withOpacity(0.8),
                                        fontStyle: FontStyle.italic,
                                        fontSize: diameter * 0.03,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryContent(
      PillarType type, double diameter, BuildContext context, WidgetRef ref) {
    final neon = const Color(0xFF00FF88);

    switch (type) {
      case PillarType.economieVivante:
        final harvestState = ref.watch(harvestRecordsProvider);

        // Si AUCUNE donnée de récolte : afficher les tirets (comportement accepté)
        if (harvestState.records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '--',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: diameter * 0.16,
                    ),
                  ),
                ),
                SizedBox(height: diameter * 0.02),
                SizedBox(
                  height: diameter * 0.10,
                  child: TopEconomyBubbleChart(
                      rankings: ref.watch(top3PlantsValueRankingProvider)),
                )
              ],
            ),
          );
        }

        // S'il y a des données -> afficher la KPI calculée (immédiatement).
        final totalValue = ref.watch(totalEconomyKpiProvider);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  totalValue > 0 ? '${totalValue.toStringAsFixed(0)} €' : '--',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: diameter * 0.16,
                  ),
                ),
              ),
              SizedBox(height: diameter * 0.02),
              SizedBox(
                height: diameter * 0.10,
                child: TopEconomyBubbleChart(
                    rankings: ref.watch(top3PlantsValueRankingProvider)),
              )
            ],
          ),
        );

      case PillarType.sante:
        final vitDist = ref.watch(vitaminDistributionProvider);
        // On affiche X/5 et un mini radar stroke
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // X/5
              FittedBox(
                child: vitDist.maybeWhen(
                  data: (distribution) {
                    final detected =
                        distribution.values.where((v) => v > 0).length;
                    return Text(
                      '$detected/5',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: diameter * 0.16,
                      ),
                    );
                  },
                  orElse: () => Text('...',
                      style: TextStyle(
                          color: Colors.white, fontSize: diameter * 0.12)),
                ),
              ),
              SizedBox(height: diameter * 0.02),
              // mini radar
              SizedBox(
                width: diameter * 0.26,
                height: diameter * 0.26,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Consumer(builder: (context, ref, child) {
                      final radarDataAsync = ref.watch(nutritionRadarProvider);
                      return radarDataAsync.maybeWhen(
                        data: (d) =>
                            NutritionRadarChart(data: d, size: diameter * 0.26),
                        orElse: () => const SizedBox(),
                      );
                    })),
              )
            ],
          ),
        );

      case PillarType.patrimoine:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text('0%',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: diameter * 0.16,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: diameter * 0.02),
              Material(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    context.pushNamed('export');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: diameter * 0.05, vertical: diameter * 0.02),
                    child: Text('Exporter',
                        style: TextStyle(
                            color: Colors.white, fontSize: diameter * 0.04)),
                  ),
                ),
              )
            ],
          ),
        );
    }
  }

  String _getKpiLabel() {
    switch (type) {
      case PillarType.economieVivante:
        return 'Valeur totale des récoltes';
      case PillarType.sante:
        return 'Contribution Nutritionnelle';

      case PillarType.patrimoine:
        return 'Héritage & Transmission';
    }
  }
}
