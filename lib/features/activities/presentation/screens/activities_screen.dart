import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/activity_tracker_v3_provider.dart';
import '../../../../core/models/activity_v3.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../garden/providers/garden_provider.dart';
import '../widgets/garden_history_widget.dart';
import '../../../../core/providers/garden_aggregation_providers.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../widgets/history_hint_card.dart';
import '../../../../l10n/app_localizations.dart';

/// Écran pour afficher toutes les activités
class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final gardenState = ref.watch(gardenProvider);
    final  currentGardenId = gardenState.selectedGarden?.id ?? (gardenState.gardens.isNotEmpty ? gardenState.gardens.first.id : '');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.activity_screen_title),
          bottom: TabBar(
            tabs: [
              Tab(text: gardenState.selectedGarden != null 
                  ? l10n.activity_tab_recent_garden(gardenState.selectedGarden!.name) 
                  : l10n.activity_tab_recent_global),
              Tab(text: l10n.activity_tab_history),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(recentActivitiesProvider.notifier).refresh();
                if (currentGardenId.isNotEmpty) {
                   ref.read(invalidateGardenCacheProvider(currentGardenId));
                }
              },
              icon: const Icon(Icons.refresh),
              tooltip: l10n.common_refresh,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Onglet 1: Activités Récentes (Existing logic)
            _buildRecentActivitiesTab(theme, currentGardenId),
            
            // Onglet 2: Historique (New Widget)
            gardenState.selectedGarden != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Row(
                          children: [
                            Text(l10n.activity_history_section_title,
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            Expanded(
                              child: Text(
                                gardenState.selectedGarden!.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: GardenHistoryWidget(
                              gardenId: gardenState.selectedGarden!.id)),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        l10n.activity_history_empty,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitiesTab(ThemeData theme, String currentGardenId) {
    final activitiesAsync = ref.watch(recentActivitiesProvider);
    final gardenState = ref.watch(gardenProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final showHistoryHint = appSettings.showHistoryHint;
    final selectedGarden = gardenState.selectedGarden;
    
    return Column(
      children: [
        if (selectedGarden == null && showHistoryHint)
          HistoryHintCard(
            onGoToDashboard: () {
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            onDismiss: () => ref
                .read(appSettingsProvider.notifier)
                .setShowHistoryHint(false),
          ),
        
        // Liste des activités
        Expanded(
          child: activitiesAsync.when(
            data: (activities) {
                final filteredActivities = activities;

                if (filteredActivities.isEmpty) {
                  return _buildEmptyState(theme);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(recentActivitiesProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      // Résolution du nom du jardin si manquant
                      String? gardenName = activity.metadata?['gardenName'];
                      if (gardenName == null && activity.metadata?['gardenId'] != null) {
                        final gardenId = activity.metadata!['gardenId'];
                        final garden = gardenState.gardens.firstWhere(
                          (g) => g.id == gardenId,
                          orElse: () => gardenState.gardens.first, // Fallback safe
                        );
                        // On vérifie si garden contient vraiment l'ID (le fallback returns first element, check ID to be sure)
                        if (garden.id == gardenId) {
                           gardenName = garden.name;
                        }
                      }

                      // Si un jardin est sélectionné, on n'affiche pas le nom du jardin sur chaque carte (redondant)
                      // Sauf si l'activité vient d'un autre contexte (peu probable avec le filtre, mais safe)
                      final displayGardenName = selectedGarden == null ? gardenName : null;
                      
                      return _buildActivityCard(activity, theme, displayGardenName);
                    },
                  ),
                );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(error, theme),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(ActivityV3 activity, ThemeData theme, String? resolvedGardenName) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildActivityIcon(activity, theme),
        title: Text(
          _getLocalizedDescription(activity),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: activity.priority > 0 ? FontWeight.w600 : FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (resolvedGardenName != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('•', style: theme.textTheme.bodySmall),
                  ),
                  Flexible(
                    child: Text(
                      resolvedGardenName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            if (activity.metadata != null && activity.metadata!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  _formatFriendlyMetadata(activity.metadata!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        trailing: _buildPriorityIndicator(activity.priority, theme),
      ),
    );
  }

  Widget _buildActivityIcon(ActivityV3 activity, ThemeData theme) {
    IconData iconData;
    Color iconColor;

    switch (activity.type) {
      case 'gardenCreated':
        iconData = Icons.park;
        iconColor = Colors.green;
        break;
      case 'bedCreated':
        iconData = Icons.grid_view;
        iconColor = Colors.blue;
        break;
      case 'plantingCreated':
        iconData = Icons.eco;
        iconColor = Colors.green;
        break;
      case 'germinationConfirmed':
        iconData = Icons.eco;
        iconColor = Colors.lightGreen;
        break;
      case 'plantingHarvested':
        iconData = Icons.agriculture;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.history;
        iconColor = theme.colorScheme.primary;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  Widget _buildPriorityIndicator(int priority, ThemeData theme) {
    if (priority <= 0) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priority > 1
            ? Colors.red.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority > 1 ? l10n.activity_priority_important : l10n.activity_priority_normal,
        style: TextStyle(
          fontSize: 10,
          color: priority > 1 ? Colors.red : Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.activity_empty_title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.activity_empty_subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.activity_error_loading,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(recentActivitiesProvider.notifier).refresh();
            },
            child: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return l10n.activity_time_just_now;
    } else if (difference.inMinutes < 60) {
      return l10n.activity_time_minutes_ago(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.activity_time_hours_ago(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.activity_time_days_ago(difference.inDays);
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatFriendlyMetadata(Map<String, dynamic> metadata) {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[];

    // Add garden / bed / plant / quantity / date / maintenance / weather
    if ((metadata['gardenName']?.toString().isNotEmpty ?? false)) {
      parts.add(l10n.activity_metadata_garden(metadata['gardenName']));
    }
    if ((metadata['gardenBedName']?.toString().isNotEmpty ?? false)) {
      parts.add(l10n.activity_metadata_bed(metadata['gardenBedName']));
    }
    if ((metadata['plantName']?.toString().isNotEmpty ?? false)) {
      parts.add(l10n.activity_metadata_plant(metadata['plantName']));
    }
    if (metadata.containsKey('quantity')) {
      final q = metadata['quantity'];
      final unit = metadata['unit'] ?? '';
      if (q != null) {
        final quantityStr = '$q${unit != '' ? ' $unit' : ''}';
        parts.add(l10n.activity_metadata_quantity(quantityStr));
      }
    }
    if (metadata.containsKey('plantingDate')) {
      final raw = metadata['plantingDate']?.toString() ?? '';
      try {
        final dt = DateTime.parse(raw);
        parts.add(l10n.activity_metadata_date('${dt.day}/${dt.month}/${dt.year}'));
      } catch (_) {
        if (raw.isNotEmpty) parts.add(l10n.activity_metadata_date(raw));
      }
    }
    if ((metadata['maintenanceType']?.toString().isNotEmpty ?? false)) {
      parts.add(l10n.activity_metadata_maintenance(metadata['maintenanceType']));
    }
    if ((metadata['weatherType']?.toString().isNotEmpty ?? false)) {
      parts.add(l10n.activity_metadata_weather(metadata['weatherType']));
    }

    // If no friendly metadata found, return empty string (so nothing is rendered)
    if (parts.isEmpty) return '';

    return parts.join('\n');
  }

  String _getLocalizedDescription(ActivityV3 activity) {
    final l10n = AppLocalizations.of(context)!;
    final metadata = activity.metadata ?? {};

    switch (activity.type) {
      case 'gardenCreated':
        // 'Jardin "Potager" créé'
        final name = metadata['gardenName'] ?? '???';
        return l10n.activity_desc_garden_created(name);

      case 'gardenDeleted':
        // 'Jardin "Potager" supprimé'
        final name = metadata['gardenName'] ?? '???';
        return l10n.activity_desc_garden_deleted(name);

      case 'gardenUpdated':
        // 'Jardin "Potager" mis à jour'
        final name = metadata['gardenName'] ?? '???';
        return l10n.activity_desc_garden_updated(name);

      case 'gardenBedCreated':
      case 'bedCreated': // Legacy
        // 'Parcelle "Carré A" créée'
        final name = metadata['gardenBedName'] ?? '???';
        return l10n.activity_desc_bed_created(name);

      case 'gardenBedDeleted':
      case 'bedDeleted': // Legacy
        // 'Parcelle "Carré A" supprimée'
        final name = metadata['gardenBedName'] ?? '???';
        return l10n.activity_desc_bed_deleted(name);

      case 'gardenBedUpdated':
        // 'Parcelle "Carré A" mise à jour'
        final name = metadata['gardenBedName'] ?? '???';
        return l10n.activity_desc_bed_updated(name);

      case 'plantingCreated':
      case 'plantingAdded': // Legacy support
        // 'Plantation de "Tomate" ajoutée'
        final name = metadata['plantName'] ?? '???';
        return l10n.activity_desc_planting_created(name);

      case 'plantingDeleted':
        // 'Plantation de "Tomate" supprimée'
        final name = metadata['plantName'] ?? '???';
        return l10n.activity_desc_planting_deleted(name);

      case 'plantingUpdated':
        // 'Plantation de "Tomate" mise à jour'
        final name = metadata['plantName'] ?? '???';
        return l10n.activity_desc_planting_updated(name);

      case 'germinationConfirmed':
        // 'Germination de "Tomate" confirmée'
        final name = metadata['plantName'] ?? '???';
        return l10n.activity_desc_germination(name);

      case 'plantingHarvested':
      case 'harvestCompleted': // Compatibility with enum
        // 'Récolte de "Tomate" enregistrée'
        final name = metadata['plantName'] ?? '???';
        return l10n.activity_desc_harvest(name);

      case 'maintenanceCompleted':
        // 'Maintenance : Arrosage'
        final type = metadata['maintenanceType'] ?? '???';
        return l10n.activity_desc_maintenance(type);

      default:
        // Pour les types inconnus ou non mappés, on garde la description stockée en bdd.
        return activity.description;
    }
  }
}
