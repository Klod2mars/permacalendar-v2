import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/evolution/plant_evolution_timeline.dart';
import '../providers/plant_evolution_providers.dart';

/// 📊 CURSOR PROMPT A8 - Plant Evolution History Screen
///
/// Écran dédié pour afficher l'historique complet des évolutions d'une plante.
///
/// **Features:**
/// - Affichage de la timeline d'évolution
/// - Statistiques résumées en haut
/// - Filtre temporel
/// - Navigation retour
///
/// **Usage:**
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => PlantEvolutionHistoryScreen(
///       plantId: 'tomato-001',
///       plantName: 'Tomate Cerise',
///     ),
///   ),
/// );
/// ```
class PlantEvolutionHistoryScreen extends ConsumerWidget {
  final String plantId;
  final String plantName;

  const PlantEvolutionHistoryScreen({
    super.key,
    required this.plantId,
    required this.plantName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Historique d\'évolution'),
            Text(
              plantName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _EvolutionStatsSummary(plantId: plantId),
          const Divider(height: 1),
          Expanded(
            child: PlantEvolutionTimeline(
              plantId: plantId,
              showTimeFilter: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== EVOLUTION STATS SUMMARY ====================

/// Widget qui affiche un résumé des statistiques d'évolution
class _EvolutionStatsSummary extends ConsumerWidget {
  final String plantId;

  const _EvolutionStatsSummary({required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider(plantId));

    return evolutionsAsync.when(
      data: (evolutions) {
        if (evolutions.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildSummaryCard(context, evolutions);
      },
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSummaryCard(BuildContext context, List evolutions) {
    final theme = Theme.of(context);

    // Calculer les statistiques
    final stats = _calculateStats(evolutions);

    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.show_chart,
              label: 'Évolutions',
              value: stats.totalEvolutions.toString(),
              color: theme.colorScheme.primary,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.trending_up,
              label: 'Améliorations',
              value: stats.improvements.toString(),
              color: Colors.green,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.trending_down,
              label: 'Dégradations',
              value: stats.degradations.toString(),
              color: Colors.red,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.trending_flat,
              label: 'Stables',
              value: stats.stables.toString(),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _EvolutionStats _calculateStats(List evolutions) {
    int improvements = 0;
    int degradations = 0;
    int stables = 0;

    for (final evolution in evolutions) {
      if (evolution.hasImproved) {
        improvements++;
      } else if (evolution.hasDegraded) {
        degradations++;
      } else {
        stables++;
      }
    }

    return _EvolutionStats(
      totalEvolutions: evolutions.length,
      improvements: improvements,
      degradations: degradations,
      stables: stables,
    );
  }
}

class _EvolutionStats {
  final int totalEvolutions;
  final int improvements;
  final int degradations;
  final int stables;

  const _EvolutionStats({
    required this.totalEvolutions,
    required this.improvements,
    required this.degradations,
    required this.stables,
  });
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


