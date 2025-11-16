import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/models/garden_bed.dart';
import '../../../../core/models/planting.dart';
import '../../../planting/providers/planting_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';

class GardenBedCard extends ConsumerWidget {
  final GardenBed gardenBed;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Widget? extraContent;

  const GardenBedCard({
    super.key,
    required this.gardenBed,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    /// 🔍 1. Récupérer plantations et catalogue
    final allPlantings = ref.watch(plantingsListProvider);
    final plantsCatalog = ref.watch(plantsListProvider);

    /// 🔍 2. Trouver la plantation active (sans firstWhere)
    Planting? activePlanting;
    for (final p in allPlantings) {
      if (p.gardenBedId == gardenBed.id && p.isActive) {
        activePlanting = p;
        break;
      }
    }

    /// 🔍 3. Trouver la plante liée
    dynamic plant;
    if (activePlanting != null) {
      for (final pl in plantsCatalog) {
        if (pl.id == activePlanting!.plantId) {
          plant = pl;
          break;
        }
      }
    }

    /// 🔍 4. Trouver l’image dans metadata
    String? imagePath;
    if (plant != null && plant.metadata != null) {
      final meta = plant.metadata!;
      imagePath = meta['image'] ??
          meta['imagePath'] ??
          meta['photo'] ??
          meta['image_url'] ??
          meta['imageUrl'];
    }

    return CustomCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  /// 🖼 Image de la plante ou icône
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (imagePath != null)
                        ? Image.asset(
                            imagePath,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.grass,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                  ),

                  const SizedBox(width: 16),

                  /// 📝 Texte principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gardenBed.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${gardenBed.sizeInSquareMeters.toStringAsFixed(1)} m²",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),

                        /// 🌱 Culture active affichée
                        if (activePlanting != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            "${plant?.commonName ?? plant?.id ?? 'Culture'} — "
                            "Semé le ${activePlanting!.plantedDate.day}/${activePlanting!.plantedDate.month}",
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),

                  /// 🌾 Bouton récolte si culture active
                  if (activePlanting != null)
                    IconButton(
                      icon: const Icon(Icons.local_florist),
                      color: theme.colorScheme.primary,
                      onPressed: onEdit,
                    ),

                  /// ⋮ Menu contextuel
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) onEdit!();
                      if (value == 'delete' && onDelete != null) onDelete!();
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

              /// Contenu additionnel (germination preview)
              if (extraContent != null) ...[
                const SizedBox(height: 12),
                extraContent!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
