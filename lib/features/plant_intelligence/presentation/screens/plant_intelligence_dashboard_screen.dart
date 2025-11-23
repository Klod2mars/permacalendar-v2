import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/plant_intelligence_providers.dart';
import '../providers/intelligence_state_providers.dart';
import '../providers/notification_providers.dart';

import '../../domain/entities/intelligence_state.dart';
import '../../domain/entities/plant_condition.dart';
import '../../domain/entities/comprehensive_garden_analysis.dart';
import '../../domain/entities/pest_threat_analysis.dart';
import '../../domain/entities/bio_control_recommendation.dart';
import '../../domain/entities/intelligence_report.dart';
import '../../domain/entities/notification_alert.dart';

import '../../../garden/providers/garden_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

import '../../../../app_router.dart';
import '../../../../core/providers/garden_aggregation_providers.dart';

// Export core runtime providers alias
import '../../../../core/providers/providers.dart' as core_intel;
import '../../../../core/providers/providers.dart' show IntelligentAlertsState;

// Active garden provider (orchestration)
import '../../../../core/providers/active_garden_provider.dart';

import '../providers/plant_intelligence_ui_providers.dart' as ui_intel;
import '../widgets/charts/condition_radar_chart_simple.dart';
import '../widgets/garden_selector_widget.dart';

import 'plant_evolution_history_screen.dart';

/// Écran principal du tableau de bord d'intelligence des plantes
class PlantIntelligenceDashboardScreen extends ConsumerStatefulWidget {
  const PlantIntelligenceDashboardScreen({super.key});

  @override
  ConsumerState<PlantIntelligenceDashboardScreen> createState() {
    developer.log('PlantIntelligenceDashboardScreen.createState() called',
        name: 'PlantIntelligenceDashboard');
    return _PlantIntelligenceDashboardScreenState();
  }
}

