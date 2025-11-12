import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/plant_evolution_report.dart';

/// 📊 CURSOR PROMPT A8 - Plant Evolution Card
///
/// Widget carte compact pour afficher une évolution unique.
/// Utile pour les dashboards ou résumés.
///
/// **Usage:**
/// ```dart
/// PlantEvolutionCard(
///   evolution: evolutionReport,
///   onTap: () => navigateToDetails(),
/// )
/// ```
class PlantEvolutionCard extends StatelessWidget {
  final PlantEvolutionReport evolution;
  final VoidCallback? onTap;
  final bool compact;

  const PlantEvolutionCard({
    super.key,
    required this.evolution,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: compact
              ? _buildCompactContent(context, theme)
              : _buildFullContent(context, theme),
        ),
      ),
    );
  }

  Widget _buildCompactContent(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        _buildTrendIcon(theme),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evolution.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(evolution.currentDate),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant,
          ),
      ],
    );
  }

  Widget _buildFullContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildTrendIcon(theme),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Évolution détectée',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _formatDate(evolution.currentDate),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildScoreBadge(theme),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          evolution.description,
          style: theme.textTheme.bodyMedium,
        ),
        if (evolution.hasConditionChanges) ...[
          const SizedBox(height: 12),
          _buildConditionsSummary(theme),
        ],
      ],
    );
  }

  Widget _buildTrendIcon(ThemeData theme) {
    final (icon, color) = _getTrendIconAndColor(theme);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildScoreBadge(ThemeData theme) {
    final deltaColor = evolution.hasImproved
        ? Colors.green
        : evolution.hasDegraded
            ? Colors.red
            : theme.colorScheme.onSurfaceVariant;

    final deltaPrefix = evolution.deltaScore > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: deltaColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: deltaColor.withOpacity(0.3)),
      ),
      child: Text(
        '$deltaPrefix${evolution.deltaScore.toStringAsFixed(1)}',
        style: theme.textTheme.titleSmall?.copyWith(
          color: deltaColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConditionsSummary(ThemeData theme) {
    final parts = <String>[];

    if (evolution.improvedConditions.isNotEmpty) {
      parts.add('✅ ${evolution.improvedConditions.length} améliorée(s)');
    }

    if (evolution.degradedConditions.isNotEmpty) {
      parts.add('⚠️ ${evolution.degradedConditions.length} dégradée(s)');
    }

    return Text(
      parts.join(' • '),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  (IconData, Color) _getTrendIconAndColor(ThemeData theme) {
    switch (evolution.trend) {
      case 'up':
        return (Icons.trending_up, Colors.green);
      case 'down':
        return (Icons.trending_down, Colors.red);
      case 'stable':
      default:
        return (Icons.trending_flat, theme.colorScheme.primary);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return DateFormat('dd MMM yyyy', 'fr_FR').format(date);
    }
  }
}


