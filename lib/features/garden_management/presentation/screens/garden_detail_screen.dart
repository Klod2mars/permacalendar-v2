import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/garden_bed/providers/garden_bed_scoped_provider.dart';
import '../../providers/garden_management_provider.dart';
import '../../../../features/garden/providers/garden_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/models/garden_freezed.dart';
import '../../../garden_bed/presentation/widgets/germination_preview.dart';
import '../../../planting/providers/planting_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../garden_bed/presentation/widgets/create_garden_bed_dialog.dart';

// --- Imports ajoutés ---
import '../../../../core/models/garden_bed.dart';
import '../../../../core/data/hive/garden_boxes.dart';
import '../../../../core/services/activity_observer_service.dart';
import '../../../../core/events/garden_event_bus.dart';
import '../../../../core/events/garden_events.dart';

class GardenDetailScreen extends ConsumerWidget {
  final String gardenId;
  final bool openPlantingsOnBedTap;

  const GardenDetailScreen({
    super.key,
    required this.gardenId,
    this.openPlantingsOnBedTap = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenAsync = ref.watch(gardenDetailProvider(gardenId));
    final gardenBedsAsync = ref.watch(gardenBedProvider(gardenId));
    final theme = Theme.of(context);

    return gardenAsync.when(
      loading: () => const Scaffold(
        body: Center(child: LoadingWidget()),
      ),
      error: (error, stack) => Scaffold(
        appBar: const CustomAppBar(
          title: 'Erreur',
        ),
        body: ErrorStateWidget(
          title: 'Erreur de chargement',
          subtitle: 'Impossible de charger le jardin: $error',
          onRetry: () => ref.refresh(gardenDetailProvider(gardenId)),
          retryText: 'Réessayer',
        ),
      ),
      data: (garden) {
        if (garden == null) {
          return Scaffold(
            appBar: const CustomAppBar(
              title: 'Jardin introuvable',
            ),
            body: ErrorStateWidget(
              title: 'Jardin introuvable',
              subtitle: 'Le jardin demandé n\'existe pas ou a été supprimé.',
              onRetry: () => context.pop(),
              retryText: 'Retour',
            ),
          );
        }

        return gardenBedsAsync.when(
          loading: () => const Scaffold(
            body: Center(child: LoadingWidget()),
          ),
          error: (error, stack) => Scaffold(
            appBar: CustomAppBar(
              title: garden.name,
            ),
            body: ErrorStateWidget(
              title: 'Erreur de chargement des planches',
              subtitle: 'Impossible de charger les planches: $error',
              onRetry: () => ref.refresh(gardenBedProvider(gardenId)),
              retryText: 'Réessayer',
            ),
          ),
          data: (gardenBeds) {
            final double totalBedsArea = gardenBeds.fold<double>(
                0, (sum, bed) => sum + (bed as GardenBed).sizeInSquareMeters);

            return Scaffold(
              appBar: CustomAppBar(
                title: garden.name,
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenuAction(context, ref, value, garden.id),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Modifier'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle_status',
                        child: Row(
                          children: [
                            Icon(garden.isActive
                                ? Icons.archive
                                : Icons.unarchive),
                            const SizedBox(width: 8),
                            Text(garden.isActive ? 'Archiver' : 'Désarchiver'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Supprimer',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // FAB : ouvre le formulaire complet de création de parcelle
              floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                label: const Text("Parcelle"),
                onPressed: () =>
                    _showCreateGardenBedDialog(context, ref, garden),
              ),

              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Garden Status Badge
                    if (!garden.isActive) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.archive, size: 16, color: Colors.orange),
                            SizedBox(width: 4),
                            Text(
                              'Jardin archivé',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Garden Image
                    if (garden.imageUrl != null &&
                        garden.imageUrl!.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            garden.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Garden Information (superficie calculée depuis les parcelles)
                    _buildGardenInfo(
                        garden, theme, totalBedsArea, gardenBeds.length),
                    const SizedBox(height: 24),

                    // Garden Beds Section
                    _buildGardenBedsSection(
                        context, ref, theme, garden, gardenBeds),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGardenInfo(GardenFreezed garden, ThemeData theme,
      double totalBedsArea, int gardenBedsCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description si elle existe (affichée au-dessus de l'encadré principal)
        if (garden.description?.isNotEmpty == true) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              garden.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Encadré principal avec les métriques essentielles
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Parcelles',
                '$gardenBedsCount',
                Icons.grid_view,
                theme,
              ),
              _buildStatItem(
                'Surface totale',
                '${totalBedsArea.toStringAsFixed(1)} m²',
                Icons.straighten,
                theme,
              ),
            ],
          ),
        ),

        // Date de création
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Créé le ${AppDateUtils.formatDate(garden.createdAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
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
              const SizedBox(height: 2),
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

  Widget _buildGardenBedsSection(BuildContext context, WidgetRef ref,
      ThemeData theme, GardenFreezed garden, List<GardenBed> gardenBeds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Parcelles',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 16),

        // Affichage conditionnel selon l'état des parcelles
        if (gardenBeds.isEmpty)
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.grass,
                    size: 48,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune parcelle',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Créez des parcelles pour organiser vos plantations',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              const SizedBox(height: 16),

              // Affiche chaque parcelle sous forme de Card simple
              ...gardenBeds.map((bed) {
                final GardenBed bedTyped = bed as GardenBed;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row principal : titre + actions
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(bedTyped.name),
                          subtitle: Text(bedTyped.formattedSize),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              switch (value) {
                                case 'edit':
                                  await _editBed(
                                      context, ref, garden, bedTyped);
                                  break;
                                case 'delete':
                                  await _deleteBed(
                                      context, ref, garden, bedTyped);
                                  break;
                                case 'open':
                                  context.push(
                                    '/garden/${garden.id}/beds/${bedTyped.id}/detail',
                                    extra: bedTyped.name,
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                  value: 'open', child: Text('Ouvrir')),
                              const PopupMenuItem(
                                  value: 'edit', child: Text('Modifier')),
                              const PopupMenuItem(
                                  value: 'delete', child: Text('Supprimer')),
                            ],
                          ),
                          onTap: () {
                            if (openPlantingsOnBedTap) {
                              // Ouvrir la liste de plantations si demandé
                              context.push(
                                '/garden/${garden.id}/beds/${bedTyped.id}/plantings',
                                extra: bedTyped.name,
                              );
                            } else {
                              // Ouvrir la Planche 2
                              context.push(
                                '/garden/${garden.id}/beds/${bedTyped.id}/detail',
                                extra: bedTyped.name,
                              );
                            }
                          },
                        ),

                        // Extra content : preview germination + small stats
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GerminationPreview(
                                gardenBed: bedTyped,
                                allPlantings:
                                    ref.watch(plantingProvider).plantings,
                                plants: ref.watch(plantsListProvider),
                                forceRefresh: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 8),

              // CTA "Gérer les parcelles"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push(
                      AppRoutes.gardenBeds.replaceFirst(':gardenId', garden.id),
                      extra: garden.name,
                    );
                  },
                  child: const Text('Gérer les parcelles'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _showCreateGardenBedDialog(
      BuildContext context, WidgetRef ref, GardenFreezed garden) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => CreateGardenBedDialog(gardenId: garden.id),
    );

    if (result == true) {
      ref.invalidate(gardenBedProvider(garden.id));
    }
  }

  Future<void> _editBed(BuildContext context, WidgetRef ref,
      GardenFreezed garden, GardenBed bedTyped) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) =>
          CreateGardenBedDialog(gardenId: garden.id, gardenBed: bedTyped),
    );

    if (result == true) {
      ref.invalidate(gardenBedProvider(garden.id));
    }
  }

  Future<void> _deleteBed(BuildContext context, WidgetRef ref,
      GardenFreezed garden, GardenBed bedTyped) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('Supprimer la parcelle'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${bedTyped.name}" ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dctx).pop(false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.of(dctx).pop(true),
              child: const Text('Supprimer')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Supprimer de Hive (sanctuaire)
        await GardenBoxes.gardenBeds.delete(bedTyped.id);

        // Tracker l'activité
        await ActivityObserverService().captureGardenBedDeleted(
          gardenBedId: bedTyped.id,
          gardenBedName: bedTyped.name,
          gardenId: bedTyped.gardenId,
        );

        // Émettre event (silencieux si erreur)
        try {
          GardenEventBus().emit(
            GardenEvent.gardenContextUpdated(
              gardenId: bedTyped.gardenId,
              timestamp: DateTime.now(),
              metadata: {
                'action': 'bed_deleted',
                'bedId': bedTyped.id,
              },
            ),
          );
        } catch (_) {
          // silencieux
        }

        // Forcer le refresh
        ref.invalidate(gardenBedProvider(garden.id));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Parcelle supprimée'),
                backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de la suppression: $e')));
        }
      }
    }
  }

  void _handleMenuAction(
      BuildContext context, WidgetRef ref, String action, String gardenId) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Édition à implémenter')),
        );
        break;
      case 'toggle_status':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Toggle status à implémenter')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref, gardenId);
        break;
    }
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, String gardenId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le jardin'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce jardin ? '
          'Cette action supprimera également toutes les parcelles et plantations associées. '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                final success = await ref
                    .read(gardenProvider.notifier)
                    .deleteGarden(gardenId);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jardin supprimé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop(); // Return to garden list
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erreur lors de la suppression du jardin'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
