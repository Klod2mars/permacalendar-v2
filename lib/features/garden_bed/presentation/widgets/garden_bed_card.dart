import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_card.dart';
import '../../../planting/providers/planting_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../core/models/garden_bed_freezed.dart';

class GardenBedCard extends ConsumerWidget {
  final GardenBedFreezed bed;
  final String gardenId;

  const GardenBedCard({
    super.key,
    required this.bed,
    required this.gardenId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Récupération de toutes les plantations
    final plantings = ref.watch(plantingsListProvider);
    final plantsCatalog = ref.watch(plantsListProvider);

    // Trouver la culture active s’il y en a une
    final activePlanting = plantings.firstWhere(
      (p) => p.gardenBedId == bed.id && !p.isHarvested,
      orElse: () => null,
    );

    // Trouver la plante (pour l'image PNG)
    final plant = activePlanting != null
        ? plantsCatalog.firstWhere(
            (pl) => pl.id == activePlanting.plantId,
            orElse: () => null,
          )
        : null;

    return CustomCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push(
            '/garden/$gardenId/beds/${bed.id}/plantings',
            extra: bed.name,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image de plante (si présente)
              if (plant != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/legumes/${plant.image}',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Icon(
                  Icons.grass,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),

              const SizedBox(width: 16),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bed.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${bed.sizeInSquareMeters.toStringAsFixed(1)} m²",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (activePlanting != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        "${plant?.name ?? 'Plante'} — Semé le ${activePlanting.plantedAt.day}/${activePlanting.plantedAt.month}",
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),

              // Icône récolte (visible uniquement si culture active)
              if (activePlanting != null)
                IconButton(
                  icon: const Icon(Icons.local_florist),
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    context.push(
                      '/garden/$gardenId/beds/${bed.id}/harvest',
                    );
                  },
                ),

              // Menu …
              PopupMenuButton<String>(
                onSelected: (value) {
                  // À implémenter : modifier / supprimer
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Modifier'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Supprimer',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
