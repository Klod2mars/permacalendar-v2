import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/intelligence_state_providers.dart';
import '../widgets/cards/recommendation_card.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/intelligence_state.dart';
import '../../../../core/providers/providers.dart';

/// Écran des recommandations d'intelligence végétale
class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() =>
      _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  String _selectedFilter = 'all';
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Récupérer le jardin actuel
    final currentGardenId = ref.watch(currentIntelligenceGardenIdProvider);

    // Si aucun jardin n'est sélectionné, afficher un message
    if (currentGardenId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Recommandations'),
        ),
        body: const Center(
          child: Text('Aucun jardin sélectionné. Veuillez créer un jardin.'),
        ),
      );
    }

    final intelligenceState =
        ref.watch(intelligenceStateProvider(currentGardenId));
    final contextualRecsState = ref.watch(contextualRecommendationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommandations'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          if (_isRefreshing)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              onPressed: _refreshRecommendations,
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualiser',
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedFilter = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('Toutes'),
              ),
              const PopupMenuItem(
                value: 'high',
                child: Text('Urgentes'),
              ),
              const PopupMenuItem(
                value: 'maintenance',
                child: Text('Maintenance'),
              ),
              const PopupMenuItem(
                value: 'watering',
                child: Text('Arrosage'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          _buildFilters(theme),

          // Liste des recommandations
          Expanded(
            child: _buildRecommendationsList(
                theme, intelligenceState, contextualRecsState),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'all',
                  label: Text('Toutes'),
                  icon: Icon(Icons.list),
                ),
                ButtonSegment(
                  value: 'urgent',
                  label: Text('Urgentes'),
                  icon: Icon(Icons.priority_high),
                ),
                ButtonSegment(
                  value: 'maintenance',
                  label: Text('Maintenance'),
                  icon: Icon(Icons.build),
                ),
              ],
              selected: {_selectedFilter},
              onSelectionChanged: (Set<String> selection) {
                setState(() => _selectedFilter = selection.first);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsList(
      ThemeData theme,
      IntelligenceState intelligenceState,
      ContextualRecommendationsState contextualRecsState) {
    final recommendations =
        _getFilteredRecommendations(intelligenceState, contextualRecsState);
    final appliedRecommendations = { for (final rec in contextualRecsState.appliedRecommendations) rec.id: true };

    if (recommendations.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshRecommendations,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune recommandation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vos plantes sont en bonne santé !',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _refreshRecommendations,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Actualiser'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRecommendations,
      child: RecommendationsList(
        recommendations: recommendations.cast<Recommendation>(),
        appliedRecommendations: appliedRecommendations,
        onTap: _showDetails,
        onComplete: _markAsCompleted,
        showAnimation: true,
      ),
    );
  }

  List<dynamic> _getFilteredRecommendations(IntelligenceState intelligenceState,
      ContextualRecommendationsState contextualRecsState) {
    // Obtenir toutes les recommandations depuis les différentes sources
    final allRecommendations = <dynamic>[
      ...intelligenceState.plantRecommendations.values.expand((recs) => recs),
      ...(contextualRecsState.contextualRecommendations ?? []),
    ];

    if (_selectedFilter == 'all') {
      return allRecommendations;
    }

    return allRecommendations.where((rec) {
      switch (_selectedFilter) {
        case 'high':
          return rec.priority.name.toLowerCase() == 'high' ||
              rec.priority.name.toLowerCase() == 'urgent';
        case 'maintenance':
          return rec.type.name.toLowerCase() == 'maintenance' ||
              rec.type.name.toLowerCase() == 'fertilizing';
        case 'watering':
          return rec.type.name.toLowerCase() == 'watering';
        default:
          return true;
      }
    }).toList();
  }

  Future<void> _refreshRecommendations() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      final currentGardenId = ref.read(currentIntelligenceGardenIdProvider);
      if (currentGardenId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aucun jardin sélectionné'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final intelligenceState =
          ref.read(intelligenceStateProvider(currentGardenId));

      // Rafraîchir les recommandations pour toutes les plantes actives
      for (final plantId in intelligenceState.activePlantIds) {
        await ref
            .read(intelligenceStateProvider(currentGardenId).notifier)
            .analyzePlant(plantId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recommandations actualisées'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'actualisation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  void _markAsCompleted(recommendation) {
    ref
        .read(contextualRecommendationsProvider.notifier)
        .applyRecommendation(recommendation.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Recommandation "${recommendation.title}" marquée comme terminée'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            ref
                .read(contextualRecommendationsProvider.notifier)
                .dismissRecommendation(recommendation.id);
          },
        ),
      ),
    );
  }

  void _showDetails(recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(recommendation.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recommendation.plantId != null) ...[
                Row(
                  children: [
                    const Icon(Icons.local_florist, size: 16),
                    const SizedBox(width: 8),
                    Text('Plante: ${recommendation.plantId}'),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  const Icon(Icons.flag, size: 16),
                  const SizedBox(width: 8),
                  Text('Priorité: ${recommendation.priority.name}'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 8),
                  Text('Type: ${recommendation.type.name}'),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(recommendation.description),
              if (recommendation.expectedImpact > 0) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Impact attendu',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text('${(recommendation.expectedImpact * 100).toInt()}%'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _markAsCompleted(recommendation);
            },
            child: const Text('Marquer comme fait'),
          ),
        ],
      ),
    );
  }
}

