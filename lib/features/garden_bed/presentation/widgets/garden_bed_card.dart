// lib/features/garden_bed/presentation/widgets/garden_bed_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/models/garden_bed.dart';
import '../../../../core/models/planting.dart';
import '../../../../core/utils/planting_utils.dart';
import '../../../planting/providers/planting_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../shared/utils/plant_image_resolver.dart';
import '../../../planting/presentation/widgets/harvest_dialog.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
      debugPrint('[GardenBedCard] Active planting: ${activePlanting.plantName}, Plant found: ${plant != null}, Plant ID: ${activePlanting.plantId}');
      if (plant != null) {
          debugPrint('[GardenBedCard] Plant metadata: ${plant.metadata}');
      } else {
          debugPrint('[GardenBedCard] WARNING: Plant not found in catalog for ID ${activePlanting.plantId}');
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
                    child: Builder(builder: (ctx) {
                       // 1. Try Local File first (Sync check)
                       final raw = _resolveImagePathFromPlant(plant);
                       if (raw != null && raw.isNotEmpty) {
                          debugPrint('[GardenBedCard] Resolving image for ${plant.commonName}: "$raw"'); 
                          final isNetwork = RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(raw);
                          final bool isLocalFile = !isNetwork && (raw.startsWith('/') || raw.startsWith('file:') || (raw.contains(Platform.pathSeparator) && raw.contains('.')));

                          if (isLocalFile) {
                              String path = raw;
                              if (path.startsWith('file://')) {
                                  path = path.substring(7);
                              }
                              final f = File(path);
                              debugPrint('[GardenBedCard] Trying local file: "$path" (exists: ${f.existsSync()})');
                              return Image.file(
                                f, 
                                width: 64, 
                                height: 64, 
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) {
                                    debugPrint('[GardenBedCard] Error loading file image $path: $err');
                                    return _buildFallbackImage(context, width:64, height:64);
                                }
                              );
                          }
                       }
                       
                       // 2. Fallback to Asset Resolver
                       return FutureBuilder<String?>(
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
                    );
                    }),
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
                            "${plant?.commonName ?? activePlanting.plantName} — ${l10n.bed_card_sown_on(activePlanting.plantedDate)}",
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
                                  '${(progress * 100).toStringAsFixed(0)}% ${l10n.bed_card_harvest_start}',
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
                    _buildHarvestOrEditButton(context, ref, activePlanting, l10n),
                  // Menu contextuel
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) onEdit!();
                      if (value == 'delete' && onDelete != null) onDelete!();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'edit', child: Text(l10n.garden_action_modify)),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.common_delete,
                            style: const TextStyle(color: Colors.red)),
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
      BuildContext context, WidgetRef ref, Planting active, AppLocalizations l10n) {
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
      tooltip: l10n.bed_action_harvest,
      icon: const Icon(Icons.agriculture),
      color: Colors.green,
      onPressed: () => _showQuickHarvestDialog(context, ref, active),
    );
  }

  void _showQuickHarvestDialog(
      BuildContext context, WidgetRef ref, Planting planting) {
    showHarvestDialog(context, ref, planting);
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
    String? _resolveImagePathFromPlant(dynamic plant) {
    if (plant == null) return null;
    try {
      final meta = plant.metadata;
      if (meta != null && meta is Map) {
        final candidates = [
          meta['image'],
          meta['imagePath'],
          meta['photo'],
          meta['image_url'],
          meta['imageUrl'],
        ];
        for (final c in candidates) {
          if (c is String && c.trim().isNotEmpty) return c.trim();
        }
      }
    } catch (_) {}
    return null;
  }
}
}
