// lib/features/planting/presentation/screens/planting_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/planting.dart';
import '../../../../core/models/plant.dart';
import '../../../../core/models/activity_v3.dart';
import '../../../../core/providers/activity_tracker_v3_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../providers/planting_provider.dart';
import '../dialogs/create_planting_dialog.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../../shared/widgets/plant_lifecycle_widget.dart';

import '../widgets/planting_header_widget.dart';
import '../widgets/planting_info_widget.dart';
import '../widgets/planting_steps_widget.dart';

import '../../domain/plant_step.dart';
import '../../../../l10n/app_localizations.dart';

/// Écran principal de détail d'une plantation.
/// Orchestration : header + lifecycle + status + botanical info + steps + notes
class PlantingDetailScreen extends ConsumerWidget {
  final String plantingId;

  const PlantingDetailScreen({
    super.key,
    required this.plantingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantingAsync = ref.watch(plantingByIdProvider(plantingId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.planting_detail_title,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleAction(value, context, ref),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.common_edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.common_duplicate),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.common_delete, style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: plantingAsync.when(
        data: (planting) => planting != null
            ? _buildPlantingDetail(context, ref, planting, theme)
            : _buildNotFound(theme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(e.toString(), theme),
      ),
    );
  }

  Widget _buildPlantingDetail(
      BuildContext context, WidgetRef ref, Planting planting, ThemeData theme) {
    // Récupération catalogue plantes
    final plantCatalogState = ref.watch(plantCatalogProvider);

    // Si catalogue vide -> trigger load non-bloquant
    if (plantCatalogState.plants.isEmpty) {
      Future.microtask(
          () => ref.read(plantCatalogProvider.notifier).loadPlants());
    }

    // Recherche plant dans catalogue
    PlantFreezed? plant;
    try {
      plant =
          plantCatalogState.plants.firstWhere((p) => p.id == planting.plantId);
    } catch (_) {
      plant = null;
    }

    // Fallback recherche par nom (provider de recherche)
    if (plant == null ||
        (plant.scientificName.isEmpty && planting.plantName.isNotEmpty)) {
      final results = ref.read(plantSearchProvider(planting.plantName));
      if (results.isNotEmpty) plant = results.first;
    }

    // Dernier fallback : PlantFreezed minimal (garantit plant != null via plantSafe)
    final PlantFreezed plantSafe = plant ??
        PlantFreezed(
          id: planting.plantId,
          commonName: planting.plantName,
          scientificName: '',
          family: '',
          plantingSeason: '',
          harvestSeason: '',
          daysToMaturity: 0,
          spacing: 0,
          depth: 0.0,
          sunExposure: '',
          waterNeeds: '',
          description: '',
          sowingMonths: [],
          harvestMonths: [],
          culturalTips: [],
          biologicalControl: {},
          harvestTime: '',
          companionPlanting: {'beneficial': [], 'avoid': [], 'notes': ''},
          notificationSettings: {},
          varieties: {},
          metadata: {},
        );
    
    final plantJson = _normalizePlantFreezedJson(plantSafe.toJson());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        PlantingHeaderWidget(
            planting: planting, plant: plantSafe, theme: Theme.of(context)),

        const SizedBox(height: 12),

        // Croissance (remontée haut de page pour visibilité)
        PlantLifecycleWidget(
          plant: plantSafe,
          plantingDate: planting.plantedDate,
          initialProgressFromPlanting: (() {
            final dynamic _v = planting.metadata?['initialGrowthPercent'];
            if (_v is num) return _v.toDouble();
            if (_v is String) return double.tryParse(_v);
            return null;
          })(),
          plantingStatus: planting.status,
          showNextAction: false, // éviter doublon avec le pas-à-pas
        ),

        const SizedBox(height: 20),

        // Informations botaniques
        if (plantSafe.scientificName.isNotEmpty) ...[
          PlantingInfoWidget(plant: plantSafe, theme: theme),
          const SizedBox(height: 20),
        ],

        // PAS-À-PAS : instant UI handled locally in widget; onMarkDone logs Activity V3
        PlantingStepsWidget(
          plant: Plant.fromJson(plantJson),
          planting: planting,
          onAddCareAction: (String action) async {
            await ref.read(plantingProvider.notifier).addCareAction(
                  plantingId: planting.id,
                  actionType: action,
                  date: DateTime.now(),
                );
          },
          onMarkDone: (PlantStep step) async {
            // Fire-and-forget background task to persist + log activity + refresh activities
            Future.microtask(() async {
              try {
                // 1) Persist care action
                final actionLabel =
                    '${step.title} - ${DateTime.now().toIso8601String()}';
                await ref.read(plantingProvider.notifier).addCareAction(
                      plantingId: planting.id,
                      actionType: actionLabel,
                      date: DateTime.now(),
                    );

                // 2) Log to Activity V3
                final tracker = ref.read(activityTrackerV3Provider);
                if (!tracker.isInitialized) {
                  await tracker.initialize();
                }

                await tracker.trackActivity(
                  type: 'maintenanceCompleted',
                  description:
                      'Marqué fait: ${step.title} (${plantSafe.commonName})',
                  metadata: {
                    'plantingId': planting.id,
                    'plantId': plantSafe.id,
                    'stepId': step.id,
                    'stepCategory': step.category,
                  },
                  priority: ActivityPriority.normal,
                );

                // 3) Refresh recent activities (so dashboard shows it fast)
                try {
                  await ref.read(recentActivitiesProvider.notifier).refresh();
                } catch (_) {
                  // ignore refresh errors
                }
              } catch (e) {
                // Log and surface minimal feedback
                // ignore: avoid_print
                print('Erreur onMarkDone background task: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Erreur en enregistrant l\'action: $e')),
                  );
                }
              }
            });
          },
        ),

