import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../enums/pillar_type.dart';
import '../../application/providers/statistics_kpi_providers.dart';
import '../../application/providers/vitamin_distribution_provider.dart';
import '../../application/providers/vitamin_recommendation_provider.dart';
import '../../application/providers/performance/performance_comparison_provider.dart';
import '../../application/providers/alignment/alignment_insight_provider.dart';
import 'placeholders/performance_seasonal_placeholder.dart';
import 'top_economy_bubble_chart.dart';
// âÅ“… V4_UNIFIED_MEMBRANE: Import V4 unified membrane system
import '../../../climate/presentation/experimental/cellular_rosace_v4/unified_membrane_widget.dart';
import 'charts/vitamin_pie_chart.dart';
import 'vitamin_suggestion_row.dart';
import 'kpi/alignment_kpi_card.dart';

/// Carte individuelle pour chaque pilier métier
///
/// Responsabilité : Afficher la structure complète d'un pilier avec zone graphique placeholder
///
/// Design :
/// - Header avec icône et titre du pilier
/// - Zone graphique placeholder pour l'intégration future des charts
/// - Valeur KPI centrale (réelle pour Économie Vivante, placeholder pour les autres)
/// - Sous-titre descriptif
class StatisticsPillarCard extends ConsumerWidget {
  final PillarType type;

