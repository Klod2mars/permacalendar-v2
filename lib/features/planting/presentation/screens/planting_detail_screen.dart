import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/planting.dart';

import '../../../../shared/widgets/custom_app_bar.dart';

import '../../../../shared/widgets/custom_card.dart';

import '../../providers/planting_provider.dart';

import '../dialogs/create_planting_dialog.dart';

import '../../../plant_catalog/providers/plant_catalog_provider.dart';

import '../../../plant_catalog/domain/entities/plant_entity.dart';

import '../../../plant_intelligence/presentation/widgets/plant_health_degradation_banner.dart';
import '../../../../shared/widgets/plant_lifecycle_widget.dart';

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
        title: 'Détails de la plantation',
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleAction(value, context, ref),
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
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Dupliquer'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: plantingAsync.when(
        data: (planting) => planting != null
            ? _buildPlantingDetail(planting, theme, ref, context)
            : _buildNotFound(theme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(error.toString(), theme),
      ),
    );
  }

  Widget _buildPlantingDetail(
      Planting planting, ThemeData theme, WidgetRef ref, BuildContext context) {
    // Récupérer les informations de la plante depuis le catalogue

    final plantCatalogState = ref.watch(plantCatalogProvider);

    // Si le catalogue est vide (pas encore chargé), demander un load (non bloquant)
    if (plantCatalogState.plants.isEmpty) {
      // lancement hors-build, évite d'appeler loadPlants pendant le build sync
      Future.microtask(
          () => ref.read(plantCatalogProvider.notifier).loadPlants());
    }

    // 1) essayer de récupérer par ID (catalogue actuel)
    PlantFreezed? plant;
    try {
      plant =
          plantCatalogState.plants.firstWhere((p) => p.id == planting.plantId);
    } catch (_) {
      plant = null;
    }

    // 2) fallback : recherche par nom (synchrone via le provider de recherche)
    if (plant == null ||
        (plant.scientificName.isEmpty && planting.plantName.isNotEmpty)) {
      final results = ref.read(plantSearchProvider(planting.plantName));
      if (results.isNotEmpty) plant = results.first;
    }

    // 3) ultime fallback : construire un PlantFreezed minimal mais complet
    plant ??= PlantFreezed(
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // âœ… CURSOR PROMPT A9 - Health Degradation Banner (Conditional)

          PlantHealthDegradationBanner(
            plantId: planting.plantId,
            plantName: planting.plantName,
          ),

          // Header with plant info

          _buildHeader(planting, plant, theme),

          const SizedBox(height: 24),

          // Status and progress

          _buildStatusSection(planting, theme, context, ref),

          const SizedBox(height: 24),

          // Plant information from catalog

          if (plant.scientificName.isNotEmpty)
            _buildPlantCatalogInfo(plant, theme, context),

          const SizedBox(height: 24),

          // Care recommendations

          _buildCareRecommendations(planting, plant, theme),

          const SizedBox(height: 24),

          // Planting information

          _buildPlantingInfo(planting, theme),

          const SizedBox(height: 24),

          // Care actions

          _buildCareEtapes(planting, theme, ref, context),

          const SizedBox(height: 24),

          // Timeline

          PlantLifecycleWidget(
            plant: plant,
            plantingDate: planting.plantedDate,
            initialProgressFromPlanting: (() {
              final dynamic _v = planting.metadata?['initialGrowthPercent'];
              if (_v is num) return _v.toDouble();
              if (_v is String) return double.tryParse(_v);
              return null;
            })(),
            plantingStatus: planting.status,
          ),

          const SizedBox(height: 24),

          // Notes

          if (planting.notes != null && planting.notes!.isNotEmpty)
            _buildNotes(planting, theme),
        ],
      ),
    );
  }

  Widget _buildCareEtapes(
      Planting planting, ThemeData theme, WidgetRef ref, BuildContext context) {
    final plantingNotifier = ref.read(plantingProvider.notifier);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header : titre + bouton "Ajouter"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Étapes (${planting.careActions.length})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final TextEditingController controller =
                        TextEditingController();
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text('Ajouter étape'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: Planting.commonCareActions.map((a) {
                                    return ListTile(
                                      title: Text(a),
                                      onTap: () async {
                                        Navigator.of(dialogCtx).pop();
                                        await plantingNotifier.addCareAction(
                                          plantingId: planting.id,
                                          actionType: a,
                                          date: DateTime.now(),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              const Divider(),
                              TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'Autre étape',
                                  hintText: 'Ex: Paillage léger',
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(dialogCtx).pop(),
                              child: const Text('Annuler')),
                          ElevatedButton(
                            onPressed: () async {
                              final text = controller.text.trim();
                              if (text.isNotEmpty) {
                                Navigator.of(dialogCtx).pop();
                                await plantingNotifier.addCareAction(
                                  plantingId: planting.id,
                                  actionType: text,
                                  date: DateTime.now(),
                                );
                              }
                            },
                            child: const Text('Ajouter'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.add, color: theme.colorScheme.primary),
                  label: Text('Ajouter',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Contenu : vide ou liste compacte
            if (planting.careActions.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.02),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.flag,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant
                            .withOpacity(0.5)),
                    const SizedBox(height: 8),
                    Text(
                      'Aucune étape enregistrée',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.7)),
                    ),
                  ],
                ),
              )
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: planting.careActions.take(5).map((action) {
                  final label = action.split(' - ').first;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.secondaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag,
                            size: 16,
                            color: theme.colorScheme.onSecondaryContainer),
                        const SizedBox(width: 6),
                        Text(label,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (planting.careActions.length > 5) ...[
                const SizedBox(height: 8),
                Text(
                  '+${planting.careActions.length - 5} autres...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ]
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCatalogInfo(
      PlantFreezed plant, ThemeData theme, BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations botaniques',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (plant.description.isNotEmpty) ...[
            Text(
              plant.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
          ],

          // Caractéristiques de culture

          _buildInfoGrid([
            if (plant.daysToMaturity > 0)
              _InfoItem(
                  'Maturité', '${plant.daysToMaturity} jours', Icons.schedule),
            if (plant.spacing > 0)
              _InfoItem('Espacement', '${plant.spacing} cm', Icons.straighten),
            if (plant.depth > 0)
              _InfoItem('Profondeur', '${plant.depth} cm',
                  Icons.vertical_align_bottom),
            if (plant.sunExposure.isNotEmpty)
              _InfoItem('Exposition', plant.sunExposure, Icons.wb_sunny),
            if (plant.waterNeeds.isNotEmpty)
              _InfoItem('Arrosage', plant.waterNeeds, Icons.water_drop),
            if (plant.plantingSeason.isNotEmpty)
              _InfoItem('Saison plantation', plant.plantingSeason,
                  Icons.calendar_today),
          ], theme, context),

          // Conseils culturaux

          if (plant.culturalTips != null && plant.culturalTips!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Conseils de culture',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...plant.culturalTips!.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildCareRecommendations(
      Planting planting, PlantFreezed plant, ThemeData theme) {
    final now = DateTime.now();

    final daysSincePlanting = now.difference(planting.plantedDate).inDays;

    final recommendations = <String>[];

    // Recommandations basées sur l'âge de la plantation

    if (daysSincePlanting < 7) {
      recommendations
          .add('Maintenir le sol humide pour favoriser la germination');

      recommendations
          .add('Protéger des vents forts et du soleil direct intense');
    } else if (daysSincePlanting < 30) {
      recommendations
          .add('Surveiller l\'apparition des premières vraies feuilles');

      recommendations.add('Commencer un arrosage régulier mais modéré');

      if (plant.thinning != null) {
        recommendations.add('Préparer l\'éclaircissement si nécessaire');
      }
    } else if (daysSincePlanting < plant.daysToMaturity * 0.7) {
      recommendations
          .add('Phase de croissance active - maintenir un arrosage régulier');

      recommendations.add('Surveiller les signes de maladies ou parasites');

      if (plant.weeding != null) {
        recommendations.add('Effectuer un désherbage régulier');
      }
    } else {
      recommendations
          .add('Approche de la maturité - surveiller les signes de récolte');

      recommendations.add('Réduire progressivement l\'arrosage');
    }

    // Recommandations saisonnières

    final currentMonth = now.month;

    if (currentMonth >= 6 && currentMonth <= 8) {
      // Été

      recommendations
          .add('Période estivale - arroser de préférence le matin ou le soir');

      recommendations.add('Pailler pour conserver l\'humidité');
    } else if (currentMonth >= 9 && currentMonth <= 11) {
      // Automne

      recommendations
          .add('Période automnale - réduire la fréquence d\'arrosage');

      recommendations.add('Préparer la protection hivernale si nécessaire');
    }

    if (recommendations.isEmpty) {
      recommendations
          .add('Continuer les soins habituels selon les besoins de la plante');
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Recommandations de soins',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Jour ${daysSincePlanting + 1} après plantation',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...recommendations.map((rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rec,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(
      List<_InfoItem> items, ThemeData theme, BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: items
          .map((item) => SizedBox(
                width:
                    (MediaQuery.of(context).size.width - 80) / 2, // 2 colonnes

                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            item.value,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStatusSection(
      Planting planting, ThemeData theme, BuildContext context, WidgetRef ref) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statut et progression',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Status badge

          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(planting.status, theme),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  planting.status,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _getStatusTextColor(planting.status, theme),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // Progress indicator for growing plants

          if (planting.status == 'Planté' &&
              planting.expectedHarvestStartDate != null) ...[
            const SizedBox(height: 16),
            _buildProgressIndicator(planting, theme),
          ],

          // Quick actions

          const SizedBox(height: 16),

          _buildQuickActions(planting, theme, context, ref),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(Planting planting, ThemeData theme) {
    final now = DateTime.now();

    final totalDays = planting.expectedHarvestStartDate!
        .difference(planting.plantedDate)
        .inDays;

    final elapsedDays = now.difference(planting.plantedDate).inDays;

    final progress =
        totalDays > 0 ? (elapsedDays / totalDays).clamp(0.0, 1.0) : 0.0;

    final remainingDays = totalDays - elapsedDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression de croissance',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          remainingDays > 0
              ? '$remainingDays jours restants jusqu\'à la récolte prévue'
              : progress >= 1.0
                  ? 'Prêt à récolter!'
                  : 'Date de récolte dépassée',
          style: theme.textTheme.bodySmall?.copyWith(
            color: remainingDays <= 0 && progress >= 1.0
                ? Colors.green
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
      Planting planting, ThemeData theme, BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (planting.status != 'Récolté' && planting.status != 'Échoué') ...[
          _buildActionChip(
            'Changer statut',
            Icons.update,
            () => _showStatusChangeDialog(planting, context, ref),
            theme,
          ),
          if (planting.status == 'Prêt à récolter')
            _buildActionChip(
              'Récolter',
              Icons.agriculture,
              () => _harvestPlanting(planting, context, ref),
              theme,
              color: Colors.green,
            ),
          _buildActionChip(
            'Ajouter soin',
            Icons.healing,
            () => _showCareActionDialog(planting, context, ref),
            theme,
          ),
        ],
      ],
    );
  }

  Widget _buildActionChip(
      String label, IconData icon, VoidCallback onTap, ThemeData theme,
      {Color? color}) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
      onPressed: onTap,
      backgroundColor: color?.withOpacity(0.1) ??
          theme.colorScheme.secondaryContainer.withOpacity(0.5),
      labelStyle: TextStyle(
        color: color ?? theme.colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildPlantingInfo(Planting planting, ThemeData theme) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de plantation',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Date de plantation', _formatDate(planting.plantedDate),
              Icons.calendar_today, theme),
          if (planting.expectedHarvestStartDate != null)
            _buildInfoRow(
                'Début de récolte',
                _formatDate(planting.expectedHarvestStartDate!),
                Icons.schedule,
                theme),
          if (planting.expectedHarvestEndDate != null)
            _buildInfoRow(
                'Fin de récolte',
                _formatDate(planting.expectedHarvestEndDate!),
                Icons.schedule,
                theme),
          if (planting.actualHarvestDate != null)
            _buildInfoRow(
                'Récolté le',
                _formatDate(planting.actualHarvestDate!),
                Icons.agriculture,
                theme),
          _buildInfoRow(
              'Quantité', '${planting.quantity} plants', Icons.numbers, theme),
          _buildInfoRow('Créé le', _formatDate(planting.createdAt),
              Icons.add_circle_outline, theme),
          if (planting.updatedAt != planting.createdAt)
            _buildInfoRow('Modifié le', _formatDate(planting.updatedAt),
                Icons.edit, theme),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label, String value, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
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
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareActions(
      Planting planting, ThemeData theme, WidgetRef ref, BuildContext context) {
    final plantingNotifier = ref.read(plantingProvider.notifier);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header : titre + bouton "Ajouter"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Étapes (${planting.careActions.length})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      _showAddStepDialog(context, planting, plantingNotifier),
                  icon: Icon(Icons.add, color: theme.colorScheme.primary),
                  label: Text('Ajouter',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Contenu : soit liste compacte, soit état vide
            if (planting.careActions.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.02),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.flag,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant
                            .withOpacity(0.5)),
                    const SizedBox(height: 8),
                    Text(
                      'Aucune étape enregistrée',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.7)),
                    ),
                  ],
                ),
              )
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: planting.careActions.map((action) {
                  final label = action.split(' - ').first;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.secondaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag,
                            size: 16,
                            color: theme.colorScheme.onSecondaryContainer),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (planting.careActions.length > 5) ...[
                const SizedBox(height: 8),
                Text(
                  '+${planting.careActions.length - 5} autres...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ]
            ],
          ],
        ),
      ),
    );
  }

// Dialog simple pour ajouter une étape (appel au provider qui existe : addCareAction)
  void _showAddStepDialog(
      BuildContext context, Planting planting, dynamic plantingNotifier) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter étape'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Liste rapide d'actions communes
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: Planting.commonCareActions.map((a) {
                    return ListTile(
                      title: Text(a),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await plantingNotifier.addCareAction(
                          plantingId: planting.id,
                          actionType: a,
                          date: DateTime.now(),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Autre étape',
                  hintText: 'Ex: Paillage léger',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop();
                await plantingNotifier.addCareAction(
                  plantingId: planting.id,
                  actionType: text,
                  date: DateTime.now(),
                );
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(Planting planting, ThemeData theme, WidgetRef ref) {
    final plantCatalogState = ref.watch(plantCatalogProvider);

    final plant = plantCatalogState.plants.firstWhere(
      (p) => p.id == planting.plantId,
      orElse: () => PlantFreezed(
        id: planting.plantId,
        commonName: planting.plantName,
        scientificName: '',
        family: '',
        description: '',
        plantingSeason: '',
        harvestSeason: '',
        daysToMaturity: 0,
        spacing: 0,
        depth: 0.0,
        sunExposure: '',
        waterNeeds: '',
        sowingMonths: [],
        harvestMonths: [],
      ),
    );

    final events = <Map<String, dynamic>>[
      {
        'date': planting.createdAt,
        'title': 'Plantation Créée',
        'description': 'Enregistrement de la plantation dans le système',
        'icon': Icons.add_circle,
        'color': theme.colorScheme.primary,
        'completed': true,
      },
      {
        'date': planting.plantedDate,
        'title': 'Plantation effectuée',
        'description': 'Mise en terre des plants',
        'icon': Icons.eco,
        'color': Colors.green,
        'completed': true,
      },
    ];

    // Ajouter les étapes prédictives basées sur les données de la plante

    final now = DateTime.now();

    final daysSincePlanting = now.difference(planting.plantedDate).inDays;

    // Germination (estimée à 7-14 jours)

    final germinationDate = planting.plantedDate.add(const Duration(days: 10));

    events.add({
      'date': germinationDate,
      'title': 'Germination attendue',
      'description': 'Apparition des premières pousses',
      'icon': Icons.grass,
      'color': Colors.lightGreen,
      'completed': daysSincePlanting >= 10,
      'predicted': true,
    });

    // Première vraie feuille (estimée à 2-3 semaines)

    final firstLeavesDate = planting.plantedDate.add(const Duration(days: 20));

    events.add({
      'date': firstLeavesDate,
      'title': 'Premières vraies feuilles',
      'description': 'Développement des feuilles définitives',
      'icon': Icons.local_florist,
      'color': Colors.green.shade600,
      'completed': daysSincePlanting >= 20,
      'predicted': true,
    });

    // Éclaircissement si nécessaire (basé sur les données de la plante)

    if (plant.thinning != null && plant.spacing > 0) {
      final thinningDate = planting.plantedDate.add(const Duration(days: 30));

      events.add({
        'date': thinningDate,
        'title': 'Éclaircissement recommandé',
        'description': 'Espacement optimal: ${plant.spacing}cm',
        'icon': Icons.content_cut,
        'color': Colors.orange.shade600,
        'completed': daysSincePlanting >= 30,
        'predicted': true,
      });
    }

    // Floraison (estimée à 50% du cycle)

    if (plant.daysToMaturity > 0) {
      final floweringDate = planting.plantedDate
          .add(Duration(days: (plant.daysToMaturity * 0.5).round()));

      events.add({
        'date': floweringDate,
        'title': 'Floraison attendue',
        'description': 'Apparition des fleurs',
        'icon': Icons.local_florist,
        'color': Colors.pink.shade400,
        'completed': daysSincePlanting >= (plant.daysToMaturity * 0.5).round(),
        'predicted': true,
      });
    }

    // Période de récolte prévue

    if (planting.expectedHarvestStartDate != null) {
      events.add({
        'date': planting.expectedHarvestStartDate!,
        'title': 'Début de récolte',
        'description': 'Début de la période de récolte prévue',
        'icon': Icons.schedule,
        'color': Colors.orange,
        'completed': false,
        'predicted': true,
      });
    }

    // Récolte effectuée

    if (planting.actualHarvestDate != null) {
      events.add({
        'date': planting.actualHarvestDate!,
        'title': 'Récolte effectuée',
        'description': 'Plantation récoltée avec succès',
        'icon': Icons.agriculture,
        'color': Colors.green.shade700,
        'completed': true,
      });
    }

    // Trier les événements par date

    events.sort(
        (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chronologie',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...events.asMap().entries.map((entry) {
            final index = entry.key;

            final event = entry.value;

            final isLast = index == events.length - 1;

            return _buildTimelineItem(
              event['date'] as DateTime,
              event['title'] as String,
              event['description'] as String,
              event['icon'] as IconData,
              event['color'] as Color,
              event['completed'] as bool,
              event['predicted'] as bool? ?? false,
              isLast,
              theme,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      DateTime date,
      String title,
      String description,
      IconData icon,
      Color color,
      bool completed,
      bool predicted,
      bool isLast,
      ThemeData theme) {
    final now = DateTime.now();

    final isToday =
        date.day == now.day && date.month == now.month && date.year == now.year;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator

        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: completed
                    ? color.withOpacity(0.2)
                    : predicted
                        ? color.withOpacity(0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: completed
                      ? color
                      : predicted
                          ? color.withOpacity(0.5)
                          : theme.colorScheme.outline,
                  width: completed ? 2 : 1,
                ),
              ),
              child: Icon(
                completed ? Icons.check : icon,
                color: completed
                    ? color
                    : predicted
                        ? Color.fromRGBO(
                            color.red, color.green, color.blue, 0.7)
                        : theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Color.fromRGBO(
                  theme.colorScheme.outline.red,
                  theme.colorScheme.outline.green,
                  theme.colorScheme.outline.blue,
                  0.3,
                ),
              ),
          ],
        ),

        const SizedBox(width: 16),

        // Event content

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              completed ? FontWeight.w600 : FontWeight.w500,
                          color: completed
                              ? theme.colorScheme.onSurface
                              : predicted
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (predicted && !completed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Prédiction',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.blue.shade700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Aujourd\'hui',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.orange.shade700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotes(Planting planting, ThemeData theme) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              planting.notes!,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFound(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Plantation non trouvée',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cette plantation n\'existe pas ou a été supprimée.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Planté':
        return Colors.blue.withOpacity(0.2);

      case 'En croissance':
        return Colors.green.withOpacity(0.2);

      case 'Prêt à récolter':
        return Colors.orange.withOpacity(0.2);

      case 'Récolté':
        return Colors.green.withOpacity(0.3);

      case 'Échoué':
        return Colors.red.withOpacity(0.2);

      default:
        return theme.colorScheme.surfaceContainerHighest;
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
        builder: (context) => CreatePlantingDialog(
          gardenBedId: planting.gardenBedId,
          planting: planting,
        ),
      );
    }
  }

  void _duplicatePlanting(BuildContext context, WidgetRef ref) {
    // TODO: Implement duplication logic

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Duplication - À implémenter'),
      ),
    );
  }

  void _deletePlanting(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la plantation'),
        content: const Text(
            'ÃŠtes-vous sûr de vouloir supprimer cette plantation ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                await ref
                    .read(plantingProvider.notifier)
                    .deletePlanting(plantingId);

                if (context.mounted) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Plantation supprimée avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(
      Planting planting, BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Planting.statusOptions.map((status) {
            return ListTile(
              title: Text(status),
              leading: Radio<String>(
                value: status,
                groupValue: planting.status,
                onChanged: (value) {
                  if (value != null) {
                    Navigator.of(context).pop();

                    _updatePlantingStatus(planting, value, context, ref);
                  }
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _harvestPlanting(
      Planting planting, BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Récolter la plantation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Confirmer la récolte de cette plantation ?'),
            const SizedBox(height: 16),
            Text(
              'Date de récolte: ${_formatDate(DateTime.now())}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              _updatePlantingStatus(planting, 'Récolté', context, ref,
                  actualHarvestDate: DateTime.now());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Récolter'),
          ),
        ],
      ),
    );
  }

  void _showCareActionDialog(
      Planting planting, BuildContext context, WidgetRef ref) {
    final TextEditingController actionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une action de soin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: actionController,
              decoration: const InputDecoration(
                labelText: 'Action de soin',
                hintText: 'Ex: Arrosage, Taille, Fertilisation...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            // Actions prédéfinies

            Wrap(
              spacing: 8,
              children: [
                'Arrosage',
                'Fertilisation',
                'Taille',
                'Désherbage',
                'Traitement',
                'Paillage',
              ]
                  .map((action) => ActionChip(
                        label: Text(action),
                        onPressed: () {
                          actionController.text = action;
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (actionController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();

                _addCareAction(
                    planting, actionController.text.trim(), context, ref);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _updatePlantingStatus(
      Planting planting, String newStatus, BuildContext context, WidgetRef ref,
      {DateTime? actualHarvestDate}) async {
    try {
      final updatedPlanting = planting.copyWith(
        status: newStatus,
        actualHarvestDate: actualHarvestDate,
      );

      await ref.read(plantingProvider.notifier).updatePlanting(updatedPlanting);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Statut mis à jour: $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addCareAction(Planting planting, String action, BuildContext context,
      WidgetRef ref) async {
    try {
      final updatedCareActions = List<String>.from(planting.careActions)
        ..add(action);

      final updatedPlanting = planting.copyWith(
        careActions: updatedCareActions,
      );

      await ref.read(plantingProvider.notifier).updatePlanting(updatedPlanting);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Action ajoutée: $action'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Classe helper pour les informations affichées dans la grille

class _InfoItem {
  final String label;

  final String value;

  final IconData icon;

  const _InfoItem(this.label, this.value, this.icon);
}