class _PlantIntelligenceDashboardScreenState
    extends ConsumerState<PlantIntelligenceDashboardScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    developer.log('PlantIntelligenceDashboard.initState()',
        name: 'PlantIntelligenceDashboard');

    // Lors du premier rendu, on initialise l'intelligence
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeIntelligence();
    });
  }

  /// Nouvelle logique : respecte la sélection existante (current provider)
  /// ou l'activeGarden (orchestration). Si rien n'existe, on tombe sur gardens.first.
  Future<void> _initializeIntelligence() async {
    developer.log('BEGIN _initializeIntelligence',
        name: 'PlantIntelligenceDashboard');

    try {
      // Récupérer l'état des jardins
      final gardenState = ref.read(gardenProvider);
      final gardens = gardenState.gardens;

      if (gardens.isEmpty) {
        developer.log('No gardens found', name: 'PlantIntelligenceDashboard');
        return;
      }

      // Lire la sélection existante (UI) et l'active garden (orchestration)
      final prevSelectedGardenId =
          ref.read(core_intel.currentIntelligenceGardenIdProvider);
      final activeGardenId = ref.read(activeGardenIdProvider);

      // Choisir l'ID à utiliser en respectant l'ordre :
      // 1) sélection UI existante
      // 2) activeGarden (orchestration)
      // 3) fallback -> gardens.first
      String gardenIdToUse;
      if (prevSelectedGardenId != null &&
          gardens.any((g) => g.id == prevSelectedGardenId)) {
        gardenIdToUse = prevSelectedGardenId;
      } else if (activeGardenId != null &&
          gardens.any((g) => g.id == activeGardenId)) {
        gardenIdToUse = activeGardenId;
      } else {
        gardenIdToUse = gardens.first.id;
      }

      // Réaffirmer la sélection courante (cela met à jour currentIntelligenceGardenIdProvider)
      ref.read(core_intel.currentIntelligenceGardenIdProvider.notifier).state =
          gardenIdToUse;

      final gardenName = gardens.firstWhere((g) => g.id == gardenIdToUse).name;
      developer.log('Using gardenId: $gardenIdToUse ($gardenName)',
          name: 'PlantIntelligenceDashboard');

      // Appeler l'initialize pour ce garden (synchronisation + analyses)
      await ref
          .read(intelligenceStateProvider(gardenIdToUse).notifier)
          .initializeForGarden();

      developer.log('initializeForGarden completed for $gardenIdToUse',
          name: 'PlantIntelligenceDashboard');
    } catch (e, st) {
      developer.log('Error in _initializeIntelligence: $e',
          error: e, stackTrace: st, name: 'PlantIntelligenceDashboard');
    } finally {
      developer.log('END _initializeIntelligence',
          name: 'PlantIntelligenceDashboard');
    }
  }

  /// Rafraîchissement manuel : respecte la sélection courante (plutôt que gardens.first)
  Future<void> _onManualRefresh() async {
    setState(() => _isRefreshing = true);

    try {
      final currentGardenId =
          ref.read(core_intel.currentIntelligenceGardenIdProvider);
      if (currentGardenId == null) {
        developer.log('No current garden selected on refresh',
            name: 'PlantIntelligenceDashboard');
        return;
      }

      // Invalider les providers dépendants pour forcer re-synchronisation
      ref.invalidate(unifiedGardenContextProvider(currentGardenId));
      ref.invalidate(gardenActivePlantsProvider(currentGardenId));
      ref.invalidate(gardenStatsProvider(currentGardenId));
      ref.invalidate(gardenActivitiesProvider(currentGardenId));

      // Re-initialize intelligence for the current garden
      await ref
          .read(intelligenceStateProvider(currentGardenId).notifier)
          .initializeForGarden();
      developer.log('Manual refresh completed for $currentGardenId',
          name: 'PlantIntelligenceDashboard');
    } catch (e, st) {
      developer.log('Error on manual refresh: $e',
          error: e, stackTrace: st, name: 'PlantIntelligenceDashboard');
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Obtenir l'ID du jardin courant (celui que l'UI et l'intelligence doivent utiliser)
    final currentGardenId =
        ref.watch(core_intel.currentIntelligenceGardenIdProvider);

    // Si aucun jardin n'est sélectionné, on affiche un état vide
    if (currentGardenId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Intelligence Végétale')),
        body: const Center(
            child: Text(
                'Aucun jardin sélectionné. Veuillez créer ou sélectionner un jardin.')),
      );
    }

    final intelligenceState =
        ref.watch(intelligenceStateProvider(currentGardenId));
    final alertsState = ref.watch(core_intel.intelligentAlertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intelligence Végétale'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: _isRefreshing
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            tooltip: 'Rafraîchir l\'analyse',
            onPressed: _isRefreshing ? null : _onManualRefresh,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sélecteur de jardins (chips / dropdown)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: GardenSelectorWidget(
                style: GardenSelectorStyle.chips,
                onGardenChanged: (gardenId) async {
                  // On s'assure que la sélection déclenche l'initialisation.
                  try {
                    await ref
                        .read(intelligenceStateProvider(gardenId).notifier)
                        .initializeForGarden();
                  } catch (e, st) {
                    developer.log('Error initializing garden from selector: $e',
                        error: e,
                        stackTrace: st,
                        name: 'PlantIntelligenceDashboard');
                  }
                },
              ),
            ),

            // Header résumé
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Jardin: ${currentGardenId}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (intelligenceState.isAnalyzing) ...[
                    const SizedBox(width: 8),
                    const CircularProgressIndicator(strokeWidth: 2),
                  ],
                ],
              ),
            ),

            const Divider(),

            // Statuts (nombre de plantes actives / analyses / alerts)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Row(
                children: [
                  _smallStat('Plantes actives',
                      intelligenceState.activePlantIds.length.toString()),
                  const SizedBox(width: 12),
                  _smallStat('Analyses',
                      intelligenceState.plantConditions.length.toString()),
                  const SizedBox(width: 12),
                  _smallStat(
                      'Alertes', alertsState.activeAlerts.length.toString()),
                ],
              ),
            ),

            const Divider(),

            // Liste simple des plantes et leur condition principale
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView(
                  children: [
                    if (intelligenceState.plantConditions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                            child: Text(
                                'Aucune condition analysée pour ce jardin.')),
                      ),
                    for (final entry
                        in intelligenceState.plantConditions.entries)
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(entry
                              .key), // plantId : tu peux remplacer par nom via provider plantCatalog
                          subtitle: Text(_formatConditionSummary(entry.value)),
                          trailing: IconButton(
                            icon: const Icon(Icons.history),
                            onPressed: () {
                              // Récupérer le nom de la plante depuis le catalogue si possible
                              final plantsList = ref.read(plantsListProvider);
                              PlantFreezed? plantEntity;
                              for (final p in plantsList) {
                                if (p.id == entry.key) {
                                  plantEntity = p;
                                  break;
                                }
                              }
                              final plantName =
                                  plantEntity?.commonName ?? entry.key;

                              // Ouvre l'historique d'évolution via Navigator (MaterialPageRoute)
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlantEvolutionHistoryScreen(
                                    plantId: entry.key,
                                    plantName: plantName,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallStat(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 8),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatConditionSummary(PlantCondition condition) {
    final status = condition.status.toString().split('.').last;
    final score = condition.healthScore?.toStringAsFixed(0) ?? '-';
    return 'Status: $status • Health: $score';
  }
}
