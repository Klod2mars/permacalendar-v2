import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../plant_catalog/presentation/screens/plant_catalog_screen.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../planting/presentation/dialogs/create_planting_dialog.dart';
import '../../../../core/models/garden_bed.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../providers/garden_bed_provider.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/core/models/planting.dart';

class GardenBedDetailScreen extends ConsumerWidget {
  final String gardenId;
  final String bedId;
  final VoidCallback? onPop;

  const GardenBedDetailScreen({
    super.key,
    required this.gardenId,
    required this.bedId,
    this.onPop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenBedState = ref.watch(gardenBedProvider);

    final gardenBed =
        gardenBedState.gardenBeds.where((bed) => bed.id == bedId).firstOrNull;
    final theme = Theme.of(context);

    // Vérification de non-nullité pour utiliser gardenBed en toute sécurité
    final bool hasBed = gardenBed != null;

    // Charger les parcelles si nécessaire
    if (gardenBedState.gardenBeds.isEmpty && !gardenBedState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(gardenBedProvider.notifier).loadGardenBeds(gardenId);
      });
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: gardenBed?.name ?? 'Détail de la parcelle',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onPop ?? () => context.pop(),
        ),
      ),
      body: gardenBedState.isLoading
          ? const Center(child: LoadingWidget())
          : gardenBedState.error != null
              ? ErrorStateWidget(
                  title: 'Erreur',
                  subtitle: gardenBedState.error!,
                  onRetry: () => ref
                      .read(gardenBedProvider.notifier)
                      .loadGardenBeds(gardenId),
                )
              : gardenBed == null
                  ? const EmptyStateWidget(
                      icon: Icons.grid_view,
                      title: 'Parcelle non trouvée',
                      subtitle:
                          'Cette parcelle n\'existe pas ou a été supprimée.',
                    )
                  : _buildGardenBedDetail(context, ref, gardenBed, theme),
      // FLOATING ACTION BUTTON - POINT 4
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: hasBed
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
              child: FloatingActionButton(
                tooltip: 'Ajouter une plantation',
                child: const Icon(Icons.add),
                onPressed: () async {
                  final bed = gardenBed!; // safe

                  // 1) Ouvrir le catalogue (6)
                  final selectedPlantId =
                      await Navigator.of(context).push<String?>(
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlantCatalogScreen(isSelectionMode: true),
                      fullscreenDialog: true,
                    ),
                  );
                  if (selectedPlantId == null) return;

                  // 2) récupérer plant (si nécessaire)...
                  List<PlantFreezed> plantList = ref.read(plantsListProvider);
                  PlantFreezed? plant;
                  try {
                    plant =
                        plantList.firstWhere((p) => p.id == selectedPlantId);
                  } catch (_) {
                    plant = null;
                  }
                  if (plant == null) {
                    await ref.read(plantCatalogProvider.notifier).loadPlants();
                    final reloaded = ref.read(plantsListProvider);
                    try {
                      plant =
                          reloaded.firstWhere((p) => p.id == selectedPlantId);
                    } catch (_) {
                      plant = null;
                    }
                  }

                  // 3) créer preset
                  final preset = Planting(
                    gardenBedId: bed.id,
                    plantId: selectedPlantId,
                    plantName: plant?.commonName ?? 'Plante',
                    plantedDate: DateTime.now(),
                    quantity: 1,
                  );

                  // 4) Ouvrir le dialog (point 5 - bottom sheet)
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (ctx) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: CreatePlantingDialog(
                        gardenBedId: bed.id,
                        planting: preset,
                      ),
                    ),
                  );

                  // 5) recharger les plantings
                  await ref
                      .read(plantingProvider.notifier)
                      .loadPlantings(bed.id);
                },
              ),
            )
          : null,
    );
  }

  Widget _buildGardenBedDetail(BuildContext context, WidgetRef ref,
      GardenBed gardenBed, ThemeData theme) {
    // CHARGEMENT DES PLANTATIONS - POINT 2
    // S'assurer que les plantings pour cette parcelle sont chargés
    final plantingState = ref.watch(plantingProvider);
    final bedPlantings = plantingState.plantings
        .where((p) => p.gardenBedId == gardenBed.id)
        .toList();
    if (bedPlantings.isEmpty && !plantingState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(plantingProvider.notifier).loadPlantings(gardenBed.id);
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations de base
          _buildBasicInfo(gardenBed, theme),

          const SizedBox(height: 24),

          // Actions rapides
          _buildQuickActions(context, ref, gardenBed, theme),

          const SizedBox(height: 24),

          // Plantations actuelles
          _buildCurrentPlantings(context, ref, gardenBed, theme),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(GardenBed gardenBed, ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (gardenBed.description.isNotEmpty) ...[
              _buildInfoRow(Icons.description, 'Description',
                  gardenBed.description, theme),
              const SizedBox(height: 12),
            ],
            _buildInfoRow(
                Icons.straighten, 'Surface', gardenBed.formattedSize, theme),
            const SizedBox(height: 12),
            _buildInfoRow(
                Icons.terrain, 'Type de sol', gardenBed.soilType, theme),
            const SizedBox(height: 12),
            _buildInfoRow(
                Icons.wb_sunny, 'Exposition', gardenBed.exposure, theme),
            if (gardenBed.notes != null && gardenBed.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(Icons.note, 'Notes', gardenBed.notes!, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // POINT 1 - Actions rapides simplifiées
  Widget _buildQuickActions(BuildContext context, WidgetRef ref,
      GardenBed gardenBed, ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions rapides',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: implémentation "Modifier" existante
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPlantings(BuildContext context, WidgetRef ref,
      GardenBed gardenBed, ThemeData theme) {
    final plantingState = ref.watch(plantingProvider);

    final plantings = plantingState.plantings
        .where((planting) => planting.gardenBedId == gardenBed.id)
        .toList();

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // POINT 2 - Header résilient avec Expanded
            Row(
              children: [
                // Le titre prend tout l'espace disponible
                Expanded(
                  child: Text(
                    'Plantations actuelles',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

                // Voir tout seulement si nécessaire
                if (plantings.length > 3)
                  TextButton(
                    onPressed: () {
                      context.push(
                          '/garden/${gardenBed.gardenId}/beds/${gardenBed.id}/plantings');
                    },
                    child: const Text('Voir tout'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // POINT 3 - CTA dans état vide avec flow FAB
            if (plantings.isEmpty)
              EmptyStateWidget(
                icon: Icons.eco,
                title: 'Aucune plantation',
                subtitle: 'Cette parcelle n\'a pas encore de plantations.',
                actionText: 'Ajouter une plantation',
                onAction: () async {
                  // Même flow que le FAB : catalogue -> dialog prérempli
                  final selectedPlantId =
                      await Navigator.of(context).push<String?>(
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlantCatalogScreen(isSelectionMode: true),
                      fullscreenDialog: true,
                    ),
                  );
                  if (selectedPlantId == null) return;

                  // Récupérer la plante (si dispo) et créer preset
                  List<PlantFreezed> plantList = ref.read(plantsListProvider);
                  PlantFreezed? plant;
                  try {
                    plant =
                        plantList.firstWhere((p) => p.id == selectedPlantId);
                  } catch (_) {
                    plant = null;
                  }
                  if (plant == null) {
                    await ref.read(plantCatalogProvider.notifier).loadPlants();
                    final reloaded = ref.read(plantsListProvider);
                    try {
                      plant =
                          reloaded.firstWhere((p) => p.id == selectedPlantId);
                    } catch (_) {
                      plant = null;
                    }
                  }

                  final preset = Planting(
                    gardenBedId: gardenBed.id,
                    plantId: selectedPlantId,
                    plantName: plant?.commonName ?? 'Plante',
                    plantedDate: DateTime.now(),
                    quantity: 1,
                  );

                  // Ouvrir la modal de création (bottom sheet)
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (ctx) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: CreatePlantingDialog(
                        gardenBedId: gardenBed.id,
                        planting: preset,
                      ),
                    ),
                  );

                  await ref
                      .read(plantingProvider.notifier)
                      .loadPlantings(gardenBed.id);
                },
              )
            else
              Column(
                children: plantings.take(3).map((planting) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.eco),
                    ),
                    title: Text(planting.plantName),
                    subtitle: Text(
                        'Planté le ${planting.plantedDate.day}/${planting.plantedDate.month}/${planting.plantedDate.year}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.push('/plantings/${planting.id}');
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
