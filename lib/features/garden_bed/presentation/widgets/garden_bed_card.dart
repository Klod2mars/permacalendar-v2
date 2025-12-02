// lib/features/garden_bed/presentation/widgets/garden_bed_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/models/garden_bed.dart';
import '../../../../core/models/planting.dart';
import '../../../../core/utils/planting_utils.dart';
import '../../../planting/providers/planting_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../shared/utils/plant_image_resolver.dart';

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

    // Providers pour réactivité
    final allPlantings = ref.watch(plantingsListProvider);
    final plantsCatalog = ref.watch(plantsListProvider);

    // Trouver la plantation active pour cette parcelle (la plus récente)
    Planting? activePlanting;
    for (final p in allPlantings) {
      if (p.gardenBedId == gardenBed.id && p.isActive) {
        activePlanting = p;
        break;
      }
    }

    // Trouver la plante liée dans le catalogue (si présente)
    dynamic plant;
    if (activePlanting != null) {
      for (final pl in plantsCatalog) {
        if (pl.id == activePlanting.plantId) {
          plant = pl;
          break;
        }
      }
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
                  // Image (vignette) ou icône - resolved via plant_image_resolver
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FutureBuilder<String?>(
                      future: findPlantImageAsset(plant),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container(
                            width: 64,
                            height: 64,
                            color: Colors.green.shade50,
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        final found = snapshot.data;
                        if (found != null) {
                          return Image.asset(
                            found,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildFallbackImage(
                                context,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover),
                          );
                        } else {
                          return _buildFallbackImage(context,
                              width: 64, height: 64, fit: BoxFit.cover);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texte principal + progression si présente
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
                        if (activePlanting != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            "${plant?.commonName ?? plant?.id ?? activePlanting.plantName} — Semé le ${activePlanting.plantedDate.day}/${activePlanting.plantedDate.month}",
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 6),
                          Builder(builder: (ctx) {
                            final progress =
                                computePlantingProgress(activePlanting!);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(value: progress),
                                const SizedBox(height: 6),
                                Text(
                                  '${(progress * 100).toStringAsFixed(0)}% vers début récolte',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                  // Bouton récolte (visible quand la plantation existe) :
                  if (activePlanting != null)
                    _buildHarvestOrEditButton(context, ref, activePlanting),
                  // Menu contextuel
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) onEdit!();
                      if (value == 'delete' && onDelete != null) onDelete!();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'edit', child: Text('Modifier')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Supprimer',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
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

  Widget _buildHarvestOrEditButton(
      BuildContext context, WidgetRef ref, Planting active) {
    final theme = Theme.of(context);
    final progress = computePlantingProgress(active);
    final bool inHarvestWindow = active.isInHarvestPeriod || progress >= 1.0;

    if (!inHarvestWindow) {
      // Afficher le bouton d'édition (existant)
      return IconButton(
        icon: const Icon(Icons.local_florist),
        color: theme.colorScheme.primary,
        onPressed: onEdit,
      );
    }

    // Afficher bouton récolte (vert) et ouvrir un dialogue pour enregistrer la récolte
    return IconButton(
      tooltip: 'Récolter',
      icon: const Icon(Icons.agriculture),
      color: Colors.green,
      onPressed: () => _showQuickHarvestDialog(context, ref, active),
    );
  }

  void _showQuickHarvestDialog(
      BuildContext context, WidgetRef ref, Planting planting) {
    final _quantityController = TextEditingController();
    final _notesController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text('Récolte: ${planting.plantName}'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: 'Quantité (optionnel)'),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty) {
                    final d = double.tryParse(v.trim().replaceAll(',', '.'));
                    if (d == null || d < 0) return 'Quantité invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration:
                    const InputDecoration(labelText: 'Notes (optionnel)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dctx).pop(),
              child: const Text('Annuler')),
          FilledButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final raw = _quantityController.text.trim();
              final double? qty = raw.isEmpty
                  ? null
                  : double.tryParse(raw.replaceAll(',', '.'));
              final notes = _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim();

              Navigator.of(dctx).pop();

              final success =
                  await ref.read(plantingProvider.notifier).recordHarvest(
                        planting.id,
                        DateTime.now(),
                        quantity: qty,
                        notes: notes,
                      );

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Récolte enregistrée')));
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Erreur lors de l\'enregistrement')));
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage(BuildContext ctx,
      {double width = 64, double height = 64, BoxFit fit = BoxFit.cover}) {
    return Image.asset(
      'assets/images/legumes/default.png',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Ultimate fallback: simple icon so we never throw at runtime when asset is missing.
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(Icons.eco,
              size: (width < height ? width : height) * 0.6,
              color: Theme.of(context).colorScheme.primary),
        );
      },
    );
  }
}
