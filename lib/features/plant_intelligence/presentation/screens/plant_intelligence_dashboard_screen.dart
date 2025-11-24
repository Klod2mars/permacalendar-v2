// lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/intelligence_state_providers.dart';

import '../widgets/garden_selector_widget.dart';
import '../widgets/plant_checklist_card.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../core/providers/intelligence_runtime_providers.dart';

class PlantIntelligenceDashboardScreen extends ConsumerStatefulWidget {
  const PlantIntelligenceDashboardScreen({super.key});

  @override
  ConsumerState<PlantIntelligenceDashboardScreen> createState() =>
      _PlantIntelligenceDashboardScreenState();
}

class _PlantIntelligenceDashboardScreenState
    extends ConsumerState<PlantIntelligenceDashboardScreen> {
  bool _didInitialLoad = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final plantCatalogState = ref.read(plantCatalogProvider);
      if (plantCatalogState.plants.isEmpty && !plantCatalogState.isLoading) {
        await ref.read(plantCatalogProvider.notifier).loadPlants();
      }

      final currentGardenId = ref.read(currentIntelligenceGardenIdProvider);
      if (currentGardenId != null) {
        try {
          await ref
              .read(intelligenceStateProvider(currentGardenId).notifier)
              .initializeForGarden();
        } catch (e) {
          debugPrint('⚠️ init intelligence erreur: $e');
        }
      }

      setState(() {
        _didInitialLoad = true;
      });
    });
  }

  Future<void> _refreshGarden(String gardenId) async {
    final notifier = ref.read(intelligenceStateProvider(gardenId).notifier);
    try {
      notifier.reset();
      await notifier.initializeForGarden();
    } catch (e) {
      debugPrint('Erreur refresh garden $gardenId : $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur actualisation: $e')));
    }
  }

  void _showActivePlantsSheet(String gardenId, List<String> activePlantIds) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text('Plantes actives'), leading: Icon(Icons.eco)),
              const Divider(),
              ...activePlantIds.map((plantId) {
                // Recherche sûre du plant dans le catalogue (sans orElse: () => null)
                final plantsList = ref.read(plantCatalogProvider).plants;
                dynamic maybePlant;
                try {
                  maybePlant = plantsList.firstWhere((p) => p.id == plantId);
                } catch (_) {
                  maybePlant = null;
                }
                final name = (maybePlant != null &&
                        (maybePlant as dynamic).commonName != null)
                    ? (maybePlant as dynamic).commonName as String
                    : plantId;
                return ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Analyse en cours...')));
                      await ref
                          .read(intelligenceStateProvider(gardenId).notifier)
                          .analyzePlant(plantId);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Analyse terminée')));
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showAlertsSheet() {
    final alertsState = ref.read(intelligentAlertsProvider);
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text('Alertes'), leading: Icon(Icons.warning_rounded)),
              const Divider(),
              if (alertsState.activeAlerts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Aucune alerte active'),
                )
              else
                ...alertsState.activeAlerts.map((a) => ListTile(
                      title: Text(a.title),
                      subtitle: Text(a.message),
                    )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentGardenId = ref.watch(currentIntelligenceGardenIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intelligence Végétale'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: const [
                Expanded(
                    child:
                        GardenSelectorWidget(style: GardenSelectorStyle.chips)),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir le jardin courant',
            onPressed: currentGardenId == null
                ? null
                : () => _refreshGarden(currentGardenId),
          ),
        ],
      ),
      body: currentGardenId == null
          ? _buildNoGarden(context)
          : _buildForGarden(context, currentGardenId),
    );
  }

  Widget _buildNoGarden(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GardenSelectorWidget(style: GardenSelectorStyle.dropdown),
            const SizedBox(height: 16),
            Text(
              'Sélectionnez un jardin pour afficher l’intelligence végétale.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForGarden(BuildContext context, String gardenId) {
    final intelligenceState = ref.watch(intelligenceStateProvider(gardenId));
    final plantCatalog = ref.watch(plantCatalogProvider);

    final activePlantsCount = intelligenceState.activePlantIds.length;
    final analysesCount = intelligenceState.plantConditions.length;
    final alertsState = ref.watch(intelligentAlertsProvider);
    final alertsCount = alertsState.activeAlerts.length;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await _refreshGarden(gardenId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jardin: $gardenId',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showActivePlantsSheet(
                        gardenId, intelligenceState.activePlantIds),
                    child: _buildBadge(
                        'Plantes actives', activePlantsCount.toString()),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      if (!intelligenceState.isAnalyzing) {
                        await ref
                            .read(intelligenceStateProvider(gardenId).notifier)
                            .initializeForGarden();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Analyse lancée')));
                      }
                    },
                    child: _buildBadge('Analyses', analysesCount.toString()),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _showAlertsSheet,
                    child: _buildBadge('Alertes', alertsCount.toString()),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Analyser'),
                    onPressed: intelligenceState.isAnalyzing
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(intelligenceStateProvider(gardenId)
                                      .notifier)
                                  .initializeForGarden();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Analyse lancée')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erreur: $e')));
                            }
                          },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (activePlantsCount == 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: Text('Aucune plante active dans ce jardin.',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              const SizedBox(height: 12),
              Column(
                children: intelligenceState.activePlantIds.map((plantId) {
                  final matches =
                      plantCatalog.plants.where((p) => p.id == plantId);
                  final maybePlant = matches.isNotEmpty ? matches.first : null;
                  final plantName = maybePlant?.commonName ?? plantId;
                  final imageUrl = (maybePlant?.metadata is Map)
                      ? (maybePlant!.metadata['image']?.toString())
                      : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PlantChecklistCard(
                      plantId: plantId,
                      gardenId: gardenId,
                      plantName: plantName,
                      imageUrl: imageUrl,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    )),
          ),
        ],
      ),
    );
  }
}
