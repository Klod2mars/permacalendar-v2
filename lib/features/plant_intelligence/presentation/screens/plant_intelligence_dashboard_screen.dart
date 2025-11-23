// lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart
// Version auditée et nettoyée — Plant Intelligence Dashboard Screen
// Remplace l'ancien fichier par celui-ci, puis full restart (Clean Run).

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/intelligence_state_providers.dart';
import '../../domain/entities/plant_condition.dart';

import '../../../garden/providers/garden_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

import '../../../../core/providers/garden_aggregation_providers.dart';
import '../../../../core/providers/providers.dart' as core_intel;

import '../widgets/garden_selector_widget.dart';
import 'plant_evolution_history_screen.dart';

/// Écran principal du tableau de bord d'intelligence des plantes (nettoyé)
class PlantIntelligenceDashboardScreen extends ConsumerStatefulWidget {
  const PlantIntelligenceDashboardScreen({super.key});

  @override
  ConsumerState<PlantIntelligenceDashboardScreen> createState() =>
      _PlantIntelligenceDashboardScreenState();
}

class _PlantIntelligenceDashboardScreenState
    extends ConsumerState<PlantIntelligenceDashboardScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    developer.log('PlantIntelligenceDashboard.initState()',
        name: 'PlantIntelligenceDashboard');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeIntelligence();
    });
  }

  Future<void> _initializeIntelligence() async {
    developer.log('BEGIN _initializeIntelligence',
        name: 'PlantIntelligenceDashboard');
    try {
      final gardenState = ref.read(gardenProvider);
      final gardens = gardenState.gardens;
      if (gardens.isEmpty) {
        developer.log('No gardens found', name: 'PlantIntelligenceDashboard');
        return;
      }

      final prevSelectedGardenId =
          ref.read(core_intel.currentIntelligenceGardenIdProvider);
      final activeGardenId = ref.read(core_intel.activeGardenIdProvider);

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

      ref.read(core_intel.currentIntelligenceGardenIdProvider.notifier).state =
          gardenIdToUse;

      developer.log('Using gardenId: $gardenIdToUse',
          name: 'PlantIntelligenceDashboard');

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

      // Invalider providers liés au jardin pour forcer rechargement
      ref.invalidate(unifiedGardenContextProvider(currentGardenId));
      ref.invalidate(gardenActivePlantsProvider(currentGardenId));
      ref.invalidate(gardenStatsProvider(currentGardenId));
      ref.invalidate(gardenActivitiesProvider(currentGardenId));

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
    final currentGardenId =
        ref.watch(core_intel.currentIntelligenceGardenIdProvider);

    if (currentGardenId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Intelligence Végétale')),
        body: const Center(child: Text('Aucun jardin sélectionné.')),
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
            icon: Icon(Icons.refresh,
                color: _isRefreshing
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface),
            tooltip: 'Rafraîchir l\'analyse',
            onPressed: _isRefreshing ? null : _onManualRefresh,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Selector
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: GardenSelectorWidget(
                style: GardenSelectorStyle.chips,
                onGardenChanged: (gardenId) async {
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

            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Jardin: $currentGardenId',
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

            // Small stats
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Row(
                children: [
                  _smallStat(context, 'Plantes actives',
                      intelligenceState.activePlantIds.length.toString()),
                  const SizedBox(width: 12),
                  _smallStat(context, 'Analyses',
                      intelligenceState.plantConditions.length.toString()),
                  const SizedBox(width: 12),
                  _smallStat(context, 'Alertes',
                      alertsState.activeAlerts.length.toString()),
                ],
              ),
            ),

            const Divider(),

            // Plant list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: intelligenceState.plantConditions.isEmpty
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child:
                            Text('Aucune condition analysée pour ce jardin.'),
                      ))
                    : ListView.builder(
                        itemCount: intelligenceState.plantConditions.length,
                        itemBuilder: (context, index) {
                          final entry = intelligenceState
                              .plantConditions.entries
                              .elementAt(index);
                          final plantId = entry.key;
                          final condition = entry.value;

                          // Récupérer le nom / image depuis le catalogue
                          final plantsList = ref.read(plantsListProvider);
                          PlantFreezed? plantEntity;
                          for (final p in plantsList) {
                            if (p.id == plantId) {
                              plantEntity = p;
                              break;
                            }
                          }
                          final plantName = plantEntity?.commonName ?? plantId;
                          final imageUrl =
                              plantEntity?.metadata['image']?.toString() ?? '';

                          return _PlantChecklistCard(
                            plantId: plantId,
                            plantName: plantName,
                            imageUrl: imageUrl,
                            condition: condition,
                            gardenId: currentGardenId,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallStat(BuildContext context, String title, String value) {
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
}

/// Carte compacte par plante — affichage minimal, navigation vers historique
class _PlantChecklistCard extends ConsumerWidget {
  final String plantId;
  final String plantName;
  final String imageUrl;
  final PlantCondition condition;
  final String gardenId;

  const _PlantChecklistCard({
    required this.plantId,
    required this.plantName,
    required this.imageUrl,
    required this.condition,
    required this.gardenId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = condition.status.toString().split('.').last;
    final score = condition.healthScore?.toStringAsFixed(0) ?? '-';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl,
                    width: 56, height: 56, fit: BoxFit.cover))
            : const CircleAvatar(child: Icon(Icons.agriculture)),
        title: Text(plantName),
        subtitle: Text('Status: $status • Health: $score'),
        trailing: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PlantEvolutionHistoryScreen(
                  plantId: plantId, plantName: plantName),
            ));
          },
        ),
      ),
    );
  }
}
