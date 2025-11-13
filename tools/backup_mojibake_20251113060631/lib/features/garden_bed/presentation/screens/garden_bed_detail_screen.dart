import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/garden_bed.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../providers/garden_bed_provider.dart';
import '../../../planting/providers/planting_provider.dart';

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
    );
  }

  Widget _buildGardenBedDetail(BuildContext context, WidgetRef ref,
      GardenBed gardenBed, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations de base
          _buildBasicInfo(gardenBed, theme),
          const SizedBox(height: 24),

          // Actions rapides
          _buildQuickActions(context, gardenBed, theme),
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

  Widget _buildQuickActions(
      BuildContext context, GardenBed gardenBed, ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions rapides',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                          '/garden/${gardenBed.gardenId}/beds/${gardenBed.id}/plantings');
                    },
                    icon: const Icon(Icons.eco),
                    label: const Text('Plantations'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter l'édition de la parcelle
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plantations actuelles',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            if (plantings.isEmpty)
              const EmptyStateWidget(
                icon: Icons.eco,
                title: 'Aucune plantation',
                subtitle: 'Cette parcelle n\'a pas encore de plantations.',
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


