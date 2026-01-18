// lib/features/garden_bed/presentation/screens/garden_bed_detail_screen.dart
import 'dart:convert';

import '../../../planting/presentation/widgets/harvest_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import '../../../plant_catalog/presentation/screens/plant_catalog_screen.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../planting/presentation/dialogs/create_planting_dialog.dart';
import '../../../../core/models/garden_bed.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../providers/garden_bed_provider.dart';
import '../../providers/garden_bed_scoped_provider.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/planting/presentation/widgets/planting_card.dart';
import 'package:permacalendar/features/planting/presentation/widgets/planting_preview.dart';

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
    // Use scoped provider for detail to avoid global state syncing issues
    final gardenBedAsync =
        ref.watch(gardenBedDetailProvider((gardenId: gardenId, bedId: bedId)));
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // No need for imperative loading or checking global state

    return Scaffold(
      appBar: CustomAppBar(
        title: gardenBedAsync.asData?.value?.name ?? 'Détail de la parcelle',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onPop ?? () => context.pop(),
        ),
      ),
      body: gardenBedAsync.when(
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => ErrorStateWidget(
          title: l10n.garden_detail_title_error,
          subtitle: error.toString(),
          onRetry: () => ref.refresh(
              gardenBedDetailProvider((gardenId: gardenId, bedId: bedId))),
        ),
        data: (gardenBed) {
          if (gardenBed == null) {
            return EmptyStateWidget(
              icon: Icons.grid_view,
              title: 'Parcelle non trouvée', // TODO: Add localization key if needed
              subtitle: 'Cette parcelle n\'existe pas ou a été supprimée.', // TODO: Add localization key
            );
          }
          return _buildGardenBedDetail(context, ref, gardenBed, theme, l10n);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: gardenBedAsync.asData?.value != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
              child: FloatingActionButton(
                tooltip: l10n.bed_detail_add_planting,
                child: const Icon(Icons.add),
                onPressed: () async {
                  final bed = gardenBedAsync.asData!.value!; // safe
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
                    gardenBedId: bed.id,
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
      GardenBed gardenBed, ThemeData theme, AppLocalizations l10n) {
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
                                  l10n.bed_detail_surface,
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
                    if (gardenBed.description.isNotEmpty ||
                        (gardenBed.notes != null &&
                            gardenBed.notes!.isNotEmpty)) ...[
                      const SizedBox(height: 8),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: Text(l10n.bed_detail_details,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        children: [
                          if (gardenBed.description.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                child: _buildInfoRow(
                                    Icons.description,
                                    l10n.bed_form_desc_label,
                                    gardenBed.description,
                                    theme)),
                          if (gardenBed.notes != null &&
                              gardenBed.notes!.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                child: _buildInfoRow(Icons.note, l10n.bed_detail_notes,
                                    gardenBed.notes!, theme)),
                        ],
                      ),
                    ]
                  ]),
            ),
          ),
          const SizedBox(height: 24),
          // Plantations actuelles
          _buildCurrentPlantings(context, ref, gardenBed, theme, l10n),
        ],
      ),
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
      GardenBed gardenBed, ThemeData theme, AppLocalizations l10n) {
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
                child: Text(l10n.bed_detail_current_plantings,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              // "Voir tout" removed as requested for simple scroll
            ],
          ),
          const SizedBox(height: 16),
          if (plantings.isEmpty)
            EmptyStateWidget(
              icon: Icons.eco,
              title: l10n.bed_detail_no_plantings_title,
              subtitle: l10n.bed_detail_no_plantings_desc,
              actionText: l10n.bed_detail_add_planting,
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
            // Unified Vertical List
            Column(
              children: plantings.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Builder(builder: (ctx) {
                    return SizedBox(
                      width: double.infinity,
                      child: PlantingCard(
                        planting: p,
                        onTap: () => context.push('/plantings/${p.id}'),
                        onHarvest: () => showHarvestDialog(context, ref, p),
                        onDelete: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(l10n.bed_delete_planting_confirm_title),
                            content: Text(
                                l10n.bed_delete_planting_confirm_body),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(l10n.common_cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await ref
                                      .read(plantingProvider.notifier)
                                      .deletePlanting(p.id);
                                  // Refresh header / plantings
                                  ref
                                      .read(gardenBedNotifierProvider.notifier)
                                      .loadGardenBeds(gardenBed.gardenId);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                                child: Text(l10n.common_delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }).toList(),
            ),
        ]),
      ),
    );
  }
} // end of class GardenBedDetailScreen

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
