import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/plant_evolution_report.dart';
import '../../providers/plant_evolution_providers.dart';

/// 📈 CURSOR PROMPT A8 - PlantEvolutionTimeline
///
/// Widget réutilisable pour afficher l'historique des évolutions d'intelligence végétale.
///
/// **Features:**
/// - Timeline chronologique verticale
/// - Affichage des scores, deltas et tendances
/// - Liste des conditions changées avec couleurs
/// - Filtre temporel (30j / 90j / 1an / tous)
/// - Gestion des états vides et erreurs
/// - Design épuré et accessible mobile
///
/// **Usage:**
/// ```dart
/// PlantEvolutionTimeline(plantId: 'tomato-001')
/// ```
class PlantEvolutionTimeline extends ConsumerWidget {
  final String plantId;
  final bool showTimeFilter;
  final ScrollPhysics? scrollPhysics;

  const PlantEvolutionTimeline({
    super.key,
    required this.plantId,
    this.showTimeFilter = true,
    this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedTimePeriodProvider);

    final evolutionsAsync = selectedPeriod == null
        ? ref.watch(plantEvolutionHistoryProvider(plantId))
        : ref.watch(filteredEvolutionHistoryProvider(
            FilterParams(plantId: plantId, days: selectedPeriod),
          ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTimeFilter) _buildTimeFilter(context, ref, selectedPeriod),
        const SizedBox(height: 16),
        Expanded(
          child: evolutionsAsync.when(
            data: (evolutions) => _buildTimelineContent(context, evolutions),
            loading: () => _buildLoadingState(context),
            error: (error, stack) => _buildErrorState(context, error),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFilter(
      BuildContext context, WidgetRef ref, int? selectedPeriod) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _TimeFilterChip(
            label: 'Tous',
            isSelected: selectedPeriod == null,
            onSelected: () =>
                ref.read(selectedTimePeriodProvider.notifier).state = null,
          ),
          const SizedBox(width: 8),
          _TimeFilterChip(
            label: '30 jours',
            isSelected: selectedPeriod == 30,
            onSelected: () =>
                ref.read(selectedTimePeriodProvider.notifier).state = 30,
          ),
          const SizedBox(width: 8),
          _TimeFilterChip(
            label: '90 jours',
            isSelected: selectedPeriod == 90,
            onSelected: () =>
                ref.read(selectedTimePeriodProvider.notifier).state = 90,
          ),
          const SizedBox(width: 8),
          _TimeFilterChip(
            label: '1 an',
            isSelected: selectedPeriod == 365,
            onSelected: () =>
                ref.read(selectedTimePeriodProvider.notifier).state = 365,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineContent(
      BuildContext context, List<PlantEvolutionReport> evolutions) {
    if (evolutions.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      physics: scrollPhysics,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: evolutions.length,
      itemBuilder: (context, index) {
        final evolution = evolutions[index];
        final isFirst = index == 0;
        final isLast = index == evolutions.length - 1;

        return _EvolutionTimelineEntry(
          evolution: evolution,
          isFirst: isFirst,
          isLast: isLast,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timeline,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune évolution enregistrée',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Les évolutions de santé apparaîtront ici après votre première analyse d\'intelligence végétale.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement de l\'historique...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Impossible de récupérer l\'historique des évolutions.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TIME FILTER CHIP ====================

class _TimeFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _TimeFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

// ==================== TIMELINE ENTRY ====================

class _EvolutionTimelineEntry extends StatelessWidget {
  final PlantEvolutionReport evolution;
  final bool isFirst;
  final bool isLast;

  const _EvolutionTimelineEntry({
    required this.evolution,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                _TrendIndicator(trend: evolution.trend),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _EvolutionCard(evolution: evolution),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TREND INDICATOR ====================

class _TrendIndicator extends StatelessWidget {
  final String trend;

  const _TrendIndicator({required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = _getTrendIconAndColor(theme);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }

  (IconData, Color) _getTrendIconAndColor(ThemeData theme) {
    switch (trend) {
      case 'up':
        return (Icons.trending_up, Colors.green);
      case 'down':
        return (Icons.trending_down, Colors.red);
      case 'stable':
      default:
        return (Icons.trending_flat, theme.colorScheme.primary);
    }
  }
}

// ==================== EVOLUTION CARD ====================

class _EvolutionCard extends StatelessWidget {
  final PlantEvolutionReport evolution;

  const _EvolutionCard({required this.evolution});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 12),
            _buildScoreSection(context, theme),
            if (evolution.hasConditionChanges) ...[
              const SizedBox(height: 16),
              _buildConditionsSection(context, theme),
            ],
            const SizedBox(height: 12),
            _buildFooter(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(evolution.currentDate),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Analyse du ${dateFormat.format(evolution.previousDate)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _buildTrendEmoji(),
      ],
    );
  }

  Widget _buildTrendEmoji() {
    final emoji = evolution.hasImproved
        ? '📈'
        : evolution.hasDegraded
            ? '📉'
            : '➡️';

    return Text(
      emoji,
      style: const TextStyle(fontSize: 32),
    );
  }

  Widget _buildScoreSection(BuildContext context, ThemeData theme) {
    final deltaColor = evolution.hasImproved
        ? Colors.green
        : evolution.hasDegraded
            ? Colors.red
            : theme.colorScheme.onSurfaceVariant;

    final deltaPrefix = evolution.deltaScore > 0 ? '+' : '';

    return Row(
      children: [
        Expanded(
          child: _ScoreIndicator(
            label: 'Score actuel',
            score: evolution.currentScore,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: deltaColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: deltaColor.withOpacity(0.3)),
          ),
          child: Text(
            '$deltaPrefix${evolution.deltaScore.toStringAsFixed(1)} pts',
            style: theme.textTheme.titleMedium?.copyWith(
              color: deltaColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionsSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (evolution.improvedConditions.isNotEmpty) ...[
          Text(
            'Conditions améliorées',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: evolution.improvedConditions
                .map((c) => _ConditionChip(
                      label: c,
                      type: ConditionChangeType.improved,
                    ))
                .toList(),
          ),
        ],
        if (evolution.degradedConditions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Conditions dégradées',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: evolution.degradedConditions
                .map((c) => _ConditionChip(
                      label: c,
                      type: ConditionChangeType.degraded,
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme) {
    final duration = evolution.timeBetweenReports;
    final daysText = duration.inDays == 1 ? 'jour' : 'jours';

    return Text(
      'Évolution sur ${duration.inDays} $daysText',
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

// ==================== SCORE INDICATOR ====================

class _ScoreIndicator extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _ScoreIndicator({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              score.toStringAsFixed(1),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' / 100',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ==================== CONDITION CHIP ====================

enum ConditionChangeType { improved, degraded, stable }

class _ConditionChip extends StatelessWidget {
  final String label;
  final ConditionChangeType type;

  const _ConditionChip({
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, icon) = _getColorAndIcon();

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        _formatLabel(label),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  (Color, IconData) _getColorAndIcon() {
    switch (type) {
      case ConditionChangeType.improved:
        return (Colors.green, Icons.arrow_upward);
      case ConditionChangeType.degraded:
        return (Colors.red, Icons.arrow_downward);
      case ConditionChangeType.stable:
        return (Colors.grey, Icons.remove);
    }
  }

  String _formatLabel(String label) {
    // Capitalize first letter and translate common terms
    final translations = {
      'temperature': 'Température',
      'humidity': 'Humidité',
      'light': 'Lumière',
      'soil': 'Sol',
      'water': 'Eau',
      'nutrients': 'Nutriments',
    };

    return translations[label.toLowerCase()] ??
        label[0].toUpperCase() + label.substring(1);
  }
}


