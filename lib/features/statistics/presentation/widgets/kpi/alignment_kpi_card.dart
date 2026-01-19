import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../application/providers/alignment/alignment_insight_provider.dart';

/// Widget KPI pour l'alignement au vivant
///
/// Affiche :
/// - Si hasData == false : phrase pédagogique validée
/// - Si hasData == true : jauge circulaire avec pourcentage d'alignement
class AlignmentKpiCard extends ConsumerWidget {
  const AlignmentKpiCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightAsync = ref.watch(alignmentInsightProvider);
    final l10n = AppLocalizations.of(context)!;

    return insightAsync.when(
      data: (insight) {
        if (!insight.hasData) {
          return _buildNoDataState(context, l10n);
        }

        return _buildAlignmentDisplay(context, insight, l10n);
      },
      loading: () => _buildLoadingState(context, l10n),
      error: (error, stack) => _buildErrorState(context, l10n),
    );
  }

  /// Construit l'état "pas de données"
  Widget _buildNoDataState(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Placeholder visuel
        _buildPlaceholderVisual(context),

        const SizedBox(height: 16),

        // Message pédagogique
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.eco_outlined,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.kpi_alignment_title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.kpi_alignment_description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.kpi_alignment_cta,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construit l'affichage avec données d'alignement
  Widget _buildAlignmentDisplay(
      BuildContext context, AlignmentInsight insight, AppLocalizations l10n) {
    return Column(
      children: [
        // Jauge circulaire d'alignement
        _buildAlignmentGauge(context, insight, l10n),

        const SizedBox(height: 16),

        // Message descriptif
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getAlignmentColor(context, insight.level).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _getAlignmentColor(context, insight.level).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getAlignmentIcon(insight.level),
                size: 20,
                color: _getAlignmentColor(context, insight.level),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Statistiques détaillées
        _buildDetailedStats(context, insight, l10n),
      ],
    );
  }

  /// Construit la jauge circulaire d'alignement
  Widget _buildAlignmentGauge(BuildContext context, AlignmentInsight insight, AppLocalizations l10n) {
    final color = _getAlignmentColor(context, insight.level);
    final score = insight.score.round();

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          // Cercle de fond
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withOpacity(0.3),
            ),
          ),

          // Cercle de progression
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: insight.score / 100,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),

          // Texte central
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score%',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                Text(
                  l10n.kpi_alignment_aligned,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit les statistiques détaillées
  Widget _buildDetailedStats(BuildContext context, AlignmentInsight insight, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          context,
          l10n.kpi_alignment_total,
          '${insight.totalActions}',
          Icons.list_alt_outlined,
        ),
        _buildStatItem(
          context,
          l10n.kpi_alignment_aligned_actions,
          '${insight.alignedActions}',
          Icons.check_circle_outline,
          _getAlignmentColor(context, insight.level),
        ),
        _buildStatItem(
          context,
          l10n.kpi_alignment_misaligned_actions,
          '${insight.misalignedActions}',
          Icons.schedule_outlined,
          Colors.orange,
        ),
      ],
    );
  }

  /// Construit un élément de statistique
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, [
    Color? color,
  ]) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: effectiveColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  /// Construit l'état de chargement
  Widget _buildLoadingState(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buildPlaceholderVisual(context),
        const SizedBox(height: 16),
        Text(
          l10n.kpi_alignment_calculating,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  /// Construit l'état d'erreur
  Widget _buildErrorState(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buildPlaceholderVisual(context),
        const SizedBox(height: 16),
        Text(
          l10n.kpi_alignment_error,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      ],
    );
  }

  /// Construit le placeholder visuel
  Widget _buildPlaceholderVisual(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.eco_outlined,
        size: 48,
        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
      ),
    );
  }

  /// Retourne la couleur appropriée selon le niveau d'alignement
  Color _getAlignmentColor(BuildContext context, AlignmentLevel level) {
    switch (level) {
      case AlignmentLevel.excellent:
        return Colors.green;
      case AlignmentLevel.good:
        return Colors.lightGreen;
      case AlignmentLevel.average:
        return Colors.orange;
      case AlignmentLevel.poor:
        return Colors.deepOrange;
      case AlignmentLevel.veryPoor:
        return Colors.red;
      case AlignmentLevel.noData:
        return Theme.of(context).colorScheme.primary;
    }
  }

  /// Retourne l'icône appropriée selon le niveau d'alignement
  IconData _getAlignmentIcon(AlignmentLevel level) {
    switch (level) {
      case AlignmentLevel.excellent:
        return Icons.eco;
      case AlignmentLevel.good:
        return Icons.eco_outlined;
      case AlignmentLevel.average:
        return Icons.timeline;
      case AlignmentLevel.poor:
        return Icons.schedule;
      case AlignmentLevel.veryPoor:
        return Icons.warning_outlined;
      case AlignmentLevel.noData:
        return Icons.eco_outlined;
    }
  }
}
