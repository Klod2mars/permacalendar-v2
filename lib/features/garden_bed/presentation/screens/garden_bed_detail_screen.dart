// lib/features/garden_bed/presentation/screens/garden_bed_detail_screen.dart
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
import 'package:permacalendar/features/planting/presentation/widgets/planting_card.dart';
import 'package:permacalendar/features/planting/presentation/widgets/planting_preview.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Écran détail d'une parcelle : présente les informations de la parcelle
/// et la liste synthétique des plantations. Cette version reprend la logique
/// principale de l'original avec des helpers localisés.
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: gardenBed != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
              child: FloatingActionButton(
                tooltip: 'Ajouter une plantation',
                child: const Icon(Icons.add),
                onPressed: () async {
                  final bed = gardenBed; // safe
                  // Ouvre le catalogue en mode sélection
                  final selectedPlantId =
                      await Navigator.of(context).push<String?>(
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlantCatalogScreen(isSelectionMode: true),
                      fullscreenDialog: true,
                    ),
                  );
                  if (selectedPlantId == null) return;

                  // Récupérer la plante (si nécessaire)
                  List<PlantFreezed> plantList = ref.read(plantsListProvider);
                  PlantFreezed? plantObj;
                  try {
                    plantObj =
                        plantList.firstWhere((p) => p.id == selectedPlantId);
                  } catch (_) {
                    plantObj = null;
                  }
                  if (plantObj == null) {
                    await ref.read(plantCatalogProvider.notifier).loadPlants();
                    final reloaded = ref.read(plantsListProvider);
                    try {
                      plantObj =
                          reloaded.firstWhere((p) => p.id == selectedPlantId);
                    } catch (_) {
                      plantObj = null;
                    }
                  }

                  final preset = Planting(
                    gardenBedId: bed!.id,
                    plantId: selectedPlantId,
                    plantName: plantObj?.commonName ?? 'Plante',
                    plantedDate: DateTime.now(),
                    quantity: 1,
                    metadata: {'preset': true},
                  );

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
                          bottom: MediaQuery.of(ctx).viewInsets.bottom),
                      child: CreatePlantingDialog(
                          gardenBedId: bed.id, planting: preset),
                    ),
                  );

                  // Recharger les plantings de la parcelle
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
          // Carte résumé (réutilise GardenBedCard si souhaité) -- on affiche ici un CustomCard minimal.
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Surface',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  gardenBed.formattedSize,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ]),
                        ),
                        Icon(Icons.grid_view,
                            color: theme.colorScheme.primary, size: 26),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildSmallInfoChip(Icons.terrain,
                            '${gardenBed.soilType} (est.)', theme),
                        _buildSmallInfoChip(Icons.wb_sunny,
                            '${gardenBed.exposure} (variable)', theme),
                      ],
                    ),
                    if (gardenBed.description.isNotEmpty ||
                        (gardenBed.notes != null &&
                            gardenBed.notes!.isNotEmpty)) ...[
                      const SizedBox(height: 8),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: Text('Détails',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        children: [
                          if (gardenBed.description.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                child: _buildInfoRow(
                                    Icons.description,
                                    'Description',
                                    gardenBed.description,
                                    theme)),
                          if (gardenBed.notes != null &&
                              gardenBed.notes!.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                child: _buildInfoRow(Icons.note, 'Notes',
                                    gardenBed.notes!, theme)),
                        ],
                      ),
                    ]
                  ]),
            ),
          ),
          const SizedBox(height: 24),
          // Plantations actuelles
          _buildCurrentPlantings(context, ref, gardenBed, theme),
        ],
      ),
    );
  }

  Widget _buildSmallInfoChip(IconData icon, String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.08)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(text, style: theme.textTheme.bodySmall),
      ]),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, ThemeData theme) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 20, color: theme.colorScheme.primary),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontWeight: FontWeight.w500)),
          Text(value, style: theme.textTheme.bodyMedium),
        ]),
      ),
    ]);
  }

  Widget _buildCurrentPlantings(BuildContext context, WidgetRef ref,
      GardenBed gardenBed, ThemeData theme) {
    final plantingState = ref.watch(plantingProvider);
    final plantings = plantingState.plantings
        .where((planting) => planting.gardenBedId == gardenBed.id)
        .toList();
    final plants = ref.watch(plantsListProvider);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: Text('Plantations actuelles',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              if (plantings.length > 3)
                TextButton(
                    onPressed: () => context.push(
                        '/garden/${gardenBed.gardenId}/beds/${gardenBed.id}/plantings'),
                    child: const Text('Voir tout')),
            ],
          ),
          const SizedBox(height: 16),
          if (plantings.isEmpty)
            EmptyStateWidget(
              icon: Icons.eco,
              title: 'Aucune plantation',
              subtitle: 'Cette parcelle n\'a pas encore de plantations.',
              actionText: 'Ajouter une plantation',
              onAction: () async {
                // Reprend la logique d'ajout depuis le bouton FAB (simple duplication locale)
                final selectedPlantId =
                    await Navigator.of(context).push<String?>(
                  MaterialPageRoute(
                      builder: (_) =>
                          const PlantCatalogScreen(isSelectionMode: true),
                      fullscreenDialog: true),
                );
                if (selectedPlantId == null) return;
                // create minimal preset and show dialog
                final preset = Planting(
                    gardenBedId: gardenBed.id,
                    plantId: selectedPlantId,
                    plantName: selectedPlantId,
                    plantedDate: DateTime.now(),
                    quantity: 1,
                    metadata: {'preset': true});
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (ctx) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom),
                    child: CreatePlantingDialog(
                        gardenBedId: gardenBed.id, planting: preset),
                  ),
                );
                await ref
                    .read(plantingProvider.notifier)
                    .loadPlantings(gardenBed.id);
              },
            )
          else
            // ===== REPLACEMENT: compact visual previews (1 / 2–3 / 4+) =====
            Column(
              children: [
                if (plantings.length == 1) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: PlantingPreview(
                        planting: plantings.first,
                        onTap: () =>
                            context.push('/plantings/${plantings.first.id}'),
                        imageSize: 220,
                      ),
                    ),
                  ),
                ] else if (plantings.length <= 3) ...[
                  SizedBox(
                    height: 260,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      children: plantings
                          .map((p) => Padding(
                                padding: const EdgeInsets.only(right: 14.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PlantingPreview(
                                      planting: p,
                                      onTap: () =>
                                          context.push('/plantings/${p.id}'),
                                      imageSize: 180,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ] else ...[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.start,
                    children: plantings
                        .take(4)
                        .map((p) => PlantingPreview(
                              planting: p,
                              onTap: () => context.push('/plantings/${p.id}'),
                              imageSize: 160,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(
                          '/garden/${gardenBed.gardenId}/beds/${gardenBed.id}/plantings'),
                      child: const Text('Voir tout'),
                    ),
                  ),
                ],
              ],
            ),
        ]),
      ),
    );
  }
}

