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

class GardenDetailScreen extends ConsumerWidget {
  final String gardenId;

  const GardenDetailScreen({
    super.key,
    required this.gardenId,
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
          retryText: 'RÃ©essayer',
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
              subtitle: 'Le jardin demandÃ© n\'existe pas ou a Ã©tÃ© supprimÃ©.',
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
              retryText: 'RÃ©essayer',
            ),
          ),
          data: (gardenBeds) {
            final double totalBedsArea = gardenBeds.fold<double>(
                0, (sum, bed) => sum + bed.sizeInSquareMeters);

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
                            Text(garden.isActive ? 'Archiver' : 'DÃ©sarchiver'),
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
                              'Jardin archivÃ©',
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

                    // Garden Information (superficie calculÃ©e depuis les parcelles)
                    _buildGardenInfo(
                        garden, theme, totalBedsArea, gardenBeds.length),
                    const SizedBox(height: 24),

                    // Garden Beds Section
                    _buildGardenBedsSection(context, ref, theme, garden),
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
        // Description si elle existe (affichÃ©e au-dessus de l'encadrÃ© principal)
        if (garden.description?.isNotEmpty == true) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.5),
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

        // EncadrÃ© principal avec les mÃ©triques essentielles (design vert pomme)
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
                '${totalBedsArea.toStringAsFixed(1)} mÂ²',
                Icons.straighten,
                theme,
              ),
            ],
          ),
        ),

        // Date de crÃ©ation en position secondaire (texte gris discret)
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'CrÃ©Ã© le ${AppDateUtils.formatDate(garden.createdAt)}',
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
      ThemeData theme, GardenFreezed garden) {
    // Invalider le provider pour forcer le rechargement des parcelles
    // Ceci corrige le problÃ¨me de cache qui empÃªchait l'affichage immÃ©diat des parcelles
    // lors de la navigation entre diffÃ©rents jardins
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(gardenBedProvider(garden.id));
    });

    final gardenBedsAsync = ref.watch(gardenBedProvider(garden.id));

    return gardenBedsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Erreur: $error', style: theme.textTheme.bodyMedium),
      ),
      data: (gardenBeds) => Column(
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
              CustomButton(
                text: 'GÃ©rer',
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.push('/garden/${garden.id}/beds', extra: garden.name);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Affichage conditionnel selon l'Ã©tat des parcelles
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
                      'CrÃ©ez des parcelles pour organiser vos plantations',
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
            // Affichage des parcelles existantes
            Column(
              children: [
                // RÃ©sumÃ© des parcelles
                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_view,
                          size: 24,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${gardenBeds.length} parcelle${gardenBeds.length > 1 ? 's' : ''}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Le total des surfaces est dÃ©sormais affichÃ© dans la carte d'informations du jardin
                              // pour Ã©viter la duplication au milieu de la page.
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Liste des parcelles (limitÃ©e Ã  3 pour l'aperÃ§u)
                ...gardenBeds.take(3).map((bed) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.grass,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                bed.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (bed.description.isNotEmpty) ...[
                                    Text(
                                      bed.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${bed.sizeInSquareMeters.toStringAsFixed(1)} mÂ²',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'â€¢ ${bed.exposure}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: theme.colorScheme.outline,
                              ),
                              onTap: () {
                                // Navigation vers les plantations de la parcelle
                                context.push(
                                    '/garden/${garden.id}/beds/${bed.id}/plantings',
                                    extra: bed.name);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: GerminationPreview(
                                gardenBed: bed,
                                allPlantings: ref.watch(plantingsListProvider),
                                plants: ref.watch(plantsListProvider),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                // Bouton "Voir toutes" si plus de 3 parcelles
                if (gardenBeds.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton(
                      onPressed: () {
                        context.push('/garden/${garden.id}/beds',
                            extra: garden.name);
                      },
                      child: Text(
                          'Voir toutes les parcelles (${gardenBeds.length})'),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  void _handleMenuAction(
      BuildContext context, WidgetRef ref, String action, String gardenId) {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ã‰dition Ã  implÃ©menter')),
        );
        break;
      case 'toggle_status':
        // TODO: Implement toggle status with new provider
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Toggle status Ã  implÃ©menter')),
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
          'ÃŠtes-vous sÃ»r de vouloir supprimer ce jardin ? '
          'Cette action supprimera Ã©galement toutes les parcelles et plantations associÃ©es. '
          'Cette action est irrÃ©versible.',
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
                      content: Text('Jardin supprimÃ© avec succÃ¨s'),
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

