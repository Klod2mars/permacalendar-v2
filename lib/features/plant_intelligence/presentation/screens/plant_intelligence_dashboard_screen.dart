// lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart
// Plant Intelligence Dashboard Screen — version réactivée & multi-jardin (jusqu'à 5 jardins)
// - Précharge les analyses pour les 5 premiers jardins afin d'assurer que la feature
//   est activable individuellement pour chacun d'entre eux.
// - Importe explicitement les providers core critiques (robuste vis-à-vis des exports).
//
// Note : Cette version suppose que les providers suivants existent:
// - activeGardenIdProvider (lib/core/providers/active_garden_provider.dart)
// - currentIntelligenceGardenIdProvider, intelligentAlertsProvider (lib/core/providers/intelligence_runtime_providers.dart)
// - gardenActivePlantsProvider, gardenStatsProvider, gardenActivitiesProvider, unifiedGardenContextProvider
//
// Auteur : Audit & correction par l'équipe PermaCalendar (via assistant)

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/intelligence_state_providers.dart';

import '../../domain/entities/plant_condition.dart';

import '../../../garden/providers/garden_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

import '../../../../core/providers/intelligence_runtime_providers.dart'
    as core_runtime;
import '../../../../core/providers/active_garden_provider.dart' as core_active;
import '../../../../core/providers/garden_aggregation_providers.dart'
    as garden_agg;

import '../widgets/garden_selector_widget.dart';
import '../../presentation/screens/plant_evolution_history_screen.dart';

// Réutiliser le widget existant (évite duplication)
import '../widgets/plant_checklist_card.dart';

/// Tableau de bord : Intelligence Végétale
/// - Gère la sélection de jardin
/// - Pré-charge jusqu'à 5 jardins pour permettre un usage multi-jardins
class PlantIntelligenceDashboardScreen extends ConsumerStatefulWidget {
  const PlantIntelligenceDashboardScreen({super.key});

  @override
  ConsumerState<PlantIntelligenceDashboardScreen> createState() =>
      _PlantIntelligenceDashboardScreenState();
}