/// Cherche dans l'AssetManifest les chemins candidats pour la plante.
/// Retourne :
/// - une URL réseau (si metadata contient une URL) OU
/// - le chemin d'asset exact (si trouvé) OU
/// - null si aucun asset/URL trouvé.
Future<String?> _findExistingAssetForPlant(PlantFreezed plant) async {
  try {
    // 1) Si metadata contient une URL (http/https), on la renvoie directement.
    final meta = plant.metadata;
    if (meta != null) {
      final metaCandidates = [
        meta['image'],
        meta['imagePath'],
        meta['photo'],
        meta['image_url'],
        meta['imageUrl'],
        meta['photoUrl']
      ];
      for (final c in metaCandidates) {
        if (c is String && c.trim().isNotEmpty) {
          final raw = c.trim();
          if (RegExp(r'^(http|https):\/\/', caseSensitive: false)
              .hasMatch(raw)) {
            return raw;
          }
          if (raw.startsWith('assets/')) {
            return raw;
          }
          // sinon on garde en tant que base candidate plus bas
          break;
        }
      }
    }

    // 2) Construire une liste de candidats plausibles (legumes / plants / id / commonName)
    final cn = plant.commonName ?? '';
    final id = plant.id ?? '';
    final bases = <String>{};

    if (cn.isNotEmpty) {
      bases.add(cn); // nom tel quel (ex: "Betterave")
      bases.add(cn.toLowerCase());
      bases.add(_toFilenameSafe(cn));
      bases.add(_toFilenameSafe(cn).replaceAll('_', '-'));
    }
    if (id.isNotEmpty) {
      bases.add(id);
      bases.add(id.toLowerCase());
    }

    final exts = ['.png', '.jpg', '.jpeg', '.webp'];

    final candidatePaths = <String>[];
    for (final b in bases) {
      for (final e in exts) {
        candidatePaths.add('assets/images/legumes/$b$e');
        candidatePaths.add('assets/images/plants/$b$e');
        candidatePaths.add('assets/images/$b$e');
        candidatePaths.add('assets/$b$e');
      }
    }

    // 3) Charger AssetManifest et tester rapidement la présence
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final keys = manifestMap.keys.toList();

      // Vérifier égalité directe d'abord (fast path)
      for (final candidate in candidatePaths) {
        if (keys.contains(candidate)) return candidate;
      }

      // Puis vérifier en fin de chaîne (cas où Assets sont préfixés)
      final lowerKeys = keys.map((k) => k.toLowerCase()).toList();
      for (final candidate in candidatePaths) {
        final lc = candidate.toLowerCase();
        for (final k in lowerKeys) {
          if (k.endsWith(lc)) {
            // retrouver la clé originale (sensible à la casse)
            final index = lowerKeys.indexOf(k);
            return keys[index];
          }
        }
      }
    } catch (_) {
      // Si AssetManifest indisponible (rare), on ignore et on essaie un dernier fallback
    }

    // 4) Fallback heuristique : retourner le chemin le plus probable (non garanti)
    if (id.isNotEmpty) return 'assets/images/legumes/${id.toLowerCase()}.png';
    if (cn.isNotEmpty) return 'assets/images/legumes/${cn.toLowerCase()}.png';

    return null;
  } catch (_) {
    return null;
  }
}

/// Simplified filename-safe helper (retire ponctuation et remplace espaces par _)
String _toFilenameSafe(String s) {
  var out = s.trim();
  out = out.replaceAll(RegExp(r'[^\w\s\-]'), '');
  out = out.replaceAll(RegExp(r'\s+'), '_');
  return out;
}