  const StatisticsPillarCard({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconAndTitle = switch (type) {
      PillarType.economieVivante => {'icon': '🌾', 'title': 'Économie Vivante'},
      PillarType.sante => {'icon': '🩺', 'title': 'Santé'},
      PillarType.performance => {'icon': '📈', 'title': 'Performance'},
      PillarType.alignement => {'icon': '⏳', 'title': 'Alignement'},
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            final routeName = switch (type) {
              PillarType.economieVivante => 'garden-stats-economie',
              PillarType.sante => 'garden-stats-sante',
              PillarType.performance => 'garden-stats-performance',
              PillarType.alignement => 'garden-stats-alignement',
            };
            
            final state = GoRouterState.of(context);
            final gardenId = state.pathParameters['id'];
            if (gardenId != null) {
               context.pushNamed(routeName, pathParameters: {'id': gardenId});
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Text(
                  '${iconAndTitle['icon']} ${iconAndTitle['title']}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 20),

                // PLACEHOLDER VISUEL
                _buildPlaceholder(type),

                const SizedBox(height: 20),

                // VALEUR KPI
                Center(
                  child: _buildKpiValue(context, ref),
                ),

                const SizedBox(height: 6),

                // LABEL DESCRIPTIF
                Center(
                  child: Text(
                    _getKpiLabel(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),

                // TOP 3 DES PLANTES LES PLUS RENTABLES (uniquement pour Économie Vivante)
                if (type == PillarType.economieVivante) ...[
                  const SizedBox(height: 16),
                  _buildTop3PlantsBubbles(context, ref),
                ],

                // SUGGESTIONS VITAMINIQUES (uniquement pour Santé)
                if (type == PillarType.sante) ...[
                  const SizedBox(height: 16),
                  _buildVitaminSuggestions(context, ref),
                ],

                // MESSAGE D'ENCOURAGEMENT (uniquement pour Performance)
                if (type == PillarType.performance) ...[
                  const SizedBox(height: 16),
                  _buildPerformanceEncouragement(context, ref),
                ],

                // MESSAGE D'ENCOURAGEMENT (uniquement pour Alignement)
                if (type == PillarType.alignement) ...[
                  const SizedBox(height: 16),
                  _buildAlignmentEncouragement(context, ref),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le placeholder visuel approprié selon le type de pilier
  Widget _buildPlaceholder(PillarType type) {
    switch (type) {
      case PillarType.economieVivante:
        return _buildV4UnifiedMembrane();
      case PillarType.sante:
        return _buildHealthChart();
      case PillarType.performance:
        return const PerformanceSeasonalPlaceholder();
      case PillarType.alignement:
        return const AlignmentKpiCard();
    }
  }

  /// Construit la valeur KPI selon le type de pilier
  Widget _buildKpiValue(BuildContext context, WidgetRef ref) {
    if (type == PillarType.economieVivante) {
      final totalValue = ref.watch(totalEconomyKpiProvider);

      return Text(
        totalValue > 0 ? '${totalValue.toStringAsFixed(2)} €' : '--',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );
    } else if (type == PillarType.sante) {
      return _buildHealthKpiValue(context, ref);
    } else if (type == PillarType.performance) {
      return _buildPerformanceKpiValue(context, ref);
    } else if (type == PillarType.alignement) {
      return _buildAlignmentKpiValue(context, ref);
    } else {
      // Pour les autres piliers, afficher le placeholder
      return Text(
        '--',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );
    }
  }

  /// Retourne le label descriptif selon le type de pilier
  String _getKpiLabel() {
    switch (type) {
      case PillarType.economieVivante:
        return 'Valeur totale des récoltes';
      case PillarType.sante:
        return 'Répartition vitaminique';
      case PillarType.performance:
        return 'Performance saisonnière';
      case PillarType.alignement:
        return 'Alignement au vivant';
    }
  }

  /// Construit le V4 Unified Membrane System pour l'économie vivante
  Widget _buildV4UnifiedMembrane() {
    // V4 hierarchy: weather_current dominant, pH subtle nucleus
    final v4Hierarchy = {
      'weather_current': 1.0, // DOMINANT - daily orientation cell
      'soil_temp': 0.85, // STRATEGIC - frequently consulted
      'weather_forecast': 0.85, // STRATEGIC - planning information
      'alerts': 0.75, // CONDITIONAL - importance varies
      'ph_core': 0.35, // NUCLEUS - small but central presence
    };

    return UnifiedMembraneWidget(
      dataHierarchy: v4Hierarchy,
      height: 200,
      margin: const EdgeInsets.all(8),
      onCellTap: (cellId) {
        // Handle cell tap for statistics context
        print('Statistics cell tapped: $cellId');
      },
    );
  }

  /// Construit l'affichage du Top 3 des plantes les plus rentables avec bulles colorées
  Widget _buildTop3PlantsBubbles(BuildContext context, WidgetRef ref) {
    final top3Plants = ref.watch(top3PlantsValueRankingProvider);

    if (top3Plants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          'Top 3 des plantes les plus rentables',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        TopEconomyBubbleChart(rankings: top3Plants),
      ],
    );
  }

  /// Construit le graphique de santé (camembert vitaminique)
  Widget _buildHealthChart() {
    return Consumer(
      builder: (context, ref, child) {
        final vitaminPercentagesAsync =
            ref.watch(vitaminDistributionPercentagesProvider);

        return vitaminPercentagesAsync.when(
          data: (percentages) {
            return VitaminPieChart(vitaminPercentages: percentages);
          },
          loading: () => const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (error, stack) => const Center(
            child: Text('--', style: TextStyle(fontSize: 16)),
          ),
        );
      },
    );
  }

  /// Construit la valeur KPI pour le pilier Santé
  Widget _buildHealthKpiValue(BuildContext context, WidgetRef ref) {
    final vitaminDistributionAsync = ref.watch(vitaminDistributionProvider);

    return vitaminDistributionAsync.when(
      data: (distribution) {
        // Calculer le total des vitamines pour afficher un indicateur global
        final totalVitamins =
            distribution.values.fold(0.0, (sum, value) => sum + value);

        if (totalVitamins == 0) {
          return Text(
            '--',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          );
        }

        // Afficher le nombre de vitamines détectées
        final detectedVitamins =
            distribution.values.where((value) => value > 0).length;
        return Text(
          '$detectedVitamins/5 vitamines',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        );
      },
      loading: () => Text(
        '...',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      error: (error, stack) => Text(
        '--',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  /// Construit les suggestions vitaminiques
  Widget _buildVitaminSuggestions(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(vitaminRecommendationProvider);

    return suggestionsAsync.when(
      data: (suggestions) {
        return VitaminSuggestionRow(suggestions: suggestions);
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  /// Construit la valeur KPI pour le pilier Performance
  Widget _buildPerformanceKpiValue(BuildContext context, WidgetRef ref) {
    final comparisonAsync = ref.watch(seasonalComparisonProvider);

    return comparisonAsync.when(
      data: (comparison) {
        if (!comparison.hasPreviousSeason) {
          return Text(
            '--',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          );
        }

        // Afficher le score global avec indicateur de tendance
        final score = comparison.overallScorePercentage;
        final trendIcon = comparison.isImproving
            ? Icons.trending_up_rounded
            : comparison.isDeclining
                ? Icons.trending_down_rounded
                : Icons.trending_flat_rounded;

        final trendColor = comparison.isImproving
            ? Colors.green
            : comparison.isDeclining
                ? Colors.red
                : Colors.orange;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(
              trendIcon,
              size: 20,
              color: trendColor,
            ),
          ],
        );
      },
      loading: () => Text(
        '...',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      error: (error, stack) => Text(
        '--',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  /// Construit le message d'encouragement pour le pilier Performance
  Widget _buildPerformanceEncouragement(BuildContext context, WidgetRef ref) {
    final encouragementMessageAsync =
        ref.watch(performanceEncouragementMessageProvider);

    return encouragementMessageAsync.when(
      data: (encouragementMessage) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                encouragementMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  /// Construit la valeur KPI pour le pilier Alignement
  Widget _buildAlignmentKpiValue(BuildContext context, WidgetRef ref) {
    final insightAsync = ref.watch(alignmentInsightProvider);

    return insightAsync.when(
      data: (insight) {
        if (!insight.hasData) {
          return Text(
            '--',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          );
        }

        // Afficher le pourcentage d'alignement
        final score = insight.score.round();
        return Text(
          '$score%',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        );
      },
      loading: () => Text(
        '...',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      error: (error, stack) => Text(
        '--',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  /// Construit le message d'encouragement pour le pilier Alignement
  Widget _buildAlignmentEncouragement(BuildContext context, WidgetRef ref) {
    final encouragementMessageAsync =
        ref.watch(alignmentEncouragementMessageProvider);

    return encouragementMessageAsync.when(
      data: (encouragementMessage) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.eco_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                encouragementMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