class _PlantIntelligenceDashboardScreenState
    extends ConsumerState<PlantIntelligenceDashboardScreen> {
  bool _isRefreshing = false;

  /// Nombre maximum de jardins à pré-initialiser (par exigence récente)
  static const int _maxPreloadGardens = 5;

  @override
  void initState() {
    super.initState();
    developer.log('PlantIntelligenceDashboard.initState()',
        name: 'PlantIntelligenceDashboard');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeIntelligence();
    });
  }

  /// Initialise l'intelligence :
  /// - Choisit le jardin courant (préférence : précédent sélectionné, sinon jardin actif, sinon premier)
  /// - Pré-charge (initializeForGarden) pour les N premiers jardins (N = _maxPreloadGardens)
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

      // Lecture de la sélection précédente / jardin actif
      final prevSelectedGardenId =
          ref.read(core_runtime.currentIntelligenceGardenIdProvider);
      final activeGardenId = ref.read(core_active.activeGardenIdProvider);

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

      // Définir le jardin courant pour l'intelligence
      ref
          .read(core_runtime.currentIntelligenceGardenIdProvider.notifier)
          .state = gardenIdToUse;

      developer.log('Using gardenId: $gardenIdToUse',
          name: 'PlantIntelligenceDashboard');

      // Préparer la liste des jardins à pré-initialiser (jusqu'à _maxPreloadGardens)
      final gardenIdsToInit =
          gardens.take(_maxPreloadGardens).map((g) => g.id).toSet().toList();

      // S'assurer que le gardenIdToUse est initialisé (s'il n'est pas dans les N premiers)
      if (!gardenIdsToInit.contains(gardenIdToUse)) {
        gardenIdsToInit.add(gardenIdToUse);
      }

      developer.log('Preloading gardens: ${gardenIdsToInit.join(", ")}',
          name: 'PlantIntelligenceDashboard');

      // Initialiser en parallèle (bounded) : utiliser Future.wait
      // NB : initializeForGarden est idempotent côté notifier
      await Future.wait(
        gardenIdsToInit.map((id) async {
          try {
            await ref
                .read(intelligenceStateProvider(id).notifier)
                .initializeForGarden();
            developer.log('Initialized intelligence for $id',
                name: 'PlantIntelligenceDashboard');
          } catch (e, st) {
            developer.log('Error initializing garden $id: $e',
                error: e, stackTrace: st, name: 'PlantIntelligenceDashboard');
          }
        }),
      );

      developer.log('initializeForGarden completed for preloaded gardens',
          name: 'PlantIntelligenceDashboard');
    } catch (e, st) {
      developer.log('Error in _initializeIntelligence: $e',
          error: e, stackTrace: st, name: 'PlantIntelligenceDashboard');
    } finally {
      developer.log('END _initializeIntelligence',
          name: 'PlantIntelligenceDashboard');
    }
  }

  /// Rafraîchissement manuel : invalide les providers liés au jardin courant
  Future<void> _onManualRefresh() async {
    setState(() => _isRefreshing = true);
    try {
      final currentGardenId =
          ref.read(core_runtime.currentIntelligenceGardenIdProvider);
      if (currentGardenId == null) {
        developer.log('No current garden selected on refresh',
            name: 'PlantIntelligenceDashboard');
        return;
      }

      // Invalider les providers liés afin de forcer un rechargement propre
      ref.invalidate(garden_agg.unifiedGardenContextProvider(currentGardenId));
      ref.invalidate(garden_agg.gardenActivePlantsProvider(currentGardenId));
      ref.invalidate(garden_agg.gardenStatsProvider(currentGardenId));
      ref.invalidate(garden_agg.gardenActivitiesProvider(currentGardenId));

      // Réinitialiser l'intelligence pour le jardin courant
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

    // Jardin courant d'intelligence
    final currentGardenId =
        ref.watch(core_runtime.currentIntelligenceGardenIdProvider);

    // Etat d'intelligence du jardin courant (family)
    final intelligenceState = currentGardenId != null
        ? ref.watch(intelligenceStateProvider(currentGardenId))
        : null;

    // Alertes globales intelligentes (core runtime)
    final alertsState = ref.watch(core_runtime.intelligentAlertsProvider);

    // Liste complète des jardins (pour l'affichage / selector)
    final gardens = ref.watch(gardenProvider).gardens;

    if (gardens.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Intelligence Végétale')),
        body: const Center(child: Text('Aucun jardin trouvé.')),
      );
    }

    // Nombre de jardins préchargés / disponible pour l'IHM
    final preloadedCount = gardens.length >= _maxPreloadGardens
        ? _maxPreloadGardens
        : gardens.length;

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
            // Selector : GardenSelectorWidget (chips)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: GardenSelectorWidget(
                style: GardenSelectorStyle.chips,
                // Limitation visuelle / info : on indique le nb max gérés
                trailingInfo: 'Préchargés: $preloadedCount / ${gardens.length}',
                onGardenChanged: (gardenId) async {
                  try {
                    // Définir le garden courant pour l'intelligence
                    ref
                        .read(core_runtime
                            .currentIntelligenceGardenIdProvider.notifier)
                        .state = gardenId;

                    // Initialiser ce jardin à la demande
                    await ref
                        .read(intelligenceStateProvider(gardenId).notifier)
                        .initializeForGarden();
                  } catch (e, st) {
                    developer.log('Error initializing garden from selector: $e',
                        error: e,
                        stackTrace: st,
                        name: 'PlantIntelligenceDashboard');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Erreur initialisation jardin')),
                      );
                    }
                  }
                },
              ),
            ),

            // Header : jardin courant + état d'analyse + sélection multi-jardins
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Jardin: ${currentGardenId ?? gardens.first.id}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (intelligenceState != null &&
                      intelligenceState.isAnalyzing) ...[
                    const SizedBox(width: 8),
                    const CircularProgressIndicator(strokeWidth: 2),
                  ],
                ],
              ),
            ),

            const Divider(),

            // Small stats : Plantes / Analyses / Alerte
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Row(
                children: [
                  _smallStat(
                      context,
                      'Plantes actives',
                      intelligenceState?.activePlantIds.length.toString() ??
                          ref
                              .read(garden_agg.gardenActivePlantsProvider(
                                  currentGardenId ?? gardens.first.id))
                              .maybeWhen(
                                  data: (v) => v.length.toString(),
                                  orElse: () => '-')),
                  const SizedBox(width: 12),
                  _smallStat(
                      context,
                      'Analyses',
                      intelligenceState?.plantConditions.length.toString() ??
                          '-'),
                  const SizedBox(width: 12),
                  _smallStat(context, 'Alertes',
                      alertsState.activeAlerts.length.toString()),
                ],
              ),
            ),

            const Divider(),

            // Liste des plantes (pour le jardin courant)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Builder(builder: (context) {
                  if (currentGardenId == null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('Aucun jardin sélectionné.'),
                      ),
                    );
                  }

                  final state = intelligenceState;
                  if (state == null || state.plantConditions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child:
                            Text('Aucune condition analysée pour ce jardin.'),
                      ),
                    );
                  }

                  final plantConditionsEntries =
                      state.plantConditions.entries.toList();

                  return ListView.builder(
                    itemCount: plantConditionsEntries.length,
                    itemBuilder: (context, index) {
                      final entry = plantConditionsEntries.elementAt(index);
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

                      // Utiliser le widget réutilisable PlantChecklistCard
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: PlantChecklistCard(
                          plantId: plantId,
                          gardenId: currentGardenId,
                          plantName: plantName,
                          imageUrl: imageUrl,
                        ),
                      );
                    },
                  );
                }),
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
