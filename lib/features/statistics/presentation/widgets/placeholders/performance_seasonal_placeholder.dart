import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/performance/performance_comparison_provider.dart';
import '../../../domain/models/seasonal_performance.dart';

/// Placeholder pour le KPI Performance SaisonniÃ¨re
///
/// Affiche soit :
/// - Un graphique de comparaison si des donnÃ©es de saisons prÃ©cÃ©dentes existent
/// - Un panneau pÃ©dagogique si c'est la premiÃ¨re saison
class PerformanceSeasonalPlaceholder extends ConsumerWidget {
  const PerformanceSeasonalPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirstSeasonAsync = ref.watch(isFirstSeasonProvider);
    final comparisonAsync = ref.watch(seasonalComparisonProvider);

    return isFirstSeasonAsync.when(
      data: (isFirstSeason) {
        if (isFirstSeason) {
          return _buildFirstSeasonPlaceholder(context);
        } else {
          return comparisonAsync.when(
            data: (comparison) => _buildComparisonChart(context, comparison),
            loading: () => _buildLoadingPlaceholder(context),
            error: (error, stack) =>
                _buildErrorPlaceholder(context, error.toString()),
          );
        }
      },
      loading: () => _buildLoadingPlaceholder(context),
      error: (error, stack) =>
          _buildErrorPlaceholder(context, error.toString()),
    );
  }

  /// Construit le placeholder pour la premiÃ¨re saison
  Widget _buildFirstSeasonPlaceholder(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 300,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context)
                .colorScheme
                .primaryContainer
                .withOpacity(0.3),
            Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'PremiÃ¨re saison active',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Continue Ã  cultiver ! Tes statistiques de performance saisonniÃ¨re apparaÃ®tront bientÃ´t.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              _buildFutureIndicators(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la liste des futurs indicateurs
  Widget _buildFutureIndicators(BuildContext context) {
    final indicators = [
      'Taux de complÃ©tion des cultures',
      'DurÃ©e moyenne de maturation',
      'Valeur totale des rÃ©coltes',
      'Rendement moyen par culture',
    ];

    return Column(
      children: indicators
          .map((indicator) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        indicator,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  /// Construit le graphique de comparaison
  Widget _buildComparisonChart(
      BuildContext context, SeasonalComparison comparison) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comparaison saisonniÃ¨re',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildComparisonBars(context, comparison),
            ),
            const SizedBox(height: 12),
            _buildLegend(context, comparison),
          ],
        ),
      ),
    );
  }

  /// Construit les barres de comparaison
  Widget _buildComparisonBars(
      BuildContext context, SeasonalComparison comparison) {
    final metrics = [
      {
        'label': 'ComplÃ©tion',
        'current': comparison.currentSeason.completionRate,
        'previous': comparison.previousSeason?.completionRate ?? 0.0,
        'improvement': comparison.completionRateImprovement,
        'color': Theme.of(context).colorScheme.primary,
      },
      {
        'label': 'Valeur (â‚¬)',
        'current': comparison.currentSeason.totalHarvestValue /
            100, // Normaliser pour l'affichage
        'previous': (comparison.previousSeason?.totalHarvestValue ?? 0.0) / 100,
        'improvement': comparison.harvestValueImprovement,
        'color': Theme.of(context).colorScheme.secondary,
      },
      {
        'label': 'Rendement',
        'current': comparison.currentSeason.averageYieldPerCulture,
        'previous': comparison.previousSeason?.averageYieldPerCulture ?? 0.0,
        'improvement': comparison.yieldImprovement,
        'color': Theme.of(context).colorScheme.tertiary,
      },
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: metrics
          .map((metric) => Expanded(
                child: Column(
                  children: [
                    // Barres de comparaison
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Barre saison prÃ©cÃ©dente
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 2),
                              decoration: BoxDecoration(
                                color: (metric['color'] as Color?)
                                    ?.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              height: (metric['previous'] as double) * 100,
                            ),
                          ),
                          // Barre saison actuelle
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 2),
                              decoration: BoxDecoration(
                                color: metric['color'] as Color?,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              height: (metric['current'] as double) * 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Label
                    Text(
                      metric['label'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  /// Construit la lÃ©gende
  Widget _buildLegend(BuildContext context, SeasonalComparison comparison) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          context,
          'Saison prÃ©cÃ©dente',
          Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          context,
          'Saison actuelle',
          Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  /// Construit un Ã©lÃ©ment de lÃ©gende
  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  /// Construit un placeholder de chargement
  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Construit un placeholder d'erreur
  Widget _buildErrorPlaceholder(BuildContext context, String error) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                error,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