        const SizedBox(height: 20),

        // Notes
        if (planting.notes != null && planting.notes!.isNotEmpty)
          _buildNotes(planting, theme),
      ]),
    );
  }

  Widget _buildNotes(Planting planting, ThemeData theme) {
    return CustomCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Notes',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8)),
          child: Text(planting.notes!, style: theme.textTheme.bodyMedium),
        ),
      ]),
    );
  }

  // -------------------------
  // Dialogs and actions
  // -------------------------
  void _showCareActionDialog(
      Planting planting, BuildContext context, WidgetRef ref) {
    final TextEditingController actionController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter une action de soin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: actionController,
                decoration: const InputDecoration(
                    labelText: 'Action de soin', hintText: 'Ex: Arrosage'),
                maxLines: 2),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: Planting.commonCareActions
                  .map((a) => ActionChip(
                      label: Text(a),
                      onPressed: () => actionController.text = a))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              final text = actionController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(ctx).pop();
                ref.read(plantingProvider.notifier).addCareAction(
                    plantingId: planting.id,
                    actionType: text,
                    date: DateTime.now());
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(
      Planting planting, BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Changer le statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Planting.statusOptions
              .map((status) => ListTile(
                    title: Text(status),
                    leading: Radio<String>(
                      value: status,
                      groupValue: planting.status,
                      onChanged: (value) {
                        if (value != null) {
                          Navigator.of(ctx).pop();
                          _updatePlantingStatus(planting, value, context, ref);
                        }
                      },
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler'))
        ],
      ),
    );
  }

  void _harvestPlanting(
      Planting planting, BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Récolter la plantation'),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Confirmer la récolte de cette plantation ?'),
              const SizedBox(height: 12),
              Text('Date de récolte: ${_formatDate(DateTime.now())}',
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _updatePlantingStatus(planting, 'Récolté', context, ref,
                  actualHarvestDate: DateTime.now());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Récolter'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePlantingStatus(
      Planting planting, String newStatus, BuildContext context, WidgetRef ref,
      {DateTime? actualHarvestDate}) async {
    try {
      final updatedPlanting = planting.copyWith(
          status: newStatus, actualHarvestDate: actualHarvestDate);
      await ref.read(plantingProvider.notifier).updatePlanting(updatedPlanting);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Statut mis à jour: $newStatus'),
            backgroundColor: Colors.green));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // -------------------------
  // Small helpers + UI utils
  // -------------------------
  Widget _buildNotFound(ThemeData theme) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
        const SizedBox(height: 12),
        Text('Plantation non trouvée',
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        Text('Cette plantation n\'existe pas ou a été supprimée.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ]),
    );
  }

  Widget _buildError(String error, ThemeData theme) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red.withOpacity(0.5)),
        const SizedBox(height: 12),
        Text('Erreur de chargement',
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.red)),
        const SizedBox(height: 8),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(error,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center)),
      ]),
    );
  }

  void _handleAction(String action, BuildContext context, WidgetRef ref) {
    switch (action) {
      case 'edit':
        _editPlanting(context, ref);
        break;
      case 'duplicate':
        _duplicatePlanting(context, ref);
        break;
      case 'delete':
        _deletePlanting(context, ref);
        break;
    }
  }

  void _editPlanting(BuildContext context, WidgetRef ref) {
    final planting = ref.read(plantingByIdProvider(plantingId)).value;
    if (planting != null) {
      showDialog(
          context: context,
          builder: (_) => CreatePlantingDialog(
              gardenBedId: planting.gardenBedId, planting: planting));
    }
  }

  void _duplicatePlanting(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duplication - À implémenter')));
  }

  void _deletePlanting(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.planting_delete_title),
        content: Text(
            AppLocalizations.of(context)!.planting_delete_confirm_body),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.common_cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(plantingProvider.notifier)
                    .deletePlanting(plantingId);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Plantation supprimée avec succès'),
                      backgroundColor: Colors.green));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Erreur: $e'),
                      backgroundColor: Colors.red));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.common_delete),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Planté':
        return Colors.blue.withOpacity(0.12);
      case 'En croissance':
        return Colors.green.withOpacity(0.12);
      case 'Prêt à récolter':
        return Colors.orange.withOpacity(0.12);
      case 'Récolté':
        return Colors.green.withOpacity(0.12);
      case 'Échoué':
        return Colors.red.withOpacity(0.12);
      default:
        return theme.colorScheme.surfaceVariant;
    }
  }

  Color _getStatusTextColor(String status, ThemeData theme) {
    switch (status) {
      case 'Planté':
        return Colors.blue.shade700;
      case 'En croissance':
        return Colors.green.shade700;
      case 'Prêt à récolter':
        return Colors.orange.shade700;
      case 'Récolté':
        return Colors.green.shade800;
      case 'Échoué':
        return Colors.red.shade700;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Map<String, dynamic> _normalizePlantFreezedJson(Map<String, dynamic> j) {
    final out = Map<String, dynamic>.from(j);
    out['culturalTips'] = out['culturalTips'] ?? <String>[];
    out['sowingMonths'] = out['sowingMonths'] ?? <String>[];
    out['harvestMonths'] = out['harvestMonths'] ?? <String>[];
    out['companionPlanting'] = out['companionPlanting'] ??
        {'beneficial': <String>[], 'avoid': <String>[], 'notes': ''};
    out['notificationSettings'] =
        out['notificationSettings'] ?? <String, dynamic>{};
    return out;
  }
}
